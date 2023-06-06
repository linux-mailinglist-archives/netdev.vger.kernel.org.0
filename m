Return-Path: <netdev+bounces-8541-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A03C7247CE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF7AB280FCD
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD12D2DBDD;
	Tue,  6 Jun 2023 15:33:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA00737B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:33:18 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655851BD
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:33:16 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f7e81f0624so82045e9.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 08:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686065595; x=1688657595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QeQNQ+9uwMncckidJRES3I2PBpLXeTVzvhBnB6ohGE=;
        b=iJpR2LMdEZ0ZB1MuOnp60QrzlF3rtLHZB65C3tEK2S6r4BCddWdxI5gDEVqywu0Yy5
         zxaruA/4Q2Cq3IQ4G2ZsJTGEsD6ZoNRYShqjL6zMOOWpp/n7Pwk/3hPE5nI3vQ5ZSVxb
         P8xSnBEiOB+ELIZzITPwqxlDppvztMOw7y/TDdhkd4ZuUNHkm2LmWyg527IEU9c/uSxG
         3kaTsed0szO7WHdIDvfxNbZ/5nJm4MWlHREb3XkN/Y/Yvci5Fp2Vuunp1WIhlw6wdmHE
         nB5GA7lnxOkEreAJwEQd8gBjjObg+GdN+4IJv1l5hHIn1LTYb4GLAfCin7UMi8POBeCG
         H3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686065595; x=1688657595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0QeQNQ+9uwMncckidJRES3I2PBpLXeTVzvhBnB6ohGE=;
        b=i/ZeB0XqQkpK6RTJGb7T8G+YKxY7QA6vaHPGii8MikO+aXJoQjVKlS3J30Jyy9Oapn
         jHs/5+gSZ3xx9GwFKIgkZFbsDvfz69WXuc0ZY6fDPO5xWf0FQXQUCSU6BxDgW6Gx2cds
         uVXXQO9Vnl9Lx77QcG7XDhixO7UF/N6l0Egc5KXS9T6nVuYQsgk6CC3AdQ/702No39og
         Aa9kWk81AuDdMg+ghHl84rqNiXgiVsU3frEfYda+mllXdf2a6oADqcrV6X+IrFFq4YSn
         gSgSEMkLtNR+h4Y9CiHdwtn8GugzG/cm6zBrtlsWheIpGCeG5+Dds3zY+ZPOzJsA9o/+
         bEfg==
X-Gm-Message-State: AC+VfDyZW6NhgRU/TWA7YyWX3kYVyegIa6pmwo42NgIMoL4ivXj/n+5Z
	iok42SoLGgMvSnCKWYG4X26qnZmZgR/05YKnBaau9Q==
X-Google-Smtp-Source: ACHHUZ56oAogObfEsAxr/Dg4Q6FnwqHGQeywi3AAM97MYPLeWypTXH2goCJiUBtwpFitVDROPsonWXM2TfnYXfgdkCA=
X-Received: by 2002:a05:600c:4695:b0:3f1:70d1:21a6 with SMTP id
 p21-20020a05600c469500b003f170d121a6mr231601wmo.0.1686065594581; Tue, 06 Jun
 2023 08:33:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605203857.1672816-1-mfreemon@cloudflare.com>
 <20230605154229.6077983e@hermes.local> <20230605154430.65d94106@hermes.local>
 <CAL+tcoBSc51N_cx5AozpKVeN=7u81i_nYcvn6rOUPyVrsevwLA@mail.gmail.com> <dfeec14e-738a-bd04-05b4-70a139867ea5@cloudflare.com>
In-Reply-To: <dfeec14e-738a-bd04-05b4-70a139867ea5@cloudflare.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 6 Jun 2023 17:33:02 +0200
Message-ID: <CANn89iJs92TW-FEw0rkp4=z1tbfEYjP9bin281d+SU5Cya2xxw@mail.gmail.com>
Subject: Re: [PATCH] Add a sysctl to allow TCP window shrinking in order to
 honor memory limits
To: Mike Freemon <mfreemon@cloudflare.com>
Cc: Jason Xing <kerneljasonxing@gmail.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, Neal Cardwell <ncardwell@google.com>, 
	netdev@vger.kernel.org, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 5:17=E2=80=AFPM Mike Freemon <mfreemon@cloudflare.co=
m> wrote:
>
>
> On 6/5/23 21:09, Jason Xing wrote:
> > On Tue, Jun 6, 2023 at 6:44=E2=80=AFAM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> >>
> >> On Mon, 5 Jun 2023 15:42:29 -0700
> >> Stephen Hemminger <stephen@networkplumber.org> wrote:
> >>
> >>>> sysctl: net.ipv4.tcp_shrink_window
> >>>>
> >>>> This sysctl changes how the TCP window is calculated.
> >>>>
> >>>> If sysctl tcp_shrink_window is zero (the default value), then the
> >>>> window is never shrunk.
> >>>>
> >>>> If sysctl tcp_shrink_window is non-zero, then the memory limit
> >>>> set by autotuning is honored.  This requires that the TCP window
> >>>> be shrunk ("retracted") as described in RFC 1122.
> >>>>
> >>>> [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
> >>>> [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
> >>>> [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
> >>>> [4] https://www.rfc-editor.org/rfc/rfc793
> >>>> [5] https://www.rfc-editor.org/rfc/rfc1323
> >>>>
> >>>> Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
> >>>
> >>> Does Linux TCP really need another tuning parameter?
> >>> Will tests get run with both feature on and off?
> >>> What default will distributions ship with?
> >>>
> >>> Sounds like unbounded receive window growth is always a bad
> >>> idea and a latent bug.
> >>
> >> FYI - I worked in an environment where every bug fix had to have
> >> a tuning parameter to turn it off. It was a bad idea, driven by
> >> management problems with updating. The number of knobs lead
> >> to confusion and geometric growth in possible code paths.
> >>
> >
> > I agree. More than this, shrinking window prohibited in those classic
> > RFCs could cause unexpected/unwanted behaviour.
>
> I discuss the RFCs in more detail in my blog post here:
> https://blog.cloudflare.com/unbounded-memory-usage-by-tcp-for-receive-buf=
fers-and-how-we-fixed-it/

Mike, the usual process to push linux patches is to make them self containe=
d.

changelog should be enough, no need to read a lengthy blog post.

Also, I did not receive a copy of the patch, which is unfortunate,
given I am the linux TCP maintainer.

Next time you post it, make sure to CC me.

Thanks.

