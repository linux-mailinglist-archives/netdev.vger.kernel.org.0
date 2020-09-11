Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C47266973
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 22:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgIKUQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 16:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgIKUQS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 16:16:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24A4421D81;
        Fri, 11 Sep 2020 20:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599855378;
        bh=CXhtiKN5U8OazyCb7IXeYAu2xj4jhVjWgYi7/OQVh4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0dledK/7y6cYvfnH/TbLESheQa5vU0tBgba0CZAyXDJZFBL8Kg8UA8qNzhRkkOh81
         2jh+3ZEJXm0+kNu1dGbEj5J1wIXhlmCEuApFGkNjsX+kr4pq0kV5nojLCN1ZS5noWe
         OKoayjaBiWCd+hbRNkJDdT4C0qS1TOxe+hok3wGU=
Date:   Fri, 11 Sep 2020 13:16:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 5/7] sfc: de-indirect TSO handling
Message-ID: <20200911131616.4657c3f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e6009413-aba0-b0de-ba66-71d64bd4b86b@solarflare.com>
References: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
        <96677549-bc70-9785-aab5-b55dd15ecef6@solarflare.com>
        <20200911090146.61eb66f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e6009413-aba0-b0de-ba66-71d64bd4b86b@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 18:42:34 +0100 Edward Cree wrote:
> > Should tso_version 3 be handled in this switch? =20
> No, because this switch is in the EF10/Siena datapath and is neverrun for
> =C2=A0EF100.=C2=A0 Setting tx_queue->tso_version =3D 3 for EF100 is reall=
y just there
> =C2=A0as documentation =E2=80=94 EF100 has a completely different TX path=
, in
> =C2=A0ef100_enqueue_skb(), which never looks at tx_queue->tso_version bec=
ause
> =C2=A0currently there's only one version of EF100 TSO descriptor.=C2=A0 F=
rom a
> =C2=A0functional perspective everything would still work if it were set t=
o 0,
> =C2=A0but that would be kinda misleading.

I see, that wasn't clear from file or function names.

> Should I explain this in the commit message, or in a comment (and if the
> =C2=A0latter, where should it go?)

Yeah, won't hurt.
