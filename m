Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4FF29829B
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 17:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1417279AbgJYQv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 12:51:28 -0400
Received: from relay1.mymailcheap.com ([144.217.248.102]:60072 "EHLO
        relay1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1417274AbgJYQv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 12:51:28 -0400
X-Greylist: delayed 8631 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Oct 2020 12:51:27 EDT
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay1.mymailcheap.com (Postfix) with ESMTPS id 937B33F157;
        Sun, 25 Oct 2020 16:51:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 6FEF92A35F;
        Sun, 25 Oct 2020 12:51:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1603644686;
        bh=FoSy3t/kqmgQC10lMSeyKa4t+0LPTjYELCvA/q1mA2o=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=TP4oMSK3ey0LmvXRHT3xniPaw1slaNSi7tfUJlbQO/ohd3Som2GctRSWTa3BnIXUZ
         6uGil/3mKVqeQOwhCWk52aoTvXcL8YyB4SYnB4Gt36J+4Qf/fMBWt8UHMaDmS7qbnc
         q7xs5fBfG88AhxrlmcGRnabfDUbBB+8Tr1dE1FP8=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iUw6f3I8ZitG; Sun, 25 Oct 2020 12:51:24 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Sun, 25 Oct 2020 12:51:24 -0400 (EDT)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 38A2E400C5;
        Sun, 25 Oct 2020 16:51:23 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="ME4pA23y";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [172.19.0.1] (unknown [64.225.114.122])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 57B93400DA;
        Sun, 25 Oct 2020 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1603644677; bh=FoSy3t/kqmgQC10lMSeyKa4t+0LPTjYELCvA/q1mA2o=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=ME4pA23yrHW17q83vF3CgT1qui+uGUMm1GO0ysaPO/eX70g6RwckhnaV3kfR0UtDu
         a4ng0NJX4Q1D5/JchKe/RnW8NQys5p0E4gITgqfuk4Ftc0DCImMjvkNNYzlBvxmu2T
         GuoIWbiOk1ArA1fM5Slu70Wvpe9NDRQ92lvlbYhc=
Date:   Mon, 26 Oct 2020 00:51:05 +0800
User-Agent: K-9 Mail for Android
In-Reply-To: <20201025143608.GD792004@lunn.ch>
References: <20201025085556.2861021-1-icenowy@aosc.io> <20201025141825.GB792004@lunn.ch> <77AAA8B8-2918-4646-BE47-910DDDE38371@aosc.io> <20201025143608.GD792004@lunn.ch>
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
Message-ID: <F5D81295-B4CD-4B80-846A-39503B70E765@aosc.io>
X-Rspamd-Queue-Id: 38A2E400C5
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
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[aosc.io:+];
         RCPT_COUNT_TWELVE(0.00)[12];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         FREEMAIL_CC(0.00)[gmail.com,armlinux.org.uk,davemloft.net,kernel.org,realtek.com,siol.net,vger.kernel.org,googlegroups.com];
         SUSPICIOUS_RECIPS(1.50)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



=E4=BA=8E 2020=E5=B9=B410=E6=9C=8825=E6=97=A5 GMT+08:00 =E4=B8=8B=E5=8D=88=
10:36:08, Andrew Lunn <andrew@lunn=2Ech> =E5=86=99=E5=88=B0:
>On Sun, Oct 25, 2020 at 10:27:05PM +0800, Icenowy Zheng wrote:
>>=20
>>=20
>> =E4=BA=8E 2020=E5=B9=B410=E6=9C=8825=E6=97=A5 GMT+08:00 =E4=B8=8B=E5=8D=
=8810:18:25, Andrew Lunn <andrew@lunn=2Ech> =E5=86=99=E5=88=B0:
>> >On Sun, Oct 25, 2020 at 04:55:56PM +0800, Icenowy Zheng wrote:
>> >> Currently there are many boards that just set "rgmii" as phy-mode
>in
>> >the
>> >> device tree, and leave the hardware [TR]XDLY pins to set PHY delay
>> >mode=2E
>> >>=20
>> >> In order to keep old device tree working, omit setting delay for
>just
>> >> "RGMII" without any internal delay suffix, otherwise many devices
>are
>> >> broken=2E
>> >
>> >Hi Icenowy
>> >
>> >We have been here before with the Atheros PHY=2E It did not correctly
>> >implement one of the delay modes, until somebody really did need
>that
>> >mode=2E So the driver was fixed=2E And we then found a number of devic=
e
>> >trees were also buggy=2E It was painful for a while, but all the
>device
>> >trees got fixed=2E
>>=20
>> 1=2E As the PHY chip has hardware configuration for configuring delays,
>> we should at least have a mode that respects what's set on the
>hardware=2E
>
>Yes, that is PHY_INTERFACE_MODE_NA=2E In DT, set the phy-mode to ""=2E Or
>for most MAC drivers, don't list a phy-mode at all=2E

However, we still need to tell the MAC it's RGMII mode that is in use, not
MII/RMII/*MII=2E So the phy-mode still needs to be something that
contains rgmii=2E

>
>> 2=2E As I know, at least Fedora ships a device tree with their
>bootloader, and
>> the DT will not be updated with kernel=2E
>
>I would check that=2E Debian does the exact opposite, the last time i
>looked=2E It always uses the DT that come with the kernel because it
>understands DT can have bugs, like all software=2E
>
>      Andrew
