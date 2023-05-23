Return-Path: <netdev+bounces-4650-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4681E70DAC9
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A18328124E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32CB34A849;
	Tue, 23 May 2023 10:45:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200DC4A842
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:45:49 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE16CFF
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:45:47 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f601283b36so53045e9.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684838746; x=1687430746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gKNB1PLPgA6/NfqEcw/wRUenyADMemNCEiwXNXVdVwg=;
        b=vIRA/pelpgmEOaoX6n3KDWb3xEUs+cL8p0+juaU0x68+goWyZ3RT+WgxfBVgOjgt72
         Y+s9fTgzqxg1iSBcqJOzKY8iRZ/rCkBSnNVkjL3ws7Dnp2jsuVeHNKO4X7m/EIXr3xoh
         v2U4N+GbvQO52t+4ENmbQtxYYTxR248QupGvp3J79dpbPCjHmiHFMf2T9jtaGGP91rG/
         rrw03KrgbI1aTDm3XAr8xb8cC0uxnnLjsh5IBUFQ1BX5o/5CLQCeMzPXENBL54csCvAP
         54J9bQLiOBUJxDL6NrPJgF/eunB/Vak010TRW0EF4o5lYfGAE4f96k/juS25fwCP0V8a
         RLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684838746; x=1687430746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKNB1PLPgA6/NfqEcw/wRUenyADMemNCEiwXNXVdVwg=;
        b=GOBBuNofYYpO/fa+B9pl9h2vKORaBl9rs02u5iF41mHBkuOPARkqpvdVgOA58+LvKA
         lo3dIzK9DSamRigyvUC6I3cPamVMbR5ipXH+t1r+Ug6f3xPGLtyHxqSvlb6//RDY8TtA
         D/AoGRgNREMdvzXP/eo5m+8gM5y22PEZrUS8aUnKKz54/zPF6hcgpJQflFnEnebYThK4
         /V7vzCHeBnr2ZpLTcVSW9AnP/oqBSjm4XREVZTHQYM6iz5Dcd81/gPV2W6MsldufPQDn
         T2EupF47yF286wy2m5v7ZiU6xgwtysoXSvBwBfKshhx9Nj9/AhHh+Q/TlnPtTwvu4htH
         wLMw==
X-Gm-Message-State: AC+VfDzvYwPPJ7+CnVQlNgZmYN8pxPHkY9AXZ11IVRx591R8IDUVBtIH
	CnIbQbB5RHDgS5H1GgFvnslveyUISougQ2OtnEml2Q==
X-Google-Smtp-Source: ACHHUZ69E5H24+BvxB5jBxTA6gQnLO5PpdEETUPHHxi7rasjX30GtwLzzx9rixjSWILEE3hdMxNqfjHyketujC8YHlg=
X-Received: by 2002:a05:600c:5118:b0:3f6:f4b:d4a6 with SMTP id
 o24-20020a05600c511800b003f60f4bd4a6mr2611wms.7.1684838745997; Tue, 23 May
 2023 03:45:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517213118.3389898-1-edumazet@google.com> <20230517213118.3389898-2-edumazet@google.com>
 <ZGZavH7hxiq/pkF8@corigine.com> <CANn89iJofjC=aqSu6X9itW8VQXTSFUOiAmBB2Zzuw-6kqTnwzA@mail.gmail.com>
 <20230522130050.6fa160f6@kernel.org> <ZGx9k6m6r7blT2B+@corigine.com>
In-Reply-To: <ZGx9k6m6r7blT2B+@corigine.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 23 May 2023 12:45:34 +0200
Message-ID: <CANn89iJ0Sdy5o8WHdTygE3UwUgHpJkdxKfeYXMN0DZBKs_f6AA@mail.gmail.com>
Subject: Re: [PATCH net 1/3] ipv6: exthdrs: fix potential use-after-free in ipv6_rpl_srh_rcv()
To: Simon Horman <simon.horman@corigine.com>
Cc: Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Paolo Abeni <pabeni@redhat.com>, Alexander Aring <alex.aring@gmail.com>, netdev@vger.kernel.org, 
	eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 10:47=E2=80=AFAM Simon Horman <simon.horman@corigin=
e.com> wrote:
>
> On Mon, May 22, 2023 at 01:00:50PM -0700, Jakub Kicinski wrote:
> > On Sun, 21 May 2023 20:22:16 +0200 Eric Dumazet wrote:
> > > On Thu, May 18, 2023 at 7:05=E2=80=AFPM Simon Horman <simon.horman@co=
rigine.com> wrote:
> > > > Not far below this line there is a call to pskb_pull():
> > > >
> > > >                 if (hdr->nexthdr =3D=3D NEXTHDR_IPV6) {
> > > >                         int offset =3D (hdr->hdrlen + 1) << 3;
> > > >
> > > >                         skb_postpull_rcsum(skb, skb_network_header(=
skb),
> > > >                                            skb_network_header_len(s=
kb));
> > > >
> > > >                         if (!pskb_pull(skb, offset)) {
> > > >                                 kfree_skb(skb);
> > > >                                 return -1;
> > > >                         }
> > > >                         skb_postpull_rcsum(skb, skb_transport_heade=
r(skb),
> > > >                                            offset);
> > > >
> > > > Should hdr be reloaded after the call to pskb_pull() too?
> > >
> > > I do not think so, because @hdr is not used between this pskb_pull()
> > > and the return -1:
> > >
> > >        if (hdr->nexthdr =3D=3D NEXTHDR_IPV6) {
> > >             int offset =3D (hdr->hdrlen + 1) << 3;
> > >
> > >             skb_postpull_rcsum(skb, skb_network_header(skb),
> > >                        skb_network_header_len(skb));
> > >
> > >             if (!pskb_pull(skb, offset)) {
> > >                 kfree_skb(skb);
> > >                 return -1;
> > >             }
> > >             skb_postpull_rcsum(skb, skb_transport_header(skb),
> > >                        offset);
> > >
> > >             skb_reset_network_header(skb);
> > >             skb_reset_transport_header(skb);
> > >             skb->encapsulation =3D 0;
> > >
> > >             __skb_tunnel_rx(skb, skb->dev, net);
> > >
> > >             netif_rx(skb);
> > >             return -1;
> > >         }
> >
> > Hum, there's very similar code in ipv6_srh_rcv() (a different function
> > but with a very similar name) which calls pskb_pull() and then checks
> > if hdr->nexthdr is v4. I'm guessing that's the one Simon was referring
> > to.
>
> Yes, that does seem to be the case.

I think ipv6_srh_rcv() is fine.

The "goto looped_back" does not need to reload hdr.

The only point where skb->head can change is at the pskb_expand_head() call=
,
which is properly followed by:

hdr =3D (struct ipv6_sr_hdr *)skb_transport_header(skb);

I will send a V2, because this first patch in the series can also make
ipv6_rpl_srh_rcv() similar.
(No need to move around the pskb_may_pull(skb, sizeof(*hdr)

