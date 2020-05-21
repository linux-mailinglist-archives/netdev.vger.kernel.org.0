Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B031DC379
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgEUAR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgEUAR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:17:29 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21312C061A0E;
        Wed, 20 May 2020 17:17:29 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f13so5642881qkh.2;
        Wed, 20 May 2020 17:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6VjbEhQDFU1/kcyRd3meryKPmdnEABgZ4qDJb1UqetE=;
        b=NOJud/lsJqiKVSGbBL8wenpgaXOIhEsVA2iHONC6Z+Guz4miHbzU8z6fZRKt/pjjfm
         S6pMI6iBicZe/Hrq9ELWEF8SohHAHW6e7iihOhNd6eVYC8IXnMNceAvQ327cK+7QTuN3
         +WqKXpgZfikGe1hVeIZrdNGqR66r5nNbjw5jTEG4v+iArcpxwbK7/+wuntubBLAsLT6I
         UmosiK6sI26diUMzsq90bttl716MSGQnowHHQpJHzno6xEsM4tciHp+CpLt70a7NJ8oJ
         MmOymIcYwH9YYzXSi7Z8yudFrlN+gni8r0Qy2VT2np62xr8DRqP/RzL/tHLZRLBziok0
         n3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6VjbEhQDFU1/kcyRd3meryKPmdnEABgZ4qDJb1UqetE=;
        b=OzXRF6qSIvdexOdg1sgNdDtMGSYfBzDL5ZhSIy6N2L/xMYlx8KYye18MEkyeMjUeJ4
         Jj77K3AV7HKznDVeuobGGChNHW9WiRzwLTjOmKwyxUmJdczlBcExylvKHTg3taAhG1Kz
         Cl2CmybTU3AFwLO8FM1rlesvX35zUaIfHuruVDpv/A9y+gSqWMwr8/irIghsdFRe+890
         vh+Romy2I/H7HAMVRExTXVbPi+f5/ZsCRB5u+sKTRlhHlVvIUs8GQagb7d6l7p13SQ/4
         xdctfw1OzkmowK3umLfxxvTMXXVIhiTUlLjVKlruNeqzCSFVJVH0LVJQXkfkYTBFcpwn
         e0cA==
X-Gm-Message-State: AOAM531Y5b76rIC8Sg869yyFzKiqxe3F8J9CuJVG/cUZ05R511+yBoyn
        OtrSKDSpZ9HUfsT8Lqxja8qk738wEL173A==
X-Google-Smtp-Source: ABdhPJz+OlWSF0IkJyBW0ofYclhKPKOjs7+ka9IcVzynH1tZUWXdn5Ns7lr5YlGRN43Sqmy+npAwgw==
X-Received: by 2002:ae9:f50f:: with SMTP id o15mr7791756qkg.177.1590020248272;
        Wed, 20 May 2020 17:17:28 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id n5sm3508091qke.124.2020.05.20.17.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 17:17:27 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 32EFEC0DAC; Wed, 20 May 2020 21:17:25 -0300 (-03)
Date:   Wed, 20 May 2020 21:17:25 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net-next] sctp: Pull the user copies out of the
 individual sockopt functions.
Message-ID: <20200521001725.GW2491@localhost.localdomain>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
...
> Only SCTP_SOCKOPT_CONNECTX3 contains an indirect pointer.
> It is also the only getsockopt() that wants to return a buffer
> and an error code. It is also definitely abusing getsockopt().
...
> @@ -1375,11 +1350,11 @@ struct compat_sctp_getaddrs_old {
>  #endif
>  
>  static int sctp_getsockopt_connectx3(struct sock *sk, int len,
> -				     char __user *optval,
> -				     int __user *optlen)
> +				     struct sctp_getaddrs_old *param,
> +				     int *optlen)
>  {
> -	struct sctp_getaddrs_old param;
>  	sctp_assoc_t assoc_id = 0;
> +	struct sockaddr *addrs;
>  	int err = 0;
>  
>  #ifdef CONFIG_COMPAT
> @@ -1388,29 +1363,28 @@ static int sctp_getsockopt_connectx3(struct sock *sk, int len,
>  
>  		if (len < sizeof(param32))
>  			return -EINVAL;
> -		if (copy_from_user(&param32, optval, sizeof(param32)))
> -			return -EFAULT;
> +		param32 = *(struct compat_sctp_getaddrs_old *)param;
>  
> -		param.assoc_id = param32.assoc_id;
> -		param.addr_num = param32.addr_num;
> -		param.addrs = compat_ptr(param32.addrs);
> +		param->assoc_id = param32.assoc_id;
> +		param->addr_num = param32.addr_num;
> +		param->addrs = compat_ptr(param32.addrs);
>  	} else
>  #endif
>  	{
> -		if (len < sizeof(param))
> +		if (len < sizeof(*param))
>  			return -EINVAL;
> -		if (copy_from_user(&param, optval, sizeof(param)))
> -			return -EFAULT;
>  	}
>  
> -	err = __sctp_setsockopt_connectx(sk, (struct sockaddr __user *)
> -					 param.addrs, param.addr_num,
> +	addrs = memdup_user(param->addrs, param->addr_num);

I'm staring at this for a while now but I don't get this memdup_user.
AFAICT, params->addrs is not __user anymore here, because
sctp_getsockopt() copied the whole thing already, no?
Also weird because it is being called from kernel_sctp_getsockopt(),
which now has no knowledge of __user buffers.
Maybe I didn't get something from the patch description.

> +	if (IS_ERR(addrs))
> +		return PTR_ERR(addrs);
> +
> +	err = __sctp_setsockopt_connectx(sk, addrs, param->addr_num,
>  					 &assoc_id);
> +	kfree(addrs);
>  	if (err == 0 || err == -EINPROGRESS) {
> -		if (copy_to_user(optval, &assoc_id, sizeof(assoc_id)))
> -			return -EFAULT;
> -		if (put_user(sizeof(assoc_id), optlen))
> -			return -EFAULT;
> +		*(sctp_assoc_t *)param = assoc_id;
> +		*optlen = sizeof(assoc_id);
>  	}
>  
>  	return err;
