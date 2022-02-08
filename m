Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D9C4AE335
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386559AbiBHWV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386581AbiBHUzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 15:55:18 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED05C0612C3
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 12:55:16 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id b2so361184vso.9
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 12:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dav5GHwHoInVNFFUmD/+H7rFBilhhPolISX4pLfyPgs=;
        b=I35aftOGkLR/ISv6OSLuGuNra4KAzA0XXAvR3HIzqJsZ4sbzSCT6m6eUErRZTsBdRZ
         5zHFtqoTfYTj0VaC44XixtJmomtIqu6M2jaGsuJVIFo9NFo73pcMfzY6Ib6daRmOQQ6G
         s61LlDd0JuL2BDMhfXFEtfUTzv8Gb82qMMbR0G9yretQLwALK2QmdEaFwNvtCZ+xTHcw
         YsKyu3HM3enCJRsm6D5qPoryva8Zw7Tulo94jtMwvcQWakEadP5Kr9mEupdTsILy1yjH
         aZAW1pjsKR/HlEntXIBoRge+jo1q74UJiwiUyNQKf6AdaelrV1Cb0N0B5Vj6vewPaFM1
         JBSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dav5GHwHoInVNFFUmD/+H7rFBilhhPolISX4pLfyPgs=;
        b=ZLVrXznSi0vSklvkOl8TvrWNFrq+9Pr64nuL/jGUGmoEA+1TnkFgCSm+1hfWJy5Mic
         hBaj/F4wyL9sSSNOp5UiPugGO+H7oW9KFcYudY/5GXiw2Ex7HvD+PVGFqWKQe/h6pxOj
         NpKeq9H7r0U6KFHwd/GqCzi5tdx06PqHZRZCp2OITyCsElOWlF6m6XYNH/mX0IXouhqM
         0n+V7hzQFwmNTSPlVThAyZ1lMWRpOjrZfkBNKoTCLI3kSCMkVEwOsP+AbqaS3IgSI7Rx
         hIxmM1uN/QoG7/rW7JDP+lsn4XZUrfTHBLlwI+r611m/EyQWpoKn67yCXEDcYaIH635j
         hbLg==
X-Gm-Message-State: AOAM530iJjg4sLl1vRo5Kz37gKcDcDAwDNPvFKQrX0Ev5SGuZxENlf3u
        L6FC2GfxpZHp5RQRbtABybtgAuzvPtbOiQ==
X-Google-Smtp-Source: ABdhPJxdl7lGK1hkKNkX6UbFwg7WPD9zuQYZ62/VOLKB68OyIITndHkuLOqcSrgOJ3X5v4YGh0x7TA==
X-Received: by 2002:a05:6102:3e8f:: with SMTP id m15mr2237089vsv.15.1644353715642;
        Tue, 08 Feb 2022 12:55:15 -0800 (PST)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id d5sm433800vsd.19.2022.02.08.12.55.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 12:55:15 -0800 (PST)
Received: by mail-ua1-f49.google.com with SMTP id 60so263578uae.1
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 12:55:15 -0800 (PST)
X-Received: by 2002:ab0:6718:: with SMTP id q24mr1146421uam.141.1644353714675;
 Tue, 08 Feb 2022 12:55:14 -0800 (PST)
MIME-Version: 1.0
References: <20220208181510.787069-1-andrew@daynix.com> <20220208181510.787069-4-andrew@daynix.com>
In-Reply-To: <20220208181510.787069-4-andrew@daynix.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Feb 2022 15:54:38 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdrHwNWh1Mz7KT8w+Z69LcNipeTcasny6ioqOUYBisNXg@mail.gmail.com>
Message-ID: <CA+FuTSdrHwNWh1Mz7KT8w+Z69LcNipeTcasny6ioqOUYBisNXg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] drivers/net/virtio_net: Added RSS hash report.
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
> Added features for RSS hash report.
> If hash is provided - it sets to skb.
> Added checks if rss and/or hash are enabled together.
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>  drivers/net/virtio_net.c | 51 ++++++++++++++++++++++++++++++++++------
>  1 file changed, 44 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 495aed524e33..543da2fbdd2d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -227,6 +227,7 @@ struct virtnet_info {
>
>         /* Host supports rss and/or hash report */
>         bool has_rss;
> +       bool has_rss_hash_report;
>         u8 rss_key_size;
>         u16 rss_indir_table_size;
>         u32 rss_hash_types_supported;
> @@ -421,7 +422,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>
>         hdr_len = vi->hdr_len;
>         if (vi->mergeable_rx_bufs)
> -               hdr_padded_len = sizeof(*hdr);
> +               hdr_padded_len = hdr_len;

Belongs in patch 1?

>         else
>                 hdr_padded_len = sizeof(struct padded_vnet_hdr);
>
> @@ -1156,6 +1157,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>         struct net_device *dev = vi->dev;
>         struct sk_buff *skb;
>         struct virtio_net_hdr_mrg_rxbuf *hdr;
> +       struct virtio_net_hdr_v1_hash *hdr_hash;
> +       enum pkt_hash_types rss_hash_type;
>
>         if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
>                 pr_debug("%s: short packet %i\n", dev->name, len);
> @@ -1182,6 +1185,29 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>                 return;
>
>         hdr = skb_vnet_hdr(skb);
> +       if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report) {

Can the first be true if the second is not?

> +               hdr_hash = (struct virtio_net_hdr_v1_hash *)(hdr);
> +
> +               switch (hdr_hash->hash_report) {
> +               case VIRTIO_NET_HASH_REPORT_TCPv4:
> +               case VIRTIO_NET_HASH_REPORT_UDPv4:
> +               case VIRTIO_NET_HASH_REPORT_TCPv6:
> +               case VIRTIO_NET_HASH_REPORT_UDPv6:
> +               case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
> +               case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
> +                       rss_hash_type = PKT_HASH_TYPE_L4;
> +                       break;
> +               case VIRTIO_NET_HASH_REPORT_IPv4:
> +               case VIRTIO_NET_HASH_REPORT_IPv6:
> +               case VIRTIO_NET_HASH_REPORT_IPv6_EX:
> +                       rss_hash_type = PKT_HASH_TYPE_L3;
> +                       break;
> +               case VIRTIO_NET_HASH_REPORT_NONE:
> +               default:
> +                       rss_hash_type = PKT_HASH_TYPE_NONE;
> +               }
> +               skb_set_hash(skb, hdr_hash->hash_value, rss_hash_type);
> +       }

so many lines, perhaps deserves a helper function

>
>         if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
>                 skb->ip_summed = CHECKSUM_UNNECESSARY;
> @@ -2232,7 +2258,8 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
>         sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
>
>         if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
> -                                 VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
> +                                 vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CONFIG
> +                                 : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs)) {
>                 dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
>                 return false;
>         }
> @@ -3230,6 +3257,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
>                              "VIRTIO_NET_F_CTRL_VQ") ||
>              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
> +                            "VIRTIO_NET_F_CTRL_VQ") ||
> +            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
>                              "VIRTIO_NET_F_CTRL_VQ"))) {
>                 return false;
>         }
> @@ -3365,8 +3394,13 @@ static int virtnet_probe(struct virtio_device *vdev)
>         if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>                 vi->mergeable_rx_bufs = true;
>
> -       if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
> +       if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
> +               vi->has_rss_hash_report = true;
> +
> +       if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
>                 vi->has_rss = true;
> +
> +       if (vi->has_rss || vi->has_rss_hash_report) {
>                 vi->rss_indir_table_size =
>                         virtio_cread16(vdev, offsetof(struct virtio_net_config,

should indir table size be zero if only hash report is enabled?

>                                 rss_max_indirection_table_length));
> @@ -3382,8 +3416,11 @@ static int virtnet_probe(struct virtio_device *vdev)
>
>                 dev->hw_features |= NETIF_F_RXHASH;
>         }
> -       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
> -           virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> +
> +       if (vi->has_rss_hash_report)
> +               vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
> +       else if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
> +                virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
>                 vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
>         else
>                 vi->hdr_len = sizeof(struct virtio_net_hdr);
> @@ -3450,7 +3487,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>                 }
>         }
>
> -       if (vi->has_rss)
> +       if (vi->has_rss || vi->has_rss_hash_report)
>                 virtnet_init_default_rss(vi);
>
>         err = register_netdev(dev);
> @@ -3585,7 +3622,7 @@ static struct virtio_device_id id_table[] = {
>         VIRTIO_NET_F_CTRL_MAC_ADDR, \
>         VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>         VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -       VIRTIO_NET_F_RSS
> +       VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
>
>  static unsigned int features[] = {
>         VIRTNET_FEATURES,
> --
> 2.34.1
>
