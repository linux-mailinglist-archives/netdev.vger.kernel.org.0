Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BFE3D7F80
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhG0Ut7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhG0Ut6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:49:58 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364A7C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:49:57 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C5A78806B6;
        Wed, 28 Jul 2021 08:49:53 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1627418993;
        bh=0k8KzzaYoFIF7lHReVwIRNgaUtivHiU9nnWoYTIR+IY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=F+74VlHuMo4UdzHkjON6IcqnvBm5r7DIqHGFavyvZk9xN44H39J0gp1Xc0EWUGj+Q
         X79y+mWfNIlTwoJ0FU9Mx1wk/ngYLFJUJ45XukPslj7Q+COo1lJ1ivM/stlR9sfZlY
         44+PnwdMLELddmEYozZWJ1neuCwf565axZmC8kL7HyvchcP52Yxj6qZ957wbq9lJis
         6h1S5xhlFH2bHqLrSDs0d5Ba6oB5neOKhaOyU7qT7w+Ke7VPDyOR5NrLBhcbfobh39
         v+fhacadGzbv+3DwcXWa5KVRaPLtIlEOEnZNTkj0KyN9IwQq8B1S3P/vJMRQ9pYARV
         NYqUxZ5Am+2Tw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B610071710001>; Wed, 28 Jul 2021 08:49:53 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.23; Wed, 28 Jul 2021 08:49:53 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.023; Wed, 28 Jul 2021 08:49:53 +1200
From:   Richard Laing <Richard.Laing@alliedtelesis.co.nz>
To:     Loic Poulain <loic.poulain@linaro.org>
CC:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bus: mhi: pci-generic: configurable network interface MRU
Thread-Topic: [PATCH] bus: mhi: pci-generic: configurable network interface
 MRU
Thread-Index: AQHXePXNQwvlV1kNe0CXQRxG8ENZtqtJUccAgADBqICAC8MmAIAAwDkA
Date:   Tue, 27 Jul 2021 20:49:52 +0000
Message-ID: <a984248c-c9be-b8e0-b6bc-1cf2aabb09f5@alliedtelesis.co.nz>
References: <20210714211805.22350-1-richard.laing@alliedtelesis.co.nz>
 <CAMZdPi-1E5pieVwt_XFF-+PML-cX05nM=PdD0pApD_ym5k_uMQ@mail.gmail.com>
 <5165a859-1b00-e50e-985e-25044cf0e9ec@alliedtelesis.co.nz>
 <CAMZdPi8MZp5Vx_ZnjjQWptms9vj6bEMoV83pcv4wmgxbZz0wjQ@mail.gmail.com>
In-Reply-To: <CAMZdPi8MZp5Vx_ZnjjQWptms9vj6bEMoV83pcv4wmgxbZz0wjQ@mail.gmail.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.16.78]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D61BBE1B9CF5B541B2454CEB393DE04C@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=dvql9Go4 c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=8KpF8ikWtqQA:10 a=IkcTkHD0fZMA:10 a=e_q4qTt1xDgA:10 a=R6aZAQg3Yvr2Z4M2TdcA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMjcvMjEgOToyMSBQTSwgTG9pYyBQb3VsYWluIHdyb3RlOg0KPiBOb3RlIHRoYXQg
dGhlIGRlZmF1bHQgTVJVIHlvdSBkZWZpbmUgaXMgbm90IE1ISSBjb250cm9sbGVyIHNwZWNpZmlj
DQo+IGJ1dCBNSEkgY2hhbm5lbCBzcGVjaWZpYyAoSVAvTUJJTSBjaGFubmVsKSwgc28gaXQgc2hv
dWxkIG5vdCBiZSBhDQo+IHByb3BlcnR5IG9mIHRoZSBNSEkgY29udHJvbGxlci4gQUZBSUssIFRo
ZSBNSEkgc3BlY2lmaWNhdGlvbiBhbHJlYWR5DQo+IGRlZmluZXMgTVJVIGZvciB0aGUgdHJhbnNm
ZXJlZCBidWZmZXJzIHdoaWNoIGlzIDY1NTM1LiBJIHdvdWxkDQo+IHJlY29tbWVuZCB0byBtb3Zl
IHRoaXMgcHJvcCB0byB0aGUgY2hhbm5lbCBjb25maWcuDQoNClRoYXQgbWFrZXMgc2Vuc2UgdGhh
bmsgeW91LiBJIGFzc3VtZSB0aGUgVUwgYW5kIERMIGNoYW5uZWxzIGNvdWxkIGJlIA0KZXhwZWN0
ZWQgdG8gaGF2ZSB0aGUgc2FtZSBNUlU/DQoNClJlZ2FyZHMsDQpSaWNoYXJk
