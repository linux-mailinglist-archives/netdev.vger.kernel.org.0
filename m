Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CCA69F7BB
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 16:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjBVP2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 10:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjBVP16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 10:27:58 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA79783C8;
        Wed, 22 Feb 2023 07:27:55 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id x1so8572920qtw.3;
        Wed, 22 Feb 2023 07:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9m/kfnrGONHsb5PgnBL8/pStsYy3q027IoFRDMpAcZU=;
        b=XPHi6bVpsqeur/ddrM+PLHpuzvfigwzUC+IiEsjvv0rtzuDaVKEndev+Fzjp/Ts7JS
         QtfNv8bOjh5C0Z2BkheQO4PAmcQfb9ZvLu8u1VA1KrvvFTh5S/NC6C1onbDtJ4SVAYqq
         8PbdlFBEerFzr7Zj/FPIpsG2H1SgeerQgXxdmxCu8V96kWdcDyoLj6SN60T/3ih14hkx
         0s3Ra9B+iTpiFUThw5+A4BZO1SaH2HigM2ANH51cskJCSz8Gpah6TgAO9Sk7rLHHwdeg
         lUBOLWQlOdssQugiBpoXc83cUq0Eo/0GhztooXNGkR+4Mf+ABbii6P+DHk5opmhBnLn/
         RujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9m/kfnrGONHsb5PgnBL8/pStsYy3q027IoFRDMpAcZU=;
        b=cA+OFDR4qYLO1nheD2glRAllf32MliZs6in9zhaYBlwrkOHnHNmntj7Uajezkqqc+u
         mA3T2CEgYX9fRZZMPN9YAZo0MScoimR5AHvuEUGmkCUiHZKX6qji+r+xThFncStPz/10
         R+MUvF9bs7u1XXgXy6GG3eyrVzIVKThJOCpRAfedMcydSGXiBfN41hsCut9bT7lz4ryE
         LNJQVm4rj4yMifXHpWaBiwlp9xRTLEYlSvSJzbGh1CXG5HNau8u2+mrf9jUn5ZcRM4rj
         z0Y71oxQmdG+Jlfr4JhOVbTNiYstzQLxICOl0GlUOzKDPT+X8TgoQqyUKbZ3bUPZlqi4
         VZ/Q==
X-Gm-Message-State: AO0yUKWVd9nVOLhBnM9SgVBu8AlZO96whowb7073LhhZ64cdAiyjHfle
        j6IfGrXHeTaHqdIjuFZWaQQ=
X-Google-Smtp-Source: AK7set/1BvDCAvES8JGFY48r1wN4zAcdhaRvQGNPyo9p4+QUTuctyxvou2neiIylYkOla+LFNNxA4Q==
X-Received: by 2002:a05:622a:38f:b0:3b6:9736:2e9b with SMTP id j15-20020a05622a038f00b003b697362e9bmr27073875qtx.26.1677079674885;
        Wed, 22 Feb 2023 07:27:54 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id q73-20020a37434c000000b0073b341148b3sm2723961qka.121.2023.02.22.07.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 07:27:54 -0800 (PST)
Date:   Wed, 22 Feb 2023 10:27:54 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, alexanderduyck@fb.com, lixiaoyan@google.com,
        steffen.klassert@secunet.com, lucien.xin@gmail.com,
        ye.xingchen@zte.com.cn, iwienand@redhat.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <63f6347a48c26_3a2320814@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230222151236.GB12658@debian>
References: <20230222145917.GA12590@debian>
 <20230222151236.GB12658@debian>
Subject: RE: [PATCH v2 2/2] gro: optimise redundant parsing of packets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Gobert wrote:
> Currently the IPv6 extension headers are parsed twice: first in
> ipv6_gro_receive, and then again in ipv6_gro_complete.
> 
> By using the new ->transport_proto field, and also storing the size of the
> network header, we can avoid parsing extension headers a second time in
> ipv6_gro_complete (which saves multiple memory dereferences and conditional
> checks inside ipv6_exthdrs_len for a varying amount of extension headers in IPv6
> packets).
> 
> The implementation had to handle both inner and outer layers in case of
> encapsulation (as they can't use the same field).
> 
> Performance tests for TCP stream over IPv6 with a varying amount of extension
> headers demonstrate throughput improvement of ~0.7%.
> 
> In addition, I fixed a potential existing problem:
>  - The call to skb_set_inner_network_header at the beginning of
>    ipv6_gro_complete calculates inner_network_header based on skb->data by
>    calling skb_set_inner_network_header, and setting it to point to the beginning
>    of the ip header.
>  - If a packet is going to be handled by BIG TCP, the following code block is
>    going to shift the packet header, and skb->data is going to be changed as
>    well. 
> 
> When the two flows are combined, inner_network_header will point to the wrong
> place.
> 
> The fix is to place the whole encapsulation branch after the BIG TCP code block.

This should be a separate fix patch?

> This way, inner_network_header is calculated with a correct value of skb->data.
> Also, by arranging the code that way, the optimisation does not add an additional
> branch.
> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>  include/net/gro.h      |  9 +++++++++
>  net/ethernet/eth.c     | 14 +++++++++++---
>  net/ipv6/ip6_offload.c | 20 +++++++++++++++-----
>  3 files changed, 35 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/gro.h b/include/net/gro.h
> index 7b47dd6ce94f..35f60ea99f6c 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -86,6 +86,15 @@ struct napi_gro_cb {
>  
>  	/* used to support CHECKSUM_COMPLETE for tunneling protocols */
>  	__wsum	csum;
> +
> +	/* Used in ipv6_gro_receive() */
> +	u16	network_len;
> +
> +	/* Used in eth_gro_receive() */
> +	__be16	network_proto;
> +

Why also cache eth->h_proto? That is not mentioned in the commit message.

> +	/* Used in ipv6_gro_receive() */
> +	u8	transport_proto;
