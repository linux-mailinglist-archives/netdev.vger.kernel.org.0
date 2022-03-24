Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A304E60A1
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 09:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348440AbiCXIvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 04:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344084AbiCXIvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 04:51:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16E6C64BFB
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 01:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648111811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XFmTwcROswlvrmagzZ2qWGa6g3J0PQJ5ANS3C7aiKE4=;
        b=QCJ5gLDmCUTeIdm1AIRmkj0v7KGjoKyHGeXvv2SIZSPXcCGbDkJvDcIWf+HnWpgvY3GfEg
        2DZIOuhw5n0mO1zJSdmCzxfooe1ukCK9uYRKN2E0RyCwLfh6IfHMd7PiABx0hS9r7osVwV
        D5knhHKhhhAAF5khYpT2bhpMVFBeObQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-QSR4_lwJOXSMV3x2mzqkcw-1; Thu, 24 Mar 2022 04:50:09 -0400
X-MC-Unique: QSR4_lwJOXSMV3x2mzqkcw-1
Received: by mail-wr1-f71.google.com with SMTP id t15-20020adfdc0f000000b001ef93643476so1437335wri.2
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 01:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XFmTwcROswlvrmagzZ2qWGa6g3J0PQJ5ANS3C7aiKE4=;
        b=vcHvubQ4t4wx2iGK3LbTHQZmaqJeuu9nl6RsrgyhAODy+A6fhsvC7g0vMIquKi/j1/
         EMsyGNv8oiykIu0U+M6CGY2WGuIgh/cA+E4DBRYKFIBROxPKrxRYlWT6NTa96YoZEdtS
         l2oUhsz7Vfo0bbmSwWlE74hA0MYK24TjUS4TDmDVNbgBIjrvb6s7uRlBb1XcrKEk1fEi
         GKHvc0Tn64MaX1VQKVPBDxmnCfa5srQu89uSoWLoDuC4YOMaS4q3cSPXfz4c+2XSMSn/
         YUmawqvODqRlki66lLsEvdofwhIwN7areovPVtWOQVPHg/KcpPjJg6wBnR5zsd1TKFIc
         +nUA==
X-Gm-Message-State: AOAM530YKbh9nQzUQ/XQxRhF2N1kL2NeHMi2NkfNwR6sMOMJRpzuMuNX
        oICIDZsJ7qvKevIEgj2u/yFmP5p3SaRg7Q0aayMH83Ho6YRpidVt6OioYuurf5atMv4pXqH09tw
        6Xqg37kuYomtOiBFL
X-Received: by 2002:a05:600c:19ca:b0:38c:a190:9a0f with SMTP id u10-20020a05600c19ca00b0038ca1909a0fmr13273806wmq.57.1648111808550;
        Thu, 24 Mar 2022 01:50:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0LkC56n2G8fuZkptTU7TdHyfx14ik08ajkkKHwja6x8PBC/I7KmmTnEFLmh0MYtRbmySdlg==
X-Received: by 2002:a05:600c:19ca:b0:38c:a190:9a0f with SMTP id u10-20020a05600c19ca00b0038ca1909a0fmr13273783wmq.57.1648111808262;
        Thu, 24 Mar 2022 01:50:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id u11-20020a5d6acb000000b002058148822bsm2947375wrw.63.2022.03.24.01.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 01:50:07 -0700 (PDT)
Message-ID: <a172a650b503f69d3de49586de2fdec2d6a71e7a.camel@redhat.com>
Subject: Re: [RFC net-next 2/3] skbuff: rewrite the doc for data-only skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net, imagedong@tencent.com,
        edumazet@google.com, dsahern@kernel.org, talalahmad@google.com,
        linux-doc@vger.kernel.org
Date:   Thu, 24 Mar 2022 09:50:06 +0100
In-Reply-To: <20220323233715.2104106-3-kuba@kernel.org>
References: <20220323233715.2104106-1-kuba@kernel.org>
         <20220323233715.2104106-3-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-03-23 at 16:37 -0700, Jakub Kicinski wrote:
> The comment about shinfo->dataref split is really unhelpful,
> at least to me. Rewrite it and render it to skb documentation.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/index.rst  |  1 +
>  Documentation/networking/skbuff.rst |  6 ++++++
>  include/linux/skbuff.h              | 33 +++++++++++++++++++----------
>  3 files changed, 29 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> index ce017136ab05..1b3c45add20d 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -96,6 +96,7 @@ Linux Networking Documentation
>     sctp
>     secid
>     seg6-sysctl
> +   skbuff
>     smc-sysctl
>     statistics
>     strparser
> diff --git a/Documentation/networking/skbuff.rst b/Documentation/networking/skbuff.rst
> index 7c6be64f486a..581e5561c362 100644
> --- a/Documentation/networking/skbuff.rst
> +++ b/Documentation/networking/skbuff.rst
> @@ -23,3 +23,9 @@ skb_clone() allows for fast duplication of skbs. None of the data buffers
>  get copied, but caller gets a new metadata struct (struct sk_buff).
>  &skb_shared_info.refcount indicates the number of skbs pointing at the same
>  packet data (i.e. clones).
> +
> +dataref and headerless skbs
> +---------------------------
> +
> +.. kernel-doc:: include/linux/skbuff.h
> +   :doc: dataref and headerless skbs
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 5431be4aa309..5b838350931c 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -691,16 +691,25 @@ struct skb_shared_info {
>  	skb_frag_t	frags[MAX_SKB_FRAGS];
>  };
>  
> -/* We divide dataref into two halves.  The higher 16 bits hold references
> - * to the payload part of skb->data.  The lower 16 bits hold references to
> - * the entire skb->data.  A clone of a headerless skb holds the length of
> - * the header in skb->hdr_len.
> +/**
> + * DOC: dataref and headerless skbs
> + *
> + * Transport layers send out clones of data skbs they hold for retransmissions.
> + * To allow lower layers of the stack to prepend their headers
> + * we split &skb_shared_info.dataref into two halves.
> + * The lower 16 bits count the overall number of references.
> + * The higher 16 bits indicate number of data-only references.
> + * skb_header_cloned() checks if skb is allowed to add / write the headers.

Thank you very much for the IMHO much needed documentation!

Please allow me to do some non-native-english-speaker biased comments;)

The previous patch uses the form  "payload data" instead of data-only,
I think it would be clearer using consistently one or the other. I
personally would go for "payload-data-only" (which is probably a good
reason to pick a different option).

>   *
> - * All users must obey the rule that the skb->data reference count must be
> - * greater than or equal to the payload reference count.
> + * The creator of the skb (e.g. TCP) marks its data-only skb as &sk_buff.nohdr
> + * (via __skb_header_release()). Any clone created from marked skb will get
> + * &sk_buff.hdr_len populated with the available headroom.
> + * If it's the only clone in existence it's able to modify the headroom at will.

I think it would be great if we explicitly list the expected sequence,
e.g.
	<alloc skb>
	skb_reserve
	__skb_header_release
	skb_clone


Thanks!

Paolo

