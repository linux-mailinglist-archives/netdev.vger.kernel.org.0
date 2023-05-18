Return-Path: <netdev+bounces-3485-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53281707866
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 05:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44A521C2102F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 03:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511B419B;
	Thu, 18 May 2023 03:22:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4534B392
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:22:52 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE07D1719
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 20:22:49 -0700 (PDT)
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id F345D3F235
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684380167;
	bh=Gi4VEKOMa2h3a92P3bc7WeGm4ywxJ/65UScMzNMWt9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=qnuDyIoi3/7GulumttzUMARn+ALgFMvozZ4e3j7mhrKz0BDb+R98s/ctoAeQ+OOCV
	 FcHccaFKtB/xOg13zHGK3dHUqdDFiR+hYOhB30NEXausW3axEazM3d0peePK1OgmtI
	 X/pQBEbt1CzjYjZSOdqlbKl4FVZZA4WzekjrvD4NV5znum7d/xZImOJO750/bQOw56
	 lFPgxiKLejfmSaVQnApbPqZC23EQAK16AYGHMqdbX3t+Fm8OWv94KI4LepnsGXfa3O
	 q7EzglQdF3HC972pY9F9i2HAJ/7oJK3C9yeq+2SRutd17yvqKa2Xt+QFCjVlSbSvW6
	 yWdRlAyzAyCiA==
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6ab30cf37f3so487340a34.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 20:22:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684380166; x=1686972166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gi4VEKOMa2h3a92P3bc7WeGm4ywxJ/65UScMzNMWt9g=;
        b=dyX7YusbuF8i5ixYUvmHp3lRdJ6twP0n41nI2WVWUEEWXjVMvoLx20ZTUl4FxKmMW7
         /TrRa2DlzH0Xa60vBzgXtarWe65clWYMrwSG1i/Hs5bx3YgR13OAd8i35ucU5Bo1EBVF
         7i96pOU0nBEvgMiAHcdwuvPxyxDB8uYqt47ZUezbUgzSyaoaFRa59Hky6pL5JLTq/7uW
         ta+f3dsp8hEXHtv/JBUWoONxTGM1iYSVC0gR5g8qMQK2HSQe7K/tm0xDKIzjAP0uz9QS
         KonT1YytSxGBLUmFsMXzFlBvdOOYFJj8yfvB726dkNiySTgELLquneYOAlqaCYoZjQEW
         yP7A==
X-Gm-Message-State: AC+VfDyEvNFgfiqw03thTxR5y6/hiVmqVapYoR1O4IWm3ThfObXjIipA
	9go0knVER5pTmD5IkauG9tTiVOlD74t//0MMFAvEdiOmhC4NNQroUfhNOgf1PFcF1VdS4A2G3oK
	b+bkhXEpuEPZdeVamOftLtJ+000KSc6SZtjo2tuJRDTRiI3Ya
X-Received: by 2002:a05:6870:a343:b0:17e:5166:e5ad with SMTP id y3-20020a056870a34300b0017e5166e5admr99276oak.44.1684380166735;
        Wed, 17 May 2023 20:22:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Di+BGi2T2Y8o48hf73VHtmqnUhbnSLeez5vG0gzZcxFpeZcJDMLOxz1YGfRxkX+0YNvwFmiA9PRUEr7Fdn9Q=
X-Received: by 2002:a05:6870:a343:b0:17e:5166:e5ad with SMTP id
 y3-20020a056870a34300b0017e5166e5admr99266oak.44.1684380166509; Wed, 17 May
 2023 20:22:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517041119.202072-1-po-hsu.lin@canonical.com> <ZGRthdt5u88zs6xy@shredder>
In-Reply-To: <ZGRthdt5u88zs6xy@shredder>
From: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date: Thu, 18 May 2023 11:22:35 +0800
Message-ID: <CAMy_GT9SYNzhDx6Eod8VXkDM+eKnn+5NjxvBvd5bORF9kBBu_g@mail.gmail.com>
Subject: Re: [PATCH] selftests: fib_tests: mute cleanup error message
To: Ido Schimmel <idosch@idosch.org>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	netdev@vger.kernel.org, dsahern@gmail.com, shuah@kernel.org, 
	pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 2:00=E2=80=AFPM Ido Schimmel <idosch@idosch.org> wr=
ote:
>
> On Wed, May 17, 2023 at 12:11:19PM +0800, Po-Hsu Lin wrote:
> > In the end of the test, there will be an error message induced by the
> > `ip netns del ns1` command in cleanup()
> >
> >   Tests passed: 201
> >   Tests failed:   0
> >   Cannot remove namespace file "/run/netns/ns1": No such file or direct=
ory
> >
> > Redirect the error message to /dev/null to mute it.
> >
> > Fixes: a0e11da78f48 ("fib_tests: Add tests for metrics on routes")
>
> I don't think this tag is correct. More likely that this is caused by
> commit b60417a9f2b8 ("selftest: fib_tests: Always cleanup before exit").
>
> You can even reproduce it with '-h':
>
> # ./fib_tests.sh -h
> usage: fib_tests.sh OPTS
> [...]
> Cannot remove namespace file "/var/run/netns/ns1": No such file or direct=
ory
>
> Reverting the commit I mentioned makes it go away.
>
> Also, please use "PATCH net" prefix:
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#tl-=
dr

Thank you!
I will submit V2 for this.

