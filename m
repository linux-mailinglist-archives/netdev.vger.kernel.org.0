Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724426EDCF8
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbjDYHpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbjDYHpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:45:46 -0400
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1C893
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 00:45:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 115B4220002;
        Tue, 25 Apr 2023 09:45:42 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dj0dHKqTed6I; Tue, 25 Apr 2023 09:45:40 +0200 (CEST)
Received: from [10.6.0.125] (unknown [185.12.128.225])
        by mail.codelabs.ch (Postfix) with ESMTPSA id D798A220001;
        Tue, 25 Apr 2023 09:45:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
        s=default; t=1682408740;
        bh=Wy08fEc5GoD+JNEOR3qM2dAiJwHLw2Kx13DVIR5XoEo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WKi6MUZv9YF0eAhZTbnQUopY4vKixRPpqHq/jBXi1HziAf3toSnD5W9do4X/Gi1kp
         pGlvAW8lkXi2c/woox4/E/9KfW+qAzCW/lVVaZ4m6MsZmkaBOWpRv5MDx0QBz7uacd
         UCNtxyJlH/htFNvL9hIiXoh4V+O6hY8PV/VpjDaC7zUIrUQW/0D4vQZY2T9v/Us6UH
         q7fn62szM2URHZVSDHsOUUzIRNJ+9eNOVbmFCnuAUs0qFCBfYikOrifGY6U1OQ2u7h
         7IV49VVPo3rB8DepryDFSoL3bGrmtKsQq4GpcWFL1jGMKs8p4L8mxzpmdcU2cAXx6F
         jt7CTbBEGDLiw==
Message-ID: <b5972f7bab88300e924853f4d9cca62f36a735cb.camel@strongswan.org>
Subject: Re: [PATCH ipsec v2] xfrm: Preserve xfrm interface secpath for
 packets forwarded
From:   Martin Willi <martin@strongswan.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Benedict Wong <benedictwong@google.com>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Date:   Tue, 25 Apr 2023 09:45:40 +0200
In-Reply-To: <CANrj0bb6nGzsQMH3eOHHD_fukynFb0NVS6=+xqGrWmAZ+gco1g@mail.gmail.com>
References: <20230412085615.124791-1-martin@strongswan.org>
         <CANrj0bb6nGzsQMH3eOHHD_fukynFb0NVS6=+xqGrWmAZ+gco1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> [...] my original change also happens to break Transport-in-Tunnel
> mode (which attempts to match the outer tunnel mode policy twice.). I
> wonder if it's worth just reverting first

Given that the offending commit has been picked up by -stable and now
by distros, I guess this regression will start affecting more IPsec
users.

May I suggest to go with a revert of the offending commit as an
immediate fix, and then bring in a fixed nested policy check from
Benedict in a separate effort?

I'll post a patch with the revert.

Thanks,
Martin
