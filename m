Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E4B3304AB
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 21:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhCGUrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 15:47:10 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:16126 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbhCGUrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 15:47:05 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615149840; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=JiBzrTJpjsHhrH8onkShmkzxEav/9iB84TP+Ess+yaPBXFsBYvnLlPjnKD+txc0NhE
    Iajz7/+OS3eU4JurQl6UYyrRzg7c3PSoh3r34eFy/y6ROuB5UW8viuJTgM5BGBK2L7OP
    qXPxXr82qRJXYOiP42PeTmlSU075Aqcq9+VAU19zrnx7FveEJFi9vg4u85kDCUy2RzsT
    5eQgkQ3GXm3VyLelJtdGGSul4JioHWGQaSWiVBpJ/ZFW8+ZeZM2RhrgOYZapqCu9Oc0M
    hsHtv8Rj8eOHdS2z7yHMypIzfqiK2mIKSdVUkQ+NM26UeLBXBpm5gxGO2Xmj5QLctyzt
    Es0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1615149840;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=gxgYF0tErZiumxUGe/6mbbvxe1u5aMZ5GP4opM3Uock=;
    b=d2ATTTQSjDEx+MaxpG3z4ygrD+T3pnioC7IFk9Vedgg+PBMtTd9+SlfdDCbYX7kWSO
    OGayArLhvnR3r5I/vGh+fi4IjA8EksqUGulVk/BkVcZTlTsX/6A5LsINTq5yZM3E64UM
    rR4aaXmY54am/rgrbkBWyG+H1X5oVEXfeS7LyZTgYOvi7I/iIy6BxUhnIZJHH78KTQVo
    p83GXgdQbu3Ww89DtdDDpbuuQ4Q5tsMgcL4bi0Tj7hQn/AOYLGwVQAjc7/stAh5ejA5E
    h9Ua6K0X/G4zx0aZQvHgnBnefcZMohuWVIQ9xoH+FV6sjgVwsoepiUF/2Im0luswCmOL
    l9/A==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1615149840;
    s=strato-dkim-0002; d=fami-braun.de;
    h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=gxgYF0tErZiumxUGe/6mbbvxe1u5aMZ5GP4opM3Uock=;
    b=W+PLjvoFlZiG7z8jeBrD97ajyZt06SDBGgsGa0IpR6GWQuCEWsM8MlDPkfHdhVJsBp
    L1NlkZfAi1ceavbR5XRvaGYfHdE0eycEp+m7mq82veu9gt2fWzeituSS8ky9wIlJZ2iG
    9Yq0NVUxL4xcA1TDkHEHNEB2RPstTR47Xjnzv9rkLdobNpvNM/QrqJr/k2B+XuRWiTX3
    O7UhAg1wqBm/b+wyQIS01ahSVfczFAOnr2oc0pY+R+Jq0eXW+LybNZ7NnTmhoRW8W05S
    Bpojtm5zJ2nDIuHCgs4p2RZmjYLBghSvCy2k777gtJJLS2wvRTs2ZPFsSobCLegPkaeJ
    Lgqw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpdQd5bmdzGXu9QVR3m+Q="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
    by smtp.strato.de (RZmta 47.20.3 DYNA|AUTH)
    with ESMTPSA id 909468x27KhxAuI
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 7 Mar 2021 21:43:59 +0100 (CET)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id 9069A15411B;
        Sun,  7 Mar 2021 21:43:59 +0100 (CET)
Received: from uRE6X5oIQVYdjkawJ95/LHp/MFdT6gCtjnvkXwtko7lrqdodek7Jsg==
 (+uUZcCv+JLlu0HaAbefDTzlMQ/6pmr5m)
 by webmail.fami-braun.de
 with HTTP (HTTP/2.0 POST); Sun, 07 Mar 2021 21:43:45 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 07 Mar 2021 21:43:45 +0100
From:   michael-dev <michael-dev@fami-braun.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCHv2] gianfar: fix jumbo packets+napi+rx overrun crash
In-Reply-To: <20210304201725.unm27y2hpezgsqm3@skbuf>
References: <20210304195252.16360-1-michael-dev@fami-braun.de>
 <20210304201725.unm27y2hpezgsqm3@skbuf>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <0e84c2fb0adbfc2c61af78e3a5f4deb7@fami-braun.de>
X-Sender: michael-dev@fami-braun.de
X-Virus-Scanned: clamav-milter 0.102.4 at gate
X-Virus-Status: Clean
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on gate.zuhause.all
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 04.03.2021 21:17, schrieb Vladimir Oltean:
> Just for my understanding, do you have a reproducer for the issue?
> I notice you haven't answered Claudiu's questions posted on v1.
> On LS1021A I cannot trigger this apparent hardware issue even if I 
> force
> RX overruns (by reducing the ring size). Judging from the "NIP" 
> register
> from your stack trace, this is a PowerPC device, which one is it?

This is on P1020WLAN (AP) devices and it happens reproducably when I use 
ipsec + iperf3 --udp -b 1000M on some other server targetting the AP.
Yes this is PPC.

Regards,
Michael

