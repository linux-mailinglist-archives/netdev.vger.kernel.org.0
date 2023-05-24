Return-Path: <netdev+bounces-5043-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68F9970F861
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 220F91C20DC4
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B825818AFE;
	Wed, 24 May 2023 14:12:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BD8A955;
	Wed, 24 May 2023 14:12:43 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D72132;
	Wed, 24 May 2023 07:12:41 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2af2db78b38so13283271fa.3;
        Wed, 24 May 2023 07:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684937559; x=1687529559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zxdZqkghugmvEgabqpcrCX2hZgP/Izy7qx2ozu1an0o=;
        b=T6FMbg1D3XGCIeAalO6WtYFOwcMHHu5hXL1jkgfQmOrk+jwlIls/z4f5N7A9vGd7Ps
         33IWs43b3zeyycmycUBqTPk2KYifqA++CpefHLM+H9uNr8o7ufayowPmDeQ42pyT4cIe
         YMOJxb5xp5NTvRfW1iXn6mSVpcTED8pmho4qS7zobdaMd6iaXbNzDz9sF7U+fZn4P3R4
         W7LYwCwgOKazNb3GZnjwSMpXq8DKycnENB7he7u+u2HhEMQzOh3vpIm/chpUS4h4Fba6
         Fls4VOgH5ahMcK3poo/4bd44M50iV23CDzEYjK+Y8DF5Hrt/AJBXpwqZdicIcj+45HXJ
         akpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684937559; x=1687529559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zxdZqkghugmvEgabqpcrCX2hZgP/Izy7qx2ozu1an0o=;
        b=CnwM3hFA4BZz92cZeyHymE1pgYMIE9qwl53NJYHFi0oCtGPeGobuAFCg+DHT4ab/Iu
         9sxAys3MPA8/QC+k4y9NcAxesQY0buVz8gQJhXqz1cn6qPHczpUmca03pq23imVWNHMf
         ZGpUi7cSLkclvDL9ySaCOl2DdjN0zSZgbXTs46as4ybvv0okzXgJOugmU7XkbM5GTOqs
         74SgMmL35Ix7x92G+Scuf1caheU1nmQnPqmSA2wOwLyEmnBVLydaqb31kF13sWIZN/pP
         nhuo4vwMlvJ0xnmsWNLpZz/bOIdystWCH4ZTqSPq+lpx1pVxyie0DJK5ilIjOBQqiuNM
         cAuA==
X-Gm-Message-State: AC+VfDySuNZkhHa4yQbwu8Z5PPkQzuFKDahK/v8U1nNZsfsKDN2BVX5B
	U1Ul9OxZ/fVGioa8N7K/IZqZxTxMD6nMHgvwe80=
X-Google-Smtp-Source: ACHHUZ4qtA9cVLlvjeimyfTbPuY9KBtYMozj61VhTqp5I+/cnVfYagje79+tYAFt2iBi16UupOISe2wJZ8W52AYw6D0=
X-Received: by 2002:a05:651c:14b:b0:2ac:8c95:d42b with SMTP id
 c11-20020a05651c014b00b002ac8c95d42bmr6128695ljd.4.1684937559179; Wed, 24 May
 2023 07:12:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
 <20230518180545.159100-2-maciej.fijalkowski@intel.com> <ZGZ66D8x5Nbp2iYO@google.com>
 <CAADnVQJN6Wt2uiNu+wbmh-MPjxnYneA5gcRXF7Jg+3siACA9aA@mail.gmail.com>
 <SN7PR11MB66554BA6BE57F4CBB407B88290419@SN7PR11MB6655.namprd11.prod.outlook.com>
 <ZG3mkn3gvLmXDUZE@boxer>
In-Reply-To: <ZG3mkn3gvLmXDUZE@boxer>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 24 May 2023 07:12:27 -0700
Message-ID: <CAADnVQK4sRi3stAv31TB3iRZ=_096WUwW49Z49Zh8tNp2fmx0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_desc for
 multi-buffer use
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>, Stanislav Fomichev <sdf@google.com>, 
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Network Development <netdev@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, 
	=?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 3:27=E2=80=AFAM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, May 24, 2023 at 10:56:21AM +0200, Sarkar, Tirthendu wrote:
> > > -----Original Message-----
> > > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > Sent: Friday, May 19, 2023 10:44 PM
> > > To: Stanislav Fomichev <sdf@google.com>
> > > Cc: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>; bpf
> > > <bpf@vger.kernel.org>; Alexei Starovoitov <ast@kernel.org>; Daniel
> > > Borkmann <daniel@iogearbox.net>; Andrii Nakryiko <andrii@kernel.org>;
> > > Network Development <netdev@vger.kernel.org>; Karlsson, Magnus
> > > <magnus.karlsson@intel.com>; Sarkar, Tirthendu
> > > <tirthendu.sarkar@intel.com>; Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org=
>
> > > Subject: Re: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_des=
c for
> > > multi-buffer use
> > >
> > > On Thu, May 18, 2023 at 12:22=E2=80=AFPM Stanislav Fomichev <sdf@goog=
le.com>
> > > wrote:
> > > >
> > > > On 05/18, Maciej Fijalkowski wrote:
> > > > > From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > > > >
> > > > > Use the 'options' field in xdp_desc as a packet continuity marker=
. Since
> > > > > 'options' field was unused till now and was expected to be set to=
 0, the
> > > > > 'eop' descriptor will have it set to 0, while the non-eop descrip=
tors
> > > > > will have to set it to 1. This ensures legacy applications contin=
ue to
> > > > > work without needing any change for single-buffer packets.
> > > > >
> > > > > Add helper functions and extend xskq_prod_reserve_desc() to use t=
he
> > > > > 'options' field.
> > > > >
> > > > > Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > > > > ---
> > > > >  include/uapi/linux/if_xdp.h | 16 ++++++++++++++++
> > > > >  net/xdp/xsk.c               |  8 ++++----
> > > > >  net/xdp/xsk_queue.h         | 12 +++++++++---
> > > > >  3 files changed, 29 insertions(+), 7 deletions(-)
> > > > >
> > > > > diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_=
xdp.h
> > > > > index a78a8096f4ce..4acc3a9430f3 100644
> > > > > --- a/include/uapi/linux/if_xdp.h
> > > > > +++ b/include/uapi/linux/if_xdp.h
> > > > > @@ -108,4 +108,20 @@ struct xdp_desc {
> > > > >
> > > > >  /* UMEM descriptor is __u64 */
> > > > >
> > > > > +/* Flag indicating that the packet continues with the buffer poi=
nted out
> > > by the
> > > > > + * next frame in the ring. The end of the packet is signalled by=
 setting
> > > this
> > > > > + * bit to zero. For single buffer packets, every descriptor has =
'options'
> > > set
> > > > > + * to 0 and this maintains backward compatibility.
> > > > > + */
> > > > > +#define XDP_PKT_CONTD (1 << 0)
> > > > > +
> > > > > +/* Maximum number of descriptors supported as frags for a packet=
. So
> > > the total
> > > > > + * number of descriptors supported for a packet is
> > > XSK_DESC_MAX_FRAGS + 1. The
> > > > > + * max frags supported by skb is 16 for page sizes greater than =
4K and 17
> > > or
> > > >
> > > > This is now a config option CONFIG_MAX_SKB_FRAGS. Can we use it
> > > > directly?
> > >
> > > Also it doesn't look right to expose kernel internal config in uapi
> > > especially since XSK_DESC_MAX_FRAGS is not guaranteed to be 16.
> >
> > Ok, we have couple of options here:
> >
> > Option 1:  We will define XSK_DESC_MAX_FRAGS to 17 now. This will ensur=
e AF_XDP
> >  applications will work on any system without any change since the MAX_=
SKB_FRAGS
> >  is guaranteed to be at least 17.
> >
> > Option 2: Instead of defining a new macro, we say max frags supported i=
s same as
> >  MAX_SKB_FRAGS as configured in your system. So use 17 or less frags if=
 you want
> >  your app to work everywhere but you can go larger if you control the s=
ystem.
> >
> > Any suggestions ?
> >
> > Also Alexei could you please clarify what you meant by ".. since XSK_DE=
SC_MAX_FRAGS
> >  is not guaranteed to be 16." ?
>
> Maybe it would be better to put this define onto patch 08 so people would
> see how it is used and get a feeling of it? Although it has a description
> nothing says about it in commit message.
>
> FWIW i'm voting for option 2, but also Alexei's comment is a bit unclear
> to me, would be nice to hear more about it.

Meaning that uapi can only have fixed constants.
We cannot put *_MAX_FRAGS there, since it's config dependent.

