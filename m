Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744776E7C40
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjDSOV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjDSOV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:21:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC1DF9;
        Wed, 19 Apr 2023 07:21:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84B6563FB3;
        Wed, 19 Apr 2023 14:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6750EC4339B;
        Wed, 19 Apr 2023 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681914113;
        bh=HEJF7p3KDVRicgqIkx95paeu/oHEW4x5UvO/q6CgPBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t+OaEKQ3fS8sXiDgC1b39uv4UD1J+tvNSZl0HwYVPJ76niaWmCN29pjgK1qJ9BF+R
         s5pMJu5Df7hvjzHXRYfS/mv3sIXkYvEL+Tqjli+oIjb3ghzMHrdN8NdLkAKKG6wZYW
         v3TVxZsPOHWVdRHj+R8GmlXF1RHVU97QJknLrMBbXnHEnQDXUVQiEj4dFGKBtHvJWi
         E5RWP1LuyvcUP3a3O2OqrYEHuhhKhOFj5UJvsX/G9QSZ+53Zj8yBV8OboHzWjfEaSF
         YSzG9opJcwzCTRgchg4ycEYY/XSX6d/ub0uiwlvxrfJM1pV3mDnltHpQPZSGXxk+s1
         u+pKunIf6rfwg==
Date:   Wed, 19 Apr 2023 16:21:50 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>, brouer@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name,
        Toke Hoiland Jorgensen <toke@redhat.com>
Subject: Re: issue with inflight pages from page_pool
Message-ID: <ZD/4/npAIvS1Co6e@lore-desk>
References: <ZD2NSSYFzNeN68NO@lore-desk>
 <20230417112346.546dbe57@kernel.org>
 <ZD2TH4PsmSNayhfs@lore-desk>
 <20230417120837.6f1e0ef6@kernel.org>
 <ZD26lb2qdsdX16qa@lore-desk>
 <20230417163210.2433ae40@kernel.org>
 <ZD5IcgN5s9lCqIgl@lore-desk>
 <3449df3e-1133-3971-06bb-62dd0357de40@redhat.com>
 <CANn89iKAVERmJjTyscwjRTjTeWBUgA9COz+8HVH09Q0ehHL9Gw@mail.gmail.com>
 <ea762132-a6ff-379a-2cc2-6057754425f7@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lwsbHhNOdCZivJbx"
Content-Disposition: inline
In-Reply-To: <ea762132-a6ff-379a-2cc2-6057754425f7@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lwsbHhNOdCZivJbx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> On 19/04/2023 14.09, Eric Dumazet wrote:
> > On Wed, Apr 19, 2023 at 1:08=E2=80=AFPM Jesper Dangaard Brouer
> > >=20
> > >=20
> > > On 18/04/2023 09.36, Lorenzo Bianconi wrote:
> > > > > On Mon, 17 Apr 2023 23:31:01 +0200 Lorenzo Bianconi wrote:
> > > > > > > If it's that then I'm with Eric. There are many ways to keep =
the pages
> > > > > > > in use, no point working around one of them and not the rest =
:(
> > > > > >=20
> > > > > > I was not clear here, my fault. What I mean is I can see the re=
turned
> > > > > > pages counter increasing from time to time, but during most of =
tests,
> > > > > > even after 2h the tcp traffic has stopped, page_pool_release_re=
try()
> > > > > > still complains not all the pages are returned to the pool and =
so the
> > > > > > pool has not been deallocated yet.
> > > > > > The chunk of code in my first email is just to demonstrate the =
issue
> > > > > > and I am completely fine to get a better solution :)
> > > > >=20
> > > > > Your problem is perhaps made worse by threaded NAPI, you have
> > > > > defer-free skbs sprayed across all cores and no NAPI there to
> > > > > flush them :(
> > > >=20
> > > > yes, exactly :)
> > > >=20
> > > > >=20
> > > > > > I guess we just need a way to free the pool in a reasonable amo=
unt
> > > > > > of time. Agree?
> > > > >=20
> > > > > Whether we need to guarantee the release is the real question.
> > > >=20
> > > > yes, this is the main goal of my email. The defer-free skbs behavio=
ur seems in
> > > > contrast with the page_pool pending pages monitor mechanism or at l=
east they
> > > > do not work well together.
> > > >=20
> > > > @Jesper, Ilias: any input on it?
> > > >=20
> > > > > Maybe it's more of a false-positive warning.
> > > > >=20
> > > > > Flushing the defer list is probably fine as a hack, but it's not
> > > > > a full fix as Eric explained. False positive can still happen.
> > > >=20
> > > > agree, it was just a way to give an idea of the issue, not a proper=
 solution.
> > > >=20
> > > > Regards,
> > > > Lorenzo
> > > >=20
> > > > >=20
> > > > > I'm ambivalent. My only real request wold be to make the flushing
> > > > > a helper in net/core/dev.c rather than open coded in page_pool.c.
> > >=20
> > > I agree. We need a central defer_list flushing helper
> > >=20
> > > It is too easy to say this is a false-positive warning.
> > > IHMO this expose an issue with the sd->defer_list system.
> > >=20
> > > Lorenzo's test is adding+removing veth devices, which creates and runs
> > > NAPI processing on random CPUs.  After veth netdevices (+NAPI) are
> > > removed, nothing will naturally invoking net_rx_softirq on this CPU.
> > > Thus, we have SKBs waiting on CPUs sd->defer_list.  Further more we w=
ill
> > > not create new SKB with this skb->alloc_cpu, to trigger RX softirq IPI
> > > call (trigger_rx_softirq), even if this CPU process and frees SKBs.
> > >=20
> > > I see two solutions:
> > >=20
> > >    (1) When netdevice/NAPI unregister happens call defer_list flushing
> > > helper.
> > >=20
> > >    (2) Use napi_watchdog to detect if defer_list is (many jiffies) ol=
d,
> > > and then call defer_list flushing helper.
> > >=20
> > >=20
> > > > >=20
> > > > > Somewhat related - Eric, do we need to handle defer_list in dev_c=
pu_dead()?
> > >=20
> > > Looks to me like dev_cpu_dead() also need this flushing helper for
> > > sd->defer_list, or at least moving the sd->defer_list to an sd that w=
ill
> > > run eventually.
> >=20
> > I think I just considered having a few skbs in per-cpu list would not
> > be an issue,
> > especially considering skbs can sit hours in tcp receive queues.
> >=20
>=20
> It was the first thing I said to Lorenzo when he first reported the
> problem to me (over chat): It is likely packets sitting in a TCP queue.
> Then I instructed him to look at output from netstat to see queues and
> look for TIME-WAIT, FIN-WAIT etc.
>=20
>=20
> > Do we expect hacing some kind of callback/shrinker to instruct TCP or
> > pipes to release all pages that prevent
> > a page_pool to be freed ?
> >=20
>=20
> This is *not* what I'm asking for.
>=20
> With TCP sockets (pipes etc) we can take care of closing the sockets
> (and programs etc) to free up the SKBs (and perhaps wait for timeouts)
> to make sure the page_pool shutdown doesn't hang.
>=20
> The problem arise for all the selftests that uses veth and bpf_test_run
> (using bpf_test_run_xdp_live / xdp_test_run_setup).  For the selftests
> we obviously take care of closing sockets and removing veth interfaces
> again.  Problem: The defer_list corner-case isn't under our control.
>=20
>=20
> > Here, we are talking of hundreds of thousands of skbs, compared to at
> > most 32 skbs per cpu.
> >=20
>=20
> It is not a memory usage concern.
>=20
> > Perhaps sets sysctl_skb_defer_max to zero by default, so that admins
> > can opt-in
> >=20
>=20
> I really like the sd->defer_list system and I think is should be enabled
> by default.  Even if disabled by default, we still need to handle these
> corner cases, as the selftests shouldn't start to cause-issues when this
> gets enabled.
>=20
> The simple solution is: (1) When netdevice/NAPI unregister happens call
> defer_list flushing helper.  And perhaps we also need to call it in
> xdp_test_run_teardown().  How do you feel about that?
>=20
> --Jesper
>=20

Today I was discussing with Toke about this issue, and we were wondering,
if we just consider the page_pool use-case, what about moving the real pool
destroying steps when we return a page to the pool in page_pool_put_full_pa=
ge()
if the pool has marked to be destroyed and there are no inflight pages inst=
ead
of assuming we have all the pages in the pool when we run page_pool_destroy=
()?
Maybe this means just get rid of the warn in page_pool_release_retry() :)

Regards,
Lorenzo

--lwsbHhNOdCZivJbx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZD/4/QAKCRA6cBh0uS2t
rBW9AQCTfg6N1A1EW/GJEjnEcJnmZ6IU9MIhKenM96QYqjx1DwEA/HYvqL0x+Bnj
uvPSgupsNPDpQySjXbOYOoqmg47aUws=
=PeVt
-----END PGP SIGNATURE-----

--lwsbHhNOdCZivJbx--
