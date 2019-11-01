Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E62AEC9C3
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfKAUnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:43:08 -0400
Received: from mout.web.de ([212.227.17.12]:49101 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbfKAUnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 16:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1572640963;
        bh=e9boskGhIkDLa3vEXHpvYq1aV9JbklBvbC4KpcTg9YU=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=aUpFf8V7f1xuNAapzTMEJgw2epTjiVEFQrb555wPaCErD5HEBUx1xyzaqkb0g7UpJ
         Tkbn933P12JVeCxMP3dk6ejH+4J19byQClqW3X8OksKXqr2bfNYJA2SpuYN+UBhpDQ
         2dC/xWLwCcClGmfFAEewDSd/intdMlIxYN+9NgbU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.35.66]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M3k8j-1i9FQY2A6r-00rFHS; Fri, 01
 Nov 2019 21:42:43 +0100
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Olaf Hering <olaf@aepfle.de>, Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <1572296801-4789-3-git-send-email-haiyangz@microsoft.com>
Subject: Re: [PATCH net-next, 2/4] hv_netvsc: Fix error handling in
 netvsc_attach()
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <cdf7b308-940a-ff9c-07ae-f42b94687e24@web.de>
Date:   Fri, 1 Nov 2019 21:42:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1572296801-4789-3-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:trtB7xvTfXGQW3iQj5cEaRfPK4WjJOXN1VzyuKucrEP7N3dujzy
 4DIhbGVGp+olPKG/NYTrIvStSBdsJ+x1r0gHShngR60tagw1yHnO/QG8wrK6qOJb4itKunC
 eSyyAeiFZOWvfp+e/KIVyFeanZRdyIKugK5LxMhf1QcraH6Zx5U2XCBaHAbzYkPNKd8yxPt
 n3rr+B9IhA3fFBz0OMl7A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cgrxrmIv5nc=:1KDmVhf0QSEf8Npcwa1HH/
 yWUIGTHNR0J8VTpYtyxFYpntiSkCQ6L9lsXNoDEXSZMCzDmUKkaoubmjmJySUfD/WL7Md8Uyu
 Ea6uRMFroA37h5oIdsvF6UbNcT+435PA4ZZlncaFys/IpuD0uArqxu+nya0fm+eO5srC9oynw
 Nscibx89kpSQJjcw0EX9QS/g1lrC//7Gn64yLqfRi0oMJpmD3bCXCcn/+C1l1W8FK88+DZQ88
 Yw0tFv0iu8jOzG3LQHYSnBHs9t2HxD/tAWckzrVM0kzdb2RjFSimBGsgOV71wbCGojCJ/TyVf
 uJGBnQb7vY158QvfnvXVbQDC52osPuLqAKasRVUoNblWR2lyioXbLWYdvgiBSMqKUO4cX1JSC
 2NCETCpnXuDkIdgrR4Uv+VM0n4FIzBlL4HInicKZbIJuSxnExcYqrwXdjzsdQ2tLKB7snu5sT
 eYNI6FFaR+cajmetGLKlApY2uO8YKr5cmtO4oYJlkVcgAggv3UpvQ5AeqbnSm9A3z4QVW2Emz
 1NqxDtUpQc9dtJS4a3GGVKgFpbkErR19x65r6kD+TQE8o308Vq9droWcSnm+xj9TW4EDR82lG
 zwctXjVFRRLDN17CsviO/Ro9qwFQcl2VnvJqhpNnzJm7HRSrOKRye9zzMa3vvrc+Prgaj5WBX
 TozlGPUsRjuSZQfKR9qTO3pGggoDR4LlmkS/RrfZvgMV59fUPAPasfpYZJOz0igWnSX0mG6ec
 JgQDK+dq4rAui7KimoA/DEW4xezh3ol2mDwOOyrWCD/s5kTHsZSB8b6kVx/yVdaWARNF2FbSY
 PWeaqrK6cd57u+vMFqcPK+EcRAWTGSKImcR8KL0lQDH75/6ncAgiVsvdZ5p5Hp2H0wWqK0WNW
 BTLltSoprc6aLHLZRrCexKQoUmrMRy8DaENO2jD33vLgQPUkKYTbwi3ujTLMsbLtptnN/vpc+
 luHKOnUykjWoYgqPxTI1w1SWCte2a85fzozx8TuYOMqcWZehlN+2fO4vcKxkSGiZL9pEi1jsS
 SqYj5RQF2dt2BAMTMgVa7T9n+eannbn0ljHke/zx0aBuvQlWhwg8YIyaaiavodpxfI5asEsel
 Fyqe/bFeLwYtItWP/L3J2UeMjFp8zR1Y5RXV0odB/X0FjfAqRef9O1c4+leFPSxB+deRbRIId
 7LphlIBBNhDYZ8W9dPb8VHfmg/mFTqVKOeOchc7BWlo8VoKM44S1d+cmbA185D7pnO5WTWnyR
 WHld4/eMlEFSvq/qeiwW7h189J9IwrGiszKsYg2QcRrfSXmMjVFeyl7C4pps=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If rndis_filter_open() fails, we need to remove the rndis device created
> in earlier steps, before returning an error code. Otherwise, the retry o=
f
> netvsc_attach() from its callers will fail and hang.

How do you think about to choose a more =E2=80=9Cimperative mood=E2=80=9D =
for your
change description?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3D0dbe6cb8f7e05bc9611602ef45=
980a6c57b245a3#n151


=E2=80=A6
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -982,7 +982,7 @@ static int netvsc_attach(struct net_device *ndev,
>  	if (netif_running(ndev)) {
>  		ret =3D rndis_filter_open(nvdev);
>  		if (ret)
> -			return ret;
> +			goto err;
>
>  		rdev =3D nvdev->extension;
>  		if (!rdev->link_state)
=E2=80=A6

I would prefer to specify the completed exception handling
(addition of two function calls) by a compound statement in
the shown if branch directly.

If you would insist to use a goto statement, I find an other label
more appropriate according to the Linux coding style.

Regards,
Markus
