Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C6B58C2E1
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 07:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbiHHFcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 01:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiHHFcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 01:32:24 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D5D641F;
        Sun,  7 Aug 2022 22:32:23 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1659936741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yXDllftD4QyDeHUS/2Bf32lao56WYMz9aqKNaMzbgow=;
        b=l/5g3LBSyqvi5Gjq24ubCHcG7qabOObZZ8TLuSHVu2BIS/VvakzjFtEQzYJYQ0lDr+avMs
        7ha3lBTXkBnoZ8oWULns3TlaqjljCBjGq+WL03HR0ADPqlEiEWZvI/x/SOW+FVa1UDqex7
        QtPg0TFpK7O5ymQK226DLAuGBh9h9uc+2WvyRYBko+ntO6EUGXioGIjWrdL6ODchFkrPBA
        1q38Gh9yFYqx3jzDx0SvzialxaNYXmqKisF81Dc9IuxkXl4ikfpPK3Dqt7uTDWyH9hdKZJ
        iGZDBuriYVlgNQyTi3vtvqCbdOMerfu7sbWIqYzFg3d5Bkn0EBdaZXPSSYf9FA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1659936741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yXDllftD4QyDeHUS/2Bf32lao56WYMz9aqKNaMzbgow=;
        b=E3qbUOAt5/fCLiyUb7VbZKltnLl6fdQbVp8zwrGHw4tcKTuoetrcDyMMnH9thcn2pMs8d8
        Bcn/GPkyAKeOPQAA==
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gene Chen <gene_chen@richtek.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Eddie James <eajames@linux.ibm.com>,
        Denis Osterland-Heim <Denis.Osterland@diehl.com>,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 11/11] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
In-Reply-To: <20220805154907.32263-12-andriy.shevchenko@linux.intel.com>
References: <20220805154907.32263-1-andriy.shevchenko@linux.intel.com>
 <20220805154907.32263-12-andriy.shevchenko@linux.intel.com>
Date:   Mon, 08 Aug 2022 07:32:19 +0200
Message-ID: <87pmhbxpuk.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Aug 05 2022, Andy Shevchenko wrote:
> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmLwn+MTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgrNzEACnffyzXSC3y5NLX9wOxrvEQH/DTqkA
DHNJ4NaHmLifJPoqkqY1sRe4pxQFV9KDhKMC+qThd8MRDy06JgCEFjbyeM5RqI5i
V2OF0kF4iX9cZ9e6FE+Tw3usDLSMuTUZiFgQqGD4FfKExaa1ARa7e1ODhrlOcQm3
qwv++kbeU/tao2jCnVdhiKfkT68fuBY9wnfRdul0bjiDv5x9olsrktbDvJTKCsC3
kAF/cfOQBv6f1Q06OMr1wCskw1Je7dGFehq5FkjtZ5xWZoIPpLkV858nI4rfn+DO
M6AxtrnZMr8KJAir4YhU1NDvYGSrL5wQv3nqc/NJoaeUkg8nj0wVqeXuIsgsznBC
BkH0VJ0RHtENu6p4NKCJaGnjW5RNPDmZu8CeanDhtTDAnhkhnfhe8t1Y8+pTa2Lk
mdaolZRJf7N+E/nKx9RiKkHh7goa5xrzVRHkIgYKwWb/Zu8z7I3uhhQiYfzVgC60
Jpscye/KxPMt/bc82k3Rn5iUaqd64KKLuF0K0p/1zV7I0XbcYHK33M0IiI3cz8Vx
xdMA1JoNz1zTR/SSgkjObfO2m/Xk+bUkk9LHjBONUhBrsK4UPcLlO3baUgVhk2vs
+p4DC2UHEV3jzSH9G0cMJHhgJEej2hnp5qcp2Ij3F19ywVEbEmgSkTnZbUXu/rPh
i4tkTsGrGWwQhg==
=o6fN
-----END PGP SIGNATURE-----
--=-=-=--
