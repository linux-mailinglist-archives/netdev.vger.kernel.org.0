Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E6E643CB9
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 06:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiLFFhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 00:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiLFFhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 00:37:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92FA2316B
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 21:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670305017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aGf+n7swUP938avvj0fLNXXsZ8wfvRCN78Z75W64+7I=;
        b=UcmlFx+3r49OP/GUD5qzD8uWwSM41A2eZinzQCW8oPXvXHH3XB9aZEW3JXi0LPMrurBJ7p
        VAy+h9/XsTVej08nzt7WpFOmLO4Xo130nmflT82UmV+HzQI1X1XlCBgYsoxuUjVcL6idh7
        MZM77Hp2Nmg6zLurMw91K4BqPVlP4FA=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-632-kRLIBXnyMqq8rWSTqT1FVw-1; Tue, 06 Dec 2022 00:36:56 -0500
X-MC-Unique: kRLIBXnyMqq8rWSTqT1FVw-1
Received: by mail-ot1-f72.google.com with SMTP id cd15-20020a056830620f00b0066e293d93caso7801087otb.8
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 21:36:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aGf+n7swUP938avvj0fLNXXsZ8wfvRCN78Z75W64+7I=;
        b=ipgoPuSgYAsdEdFUYN/sfvPp0yJXwgPKTcRJz5oKJiq1vxPmBn5TjFf6X8g2+dvmND
         PN29NeW3L07aSjtywE4NsOExxA2qU9AW1W/AMvbwUAzybaL1IJGZ39AlGuq/DhDXawUq
         PnesPp1zMjRK76Y2TLakwCv2HXwk/rAF76TieSJnMwzaUhUGtUjvg6hq813gclSyzG0j
         WXb7XvFgIS9bOMNEPNB7XyhBbYk2W2r5bIKswtOWvcuR1bRHZPYZnCQVt0tJ5oJF67LB
         78sdfrZizBgh6HIq/YaYnWshrf1ncXOweSnz2/qhgvSkN637GiywGSsY9VKbWWvfm26k
         GSgQ==
X-Gm-Message-State: ANoB5pn7DsQyioG7e8/yN0PkuHgF58s0EgLKrlPsOcMzfZheJcc/9ijx
        aCw1Rax+t//RcFeRnrSgk9OOL0b5fatOev63jYsbKTxbvK7HI9jKY/YuU7C7+ODaHV4epAgPxGZ
        YaQw6Kbxq4fWZyn/54ZeXW4Y2zbzkfkOw
X-Received: by 2002:a05:6870:b9b:b0:144:b22a:38d3 with SMTP id lg27-20020a0568700b9b00b00144b22a38d3mr2694050oab.280.1670305015850;
        Mon, 05 Dec 2022 21:36:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf710dHA0BS28suZfHCeNCq61zm45mTKYpYjGXttsHVhtKiZjRmsAY6oVnpexzcjpux6s3l6T4EsDUeOvzVvKtA=
X-Received: by 2002:a05:6870:b9b:b0:144:b22a:38d3 with SMTP id
 lg27-20020a0568700b9b00b00144b22a38d3mr2694040oab.280.1670305015619; Mon, 05
 Dec 2022 21:36:55 -0800 (PST)
MIME-Version: 1.0
References: <20221122074348.88601-1-hengqi@linux.alibaba.com> <20221122074348.88601-5-hengqi@linux.alibaba.com>
In-Reply-To: <20221122074348.88601-5-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 6 Dec 2022 13:36:44 +0800
Message-ID: <CACGkMEsvKFBCfwsv1J5gXW6anQOZGuJfWPm9ku6v8i_BbWjLCw@mail.gmail.com>
Subject: Re: [RFC PATCH 4/9] virtio_net: remove xdp related info from page_to_skb()
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
> For the clear construction of multi-buffer xdp_buff, we now remove the xdp
> processing interleaved with page_to_skb() before, and the logic of xdp and
> building skb from xdp will be separate and independent.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

So I think the organization of this series needs some tweak.

If I was not not and if we do things like this, XDP support is
actually broken and it breaks bisection and a lot of other things.

We need make sure each patch does not break anything, it probably requires

1) squash the following patches or
2) having a new helper to do XDP stuffs after/before page_to_skb()

Thanks

> ---
>  drivers/net/virtio_net.c | 41 +++++++++-------------------------------
>  1 file changed, 9 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index d3e8c63b9c4b..cd65f85d5075 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -439,9 +439,7 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
>  static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>                                    struct receive_queue *rq,
>                                    struct page *page, unsigned int offset,
> -                                  unsigned int len, unsigned int truesize,
> -                                  bool hdr_valid, unsigned int metasize,
> -                                  unsigned int headroom)
> +                                  unsigned int len, unsigned int truesize)
>  {
>         struct sk_buff *skb;
>         struct virtio_net_hdr_mrg_rxbuf *hdr;
> @@ -459,21 +457,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>         else
>                 hdr_padded_len = sizeof(struct padded_vnet_hdr);
>
> -       /* If headroom is not 0, there is an offset between the beginning of the
> -        * data and the allocated space, otherwise the data and the allocated
> -        * space are aligned.
> -        *
> -        * Buffers with headroom use PAGE_SIZE as alloc size, see
> -        * add_recvbuf_mergeable() + get_mergeable_buf_len()
> -        */
> -       truesize = headroom ? PAGE_SIZE : truesize;
> -       tailroom = truesize - headroom;
> -       buf = p - headroom;
> -
> +       buf = p;
>         len -= hdr_len;
>         offset += hdr_padded_len;
>         p += hdr_padded_len;
> -       tailroom -= hdr_padded_len + len;
> +       tailroom = truesize - hdr_padded_len - len;
>
>         shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>
> @@ -503,7 +491,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>         if (len <= skb_tailroom(skb))
>                 copy = len;
>         else
> -               copy = ETH_HLEN + metasize;
> +               copy = ETH_HLEN;
>         skb_put_data(skb, p, copy);
>
>         len -= copy;
> @@ -542,19 +530,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>                 give_pages(rq, page);
>
>  ok:
> -       /* hdr_valid means no XDP, so we can copy the vnet header */
> -       if (hdr_valid) {
> -               hdr = skb_vnet_hdr(skb);
> -               memcpy(hdr, hdr_p, hdr_len);
> -       }
> +       hdr = skb_vnet_hdr(skb);
> +       memcpy(hdr, hdr_p, hdr_len);
>         if (page_to_free)
>                 put_page(page_to_free);
>
> -       if (metasize) {
> -               __skb_pull(skb, metasize);
> -               skb_metadata_set(skb, metasize);
> -       }
> -
>         return skb;
>  }
>
> @@ -917,7 +897,7 @@ static struct sk_buff *receive_big(struct net_device *dev,
>  {
>         struct page *page = buf;
>         struct sk_buff *skb =
> -               page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 0);
> +               page_to_skb(vi, rq, page, 0, len, PAGE_SIZE);
>
>         stats->bytes += len - vi->hdr_len;
>         if (unlikely(!skb))
> @@ -1060,9 +1040,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>                                 rcu_read_unlock();
>                                 put_page(page);
>                                 head_skb = page_to_skb(vi, rq, xdp_page, offset,
> -                                                      len, PAGE_SIZE, false,
> -                                                      metasize,
> -                                                      headroom);
> +                                                      len, PAGE_SIZE);
>                                 return head_skb;
>                         }
>                         break;
> @@ -1116,8 +1094,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>         rcu_read_unlock();
>
>  skip_xdp:
> -       head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
> -                              metasize, headroom);
> +       head_skb = page_to_skb(vi, rq, page, offset, len, truesize);
>         curr_skb = head_skb;
>
>         if (unlikely(!curr_skb))
> --
> 2.19.1.6.gb485710b
>

