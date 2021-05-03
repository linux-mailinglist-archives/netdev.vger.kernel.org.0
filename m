Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33037371715
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 16:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhECOvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 10:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhECOvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 10:51:43 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796B6C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 07:50:50 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id i81so5622607oif.6
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 07:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YUzzR1wqCZMkLqqcd9B5/jv9E7kSNvLPIt2VNrsvakE=;
        b=pEq9pyxMocrT4LIKjcXBYGzg1+rWW0Fx7mQU9MMh/+E5QjomFhxzPf2CAQDeq9k2Td
         j8acxIcx2UNtX/c6Cxu6lJ8nT+6/ukXpdhfyt2T56isWFOwLtFCfUU1StKl/vuXWApi5
         IvuvbnREOFpmY7f7yTcwwd5sikwbApuR/tFAPD0QoepgTmrO3Bne4UCN0BGTHA0n39hJ
         SCHfsFTW84ocMOBGpObSk6o+RSRGg1zwkmBHUFKeAxhZDtsKJL5w645e1O224pdxG8Jy
         tga9A9JyaG9TsCxGGYqAlgimNSj+o3KJo/eC5ncqJTtOvsVZ7T+ZA8inkU4lCmlxyl8/
         Xq4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YUzzR1wqCZMkLqqcd9B5/jv9E7kSNvLPIt2VNrsvakE=;
        b=glDU3Dbe3EsBsbUW0GVp6YAodF0oUvHcLA0ZAS9n1QVu+UbS63PQBCXguyP/aDGiD7
         EWZjsO8TEB+UGYrNd5i7dOG6UZ0zh830ZB7MZDoAknsPnMIi74YZvA29BJpXm/bOQ/e7
         Pv0DhelgnP5ryoJiHNOvTv1X9gapTCjO7TBsUtUCsF8U8O8FZ0BDXXTexUdNByjeKmNl
         NIpG6f75ivewWgU7eLgSog/otW+s9AOfP6ewxdR+j0GoHuPaj1vlGihCo9ZiSqVT0oAs
         tAxu/9LPOkI7k4AxJFg+hIrR+jaBa5scnYLihx9KHCEX96oGh1QEgq1h9ea+n8ixrCeb
         xJQQ==
X-Gm-Message-State: AOAM533Yuc0BdivDWGFhDYpM6ILaE12mQ+/mHWW2HqYcg2ZpLIaM+BqY
        WafEsOd5IfFmbdcTsp1sW0A=
X-Google-Smtp-Source: ABdhPJxJPZBJh+E6jFtreVKOJo7vNuBwvaGRUX/B3FsTJTcZOgmLClFVHhdP2rd9pYVWFNc9FwnKDQ==
X-Received: by 2002:aca:2314:: with SMTP id e20mr13673117oie.167.1620053449962;
        Mon, 03 May 2021 07:50:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id m13sm2906473otp.71.2021.05.03.07.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 07:50:49 -0700 (PDT)
Subject: Re: [PATCH iproute2 1/2] tipc: bail out if algname is abnormally long
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        Tuong Lien <tuong.t.lien@dektech.com.au>
Cc:     stephen@networkplumber.org
References: <cover.1619886329.git.aclaudi@redhat.com>
 <0615f30dc0e11d25d61b48a65dfcb9e9f1136188.1619886329.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2448f15e-7813-f754-dbac-3b870d6ae87b@gmail.com>
Date:   Mon, 3 May 2021 08:50:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <0615f30dc0e11d25d61b48a65dfcb9e9f1136188.1619886329.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc author of Fixes commit ]

On 5/1/21 10:32 AM, Andrea Claudi wrote:
> tipc segfaults when called with an abnormally long algname:
> 
> $ tipc node set key 0x1234 algname supercalifragilistichespiralidososupercalifragilistichespiralidoso
> *** buffer overflow detected ***: terminated
> 
> Fix this returning an error if provided algname is longer than
> TIPC_AEAD_ALG_NAME.
> 
> Fixes: 24bee3bf9752 ("tipc: add new commands to set TIPC AEAD key")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  tipc/node.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tipc/node.c b/tipc/node.c
> index ae75bfff..bf592a07 100644
> --- a/tipc/node.c
> +++ b/tipc/node.c
> @@ -236,10 +236,15 @@ get_ops:
>  
>  	/* Get algorithm name, default: "gcm(aes)" */
>  	opt_algname = get_opt(opts, "algname");
> -	if (!opt_algname)
> +	if (!opt_algname) {
>  		strcpy(input.key.alg_name, "gcm(aes)");
> -	else
> +	} else {
> +		if (strlen(opt_algname->val) > TIPC_AEAD_ALG_NAME) {
> +			fprintf(stderr, "error, invalid algname\n");
> +			return -EINVAL;
> +		}
>  		strcpy(input.key.alg_name, opt_algname->val);
> +	}
>  
>  	/* Get node identity */
>  	opt_nodeid = get_opt(opts, "nodeid");
> 

