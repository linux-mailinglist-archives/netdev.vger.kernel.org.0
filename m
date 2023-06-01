Return-Path: <netdev+bounces-7112-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A7E71A1B4
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFB39280FA7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201FB21CE9;
	Thu,  1 Jun 2023 15:04:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF782342E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:04:38 +0000 (UTC)
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2F41BC;
	Thu,  1 Jun 2023 08:04:16 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-53fb4ee9ba1so450068a12.3;
        Thu, 01 Jun 2023 08:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685631844; x=1688223844;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uK5uD6mrs680QG5ZmOnn4rSAVBfFbZfxfM8tNBrb058=;
        b=ceovWaLmO/oFqHSbSTBIXk3xpZsswwzaga5keHs9O/mS7z7hEUSta7Yr8vMPRgvMTV
         WQiZUZqKD9i11NoejYmr9TQtGDDXnvgGlkv3pMvSizVgvkDe0P7h2VdrDt2bvAzgbsro
         zAqoFZySRTuwFs5AIOhgOecYdfzjI9cskmwWrHuIZOHmJyFBGyrLb8C7vpXk1uKl9QD8
         xTsVcRfcjLnLev4k5dIJmOAwEEtWDqgmYiMIS6of/Qtwhf33A9ZG9+pCBqEiC4PzVAfd
         xLEslY9zg8YKQwyCYxV/DewxvxOBCgVbsmTNBSDWi8m+gxGmeIBH8YgR+c2istDqgnYt
         68Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685631844; x=1688223844;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uK5uD6mrs680QG5ZmOnn4rSAVBfFbZfxfM8tNBrb058=;
        b=FhFhRcXUGNLRpfdjOe69tQe35xWoW9sE/cX3bz5ZhbOJKQSNeHbZO5TFrV+6OJdizf
         iNSu6oTxTGYTUuYAcRKDKrWsD5JzstlZ9/xscrUQnwGR9OT0doeIa8fAMPwapQUmZf0G
         /dF9Gwup4iSUPj6whF/D+Zhv7SEdE+tRs3Wjphn+idxRAOh+VoIw3MhNnR5doWRz44wf
         KjktpmrBwtOp2d6locko3LezpOgPAQQyfRiI0KPx6nVOWTUUHbCWg4c42IHZgyL2SkBz
         E8sA8UFruEbC2rHrhBTvhA8S9ke9uDAJDciSjOiRmNMtUU0CfzncldkV6MSyKRiu6Gaf
         rlhg==
X-Gm-Message-State: AC+VfDzYlnJTizVHri2Zb8IN689/e04yc5Uyjr+QUnI5qL4ii85qaTQ6
	o4Rt8fJt2gNP12NYXpmsntA=
X-Google-Smtp-Source: ACHHUZ4IbiBQSVqKfeqcz/0yixtHbKKuW5gVkmqW0iPt+iOTvLQ6dO7Q4BFs20SBeMYhFrUr/hSvUg==
X-Received: by 2002:a17:903:245:b0:1a9:7b5e:14ba with SMTP id j5-20020a170903024500b001a97b5e14bamr7070241plh.29.1685631843704;
        Thu, 01 Jun 2023 08:04:03 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id 17-20020a170902e9d100b001affb590696sm3574251plk.216.2023.06.01.08.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 08:04:03 -0700 (PDT)
Message-ID: <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Ding Hui <dinghui@sangfor.com.cn>, davem@davemloft.net,
 edumazet@google.com,  kuba@kernel.org, pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Date: Thu, 01 Jun 2023 08:04:01 -0700
In-Reply-To: <20230601112839.13799-1-dinghui@sangfor.com.cn>
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-06-01 at 19:28 +0800, Ding Hui wrote:
> When we get statistics by ethtool during changing the number of NIC
> channels greater, the utility may crash due to memory corruption.
>=20
> The NIC drivers callback get_sset_count() could return a calculated
> length depends on current number of channels (e.g. i40e, igb).
>=20

The drivers shouldn't be changing that value. If the drivers are doing
this they should be fixed to provide a fixed length in terms of their
strings.

> The ethtool allocates a user buffer with the first ioctl returned
> length and invokes the second ioctl to get data. The kernel copies
> data to the user buffer but without checking its length. If the length
> returned by the second get_sset_count() is greater than the length
> allocated by the user, it will lead to an out-of-bounds copy.
>=20
> Fix it by restricting the copy length not exceed the buffer length
> specified by userspace.
>=20
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>

Changing the copy size would not fix this. The problem is the driver
will be overwriting with the size that it thinks it should be using.
Reducing the value that is provided for the memory allocations will
cause the driver to corrupt memory.

> ---
>  net/ethtool/ioctl.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>=20
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 6bb778e10461..82a975a9c895 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -1902,7 +1902,7 @@ static int ethtool_self_test(struct net_device *dev=
, char __user *useraddr)
>  	if (copy_from_user(&test, useraddr, sizeof(test)))
>  		return -EFAULT;
> =20
> -	test.len =3D test_len;
> +	test.len =3D min_t(u32, test.len, test_len);
>  	data =3D kcalloc(test_len, sizeof(u64), GFP_USER);
>  	if (!data)
>  		return -ENOMEM;

This is the wrong spot to be doing this. You need to use test_len for
your allocation as that is what the driver will be writing to. You
should look at adjusting after the allocation call and before you do
the copy

> @@ -1915,7 +1915,8 @@ static int ethtool_self_test(struct net_device *dev=
, char __user *useraddr)
>  	if (copy_to_user(useraddr, &test, sizeof(test)))
>  		goto out;
>  	useraddr +=3D sizeof(test);
> -	if (copy_to_user(useraddr, data, array_size(test.len, sizeof(u64))))
> +	if (test.len &&
> +	    copy_to_user(useraddr, data, array_size(test.len, sizeof(u64))))
>  		goto out;
>  	ret =3D 0;
> =20

I don't believe this is adding any value. I wouldn't bother with
checking for lengths of 0.

> @@ -1940,10 +1941,10 @@ static int ethtool_get_strings(struct net_device =
*dev, void __user *useraddr)
>  		return -ENOMEM;
>  	WARN_ON_ONCE(!ret);
> =20
> -	gstrings.len =3D ret;
> +	gstrings.len =3D min_t(u32, gstrings.len, ret);
> =20
>  	if (gstrings.len) {
> -		data =3D vzalloc(array_size(gstrings.len, ETH_GSTRING_LEN));
> +		data =3D vzalloc(array_size(ret, ETH_GSTRING_LEN));
>  		if (!data)
>  			return -ENOMEM;
> =20

Same here. We should be using the returned value for the allocations
and tests, and then doing the min adjustment after the allocationis
completed.

> @@ -2055,9 +2056,9 @@ static int ethtool_get_stats(struct net_device *dev=
, void __user *useraddr)
>  	if (copy_from_user(&stats, useraddr, sizeof(stats)))
>  		return -EFAULT;
> =20
> -	stats.n_stats =3D n_stats;
> +	stats.n_stats =3D min_t(u32, stats.n_stats, n_stats);
> =20
> -	if (n_stats) {
> +	if (stats.n_stats) {
>  		data =3D vzalloc(array_size(n_stats, sizeof(u64)));
>  		if (!data)
>  			return -ENOMEM;

Same here. We should be using n_stats, not stats.n_stats and adjust
before you do the final copy.

> @@ -2070,7 +2071,8 @@ static int ethtool_get_stats(struct net_device *dev=
, void __user *useraddr)
>  	if (copy_to_user(useraddr, &stats, sizeof(stats)))
>  		goto out;
>  	useraddr +=3D sizeof(stats);
> -	if (n_stats && copy_to_user(useraddr, data, array_size(n_stats, sizeof(=
u64))))
> +	if (stats.n_stats &&
> +	    copy_to_user(useraddr, data, array_size(stats.n_stats, sizeof(u64))=
))
>  		goto out;
>  	ret =3D 0;
> =20

Again. I am not sure what value is being added. If n_stats is 0 then I
am pretty sure this will do nothing anyway.

