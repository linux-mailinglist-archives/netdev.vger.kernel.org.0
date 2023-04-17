Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A996E4D55
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjDQPdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjDQPdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:33:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4558C164;
        Mon, 17 Apr 2023 08:32:38 -0700 (PDT)
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1681745520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZNqAznZucUwar6l9V+SpEqFf4WGQ4TaEWsz5LdTwLO0=;
        b=h4MK9rQxCNldmspQ2ekSbav6OCDIBvW/lBNViHTg8Eew50AGem+33buONoPvC5dgnRyNij
        kYFzHh2AjcCXT0UfeqyGUpQmiE2P+iyVUK6aqV7ATLBr/5XwJoyJ7BgsXOd6ZQTr9M5+Tg
        InWl/G01MrXTXAN0bANkhXc9bchlAWRZI4pHLxPX+dxJuY7bxfgZ8MJFSaL3iQY8zqtDms
        mg08ta0IdmXbR2GZu6zyujObgpf+0y8uU7Rk0xeDdegiPQ2xID2T3/hVZBrRg2WVWZEb2f
        MSjlqc8bYzKxWS3wEN+YM9cJvhQnUK5G94/Bf3dszKvEP25KO9iBNailTkfepA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1681745520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZNqAznZucUwar6l9V+SpEqFf4WGQ4TaEWsz5LdTwLO0=;
        b=3Rb4+K6SMPMktyFO3+RfZXH19dm4B/+tIp7Nz5cDQuXxblNrtx7bNM12NK/g7FFPDeLHs+
        gC3+0zdB34IrhqCg==
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8r?= =?utf-8?Q?gensen?= 
        <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, yoong.siang.song@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next V1 5/5] selftests/bpf: xdp_hw_metadata track
 more timestamps
In-Reply-To: <168174344813.593471.4026230439937368990.stgit@firesoul>
References: <168174338054.593471.8312147519616671551.stgit@firesoul>
 <168174344813.593471.4026230439937368990.stgit@firesoul>
Date:   Mon, 17 Apr 2023 17:31:58 +0200
Message-ID: <87leiqsexd.fsf@kurt>
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

On Mon Apr 17 2023, Jesper Dangaard Brouer wrote:
> To correlate the hardware RX timestamp with something, add tracking of
> two software timestamps both clock source CLOCK_TAI (see description in
> man clock_gettime(2)).
>
> XDP metadata is extended with xdp_timestamp for capturing when XDP
> received the packet. Populated with BPF helper bpf_ktime_get_tai_ns(). I
> could not find a BPF helper for getting CLOCK_REALTIME, which would have
> been preferred. In userspace when AF_XDP sees the packet another
> software timestamp is recorded via clock_gettime() also clock source
> CLOCK_TAI.
>
> Example output shortly after loading igc driver:
>
>   poll: 1 (0) skip=1 fail=0 redir=2
>   xsk_ring_cons__peek: 1
>   0x12557a8: rx_desc[1]->addr=100000000009000 addr=9100 comp_addr=9000
>   rx_hash: 0x82A96531 with RSS type:0x1
>   rx_timestamp:  1681740540304898909 (sec:1681740540.3049)
>   XDP RX-time:   1681740577304958316 (sec:1681740577.3050) delta sec:37.0001 (37000059.407 usec)
>   AF_XDP time:   1681740577305051315 (sec:1681740577.3051) delta sec:0.0001 (92.999 usec)
>   0x12557a8: complete idx=9 addr=9000
>
> The first observation is that the 37 sec difference between RX HW vs XDP
> timestamps, which indicate hardware is likely clock source
> CLOCK_REALTIME, because (as of this writing) CLOCK_TAI is initialised
> with a 37 sec offset.

Maybe I'm missing something here, but in order to compare the hardware
with software timestamps (e.g., by using bpf_ktime_get_tai_ns()) the
time sources have to be synchronized by using something like
phc2sys. That should make them comparable within reasonable range
(nanoseconds).

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJSBAEBCgA8FiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmQ9Zm4eHGt1cnQua2Fu
emVuYmFjaEBsaW51dHJvbml4LmRlAAoJEMGT0fKqRnOCYtUP/3c5DAmd2vNkZ6A9
Sy1VrS9EFf5Re6h3DXMxCBsNi1AC/lYiNfkF2YRIY45UPntexdrl8J1ehisiIrWs
OPi2cIyZObXXrm5SCXDk/o//G3cwv0CwqCC5Wnhk1120d9kpAlXwiYpHZnzZRFGE
2XKkAcNOaKqjwlC8eKxI8dTIfZEWl2w1nazOzNSQCGnQV9sll1TetJaempzYyXkp
luI2fmsuLFt9z02xW33jS2W2fRQoIfBbb6PIuGPiAnjGMNiUNeyh6hg7wzDz4uHA
RnM87yFtBbTlIwzAgpSMXXnmdyLL5uJUmqiiS9RvxZhWYklc2015OsynMBO7namn
MtT1bPjrFxVrIRBYTQ+YaTuUwRN/sLkye92IG6AttUjcJElvL3xW20kWMs+nqgGP
yBB2Y/DLsNzWVDIXY7406U1/6bZEZjHaCFawnXbrYUurAXr2zG27x13aFQWxHD69
wyH3esfAZP8/0yBucSlpbgBiOOwz7ys2M/I9NaAQAKVitL11bDSqHBSuBAp3T1im
UBZXIws7gqvQ1L3DMj1QnBi1QyheCcjvyS2bXgn00t27aRo5uy8Gdv750bW4RqES
hMxSATWP2Ee+ePTYVMHOCsUStTkX0qyT7iaPARC7HbpId1dmTVulzrdz5eUGJDJU
yNNSk0lrFfo1uXx7AScZAHpkl3zZ
=YsLm
-----END PGP SIGNATURE-----
--=-=-=--
