Return-Path: <netdev+bounces-8259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 409E5723513
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 04:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 062CD2814EE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 026EA38F;
	Tue,  6 Jun 2023 02:10:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF627F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:10:08 +0000 (UTC)
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEA2114
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:10:07 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id 006d021491bc7-558565cc58fso4270720eaf.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 19:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686017407; x=1688609407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8891B5UJGA71rPK3Yvg2KUpGKB+05OxWyZhdYBeaIU=;
        b=BlUBFUwF2MFviNeZyacqVRLddaPi0+Agnea4rRRaJRCqLAglocmvhYhnj0ZKkGYVNh
         oLJusnMR4aI1C1+Y20UtI1V4av7NC6HIe3nEhWwk0Hhbb+/0h6F7Cwzprc+axIQknZ++
         k7lJYGywe0r5vI691qvPpQtsGg4Fr3QAdIZUTFeU/gdK7jLxBnH/TztXo/jNkJWGifq+
         0nOqHdyOoZdzY0qIm1jBqAdZzWRA4vPaf0piHsgIXRlK8mCAl85FnWh6kAav4cEUzqE3
         Ssr1boFaF/EJZQYmkoq0n/XZpdi82T39QlDLXj3RIWukaLJEzSskdDh2ojBc1cLxyVqC
         bT9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686017407; x=1688609407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m8891B5UJGA71rPK3Yvg2KUpGKB+05OxWyZhdYBeaIU=;
        b=NzyxN573rEEGpebr7D68TTj0xPHp9uzoPD/HqZbFiRMIg9QGgxAR4rhWvImphti+Hy
         45udreoEt2vFTEneu53NjsNNxm8OlgjOr6VinTfK6zN0kODes2iWJtFEE1aV98eNz6J1
         5ue0ZfOTuPdyRqt7IsgdVPjtlaRIrUQgOXM0GriydcfSv629XHXKMNO+cYI3hnvSsbc0
         zJygQuCDp7NTVxskj71wP9hoXVLVvb1yf9c1VEz+xVg0vPRwiERD6RwuJm3hiPzVmwGE
         FrBU4VVOieRxmNM/EJCJh98ROIgN2kTJm/uZtiw90kZgEv5iFsuqODd84DLMIoxUQPyZ
         8CGQ==
X-Gm-Message-State: AC+VfDxRJrLXOUu6l9dKnb+ly7EFuBYa1aPmtaIEKxy1yxcjm7glkQ+i
	lKZ6QOAnDXnJMKW3CualvFEvoQB/j0YnyWeQ2bk=
X-Google-Smtp-Source: ACHHUZ7MLRy7Crqk95bpqB9X3lB06KdZyZfmSWwc+TENFzfvTyg8gVthVG2P32AQuhkFubEkjJHx2yuSSmxEfsoLHV0=
X-Received: by 2002:a4a:d9c3:0:b0:558:ac05:eaf4 with SMTP id
 l3-20020a4ad9c3000000b00558ac05eaf4mr561320oou.1.1686017406769; Mon, 05 Jun
 2023 19:10:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605203857.1672816-1-mfreemon@cloudflare.com>
 <20230605154229.6077983e@hermes.local> <20230605154430.65d94106@hermes.local>
In-Reply-To: <20230605154430.65d94106@hermes.local>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 6 Jun 2023 10:09:30 +0800
Message-ID: <CAL+tcoBSc51N_cx5AozpKVeN=7u81i_nYcvn6rOUPyVrsevwLA@mail.gmail.com>
Subject: Re: [PATCH] Add a sysctl to allow TCP window shrinking in order to
 honor memory limits
To: Stephen Hemminger <stephen@networkplumber.org>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>
Cc: Mike Freemon <mfreemon@cloudflare.com>, netdev@vger.kernel.org, 
	kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 6:44=E2=80=AFAM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 5 Jun 2023 15:42:29 -0700
> Stephen Hemminger <stephen@networkplumber.org> wrote:
>
> > > sysctl: net.ipv4.tcp_shrink_window
> > >
> > > This sysctl changes how the TCP window is calculated.
> > >
> > > If sysctl tcp_shrink_window is zero (the default value), then the
> > > window is never shrunk.
> > >
> > > If sysctl tcp_shrink_window is non-zero, then the memory limit
> > > set by autotuning is honored.  This requires that the TCP window
> > > be shrunk ("retracted") as described in RFC 1122.
> > >
> > > [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
> > > [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
> > > [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
> > > [4] https://www.rfc-editor.org/rfc/rfc793
> > > [5] https://www.rfc-editor.org/rfc/rfc1323
> > >
> > > Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
> >
> > Does Linux TCP really need another tuning parameter?
> > Will tests get run with both feature on and off?
> > What default will distributions ship with?
> >
> > Sounds like unbounded receive window growth is always a bad
> > idea and a latent bug.
>
> FYI - I worked in an environment where every bug fix had to have
> a tuning parameter to turn it off. It was a bad idea, driven by
> management problems with updating. The number of knobs lead
> to confusion and geometric growth in possible code paths.
>

I agree. More than this, shrinking window prohibited in those classic
RFCs could cause unexpected/unwanted behaviour.

CC: Eric and Neal

Thanks,
Jason

