Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA825232F99
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 11:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgG3Jgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 05:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgG3Jgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 05:36:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCFEC061794
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 02:36:39 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596101798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R6FS7HPmbQYSiUs6/3NL54Zse68JjC1V20pGkjyjbdg=;
        b=IqZbedrcnA0fSMItctXl1mRF0w1++TE4E6At73RZTOnz+4DD2Mdoq3hIYkTCFGcdZgCh5g
        cy5GIwojJ3KoiBI4htXQBPSrDir+uI7XAvh6nRoCembo5TZc2YZuuV9OikiDzrbVezHbMQ
        ElDNXUfG56q7SdUThDF0UAH7wlysc8gscICSo2ws/XZsjww0nbA4YV77YwODT3LCs+8m8/
        dUvKURNHExqNvOletlz1qWU8M3uKXNL1pML1IyjiF/oHl1Y1gk7THs3FyRt/OnE2LH5rsy
        63I01U4pjcuEL3ZKcv4LoZjWvCpc9fS4yWQhERdxrsVbY5WAbbqX8G32H/Lzig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596101798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R6FS7HPmbQYSiUs6/3NL54Zse68JjC1V20pGkjyjbdg=;
        b=KT0QWs4mSzXmm0r7QnLUoHvOsIz7YJtdI6s6l7wAVyI8g0VpGeDUCCTvcribklLBKW1mpQ
        Qe6l5gWmCg6XNyBQ==
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH v3 5/9] ethernet: ti: am65-cpts: Use generic helper function
In-Reply-To: <9e18a305-fbb9-f4da-cf73-65a16bdceb12@ti.com>
References: <20200730080048.32553-1-kurt@linutronix.de> <20200730080048.32553-6-kurt@linutronix.de> <9e18a305-fbb9-f4da-cf73-65a16bdceb12@ti.com>
Date:   Thu, 30 Jul 2020 11:36:37 +0200
Message-ID: <87ime5ny3e.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Jul 30 2020, Grygorii Strashko wrote:
> On 30/07/2020 11:00, Kurt Kanzenbach wrote:
>> +	msgtype =3D ptp_get_msgtype(hdr, ptp_class);
>> +	seqid	=3D be16_to_cpu(hdr->sequence_id);
>
> Is there any reason to not use "ntohs()"?

This is just my personal preference, because I think it's more
readable. Internally ntohs() uses be16_to_cpu(). There's no technical
reason for it.

>
>>=20=20=20
>> -	seqid =3D (__be16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
>> -	*mtype_seqid =3D (*msgtype << AM65_CPTS_EVENT_1_MESSAGE_TYPE_SHIFT) &
>> +	*mtype_seqid  =3D (msgtype << AM65_CPTS_EVENT_1_MESSAGE_TYPE_SHIFT) &
>>   			AM65_CPTS_EVENT_1_MESSAGE_TYPE_MASK;
>> -	*mtype_seqid |=3D (ntohs(*seqid) & AM65_CPTS_EVENT_1_SEQUENCE_ID_MASK);
>> +	*mtype_seqid |=3D (seqid & AM65_CPTS_EVENT_1_SEQUENCE_ID_MASK);
>>=20=20=20
>>   	return 1;
>>   }
>>=20
>
> I'll try to test it today.
> Thank you.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8ilKUACgkQeSpbgcuY
8KZkLxAAhYotYPHd311qZ9Kv/U/0YvYvkmbHhhq4fMpGXEmgnaBIEC0QFPf6Wbfz
4m/X9Vv08FuA9w7+iUt0DqaQQqFgYnmXQoN/FxMohDmsZyG4oA8GsZe/Gd1Zui/M
Dr6rmSgMcFGX5xMuX54bhZpqham3ZVsg7Ryl9aQs8X+X6XW2qHUUTUieT1SuqvM4
H+e6JkAlCDNomQsLTsYnaUd9IaVlH0nN3R0vKoNyS2YiPoVaEGGgUGDJ5dqzyKlP
wtgWR5ifiv9fHubIfMLaJ/SIj5/vLlK6u5+yE9mbngn32cScLPEF5ES4Z1RPjOQ/
Sr/EzZWDAp+9NDhdCo1bt0i2OKHa377RxGslBWb1SKdB4KbyetRECZ0rzKSHNAec
KNAEIE3+XkFxYGpvP1A3mns4YjOHBjhcJ1J6BMjY9sUvQlYqDat5j6FgZyJVtCPI
uD7C1Knnrb44k5NZmEodNvTRZr+PftwXbs6PCEoflUKK/CeanAWyBl8kuw21y13M
P/rDupS/jtwZ8djXIGDESLl4xTHPBOl/zQFyinOYuQ0timiiILh0rg6KdD2GQ1tX
HG1b1si0oP0BgxlqDDHWvs0GFZE/3doEbLNE+7B0z2U4pU1yhqrShkbnGnh+65mu
4xwzTLJJMHPnlPumUIfiCJLZLW705XRgnNR25gP1dFmDqDGoM6w=
=pAIB
-----END PGP SIGNATURE-----
--=-=-=--
