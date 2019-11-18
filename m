Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318E4100A35
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 18:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfKRR2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 12:28:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32642 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726314AbfKRR2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 12:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574098133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=er1S7EmTw+m2lRqhyi1gk8LRFPH1UJmX1WRpNQ974nU=;
        b=KUKUVCIJaypWO+udRph1SxSDXxdfELsfMQOO5bjHZkG1YxSKu9mvCw4XH3BUE7hqLdFRrc
        4S6mWpsHoPCqRQb3tDkSvks5XM9znMtg235zUE+OZm13Qx2DrGnAtANp5J1Kr8BxAw/0BB
        2excusYBkefaQh+SeZtbpokPhxVBjXw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-RsMT9W1wNqO3F7SaEf8Y9g-1; Mon, 18 Nov 2019 12:28:52 -0500
Received: by mail-wm1-f70.google.com with SMTP id x16so68606wmk.2
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 09:28:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kvWq585u9B/+tXGrrXSSeueC9Wga6XImyLy3VWcl2gc=;
        b=G6xiliBowUIGDpeWvhnOrK/Wiw11jsXhuBHp7daZJ0d7r2D6BoI2mND5htcUIHkmyq
         xx/pnnAhZs2POPSlldLiAvc6olOT59tcak0PMwEeJOHc6+km1DOvhVrPt7Cq6z74+nGW
         4QG6cSOY1TMf+2VynMEKBSeIGGfaNopUNQgF3QbefOd5IVEcjjJ6MI1YL1gQKyngeln6
         XzqhQacrBXLtNCzMzBLd4rdMIsKPenkg3KjG05o+bhRe79B21IjCfPN0rzmh4mMJmQ0u
         7N+YTKcCYebHKvumovFYNlA7mtPrinnZhxuE4mD7sXT3N3B67nOuFF35xQXL1fJehwFI
         OvIA==
X-Gm-Message-State: APjAAAVgHBv05GkrC3OYvQcHFxMZfTPr/Oz9qiTbta+pKYbiiQ4nyAyB
        gy30k0a7G1YgHaoOzKTI7ftYXUTQyS7PDFVVAAYt0+Bk5EyAYnvqbhmstzdAO77q8yKmrZolrkU
        xY0/rMLkI79v8RIFn
X-Received: by 2002:a5d:4688:: with SMTP id u8mr20814712wrq.40.1574098130310;
        Mon, 18 Nov 2019 09:28:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqyTt1HpU3TnI5ci0QIFaxICCDw/T8doL9VHWGOb7g+x43aaXDjmh0z3ci33RHr2ztxM0cIyfA==
X-Received: by 2002:a5d:4688:: with SMTP id u8mr20814689wrq.40.1574098130063;
        Mon, 18 Nov 2019 09:28:50 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z6sm9583574wrq.76.2019.11.18.09.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 09:28:49 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf\@aepfle.de" <olaf@aepfle.de>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sashal\@kernel.org" <sashal@kernel.org>,
        "linux-hyperv\@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net, 1/2] hv_netvsc: Fix offset usage in netvsc_send_table()
In-Reply-To: <1574094751-98966-2-git-send-email-haiyangz@microsoft.com>
References: <1574094751-98966-1-git-send-email-haiyangz@microsoft.com> <1574094751-98966-2-git-send-email-haiyangz@microsoft.com>
Date:   Mon, 18 Nov 2019 18:28:48 +0100
Message-ID: <87wobxgkkv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: RsMT9W1wNqO3F7SaEf8Y9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Haiyang Zhang <haiyangz@microsoft.com> writes:

> To reach the data region, the existing code adds offset in struct
> nvsp_5_send_indirect_table on the beginning of this struct. But the
> offset should be based on the beginning of its container,
> struct nvsp_message. This bug causes the first table entry missing,
> and adds an extra zero from the zero pad after the data region.
> This can put extra burden on the channel 0.
>
> So, correct the offset usage. Also add a boundary check to ensure
> not reading beyond data region.
>
> Fixes: 5b54dac856cb ("hyperv: Add support for virtual Receive Side Scalin=
g (vRSS)")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/hyperv/hyperv_net.h |  3 ++-
>  drivers/net/hyperv/netvsc.c     | 26 ++++++++++++++++++--------
>  2 files changed, 20 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index 670ef68..fb547f3 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -609,7 +609,8 @@ struct nvsp_5_send_indirect_table {
>  =09/* The number of entries in the send indirection table */
>  =09u32 count;
> =20
> -=09/* The offset of the send indirection table from top of this struct.
> +=09/* The offset of the send indirection table from the beginning of
> +=09 * struct nvsp_message.
>  =09 * The send indirection table tells which channel to put the send
>  =09 * traffic on. Each entry is a channel number.
>  =09 */
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index d22a36f..efd30e2 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -1178,20 +1178,28 @@ static int netvsc_receive(struct net_device *ndev=
,
>  }
> =20
>  static void netvsc_send_table(struct net_device *ndev,
> -=09=09=09      const struct nvsp_message *nvmsg)
> +=09=09=09      const struct nvsp_message *nvmsg,
> +=09=09=09      u32 msglen)
>  {
>  =09struct net_device_context *net_device_ctx =3D netdev_priv(ndev);
> -=09u32 count, *tab;
> +=09u32 count, offset, *tab;
>  =09int i;
> =20
>  =09count =3D nvmsg->msg.v5_msg.send_table.count;
> +=09offset =3D nvmsg->msg.v5_msg.send_table.offset;
> +
>  =09if (count !=3D VRSS_SEND_TAB_SIZE) {
>  =09=09netdev_err(ndev, "Received wrong send-table size:%u\n", count);
>  =09=09return;
>  =09}
> =20
> -=09tab =3D (u32 *)((unsigned long)&nvmsg->msg.v5_msg.send_table +
> -=09=09      nvmsg->msg.v5_msg.send_table.offset);
> +=09if (offset + count * sizeof(u32) > msglen) {

Nit: I think this can overflow.

> +=09=09netdev_err(ndev, "Received send-table offset too big:%u\n",
> +=09=09=09   offset);
> +=09=09return;
> +=09}
> +
> +=09tab =3D (void *)nvmsg + offset;

But tab is 'u32 *', doesn't compiler complain?

> =20
>  =09for (i =3D 0; i < count; i++)
>  =09=09net_device_ctx->tx_table[i] =3D tab[i];
> @@ -1209,12 +1217,13 @@ static void netvsc_send_vf(struct net_device *nde=
v,
>  =09=09    net_device_ctx->vf_alloc ? "added" : "removed");
>  }
> =20
> -static  void netvsc_receive_inband(struct net_device *ndev,
> -=09=09=09=09   const struct nvsp_message *nvmsg)
> +static void netvsc_receive_inband(struct net_device *ndev,
> +=09=09=09=09  const struct nvsp_message *nvmsg,
> +=09=09=09=09  u32 msglen)
>  {
>  =09switch (nvmsg->hdr.msg_type) {
>  =09case NVSP_MSG5_TYPE_SEND_INDIRECTION_TABLE:
> -=09=09netvsc_send_table(ndev, nvmsg);
> +=09=09netvsc_send_table(ndev, nvmsg, msglen);
>  =09=09break;
> =20
>  =09case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
> @@ -1232,6 +1241,7 @@ static int netvsc_process_raw_pkt(struct hv_device =
*device,
>  {
>  =09struct vmbus_channel *channel =3D nvchan->channel;
>  =09const struct nvsp_message *nvmsg =3D hv_pkt_data(desc);
> +=09u32 msglen =3D hv_pkt_datalen(desc);
> =20
>  =09trace_nvsp_recv(ndev, channel, nvmsg);
> =20
> @@ -1247,7 +1257,7 @@ static int netvsc_process_raw_pkt(struct hv_device =
*device,
>  =09=09break;
> =20
>  =09case VM_PKT_DATA_INBAND:
> -=09=09netvsc_receive_inband(ndev, nvmsg);
> +=09=09netvsc_receive_inband(ndev, nvmsg, msglen);
>  =09=09break;
> =20
>  =09default:

--=20
Vitaly

