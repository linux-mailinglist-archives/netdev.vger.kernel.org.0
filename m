Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B974963AB
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 18:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349649AbiAURVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 12:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243895AbiAURU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 12:20:58 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA63C06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 09:20:58 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id v3so3409362pgc.1
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 09:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=e26iCi8kpe7ZocWrGUl1EMgFeSj6fFrBfG07UEc81X0=;
        b=Wo32pqR4H38ykoFuUIhLDuE8qrnUWUZznv1eKXDHKj9wcBCOrmbrRv2rXiYervDs3B
         MokWVmV6Jxk9/BNRKhSIlPN71WqZ2xGw2FyPokiSZoXnOqO5cY9Eq8Fh+0C6BmF0BFwX
         hzYYcFcLd9kfLGPbosI77dJ1mQmRFgPZNNri+jtFJ7Ewr7WoRyqEaHYwJqPicguzaXNG
         wyT5u5bZ6wbIFhN0J54khGA+Cds813uhq7i5WXs3GBh8VE2b7DXS2Nz3GamCGP1v+Q6Q
         jrBL7Q6rDRdtLqBlUCpaPiXgpty1KcpziI2g7UQis6onO5X3+9SQzYfuuC65xW0u6y4S
         1ixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=e26iCi8kpe7ZocWrGUl1EMgFeSj6fFrBfG07UEc81X0=;
        b=1M+GsyoSgvYYqWXIvRck0VOM1w9u/H7T5cIQN282vl5JHnOpk9TadwHF3VFgYDdq8S
         qAPUBE0i1z1hzUAgIPkMoZ/PcP1oz6PMAL8tjzAJKQX9Klf2sCILfrHqgAnsOBbBhdjQ
         qpAwV9LRhqy0i72W+SCtLGr7vP0P5+G8/Q2s3V2tqwkSvlaAOSlCBwQKaqV6ysAgSNo0
         SpcoiMTux79zqzlt6gCeG+CpHlPMYDJm4CU3h3oBw/VLGf5NGwxBqhOt3lR1bw2PrcL/
         WHYUhiRz4f/WSfbFYaKipp5+PsUCD9wgtNDDHfggtXOnPZ/l1utCtVnWEf7e0l6swL8A
         olfw==
X-Gm-Message-State: AOAM533lqKDiNFMhdFym4aCzx+QWZWPQRZFQGzW5d6bOYZLa/eY4v1uw
        ddKxZyLbdSBYBntY5dqG3fxx6bHhxZYHfO42oDCa6IbnFzN78A==
X-Google-Smtp-Source: ABdhPJwCqMzgaoZdqLNYfqxMIFjcCrI0TwpT5TDsOuyV8lScLMdiMmBQpEdvsxqzjjxASW6gjBRYgH6vdRHm3aRlkEE=
X-Received: by 2002:a05:6a00:1308:b0:4c5:e231:afd4 with SMTP id
 j8-20020a056a00130800b004c5e231afd4mr4768195pfu.34.1642785657217; Fri, 21 Jan
 2022 09:20:57 -0800 (PST)
MIME-Version: 1.0
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 21 Jan 2022 09:20:45 -0800
Message-ID: <CAJ+vNU1Grqy0qkqz3NiSMwDT=OX3zOpmtXyH78Fq2+mOsAFj4w@mail.gmail.com>
Subject: best way to disable ANEG and force ethernet link?
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I'm troubleshooting a network issue and am looking for the best way to
force link speed/duplex without using auto-negotiation.

What is the best way to do this in Linux? Currently from a userspace
perspective I have only been able to using 'ifconfig' to bring the
link up, then 'mii-tool -F 100baseTx-FD <dev>' to force it. The
ethtool methods do not work on my MAC/PHY (not clear what ethtool
support is needed for that on a driver level). For testing purposes I
would like to avoid the link coming up at 1000mbps in the first place
and force it to 100mbps.

Before hacking the heck out of the phy layer in the kernel I was
hoping for some advice for the best place to do this.

In case it matters I have two boards that I would like to do this on:
an IMX8MM with FEC MAC and a CN803X with an RGMII (thunderx) vnic MAC.
Both have a GPY111 (Intel Xway) PHY.

Best regards,

Tim
