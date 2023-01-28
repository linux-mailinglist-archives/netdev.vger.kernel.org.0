Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1D167F7B1
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 12:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbjA1L7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 06:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjA1L7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 06:59:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038C6721E4
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 03:59:38 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qw9/0fAFBJtsBcs/wfjdQ4ue+5ovwgiDXeh4wauibCM=;
        b=TNdGNr6msc/tld+iWzBDyBo8RlHSqz9zjPoNdCb+GrDri/GE1J3019cqd+ZG0l9kmuxjx8
        qJdODz7iQiGqGPEdRucYb0FZGKpAc3pU2R9Z8z+SqLQHpMY/p+fwj9pFwOHQYLjJ5/eLVS
        u9CwANgqSZSZUD2lgHCtDotENZzg52tnCO9D7YrPDA4Ssn6TJATqe8XGp+SJAfqpu5xDJ1
        4HCW5NA+VhIhtRfHE56dEPi7wXUA1Omcago2VkdoayCpt5SGaluGQgOrGL5JpqcbiMq8D4
        1NaQUSaHT6nfkZFR+BN4Moq+8o6oug/H9LSH44FsmfF3vP0ExgUKVLHKSBTYmQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qw9/0fAFBJtsBcs/wfjdQ4ue+5ovwgiDXeh4wauibCM=;
        b=4uJyrzKBI0ZOHhw1vRBVgzBBpmeT3hN2HcHGj4+CQXj+X14gPM/qEWsNZo/et1l0PJ1S6Q
        fX1ABkQ31YD6wiDg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 02/15] net/sched: taprio: continue with
 other TXQs if one dequeue() failed
In-Reply-To: <20230128010719.2182346-3-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-3-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 12:59:36 +0100
Message-ID: <87sffuvphz.fsf@kurt>
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

On Sat Jan 28 2023, Vladimir Oltean wrote:
> This changes the handling of an unlikely condition to not stop dequeuing
> if taprio failed to dequeue the peeked skb in taprio_dequeue().
>
> I've no idea when this can happen, but the only side effect seems to be
> that the atomic_sub_return() call right above will have consumed some
> budget. This isn't a big deal, since either that made us remain without
> any budget (and therefore, we'd exit on the next peeked skb anyway), or
> we could send some packets from other TXQs.
>
> I'm making this change because in a future patch I'll be refactoring the
> dequeue procedure to simplify it, and this corner case will have to go
> away.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVDigTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgmuQD/9B82a8zsjpYR1gyhzzMJ2s+HIjKkIP
CoqnDpYOqcgOQeFJ8UdFa/RJkFGuNmHsJBnSzFD+kJ5s0GOvL54lyVQBp0Pdtlyq
pM4ABcJ3GgIlimxj1/o2t+7z3RJ+mvU0wrrVXwX+1TfROdGga6ZmkR0H4wTnrGJD
JzeLtBnKO1HabAwiLhgePA8VQN/STfOmIa86dhNeAoBB9r8knHZT8c0tJhdc7VGU
7nFOXz5vxrGQGjJqJOre/fyZehmllOT2EvWlfQWxHgHbMJVSXBwIdtvF7sFYnDal
zk5YVoNIflVy7v4y+kjylhH9DWFt/aXDtQsVnud40dtWaNq9Qj2tpmU7oS9u0evm
IrFMh7vCP4fFDvvHmvNymboS9jxoEHtLQg6kmtTwDtkWl3ZewFfHjuHHW8ZeM9aR
0GN2UKscWvRrWyr6nC9V5MGGxcoD6w/5prSWZVE+wCKpa8QVDwfBXEkN+goFQ//W
m+9so7tD/m1IqYyePz0ij6SUPF//9dCqHkeJkgsEwFxE4y9sUcLOO1W2OPEhQeB7
eM4Y99u+v0rh7YTIhiROheu/7ZAKK/Dsd+g8EkT/kw9BDKES8o/5+zWlWTzlamDM
9vyZ1QoM84xo6qXX/Qa2XO3HssyIG3pVB2Bmr5uUHJkzkjd11gYX5B2qKUivONz/
w5lcqb3QMTLGZw==
=le99
-----END PGP SIGNATURE-----
--=-=-=--
