Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85FB3923E2
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 02:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhE0Ass (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 20:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232229AbhE0Ass (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 20:48:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C098C613C7;
        Thu, 27 May 2021 00:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622076436;
        bh=3/nW251UtguuydRp+/IAEm9SXD4tdPcJaf15bOINbmg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qXqZ6OyfeKB7l4OoCrPzgiGLmQCh5TZSaHIXtRe25s3Js2c0HQyYM7oblWS1z+qhG
         /PMvWzidqaa2z0hFXyvWuOgDBE3lrarSKhx8Hla5J7y+QBFz/aTTVhOXO7eTASLONH
         ZmniT69kdGrVNFODL5+ovokqCbI7+ZfTxdbNXYToj7M7o2dOyBXq7h8fSVG6zNxI/A
         avtr6oSuO9FNKBjmuLDF8En9fs1XjLjv2fIAeUnUkFBKNY4buBlNlYd4MZPiUhmn4S
         Ml2Z5HYewH90eqI4w6ndPCglRQWDY55v4Ks4V2UdQ/PjPhzEJcf6apf6NQY+QbyL9t
         OUftTJqV5YePA==
Date:   Wed, 26 May 2021 17:47:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [RFC PATCH 0/6] BOND TLS flags fixes
Message-ID: <20210526174714.1328af13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210526095747.22446-1-tariqt@nvidia.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 12:57:41 +0300 Tariq Toukan wrote:
> This RFC series suggests a solution for the following problem:
>=20
> Bond interface and lower interface are both up with TLS RX/TX offloads on.
> TX/RX csum offload is turned off for the upper, hence RX/TX TLS is turned=
 off
> for it as well.
> Yet, although it indicates that feature is disabled, new connections are =
still
> offloaded by the lower, as Bond has no way to impact that:
> Return value of bond_sk_get_lower_dev() is agnostic to this change.
>=20
> One way to solve this issue, is to bring back the Bond TLS operations cal=
lbacks,
> i.e. provide implementation for struct tlsdev_ops in Bond.
> This gives full control for the Bond over its features, making it aware o=
f every
> new TLS connection offload request.
> This direction was proposed in the original Bond TLS implementation, but =
dropped
> during ML review. Probably it's right to re-consider now.
>=20
> Here I suggest another solution, which requires generic changes out of th=
e bond
> driver.
>=20
> Fixes in patches 1 and 4 are needed anyway, independently to which soluti=
on
> we choose. I'll probably submit them separately soon.

No opinions here, semantics of bond features were always clear=20
as mud to me. What does it mean that bond survived 20 years without
rx-csum? And it so why would TLS offload be different from what one
may presume the semantics of rx-csum are today? =F0=9F=A4=B7=F0=9F=8F=BB=E2=
=80=8D=E2=99=82=EF=B8=8F
