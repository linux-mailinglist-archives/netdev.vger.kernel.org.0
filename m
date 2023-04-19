Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B8B6E7FCB
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 18:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbjDSQlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 12:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbjDSQlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 12:41:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADCE4697
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 09:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681922414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8cw7LajUVrrWi88fW/qgXBhZmkexifRz2S5k3mFR+pw=;
        b=YE3tA3JRVLXFzikl0e+LmN7RC4e1iQ2g8eO5Mdes6QH2B/idyfmB/Ydnl7OK1b0fNSn285
        PUPiA0MUc9opoL4f82XEsb61te282nauFIgSYlIk6on5IKp2TSOeByuUgWDvrer1OY9QEQ
        oLWZcCM3Dusi2RpU+1flNfYIP6HUKYE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-DKx2H7mrO4Whlj40LLRyRA-1; Wed, 19 Apr 2023 12:40:13 -0400
X-MC-Unique: DKx2H7mrO4Whlj40LLRyRA-1
Received: by mail-wm1-f70.google.com with SMTP id q19-20020a05600c46d300b003ef69894934so1250333wmo.6
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 09:40:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681922412; x=1684514412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8cw7LajUVrrWi88fW/qgXBhZmkexifRz2S5k3mFR+pw=;
        b=AWsMwRVEDZ3UAhMxTAue4uszSH8cjmLE2cwAd4KAggzIge1nK0hWXphqrZkWFQRkea
         2i5YCbyZzUkdK6yX+NqrlGjQ7i1LrP0rdCN5HJ3AS/tLNybr6JNoyDvvzsUdF3+rtc3w
         Ah7e6mj30L/auTohQS3KuJbyUNfieoGi1vF/mAqCY/gsZDHqZ1tQhIggDGBzzMyDzia3
         2G+Of+yH30wonulZIfRKNUJqPT/sOEl9ij9iJDFmygv/TGDWizl5YH5p54DXLjiJMvAD
         C+51TW0/cocCPiqOKRMejpPW42EFmcKIWxpcXyTgb8RRTYyILQ+Kb4O+9wFdsVdUlKdK
         wGDg==
X-Gm-Message-State: AAQBX9cyQ4c0ue6tIJ1PUVLxRkTvVcREdwGxjuE6dSGTAjnDJh1in9iA
        TmMvoV6n41uWh7n2vfurGnkUQYgwXADevtG/aJaVByAgNN/THP/nrJYjtMGQqHNd/QK5btP6oz3
        468UF1kMbJ1qxMqzr
X-Received: by 2002:a05:600c:28e:b0:3f0:85b8:ce6e with SMTP id 14-20020a05600c028e00b003f085b8ce6emr17988709wmk.37.1681922412289;
        Wed, 19 Apr 2023 09:40:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350aSlTFAYnbmpLzDBk1OmsNDKq6OhwEXTs8ATUPnKwEKb8oLQK9zZHmgHGgGRUhTnENpVBpMvg==
X-Received: by 2002:a05:600c:28e:b0:3f0:85b8:ce6e with SMTP id 14-20020a05600c028e00b003f085b8ce6emr17988677wmk.37.1681922411872;
        Wed, 19 Apr 2023 09:40:11 -0700 (PDT)
Received: from localhost (net-130-25-106-149.cust.vodafonedsl.it. [130.25.106.149])
        by smtp.gmail.com with ESMTPSA id y10-20020a1c4b0a000000b003f182a10106sm1272600wma.8.2023.04.19.09.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:40:11 -0700 (PDT)
Date:   Wed, 19 Apr 2023 18:40:09 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, brouer@redhat.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org, nbd@nbd.name,
        Toke Hoiland Jorgensen <toke@redhat.com>
Subject: Re: issue with inflight pages from page_pool
Message-ID: <ZEAZacIv9ssQF1hD@lore-desk>
References: <ZD2TH4PsmSNayhfs@lore-desk>
 <20230417120837.6f1e0ef6@kernel.org>
 <ZD26lb2qdsdX16qa@lore-desk>
 <20230417163210.2433ae40@kernel.org>
 <ZD5IcgN5s9lCqIgl@lore-desk>
 <3449df3e-1133-3971-06bb-62dd0357de40@redhat.com>
 <CANn89iKAVERmJjTyscwjRTjTeWBUgA9COz+8HVH09Q0ehHL9Gw@mail.gmail.com>
 <ea762132-a6ff-379a-2cc2-6057754425f7@redhat.com>
 <ZD/4/npAIvS1Co6e@lore-desk>
 <e8df2654-6a5b-3c92-489d-2fe5e444135f@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BG4t38bJ8cELjR3L"
Content-Disposition: inline
In-Reply-To: <e8df2654-6a5b-3c92-489d-2fe5e444135f@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BG4t38bJ8cELjR3L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 19/04/2023 16.21, Lorenzo Bianconi wrote:
> > >=20
> > > On 19/04/2023 14.09, Eric Dumazet wrote:
> > > > On Wed, Apr 19, 2023 at 1:08=E2=80=AFPM Jesper Dangaard Brouer
> > > > >=20
> > > > >=20
> > > > > On 18/04/2023 09.36, Lorenzo Bianconi wrote:
> > > > > > > On Mon, 17 Apr 2023 23:31:01 +0200 Lorenzo Bianconi wrote:
> > > > > > > > > If it's that then I'm with Eric. There are many ways to k=
eep the pages
> > > > > > > > > in use, no point working around one of them and not the r=
est :(
> > > > > > > >=20
> > > > > > > > I was not clear here, my fault. What I mean is I can see th=
e returned
> > > > > > > > pages counter increasing from time to time, but during most=
 of tests,
> > > > > > > > even after 2h the tcp traffic has stopped, page_pool_releas=
e_retry()
> > > > > > > > still complains not all the pages are returned to the pool =
and so the
> > > > > > > > pool has not been deallocated yet.
> > > > > > > > The chunk of code in my first email is just to demonstrate =
the issue
> > > > > > > > and I am completely fine to get a better solution :)
> > > > > > >=20
> > > > > > > Your problem is perhaps made worse by threaded NAPI, you have
> > > > > > > defer-free skbs sprayed across all cores and no NAPI there to
> > > > > > > flush them :(
> > > > > >=20
> > > > > > yes, exactly :)
> > > > > >=20
> > > > > > >=20
> > > > > > > > I guess we just need a way to free the pool in a reasonable=
 amount
> > > > > > > > of time. Agree?
> > > > > > >=20
> > > > > > > Whether we need to guarantee the release is the real question.
> > > > > >=20
> > > > > > yes, this is the main goal of my email. The defer-free skbs beh=
aviour seems in
> > > > > > contrast with the page_pool pending pages monitor mechanism or =
at least they
> > > > > > do not work well together.
> > > > > >=20
> > > > > > @Jesper, Ilias: any input on it?
> > > > > >=20
> > > > > > > Maybe it's more of a false-positive warning.
> > > > > > >=20
> > > > > > > Flushing the defer list is probably fine as a hack, but it's =
not
> > > > > > > a full fix as Eric explained. False positive can still happen.
> > > > > >=20
> > > > > > agree, it was just a way to give an idea of the issue, not a pr=
oper solution.
> > > > > >=20
> > > > > > Regards,
> > > > > > Lorenzo
> > > > > >=20
> > > > > > >=20
> > > > > > > I'm ambivalent. My only real request wold be to make the flus=
hing
> > > > > > > a helper in net/core/dev.c rather than open coded in page_poo=
l.c.
> > > > >=20
> > > > > I agree. We need a central defer_list flushing helper
> > > > >=20
> > > > > It is too easy to say this is a false-positive warning.
> > > > > IHMO this expose an issue with the sd->defer_list system.
> > > > >=20
> > > > > Lorenzo's test is adding+removing veth devices, which creates and=
 runs
> > > > > NAPI processing on random CPUs.  After veth netdevices (+NAPI) are
> > > > > removed, nothing will naturally invoking net_rx_softirq on this C=
PU.
> > > > > Thus, we have SKBs waiting on CPUs sd->defer_list.  Further more =
we will
> > > > > not create new SKB with this skb->alloc_cpu, to trigger RX softir=
q IPI
> > > > > call (trigger_rx_softirq), even if this CPU process and frees SKB=
s.
> > > > >=20
> > > > > I see two solutions:
> > > > >=20
> > > > >     (1) When netdevice/NAPI unregister happens call defer_list fl=
ushing
> > > > > helper.
> > > > >=20
> > > > >     (2) Use napi_watchdog to detect if defer_list is (many jiffie=
s) old,
> > > > > and then call defer_list flushing helper.
> > > > >=20
> > > > >=20
> > > > > > >=20
> > > > > > > Somewhat related - Eric, do we need to handle defer_list in d=
ev_cpu_dead()?
> > > > >=20
> > > > > Looks to me like dev_cpu_dead() also need this flushing helper for
> > > > > sd->defer_list, or at least moving the sd->defer_list to an sd th=
at will
> > > > > run eventually.
> > > >=20
> > > > I think I just considered having a few skbs in per-cpu list would n=
ot
> > > > be an issue,
> > > > especially considering skbs can sit hours in tcp receive queues.
> > > >=20
> > >=20
> > > It was the first thing I said to Lorenzo when he first reported the
> > > problem to me (over chat): It is likely packets sitting in a TCP queu=
e.
> > > Then I instructed him to look at output from netstat to see queues and
> > > look for TIME-WAIT, FIN-WAIT etc.
> > >=20
> > >=20
> > > > Do we expect hacing some kind of callback/shrinker to instruct TCP =
or
> > > > pipes to release all pages that prevent
> > > > a page_pool to be freed ?
> > > >=20
> > >=20
> > > This is *not* what I'm asking for.
> > >=20
> > > With TCP sockets (pipes etc) we can take care of closing the sockets
> > > (and programs etc) to free up the SKBs (and perhaps wait for timeouts)
> > > to make sure the page_pool shutdown doesn't hang.
> > >=20
> > > The problem arise for all the selftests that uses veth and bpf_test_r=
un
> > > (using bpf_test_run_xdp_live / xdp_test_run_setup).  For the selftests
> > > we obviously take care of closing sockets and removing veth interfaces
> > > again.  Problem: The defer_list corner-case isn't under our control.
> > >=20
> > >=20
> > > > Here, we are talking of hundreds of thousands of skbs, compared to =
at
> > > > most 32 skbs per cpu.
> > > >=20
> > >=20
> > > It is not a memory usage concern.
> > >=20
> > > > Perhaps sets sysctl_skb_defer_max to zero by default, so that admins
> > > > can opt-in
> > > >=20
> > >=20
> > > I really like the sd->defer_list system and I think is should be enab=
led
> > > by default.  Even if disabled by default, we still need to handle the=
se
> > > corner cases, as the selftests shouldn't start to cause-issues when t=
his
> > > gets enabled.
> > >=20
> > > The simple solution is: (1) When netdevice/NAPI unregister happens ca=
ll
> > > defer_list flushing helper.  And perhaps we also need to call it in
> > > xdp_test_run_teardown().  How do you feel about that?
> > >=20
> > > --Jesper
> > >=20
> >=20
> > Today I was discussing with Toke about this issue, and we were wonderin=
g,
> > if we just consider the page_pool use-case, what about moving the real =
pool
> > destroying steps when we return a page to the pool in page_pool_put_ful=
l_page()
> > if the pool has marked to be destroyed and there are no inflight pages =
instead
> > of assuming we have all the pages in the pool when we run page_pool_des=
troy()?
>=20
> It sounds like you want to add a runtime check to the fast-path to
> handle these corner cases?
>=20
> For performance reason we should not call page_pool_inflight() check in
> fast-path, please!

ack, right.

>=20
> Details: You hopefully mean running/calling page_pool_release(pool) and n=
ot
> page_pool_destroy().

yes, I mean page_pool_release()

>=20
> I'm not totally against the idea, as long as someone is willing to do
> extensive benchmarking that it doesn't affect fast-path performance.
> Given we already read pool->p.flags in fast-path, it might be possible
> to hide the extra branch (in the CPU pipeline).
>=20
>=20
> > Maybe this means just get rid of the warn in page_pool_release_retry() =
:)
> >=20
>=20
> Sure, we can remove the print statement, but it feels like closing our
> eyes and ignoring the problem.  We can remove the print statement, and
> still debug the problem, as I have added tracepoints (to debug this).
> But users will not report these issue early... on the other hand most of
> these reports will likely be false-positives.
>=20
> This reminds me that Jakub's recent defer patches returning pages
> 'directly' to the page_pool alloc-cache, will actually result in this
> kind of bug.  This is because page_pool_destroy() assumes that pages
> cannot be returned to alloc-cache, as driver will have "disconnected" RX
> side.  We need to address this bug separately.  Lorenzo you didn't
> happen to use a kernel with Jakub's patches included, do you?

nope, I did not tested them.

Regards,
Lorenzo

>=20
> --Jesper
>=20
>=20
>=20

--BG4t38bJ8cELjR3L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZEAZaQAKCRA6cBh0uS2t
rLMiAP0Z372omA9TVhVXNUWSAgVcGFCPvUr1KUrzTqV/b8rdSwD/SV9Odpc7BjlW
VooiG0Cpxs7fHYurGEu2pFLD8gSdkQc=
=hZ9H
-----END PGP SIGNATURE-----

--BG4t38bJ8cELjR3L--

