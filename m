Return-Path: <netdev+bounces-6882-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6C0E7188FA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A9571C20EF2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C156618C08;
	Wed, 31 May 2023 18:01:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD33A18B0A
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:01:10 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A1C136
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:01:04 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f70597707eso9095e9.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685556062; x=1688148062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HtXx/Jfs6Knj/1esq0QhOq1bu9UcHXAuIjS1Kq/WynM=;
        b=RShbKX+D/rfPkIjs2UArfcY1aHOI38aCfu1pYbqdT9dTL0o0SIJnjy8dXPZn3X2M1J
         x28HAtjsK1kfoy4neidQI+anFy7aguoo0simMy5L86yK7pbbxfDIiCUTlZIdZp1SZk9o
         cTPoJJQ3zZBBFBP/c24soy7Zom4cZ+aeXePyQ1r0w9+gw17vXz0YYHPXO9p6cnWZKIfu
         PH5q8KPTVnlBX2UgrOVR2HC94HGol3sIEPfXbCn6zUwK4ZdKSldbojck0dvNRWiLJEVO
         EMo1wME+fibnB7+fAf7jNFOH2VTFN5mdP/ZW32lgzObhWCy4mN4zCGzcTpDE+GSwv7Ed
         jXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685556062; x=1688148062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HtXx/Jfs6Knj/1esq0QhOq1bu9UcHXAuIjS1Kq/WynM=;
        b=PCknP9rA+9f/B8Z0CsLsmoOufYgxxi/2wS2r9rtorDRcoobiq8rV4VukI6v9/IlitW
         D4seSL8DGBYQfYTj19cUGxq9rvSD97G/DxAAqJZPgDJnHlsGa7sD83tKozW/x00XFpPx
         sUJ6Im4rFcqK6bNmK4k8oHzH6t7T49nYVTkypVDyUQmztdQRG0zCaeIkd/LhcQKGb8Ky
         elqQ1ixFuwlCcus8/DXxqlJtxxH+ZcnNoMM0FAEVxRNV/iuET91GZvKiNIplAudcwIaO
         GknlcFc9SICu0tbdtXijQxEf2m482Xsrw0VY69kHajMdb9gXcOqBaDZt98pG7HMm2qRr
         khAg==
X-Gm-Message-State: AC+VfDz52JQOJOvQDOy/PNxSnBavEXdav7gPTBayHmtoUrzWm+Fc3f3W
	6XYYWNBlGz7j+L2n/EheID8A/qL444FqIr0Dfy8M9Q==
X-Google-Smtp-Source: ACHHUZ7ewBseHk7k3haVW+eJ3HUlmmPWIWunfMIDiJjubFS0ml4kDRhnaP4BrcKJlZ8PHaW/Fu02Yfn6PtMuEiRak4I=
X-Received: by 2002:a05:600c:1d90:b0:3f1:758c:dd23 with SMTP id
 p16-20020a05600c1d9000b003f1758cdd23mr947wms.7.1685556062379; Wed, 31 May
 2023 11:01:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230531172158.90406-1-jon@nutanix.com> <CANn89iLE1d=MuSMTisEbLh6Q_c4rjagd8xuRj0PC-4ua0pDRPA@mail.gmail.com>
 <30861EDF-D063-43C7-94A7-9C3C5ED13E54@nutanix.com>
In-Reply-To: <30861EDF-D063-43C7-94A7-9C3C5ED13E54@nutanix.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 May 2023 20:00:50 +0200
Message-ID: <CANn89i+EKgtVnnq-LqtmHXd5Yg2WMVn5Uw+F7zM0jPRdaj3wsQ@mail.gmail.com>
Subject: Re: [PATCH] flow_dissector: introduce skb_get_hash_symmetric()
To: Jon Kohler <jon@nutanix.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	Richard Gobert <richardbgobert@gmail.com>, Menglong Dong <imagedong@tencent.com>, 
	Wojciech Drewek <wojciech.drewek@intel.com>, Guillaume Nault <gnault@redhat.com>, 
	John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Shmulik Ladkani <shmulik.ladkani@gmail.com>, 
	Qingqing Yang <qingqing.yang@broadcom.com>, Daniel Xu <dxu@dxuuu.xyz>, Felix Fietkau <nbd@nbd.name>, 
	Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>, Jason Wang <jasowang@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 7:47=E2=80=AFPM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On May 31, 2023, at 1:33 PM, Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, May 31, 2023 at 7:22=E2=80=AFPM Jon Kohler <jon@nutanix.com> wr=
ote:
> >>
> >> tun.c changed from skb_get_hash() to __skb_get_hash_symmetric() on
> >> commit feec084a7cf4 ("tun: use symmetric hash"), which exposes an
> >> overhead for OVS datapath, where ovs_dp_process_packet() has to
> >> calculate the hash again because __skb_get_hash_symmetric() does not
> >> retain the hash that it calculates.
> >>
> >> Introduce skb_get_hash_symmetric(), which will get and save the hash
> >> in one go, so that calcuation work does not go to waste, and plumb it
> >> into tun.c.
> >>
> >> Fixes: feec084a7cf4 ("tun: use symmetric hash")
> >
> >
> >> Signed-off-by: Jon Kohler <jon@nutanix.com>
> >> CC: Jason Wang <jasowang@redhat.com>
> >> CC: David S. Miller <davem@davemloft.net>
> >> ---
> >>
> >
> >> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >> index 0b40417457cd..8112b1ab5735 100644
> >> --- a/include/linux/skbuff.h
> >> +++ b/include/linux/skbuff.h
> >> @@ -1474,6 +1474,7 @@ __skb_set_sw_hash(struct sk_buff *skb, __u32 has=
h, bool is_l4)
> >>
> >> void __skb_get_hash(struct sk_buff *skb);
> >> u32 __skb_get_hash_symmetric(const struct sk_buff *skb);
> >> +u32 skb_get_hash_symmetric(struct sk_buff *skb);
> >> u32 skb_get_poff(const struct sk_buff *skb);
> >> u32 __skb_get_poff(const struct sk_buff *skb, const void *data,
> >>                   const struct flow_keys_basic *keys, int hlen);
> >> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> >> index 25fb0bbc310f..d8c0e804bbfe 100644
> >> --- a/net/core/flow_dissector.c
> >> +++ b/net/core/flow_dissector.c
> >> @@ -1747,6 +1747,35 @@ u32 __skb_get_hash_symmetric(const struct sk_bu=
ff *skb)
> >> }
> >> EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
> >>
> >> +/**
> >> + * skb_get_hash_symmetric: calculate and set a flow hash in @skb, usi=
ng
> >> + * flow_keys_dissector_symmetric.
> >> + * @skb: sk_buff to calculate flow hash from
> >> + *
> >> + * This function is similar to __skb_get_hash_symmetric except that i=
t
> >> + * retains the hash within the skb, such that it can be reused withou=
t
> >> + * being recalculated later.
> >> + */
> >> +u32 skb_get_hash_symmetric(struct sk_buff *skb)
> >> +{
> >> +       struct flow_keys keys;
> >> +       u32 hash;
> >> +
> >> +       __flow_hash_secret_init();
> >> +
> >> +       memset(&keys, 0, sizeof(keys));
> >> +       __skb_flow_dissect(NULL, skb, &flow_keys_dissector_symmetric,
> >> +                          &keys, NULL, 0, 0, 0,
> >> +                          FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
> >> +
> >> +       hash =3D __flow_hash_from_keys(&keys, &hashrnd);
> >> +
> >> +       __skb_set_sw_hash(skb, hash, flow_keys_have_l4(&keys));
> >> +
> >> +       return hash;
> >> +}
> >> +EXPORT_SYMBOL_GPL(skb_get_hash_symmetric);
> >> +
> >
> > Why copy/pasting __skb_get_hash_symmetric() ?
> >
> > Can you reuse it ?
>
> Not directly, because to use __skb_set_sw_hash requires struct flow_keys
> when using flow_keys_have_l4(). __skb_get_hash_symmetric() does not
> take or return that struct, so we=E2=80=99d either have to refactor that =
(and its callers)
> or introduce yet another function and consolidate down to that =E2=80=9Cn=
ew one=E2=80=9D.
>
> I played around with that exact thought by taking the functional guts out=
 of
> __skb_get_hash_symmetric, making it a new static function, plumbing that
> into __skb_get_hash_symmetric and this new skb_get_hash_symmetric, but
> the LOC churn was basically the same and it felt a bit worse than just a
> copy/paste.
>
> Alternatively, if it turned out that flow_keys_have_l4() wasn=E2=80=99t i=
mportant, we
> Could simply set that to false and then reuse __skb_get_hash_symmetric
> in a trivial manner. I couldn=E2=80=99t quite figure out if L4 flag was n=
ecessary, so I
> went the safe(maybe?) route and copy/paste instead.
>
> Happy to take suggestions either way!

There are 6 callers of __skb_get_hash_symmetric()

I would convert __skb_get_hash_symmetric()  to

skb_get_hash_symmetric(struct sk_buff *skb, bool record_hash)

