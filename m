Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAF63051D9
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 06:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbhA0FSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 00:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239215AbhA0Eev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 23:34:51 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C48EC061756
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 20:33:29 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id n42so482701ota.12
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 20:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZuT0N/iLdVsluz495y3cjqfZZZFc64y9QPD92MDvPBY=;
        b=hqWEGxDzN+jIOH0lJrRMU3W6Cq0Jk9oLo1G1XkIiJGByQeA3MOLQXJIGYur0Xe2Gz3
         zYM/MEoYqksb3g5gZcvVKdmU25DN4GFXfFOwgxJg6niuVT6HqCSvERKHcI2zvTfw2gXX
         eA2UWqMj/uQH05xI46O5ckvpLch5ZHgzZB7aHRSUC9HC/Vo4skcIm1uibRLCLsBEUJ5z
         QGgVTZN4rZKw+tdbcG4qIEgdPx4UnFWaBepmfEtTk+hF2BWO8C9B8SG5lw2O15pAGqoh
         F9Ly1KtHnmu/llg1Ipba3C2hC6QByOWD+SODOkPtA8MIEmiFBvYJpP+rCJwc11rK9HVb
         PDsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZuT0N/iLdVsluz495y3cjqfZZZFc64y9QPD92MDvPBY=;
        b=n8ptHx7+XAKaZ/mqSVP1Ysynlz2DnROzF1F7KO8czKlXHY0w+A3J4e7AIJfbNO37C0
         Sd5D9fSgzm70N7D+j6bnLxyky7um0ahMbmsijxXR9lLzhscOWjBXZqHDFP4gEIpLIyBu
         XLJEyjCUF1XJ3ZTV/oRJyuk/ER1Jn6ugEQwjybU6OXI01dYTMH2l17ImYLQottzeva65
         3Sp8Ib6D1k3E63mOYv0UuvU/ThhreqZE2B6UmQM0na7bI6m2T2j2gBDitq7M2j6bebqs
         YZ7sASoL0M4+jJFfGyOk/ERE4uHLOEWq5BgzsQ7HGy89STszSWrkzTd6EtXbVLMyzy/Y
         IL3A==
X-Gm-Message-State: AOAM533iB472QqPl0AYAErkvyEjm2pvsXkvdA3ZzxIvzOzM21GIDKkMy
        3wiTuEc3V0KSqsyMBc65Jlu1DuI0Dm0=
X-Google-Smtp-Source: ABdhPJw5a4jHkhI016VMPz86b5LDav7jBPdYY0zcg6JG2F8c+ObRfBJ9Pt6c7MeTQbPpw8tcOu3qCQ==
X-Received: by 2002:a05:6830:17d0:: with SMTP id p16mr6051553ota.367.1611722008941;
        Tue, 26 Jan 2021 20:33:28 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:a08d:e5cd:cfb5:2f9])
        by smtp.googlemail.com with ESMTPSA id k41sm225031ooi.46.2021.01.26.20.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 20:33:28 -0800 (PST)
Subject: Re: [PATCH net-next 01/10] netdevsim: fib: Convert the current
 occupancy to an atomic variable
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b307a304-09ef-d8e8-7296-92ddddfc348c@gmail.com>
Date:   Tue, 26 Jan 2021 21:33:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126132311.3061388-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 6:23 AM, Ido Schimmel wrote:
> @@ -889,22 +882,29 @@ static void nsim_nexthop_destroy(struct nsim_nexthop *nexthop)
>  static int nsim_nexthop_account(struct nsim_fib_data *data, u64 occ,
>  				bool add, struct netlink_ext_ack *extack)
>  {
> -	int err = 0;
> +	int i, err = 0;
>  
>  	if (add) {
> -		if (data->nexthops.num + occ <= data->nexthops.max) {
> -			data->nexthops.num += occ;
> -		} else {
> -			err = -ENOSPC;
> -			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported nexthops");
> -		}
> +		for (i = 0; i < occ; i++)
> +			if (!atomic64_add_unless(&data->nexthops.num, 1,
> +						 data->nexthops.max)) {

seems like this can be
		if (!atomic64_add_unless(&data->nexthops.num, occ,
					 data->nexthops.max)) {

and then the err_num_decrease is not needed

> +				err = -ENOSPC;
> +				NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported nexthops");
> +				goto err_num_decrease;
> +			}
>  	} else {
> -		if (WARN_ON(occ > data->nexthops.num))
> +		if (WARN_ON(occ > atomic64_read(&data->nexthops.num)))
>  			return -EINVAL;
> -		data->nexthops.num -= occ;
> +		atomic64_sub(occ, &data->nexthops.num);
>  	}
>  
>  	return err;
> +
> +err_num_decrease:
> +	for (i--; i >= 0; i--)
> +		atomic64_dec(&data->nexthops.num);

and if this path is really needed, why not atomic64_sub here?

> +	return err;
> +
>  }
>  
>  static int nsim_nexthop_add(struct nsim_fib_data *data,
> 

