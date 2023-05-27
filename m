Return-Path: <netdev+bounces-5928-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 840937135FA
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 20:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABEAF1C20A78
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 18:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17896134DE;
	Sat, 27 May 2023 18:02:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C54134C1
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 18:02:38 +0000 (UTC)
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C54DE1
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:02:37 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id 71dfb90a1353d-4571d25d288so1200356e0c.3
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685210556; x=1687802556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4zXxiVSdWRhj4THj+gBS0jQPwdd14vhiQA7WPxUcD4=;
        b=JcIMYWbhBh3qDBKXhZ691qd/aFf1hDKR8M9uMpcySOFPclTV0mFqFRQkMGb3BerKSh
         YS9WhtncNrI7DgHwbDuyuWXuW+YoTEXFPT4ELFNd26mNimfQuj4o/fphbi61vYzcdW3h
         GhlO0O46KR+IYXKtNNzwASq/UmeAc8Chnl/ArJCZk17S7NepZxAFoMNfAgxXXCpSpT8J
         o+U5khbPBP2oJjIh2klNykLShfZ0h4+YsDHupzYpcpjUrOdfIYkdY4No5pRTW+OdAs1L
         1+MCzSzU8oBtN/VmmrhCt8KsWifW3+qiyJ0nPj7XnWXxeQsnPsrBhiMyLx/WX6JjwvKx
         TzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685210556; x=1687802556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z4zXxiVSdWRhj4THj+gBS0jQPwdd14vhiQA7WPxUcD4=;
        b=NaoVqDxjBas1ih+xkBxcDM4JX3n/UdhZaLeAVf9zbuSz6Tj3LiohbBvSiKLArKnlFx
         dSc1mfVBv4nx8n6lWJTrOr9VsDImsme2nf/NeSxZR+hHeSW8TzTGfUuR+pYEVEyliwyg
         btRzcp3KxQE0PsPfFWuUY1vULX7LwBWH7H76s5xYm0Wf6NkEiK79oQMSiuQGbK/u9ofC
         66WA+pA8PY4R0M9XwvbMs/voT9XlwOiFeoU8DnUh03PO5+Kz2fvlVqonkmc1o7XbNUU6
         43aKkEGrAqNUPmC9DUIo9IFAVfz8j6jJiRUFh0Nqxsxx8qSLP3CkzqQkn0OaknjBmxEJ
         bX7g==
X-Gm-Message-State: AC+VfDxeYwMai2UNnMrztOWfchFDYpLOvk2wIFg33A90ndYn7rasc/bM
	yU0vhNU9Rmev0FauxnbfjGkEwlvM5GL3jcy3wPmAvQ==
X-Google-Smtp-Source: ACHHUZ6t+WqLh8dfDvAu6H23RAnvDFtCFcw4MX17ecPTOPcz4W6SJ69TrgQpcm6/WVp+qfNSXUr4owpAbGZCSwIYllk=
X-Received: by 2002:a67:ee12:0:b0:436:e3:f6de with SMTP id f18-20020a67ee12000000b0043600e3f6demr1791452vsp.13.1685210556113;
 Sat, 27 May 2023 11:02:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526201607.54655398@kernel.org> <20230527034922.5542-1-kuniyu@amazon.com>
 <f0194cbe-eb5b-40ee-8723-1927ebddefc1@app.fastmail.com>
In-Reply-To: <f0194cbe-eb5b-40ee-8723-1927ebddefc1@app.fastmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 27 May 2023 23:32:23 +0530
Message-ID: <CA+G9fYtzjP_EOjDFZYwTMjv5f3AK2pA_E6mk_mU5FQcZgo_qXQ@mail.gmail.com>
Subject: Re: selftests: net: udpgso_bench.sh: RIP: 0010:lookup_reuseport
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>, Jakub Kicinski <kuba@kernel.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	"David S . Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, 
	lkft-triage@lists.linaro.org, Xin Long <lucien.xin@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Netdev <netdev@vger.kernel.org>, stable@vger.kernel.org, 
	willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Arnd,

On Sat, 27 May 2023 at 15:03, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sat, May 27, 2023, at 05:49, Kuniyuki Iwashima wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Date: Fri, 26 May 2023 20:16:07 -0700
> >> On Wed, 24 May 2023 13:24:15 +0530 Naresh Kamboju wrote:
> >> > While running selftests: net: udpgso_bench.sh on qemu-x86_64 the following
> >> > kernel crash noticed on stable rc 6.3.4-rc2 kernel.
> >>
> >> Can you repro this or it's just a one-off?
> >>
> >> Adding some experts to CC.
> >
> > FWIW, I couldn't reproduce it on my x86_64 QEMU setup & 6.4.0-rc3
> > at least 5 times, so maybe one-off ?
>
> This looks like one of several spurious reports that lkft has produced
> recently, where an 'int3' trap instruction is executed in a function
> that is live-patched, but at a point where the int3 is not expected.
>
> Anders managed to get a reproducer for one of these on his manchine
> yesterday, and has narrowed it down to failing on qemu-7.2.2 but
> not failing on qemu-8.0.

This is an added advantage to tests on multiple qemu versions
and comparing the difference in test results.
Thanks, Anders.

>
> The current theory right now is that this is a qemu bug when
> dealing with self-modifying x86 code that has been fixed in
> qemu-8.0 already, and my suggestion would be to ignore all bugs
> found by lkft that involve an 'int3' trap, and instead change
> the lkft setup to use either qemu-8.0 or run the test systems
> in kvm (which would also be much faster and save resources).

 I will send out an update to ignore the 'int3' trap email reports.

>
> Someone still needs to get to the bottom of this bug to see
> if it's in qemu or in the kernel livepatching code, but I'm
> sure it has nothing to do with the ipv6 stack.

Thank you Arnd.

- Naresh

>       Arnd

