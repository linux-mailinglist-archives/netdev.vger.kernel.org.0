Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4813C3EF815
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 04:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbhHRCbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 22:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236597AbhHRCbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 22:31:44 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8640AC061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 19:31:10 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so1331000pjl.4
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 19:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HkOLxttTyZULbA8tvWktVrW2VSFTeVu7Pgfwp9VkXpc=;
        b=HmeWXBFNYD25vtezDsysmaJpnVhqjiT8Htf3yn8wwDyyAsC8cACf0Fj5Qq/rk4UNV2
         vslrN0sWIxixWL5cDQZbBaJZVywMkT0rCjL8KSZRHV2ZAwQEgHmiStbZb1SR3I9rMFZ4
         7s0QEG6L+62u9Bhz7vyOZHhdUjqLa1LE4RbaAATPjoLEu69PebiDN5xmjByjp4JZOkbp
         QObxZ9ONfSajQVhM3jda6oFiTkOFLjMKgZ7A27bpUI0TgusCwK5CN4OsaKCa8DU2FYwU
         OeNK7nVTCW8Y6pxoiDz4SWs/iXRJSVoIOsJoRC8dBPYHzKmdzTeNZmAnlbxtr8PESdJA
         bIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HkOLxttTyZULbA8tvWktVrW2VSFTeVu7Pgfwp9VkXpc=;
        b=LbLwpuucngw3BkHITXm5XMBP+E1cx2zIpz8gVydQePOtlQ6Lr/L/j/xsjXeH3/j/iA
         jX8q/jwJyDOX9mJdstC7wlaf/odaLoxlF2enOnyF2Vv0izZXRXnZWFlxYTc6jI7SiPKQ
         dobA+ViIscl5UtNnthdzybtoFPZrItwou+LY8y5aDy6ifKkrjvtdWW9uM2rFMx79SGcv
         nmpYABMZRTOjhrbB17xHcWgN4A9JisgJuDY995fcJ5+Xlb9PnN1KThmxBk/IibrRQyv5
         KzOiH3LYJpXa6R3UDis+OxqlMgV9mBZ5EFNvhxLnvnrzy9FSkz+b8qVAiCkFOMrHFJfT
         ueRA==
X-Gm-Message-State: AOAM532hpBI/gfFfDWL6kdSBA1EMfO3vz9O6y22nTdvR9LlOafFzVnop
        KxR712Dh/Qmr7gmOXyWcv0dFW0xZUjoqVCRkvUaIsA==
X-Google-Smtp-Source: ABdhPJxgN3eRVH3DulUgHpCVqzphAHy90niD2M2s+u/0tlqVyIiIikD8PVkEZNWQDLnKXi2kLEWFYPbevOl6LYhKGCc=
X-Received: by 2002:a17:902:7406:b029:12d:3bc1:3812 with SMTP id
 g6-20020a1709027406b029012d3bc13812mr5279533pll.67.1629253870030; Tue, 17 Aug
 2021 19:31:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAEEdnKGsHx5kiUm6SViYru3y8GFLjcLunoGa=0_UQrGi+i7jwg@mail.gmail.com>
 <20210817063609.4be19d4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210817063609.4be19d4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?6IyD5byA5Zac?= <fankaixi.li@bytedance.com>
Date:   Wed, 18 Aug 2021 10:30:59 +0800
Message-ID: <CAEEdnKEZ0wukK59zcsr3BmaaZQurdt5iHoFM_OWwUzP=yMDicw@mail.gmail.com>
Subject: Re: [External] [PATCH] ovs: datapath: clear skb->tstamp in forwarding path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2021=E5=B9=B48=E6=9C=8817=E6=97=
=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=889:36=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, 17 Aug 2021 10:25:24 +0800 =E8=8C=83=E5=BC=80=E5=96=9C wrote:
> > fq qdisc requires tstamp to be cleared in the forwarding path. Now ovs
> > doesn't clear skb->tstamp. We encountered a problem with linux
> > version 5.4.56 and ovs version 2.14.1, and packets failed to
> > dequeue from qdisc when fq qdisc was attached to ovs port.
> >
> > Signed-off-by: kaixi.fan <fankaixi.li@bytedance.com>
> > Signed-off-by: xiexiaohui <xiexiaohui.xxh@bytedance.com>
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/openvswitch/vport.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> > index 88deb5b41429..cf2ce5812489 100644
> > --- a/net/openvswitch/vport.c
> > +++ b/net/openvswitch/vport.c
> > @@ -507,6 +507,7 @@ void ovs_vport_send(struct vport *vport, struct
> > sk_buff *skb, u8 mac_proto)
> >   }
> >
> >   skb->dev =3D vport->dev;
> > + skb->tstamp =3D 0;
> >   vport->ops->send(skb);
> >   return;
>
> This patch has been mangled by your email client, please try
> git send-email if possible.

Sorry. I resend it through git send-email. Thanks.
