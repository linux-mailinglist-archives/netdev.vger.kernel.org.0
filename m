Return-Path: <netdev+bounces-6325-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 609C4715BC2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:28:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5EA21C20B6A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7055A174F5;
	Tue, 30 May 2023 10:28:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639C6168CC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:28:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDEA1713
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685442509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9maJC3tkWXrOh5gynTfOn7BcjZTymBhWFjWHqIetvJk=;
	b=VVz0NNB6LOIuQ5IV8/PuIez1JtmDSFdkEwzrFaZisr+wEN3pEAHLzaKeLWAB7rTp9iKRag
	H77ZPJbfwW1zPlFQSihDNyqXE+p5GiOjfndl3hEn85arfIVBYDMMtnDf3UGgqCmXPF6amI
	+0JkHAylQZMm47zvQbOLb1HJtCzFNcQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-PDTaALSfNPmh0gtwR1DVqw-1; Tue, 30 May 2023 06:28:28 -0400
X-MC-Unique: PDTaALSfNPmh0gtwR1DVqw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f6ffc2b423so3290975e9.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:28:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685442507; x=1688034507;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9maJC3tkWXrOh5gynTfOn7BcjZTymBhWFjWHqIetvJk=;
        b=cR4HrUpGNY/sOhnoX/Ijnuml+kDuPBaFOvhAagHdH5fB5zfctoCFGLZFKHV8Rs5+AD
         YxKq3V2IcQ5+iDALxek8LFO+NqN0U56qq8M058jmslsBgbUSM8gn5qwO/zTkUCJQmP2u
         582Ml+Ef18DOzMiWBe9Iclpn23KQIixLVQ5vNO60ybW6+8quBcyCVQaeIuHyP8cZiXVw
         9lqhk1roGzmtsS8e1tVNy+m0qO7qlloLdgsAVe+eJT12BcOBofYcMo2QkthOfSPEJjLO
         5X3nMHIdj3KVxBiWOVQLbIi7HmAoocaecMjPdhmyAnxZwfkFVRGcfaOojiCoKv/8irWo
         x6yw==
X-Gm-Message-State: AC+VfDyMBD/f0x0aKgS6DggP4N1I3SIuMAnJjCFMU81Z5rMZys4kceQq
	ZS1ZV+gCNp3LupvWWgZk66Y+9T1nRU6jBC5UP54euNrBzs4LE8vGeFq5mQYCFrAs1qfHUK2U91Z
	lVuTY51kGxm/gkUQh
X-Received: by 2002:adf:f3c5:0:b0:30a:e55c:1e8e with SMTP id g5-20020adff3c5000000b0030ae55c1e8emr996976wrp.2.1685442507038;
        Tue, 30 May 2023 03:28:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6n+HAg5Xabix7rRTJdxhFbnQ8iNRWdeQ9OI2ATI2A/DhevyHWXMGhE3jF6Bdq/Wy6NKILorw==
X-Received: by 2002:adf:f3c5:0:b0:30a:e55c:1e8e with SMTP id g5-20020adff3c5000000b0030ae55c1e8emr996963wrp.2.1685442506729;
        Tue, 30 May 2023 03:28:26 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-248-97.dyn.eolo.it. [146.241.248.97])
        by smtp.gmail.com with ESMTPSA id l19-20020a5d5273000000b0030ae09c5efdsm2843808wrc.42.2023.05.30.03.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 03:28:26 -0700 (PDT)
Message-ID: <0ab4f3ea2bd97c7067ed332c0128829f4a7ea596.camel@redhat.com>
Subject: Re: [PATCH] net: skbuff: fix missing a __noreturn annotation warning
From: Paolo Abeni <pabeni@redhat.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>, linmiaohe@huawei.com
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 30 May 2023 12:28:25 +0200
In-Reply-To: <20230527040038.6783-1-kuniyu@amazon.com>
References: <20230527110409.497408-1-linmiaohe@huawei.com>
	 <20230527040038.6783-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-05-26 at 21:00 -0700, Kuniyuki Iwashima wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> Date: Sat, 27 May 2023 19:04:09 +0800
> > Add __noreturn annotation to fix the warning:
> >  net/core/skbuff.o: warning: objtool: skb_push+0x3c: skb_panic() is mis=
sing a __noreturn annotation
> >  net/core/skbuff.o: warning: objtool: skb_put+0x4e: skb_panic() is miss=
ing a __noreturn annotation
>=20
> What arch are you using ?
>=20
> IIUC, BUG() should have an annotation for objtool, for
> example, __builtin_unreachable() for x86.
>=20
> Maybe the arch is missing such an annotation ?
>=20
> Also I'm curious why objtool complains about only skb_push(),
> there should be more non-inline functions that has BUG().

AFAICS, the BUG() macro implementation should already carry the
__noreturn annotation, via panic() or other arch-specific way.

This looks like the old toolchain not being able to
successfully/correctly propagate the annotation???

I think we can drop this patch.

Cheers,

Paolo


