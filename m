Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9080490340
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 08:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbiAQH50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 02:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237758AbiAQH5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 02:57:25 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967E5C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 23:57:25 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id bx18so3932923oib.7
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 23:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tLlyeAyKlnwHxx5tD2c6sR9OmT151cKCbOIWFvV7ogc=;
        b=A424nQgJnhIa6KIvg/IqFiQ/6IYZPD7zcbckynw02lYKsOl5qItvmn6v6cW125mCb4
         7ZHT0OagcGAVnOeug7fQYcJdRRzU3aURHCeGfi19f+w8ZUpFYW4VzWUIZ6/1tvist5Vv
         idqZXL/5jd1+F3c3JFrUL1RLJc90t1M7pn4zhx6B8URT/Cr7wnCNNpUibu/rnmKCvVai
         FeEsfjS8eMsyUHaJGLCXh4eL+VJX2TKZuR9BKzlk/NzD4j/fB2SSGvN+MQ9cVn6Zuq7C
         iCMTHPTwXk2x50Vrrcayxw5SbRQoTdk5UTOGBp9zULkNDAXipX/MdbbtyrtP+pNkD/C5
         f0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tLlyeAyKlnwHxx5tD2c6sR9OmT151cKCbOIWFvV7ogc=;
        b=qj/uOBbw99CIl4Vb0Di4NtnlD/ET6FjLh86Qt8dTHBFH3gFz5e/c8JU7kfpvfDO8Ua
         FgY9veODH9b/LSh9iVw6jttB87ObIP9TbGiDmDq7nORcEvlppabtrMH9ZskOEDsF58rC
         /qNVOCDhA6U0RDbLXVPyJnvGE+nU/+Wm5paUt9izA3248aMxzJ8dMqYkT4WRlnJsF3SY
         CNPE0ymsQb2y6vQw6qNXzW8lKmGLP2p4exlYd4jlcPJGGNQegcJX53nPZb9xnTpaItUO
         a13vBCRTnQ9BhXZE7AsHoAWvl0qozLT9sZM8keaY3wsHhi3k7XSV+Y4/H/fbL4eQQLta
         9ROQ==
X-Gm-Message-State: AOAM532wUz2cWzHjpYhcHJtZNud2D9xjemVMF1PrM8iI+9FMsJOhp/T1
        /bKVTIPi2gnEYT1VLZn7imgxQWIOYtXoPugH+riG3Q==
X-Google-Smtp-Source: ABdhPJzVr7BeAL5NnvfkfRu8qcruCGoWS/X9/DgQfXcUH0nLTA8af9zVshceOBXeAHgl9EMUdJV/CmPF76UuvXP261s=
X-Received: by 2002:aca:ba85:: with SMTP id k127mr15932673oif.169.1642406244923;
 Sun, 16 Jan 2022 23:57:24 -0800 (PST)
MIME-Version: 1.0
References: <20220109210659.2866740-1-andrew@daynix.com> <20220109210659.2866740-4-andrew@daynix.com>
 <60f24351-1011-de84-b443-ff5a50c3ff7f@redhat.com>
In-Reply-To: <60f24351-1011-de84-b443-ff5a50c3ff7f@redhat.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Mon, 17 Jan 2022 09:57:14 +0200
Message-ID: <CABcq3pFVPfqO6EYzWHnzDWxCW+68DHNZgxqViG2HB-3fyT-GEQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] drivers/net/virtio_net: Added RSS hash report.
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all.

> I think we should make RSS depend on CTRL_VQ.
> Need to depend on CTRL_VQ here.
I'll fix that.

> Any reason to initialize RSS feature here not the init_default_rss()?
init_default_rss() initializes virtio_net_ctrl_rss structure only, I
think it's a good idea not to mix field initializations.

On Tue, Jan 11, 2022 at 6:06 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/1/10 =E4=B8=8A=E5=8D=885:06, Andrew Melnychenko =E5=86=99=
=E9=81=93:
> > Added features for RSS hash report.
> > If hash is provided - it sets to skb.
> > Added checks if rss and/or hash are enabled together.
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > ---
> >   drivers/net/virtio_net.c | 56 ++++++++++++++++++++++++++++++++++-----=
-
> >   1 file changed, 48 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 21794731fc75..6e7461b01f87 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -231,6 +231,7 @@ struct virtnet_info {
> >
> >       /* Host supports rss and/or hash report */
> >       bool has_rss;
> > +     bool has_rss_hash_report;
> >       u8 rss_key_size;
> >       u16 rss_indir_table_size;
> >       u32 rss_hash_types_supported;
> > @@ -424,7 +425,9 @@ static struct sk_buff *page_to_skb(struct virtnet_i=
nfo *vi,
> >       hdr_p =3D p;
> >
> >       hdr_len =3D vi->hdr_len;
> > -     if (vi->mergeable_rx_bufs)
> > +     if (vi->has_rss_hash_report)
> > +             hdr_padded_len =3D sizeof(struct virtio_net_hdr_v1_hash);
> > +     else if (vi->mergeable_rx_bufs)
> >               hdr_padded_len =3D sizeof(*hdr);
> >       else
> >               hdr_padded_len =3D sizeof(struct padded_vnet_hdr);
> > @@ -1160,6 +1163,8 @@ static void receive_buf(struct virtnet_info *vi, =
struct receive_queue *rq,
> >       struct net_device *dev =3D vi->dev;
> >       struct sk_buff *skb;
> >       struct virtio_net_hdr_mrg_rxbuf *hdr;
> > +     struct virtio_net_hdr_v1_hash *hdr_hash;
> > +     enum pkt_hash_types rss_hash_type;
> >
> >       if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
> >               pr_debug("%s: short packet %i\n", dev->name, len);
> > @@ -1186,6 +1191,29 @@ static void receive_buf(struct virtnet_info *vi,=
 struct receive_queue *rq,
> >               return;
> >
> >       hdr =3D skb_vnet_hdr(skb);
> > +     if (dev->features & NETIF_F_RXHASH) {
> > +             hdr_hash =3D (struct virtio_net_hdr_v1_hash *)(hdr);
> > +
> > +             switch (hdr_hash->hash_report) {
> > +             case VIRTIO_NET_HASH_REPORT_TCPv4:
> > +             case VIRTIO_NET_HASH_REPORT_UDPv4:
> > +             case VIRTIO_NET_HASH_REPORT_TCPv6:
> > +             case VIRTIO_NET_HASH_REPORT_UDPv6:
> > +             case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
> > +             case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
> > +                     rss_hash_type =3D PKT_HASH_TYPE_L4;
> > +                     break;
> > +             case VIRTIO_NET_HASH_REPORT_IPv4:
> > +             case VIRTIO_NET_HASH_REPORT_IPv6:
> > +             case VIRTIO_NET_HASH_REPORT_IPv6_EX:
> > +                     rss_hash_type =3D PKT_HASH_TYPE_L3;
> > +                     break;
> > +             case VIRTIO_NET_HASH_REPORT_NONE:
> > +             default:
> > +                     rss_hash_type =3D PKT_HASH_TYPE_NONE;
> > +             }
> > +             skb_set_hash(skb, hdr_hash->hash_value, rss_hash_type);
> > +     }
> >
> >       if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
> >               skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> > @@ -2233,7 +2261,8 @@ static bool virtnet_commit_rss_command(struct vir=
tnet_info *vi)
> >       sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
> >
> >       if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
> > -                               VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
> > +                               vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CO=
NFIG
> > +                               : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs))=
 {
> >               dev_warn(&dev->dev, "VIRTIONET issue with committing RSS =
sgs\n");
> >               return false;
> >       }
> > @@ -3220,7 +3249,9 @@ static bool virtnet_validate_features(struct virt=
io_device *vdev)
> >            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ=
") ||
> >            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
> >                            "VIRTIO_NET_F_CTRL_VQ") ||
> > -          VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS, "VIRTIO_NET_F_RSS"))=
) {
> > +          VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS, "VIRTIO_NET_F_RSS") =
||
>
>
> I think we should make RSS depend on CTRL_VQ.
>
>
> > +          VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> > +                          "VIRTIO_NET_F_HASH_REPORT"))) {
>
>
> Need to depend on CTRL_VQ here.
>
>
> >               return false;
> >       }
> >
> > @@ -3355,6 +3386,12 @@ static int virtnet_probe(struct virtio_device *v=
dev)
> >       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> >               vi->mergeable_rx_bufs =3D true;
> >
> > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT)) {
> > +             vi->has_rss_hash_report =3D true;
> > +             vi->rss_indir_table_size =3D 1;
> > +             vi->rss_key_size =3D VIRTIO_NET_RSS_MAX_KEY_SIZE;
>
>
> Any reason to initialize RSS feature here not the init_default_rss()?
>
> Thanks
>
>
> > +     }
> > +
> >       if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
> >               vi->has_rss =3D true;
> >               vi->rss_indir_table_size =3D
> > @@ -3364,7 +3401,7 @@ static int virtnet_probe(struct virtio_device *vd=
ev)
> >                       virtio_cread8(vdev, offsetof(struct virtio_net_co=
nfig, rss_max_key_size));
> >       }
> >
> > -     if (vi->has_rss) {
> > +     if (vi->has_rss || vi->has_rss_hash_report) {
> >               vi->rss_hash_types_supported =3D
> >                   virtio_cread32(vdev, offsetof(struct virtio_net_confi=
g, supported_hash_types));
> >               vi->rss_hash_types_supported &=3D
> > @@ -3374,8 +3411,11 @@ static int virtnet_probe(struct virtio_device *v=
dev)
> >
> >               dev->hw_features |=3D NETIF_F_RXHASH;
> >       }
> > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
> > -         virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> > +
> > +     if (vi->has_rss_hash_report)
> > +             vi->hdr_len =3D sizeof(struct virtio_net_hdr_v1_hash);
> > +     else if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
> > +              virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> >               vi->hdr_len =3D sizeof(struct virtio_net_hdr_mrg_rxbuf);
> >       else
> >               vi->hdr_len =3D sizeof(struct virtio_net_hdr);
> > @@ -3442,7 +3482,7 @@ static int virtnet_probe(struct virtio_device *vd=
ev)
> >               }
> >       }
> >
> > -     if (vi->has_rss) {
> > +     if (vi->has_rss || vi->has_rss_hash_report) {
> >               rtnl_lock();
> >               virtnet_init_default_rss(vi);
> >               rtnl_unlock();
> > @@ -3580,7 +3620,7 @@ static struct virtio_device_id id_table[] =3D {
> >       VIRTIO_NET_F_CTRL_MAC_ADDR, \
> >       VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> >       VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> > -     VIRTIO_NET_F_RSS
> > +     VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
> >
> >   static unsigned int features[] =3D {
> >       VIRTNET_FEATURES,
>
