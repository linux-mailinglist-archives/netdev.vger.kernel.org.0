Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3B4435F79
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhJUKqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:46:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230374AbhJUKqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634813066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YRO/laoUj+5vXeB/KYa/nd6OPQaZ8vOBRM0emSQus4k=;
        b=bZxb7fUiVuIDmLS3/YFcWnQ5i/YgqPVCCBsn96qiBQh0nJ3ZKoAeVhakzgoUrKmG71Ck1D
        9XxyU78iLAjq/SWyzN2y+MmXUZHqrWCCGQhxg1irpe47LcZUUfp+y+xwL269xpCqelRTBe
        4GYPe65KPXdqA3IWVkL/65UhDpyP5BM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261--liePgRgNQKLQTeZM_UElQ-1; Thu, 21 Oct 2021 06:44:25 -0400
X-MC-Unique: -liePgRgNQKLQTeZM_UElQ-1
Received: by mail-wm1-f70.google.com with SMTP id v18-20020a7bcb52000000b00322fea1d5b7so122882wmj.9
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 03:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YRO/laoUj+5vXeB/KYa/nd6OPQaZ8vOBRM0emSQus4k=;
        b=yIB73BH5i5M0DRXEzjcQ1AmWJGYtz3ilqJ+q0feVc5cgJInhXrDFzWjVzQ4xPG5RQW
         TdFe7Pt5+i1ruDOOgr27bSjyyUaVSvi5SOFr2rQ5DgdBb+SzQMpT5LwXDBbqGLY4HONY
         1Xv4acRwYwmyEaYcrUH5EkcN0n1Vp06Le1eBi54CuutIV52h0LuOosyWiERv9MexwOGM
         oReAQ8Vn/3sHqJjzAc6zI5y9h7ifssXwjmXPOJ1FITn1rdhx+W2OXobUSyVAeysRpOOZ
         wMcw/ytGza5nTqYXb1tl70s0fTZQ0jEkXJYKNJU65dYYJ3cAl1n4Ep/l9RBmhXY4l9EL
         mwOA==
X-Gm-Message-State: AOAM530o4vh2GoO983BWAcAOpqmqafdpKMgO4ltw/WrZw6Te3fiFsTFT
        Bmqx/90W5cO/ymJX6nCbAPgdH4aYB9pm7Ggy588vXIl7OB+6NoHkN0FjPi9o4n0zdUAgxkQDIIH
        2Fv/DSBOBoOJQ/ChO
X-Received: by 2002:a7b:cb94:: with SMTP id m20mr5669241wmi.188.1634813064531;
        Thu, 21 Oct 2021 03:44:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuzBe5DkKQjxl8GuEEYNid5cawFKrHsDu4+l+tPDUNFAMM4MWpakoTJhRBeKzq83eCcE8RMg==
X-Received: by 2002:a7b:cb94:: with SMTP id m20mr5669205wmi.188.1634813064235;
        Thu, 21 Oct 2021 03:44:24 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-240-164.dyn.eolo.it. [146.241.240.164])
        by smtp.gmail.com with ESMTPSA id n9sm4822916wmq.6.2021.10.21.03.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 03:44:23 -0700 (PDT)
Message-ID: <e8bac4bbffdd24bbe0fa6f846900d9724f6020dd.camel@redhat.com>
Subject: Re: [PATCH] udp: reduce padding field unused to 1-byte in struct
 udp_sock
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jianguo Wu <wujianguo106@163.com>, netdev@vger.kernel.org
Cc:     willemb@google.com, davem@davemloft.net, jchapman@katalix.com
Date:   Thu, 21 Oct 2021 12:44:22 +0200
In-Reply-To: <126b8cf1-0b44-ee99-8598-a10acebc5a47@163.com>
References: <126b8cf1-0b44-ee99-8598-a10acebc5a47@163.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2021-10-21 at 18:27 +0800, Jianguo Wu wrote:
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> In commit 342f0234c71b ("[UDP]: Introduce UDP encapsulation type for L2TP"),
> it includes a padding field(__u8 unused[3]) to put the new encap_rcv field
> on a 4-byte boundary.
> 
> But commit bec1f6f69736 ("udp: generate gso with UDP_SEGMENT") and a new 2-bytes
> field gso_size, so we should cut 2-bytes padding.
> 
> Fixes: bec1f6f69736 udp: generate gso with UDP_SEGMENT)
> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
> ---
>  include/linux/udp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/udp.h b/include/linux/udp.h
> index ae66dad..c1b4e5b 100644
> --- a/include/linux/udp.h
> +++ b/include/linux/udp.h
> @@ -70,7 +70,7 @@ struct udp_sock {
>  #define UDPLITE_SEND_CC  0x2  		/* set via udplite setsockopt         */
>  #define UDPLITE_RECV_CC  0x4		/* set via udplite setsocktopt        */
>  	__u8		 pcflag;        /* marks socket as UDP-Lite if > 0    */
> -	__u8		 unused[3];
> +	__u8		 unused;
>  	/*
>  	 * For encapsulation sockets.
>  	 */

Note that after this patch we will have a 4 bytes hole on 64bits
arches.

My personal take is that we can as well drop the 'unused' field:
someone intentioned to modify the 'udp_sock' struct should have a look
at the binary layout anyway.

Cheers,

Paolo

