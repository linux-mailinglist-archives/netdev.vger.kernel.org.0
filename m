Return-Path: <netdev+bounces-3862-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F46A709410
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28BDF1C2123D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B1E613A;
	Fri, 19 May 2023 09:50:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912BF6108
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0CFC4339C;
	Fri, 19 May 2023 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684489812;
	bh=cxsLRE0alCrf2ZfgwTTn9OcSDuEYffyVmRa3xxSbSVA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=G0RyNwKIDZ0zSSG6wCVVJlHLA9iEGgez/wzoq8th6H7bbLW0ra3DBSoRHEGMHWiNV
	 /O2iplAC+fZeRHgge0C1G/uyEYNnMBlVpGQp/AaECLynPQy7bWAYrNV8ro6q4EDve1
	 mieTp0ttxxbo2/PkjdVfRMVLNsFQi624KK7RdrEQRgDLB8G8xeUMVnQa7IsG1jBeKl
	 b0IQYfsYncQ1s6Ke3MKPIV7oce6X2bqPm+Yf2xbkzsAlDLX7ooxZxHHes8RFOxgb0i
	 oJwbN8/Q6sj+n6+A+T30KYqnmYeXlJCLcx9Vy6vfSZBcHkiahCWbD2wy75x1Kli0rL
	 A2GYRgE2ttADA==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-4f387d97dddso3508841e87.3;
        Fri, 19 May 2023 02:50:12 -0700 (PDT)
X-Gm-Message-State: AC+VfDwhkgBxf5URlhcB/dTcnZl24ydrmDLEcUYNMFq1YxiF2mjM10Ex
	07zWgaV3UnpQM0ihUKzD0XxBxHIiKijCM2yVoEc=
X-Google-Smtp-Source: ACHHUZ5GcgO2M7ELebyN3Y1RyiaRrgxpvXBxmuk2yUVv8d3D90lsJfyWfmQipdKuDjOf1BlNC20rnWfiygUIXWwKBo4=
X-Received: by 2002:ac2:5a0b:0:b0:4ef:e87e:df88 with SMTP id
 q11-20020ac25a0b000000b004efe87edf88mr603195lfn.64.1684489810195; Fri, 19 May
 2023 02:50:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230512202311.2845526-1-dima@arista.com> <20230512202311.2845526-2-dima@arista.com>
 <ZGG5rtuHB4lvLyKI@gondor.apana.org.au> <eb6d0724-92d6-3c3f-b698-9734adc7e1b9@arista.com>
 <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
In-Reply-To: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 19 May 2023 11:49:58 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFoiJpZLCiE4uNTEXMncvWheSn8nVWGB8g3sL1K8jGyuw@mail.gmail.com>
Message-ID: <CAMj1kXFoiJpZLCiE4uNTEXMncvWheSn8nVWGB8g3sL1K8jGyuw@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: cmac - Add cloning support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Dmitry Safonov <dima@arista.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org, 
	David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Andy Lutomirski <luto@amacapital.net>, 
	Bob Gilligan <gilligan@arista.com>, Dan Carpenter <error27@gmail.com>, 
	David Laight <David.Laight@aculab.com>, Dmitry Safonov <0x7f454c46@gmail.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Francesco Ruggeri <fruggeri05@gmail.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, 
	Ivan Delalande <colona@arista.com>, Leonard Crestez <cdleonard@gmail.com>, 
	Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

For the series,

Acked-by: Ard Biesheuvel <ardb@kernel.org>



On Fri, 19 May 2023 at 10:27, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This series of patches add cloning support for the cmac algorithm.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

