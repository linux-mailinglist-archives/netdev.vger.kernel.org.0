Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB25B67C7
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 18:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbfIRQLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 12:11:12 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:37144 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729946AbfIRQLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 12:11:12 -0400
Received: by mail-yb1-f193.google.com with SMTP id v5so215263ybq.4
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 09:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UQ3zy25mwvmwBxmhPUCNskO7vU7BjR4ap2blfEAkW4g=;
        b=AVS7wCac92TQFjYgK06E1/EATeWQmcZ4/rouAbSZr94wVxzHc9hD0nEyZfXl9zGsBx
         ZjQ78taoU7y80tT/r1SPVjsSw5G61wKHCOrXHc1vDuxiB3TT7EDhGM37vTURjztKjEMf
         J9Ycu5OKh8BNynePTRfPJlc3tBAE1IDsZoJhWYy9/yAU9N0sINljeQmVC/CN4GSDIxM0
         SInFrcOy/0iaGr0jEHItO+eljFVEx0gELB3uFX6s8UTIhzzk2j62V59A2BN4ia+NGW52
         8NvL77r6N87pOgT0iHHHhiTnofMK4NdDGZ1yIQwArUhSgEPye3LnBFSK0UwYIbhU5ne+
         yaxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UQ3zy25mwvmwBxmhPUCNskO7vU7BjR4ap2blfEAkW4g=;
        b=oRFOUqmmq5E0B7C/XA0iztDXsHW+uF5tjUhByNJVoP5c5MFUhGQkvP/3U/MjikAJgs
         HtllfyRiPfq3JVhffNZJYfwUOVPrphBy0+VSbjzkqCZaap2nfEY9MHQ/ns595mZ7/Idq
         FH3ZA34fPABv3M3gHGJzuhcg9ft8pIpshQhYMbGH4FDppnWKQ9sfMrXZQElndQw3IEMj
         J/cVD6Z6DEdQ3CweJMcbWI6ByF33W1uc35MWtvWYiv8JmBfEdQ2KBxoaCidtgy59hXOU
         XBXqm+W9F5Fe2HqxZTQ1XelqOAaIZwllrhqoMZI8L3VZWn9tN0ISjOk8kATsDkpT/jSb
         cTTQ==
X-Gm-Message-State: APjAAAVab9A1sYTwi6Ffy7as61+1PgwywmQnpdsZ7etKQFp8I/csliSJ
        NHhzVrOTRebuipl6wFdwTzdWQm7C
X-Google-Smtp-Source: APXvYqxNJlpv1LcyeA9DgPrrbmBVpUwGiGP17Sh5uPcUWDzRB5sSvNNEC8QUVs9pJZB5PCXr+s4yGg==
X-Received: by 2002:a5b:b83:: with SMTP id l3mr3113754ybq.78.1568823071028;
        Wed, 18 Sep 2019 09:11:11 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id 137sm1289715ywp.64.2019.09.18.09.11.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 09:11:09 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id m143so200159ybf.10
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 09:11:09 -0700 (PDT)
X-Received: by 2002:a25:774d:: with SMTP id s74mr3442298ybc.473.1568823068856;
 Wed, 18 Sep 2019 09:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190918072517.16037-1-steffen.klassert@secunet.com> <20190918072517.16037-3-steffen.klassert@secunet.com>
In-Reply-To: <20190918072517.16037-3-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 18 Sep 2019 12:10:31 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeBmGY4_2X3Ydhf60G=An9g9iikDBQMDji=XptN_jBqiw@mail.gmail.com>
Message-ID: <CA+FuTSeBmGY4_2X3Ydhf60G=An9g9iikDBQMDji=XptN_jBqiw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 2/5] net: Add NETIF_F_GRO_LIST feature
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This adds a new NETIF_F_GRO_LIST feature flag. I will be used
> to configure listfyed GRO what will be implemented with some
> followup paches.

This should probably simultaneously introduce SKB_GSO_FRAGLIST as well
as a BUILD_BUG_ON in net_gso_ok.

Please also in the commit describe the constraints of skbs that have
this type. If I'm not mistaken, an skb with either gso_size linear
data or one gso_sized frag, followed by a frag_list of the same. With
the exception of the last frag_list member, whose mss may be less than
gso_size. This will help when reasoning about all the types of skbs we
may see at segmentation, as we recently had to do [1]

Minor nit: I think it's listified, not listifyed.

[1] https://lore.kernel.org/netdev/CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com/

> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---



>  include/linux/netdev_features.h | 2 ++
>  net/core/ethtool.c              | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 4b19c544c59a..1b6baa1b6fe9 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -80,6 +80,7 @@ enum {
>
>         NETIF_F_GRO_HW_BIT,             /* Hardware Generic receive offload */
>         NETIF_F_HW_TLS_RECORD_BIT,      /* Offload TLS record */
> +       NETIF_F_GRO_LIST_BIT,           /* Listifyed GRO */
>
>         /*
>          * Add your fresh new feature above and remember to update
> @@ -150,6 +151,7 @@ enum {
>  #define NETIF_F_GSO_UDP_L4     __NETIF_F(GSO_UDP_L4)
>  #define NETIF_F_HW_TLS_TX      __NETIF_F(HW_TLS_TX)
>  #define NETIF_F_HW_TLS_RX      __NETIF_F(HW_TLS_RX)
> +#define NETIF_F_GRO_LIST       __NETIF_F(GRO_LIST)
>
>  /* Finds the next feature with the highest number of the range of start till 0.
>   */
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index 6288e69e94fc..ee8d2b58c2d7 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -111,6 +111,7 @@ static const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN]
>         [NETIF_F_HW_TLS_RECORD_BIT] =   "tls-hw-record",
>         [NETIF_F_HW_TLS_TX_BIT] =        "tls-hw-tx-offload",
>         [NETIF_F_HW_TLS_RX_BIT] =        "tls-hw-rx-offload",
> +       [NETIF_F_GRO_LIST_BIT] =         "rx-gro-list",
>  };
>
>  static const char
> --
> 2.17.1
>
