Return-Path: <netdev+bounces-9300-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8777285E1
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:57:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00A9C1C20FF4
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7953719510;
	Thu,  8 Jun 2023 16:57:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFB010973
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:57:56 +0000 (UTC)
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E92210E
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
	s=20121; t=1686243469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Swrwi2+BTcTTOtQrnhZFPM4TZWnkfpHRVJ6RdmbTlE0=;
	b=ts56ChoVKHSa+PpM+jwHHKcTXXuIMuBIxHOooXE82cCA4bru4SJPi3DLGPspC/MRWxzO9X
	DLu4GEzka7miDcMryYZxkt++k9fw2wpmL2Fk85obvi+fOp8RUtx4TaU9f4DdQNJJy4vut2
	8hmU/vqd6IRV0yUOEV8+2xL8JWARrzI=
From: Sven Eckelmann <sven@narfation.org>
To: Jakub Kicinski <kuba@kernel.org>,
 Simon Wunderlich <sw@simonwunderlich.de>, Paolo Abeni <pabeni@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
 b.a.t.m.a.n@lists.open-mesh.org, Vladislav Efanov <VEfanov@ispras.ru>,
 stable@kernel.org
Subject:
 Re: [PATCH 1/1] batman-adv: Broken sync while rescheduling delayed work
Date: Thu, 08 Jun 2023 18:57:44 +0200
Message-ID: <5681063.DvuYhMxLoT@ripper>
In-Reply-To: <6a36f208b961181df9a0c611a6f5ffc4c76911f6.camel@redhat.com>
References:
 <20230607155515.548120-1-sw@simonwunderlich.de>
 <20230607220126.26c6ee40@kernel.org>
 <6a36f208b961181df9a0c611a6f5ffc4c76911f6.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5940952.lOV4Wx5bFT";
 micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--nextPart5940952.lOV4Wx5bFT
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
Date: Thu, 08 Jun 2023 18:57:44 +0200
Message-ID: <5681063.DvuYhMxLoT@ripper>
MIME-Version: 1.0

On Thursday, 8 June 2023 11:27:31 CEST Paolo Abeni wrote:
[...]
> > We're still not preventing the timer / work from getting scheduled
> > and staying alive after the netdev has been freed, right?
> 
> I *think* this specific use case does not expose such problem, as the
> delayed work is (AFAICS) scheduled only at device creation time and by
> the work itself, it should never be re-scheduled after
> cancel_delayed_work_sync()

Correct.

* batadv_dat_start_timer is the only thing scheduling it
* batadv_dat_start_timer is called by:

  - batadv_dat_purge (the worker rearming itself)
  - batadv_dat_init (when the interface is created)

Kind regards,
	Sven
--nextPart5940952.lOV4Wx5bFT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmSCCIgACgkQXYcKB8Em
e0ahnQ/+PJdBfj+dwesG6ozn6XhVZsKGvFnJ9wZ7+g3EfWPDJ+jtobwN2g8oRfSn
nUWhNXD+Dj1+AFLxc59t3M+TlFuMtEIujprsRTnrMSRRGWbQl8HNU/aa0JDpkJKP
jrnIELPjGUdK1IgVd0XilH8fpKid/wleacRfIKAwa5JCyfL7LeK/28CnMpb5+l1p
zwJo2xyZJKTx0jUNuK1yh55pzwPtHftWEp6mIx+wOnebcZg1+c/dmyB0IfV3PaCQ
cu0igtHvFPFdT/xONvWPbGTLf+XypCVElAiFgoQZgwl9hZdG1a8is5CGJzpxubn5
AWQXCqcRyAiqNmEiTnoevRcO/WNesevwv7xi51/QJPvVfidC+Q4qEW3yzSY0X9k7
aNs6P1L4mJE2bb1bR225dErrQ3coQX9Sg9HNAV40iY9C8QwROCmZNQfBTi3jI3H4
EjftcdKnNi/UMuM7hjy1VzOX36nEfQmtp/qsPS6MdzsFDld1aBB+8CUxaTXjZNdJ
FHDODNiTZiRqudzytfR6dj70HInTStStsGWctE3k0XJcXm0pfrJp/E5jy+dtEtxz
GED67B8l0bCA5MjCGvSofR1g5DQ7lqZBlUcoD0NdmYM5roi6XRO5DsMTEfuVxMqN
tgjKnD/VmfYBHj7Gz9Zjgr803wamzjsacP/dXOLo6mNafuzlLpM=
=v3Ii
-----END PGP SIGNATURE-----

--nextPart5940952.lOV4Wx5bFT--




