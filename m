Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B67621921
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 17:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiKHQLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 11:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbiKHQLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 11:11:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35142BE35
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 08:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667923816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s7DqOSUPljQniV5sI1Q/EgyBCklY5dznhg0Un3XpKh8=;
        b=aySNmIcxT4m++SslOjbdjotPNwfMXyQCt9O2zfVnbB61HUKh4DbS2xdrM+d/3ZCGJqqL3Q
        ASBBvHIa4Kwb0t97EjOtm/bwfXHS1uUynFYpt0lpQNtqHu+rIplJuYLUP9gln4D74DWhJt
        CorXy8YHNo1YsoBiK08Sj8r2S1+hOiQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-nNQ0tCqHMr26u_TyeEA8Tg-1; Tue, 08 Nov 2022 11:10:12 -0500
X-MC-Unique: nNQ0tCqHMr26u_TyeEA8Tg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C971080253A;
        Tue,  8 Nov 2022 16:10:11 +0000 (UTC)
Received: from localhost (unknown [10.39.195.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 397784B3FC6;
        Tue,  8 Nov 2022 16:10:10 +0000 (UTC)
Date:   Tue, 8 Nov 2022 11:10:09 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
Message-ID: <Y2p/YcUFhFDUnLGq@fedora>
References: <Y2lw4Qc1uI+Ep+2C@fedora>
 <4281b354-d67d-2883-d966-a7816ed4f811@kernel.dk>
 <Y2phEZKYuSmPL5B5@fedora>
 <93fa2da5-c81a-d7f8-115c-511ed14dcdbb@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RIsmrb8gxfyCVd7E"
Content-Disposition: inline
In-Reply-To: <93fa2da5-c81a-d7f8-115c-511ed14dcdbb@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RIsmrb8gxfyCVd7E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2022 at 07:09:30AM -0700, Jens Axboe wrote:
> On 11/8/22 7:00 AM, Stefan Hajnoczi wrote:
> > On Mon, Nov 07, 2022 at 02:38:52PM -0700, Jens Axboe wrote:
> >> On 11/7/22 1:56 PM, Stefan Hajnoczi wrote:
> >>> Hi Jens,
> >>> NICs and storage controllers have interrupt mitigation/coalescing
> >>> mechanisms that are similar.
> >>
> >> Yep
> >>
> >>> NVMe has an Aggregation Time (timeout) and an Aggregation Threshold
> >>> (counter) value. When a completion occurs, the device waits until the
> >>> timeout or until the completion counter value is reached.
> >>>
> >>> If I've read the code correctly, min_wait is computed at the beginning
> >>> of epoll_wait(2). NVMe's Aggregation Time is computed from the first
> >>> completion.
> >>>
> >>> It makes me wonder which approach is more useful for applications. Wi=
th
> >>> the Aggregation Time approach applications can control how much extra
> >>> latency is added. What do you think about that approach?
> >>
> >> We only tested the current approach, which is time noted from entry, n=
ot
> >> from when the first event arrives. I suspect the nvme approach is bett=
er
> >> suited to the hw side, the epoll timeout helps ensure that we batch
> >> within xx usec rather than xx usec + whatever the delay until the first
> >> one arrives. Which is why it's handled that way currently. That gives
> >> you a fixed batch latency.
> >=20
> > min_wait is fine when the goal is just maximizing throughput without any
> > latency targets.
>=20
> That's not true at all, I think you're in different time scales than
> this would be used for.
>=20
> > The min_wait approach makes it hard to set a useful upper bound on
> > latency because unlucky requests that complete early experience much
> > more latency than requests that complete later.
>=20
> As mentioned in the cover letter or the main patch, this is most useful
> for the medium load kind of scenarios. For high load, the min_wait time
> ends up not mattering because you will hit maxevents first anyway. For
> the testing that we did, the target was 2-300 usec, and 200 usec was
> used for the actual test. Depending on what the kind of traffic the
> server is serving, that's usually not much of a concern. From your
> reply, I'm guessing you're thinking of much higher min_wait numbers. I
> don't think those would make sense. If your rate of arrival is low
> enough that min_wait needs to be high to make a difference, then the
> load is low enough anyway that it doesn't matter. Hence I'd argue that
> it is indeed NOT hard to set a useful upper bound on latency, because
> that is very much what min_wait is.
>=20
> I'm happy to argue merits of one approach over another, but keep in mind
> that this particular approach was not pulled out of thin air AND it has
> actually been tested and verified successfully on a production workload.
> This isn't a hypothetical benchmark kind of setup.

Fair enough. I just wanted to make sure the syscall interface that gets
merged is as useful as possible.

Thanks,
Stefan

--RIsmrb8gxfyCVd7E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNqf2EACgkQnKSrs4Gr
c8ibJAgAwCkgFQj3M/AtwrYKp5jcONWmWCkLYWKZTWD2zn33aH3M99YeCNN8U+Ph
763iL9dzJ/oDgsL99gOOoRzo92LXg8XJxtuEq7zv4F7nyGDRAQBBQqp4NTU2QyNP
iaDznGnGimxknAVPrPE7ovG25wj2s8bmQW6WIzk1NoR8SuR3FdJvRGhY+5msSmKQ
cJw2/47sD7k2TNot2DTXdDxPpQ8n4nIyYPNyxaAjHgr//LXgvpYYvMhm3uG128Ri
YktTbZz2h5P8vaj9C/QNk3WDxNTPtQ3ukBs9nkVj7OF7vyQ+0R1hW8/OhsE9GxsZ
KBKaNilqPaoWY9tLJ9Kxvd4bz9G27Q==
=ejdq
-----END PGP SIGNATURE-----

--RIsmrb8gxfyCVd7E--

