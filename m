Return-Path: <netdev+bounces-3969-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74DF6709DA7
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32077281D6B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0938125D9;
	Fri, 19 May 2023 17:13:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A5210942;
	Fri, 19 May 2023 17:13:59 +0000 (UTC)
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD8D139;
	Fri, 19 May 2023 10:13:58 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2ac82912a59so39195121fa.3;
        Fri, 19 May 2023 10:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684516436; x=1687108436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BghFx5w7wnNzUQQ7dFY+195/WVe7VxSH2h3LTWsVywI=;
        b=ZhujQhd4XphaWxGe+IPcOCTbyhO/EsPnpfza8YPbhsfBV/STzlOrGaV/y80/aLflC5
         GQsge1wvLdsfHhzOk+vo+emFf5pIrgZOeoIoGVzuAVJd+q6lSFjS/FkfsIgptNnWbYyQ
         OGWJt2ygHehlqbc+I1MtA4YjDiFzqkGnH3LYUhSaV30UO9b2HhRXss+I/5jtbiEqYql8
         wtY00OIFHEqW2GyVsE3CnuyPYmmp/54o0JiXSW3pynGwAKsT9zUGdu3dz1HeK/+cmYTy
         Cl9rO/xivQcWt4S7tOA2hw4JzSKxST478HnYEWAcQF0mPWadTac/AdEo43GWwABWALIM
         7H0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684516436; x=1687108436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BghFx5w7wnNzUQQ7dFY+195/WVe7VxSH2h3LTWsVywI=;
        b=YpMUETvcj/ms+Rcpl1Y7HsV6kYeDZKvnRo+yLvoMKU536zoZRauNyl9S6K175A1ML8
         yAVHAQyRgvujxLuAbdofFoJUf4yMy2e9NeXkIMAoFMwkdcjTPKJmhT/13QD3wu2fIBaA
         rBSK5+qfA8rwPhgtS+t6ytnJe4ym35+a720aGC8BZwWUaVu7WiwG04YkHX2cKap8rkkc
         bZbKN2iun4uiZiEuNUL5BvzLJ57peK+zQyf3QThNIoC05kb/T5AxsqAcSx8Sa4pAjixo
         h6RaRks2LmuDJXil3wnCB/9rZ0/m9ijEtZ8ZuNjLpbcSGB/KSXSs0zqSWX3jLB5QtDFM
         HSGQ==
X-Gm-Message-State: AC+VfDwVTg5qeuRzkUpacDYC6d7KVxphyW7b1iJpaUmZ+ChayVlQMYSb
	aA9MKzETy64mb9vQvnu0GvfF/IBk2E+/EAspy3k=
X-Google-Smtp-Source: ACHHUZ6VpN2ajvcwQof0gno09WgAXGCIgfqeW2HLzchkh6qCciycrF0aEjEWx0uWnMj9kd1suYNt3tyTZp/sSHSQhUI=
X-Received: by 2002:ac2:5314:0:b0:4f0:206a:9fae with SMTP id
 c20-20020ac25314000000b004f0206a9faemr1004763lfh.11.1684516436141; Fri, 19
 May 2023 10:13:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
 <20230518180545.159100-2-maciej.fijalkowski@intel.com> <ZGZ66D8x5Nbp2iYO@google.com>
In-Reply-To: <ZGZ66D8x5Nbp2iYO@google.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 19 May 2023 10:13:44 -0700
Message-ID: <CAADnVQJN6Wt2uiNu+wbmh-MPjxnYneA5gcRXF7Jg+3siACA9aA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_desc for
 multi-buffer use
To: Stanislav Fomichev <sdf@google.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, bpf <bpf@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Network Development <netdev@vger.kernel.org>, 
	"Karlsson, Magnus" <magnus.karlsson@intel.com>, tirthendu.sarkar@intel.com, 
	=?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 12:22=E2=80=AFPM Stanislav Fomichev <sdf@google.com=
> wrote:
>
> On 05/18, Maciej Fijalkowski wrote:
> > From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> >
> > Use the 'options' field in xdp_desc as a packet continuity marker. Sinc=
e
> > 'options' field was unused till now and was expected to be set to 0, th=
e
> > 'eop' descriptor will have it set to 0, while the non-eop descriptors
> > will have to set it to 1. This ensures legacy applications continue to
> > work without needing any change for single-buffer packets.
> >
> > Add helper functions and extend xskq_prod_reserve_desc() to use the
> > 'options' field.
> >
> > Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > ---
> >  include/uapi/linux/if_xdp.h | 16 ++++++++++++++++
> >  net/xdp/xsk.c               |  8 ++++----
> >  net/xdp/xsk_queue.h         | 12 +++++++++---
> >  3 files changed, 29 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> > index a78a8096f4ce..4acc3a9430f3 100644
> > --- a/include/uapi/linux/if_xdp.h
> > +++ b/include/uapi/linux/if_xdp.h
> > @@ -108,4 +108,20 @@ struct xdp_desc {
> >
> >  /* UMEM descriptor is __u64 */
> >
> > +/* Flag indicating that the packet continues with the buffer pointed o=
ut by the
> > + * next frame in the ring. The end of the packet is signalled by setti=
ng this
> > + * bit to zero. For single buffer packets, every descriptor has 'optio=
ns' set
> > + * to 0 and this maintains backward compatibility.
> > + */
> > +#define XDP_PKT_CONTD (1 << 0)
> > +
> > +/* Maximum number of descriptors supported as frags for a packet. So t=
he total
> > + * number of descriptors supported for a packet is XSK_DESC_MAX_FRAGS =
+ 1. The
> > + * max frags supported by skb is 16 for page sizes greater than 4K and=
 17 or
>
> This is now a config option CONFIG_MAX_SKB_FRAGS. Can we use it
> directly?

Also it doesn't look right to expose kernel internal config in uapi
especially since XSK_DESC_MAX_FRAGS is not guaranteed to be 16.

