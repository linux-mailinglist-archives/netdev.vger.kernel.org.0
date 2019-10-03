Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBF6CAF4F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732153AbfJCTfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:35:51 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45413 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730889AbfJCTfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:35:50 -0400
Received: by mail-io1-f68.google.com with SMTP id c25so8216743iot.12;
        Thu, 03 Oct 2019 12:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=7PjgaJTN1sZ+1Rag9bin7ID05m1O1nNosxJ2QmV8OmY=;
        b=Nx9ZkTa/bTcjuSGNa5OH3LPCefGxRN+oz4XyiWrSpF9W4BHPnESTncHCm0x3Nge94o
         FY5KQD4hGU3j36lsPmvYVGeSiDtcTgtJ3ZU+54Hj95V2yjEZ8F07HrFzf7CIdk6d4kBn
         8Te328opPfXXCz6jm3+rLI4hxokInu9vUX/GioLPs7yg9FOXZNwdEW8V8BJCE6A08z0/
         DC2y07Yf+syNfImzse2WjJhPAzlQEHOq11TKq7X4EPGoI9hCbmD6+Ok+7piRoOXT8UlF
         8E0BF5Sl6rHT3Qqm+kulefrMe8MxhtfFFJSdoxQQpz+9GIhw8beKgeQFen8gAzYkCuse
         F1FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=7PjgaJTN1sZ+1Rag9bin7ID05m1O1nNosxJ2QmV8OmY=;
        b=CRjIKokIXNYXDmIOWRiHv6xztqnrqwgA6ZevYRk5VDclXqLlfrayEObbrFycDBdI++
         1nllQhKTY3Hv0MoVZv8pvaVQVmME0WDy++8gkGN4k+BjG7ETJzTgJIiLnF/Z8WxehxZH
         KVRPaH5ifbxYU9zrEq4RoiNXnTt0rllstZdu6TQwKJReIb4S3PKSByD7JtdTeJkehmuF
         W5HXSlpnuMXMrnYCmoI5MKc98WI+gvXwSnkqxPDmx6B4JtuXm+H9WmvUPS9W6FWxlDKt
         Wx8iEMX51pU7zh+fO18Z0gvgwubVv/0ObsAFBMgZdke7juaAltfZRNpYKH4B7JJ2dgV6
         33Ew==
X-Gm-Message-State: APjAAAXXoPDIsgbRVLPjA60zq7L3xEmhhAu6Qd9rVTUM2zQLSpXl7Jme
        IWlkj5FtGwfuspsROt/+m/o=
X-Google-Smtp-Source: APXvYqzY5pdJAu2Cl/ng4h9ZeNwr4+8oA7SIqgowIImFtj6koi+30Lw8FQZLHyOGKkujgipvrQ6BXA==
X-Received: by 2002:a5d:8b12:: with SMTP id k18mr5593527ion.93.1570131349076;
        Thu, 03 Oct 2019 12:35:49 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a24sm1193794iok.37.2019.10.03.12.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 12:35:48 -0700 (PDT)
Date:   Thu, 03 Oct 2019 12:35:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Message-ID: <5d964d8ccfd90_55732aec43fe05c47b@john-XPS-13-9370.notmuch>
In-Reply-To: <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com>
 <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com>
 <87r23vq79z.fsf@toke.dk>
 <20191003105335.3cc65226@carbon>
 <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
 <87pnjdq4pi.fsf@toke.dk>
 <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RWR3YXJkIENyZWUgd3JvdGU6Cj4gT24gMDMvMTAvMjAxOSAxNTozMywgVG9r
ZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIHdyb3RlOgo+ID4gSW4gYWxsIGNhc2Vz
LCB0aGUgc3lzYWRtaW4gY2FuJ3QgKG9yIGRvZXNuJ3Qgd2FudCB0bykgbW9k
aWZ5IGFueSBvZiB0aGUKPiA+IFhEUCBwcm9ncmFtcy4gSW4gZmFjdCwgdGhl
eSBtYXkganVzdCBiZSBpbnN0YWxsZWQgYXMgcHJlLWNvbXBpbGVkIC5zbwo+
ID4gQlBGIGZpbGVzIG9uIGhpcyBzeXN0ZW0uIFNvIGhlIG5lZWRzIHRvIGJl
IGFibGUgdG8gY29uZmlndXJlIHRoZSBjYWxsCj4gPiBjaGFpbiBvZiBkaWZm
ZXJlbnQgcHJvZ3JhbXMgd2l0aG91dCBtb2RpZnlpbmcgdGhlIGVCUEYgcHJv
Z3JhbSBzb3VyY2UKPiA+IGNvZGUuCj4gUGVyaGFwcyBJJ20gYmVpbmcgZHVt
YiwgYnV0IGNhbid0IHdlIHNvbHZlIHRoaXMgaWYgd2UgbWFrZSBsaW5raW5n
IHdvcms/Cj4gSS5lLiBteUlEUy5zbyBoYXMgaWRzX21haW4oKSBmdW5jdGlv
biwgbXlGaXJld2FsbC5zbyBoYXMgZmlyZXdhbGwoKQo+IMKgZnVuY3Rpb24s
IGFuZCBzeXNhZG1pbiB3cml0ZXMgYSBsaXR0bGUgWERQIHByb2cgdG8gY2Fs
bCB0aGVzZToKPiAKPiBpbnQgbWFpbihzdHJ1Y3QgeGRwX21kICpjdHgpCj4g
ewo+IMKgwqDCoMKgwqDCoMKgIGludCByYyA9IGZpcmV3YWxsKGN0eCksIHJj
MjsKPiAKPiDCoMKgwqDCoMKgwqDCoCBzd2l0Y2gocmMpIHsKPiDCoMKgwqDC
oMKgwqDCoCBjYXNlIFhEUF9EUk9QOgo+IMKgwqDCoMKgwqDCoMKgIGNhc2Ug
WERQX0FCT1JURUQ6Cj4gwqDCoMKgwqDCoMKgwqAgZGVmYXVsdDoKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJjOwo+IMKgwqDC
oMKgwqDCoMKgIGNhc2UgWERQX1BBU1M6Cj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJldHVybiBpZHNfbWFpbihjdHgpOwo+IMKgwqDCoMKg
wqDCoMKgIGNhc2UgWERQX1RYOgo+IMKgwqDCoMKgwqDCoMKgIGNhc2UgWERQ
X1JFRElSRUNUOgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
YzIgPSBpZHNfbWFpbihjdHgpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAocmMyID09IFhEUF9QQVNTKQo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJjOwo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmMyOwo+
IMKgwqDCoMKgwqDCoMKgIH0KPiB9Cj4gCj4gTm93IGhlIGNvbXBpbGVzIHRo
aXMgYW5kIGxpbmtzIGl0IGFnYWluc3QgdGhvc2UgLnNvIGZpbGVzLCBnaXZp
bmcgaGltCj4gwqBhIG5ldyBvYmplY3QgZmlsZSB3aGljaCBoZSBjYW4gdGhl
biBpbnN0YWxsLgo+IAo+IChPbmUgcHJvYmxlbSB3aGljaCBkb2VzIHNwcmlu
ZyB0byBtaW5kIGlzIHRoYXQgdGhlIC5zbyBmaWxlcyBtYXkgdmVyeQo+IMKg
aW5jb25zaWRlcmF0ZWx5IGJvdGggbmFtZSB0aGVpciBlbnRyeSBwb2ludHMg
bWFpbigpLCB3aGljaCBtYWtlcwo+IMKgbGlua2luZyBhZ2FpbnN0IGJvdGgg
b2YgdGhlbSByYXRoZXIgY2hhbGxlbmdpbmcuwqAgQnV0IEkgdGhpbmsgdGhh
dAo+IMKgY2FuIGJlIHdvcmtlZCBhcm91bmQgd2l0aCBhIHN1ZmZpY2llbnRs
eSBjbGV2ZXIgbGlua2VyKS4KCkkgYWdyZWUgYnV0IHRoZSBzYW1lIGNvdWxk
IGJlIGRvbmUgdG9kYXkgaWYgaWRzX21haW4gYW5kIGZpcmV3YWxsCndlcmUg
aW5saW5lIGZ1bmN0aW9ucy4gQWRtaW4gY2FuIHdyaXRlIHRoZWlyIGxpdHRs
ZSBwcm9ncmFtIGxpa2UgYWJvdmUKYW5kIGp1c3QgJyNpbmNsdWRlIGZpcmV3
YWxsJywgJyNpbmNsdWRlIGlkcycuIFRoZW4geW91IGRvbid0IG5lZWQKbGlu
a2luZyBhbHRob3VnaCBpdCBkb2VzIG1ha2UgdGhpbmdzIG5pY2VyLgoKPiAK
PiAtRWQKCgo=
