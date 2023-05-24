Return-Path: <netdev+bounces-5156-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D39D370FD62
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 20:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AA02281369
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D082109F;
	Wed, 24 May 2023 18:01:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2523C538C
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 18:01:31 +0000 (UTC)
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C24C180;
	Wed, 24 May 2023 11:01:29 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id a1e0cc1a2514c-783f88ce557so25634241.3;
        Wed, 24 May 2023 11:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684951288; x=1687543288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlPBaeyzlXrf/1ID6O8EEwBqTqJMpkMnDn/pRjEQSJc=;
        b=e3S66VMKx/tiNL1kyczRErSQ+xgBRlykj2JtCBWYSPt3r1L4MT5QNHMVG5sV7GK/q8
         sHEejcNn1/lp9YZpkogxedGXI04mcqS22B57/2/EOpNryDdY+Lmt5x0FNXPPrrBD/DYA
         5Bma1m0Y+4Zk/wIdDvJqrW3hz5C/lLx1b9FkLjydcHzh17F8CtBEuipF2RkRn/PYElf5
         nheW219I/0GqHduhfuU+Jt0xhubNqXWhRK1XU8E2CkgYmsCFkGCkUIPGrJ9nt+D3mXrI
         4Evhe80dYCAN/zuKuGDk0hbpS294U54DEDn/Dj/1CMBseoLs88Kux+IduqfP5Fp2dRtZ
         Oo2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684951288; x=1687543288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rlPBaeyzlXrf/1ID6O8EEwBqTqJMpkMnDn/pRjEQSJc=;
        b=crEEZOqkiE9ACz25trjxhOwedDBfCRf3q5UWwROC6aJDtXts3m86DhyHgrwJHeHXv+
         ND2IEhVfZxW1WNNCvk3kQ7ST3YpvwKkFr8e4pGJ0vTtPYcR4QgagqoZM8aqewo1MJMR/
         1BOXwqwDvEnhBpGq5a5x0/AeOElEoV00sWoQylltzCzp4XSPo2pnb+WKuKOWHexCYDXP
         zQ886760tRcq7IsEjdPcAomHlEoiJGo6dMF5fz8PaTzRL/Qxo2OrffIowPP+BA/EzNTL
         gyRFGPEI9ODRdzrnrp2I5SZb9+BcmeV8vsoJ4wzzWxRIMls7OfqCIMpr9iyyM1NEHnof
         xcAg==
X-Gm-Message-State: AC+VfDzxERy1Ag56yrX0rvKtsoKgSCSJCxmcPUP5klV3Xy4nmKYsKBJh
	+d2Pnt0vCk7aeJTDz9ZhTaxJbdby5pjlWqE1UU0=
X-Google-Smtp-Source: ACHHUZ6hH0zXTy1ql2c+FEGKTTerhY9iEh0FL9zJF9iqSxNqhHB315xPjK09tZCO9/r3fGp6aDexLxkWC/p1CvFmO4o=
X-Received: by 2002:a05:6102:3a44:b0:430:2b7b:a4e9 with SMTP id
 c4-20020a0561023a4400b004302b7ba4e9mr6014224vsu.20.1684951288614; Wed, 24 May
 2023 11:01:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230523223944.691076-1-Kenny.Ho@amd.com> <01936d68-85d3-4d20-9beb-27ff9f62d826@lunn.ch>
 <CAB9dFdt4-cBFhEqsTXk9suE+Bw-xcpM0n3Q6rFmBaa+8A5uMWQ@mail.gmail.com>
 <c0fda91b-1e98-420f-a18a-16bbed25e98d@lunn.ch> <CAOWid-erNGD24Ouf4fAJJBqm69QVoHOpNt0E-G+Wt=nq1W4oBQ@mail.gmail.com>
 <5b1355b8-17f7-49c8-b7b5-3d9ecdb146ce@lunn.ch>
In-Reply-To: <5b1355b8-17f7-49c8-b7b5-3d9ecdb146ce@lunn.ch>
From: Kenny Ho <y2kenny@gmail.com>
Date: Wed, 24 May 2023 14:01:17 -0400
Message-ID: <CAOWid-dYtkcKuNxoOyf3yqSJ7OtcNjaqJLVX1QhRUhYSOO6vHA@mail.gmail.com>
Subject: Re: [PATCH] Remove hardcoded static string length
To: Andrew Lunn <andrew@lunn.ch>
Cc: Marc Dionne <marc.dionne@auristor.com>, Kenny Ho <Kenny.Ho@amd.com>, 
	David Howells <dhowells@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	linux-afs@lists.infradead.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 1:43=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
>
> The other end of the socket should not blow up, because that would be
> an obvious DOS or buffer overwrite attack vector. So you need to
> decide, do you want to expose such issues and see if anything does
> actually blow up, or do you want to do a bit more work and correctly
> terminate the string when capped?

Right... I guess it's not clear to me that existing implementations
null-terminate correctly when UTS_RELEASE causes the string to exceed
the 65 byte size of rxrpc_version_string.  We can of course do better,
but I hesitate to do strncpy because I am not familiar with this code
base enough to tell if this function is part of some hot path where
strncpy matters.

Regards,
Kenny

