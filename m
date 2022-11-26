Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63261639511
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 10:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiKZJzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 04:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKZJzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 04:55:51 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB792188F
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 01:55:50 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669456547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oetK6LrR35eqq4wXETgSlPnmU3zBYbTG+xwQBon69N4=;
        b=0XqN6+Gf0HKWbz+ayO/POLzlXMo6XvcRvtdUQYq37kmZmbz/wV76FK7fcTYoYLatK5V+ZH
        L4SRWGedxO2VBom/pKSin3IRaQakMBShdOZo3W3uhO0Tk8CK6iRLmv0h3qSw7dd/sFMEzD
        PDgFIWy86PtjGpO5VIpHvox9kA6roqY175BRZd9pKjP32lj3b7AV2VbF+lISTs5SeGuydx
        Hw2h+9ClHuMR6tamZ8/Vb8hQJhQRZXm48GhLhM4qRzo49wWVfTaYhRv+tYEN8ntq8UrFNf
        AWHHraXyFm/msyb2OBeV4h7r87mFFq4l9Qt+UoO64o7nyQfgBs7grhgj448h7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669456547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oetK6LrR35eqq4wXETgSlPnmU3zBYbTG+xwQBon69N4=;
        b=dB8MumKj0YRbl3KBxDWFyCv3jocVWH5kImKxiGKYY+Yfbt63GVZCcvzGMagisV4mrVqYRP
        F2JwHmCw3jxt0UDQ==
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v4 net-next 7/8] hsr: Use a single struct for self_node.
In-Reply-To: <20221125165610.3802446-8-bigeasy@linutronix.de>
References: <20221125165610.3802446-1-bigeasy@linutronix.de>
 <20221125165610.3802446-8-bigeasy@linutronix.de>
Date:   Sat, 26 Nov 2022 10:55:45 +0100
Message-ID: <87a64edopq.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Nov 25 2022, Sebastian Andrzej Siewior wrote:
> self_node_db is a list_head with one entry of struct hsr_node. The
> purpose is to hold the two MAC addresses of the node itself.
> It is convenient to recycle the structure. However having a list_head
> and fetching always the first entry is not really optimal.
>
> Created a new data strucure contaning the two MAC addresses named
> hsr_self_node. Access that structure like an RCU protected pointer so
> it can be replaced on the fly without blocking the reader.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Looks better. Thanks.

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmOB4qETHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgqAOD/4wgdN40EUKqR/CpmCtD/A5pCOloy+X
hnZzq/BZ/L8uNh6CnwDuTeHMOvdwbL4Ekk0BQhb3RjIt5P40vWUWTC77y3Or5Zo/
rdEk/DlEvhXjXEie9A/WSwesgMjsf09cC2t5ELKuJ1QHvBb5RFssqF+y/DlD1CiD
J7R4Z1k9adQarExA8LOftkkVvb+Q+TJHyC4IM1y7we1el/tffOFk6mTzFB3wKhpL
edchjWUlVj/+MKFkARcdNkg+oAOSQiVc95QJHFXEjSG3iSsCo2AbzbTZEQzd00Me
9Gz2Nfk4jRUPpWcqzI34t2gkQTn6yfDJXMcv6u2rTuSWwUActkKdnDXrdrF6ekDC
WzXJfO6T4v6U29zABxl9JXc91F4BVQx6Cj/JG4RTveStmjYsjPk8alp73v+ZUEjP
aiwNJ6Yye9pxNXiNFeHa9YklDeAByEdsKLfaX1YTX+8uusWePLMmrh2Pmjp5zg/H
PcWGtuB3Uq7G+tsaRii7DF2oiWjGAUKhpxUjT5cOqlwVXB88MAURzowSU57xqxua
em1dVEXvoX5Xn4E2vMNT6A8ZRzqyiqCFZlaAeAAz3zoNZUYbyp5l1n/PqiY0r52b
YNfLrM6eibQAc06/nsp8g3oFfwqIN3s4KvdX50bLPy4vZLNp/NDhlyOwaFUbnD1i
enuAm/niXZYwrA==
=bhcf
-----END PGP SIGNATURE-----
--=-=-=--
