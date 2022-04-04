Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758094F12E9
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242129AbiDDKRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356761AbiDDKRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:17:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 903FB2B1B6
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 03:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649067351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tkadsSkOjK69IKBzXKLPhJkIYMQazPSW8bFoteNrRDk=;
        b=S7xfjBRu10TW8slfc87isXsdE+W2rU3mVGbdnt1TxgfPZaoU75pgICWi/wZl/pW3fZm+29
        hropMfvxOwEDb1y2PTAit5MtsZblQa4THGc09Bk7h9FR2ZolSoq1V2gvPzrApYJet82cZA
        e2mMLi6+xjyzYsBoUpLpUr6tQupM+jU=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-_NwVDug2Mu-lNaZP6_tA-Q-1; Mon, 04 Apr 2022 06:15:50 -0400
X-MC-Unique: _NwVDug2Mu-lNaZP6_tA-Q-1
Received: by mail-yb1-f198.google.com with SMTP id n207-20020a25d6d8000000b0063bd7a74ae4so7353875ybg.21
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 03:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tkadsSkOjK69IKBzXKLPhJkIYMQazPSW8bFoteNrRDk=;
        b=V521SogWqVeREAnZOfiNnesfke6e+ypP5P3aX6mEmVoy7R7PNHvJNvr/fcjjk8cKf4
         ciKUkUERnvsb6LBwv2UmwW74xoa3oWW2wno03iIH3ww1X/6deu9T9nZtI0s/g1aJhAtf
         liRrBtIdnMeiDKyuIFYbaEFEcXu8pz/3WoMpeGLRVizYVtXXkr08t9c8V7BcpK24cFb7
         9w4hd2GIE5eNKa6fkrS+JkX1grGABWhyQpP+tBHLXf2/9uSDwKIgKVp71cDsQGuV8sWP
         1Z//aEhAhxde7RMiC57BJ28Et5UDLdXgTCKZsoyjW9RihYqwYsKqNyxlTL5ziqv58BXj
         Gg9Q==
X-Gm-Message-State: AOAM5332ZcUUh/UmDXA3MobHVmIlel0AaaOp2pmk8OSiRSPtbxA6WWoK
        0BmJELblFfgPZfM4vw6OAfoGnWfGbM8XbmF2YzdZM4TWtHvOVxTLsGrgbKs62f3ySLzm1n6+EIA
        Axx69pSBUWMgTvp5sxYqyloFNvmdXvxgm
X-Received: by 2002:a05:6902:1351:b0:63d:d3ae:da8d with SMTP id g17-20020a056902135100b0063dd3aeda8dmr3484100ybu.445.1649067350034;
        Mon, 04 Apr 2022 03:15:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/FA2nG9CkjljMIizKp+3/BvFXdYTIKnSCHt2T/Y90OrnODavbrP29hqG+N35/79K//FRULtfAcH3chse8oaE=
X-Received: by 2002:a05:6902:1351:b0:63d:d3ae:da8d with SMTP id
 g17-20020a056902135100b0063dd3aeda8dmr3484083ybu.445.1649067349845; Mon, 04
 Apr 2022 03:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com>
In-Reply-To: <a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 4 Apr 2022 12:15:38 +0200
Message-ID: <CAFqZXNt=Ca+x7PaYgc1jXq-3cKxin-_=UNCSiyVHjbP7OYUKvA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: use the correct skb for security_sctp_assoc_request
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding LSM and SELinux lists to CC for awareness; the original patch
is available at:
https://lore.kernel.org/netdev/a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com/T/
https://patchwork.kernel.org/project/netdevbpf/patch/a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com/

On Mon, Apr 4, 2022 at 3:53 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> Yi Chen reported an unexpected sctp connection abort, and it occurred when
> COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
> is included in chunk->head_skb instead of chunk->skb, it failed to check
> IP header version in security_sctp_assoc_request().
>
> According to Ondrej, SELinux only looks at IP header (address and IPsec
> options) and XFRM state data, and these are all included in head_skb for
> SCTP HW GSO packets. So fix it by using head_skb when calling
> security_sctp_assoc_request() in processing COOKIE_ECHO.

The logic looks good to me, but I still have one unanswered concern.
The head_skb member of struct sctp_chunk is defined inside a union:

struct sctp_chunk {
        [...]
        union {
                /* In case of GSO packets, this will store the head one */
                struct sk_buff *head_skb;
                /* In case of auth enabled, this will point to the shkey */
                struct sctp_shared_key *shkey;
        };
        [...]
};

What guarantees that this chunk doesn't have "auth enabled" and the
head_skb pointer isn't actually a non-NULL shkey pointer? Maybe it's
obvious to a Linux SCTP expert, but at least for me as an outsider it
isn't - that's usually a good hint that there should be a code comment
explaining it.

>
> Fixes: e215dab1c490 ("security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce")
> Reported-by: Yi Chen <yiche@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/sm_statefuns.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 7f342bc12735..883f9b849ee5 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -781,7 +781,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
>                 }
>         }
>
> -       if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
> +       if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
>                 sctp_association_free(new_asoc);
>                 return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>         }
> @@ -2262,7 +2262,7 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
>         }
>
>         /* Update socket peer label if first association. */
> -       if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
> +       if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
>                 sctp_association_free(new_asoc);
>                 return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>         }
> --
> 2.31.1
>

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

