Return-Path: <netdev+bounces-8101-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B6EE722B21
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BDCF1C20988
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A68206AD;
	Mon,  5 Jun 2023 15:34:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E909B1F943
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:34:14 +0000 (UTC)
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D82C98
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:34:13 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-777b0dd72d8so44978339f.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 08:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685979253; x=1688571253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vehFuTibUQE6rDWiuW/4cOohdU3NxIO3vjlm4fitmKQ=;
        b=TjmT7JT3jSiPgP3gVCFooJbq2ntXatJE+s7928ctVBw37e5IrI6eZnhRH+y+INE/jc
         uBRjM0STqp08JkOPBT1wJDlpT0h/Xa8OHdrz5DANtNSRnVclSG2Z1XaMko3EpyyNRU9s
         jRwsVUkTkB+vdZh854e6tPImsUJbKdQmHclordiU72Ab+BzkP0gvmr1nArYi9N6Ir3EE
         QAv5znwZyQngOMq+v/iPI8wPtprXqtD0Xa+FeTpTQs+Yqbcfbnx0K/MmRHMBQiOG8Gxs
         WMDakqKjTlrT78Pza/VegEn42e2V+xVdlyhi+z5zF6tpsPTBnAIKf5HF5l2uM9x+fla3
         0jOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979253; x=1688571253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vehFuTibUQE6rDWiuW/4cOohdU3NxIO3vjlm4fitmKQ=;
        b=Xf5PuRmHBaCcUrLNH54jT1kqzkTajFWxF31Qy5smE4n04e17mgxUobOrjtqoL8uo2p
         GtEgebcU6X2tjbDNGO0zj9M49IJSUpZb47QArO5D8daJyM8IMhBhk0rOFrZ9y72iC0sG
         tv1YCODPpF3dVZH61BoF0xeZ8DPbPjOzHi+kcQFcUEwTT8u4G0fiNL3jddJg/JHpxphT
         xx9l4VQOmiW423L05fWa028KkA7hM7M+6BapEr1z717eg5kba6EwtG8b4gbyyQjnKEYK
         nLg+7JRVZZNSOeqr6XaZrtO5QLj+R4zZj4kJM5DuhqhqYYQ3GB4AOHME3TRRrDPMWZWk
         0w1w==
X-Gm-Message-State: AC+VfDyCAYGZH/htzvzykFLVh+tbbgcpAxe3x/bnSm4LrXRk1TuyR3YR
	YZbOqvgkM7E2oGkOHPxCLatEQTwGYNP+c4wEnsOqJIRgm3Xl0vIx
X-Google-Smtp-Source: ACHHUZ4de8j4ijyX8sBt0bCr7yXSqXavmAP5hAIgUCSdRf73BOGN1UlJL5IuHnYd68MWnuCknuMKRELgX4dzKsQ9LYs=
X-Received: by 2002:a6b:d603:0:b0:760:f795:ccdf with SMTP id
 w3-20020a6bd603000000b00760f795ccdfmr220601ioa.8.1685979252890; Mon, 05 Jun
 2023 08:34:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-12-jhs@mojatatu.com>
 <ZH23+403sRcabGa5@corigine.com> <CAAFAkD-=hLQzZoPtuvc0aaV8pOd8b=z2G8bYqsqM7qdKUeSB=g@mail.gmail.com>
 <ZH37za6g7UU9NPgO@corigine.com>
In-Reply-To: <ZH37za6g7UU9NPgO@corigine.com>
From: Jamal Hadi Salim <hadi@mojatatu.com>
Date: Mon, 5 Jun 2023 11:34:02 -0400
Message-ID: <CAAFAkD_SPxZ+dF=X-R8YOhe2PTbrZiafgWdN5e-20Yv-TSQH9A@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 12/28] p4tc: add
 header field create, get, delete, flush and dump
To: Simon Horman <simon.horman@corigine.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org, deb.chatterjee@intel.com, 
	tom@sipanda.io, p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com, 
	Vipin.Jain@amd.com, tomasz.osinski@intel.com, xiyou.wangcong@gmail.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 11:14=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Mon, Jun 05, 2023 at 10:48:18AM -0400, Jamal Hadi Salim wrote:
> > On Mon, Jun 5, 2023 at 6:25=E2=80=AFAM Simon Horman via p4tc-discussion=
s
> > <p4tc-discussions@netdevconf.info> wrote:
> > >
> > > On Wed, May 17, 2023 at 07:02:16AM -0400, Jamal Hadi Salim wrote:
> > >
> > > ...
> > >
> > > Hi Victor, Pedro and Jamal,
> > >
> > > some minor feedback from my side.
> > >
> > > > +static int _tcf_hdrfield_fill_nlmsg(struct sk_buff *skb,
> > > > +                                 struct p4tc_hdrfield *hdrfield)
> > > > +{
> > > > +     unsigned char *b =3D nlmsg_get_pos(skb);
> > > > +     struct p4tc_hdrfield_ty hdr_arg;
> > > > +     struct nlattr *nest;
> > > > +     /* Parser instance id + header field id */
> > > > +     u32 ids[2];
> > > > +
> > > > +     ids[0] =3D hdrfield->parser_inst_id;
> > > > +     ids[1] =3D hdrfield->hdrfield_id;
> > > > +
> > > > +     if (nla_put(skb, P4TC_PATH, sizeof(ids), ids))
> > > > +             goto out_nlmsg_trim;
> > > > +
> > > > +     nest =3D nla_nest_start(skb, P4TC_PARAMS);
> > > > +     if (!nest)
> > > > +             goto out_nlmsg_trim;
> > > > +
> > > > +     hdr_arg.datatype =3D hdrfield->datatype;
> > > > +     hdr_arg.startbit =3D hdrfield->startbit;
> > > > +     hdr_arg.endbit =3D hdrfield->endbit;
> > >
> > > There may be padding at the end of hdr_arg,
> > > which is passed uninitialised to nla_put below.
> >
> > Yeah, same comment as the metadata case; we could add initialization
> > or add PADx at the end. Or maybe there's another approach you had in
> > mind.
>
> Thanks. Yes it is  the same comment, sorry for the duplicate.
> No, I don't have suggestions other than the ones you have made.

It was a useful comment (and appreciated). We'll pick one of those two
approaches i mentioned....

cheers,
jamal

