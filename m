Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C173534DF
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 19:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbhDCRPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 13:15:21 -0400
Received: from mout.gmx.net ([212.227.15.15]:42917 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236819AbhDCRPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Apr 2021 13:15:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1617470100;
        bh=JrV89Lo/xurYMRPkWpl1O0IqJxEWTwx1p8wZRHot3Tk=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=cOmkdq+7mvDKGLg+zGlgtPtlMu8zgGX/jZSScRKGuxkD9QIyYuZ+el3+qXXK3XSBl
         CETSiUc7XzYi3sVtgYfp0fMTY7htPg3OD4ug7NlKTMDNnkhhYlHlu6YRQb4M38ZlJr
         1PL9uFQOeAs0V4JIexz30y81hG9F70sMfyi2Rf5U=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.55] ([95.91.192.147]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MatVh-1m0Qmt2evj-00cNrs; Sat, 03
 Apr 2021 19:15:00 +0200
Subject: Re: [PATCH net-next v1 2/9] net: dsa: tag_ar9331: detect IGMP and MLD
 packets
To:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-3-o.rempel@pengutronix.de> <YGiAjngOfDVWz/D7@lunn.ch>
From:   Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <f4856601-4219-09c7-2933-2161afd03abe@rempel-privat.de>
Date:   Sat, 3 Apr 2021 19:14:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YGiAjngOfDVWz/D7@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Gtx01aF/6gl4/c7myW4dDa77MMX4E5f7rZ2FRxZX8CruSrEy5ZP
 ldPhJ0dUlDXXSMiJmc3cn7eu1lAxPgy6rOVuCc5jjJnyqEn8b91kNJuP/a6F8n7cNf606CH
 qynwN1zRHnxJuaTyqzVIq30YCvcSBT5B17vdepDD9wtF/tQrOWHNxO5F4+9lAgKxxOVTTLN
 WV1M0Zrcgq856HWp4zaoQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dvXwZOyeFAw=:4WxPuj6fRWDf420c12wRU+
 lf9oQsAXeYf+0nhIv/xMBe2feFjxWgToHawWgdcqj6P74EsnTvT8WMBU/s1+SWwHUdGy8sZ67
 5KU5x7WBxJDGiZDkXjZfcPPvdntOwjapLja+FVQmAp2nOh2VYV6XBuB0dW5s3AvqkQciIbLu2
 pQfw/mxAro6nQJGv3a2NuObrvh5s14bRnuSNnjPyQFe5NEcsLhGhW/mOhCIykehjDvxG91OzJ
 zradMsx0MA08SYBOKdY++rDrUAecbUuwc/RJ9v995/CaAPFmn36Pp2eQbCmiIVqswi5hTTuAO
 5sBuTZPOrbI8eJmR+wiooDudnVfhMRZ8G0x3Dx+V/v+2Qdkf++UViyY+Gop18zWl9G2yevxlr
 UqK1+daEZfnb8oyj7oQ8dtpaMAxmQ28qyOd+aE+ndh45eIg6KdNd/oKNm/mVIzyF3DzB8Ljjh
 3clKiN74qvwCvYg32IhScbd/vK7xsyEz2WLsMsrpm5mxpPfA4fgF9id1rf+kIsmN9u9YggiOs
 2cuWJOpFQzkluXkY3b8HyNX+GcEfQ5hElYuKBSeSTfeUsco8lksMn95hqorYKyvjmGUXX2AKU
 RBi6jm8T6SPvi445Au+tvUUObggj0JOKRvyb9Gr8VIdL5SousdH/C2uIh/bJsqhcx5jmJFNXx
 2Pzj8P5811I1FpZTG1aX3LuHVaVOgGZRwBzxfE3/6TToGefbv5yLkwUspod75kfe0b5PWa0wL
 gR5cwjizmg1XupPR/OH0tXa+4g9QfxtYhKwy2HmLYiFHRO4RaPZJ516vHIKiuWW5PdN2Li14Z
 Qk0I0w+JF3EaPVo6ROV2sLut7OHsz2afahhVTsNJy56HKh4xKV+asqDUsDOoJjraBSrM35ile
 jAUSFdrL7ArY59reJNAyV2xNBt6SMlsWm9rXWVROy8D4nsTLEEd6+jjHN1dbawbpf3XcNzwu6
 JLOoD+KStsxDY5wXo2Ip0bHnqA7zsGbBFfWZxMyUYKWGede91zzNAI40R+R7HoI99UGSkfBxk
 ccfwHQ9XtUAkgzu6TjuyU2trVucYfYWv9d+7QPabTHta2eoKNqn5vTFiqOD7JQnmZc+89XklQ
 364bpXqnkovgAo1U+Ab7QkZKZ3vcqntsNl2LXSYvdhrBoJ2iyCyrF5gHCFTK5+EAVvd9HdWci
 DXT44Lq8Ur4N/5MD4XSgql3GoMWQHIkgdoVbnfrMcMetvwLYpQ1UINQhTgGAbo7RLoMrRxGlt
 dYQQwobR4eJJ6PtU/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 03.04.21 um 16:49 schrieb Andrew Lunn:
>> @@ -31,6 +96,13 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_buf=
f *skb,
>>  	__le16 *phdr;
>>  	u16 hdr;
>>
>> +	if (dp->stp_state =3D=3D BR_STATE_BLOCKING) {
>> +		/* TODO: should we reflect it in the stats? */
>> +		netdev_warn_once(dev, "%s:%i dropping blocking packet\n",
>> +				 __func__, __LINE__);
>> +		return NULL;
>> +	}
>> +
>>  	phdr =3D skb_push(skb, AR9331_HDR_LEN);
>>
>>  	hdr =3D FIELD_PREP(AR9331_HDR_VERSION_MASK, AR9331_HDR_VERSION);
>
> Hi Oleksij
>
> This change does not seem to fit with what this patch is doing.

done

> I also think it is wrong. You still need BPDU to pass through a
> blocked port, otherwise spanning tree protocol will be unstable.

We need a better filter, otherwise, in case of software based STP, we are =
leaking packages on
blocked port. For example DHCP do trigger lots of spam in the kernel log.

I'll drop STP patch for now, it will be better to make a generic soft STP =
for all switches without
HW offloading. For example ksz9477 is doing SW based STP in similar way.

=2D-
Regards,
Oleksij
