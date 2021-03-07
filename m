Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0441A3304B7
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 21:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhCGUzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 15:55:40 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.23]:23914 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbhCGUzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 15:55:09 -0500
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Mar 2021 15:55:09 EST
ARC-Seal: i=1; a=rsa-sha256; t=1615150325; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=khrypSP14nNp6tPD10zP94LbJfpItXaO3Ns0sd74Vn+xjK444+CUUMVLjCBtoZohlh
    BALzEsY42jbUDIyxMkQiupDdhwgeQQUHh9WUmc0iKPtKDLy5ewTUyoSHY56QwZJNp1Yc
    bFn/zYxo+4lN8BDLo0Z8EfhWd8MP4erlhoVkXdnseMlyLEkFINzYwyzyVJm8BVaYJ1Pp
    XOJGi2+0l2r92irnoPd7M5CiVikw3t2kpjT4uYBalWdfqW51E86M+Vd0GzHH4jakkWpU
    HT88Ix9DR2nNmYoGXeq6KTcOOm61qdSXgIhP/f3lHCD//HplR+GJR3d1q85w/FpD2x2n
    xKew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1615150325;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=3F5EyDIYfUKUKfWaxDBmit57Y4Zjlf0XdBuAIMMKit0=;
    b=lE9IAGg6c2Z7O3+Qc+Us0Pk/qN6e3uRnJHaiO5tWr2auD02QxNJgILAwJ6WvNjPSuR
    zZgq6AsH2Cdqvv4u58oMYBchh0dcfIgskqDGGUfi5oBtAOT9h5aa21NMZ7t9mL3FCMcN
    +lNWiHREtr7A/XHc74/8HwQ2hOBoK1VBwvB0SRrXNE8wpum4zi71IL6E3itVJEL3pQGm
    rEAWLpf0lYbBt9Gu4W7Wmyxignq54EoauDwFGQoqnmRRZ3qbBmN0f0MjcJU7HBkl5pEh
    e8NGlSzRq1ZRyqd1DqoTZrNckbB6in2FGvfD2W8UwKTXGgkSUMIZ+HrOS12F/L3LlMR1
    C6gg==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1615150325;
    s=strato-dkim-0002; d=fami-braun.de;
    h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=3F5EyDIYfUKUKfWaxDBmit57Y4Zjlf0XdBuAIMMKit0=;
    b=tC3ASbn06Ut+dL+Ud7eLtwSuUU7+KR96DOxlws5OisE4LUdurkaciODZ22VEul9wGh
    oGQs6dYB3qr0XxZzHUFgUsUsDe+g/PxTNU1+B1Y1B7RtwoIpJDYo/iu6hHlt393vw9Wo
    65gjxgQMCPIwHS4lOedrTwhNYYe7I5gn+JktfRQ+EYlW0WvfDR6ljqxiwfYb41QbYjVd
    HNEV+GM08+m/2ZY6VakikFVFJGzizp8rmkp8fZEzhIQGDbrfES0C2fKsNuktpcxlZ8qK
    lLA5qQ5Vfix2gFz6p3EMr1m/S06HUpEHqps6U690kSrXHWfd5MIuLTr2CY9Ba8AN3nQS
    Ck2Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpdQd5bmdzGXu9QVR3m+Q="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
    by smtp.strato.de (RZmta 47.20.3 DYNA|AUTH)
    with ESMTPSA id 909468x27Kq4Auw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 7 Mar 2021 21:52:04 +0100 (CET)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id 5603D154101;
        Sun,  7 Mar 2021 21:52:04 +0100 (CET)
Received: from s0lc3mBNFZJwXWzwO4eTytZUC7fgj0ZWfMLIWRPFpptG4QL4lDcD/Q==
 (eGLGFaDD1yktrnGMRCs1205bdc4Oyqmc)
 by webmail.fami-braun.de
 with HTTP (HTTP/2.0 POST); Sun, 07 Mar 2021 21:51:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 07 Mar 2021 21:51:59 +0100
From:   michael-dev <michael-dev@fami-braun.de>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] gianfar: fix jumbo packets+napi+rx overrun crash
In-Reply-To: <DB8PR04MB67643BBB399B02ACBA48C06F96979@DB8PR04MB6764.eurprd04.prod.outlook.com>
References: <20210304031238.28880-1-michael-dev@fami-braun.de>
 <DB8PR04MB67643BBB399B02ACBA48C06F96979@DB8PR04MB6764.eurprd04.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <376d60c0bc99cd5933273e117e9d6fdc@fami-braun.de>
X-Sender: michael-dev@fami-braun.de
X-Virus-Scanned: clamav-milter 0.102.4 at gate
X-Virus-Status: Clean
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on gate.zuhause.all
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

sorry I missed the mail.

Am 04.03.2021 11:05, schrieb Claudiu Manoil:
> Could you help provide some context, e.g.:
> On what board/soc were you able to trigger this issue?

I have an OpenWRT running on P1020WLAN boards and have IPsec for some 
gretap tunnel configured.
I run iperf3 -s on the AP and iperf3 -c --udp -b 1000M on some server 
and then the AP reliably crashes.
It also crashed sometimes during normal operations when doing some fast 
download over the IPsec tunnel, but that was hard to reproduce.

> How often does the overrun occur?
Reliably within seconds with the above test.

> What's the use case? Is the issue triggered with smaller packets than 
> 9600B?
It cannot be triggered with 1500 Byte  MTU packets as these have FIRST 
and LAST set in one.
I use jumbo frames to speed up ipsec.

> Increasing the Rx ring size does significantly reduce ring overruns?

I did not test this.

Regards,
Michael Braun
