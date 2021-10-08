Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA2F426276
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 04:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhJHCdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 22:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhJHCdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 22:33:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FAA060F4A;
        Fri,  8 Oct 2021 02:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633660309;
        bh=+2BunCrA/4RsaGp96DgO+Awt7bULZk3+MSLkObLDDpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ezGbHqngf01XXE6P7sdpwfwLSZ3pwCoO5FjuYQj7F+OYazBFsdZVwVSIxz+Ly1Hss
         c1jdigvNRd8PFN3lghXkRzvbqaaWPClxnRsUcwU2NEHoaf3pbq3PemZLZ8UCGpw+xI
         b4S6rzwLc6plnQtoKdU+SoAJwIxovCLcgzCG6DG4gguuqXzwnMtnvMww324mG0LiGJ
         wM1ZA/XB0UnaVRnaGdp40dvcseU+DxPdkriYDYsvd9dCIxqh6BQ4yduLoZwRnWc+Qp
         hwpbVkTsV2ZVxcKTk7zPPG0kvHC1qfvVpgR16OAe6UubpbSVLgZ+iXPnTkBAg0AMAE
         H0JL36xh6zyFg==
Date:   Thu, 7 Oct 2021 19:31:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Catherine Sullivan <csully@google.com>,
        Yanchun Fu <yangchun@google.com>,
        Nathan Lewis <npl@google.com>,
        David Awogbemila <awogbemila@google.com>
Subject: Re: [PATCH net-next 2/7] gve: Add rx buffer pagecnt bias
Message-ID: <20211007193148.11d0b175@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211007162534.1502578-2-jeroendb@google.com>
References: <20211007162534.1502578-1-jeroendb@google.com>
        <20211007162534.1502578-2-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Oct 2021 09:25:29 -0700 Jeroen de Borst wrote:
> From: Catherine Sullivan <csully@google.com>
>=20
> Add a pagecnt bias field to rx buffer info struct to eliminate
> needing to increment the atomic page ref count on every pass in the
> rx hotpath.
>=20
> Also prefetch two packet pages ahead.
>=20
> Fixes: ede3fcf5ec67f ("gve: Add support for raw addressing to the rx path=
")
> Signed-off-by: Yanchun Fu <yangchun@google.com>
> Signed-off-by: Nathan Lewis <npl@google.com>
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>

drivers/net/ethernet/google/gve/gve_rx.c:521:5: warning: no previous protot=
ype for =E2=80=98gve_clean_rx_done=E2=80=99 [-Wmissing-prototypes]
  521 | int gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
      |     ^~~~~~~~~~~~~~~~~
drivers/net/ethernet/google/gve/gve_rx.c:521:5: warning: symbol 'gve_clean_=
rx_done' was not declared. Should it be static?
