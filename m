Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F84F5A8566
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 20:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiHaSWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 14:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiHaSWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 14:22:20 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC30C5596
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 11:18:41 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 145so14870334pfw.4
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 11:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=c0XdkMbTQBSAjd8ya7e2nTusM/ZQyaf0gz9rPauUcLk=;
        b=cxa5z0qZIgkr0yjEz6TfrwMj8uUbv5/SjZ+wYU3SK1/v9aMVa4hRTAV6iMRoF7WFxd
         0V6hRpKxd1GHLEvwypKpGCBG+xSv344ZJiKwwjqWOYsvvsqVSxPVL9XnAQzl/GShvzAm
         UkMTNw+DVk+mmuOP4m4pMMcqtZ3QLcJ73998k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=c0XdkMbTQBSAjd8ya7e2nTusM/ZQyaf0gz9rPauUcLk=;
        b=KkKvAoQGd5vZsAMYc6DJJEQIwJlOZMrZcHPYSnDughB8oO+sfR89JOvZJXXqaMAtlA
         a77DhOJYPB8ETywoeAIVg4nPOklxDRYmaXDyGAJNWd/WFwH7p3gilaUmv/rGXVXPr5sA
         Ag/HjXfX9d+40fYw3fcseuUNdgHJJlmShmhHTOWfRqIPApH7CVTvh7ymhVosivgDdgSN
         kc8wXlmIBJXyiDJTTgemIi+s8SAg46iu2MvQHjJGGSApS7NytLSQ9FkcJ3bS7tVs01tm
         yQm2i4ggf9v0mwKd1xPgnR+LbLNC6CHPV+qvL5gPUmqZ/TqJEonctURCBFFRgSmkiL03
         eLqQ==
X-Gm-Message-State: ACgBeo1g6ByT0rgQUfLqupbiRi8YYrnZ58sUSpLxqhQuHUTyD1C/A0Xz
        Q0LCGfdgvX8sFG3ByQhOAl3b6A==
X-Google-Smtp-Source: AA6agR787O/pwqpnkZH5B+yNnV6QUTylyvzmgRNIR3phDT2SthLfCypFz0laOUUZDHU6CxJhKiZoVw==
X-Received: by 2002:a63:83c6:0:b0:42b:bb27:91a4 with SMTP id h189-20020a6383c6000000b0042bbb2791a4mr16499829pge.61.1661969853129;
        Wed, 31 Aug 2022 11:17:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w123-20020a626281000000b005383a0d9699sm6873039pfb.144.2022.08.31.11.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 11:17:32 -0700 (PDT)
Date:   Wed, 31 Aug 2022 11:17:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] uapi: net/ipv4: Use __DECLARE_FLEX_ARRAY() helper
Message-ID: <202208311116.62D0CD477@keescook>
References: <Yw5H3E3a6mmpuTeT@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw5H3E3a6mmpuTeT@work>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 12:24:44PM -0500, Gustavo A. R. Silva wrote:
> We now have a cleaner way to keep compatibility with user-space
> (a.k.a. not breaking it) when we need to keep in place a one-element
> array (for its use in user-space) together with a flexible-array
> member (for its use in kernel-space) without making it hard to read
> at the source level. This is through the use of the new
> __DECLARE_FLEX_ARRAY() helper macro.
> 
> The size and memory layout of the structure is preserved after the
> changes. See below.
> 
> Before changes:
> 
> $ pahole -C ip_msfilter net/ipv4/igmp.o
> struct ip_msfilter {
> 	union {
> 		struct {
> 			__be32     imsf_multiaddr_aux;   /*     0     4 */
> 			__be32     imsf_interface_aux;   /*     4     4 */
> 			__u32      imsf_fmode_aux;       /*     8     4 */
> 			__u32      imsf_numsrc_aux;      /*    12     4 */
> 			__be32     imsf_slist[1];        /*    16     4 */
> 		};                                       /*     0    20 */
> 		struct {
> 			__be32     imsf_multiaddr;       /*     0     4 */
> 			__be32     imsf_interface;       /*     4     4 */
> 			__u32      imsf_fmode;           /*     8     4 */
> 			__u32      imsf_numsrc;          /*    12     4 */
> 			__be32     imsf_slist_flex[0];   /*    16     0 */
> 		};                                       /*     0    16 */
> 	};                                               /*     0    20 */
> 
> 	/* size: 20, cachelines: 1, members: 1 */
> 	/* last cacheline: 20 bytes */
> };
> 
> After changes:
> 
> $ pahole -C ip_msfilter net/ipv4/igmp.o
> struct ip_msfilter {
> 	struct {
> 		__be32             imsf_multiaddr;       /*     0     4 */
> 		__be32             imsf_interface;       /*     4     4 */
> 		__u32              imsf_fmode;           /*     8     4 */
> 		__u32              imsf_numsrc;          /*    12     4 */
> 		union {
> 			__be32     imsf_slist[1];        /*    16     4 */
> 			struct {
> 				struct {
> 				} __empty_imsf_slist_flex; /*    16     0 */
> 				__be32 imsf_slist_flex[0]; /*    16     0 */
> 			};                               /*    16     0 */
> 		};                                       /*    16     4 */
> 	};                                               /*     0    20 */
> 
> 	/* size: 20, cachelines: 1, members: 1 */
> 	/* last cacheline: 20 bytes */
> };
> 
> In the past, we had to duplicate the whole original structure within
> a union, and update the names of all the members. Now, we just need to
> declare the flexible-array member to be used in kernel-space through
> the __DECLARE_FLEX_ARRAY() helper together with the one-element array,
> within a union. This makes the source code more clean and easier to read.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  include/uapi/linux/in.h | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> index 14168225cecd..fa4dc8f8f081 100644
> --- a/include/uapi/linux/in.h
> +++ b/include/uapi/linux/in.h
> @@ -188,20 +188,14 @@ struct ip_mreq_source {
>  };
>  
>  struct ip_msfilter {
> -	union {
> -		struct {
> -			__be32		imsf_multiaddr_aux;
> -			__be32		imsf_interface_aux;
> -			__u32		imsf_fmode_aux;
> -			__u32		imsf_numsrc_aux;
> +	struct {

I don't think this internal anonymous struct is needed any more?

> +		__be32		imsf_multiaddr;
> +		__be32		imsf_interface;
> +		__u32		imsf_fmode;
> +		__u32		imsf_numsrc;
> +		union {
>  			__be32		imsf_slist[1];
> -		};
> -		struct {
> -			__be32		imsf_multiaddr;
> -			__be32		imsf_interface;
> -			__u32		imsf_fmode;
> -			__u32		imsf_numsrc;
> -			__be32		imsf_slist_flex[];
> +			__DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
>  		};
>  	};
>  };

I.e. can't this now just be:

struct ip_msfilter {
	__be32          imsf_multiaddr;
	__be32          imsf_interface;
	__u32           imsf_fmode;
	__u32           imsf_numsrc;
	union {
		__be32          imsf_slist[1];
		__DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
	};
};


> -- 
> 2.34.1
> 

-- 
Kees Cook
