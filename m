Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606642991C8
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 17:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784778AbgJZQEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 12:04:41 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:38984 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1772559AbgJZQD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 12:03:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8B6F12057B;
        Mon, 26 Oct 2020 17:03:23 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wD3u82nnCoWL; Mon, 26 Oct 2020 17:03:23 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0395320581;
        Mon, 26 Oct 2020 17:03:23 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 26 Oct 2020 17:03:22 +0100
Received: from [172.18.3.9] (172.18.3.9) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 26 Oct
 2020 17:03:22 +0100
From:   Christian Langrock <christian.langrock@secunet.com>
Subject: [RESEND: PATCH net] drivers: net: ixgbe: Fix *_ipsec_offload_ok():,
 Use ip_hdr family
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
Autocrypt: addr=christian.langrock@secunet.com; prefer-encrypt=mutual;
 keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tClZlcnNpb246IEdudVBHIHYy
 CgptUUVOQkZlZTdqa0JDQUNrZU1JdXpadS9LQkExcTNrS0dyN2Q5aWlaR0Y1SXBKbklFOWRN
 aUszdWF6N3VNMjZWClNUSlZwNmpkR3VTR0dHbWI4MU9TTEVjSUVJc1lLWHZqYmxBS1VYMUE3
 NHQzV01SY2t5M013SmJtTjZBa044UWwKUDQ1bURkZHRQUmYxRWxCMlMzMmk5T3JFa3Z3OHhj
 dkhZUHdiYUhlblhpYzQvOGZIV0VoK3Z0ZC81LzVURFRJVQovYWc5dFFmUGVhMTNpeFhOMFB1
 Y2NNdWJGZVVNcHdGQ2czMjQrWjE5aUd2ZkRXV1ptUVFHbEJqYzNRNnowaFhPCmIvZGVXTC8r
 bFBTNHQrdFRncG1tWk80WGtJcysxOEtxeENWdWtDYm5xVjB5KzA0c2ozRzFHUS9EbEd2Wkh4
 d3kKd0JjZUFMN0J2bWRlWFFLQVMwS1JMNXpyZ2hJQkNnblV5dXREQUJFQkFBRzBNME5vY21s
 emRHbGhiaUJNWVc1bgpjbTlqYXlBOFkyaHlhWE4wYVdGdUxteGhibWR5YjJOclFITmxZM1Z1
 WlhRdVkyOXRQb2tCTndRVEFRZ0FJUVVDClY1N3VPUUliQXdVTENRZ0hBZ1lWQ0FrS0N3SUVG
 Z0lEQVFJZUFRSVhnQUFLQ1JDamVNZGZndXRyWHUza0NBQ0kKQng2VUhSZUJ0QmNpTlVQa1Az
 ZlJhR2VTT0FESXJxbDcyVktEOWZhTEFIVHQ2dzhrdnl6YjhDdHBhNzdqc3dKdAoyMWMzNDlt
 RjNtYVBscE50cHN3cUgyN2JUbFhZaE5jWHhjbUhQQ2JOdE4zeUdVeTBVdUlKZkJNWmM4UExx
 aXFZCm9ZNUdLRDN1aW1lVmJEWWpnTmhlYk8yZjFjVXZ3WTJ3VHdYNmIwdGdLVksweFlZVERw
 WEkxLzJNVkdzalhxYWsKN1BRb3FWcTBzRHUwZ0lBQWkxUU8wRmJiNmpJYUhqNkNFTTJocEJU
 Qms4cWJrUHMvTXFZR2RMbDRvWHZrV1RMZAp1UWptNmRNdGp4dkl0NldKV1pRYkxqVGVRSWZj
 MjFsdU5RS0RtZlQ2MjNwVlRQUE1NQWNpV2ZwZHc2M0ZibGZHCmNmQm5BS0NKOEpCajB6OVQ2
 L1BtdVFFTkJGZWU3amtCQ0FEUzdhbUpQYlkyZFdwZUd0RStJOXlMTDUzbFNyaVAKNEw2ckk5
 VW9Fd05NMU9ram5CN3dGbkg4ZG04TjY4SzJPSm9na0h3b1gyT256R2h4SjI4TkhSdUFoKysz
 aElZWQorZ1U0SE1MYVgzb25ESzFvcUFkWWN6aEo3ZjZVQ1BiWWFnaGt6SjZWZy9GRVdwQTh1
 NXZHL0JYNHkrRjMvWTk4Cmw2bXpBWDV3TG1UYXBSd2RmdVJDWFJBNmpsSUhJT3dQM05QS0s0
 UHoyRTd3aXRzaW1WMXVjTjR1WEZpWjM2Q1UKUEFpWFhsRVI5aVBablFVU3lDb2JxSk9KS200
 Qzd3VU5RMW5lZ0NYREJkM0tqU3l6VElhZncvb1lHNFJyV0d1bAppSTJpZy9xVFVDOGNaZEFK
 VE1CalVKUjZ1Z0phek1CMVJnMTdwMkdSRDBBelVPVjJxZHFZRnFRRkFCRUJBQUdKCkFSOEVH
 QUVJQUFrRkFsZWU3amtDR3d3QUNna1FvM2pIWDRMcmExN3Z0UWdBZzJnMEpFWFZUR1QzNkJE
 SmdWakkKVVkxZXZubTFmV3dUUHBjb2tQLzgvYU8ydWJtbHh0V1EyaFY1T1BmTDVuRGRheTJT
 NE5xNWoza3FRcStydlVyTwpSVm12VDRXeFlaTTFmcjJuaWJ1emFVYnNKdHhwaE5wamFocnNF
 Y0xMVHpCVzRDYkhUYUw0WVRUK1pEL0dEZUhvCnhBaDlKZk1rZE1CWEh5V1R1dytRU1AwcHA3
 V3ZOc0Rvc3VrS0Z5UTBydmU5UEgyZHJ5NkEwb0xQN1V4dEF6RUUKUlYyU2UwQnVlWlBRdVZu
 VTZDdmozWlN0SzI4SkRoTWp4SVBrWlBFNWtDVjhRTkY4T3Npd3ltQTNhb1BLZTVCdwowbE9j
 anV1Smt4UmE1YmF6eXV1Ylg5cElJZ1RlR3NlY2dwU2dwZkE5anNFSEtGcW9MdXhVQSs3N1ZR
 NWhTeWRWCmFRPT0KPU82RWEKLS0tLS1FTkQgUEdQIFBVQkxJQyBLRVkgQkxPQ0stLS0tLQo=
Message-ID: <5bbccb85-9d71-1f99-e668-27893c4e9945@secunet.com>
Date:   Mon, 26 Oct 2020 17:03:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="0c6k6SpwCjJIkBhWziZCawQ4nzfu6cL8C"
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0c6k6SpwCjJIkBhWziZCawQ4nzfu6cL8C
Content-Type: multipart/mixed; boundary="IBaK3eMGPQbaxt4qyeAO2ll9zGcgvmfKm";
 protected-headers="v1"
From: Christian Langrock <christian.langrock@secunet.com>
To: davem@davemloft.net, netdev@vger.kernel.org, jesse.brandeburg@intel.com,
 anthony.l.nguyen@intel.com
Message-ID: <5bbccb85-9d71-1f99-e668-27893c4e9945@secunet.com>
Subject: [RESEND: PATCH net] drivers: net: ixgbe: Fix *_ipsec_offload_ok():,
 Use ip_hdr family

--IBaK3eMGPQbaxt4qyeAO2ll9zGcgvmfKm
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Content-Language: de-DE

WGZybV9kZXZfb2ZmbG9hZF9vaygpIGlzIGNhbGxlZCB3aXRoIHRoZSB1bmVuY3J5cHRlZCBT
S0IuIFNvIGluIGNhc2Ugb2YKaW50ZXJmYW1pbHkgaXBzZWMgdHJhZmZpYyAoSVB2NC1pbi1J
UHY2IGFuZCBJUHY2IGluIElQdjQpIHRoZSBjaGVjawphc3N1bWVzIHRoZSB3cm9uZyBmYW1p
bHkgb2YgdGhlIHNrYiAoSVAgZmFtaWx5IG9mIHRoZSBzdGF0ZSkuCldpdGggdGhpcyBwYXRj
aCB0aGUgaXAgaGVhZGVyIG9mIHRoZSBTS0IgaXMgdXNlZCB0byBkZXRlcm1pbmUgdGhlCmZh
bWlseS4KCkZpeGVzIElQIGZhbWlseSBoYW5kbGluZyBmb3Igb2ZmbG9hZGluZyBpbnRlciBm
YW1pbHkgcGFja2V0cy4KClNpZ25lZC1vZmYtYnk6IENocmlzdGlhbiBMYW5ncm9jayA8Y2hy
aXN0aWFuLmxhbmdyb2NrQHNlY3VuZXQuY29tPgotLS0KwqBkcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9peGdiZS9peGdiZV9pcHNlYy5jIHwgMiArLQrCoGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2l4Z2JldmYvaXBzZWMuY8KgwqDCoMKgIHwgMiArLQrCoDIgZmlsZXMgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX2lwc2VjLmMKYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV9pcHNlYy5jCmluZGV4IGVjYTczNTI2
YWM4Ni4uMzYwMWRkMjkzNDYzIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9peGdiZS9peGdiZV9pcHNlYy5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2l4Z2JlL2l4Z2JlX2lwc2VjLmMKQEAgLTgxMyw3ICs4MTMsNyBAQCBzdGF0aWMgdm9p
ZCBpeGdiZV9pcHNlY19kZWxfc2Eoc3RydWN0IHhmcm1fc3RhdGUgKnhzKQrCoCAqKi8KwqBz
dGF0aWMgYm9vbCBpeGdiZV9pcHNlY19vZmZsb2FkX29rKHN0cnVjdCBza19idWZmICpza2Is
IHN0cnVjdAp4ZnJtX3N0YXRlICp4cykKwqB7Ci3CoMKgwqDCoMKgwqAgaWYgKHhzLT5wcm9w
cy5mYW1pbHkgPT0gQUZfSU5FVCkgeworwqDCoMKgwqDCoMKgIGlmIChpcF9oZHIoc2tiKS0+
dmVyc2lvbiA9PSA0KSB7CsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBPZmZs
b2FkIHdpdGggSVB2NCBvcHRpb25zIGlzIG5vdCBzdXBwb3J0ZWQgeWV0ICovCsKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoaXBfaGRyKHNrYiktPmlobCAhPSA1KQrCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBmYWxz
ZTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JldmYvaXBz
ZWMuYwpiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JldmYvaXBzZWMuYwppbmRl
eCA1MTcwZGQ5ZDg3MDUuLmIxZDcyZDVkMTc0NCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvaXhnYmV2Zi9pcHNlYy5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2l4Z2JldmYvaXBzZWMuYwpAQCAtNDE4LDcgKzQxOCw3IEBAIHN0YXRpYyB2
b2lkIGl4Z2JldmZfaXBzZWNfZGVsX3NhKHN0cnVjdCB4ZnJtX3N0YXRlICp4cykKwqAgKiov
CsKgc3RhdGljIGJvb2wgaXhnYmV2Zl9pcHNlY19vZmZsb2FkX29rKHN0cnVjdCBza19idWZm
ICpza2IsIHN0cnVjdAp4ZnJtX3N0YXRlICp4cykKwqB7Ci3CoMKgwqDCoMKgwqAgaWYgKHhz
LT5wcm9wcy5mYW1pbHkgPT0gQUZfSU5FVCkgeworwqDCoMKgwqDCoMKgIGlmIChpcF9oZHIo
c2tiKS0+dmVyc2lvbiA9PSA0KSB7CsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAv
KiBPZmZsb2FkIHdpdGggSVB2NCBvcHRpb25zIGlzIG5vdCBzdXBwb3J0ZWQgeWV0ICovCsKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoaXBfaGRyKHNrYiktPmlobCAhPSA1
KQrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVy
biBmYWxzZTsKLS0gCjIuMjkuMS4xLmcyZTY3MzM1NmFlCgotLSAKRGlwbC4tSW5mLihGSCkg
Q2hyaXN0aWFuIExhbmdyb2NrClNlbmlvciBDb25zdWx0YW50Ck5ldHdvcmsgJiBDbGllbnQg
U2VjdXJpdHkKRGl2aXNpb24gUHVibGljIEF1dGhvcml0aWVzCnNlY3VuZXQgU2VjdXJpdHkg
TmV0d29ya3MgQUcgCgpQaG9uZTogKzQ5IDIwMSA1NDU0LTM4MzMgRS1NYWlsOiBjaHJpc3Rp
YW4ubGFuZ3JvY2tAc2VjdW5ldC5jb20KCkFtbW9uc3RyYcOfZSA3NCAwMTA2NyBEcmVzZGVu
LCBHZXJtYW55Cnd3dy5zZWN1bmV0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwoKUmVnaXN0ZXJl
ZCBhdDogS3VyZnVlcnN0ZW5zdHJhc3NlIDU4LCA0NTEzOCBFc3NlbiwgR2VybWFueSBBbXRz
Z2VyaWNodCBFc3NlbiBIUkIgMTM2MTUKTWFuYWdlbWVudCBCb2FyZDogRHIgUmFpbmVyIEJh
dW1nYXJ0IChDRU8pLCBUaG9tYXMgUGxlaW5lcyBDaGFpcm1hbiBvZiBTdXBlcnZpc29yeSBC
b2FyZDogUmFsZiBXaW50ZXJnZXJzdApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCgo=

--IBaK3eMGPQbaxt4qyeAO2ll9zGcgvmfKm--

--0c6k6SpwCjJIkBhWziZCawQ4nzfu6cL8C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJflvNEAAoJEKN4x1+C62te35UH/iA1H7U2LCSrm+GoYHnScf7e
+mdyVbSMF2m5XD43p0TCuKhn/I9sxiF5p1RQyIDaQLJEToQDvW6t9b2rwZNHCK+i
ffnYLSheyHyL/uvvHLiqWbo/NOmS+85rzaA8gdESk+kpbq2p6uIzIh85T4T/rqtb
/9QgttEA34CATPhKhq5vwtCe1sDE71z2iptbazQLfjTAw1JJDhkxp/8p157LIaov
m+PitmkSvdRxMQsSyJGsZNN0YmvbL4EUM4cNHPDd6RJ1QShMOeDjgRnwu9kqgQjC
spTMGQcH7tIYbyg47bl0MJFnBs4BQmh6NaU+jYnDeSG0AVrOiacDd05mvirheUs=
=niPq
-----END PGP SIGNATURE-----

--0c6k6SpwCjJIkBhWziZCawQ4nzfu6cL8C--
