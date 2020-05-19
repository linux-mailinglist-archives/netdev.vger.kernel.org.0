Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDB31D8E6A
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 05:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgESD5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 23:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgESD5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 23:57:48 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FE1C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 20:57:48 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s1so13147931qkf.9
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 20:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dYOswKJogJtxGEnkT0GaX1RXnCvGlxuxcpNlrqau7ok=;
        b=vQih86P239FeDVs090Qam1mULHD/zqmElBpt+SJHdp55J2kLNWXTjqXxIRV5WAVyDB
         aVKK1xO9n2hvDi8im2wvG2WNZyYlv5lcPxuwvLUlvJL6cZRD1UkTehcEHzpmVPcfCG8A
         9Kfk0MHqWaso8zY6hNzOqAkspvwvSbxwfNkVVwRW0EFc3kN8SlyZArtB1uQFHo1+8t0x
         JaGJXX3OTK8MGkNwx8LffmNH/Ren2Vpjfou+wOu/us6GLIPpZxVh6A65tfWo5RHEvtqh
         es9i3FOt57w+uEqYyQ6a+i3Wgem0F79krtOT/XLaRtB7u9epR1jW5hwGv3ilpocl+HaE
         ypGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dYOswKJogJtxGEnkT0GaX1RXnCvGlxuxcpNlrqau7ok=;
        b=KwSKOJ3t+krLTnt3nCZWG6mQ10Uw3nkV4Rckx+6Fj53U8rY9Kq4tkdkHcoGiTVwYra
         onnU53X3z58u1w9a0AM/ek1KwGqmq7K7rv5CAktM99cMbRqkxG9DrwD6/TedzqvYmV7Q
         a11tGdzEKBR49bTNIqXcBlR8VfQvEJMWedWoDnoOGREAHUUm5+ZAUVFjk1ZzhRjID7cA
         0BqFQttLrQsGSRZaype+UEFPMZveCaLfSYCVsmsTBDpjsKa8PXXsof6c0Pr5ug6rfftw
         UzBzGFgTs5H2skyN+AIyXsIvb1jKiqHbFwIsXqrmY0UId6Ob2FU0h1PQOZowh2EaxQLX
         aizQ==
X-Gm-Message-State: AOAM530yeVc7mYwbLr4O2r85gBX6216rf6VVMq9Eaaj0RZ0LB0V9vPLg
        EcxUV5O4Na7zmkQ5IS5dbj4=
X-Google-Smtp-Source: ABdhPJzW5sRYbemQsOj4JbmQiQkmFta74Litc+cPO0Rx40OaDuS8MxYdR2UXbOem5a6SInP0J1jcTQ==
X-Received: by 2002:a37:515:: with SMTP id 21mr5938162qkf.317.1589860666507;
        Mon, 18 May 2020 20:57:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id p40sm11274644qtj.59.2020.05.18.20.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 20:57:45 -0700 (PDT)
Subject: Re: [PATCH net-next 3/6] vxlan: ecmp support for mac fdb entries
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
 <1589854474-26854-4-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <74896d1b-bd83-4271-3492-6dc0117ae933@gmail.com>
Date:   Mon, 18 May 2020 21:57:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589854474-26854-4-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 8:14 PM, Roopa Prabhu wrote:
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index 04dafc6..d929c98 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -331,6 +331,8 @@ static inline struct fib_nh_common *nexthop_path_fdb_result(struct nexthop *nh,
>  	struct nexthop *nhp;
>  
>  	nhp = nexthop_select_path(nh, hash);
> +	if (unlikely(!nhp))
> +		return NULL;
>  	nhi = rcu_dereference(nhp->nh_info);
>  	return &nhi->fib_nhc;
>  }

that should be folded into patch 2 which introduces nexthop_path_fdb_result


> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index cd144e3..eefcda8 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -29,6 +29,7 @@ enum {
>  	NDA_LINK_NETNSID,
>  	NDA_SRC_VNI,
>  	NDA_PROTOCOL,  /* Originator of entry */
> +	NDA_NH_ID,
>  	__NDA_MAX
>  };
>  
> 

That needs to be in Patch 2 for it to compile.

I am not qualified to review the vxlan code.
