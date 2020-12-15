Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914902DA990
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 10:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgLOI6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 03:58:22 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:49203 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727106AbgLOI6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 03:58:05 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 286FA580301;
        Tue, 15 Dec 2020 03:56:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 15 Dec 2020 03:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=4IEW1Wm+UUJ4RUAHXZ0yABLHMwu
        w1h/1bT4PPJUy10Q=; b=J5byJ/N8ttMdHuZIzWOG6M3lRBMBsp4N0DmBw06Ogsu
        ua27VBNqoRWXszW2hx3mVNL2fVlaq18p7f51JsxnqdtLFtvjMXnVUYB9oWpH7Hhl
        pP+6DZEOHddMkFW2tTdwI/obvn2+bqmRcAh23zR4sP4jvZZ4c8LEaWbJr55qdaNb
        anmHWFLLQmC1T+QaRuMUniwOKIKvS2owtEsQgbLt0xE9KR5uqdxai2xVIXYwAN3G
        2fmA02rrNZEpEpVDnKtO3Z+L/93yli24G3di9RHRKx1aoHwtSzgN+YCTP9UmQpXK
        dA06qan/rzSfEUkysJCZVIatd9xa8Ki4ML2m8FSO55w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4IEW1W
        m+UUJ4RUAHXZ0yABLHMwuw1h/1bT4PPJUy10Q=; b=kEmCNgqRJeQfQRu7qHLgam
        LnSXxa40avoemlhtCxqiyRMQ3BJcESuc33igVakzk73FyYh1OyUzkg8goYxkoQ4m
        hpUE7tq0rP/elIk0eB3GObLzfDezBa4dmnvqEij4W2LrD5kbwntP/lzAoCHeJ/A8
        K099Vtj/gvlaxamZKZFeZ4K23GPSYtkw8a2O4td2zrJoKwclGlpqPX2QrFkfvaaw
        /oMN2ZUxHKJGAH2+BruCWZBt/5KCbXUTztbtpDJPZqLAjTN7oM5AmMjCRYhYykp6
        S0oK1kkXOXZkBebV7pj1mUITUenJSYjPvPUUx5xnsFqNF3kriOXWXIsma7TvBssw
        ==
X-ME-Sender: <xms:WXrYX8fd21Vzrk6dN1zg4K3gVTSDIJKTkeeq8fQDdD9ymNg-jGQxgg>
    <xme:WXrYX-NTSGXzH_gubB3bfANxZ6qDP74kj66zMRfsFUKcAAGqgil1R8yRaphlIFC35
    veqv9qLrVDCnXqWPd4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekledguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpeelkeeghefhuddtleejgfeljeffheffgfeijefhgfeufefhtdevteegheei
    heegudenucfkphepledtrdekledrieekrdejieenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:WXrYX9gBzkGd1bGA8cnscy0dg8qAKQmock80FRvLY8t3eCXaL3s1MQ>
    <xmx:WXrYXx9FYmJ1XRLgYDgLYRQdrqOPEsHPGCsn_-NSV7FpVaXeVxqUDQ>
    <xmx:WXrYX4sMyQR2vWcBMnZEncWCJ1Ep4KuSNPKxNFUn5XJaDL44rF5mUQ>
    <xmx:W3rYX1N5rF7I4eLriJsA9qNz1DjViX4zxDBUpkPA4yN7h6a7AzAFCw>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id D976824005A;
        Tue, 15 Dec 2020 03:56:56 -0500 (EST)
Date:   Tue, 15 Dec 2020 09:56:55 +0100
From:   Maxime Ripard <maxime@cerno.tech>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, wens@csie.org,
        jernej.skrabec@siol.net, timur@kernel.org,
        song.bao.hua@hisilicon.com, f.fainelli@gmail.com, leon@kernel.org,
        hkallweit1@gmail.com, wangyunjian@huawei.com, sr@denx.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: allwinner: Fix some resources leak in the error
 handling path of the probe and in the remove function
Message-ID: <20201215085655.ddacjfvogc3e33vz@gilmour>
References: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tgnffsnu3i7wc524"
Content-Disposition: inline
In-Reply-To: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tgnffsnu3i7wc524
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 14, 2020 at 09:21:17PM +0100, Christophe JAILLET wrote:
> 'irq_of_parse_and_map()' should be balanced by a corresponding
> 'irq_dispose_mapping()' call. Otherwise, there is some resources leaks.

Do you have a source to back that? It's not clear at all from the
documentation for those functions, and couldn't find any user calling it
=66rom the ten-or-so random picks I took.

Maxime

--tgnffsnu3i7wc524
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCX9h6VwAKCRDj7w1vZxhR
xQ9UAQC+Z7aCLxnq7/YwPgDoj5mZh+XwHfGuD6zuXikKqa8zEQEAyScyReA2IHvf
/sJz8uc1BMRoj6wBip9nfzA/vv1QFA4=
=+jO3
-----END PGP SIGNATURE-----

--tgnffsnu3i7wc524--
