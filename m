Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE13033C112
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhCOQDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbhCOQCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:02:43 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B236DC06175F;
        Mon, 15 Mar 2021 09:02:43 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id v14so9802064ilj.11;
        Mon, 15 Mar 2021 09:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f2HFBE8AaJy/4EvQxK/BPKk9PZCRYtcDhtTRTzSdk34=;
        b=MLXeSHTy2A7E023rua6s1hzW9UBokFnQWuurf5ErGlLdtJGLCe0oRblU372tpT1hxv
         Ds5O/bhZpOZGah/mGJNHOBa/BCx6UemP7dOZ6pXxbWyLOq88iCAG2O1gQwhDkyevrY/l
         hMGMK3wSQD46qQBzsr1ML84JMw6TucgAwizu4qwV7hOqqg/dJcQTiTzGjOtXI97JL9OM
         7DWJC8Od9qmIRjTtq7M8N5X2SnlOtucaet9SYti3JCaKR9YLLMgsI/+ctv54srdL0BcN
         K76ihSG9yNK3yceIbaK9lyaPW4YIFFDU+fx97uxo23qadD9M2NCorQk2VjF//9+EADj8
         3H1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f2HFBE8AaJy/4EvQxK/BPKk9PZCRYtcDhtTRTzSdk34=;
        b=WaTEs0G1wY0bJEXAxbPDtcEZkVhbyf6AqKwoyaZroKPW+YYwlFvg0uoxm3H4DBe7hp
         r6IZOpHXtQ8klP75e+Ic4i5+I6qJARExEwDOt8ZM2Z+pi4Q7y7kbIXdXZ5wMX6MHvhJX
         DYDH1qgeotvF+HoCtDwnRJgR1rfQrUsSTfy6DcAbBiUTo1vw5gLWK8WH6KLd0AShNgVg
         9aPmUiG0IG1cyUgU9iDgjc/4j1YkRTcTemckmSXkTJ8STxJ4XbcQSJYN2u5PkfyxGg9u
         ZQPQNrJiXNchPgHAhDSSewk4Ggqss1rZT4pYjfcUXW3gjGUEBO0UiD53n6xNlYERVo4u
         dY7g==
X-Gm-Message-State: AOAM532TUFd3+2HGgcJNWjPYQrEIFLiWfSsZDkjdoE8DrHp110Rg46uo
        74hpIqo7jwfoGUWceDloy6k03QEKCVSNUakWCacBz1dtpLw=
X-Google-Smtp-Source: ABdhPJyQsyq7jfLMuXqSIlTWnKQgz1mnMD5PYIdx0NPTC4IEFhTplZOXgFToC85KEkfZMtZnrKVTIHZJp2jpTPHymtE=
X-Received: by 2002:a05:6e02:1069:: with SMTP id q9mr220297ilj.97.1615824163067;
 Mon, 15 Mar 2021 09:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210315133455.1576188-1-elder@linaro.org> <20210315133455.1576188-3-elder@linaro.org>
In-Reply-To: <20210315133455.1576188-3-elder@linaro.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 15 Mar 2021 09:02:32 -0700
Message-ID: <CAKgT0UetEDOgKmke7gA1MEmFBKpErcd9XZ0koe-LhCF_xW4=LA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/6] net: qualcomm: rmnet: simplify some byte
 order logic
To:     Alex Elder <elder@linaro.org>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        stranche@codeaurora.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, sharathv@codeaurora.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, David Laight <David.Laight@aculab.com>,
        Vladimir Oltean <olteanv@gmail.com>, elder@kernel.org,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 6:36 AM Alex Elder <elder@linaro.org> wrote:
>
> In rmnet_map_ipv4_ul_csum_header() and rmnet_map_ipv6_ul_csum_header()
> the offset within a packet at which checksumming should commence is
> calculated.  This calculation involves byte swapping and a forced type
> conversion that makes it hard to understand.
>
> Simplify this by computing the offset in host byte order, then
> converting the result when assigning it into the header field.
>
> Signed-off-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 22 ++++++++++---------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index 21d38167f9618..bd1aa11c9ce59 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -197,12 +197,13 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
>                               struct rmnet_map_ul_csum_header *ul_header,
>                               struct sk_buff *skb)
>  {
> -       struct iphdr *ip4h = (struct iphdr *)iphdr;
> -       __be16 *hdr = (__be16 *)ul_header, offset;
> +       __be16 *hdr = (__be16 *)ul_header;
> +       struct iphdr *ip4h = iphdr;
> +       u16 offset;
> +
> +       offset = skb_transport_header(skb) - (unsigned char *)iphdr;
> +       ul_header->csum_start_offset = htons(offset);

Rather than using skb_transport_header the correct pointer to use is
probably skb_checksum_start. The two are essentially synonymous but
the checksumming code is supposed to use skb_checksum_start.

Alternatively you could look at possibly using skb_network_header_len
as that would be the same value assuming that both headers are the
outer headers. Then you could avoid the extra pointer overhead.

>
> -       offset = htons((__force u16)(skb_transport_header(skb) -
> -                                    (unsigned char *)iphdr));
> -       ul_header->csum_start_offset = offset;
>         ul_header->csum_insert_offset = skb->csum_offset;
>         ul_header->csum_enabled = 1;
>         if (ip4h->protocol == IPPROTO_UDP)
> @@ -239,12 +240,13 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
>                               struct rmnet_map_ul_csum_header *ul_header,
>                               struct sk_buff *skb)
>  {
> -       struct ipv6hdr *ip6h = (struct ipv6hdr *)ip6hdr;
> -       __be16 *hdr = (__be16 *)ul_header, offset;
> +       __be16 *hdr = (__be16 *)ul_header;
> +       struct ipv6hdr *ip6h = ip6hdr;
> +       u16 offset;
> +
> +       offset = skb_transport_header(skb) - (unsigned char *)ip6hdr;
> +       ul_header->csum_start_offset = htons(offset);

Same here.

>
> -       offset = htons((__force u16)(skb_transport_header(skb) -
> -                                    (unsigned char *)ip6hdr));
> -       ul_header->csum_start_offset = offset;
>         ul_header->csum_insert_offset = skb->csum_offset;
>         ul_header->csum_enabled = 1;
>
> --
> 2.27.0
>
