Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6DA3D96FA
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 22:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhG1Uok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 16:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhG1Uoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 16:44:39 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93E7C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 13:44:37 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 19-20020a9d08930000b02904b98d90c82cso3468620otf.5
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 13:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=huvQqu0tQa/EmLSdm3rR3GIVUrkdYLkNVY8SQUUeLP8=;
        b=nI7t90AO1XemcHOULKUuCXdCmEorHkzEEybVMjX3gKcBCfaqmqhqUviPIKICOUB2az
         2f80BEXI7gPMFIFn+l2B8/+bIen9o5BYaySv6kEnd9LkVyT4Q4zBhzi5UdtfeiGxr1+h
         TIgj+/95bkn7TG73hbZIjVT54PrJkrehvHOCS1cWR0DF5qn4ahnHRPVdKY+Lr8F1APdr
         lph4jFJZIFegvBlZTJGg3t0ik1DOP8Zski6Tk+mDkzgZ5xvDkGYmfLFxLhX4A4Qyz9Gk
         hWGhGbOSKDKyyMEQWixoEBB4OosQm7ArpMUPP78c6chcDZMyG3xZCdgZmYrK29YYSxeB
         HkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=huvQqu0tQa/EmLSdm3rR3GIVUrkdYLkNVY8SQUUeLP8=;
        b=uTtFJ7sBk85mq6+9w53CGOikps6VhSlRuZiTxf3kNIiPeLLyC23A2fLN8y3RrRxEpk
         mMxZv7X0jbIyWJnClnAiufLZWTDtP9ZtB7xiAyGoxDUKMUWEMMy3SaGdMvKBSmokglwv
         IWG/B6gqZAfhwxFYb9aTTVzMBKEmp1AEVUlNMjCxWzMXYeFxqEcD1SqgMOUUTxqDFYZP
         E7vmegeLHjOijjp5BU1diKZwlN/RxdGdUhLXd/6cOeHLuKHofEXa4aJeeMvM+GM1caoC
         eTW15pytH54RE8/luG7lhIweUB8AXnnXR6WS6L+4Q0iNhMaFOhHOK2nbK6+FKX1YC7Ez
         nW6A==
X-Gm-Message-State: AOAM531GG8zOzkhkgdhyVSsdlm3ZtcFALkY+MwSi7ujA8VNFjxFcieX8
        6JD8Cz19jX+1ocGAdp0pZW8kLfbUfBJDuJIiscPZNX9hRMwv
X-Google-Smtp-Source: ABdhPJwBdyygAnmpWMKx8hBKYpS89EzBskDNu/yG7E6tNPLJ/R3FxdTig64HqiSwuzzm1ExfBqSp+hQZ7iBYXq3pA04=
X-Received: by 2002:a9d:1ea5:: with SMTP id n34mr1260141otn.340.1627505076156;
 Wed, 28 Jul 2021 13:44:36 -0700 (PDT)
MIME-Version: 1.0
From:   George McCollister <george.mccollister@gmail.com>
Date:   Wed, 28 Jul 2021 15:44:24 -0500
Message-ID: <CAFSKS=Pv4qjfikHcvyycneAkQWTXQkKS_0oEVQ3JyE5UL6H=MQ@mail.gmail.com>
Subject: net: dsa: mv88e6xxx: no multicasts rx'd after enabling hw time stamping
To:     netdev <netdev@vger.kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If I do the following on one of my mv88e6390 switch ports I stop
receiving multicast frames.
hwstamp_ctl -i lan0 -t 1 -r 12

Has anyone seen anything like this or have any ideas what might be
going on? Does anyone have PTP working on the mv88e6390?

I tried this but it doesn't help:
ip maddr add 01:xx:xx:xx:xx:xx dev lan0

I've tried sending 01:1B:19:00:00:00, 01:80:C2:00:00:0E as well as
other random ll multicast addresses. Nothing gets through once
hardware timestamping is switched on. The switch counters indicate
they're making it into the outward facing switch port but are not
being sent out the CPU facing switch port. I ran into this while
trying to get ptp4l to work.

I've tried kernels from 5.4 to net-next HEAD and I get the same results.

CONFIG_NET_DSA_MV88E6XXX_PTP is set to y in the kernel config.

Regards,
George McCollister
