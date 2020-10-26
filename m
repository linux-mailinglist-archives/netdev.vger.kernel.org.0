Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8557298791
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 08:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770974AbgJZHpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 03:45:00 -0400
Received: from relay5.mymailcheap.com ([159.100.241.64]:43995 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbgJZHo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 03:44:59 -0400
X-Greylist: delayed 136414 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 03:44:56 EDT
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.157])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 34BAD20100;
        Mon, 26 Oct 2020 07:44:55 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay3.mymailcheap.com (Postfix) with ESMTPS id E33853F1CC;
        Mon, 26 Oct 2020 08:44:51 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id BFF522A7CC;
        Mon, 26 Oct 2020 08:44:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1603698291;
        bh=9G0M+2nSGv2z1NrQJhhMOgoHf+bWPz85zNS3hVz/5Kc=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=X+6mvvIX33ljLmuPwtA95f8rDt8EM8vFvNRVlU5LD5eTPW6drB1kudLsK2JIUyLck
         lO3sTNXa/8G1ZcchIfK5APQkA0/Znevu/YOL3AAThGzXvCAL0FcDFKtgarQc2liMNz
         SZIB2p8QUsgyOCLWJq1wuW+sOHYT5+paenv2Wmnc=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hIxQ6y1u_tFv; Mon, 26 Oct 2020 08:44:50 +0100 (CET)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Mon, 26 Oct 2020 08:44:50 +0100 (CET)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 058B641A19;
        Mon, 26 Oct 2020 07:44:49 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="j71/CdA/";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [172.19.0.1] (unknown [64.225.114.122])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 0E02841A19;
        Mon, 26 Oct 2020 07:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1603698281; bh=9G0M+2nSGv2z1NrQJhhMOgoHf+bWPz85zNS3hVz/5Kc=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=j71/CdA/NxjFbGa2DA2JZrKUJvH38/tX4GzrOFUo0JOyIpiUncF6VqaMDRREJ2Fh1
         kSFgXA/kA6/ghU0516vj9sGyV7KFbgE4CIyQlztaYwDvT/t7LqqQH5YIwbRIHxuKrp
         RPlhfTM0LRYajovbs0iZUDkuPc+A1SEgR7Gn7zNw=
Date:   Mon, 26 Oct 2020 15:44:32 +0800
User-Agent: K-9 Mail for Android
In-Reply-To: <20201025172848.GI792004@lunn.ch>
References: <20201025085556.2861021-1-icenowy@aosc.io> <20201025141825.GB792004@lunn.ch> <77AAA8B8-2918-4646-BE47-910DDDE38371@aosc.io> <20201025143608.GD792004@lunn.ch> <F5D81295-B4CD-4B80-846A-39503B70E765@aosc.io> <20201025172848.GI792004@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [linux-sunxi] Re: [PATCH] net: phy: realtek: omit setting PHY-side delay when "rgmii" specified
To:     andrew@lunn.ch, Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sunxi@googlegroups.com
From:   Icenowy Zheng <icenowy@aosc.io>
Message-ID: <C3279C11-EE7F-49FA-9BB3-ACA797B7B690@aosc.io>
X-Rspamd-Queue-Id: 058B641A19
X-Spamd-Result: default: False [1.40 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.00)[aosc.io];
         R_SPF_SOFTFAIL(0.00)[~all];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[aosc.io:+];
         RCPT_COUNT_TWELVE(0.00)[12];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         FREEMAIL_CC(0.00)[gmail.com,armlinux.org.uk,davemloft.net,kernel.org,realtek.com,siol.net,vger.kernel.org,googlegroups.com];
         SUSPICIOUS_RECIPS(1.50)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



=E4=BA=8E 2020=E5=B9=B410=E6=9C=8826=E6=97=A5 GMT+08:00 =E4=B8=8A=E5=8D=88=
1:28:48, Andrew Lunn <andrew@lunn=2Ech> =E5=86=99=E5=88=B0:
>> >> 1=2E As the PHY chip has hardware configuration for configuring
>delays,
>> >> we should at least have a mode that respects what's set on the
>> >hardware=2E
>> >
>> >Yes, that is PHY_INTERFACE_MODE_NA=2E In DT, set the phy-mode to ""=2E
>Or
>> >for most MAC drivers, don't list a phy-mode at all=2E

By referring to linux/phy=2Eh, NA means not applicable=2E This surely
do not apply when RGMII is really in use=2E

>>=20
>> However, we still need to tell the MAC it's RGMII mode that is in
>use, not
>> MII/RMII/*MII=2E So the phy-mode still needs to be something that
>> contains rgmii=2E
>
>So for this MAC driver, you are going to have to fix the device tree=2E
>And for the short turn, maybe implement the workaround discussed in
>the other thread=2E

I think no document declares RGMII must have all internal delays
of the PHY explicitly disabled=2E It just says RGMII=2E

I think the situation that RGMII is in use and PHY has the right to
decide whether to add delay or not surely matches "rgmii", and
to explicitly disable internal delays we need some other thing
like "rgmii-noid"=2E

>
>    Andrew
