Return-Path: <netdev+bounces-5121-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6836170FB8E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:20:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36D6E1C20BD6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752EC19E53;
	Wed, 24 May 2023 16:20:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6486B1951F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:20:18 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D8D119
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:20:16 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1ae763f9a94so3378725ad.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684945216; x=1687537216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4KLpXvkvORyHDLUiO5GMhdvg0JeB/9+Ln5TwWcdc8A=;
        b=gMEwYf4946R1PInCu41Xhn5fHAMOGnMmRYO0+02FBBtDC892M3rIaxxSrz23yHC03L
         S6Az+rkQ3WZVzyMhiB8xj1Y5ezmhu21KQXcD+j95bei8QsU0jq8VxsWBQWlDndv2fE8m
         h34EX6NNMNloT+hjBZlXaCyA/mnA5pcmueFtJpXCwFpNUQIzzG7XH8O5P469dlxEdH+I
         xPxBUmKaaj89p/bVTSZsZ1k3LLw2BJ+Ah4Ke8vdvAQHQT4RsN3GachuOYqYVe2E1BUp9
         pO9M2NLX8F1m6kAI8DY2peKuwM7h4Aq5COUOe8nSgVa+hoVNMusz1j/ZsYOZwn8NsvwU
         AVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684945216; x=1687537216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t4KLpXvkvORyHDLUiO5GMhdvg0JeB/9+Ln5TwWcdc8A=;
        b=kgQachO02LZOp8D0Me4KR5cgY0pYyxQ0/FCnuknqJokLS61E+l1Y5iyy89xDFtMQxU
         LNAR6hCCNToIkJzYsBlXmOaJxT2hQ+YLaaJUTTaVOkRgAt8JZZCmD8EDIINKiPODk62s
         AgJAYwg4mODaeI2zLl/47lF+UxdsbvlAHSgHv+KAIcz7zd/j3b/oxeOiSh07UZJAGcAT
         epjsIEvvECkjnjZxX0LnoHFLfhxcMlLBhpB9kgs9Mqzdt3NVLDf1+Z1qbq62k2zuYYSk
         8dGtbbFvxbcguGhNo8p7b5cFcuWJlyCA46KwQgYGTevFoCTdvFoCuvXR+n1UOlzm3MrZ
         yAQw==
X-Gm-Message-State: AC+VfDxP97kM/2wAQ2ibVFAY9qmnKw+6pceEMIDnL/MUVSm5/t8Ct6QX
	2oA89FCRsCCBj8XM/Zxa9E/ypr4/yQxWeM3cVBZ7PQ==
X-Google-Smtp-Source: ACHHUZ47o8I/TIGFj7w9CmWlxnC04ddhiSDHflL6uTJWBDrXeL6wKPMEFLgsBc8JwVO8NKheMDnFew/ztlYi1HQQfZM=
X-Received: by 2002:a17:902:ba8b:b0:1ae:5f7e:c127 with SMTP id
 k11-20020a170902ba8b00b001ae5f7ec127mr16319360pls.40.1684945215952; Wed, 24
 May 2023 09:20:15 -0700 (PDT)
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
 <ZG3mkn3gvLmXDUZE@boxer> <CAADnVQK4sRi3stAv31TB3iRZ=_096WUwW49Z49Zh8tNp2fmx0A@mail.gmail.com>
In-Reply-To: <CAADnVQK4sRi3stAv31TB3iRZ=_096WUwW49Z49Zh8tNp2fmx0A@mail.gmail.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Wed, 24 May 2023 09:20:05 -0700
Message-ID: <CAKH8qBsKxAzP+sU5diPjtmhsJG2zCYPy4URZJKU3XaV9jjiDHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_desc for
 multi-buffer use
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
	"Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>, bpf <bpf@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Network Development <netdev@vger.kernel.org>, 
	"Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 7:12=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, May 24, 2023 at 3:27=E2=80=AFAM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Wed, May 24, 2023 at 10:56:21AM +0200, Sarkar, Tirthendu wrote:
> > > > -----Original Message-----
> > > > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > > Sent: Friday, May 19, 2023 10:44 PM
> > > > To: Stanislav Fomichev <sdf@google.com>
> > > > Cc: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>; bpf
> > > > <bpf@vger.kernel.org>; Alexei Starovoitov <ast@kernel.org>; Daniel
> > > > Borkmann <daniel@iogearbox.net>; Andrii Nakryiko <andrii@kernel.org=
>;
> > > > Network Development <netdev@vger.kernel.org>; Karlsson, Magnus
> > > > <magnus.karlsson@intel.com>; Sarkar, Tirthendu
> > > > <tirthendu.sarkar@intel.com>; Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.o=
rg>
> > > > Subject: Re: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_d=
esc for
> > > > multi-buffer use
> > > >
> > > > On Thu, May 18, 2023 at 12:22=E2=80=AFPM Stanislav Fomichev <sdf@go=
ogle.com>
> > > > wrote:
> > > > >
> > > > > On 05/18, Maciej Fijalkowski wrote:
> > > > > > From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > > > > >
> > > > > > Use the 'options' field in xdp_desc as a packet continuity mark=
er. Since
> > > > > > 'options' field was unused till now and was expected to be set =
to 0, the
> > > > > > 'eop' descriptor will have it set to 0, while the non-eop descr=
iptors
> > > > > > will have to set it to 1. This ensures legacy applications cont=
inue to
> > > > > > work without needing any change for single-buffer packets.
> > > > > >
> > > > > > Add helper functions and extend xskq_prod_reserve_desc() to use=
 the
> > > > > > 'options' field.
> > > > > >
> > > > > > Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > > > > > ---
> > > > > >  include/uapi/linux/if_xdp.h | 16 ++++++++++++++++
> > > > > >  net/xdp/xsk.c               |  8 ++++----
> > > > > >  net/xdp/xsk_queue.h         | 12 +++++++++---
> > > > > >  3 files changed, 29 insertions(+), 7 deletions(-)
> > > > > >
> > > > > > diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/i=
f_xdp.h
> > > > > > index a78a8096f4ce..4acc3a9430f3 100644
> > > > > > --- a/include/uapi/linux/if_xdp.h
> > > > > > +++ b/include/uapi/linux/if_xdp.h
> > > > > > @@ -108,4 +108,20 @@ struct xdp_desc {
> > > > > >
> > > > > >  /* UMEM descriptor is __u64 */
> > > > > >
> > > > > > +/* Flag indicating that the packet continues with the buffer p=
ointed out
> > > > by the
> > > > > > + * next frame in the ring. The end of the packet is signalled =
by setting
> > > > this
> > > > > > + * bit to zero. For single buffer packets, every descriptor ha=
s 'options'
> > > > set
> > > > > > + * to 0 and this maintains backward compatibility.
> > > > > > + */
> > > > > > +#define XDP_PKT_CONTD (1 << 0)
> > > > > > +
> > > > > > +/* Maximum number of descriptors supported as frags for a pack=
et. So
> > > > the total
> > > > > > + * number of descriptors supported for a packet is
> > > > XSK_DESC_MAX_FRAGS + 1. The
> > > > > > + * max frags supported by skb is 16 for page sizes greater tha=
n 4K and 17
> > > > or
> > > > >
> > > > > This is now a config option CONFIG_MAX_SKB_FRAGS. Can we use it
> > > > > directly?
> > > >
> > > > Also it doesn't look right to expose kernel internal config in uapi
> > > > especially since XSK_DESC_MAX_FRAGS is not guaranteed to be 16.
> > >
> > > Ok, we have couple of options here:
> > >
> > > Option 1:  We will define XSK_DESC_MAX_FRAGS to 17 now. This will ens=
ure AF_XDP
> > >  applications will work on any system without any change since the MA=
X_SKB_FRAGS
> > >  is guaranteed to be at least 17.
> > >
> > > Option 2: Instead of defining a new macro, we say max frags supported=
 is same as
> > >  MAX_SKB_FRAGS as configured in your system. So use 17 or less frags =
if you want
> > >  your app to work everywhere but you can go larger if you control the=
 system.
> > >
> > > Any suggestions ?
> > >
> > > Also Alexei could you please clarify what you meant by ".. since XSK_=
DESC_MAX_FRAGS
> > >  is not guaranteed to be 16." ?
> >
> > Maybe it would be better to put this define onto patch 08 so people wou=
ld
> > see how it is used and get a feeling of it? Although it has a descripti=
on
> > nothing says about it in commit message.
> >
> > FWIW i'm voting for option 2, but also Alexei's comment is a bit unclea=
r
> > to me, would be nice to hear more about it.
>
> Meaning that uapi can only have fixed constants.
> We cannot put *_MAX_FRAGS there, since it's config dependent.

Same here, would prefer option 2. And don't put it in the uapi. That's
something the users can try to probe maybe?

