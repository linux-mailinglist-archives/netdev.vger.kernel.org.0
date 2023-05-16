Return-Path: <netdev+bounces-3019-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1A57050A5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:26:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA7F01C20EDF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9586B23D57;
	Tue, 16 May 2023 14:26:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8722734CEC;
	Tue, 16 May 2023 14:26:36 +0000 (UTC)
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927CD83D8;
	Tue, 16 May 2023 07:26:15 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-556f2c24a28so18056107b3.1;
        Tue, 16 May 2023 07:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684247174; x=1686839174;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mRKuTomrk+ys7/Q3/LVKxeHFC/6qcq0x/mx1CTyIUjU=;
        b=RbmS5dM02DPL2D8Os7fJiYKqxw5KaBKfWHj+dx4qz4xs0nxf/8X7B8bCH/szvLA6/d
         haRppwfIxTjVWRyR7Pz3ha1eQNSyxpbm4Fma44COKxYnOWNZ9g9zEiQcyU0ygXiEqCzK
         oaATFb3bhmm4dVqea4gFj11zExcrviR380+lxE21rR7W9Uz/U+eCXfpshdmhJzh2FOOM
         /UTj6WdHYPx+o1AzwtoGWURaJ99JIN8DJKHISj0RdxrGca3dTHIcmloZYhxaVWLnkY8u
         IlVUY9E5WrKL/XB5fQkmwdKK+PlJdNGHhufyX+BeOCIuo4MRdSzb9HFLW3TCCaUsKx+Y
         WHfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684247174; x=1686839174;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mRKuTomrk+ys7/Q3/LVKxeHFC/6qcq0x/mx1CTyIUjU=;
        b=WORW2ykxJfVrHQPvU80IRrGLDv7OkRG4CCfLKUl2u6xtVEWfnBYiwAIFnLOhVyiQ9f
         p2T9xFr4rqUxDbN4uJ3YMp4jp7rXlk7gwIHfDBvBaDCXfT1MHB437L+CutSLdgcJchZe
         qi64PQUSEWxUKAt5+3fNyWkY8jv52FLvaKNTez43dvgcwNcir8PQPhaLt7twEboFrVYT
         yU4vWDACV6iiWeXMXdNk++Tuvu2pQlv8ZT6i20OJqFdx6V+i9sGSeApSEdQg8ux1b63w
         Foi8YNsVubsBH6kqsoRhxdHL2n+zbt7te5/A1BG2FPVfQBABnRow066sYJ01GHE0zJCA
         Jnlw==
X-Gm-Message-State: AC+VfDzbqwE7SCQk9xt+JBWsRIH6wwbK2IbMh06pqbcL5Ut8BmuQKGrC
	XFydEOG+ySmXVd8bMHM7+ueWSXizNxVDF/hb+Zw=
X-Google-Smtp-Source: ACHHUZ6+/HkOqhEMeXW5Pii6YHjtwVwoIG0TP6w8aiAk9IpGwkBk7N7twUyflxvcX+7jRb/ZWnoY2nJ4R1r5/vHYXHs=
X-Received: by 2002:a81:9acb:0:b0:561:94a3:5bae with SMTP id
 r194-20020a819acb000000b0056194a35baemr1270752ywg.1.1684247174472; Tue, 16
 May 2023 07:26:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230516103109.3066-1-magnus.karlsson@gmail.com>
 <20230516103109.3066-8-magnus.karlsson@gmail.com> <ZGN98qXSvzggA1Yu@boxer> <ZGN/zTd74uV2xQwl@boxer>
In-Reply-To: <ZGN/zTd74uV2xQwl@boxer>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Tue, 16 May 2023 16:26:03 +0200
Message-ID: <CAJ8uoz2mn19BbpRoC-pX-DxjZRVVMBG2Tqr5ZD20AeJX0-507A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 07/10] selftests/xsx: test for huge pages only once
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, yhs@fb.com, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, 
	john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, 
	haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 16 May 2023 at 15:07, Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, May 16, 2023 at 02:58:26PM +0200, Maciej Fijalkowski wrote:
> > On Tue, May 16, 2023 at 12:31:06PM +0200, Magnus Karlsson wrote:
> > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >
> > > Test for hugepages only once at the beginning of the execution of the
> > > whole test suite, instead of before each test that needs huge
> > > pages. These are the tests that use unaligned mode. As more unaligned
> > > tests will be added, so the current system just does not scale.
> > >
> > > With this change, there are now three possible outcomes of a test run:
> > > fail, pass, or skip. To simplify the handling of this, the function
> > > testapp_validate_traffic() now returns this value to the main loop. As
> > > this function is used by nearly all tests, it meant a small change to
> > > most of them.
> >
> > I don't get the need for that change. Why couldn't we just store the
> > retval to test_spec and then check it in run_pkt_test() just like we check
> > test->fail currently? Am i missing something?
>
> also typo in subject - s/xsx/xsk

Ouch, will fix. Thanks!

> >
> > >
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> > >  tools/testing/selftests/bpf/xskxceiver.c | 186 +++++++++++------------
> > >  tools/testing/selftests/bpf/xskxceiver.h |   2 +
> > >  2 files changed, 94 insertions(+), 94 deletions(-)
> > >

