Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC184AE342
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386414AbiBHWVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386605AbiBHU7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 15:59:06 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23679C0612C3
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 12:59:05 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id w18so252808uar.8
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 12:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NxB7BzC6ZAoAU/UTQQPI/XYwGHJmUDw1BkVBGKXBE4c=;
        b=Y3dHeM9K1rCwczLjQBwnOlwAC1lSGX6KBBSSvc9OyYXm6MqTlm+Arx3JxBqbvT2562
         W0x2T60xfaRmhG7hTPmRYxjsLOT4FN+LbwHOE0BH68Xi/mXCfSwaGROEhPdmrgqDlHqJ
         JPRWBGOJQ1PS76ChpBJzY0tx4VNWTjdTb5fVBwWSghrT8vsr7qedw4jQ2c13cNgs/aAc
         e+yl1ENT+jlXNFeDSWDJK7+ZX7++Mr0D+/gQpLUqOG41iNLxTrInsNBCQIyOYpRI8+tI
         gAz2GORpxqQe3vUVD0C0We+OO0BwCa4LDGZN8KtEOfBlMnFIXOa75bonu1iLcDzr68hi
         cOrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NxB7BzC6ZAoAU/UTQQPI/XYwGHJmUDw1BkVBGKXBE4c=;
        b=cxLnEmoGfvmSmpxL4x2grtiZTdknJK3d/T+gXXNFOn7sCm/+7dF31HADt/VAvItQ3C
         8ztMS55mLW9FJGued1PPlgDFCSCPUZB6l50Km0py1PxZueS0kATeNTU09egHBUF2LXXV
         nN6ZQkA2rthLE8rE3D1mqxCXCBOZUwaTUDK7QZpDHtrYv/CpK866FrnVkSATXGtueG4r
         5muyI7uFPtfQ6/dPiJ+J82P6PDkY/Z0I/4pUquFf+2PqM57WujirHButtoEB8QPkvIcy
         gi8LeXb+kTFsCUWmsyjrDHpb2bagByF47/o27ZufOBLjd4PWvH8VfkD5wB+SfoRUSps8
         KfNw==
X-Gm-Message-State: AOAM532N9BMg1NlHW7E3LUQQsde3HDccCNpsQWTwAYzZmx7RLecu6rlJ
        5QQjDZswZ87bYXpzMxgoWHiWbJThTn98mw==
X-Google-Smtp-Source: ABdhPJzdyK6Qg5EHAMsfwPRGrRbk7O75nJy5WHeAhfMg3HV7hAziSM0X1sZPyBUIiJ7f87C8hXTTeQ==
X-Received: by 2002:ab0:3c86:: with SMTP id a6mr2756131uax.6.1644353944280;
        Tue, 08 Feb 2022 12:59:04 -0800 (PST)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id l72sm2986079vkl.34.2022.02.08.12.59.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 12:59:03 -0800 (PST)
Received: by mail-ua1-f41.google.com with SMTP id 103so261696uag.4
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 12:59:03 -0800 (PST)
X-Received: by 2002:ab0:384c:: with SMTP id h12mr2198570uaw.122.1644353943533;
 Tue, 08 Feb 2022 12:59:03 -0800 (PST)
MIME-Version: 1.0
References: <20220208181510.787069-1-andrew@daynix.com> <20220208181510.787069-5-andrew@daynix.com>
In-Reply-To: <20220208181510.787069-5-andrew@daynix.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Feb 2022 15:58:27 -0500
X-Gmail-Original-Message-ID: <CA+FuTScRp5hhkvETuVRsUxMRCZVU0wVrmd5_=a5UoKNLDv4LnA@mail.gmail.com>
Message-ID: <CA+FuTScRp5hhkvETuVRsUxMRCZVU0wVrmd5_=a5UoKNLDv4LnA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] drivers/net/virtio_net: Added RSS hash report control.
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com, yan@daynix.com,
        yuri.benditovich@daynix.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 1:19 PM Andrew Melnychenko <andrew@daynix.com> wrote:
>
> Now it's possible to control supported hashflows.
> Added hashflow set/get callbacks.
> Also, disabling RXH_IP_SRC/DST for TCP would disable then for UDP.

I don't follow this comment. Can you elaborate?

> TCP and UDP supports only:
> ethtool -U eth0 rx-flow-hash tcp4 sd
>     RXH_IP_SRC + RXH_IP_DST
> ethtool -U eth0 rx-flow-hash tcp4 sdfn
>     RXH_IP_SRC + RXH_IP_DST + RXH_L4_B_0_1 + RXH_L4_B_2_3
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>  drivers/net/virtio_net.c | 141 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 140 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 543da2fbdd2d..88759d5e693c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -231,6 +231,7 @@ struct virtnet_info {
>         u8 rss_key_size;
>         u16 rss_indir_table_size;
>         u32 rss_hash_types_supported;
> +       u32 rss_hash_types_saved;

hash_types_active?

> +static bool virtnet_set_hashflow(struct virtnet_info *vi, struct ethtool_rxnfc *info)
> +{
> +       u32 new_hashtypes = vi->rss_hash_types_saved;
> +       bool is_disable = info->data & RXH_DISCARD;
> +       bool is_l4 = info->data == (RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3);
> +
> +       /* supports only 'sd', 'sdfn' and 'r' */
> +       if (!((info->data == (RXH_IP_SRC | RXH_IP_DST)) | is_l4 | is_disable))

maybe add an is_l3

> +               return false;
> +
> +       switch (info->flow_type) {
> +       case TCP_V4_FLOW:
> +               new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv4 | VIRTIO_NET_RSS_HASH_TYPE_TCPv4);
> +               if (!is_disable)
> +                       new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4
> +                               | (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_TCPv4 : 0);
> +               break;
> +       case UDP_V4_FLOW:
> +               new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv4 | VIRTIO_NET_RSS_HASH_TYPE_UDPv4);
> +               if (!is_disable)
> +                       new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv4
> +                               | (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_UDPv4 : 0);
> +               break;
> +       case IPV4_FLOW:
> +               new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv4;
> +               if (!is_disable)
> +                       new_hashtypes = VIRTIO_NET_RSS_HASH_TYPE_IPv4;
> +               break;
> +       case TCP_V6_FLOW:
> +               new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv6 | VIRTIO_NET_RSS_HASH_TYPE_TCPv6);
> +               if (!is_disable)
> +                       new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6
> +                               | (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_TCPv6 : 0);
> +               break;
> +       case UDP_V6_FLOW:
> +               new_hashtypes &= ~(VIRTIO_NET_RSS_HASH_TYPE_IPv6 | VIRTIO_NET_RSS_HASH_TYPE_UDPv6);
> +               if (!is_disable)
> +                       new_hashtypes |= VIRTIO_NET_RSS_HASH_TYPE_IPv6
> +                               | (is_l4 ? VIRTIO_NET_RSS_HASH_TYPE_UDPv6 : 0);
> +               break;
> +       case IPV6_FLOW:
> +               new_hashtypes &= ~VIRTIO_NET_RSS_HASH_TYPE_IPv6;
> +               if (!is_disable)
> +                       new_hashtypes = VIRTIO_NET_RSS_HASH_TYPE_IPv6;
> +               break;
> +       default:
> +               /* unsupported flow */
> +               return false;
> +       }
> +
> +       /* if unsupported hashtype was set */
> +       if (new_hashtypes != (new_hashtypes & vi->rss_hash_types_supported))
> +               return false;
> +
> +       if (new_hashtypes != vi->rss_hash_types_saved) {
> +               vi->rss_hash_types_saved = new_hashtypes;

should only be updated if the commit function returned success?
