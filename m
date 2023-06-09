Return-Path: <netdev+bounces-9696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C8C372A417
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 277922819E6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0345621CE5;
	Fri,  9 Jun 2023 20:08:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4438408DB;
	Fri,  9 Jun 2023 20:08:16 +0000 (UTC)
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7813A1B9;
	Fri,  9 Jun 2023 13:08:15 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b1b084620dso24706451fa.0;
        Fri, 09 Jun 2023 13:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686341294; x=1688933294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxIcw8cD6UcVQayinm2KAK8jFf6IXGi65++QhI5QkgU=;
        b=hf1bkrbpIy3rmJhKROt1wF/PtA6UAZ8enkWSXf5DtdnUq6+MmIEA7hy+Ncs8oP9Nck
         61W0ZdrDaet8k05vYL3ncqQNzxzIfi3ze2UifexGxHEfaY4JwrZaA1jabV6qWjW9Txh1
         b9939tLQtvNNYHUYA7Q7kM9Plrjdn/VBJ+fmcDy6zwWvZMbLWaesjpCB05ai/euABY9t
         HVUgeGt3JLbylNfT85rJtXnb8/G6EITMqOM84azSb02AdyqR9HqVOf9a+bUh9eOIduVL
         OtgdDM+t5Pt0FMf6ZSHfhUEgTaOeIkaK2C6kHqUkyAg39p7YCOpm1Ea0djKCA+ufj5LR
         NQjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686341294; x=1688933294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nxIcw8cD6UcVQayinm2KAK8jFf6IXGi65++QhI5QkgU=;
        b=H9EjZDAMDf3fJw7963dM02QGlsN8+NNU1OufQlbHi+y7H4l80c0rp5xhCmBd6Us4ur
         nomm4FuJCPWcKPcoY1Bs+uO3d0VgJv0RgwbGHJW/0XWtvLpYzuEygyjyybyV5A1BJz9U
         3jWzy6MLa4PjsIOY+SAERrvQcREpyz7D2CH8623X5ajOCKZsOg0KP6mNolyOZ320YCLe
         WAaHdUnhuzfLLX6oIRwmROtZN9J2JdNPvs0y9QxP6G8r13S3q74LtE8AtCr6Xz8UXHWp
         YUYZGl0oF83CziaIic25DXEJyQgcPrwFlW1Klnl1XDK4HLqZTaOLWQI7EyOPy6tE8v3H
         IbYQ==
X-Gm-Message-State: AC+VfDyLyDukXfkccg06BsQM9oJ4Np7gMXx9LRy0XpQ3HdXkzpAxz2cL
	594lwoYTpBoSWwVOaQ+23uL5pMTsbakpD9Q953I=
X-Google-Smtp-Source: ACHHUZ4yWMaHFntaXosNeHfz1xBdkDaHo2fFSbmlO61d1ZAMgiob7mh1VPV+CR0wCCejv+ES6I6g0tooKqZUW1vGgTY=
X-Received: by 2002:a2e:b163:0:b0:2b0:a4b1:df6 with SMTP id
 a3-20020a2eb163000000b002b0a4b10df6mr1511227ljm.49.1686341293303; Fri, 09 Jun
 2023 13:08:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com> <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com> <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <87a5x91nr8.fsf@toke.dk> <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net>
 <874jng28xk.fsf@toke.dk> <1a73a1b9-c72a-de81-4fce-7ba4fb6d7900@incline.eu>
 <87sfb0zsok.fsf@toke.dk> <CAEf4BzYnZ0XoTY=JHEq3iicP8OVPDHfziJ=q_7_F5O=B0pX6tw@mail.gmail.com>
In-Reply-To: <CAEf4BzYnZ0XoTY=JHEq3iicP8OVPDHfziJ=q_7_F5O=B0pX6tw@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 9 Jun 2023 13:08:01 -0700
Message-ID: <CAADnVQKLZ77pU7EAWPWzL=sCbJgUtZ3u-=Ma-Gf3T3kryYnh_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	Timo Beckers <timo@incline.eu>, Daniel Borkmann <daniel@iogearbox.net>, 
	Stanislav Fomichev <sdf@google.com>, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Nikolay Aleksandrov <razor@blackwall.org>, 
	John Fastabend <john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>, 
	Joe Stringer <joe@cilium.io>, "David S. Miller" <davem@davemloft.net>, bpf <bpf@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 11:56=E2=80=AFAM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> Me, Daniel, Timo are arguing that there are real situations where you
> have to be first or need to die.

afaik out of all xdp and tc progs there is not a single prog in the fb flee=
t
that has to be first.
fb's ddos and firewall don't have to be first.
cilium and datadog progs don't have to be first either.
The race between cilium and datadog was not the race to the first position,
but the conflict due to the same prio.
In all cases, I'm aware, prog owners care a lot about ordering,
but never about strict first.

