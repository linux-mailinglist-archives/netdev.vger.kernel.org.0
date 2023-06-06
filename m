Return-Path: <netdev+bounces-8543-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B195D7247E3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22CF01C20967
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A09830B61;
	Tue,  6 Jun 2023 15:36:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6F337B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:35:59 +0000 (UTC)
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA811715
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:35:57 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a1e0cc1a2514c-783f88ce557so2502059241.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 08:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686065756; x=1688657756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p23iNA32uFnEkFn8GnX4X/B5riLGgsg5TF2rE2+nldU=;
        b=7BHeZFldTm74pnQCCUxkbaSiwu2rC2XQOx4c7R5/rftvGUAi3iaGdmZhpU2owwrFFd
         nhtjLoiLBx4QUVOroQJXkIz7Y1s1vWwKuh2LsKcwgAoPDbhsweKllL56fYhkFtV6abY7
         J5UDFTYw3M7J0jbhsvcxuQVSWUYQ6aBi+kvV+kQU9nrErq6EForutbXOblNRJ47pb+XM
         vHEx9laxJFGWtxXjngAmKi7pTcDtjImTxreQFOjwSoO1tIC91NCMHA2ObL1Ng448CQsz
         /BjPNdIkQW0/jMqCa+q5SudZtQ8hAFDMHJ80S0jOh1X7SI89DxnpzupkvWCks/UJHIlc
         5cDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686065756; x=1688657756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p23iNA32uFnEkFn8GnX4X/B5riLGgsg5TF2rE2+nldU=;
        b=Lz1PYpsI4d5J+p0SXBijSW5u/xyQ3AQERgqfbkSGCQFu2PQhfDyB47Z6aZUR3RRywd
         x7IKmkDCFVxw7HVMPVyalbcolUppnbQMx2cMylNw0Ui6T99CyT2K2qCOY/RMndWRVk8T
         R/dpcgic1C7AwPzID/a8fV5fos9s7/QJFwknzXVAI1TFcOngIE5pD0z4m/PLox2qv97K
         9KBEMZiUQfyc1qC7Iqp313qnP8zxgHh48RYtAeUj0guBdHWMhVngcTl+C8Lx0DtutgUz
         Tqj1svA3p9iI6wwq/BUcJQlDE4fH3CMop0RvRWn/qAtH41jZNExoYh7KSFA2Wcja+Kop
         aLtw==
X-Gm-Message-State: AC+VfDwrbXEGwyep1PeK2eLT9HfJerH1KA32pwElqNcYBg3uSaGHvgQn
	q9i/fMGoMxOJDibCiTW27ExLwbERmMxlIRk6wI/Qcw==
X-Google-Smtp-Source: ACHHUZ7XqN+nzBYjvc9jB1cBjMCNPUoGpzXR/k+55RbLphwfonHxsUgI2El8q3Fy3JVnKZE1XjxzOOk36hGtZaLn00Y=
X-Received: by 2002:a05:6102:34da:b0:43b:5646:6ebc with SMTP id
 a26-20020a05610234da00b0043b56466ebcmr20962vst.33.1686065756505; Tue, 06 Jun
 2023 08:35:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605203857.1672816-1-mfreemon@cloudflare.com>
 <20230605154229.6077983e@hermes.local> <20230605154430.65d94106@hermes.local>
 <CAL+tcoBSc51N_cx5AozpKVeN=7u81i_nYcvn6rOUPyVrsevwLA@mail.gmail.com>
 <dfeec14e-738a-bd04-05b4-70a139867ea5@cloudflare.com> <CANn89iJs92TW-FEw0rkp4=z1tbfEYjP9bin281d+SU5Cya2xxw@mail.gmail.com>
In-Reply-To: <CANn89iJs92TW-FEw0rkp4=z1tbfEYjP9bin281d+SU5Cya2xxw@mail.gmail.com>
From: Neal Cardwell <ncardwell@google.com>
Date: Tue, 6 Jun 2023 11:35:37 -0400
Message-ID: <CADVnQy=nuKiVgCG2U+8e2S1Tr5iX1QnD=au39+EBPVXB7J0TQQ@mail.gmail.com>
Subject: Re: [PATCH] Add a sysctl to allow TCP window shrinking in order to
 honor memory limits
To: Eric Dumazet <edumazet@google.com>
Cc: Mike Freemon <mfreemon@cloudflare.com>, Jason Xing <kerneljasonxing@gmail.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org, 
	kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 11:33=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Tue, Jun 6, 2023 at 5:17=E2=80=AFPM Mike Freemon <mfreemon@cloudflare.=
com> wrote:
...
> > I discuss the RFCs in more detail in my blog post here:
> > https://blog.cloudflare.com/unbounded-memory-usage-by-tcp-for-receive-b=
uffers-and-how-we-fixed-it/
>
> Mike, the usual process to push linux patches is to make them self contai=
ned.
>
> changelog should be enough, no need to read a lengthy blog post.
>
> Also, I did not receive a copy of the patch, which is unfortunate,
> given I am the linux TCP maintainer.
>
> Next time you post it, make sure to CC me.
>
> Thanks.

Also, before the repost, can you please rebase  on to the latest
net-next branch? The patch does not currently apply to the latest
net-next tree. Thanks!

neal

