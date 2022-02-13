Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3774B3C5F
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 18:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbiBMRIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 12:08:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbiBMRIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 12:08:40 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939C649680
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 09:08:33 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id u3so15077150oiv.12
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 09:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ddTopwiOGudbD9c0a1S+23MlMo36ot+qZJddmpaLkno=;
        b=10QNQxhBItsEVnI9uWuTdUg1N8XxitvYvB6ISMdKdA6/icQ88LLUBFxcdcPqR+6zs2
         xBfa9AWa1Sr7eef5v45RJnVrvCkVoSzxtqCXLx+N/rWMUOpMRjX/NNMdJXc3PQ5+uwEU
         J4zuED6wDY5ShU6pzYHB/wrfHTXWpNNsJ64I8n4n5oImdktZTLA3OpZ+Lf/GZZiWDS4l
         pxq7L0rYCQl6hK0OnvvEdfYwo7o6KYl/UUHc7R8XIudFXKwadJKgtJRhCbb6VL+qgqkH
         j0WuFjrsfd0eSptRIbcptITiXIS+jxSkG3VzZzx0nFvQ70+lZoN6nqXTo/WXmCTN5+QQ
         6/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ddTopwiOGudbD9c0a1S+23MlMo36ot+qZJddmpaLkno=;
        b=OXyoZuCD154wzTqz8xubAnanbiJbIE5R4kqam9oXEn3X5FYUZydfEGgUfXkaI5TjvO
         ePk0Wcbn0xIOe0O61HKZHdxANmfKGroW6aXJNPYz1oaoQXxpyraei/Ng5JbCIT3jGJpn
         MIu4cq06BYEE5GPYk9lnYS7q3NCsPrlNYVCRhBw4MeIPZHGrkAg5sCwQ/hgIWwvX2env
         GPeADpK5Da6eWNEuEQwzl5GR6iLdRtLaUOneisUj13TpE/kMmGkhVn8NmLjI9hkCq0Ja
         HDIExzf9uw7kV8DeoDu01CRyxzBQH7lN1BodeB4it5zvlw5vVzZidWyZghHQS11MRgn1
         Q9ZA==
X-Gm-Message-State: AOAM531lopZIXQnkBElN5LeoGTx4EPnIjnK5i/JnM1bg1868AHRUqD06
        hWHj15I+qYk2DqtTYwTC/8yFTVA4+AfE9JoHcqN2Mg==
X-Google-Smtp-Source: ABdhPJx6F8OPpe1PPrZyszS/d8TyHzUHd9dKhENhV4//VQzt2tEHJaVAXRekVPgnJuRKyRH5j6Wzt0gKKGcEGFpF318=
X-Received: by 2002:a05:6808:1206:: with SMTP id a6mr4162215oil.279.1644772112850;
 Sun, 13 Feb 2022 09:08:32 -0800 (PST)
MIME-Version: 1.0
References: <20220208181510.787069-1-andrew@daynix.com> <20220208181510.787069-4-andrew@daynix.com>
 <CA+FuTSdrHwNWh1Mz7KT8w+Z69LcNipeTcasny6ioqOUYBisNXg@mail.gmail.com>
In-Reply-To: <CA+FuTSdrHwNWh1Mz7KT8w+Z69LcNipeTcasny6ioqOUYBisNXg@mail.gmail.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Sun, 13 Feb 2022 19:08:21 +0200
Message-ID: <CABcq3pFpP1OkbsmZpMuM53DNSRo94uS9DLQ_8JVmuO0rJuRN_w@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] drivers/net/virtio_net: Added RSS hash report.
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Tue, Feb 8, 2022 at 10:55 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Feb 8, 2022 at 1:19 PM Andrew Melnychenko <andrew@daynix.com> wrote:
> >
> > Added features for RSS hash report.
> > If hash is provided - it sets to skb.
> > Added checks if rss and/or hash are enabled together.
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > ---
> >  drivers/net/virtio_net.c | 51 ++++++++++++++++++++++++++++++++++------
> >  1 file changed, 44 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 495aed524e33..543da2fbdd2d 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -227,6 +227,7 @@ struct virtnet_info {
> >
> >         /* Host supports rss and/or hash report */
> >         bool has_rss;
> > +       bool has_rss_hash_report;
> >         u8 rss_key_size;
> >         u16 rss_indir_table_size;
> >         u32 rss_hash_types_supported;
> > @@ -421,7 +422,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >
> >         hdr_len = vi->hdr_len;
> >         if (vi->mergeable_rx_bufs)
> > -               hdr_padded_len = sizeof(*hdr);
> > +               hdr_padded_len = hdr_len;
>
> Belongs in patch 1?

Yeah, I'll move it.

>
> >         else
> >                 hdr_padded_len = sizeof(struct padded_vnet_hdr);
> >
> > @@ -1156,6 +1157,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> >         struct net_device *dev = vi->dev;
> >         struct sk_buff *skb;
> >         struct virtio_net_hdr_mrg_rxbuf *hdr;
> > +       struct virtio_net_hdr_v1_hash *hdr_hash;
> > +       enum pkt_hash_types rss_hash_type;
> >
> >         if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
> >                 pr_debug("%s: short packet %i\n", dev->name, len);
> > @@ -1182,6 +1185,29 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> >                 return;
> >
> >         hdr = skb_vnet_hdr(skb);
> > +       if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report) {
>
> Can the first be true if the second is not?

Yes, RSS may be enabled, but the hash report feature is disabled.
For now, it's possible to enable/disable VirtioNet RSS by manipulating RXHASH.

>
> > +               hdr_hash = (struct virtio_net_hdr_v1_hash *)(hdr);
> > +
> > +               switch (hdr_hash->hash_report) {
> > +               case VIRTIO_NET_HASH_REPORT_TCPv4:
> > +               case VIRTIO_NET_HASH_REPORT_UDPv4:
> > +               case VIRTIO_NET_HASH_REPORT_TCPv6:
> > +               case VIRTIO_NET_HASH_REPORT_UDPv6:
> > +               case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
> > +               case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
> > +                       rss_hash_type = PKT_HASH_TYPE_L4;
> > +                       break;
> > +               case VIRTIO_NET_HASH_REPORT_IPv4:
> > +               case VIRTIO_NET_HASH_REPORT_IPv6:
> > +               case VIRTIO_NET_HASH_REPORT_IPv6_EX:
> > +                       rss_hash_type = PKT_HASH_TYPE_L3;
> > +                       break;
> > +               case VIRTIO_NET_HASH_REPORT_NONE:
> > +               default:
> > +                       rss_hash_type = PKT_HASH_TYPE_NONE;
> > +               }
> > +               skb_set_hash(skb, hdr_hash->hash_value, rss_hash_type);
> > +       }
>
> so many lines, perhaps deserves a helper function

Ok, I'll create the helper.

>
> >
> >         if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
> >                 skb->ip_summed = CHECKSUM_UNNECESSARY;
> > @@ -2232,7 +2258,8 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
> >         sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
> >
> >         if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
> > -                                 VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
> > +                                 vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CONFIG
> > +                                 : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs)) {
> >                 dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
> >                 return false;
> >         }
> > @@ -3230,6 +3257,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
> >              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
> >                              "VIRTIO_NET_F_CTRL_VQ") ||
> >              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
> > +                            "VIRTIO_NET_F_CTRL_VQ") ||
> > +            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> >                              "VIRTIO_NET_F_CTRL_VQ"))) {
> >                 return false;
> >         }
> > @@ -3365,8 +3394,13 @@ static int virtnet_probe(struct virtio_device *vdev)
> >         if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> >                 vi->mergeable_rx_bufs = true;
> >
> > -       if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
> > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
> > +               vi->has_rss_hash_report = true;
> > +
> > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
> >                 vi->has_rss = true;
> > +
> > +       if (vi->has_rss || vi->has_rss_hash_report) {
> >                 vi->rss_indir_table_size =
> >                         virtio_cread16(vdev, offsetof(struct virtio_net_config,
>
> should indir table size be zero if only hash report is enabled?

Not really - but of course, for hash only, the table is not necessary.
(Qemu always provides the table with size 1, I'll add checks for zero sizes
in case of hardware implementation.)

>
> >                                 rss_max_indirection_table_length));
> > @@ -3382,8 +3416,11 @@ static int virtnet_probe(struct virtio_device *vdev)
> >
> >                 dev->hw_features |= NETIF_F_RXHASH;
> >         }
> > -       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
> > -           virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> > +
> > +       if (vi->has_rss_hash_report)
> > +               vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
> > +       else if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
> > +                virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> >                 vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
> >         else
> >                 vi->hdr_len = sizeof(struct virtio_net_hdr);
> > @@ -3450,7 +3487,7 @@ static int virtnet_probe(struct virtio_device *vdev)
> >                 }
> >         }
> >
> > -       if (vi->has_rss)
> > +       if (vi->has_rss || vi->has_rss_hash_report)
> >                 virtnet_init_default_rss(vi);
> >
> >         err = register_netdev(dev);
> > @@ -3585,7 +3622,7 @@ static struct virtio_device_id id_table[] = {
> >         VIRTIO_NET_F_CTRL_MAC_ADDR, \
> >         VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> >         VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> > -       VIRTIO_NET_F_RSS
> > +       VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
> >
> >  static unsigned int features[] = {
> >         VIRTNET_FEATURES,
> > --
> > 2.34.1
> >
