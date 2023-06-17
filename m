Return-Path: <netdev+bounces-11698-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99AD7733F26
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 548CB281880
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75C36AB1;
	Sat, 17 Jun 2023 07:25:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCE65231
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40561C433C8;
	Sat, 17 Jun 2023 07:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686986700;
	bh=TAC4mSAqBNFHw10a/fJsdd24Ya5CzVO97XdHjidaNE0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RIJY2hxuSlGv7GxyHu8ixLeoJ+C6k8WX0JfkyIGZrg5DI2BRXbner5aufdvZGB2j3
	 wk7vBd2DL6xVQ1mEv8Q9cmj0iX0CGv1IIaKGdLeaOdou1Wd8eZlAlPSDxPpcOU3mq5
	 3yrwbvy36Hkmcrn+/J8v50+jOVoUxWVVrXHUkZxyzLwwUvxcTyA5EPm7Cinh1MXcXK
	 fFsbHk7chZelKYWGG7mBJBUGqAsxDwADXXLtenD5jI/WO8dkE8RLbJUhlQPBnKVm2m
	 bfOXQycbzmRz1FohI1VEw36tAMBsuTzS+H0Y0VsNZnzlKIYlPrmRuJtrbJsWysJV8C
	 M+fGEuqXC1Adg==
Date: Sat, 17 Jun 2023 00:24:59 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Wang Ming <machel@vivo.com>
Cc: linyunsheng@huawei.com, opensource.kernel@vivo.com,
 gregkh@linuxfoundation.org, Sunil Goutham <sgoutham@marvell.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
 linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers:net:ethernet:Add missing fwnode_handle_put()
Message-ID: <20230617002459.76b63d90@kernel.org>
In-Reply-To: <20230616092820.1756-1-machel@vivo.com>
References: <20230616092820.1756-1-machel@vivo.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Jun 2023 17:27:39 +0800 Wang Ming wrote:
> In device_for_each_child_node(), we should have fwnode_handle_put()
> when break out of the iteration device_for_each_child_node()
> as it will automatically increase and decrease the refcounter.
>=20
> Signed-off-by: Wang Ming <machel@vivo.com>
>=20
> Fixes: 53ab6975c12d ("Add linux-next specific files for 20230609")
> ---
> This version adds 'Fixes:tag' compared to previous versions.

> ________________________________
> =E6=9C=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E5=86=85=
=E5=AE=B9=E5=8F=AF=E8=83=BD=E5=90=AB=E6=9C=89=E6=9C=BA=E5=AF=86=E5=92=8C/=
=E6=88=96=E9=9A=90=E7=A7=81=E4=BF=A1=E6=81=AF=EF=BC=8C=E4=BB=85=E4=BE=9B=E6=
=8C=87=E5=AE=9A=E4=B8=AA=E4=BA=BA=E6=88=96=E6=9C=BA=E6=9E=84=E4=BD=BF=E7=94=
=A8=E3=80=82=E8=8B=A5=E6=82=A8=E9=9D=9E=E5=8F=91=E4=BB=B6=E4=BA=BA=E6=8C=87=
=E5=AE=9A=E6=94=B6=E4=BB=B6=E4=BA=BA=E6=88=96=E5=85=B6=E4=BB=A3=E7=90=86=E4=
=BA=BA=EF=BC=8C=E8=AF=B7=E5=8B=BF=E4=BD=BF=E7=94=A8=E3=80=81=E4=BC=A0=E6=92=
=AD=E3=80=81=E5=A4=8D=E5=88=B6=E6=88=96=E5=AD=98=E5=82=A8=E6=AD=A4=E9=82=AE=
=E4=BB=B6=E4=B9=8B=E4=BB=BB=E4=BD=95=E5=86=85=E5=AE=B9=E6=88=96=E5=85=B6=E9=
=99=84=E4=BB=B6=E3=80=82=E5=A6=82=E6=82=A8=E8=AF=AF=E6=94=B6=E6=9C=AC=E9=82=
=AE=E4=BB=B6=EF=BC=8C=E8=AF=B7=E5=8D=B3=E4=BB=A5=E5=9B=9E=E5=A4=8D=E6=88=96=
=E7=94=B5=E8=AF=9D=E6=96=B9=E5=BC=8F=E9=80=9A=E7=9F=A5=E5=8F=91=E4=BB=B6=E4=
=BA=BA=EF=BC=8C=E5=B9=B6=E5=B0=86=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6=E3=80=
=81=E9=99=84=E4=BB=B6=E5=8F=8A=E5=85=B6=E6=89=80=E6=9C=89=E5=A4=8D=E6=9C=AC=
=E5=88=A0=E9=99=A4=E3=80=82=E8=B0=A2=E8=B0=A2=E3=80=82
> The contents of this message and any attachments may contain confidential=
 and/or privileged information and are intended exclusively for the address=
ee(s). If you are not the intended recipient of this message or their agent=
, please note that any use, dissemination, copying, or storage of this mess=
age or its attachments is not allowed. If you receive this message in error=
, please notify the sender by reply the message or phone and delete this me=
ssage, any attachments and any copies immediately.
> Thank you

It's your 6th submission to netdev this week and all of them are wrong.
Please read the basic process docs and look at other people's patches
before you send anything else.

In addition, please read the process guidelines for netdev:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

