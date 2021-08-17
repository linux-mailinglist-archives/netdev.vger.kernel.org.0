Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966173EED8F
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237811AbhHQNgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237775AbhHQNgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:36:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D658160E09;
        Tue, 17 Aug 2021 13:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629207370;
        bh=IN/5Keyf5ZIi7PxftZmX8FuKpnZKDIYxUwP/0fevm6c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FAKis93mdfj9auAke7QmOf4cigzFVSt8a5ejZc1Mn9oo2ULW4a+U2gzVxOlX/YAb6
         NxHlsKfz8rIALTAOKjN8cVE042Ccgkc8jA5fU39I37EJwXsQhn5Ej/9w90nNX7ubDo
         rEq5afv7OHukrExuqtVD76h+IXbCZ5HodT8lpnunZNdA8suWoJX46tHHOXClkDatdm
         VthMXV/AASuHv4qiGwCmcP1pqlT3149xrCxe4C8HQcFXRuOu0QH2pwgt5Kk/YQwULr
         LSujgf3dH6g5HKct6LV5D0fLWTdpFdnUWGvLOVAQJA/+BWqGxhBGxhi3cuKVNLGHZ1
         h9etwoips8DRQ==
Date:   Tue, 17 Aug 2021 06:36:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?6IyD5byA5Zac?= <fankaixi.li@bytedance.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [External] [PATCH] ovs: datapath: clear skb->tstamp in
 forwarding path
Message-ID: <20210817063609.4be19d4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEEdnKGsHx5kiUm6SViYru3y8GFLjcLunoGa=0_UQrGi+i7jwg@mail.gmail.com>
References: <CAEEdnKGsHx5kiUm6SViYru3y8GFLjcLunoGa=0_UQrGi+i7jwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 10:25:24 +0800 =E8=8C=83=E5=BC=80=E5=96=9C wrote:
> fq qdisc requires tstamp to be cleared in the forwarding path. Now ovs
> doesn't clear skb->tstamp. We encountered a problem with linux
> version 5.4.56 and ovs version 2.14.1, and packets failed to
> dequeue from qdisc when fq qdisc was attached to ovs port.
>=20
> Signed-off-by: kaixi.fan <fankaixi.li@bytedance.com>
> Signed-off-by: xiexiaohui <xiexiaohui.xxh@bytedance.com>
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/openvswitch/vport.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 88deb5b41429..cf2ce5812489 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -507,6 +507,7 @@ void ovs_vport_send(struct vport *vport, struct
> sk_buff *skb, u8 mac_proto)
>   }
>=20
>   skb->dev =3D vport->dev;
> + skb->tstamp =3D 0;
>   vport->ops->send(skb);
>   return;

This patch has been mangled by your email client, please try
git send-email if possible.
