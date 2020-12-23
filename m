Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96352E21D4
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 22:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgLWVAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 16:00:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgLWVAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 16:00:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D666223E4;
        Wed, 23 Dec 2020 20:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608757192;
        bh=xQmwr5xugEhCyXPMARkJAPoy6g+JnO7T7Rf68FgrIPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=niK3HTQ4YevnvjWItGcG+0lt/lPoVY4EXhCjxi1B6wlATUHsZURG4eWFSt3Bs4u/T
         xAbJLjztHhXwv+ONpmL9fCFiCJEGiImBRIyZUHsSComWr4l8AvBg8TF8hwRJUKwNSx
         fvteKyp9KOIhvgMbixakvBuhl+8EhWqzP+DtuGbyreacl6GKaQPo0YdvH/9qxpNmh1
         QwPj5aDVtW4Zr074cw31VIE5jP6onnOKH0oH3HZIAHUN57lucAFnHV6Uh6YZFVDOMM
         udDXYEk+q4BG0OfXE0MwqNXw4EPKfHm3aXBQdF/vKoXEST6VESRC1e8hzbW6I/bFv7
         BnFn+Efrk/pLA==
Date:   Wed, 23 Dec 2020 12:59:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2 1/3] net: fix race conditions in xps by locking
 the maps and dev->tc_num
Message-ID: <20201223125951.44cc281c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160875701664.1783433.16072409555972227523@kwain.local>
References: <20201221193644.1296933-1-atenart@kernel.org>
        <20201221193644.1296933-2-atenart@kernel.org>
        <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com>
        <160862887909.1246462.8442420561350999328@kwain.local>
        <CAKgT0UfzNA8qk+QFTN6ihXTxZkcE=vfrjBtyHKL6_9Yyzxt=eQ@mail.gmail.com>
        <20201223102729.6463a5c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <160875219353.1783433.8066935261216141538@kwain.local>
        <20201223121110.65effe06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <160875571511.1783433.16922263997505181889@kwain.local>
        <20201223124315.27451932@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <160875701664.1783433.16072409555972227523@kwain.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 21:56:56 +0100 Antoine Tenart wrote:
> You understood correctly, the only reason to move this code out of sysfs
> was to access the xps_map lock. Without the need, the code can stay in
> sysfs.
>=20
> Patch 2 is not only moving the code out of sysfs, but also reworking
> xps_cpus_show. I think I now see where the confusion comes from: the
> reason patches 2 and 3 were in two different patches was because they
> were targeting net and different kernel versions. They could be squashed
> now.

=F0=9F=91=8D
