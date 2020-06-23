Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F956206260
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392628AbgFWVAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393255AbgFWVAB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:00:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04D1E20656;
        Tue, 23 Jun 2020 21:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592946001;
        bh=0+sqPYIrnIToZGbPtFiFzRGJOK0b5oISbBRphyPoK7E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MmUT4+E8fMaJQo2B2XWSgXXHXyf/y1I9JXYl+XOrW13XyLgGq9zJZ8+4OvL9ymc7y
         2eVAKkCxxEgQUo0xi6yUI+IbnJtbKKgGWK3ggZXjgandMu0MzWR+hcPTZ9wGfSAvU6
         3jnULkm/S4XKpbrgL3CvopvYxmN29iecmg2BPTnA=
Date:   Tue, 23 Jun 2020 13:59:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH] linux/log2.h: enclose macro arg in parens
Message-ID: <20200623135959.5c4eda49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623170739.3151706-1-jonathan.lemon@gmail.com>
References: <20200623170739.3151706-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 10:07:39 -0700 Jonathan Lemon wrote:
> From: Jonathan Lemon <bsd@fb.com>
>=20
> roundup_pow_of_two uses its arg without enclosing it in parens.
>=20
> A call of the form:
>=20
>    roundup_pow_of_two(boolval ? PAGE_SIZE : frag_size)
>=20
> resulted in an compile warning:
>=20
> warning: ?: using integer constants in boolean context [-Wint-in-bool-con=
text]
>               PAGE_SIZE :
> ../include/linux/log2.h:176:4: note: in definition of macro =E2=80=98roun=
dup_pow_of_two=E2=80=99
>    (n =3D=3D 1) ? 1 :  \
>     ^
> And the resulting code used '1' as the result of the operation.

I'd have thought that this warning is harmless, since the expression
clearly is not a constant, interesting.

> Fixes: 312a0c170945 ("[PATCH] LOG2: Alter roundup_pow_of_two() so that it=
 can use a ilog2() on a constant")
>=20

Please no empty line between fixes and other tags.

> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/linux/log2.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index 83a4a3ca3e8a..c619ec6eff4a 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -173,7 +173,7 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
>  #define roundup_pow_of_two(n)			\
>  (						\
>  	__builtin_constant_p(n) ? (		\
> -		(n =3D=3D 1) ? 1 :			\
> +		((n) =3D=3D 1) ? 1 :		\
>  		(1UL << (ilog2((n) - 1) + 1))	\
>  				   ) :		\
>  	__roundup_pow_of_two(n)			\

