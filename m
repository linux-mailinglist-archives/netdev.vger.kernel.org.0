Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C5B64CFAF
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 19:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbiLNSoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 13:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238935AbiLNSoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 13:44:19 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9774A2A943
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 10:44:15 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso118944pjh.1
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 10:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cw3B/81u2H2+N7G7TRZJRJnoU5pzkMNrTipR+QI1Vp8=;
        b=Q0cwVZkQj/5qxPW5Mr42GmlV37bQqcySReLDNfHGO4dIbWXhxVQS//C3n4pBa/7SYh
         rMHfjkk2sSlHm+F/HlgDML3TXO8QNZa76xfPB9VV7bRRcAq1yTvCbCfQqtt508LRhdqF
         mBJttilrVkUacrwHuFUNdCoyINVUYwjXuDSqTHY3wuIj65hSUIAerqZufcc2NvBSw4kh
         /Cr1BUSvKv5JIUIiq+/FhusoNFOwGFD8F9oqTG3fgFJ74dtgtruvgziXiur9f2slv0rG
         VjO4fLw7UQrknzq81f3bAIIEIIcb/VT+FRUt+3O510VfnU/FP3IFifsie1KLHLRw7Wmx
         bp2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cw3B/81u2H2+N7G7TRZJRJnoU5pzkMNrTipR+QI1Vp8=;
        b=r6f1NktyqXpuNgWp58C+bZoBQvDYQtjJaA+NfaUrGey3LY0nO45JtB4t6rwIoUU5/U
         yHdu2iDVNf3aIhQSl0njA72r0ol9EY8sjT3NPXilYl/PzGhyigsbp5MvTKKpWgeoR6xr
         3278Gqf7qL0wwW0NsUTemaHg6buWfyiWEKgJweIQCmUMhkbrlkfbT1B6i64wOd+uKizj
         ZGaM6zzmkRn70plsaUlVhJ3qIzO8soLuvaZxT6fPNwzdmVO/7XN9jHIX1NS1pzT4GWYb
         +yZtRJ4rVgnbsgRbsrYk9H2vyWts2X6rL5PIoVvU+vSjLbPdB8cRYON1U5eEgg002Bb+
         MhjQ==
X-Gm-Message-State: AFqh2kogg/6tx/DHyqbDoXvAz03+NgIRgg1TySYKwzfBqiVTiXRwBAkN
        HHTHwIUiTuiz/pbDk6OKsLVJ6qNEHLC6t6+/oycTIA==
X-Google-Smtp-Source: AMrXdXsE/DTSMUCTV3gxuVwfJz087oOaEvx9mV4YqNsqVW2nzRFnf5s3qjXuJnAzjA3MV5MGBwmxJlqxGonZh6GxORU=
X-Received: by 2002:a17:90a:c389:b0:218:9107:381b with SMTP id
 h9-20020a17090ac38900b002189107381bmr390975pjt.75.1671043454940; Wed, 14 Dec
 2022 10:44:14 -0800 (PST)
MIME-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com> <20221213023605.737383-9-sdf@google.com>
 <7ca8ac2c-7c07-a52f-ec17-d1ba86fa45ab@redhat.com> <CAKH8qBvCxnJ2-5gd9j1HYxMA8CNi6cQM-5WOUBghiZjHUHya3A@mail.gmail.com>
 <4bac619d-8767-1364-1924-78c05b1ecf88@redhat.com> <87a63qgt30.fsf@toke.dk> <de85f811-8b2f-3ded-53b4-5f6d5e165e04@linux.dev>
In-Reply-To: <de85f811-8b2f-3ded-53b4-5f6d5e165e04@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 14 Dec 2022 10:44:02 -0800
Message-ID: <CAKH8qBviEiSFb8J5RiEE-xeGFrbLhbco4S=LSkwtqBnG5_udvQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v4 08/15] veth: Support RX XDP metadata
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 10:09 AM Martin KaFai Lau <martin.lau@linux.dev> wr=
ote:
>
> On 12/14/22 2:47 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
> >
> >> On 13/12/2022 21.42, Stanislav Fomichev wrote:
> >>> On Tue, Dec 13, 2022 at 7:55 AM Jesper Dangaard Brouer
> >>> <jbrouer@redhat.com> wrote:
> >>>>
> >>>>
> >>>> On 13/12/2022 03.35, Stanislav Fomichev wrote:
> >>>>> The goal is to enable end-to-end testing of the metadata for AF_XDP=
.
> >>>>>
> >>>>> Cc: John Fastabend <john.fastabend@gmail.com>
> >>>>> Cc: David Ahern <dsahern@gmail.com>
> >>>>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> >>>>> Cc: Jakub Kicinski <kuba@kernel.org>
> >>>>> Cc: Willem de Bruijn <willemb@google.com>
> >>>>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> >>>>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> >>>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> >>>>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> >>>>> Cc: Maryam Tahhan <mtahhan@redhat.com>
> >>>>> Cc: xdp-hints@xdp-project.net
> >>>>> Cc: netdev@vger.kernel.org
> >>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >>>>> ---
> >>>>>     drivers/net/veth.c | 24 ++++++++++++++++++++++++
> >>>>>     1 file changed, 24 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> >>>>> index 04ffd8cb2945..d5491e7a2798 100644
> >>>>> --- a/drivers/net/veth.c
> >>>>> +++ b/drivers/net/veth.c
> >>>>> @@ -118,6 +118,7 @@ static struct {
> >>>>>
> >>>>>     struct veth_xdp_buff {
> >>>>>         struct xdp_buff xdp;
> >>>>> +     struct sk_buff *skb;
> >>>>>     };
> >>>>>
> >>>>>     static int veth_get_link_ksettings(struct net_device *dev,
> >>>>> @@ -602,6 +603,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struc=
t veth_rq *rq,
> >>>>>
> >>>>>                 xdp_convert_frame_to_buff(frame, xdp);
> >>>>>                 xdp->rxq =3D &rq->xdp_rxq;
> >>>>> +             vxbuf.skb =3D NULL;
> >>>>>
> >>>>>                 act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> >>>>>
> >>>>> @@ -823,6 +825,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct =
veth_rq *rq,
> >>>>>         __skb_push(skb, skb->data - skb_mac_header(skb));
> >>>>>         if (veth_convert_skb_to_xdp_buff(rq, xdp, &skb))
> >>>>>                 goto drop;
> >>>>> +     vxbuf.skb =3D skb;
> >>>>>
> >>>>>         orig_data =3D xdp->data;
> >>>>>         orig_data_end =3D xdp->data_end;
> >>>>> @@ -1601,6 +1604,21 @@ static int veth_xdp(struct net_device *dev, =
struct netdev_bpf *xdp)
> >>>>>         }
> >>>>>     }
> >>>>>
> >>>>> +static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *ti=
mestamp)
> >>>>> +{
> >>>>> +     *timestamp =3D ktime_get_mono_fast_ns();
> >>>>
> >>>> This should be reading the hardware timestamp in the SKB.
> >>>>
> >>>> Details: This hardware timestamp in the SKB is located in
> >>>> skb_shared_info area, which is also available for xdp_frame (current=
ly
> >>>> used for multi-buffer purposes).  Thus, when adding xdp-hints "store=
"
> >>>> functionality, it would be natural to store the HW TS in the same pl=
ace.
> >>>> Making the veth skb/xdp_frame code paths able to share code.
> >>>
> >>> Does something like the following look acceptable as well?
> >>>
> >>> *timestamp =3D skb_hwtstamps(_ctx->skb)->hwtstamp;
>
> If it is to test the kfunc and ensure veth_xdp_rx_timestamp is called, th=
is
> alone should be enough. skb_hwtstamps(_ctx->skb)->hwtstamp should be 0 if
> hwtstamp is unavailable?  The test can initialize the 'u64 *timestamp' ar=
g to
> non-zero first.  If it is not good enough, an fentry tracing can be done =
to
> veth_xdp_rx_timestamp to ensure it is called also.  There is also fmod_re=
t that
> could change the return value but the timestamp is not the return value t=
hough.
>
> If the above is not enough, another direction of thought could be doing i=
t
> through bpf_prog_test_run_xdp() but it will need a way to initialize the
> veth_xdp_buff.
>
> That said, overall, I don't think it is a good idea to bend the
> veth_xdp_rx_timestamp kfunc too much only for testing purpose unless ther=
e is no
> other way out.

Oh, good point about just making sure veth_xdp_rx_timestamp returns
timestamp=3D0. That should be enough, thanks!
