Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D802517C29
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 05:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiECDNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 23:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiECDNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 23:13:39 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910833917C
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 20:10:07 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 814A62C06D3
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 03:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1651547403;
        bh=0cb3BLrhsnWTwIDSacX9zQHfpHi8rW/nlj64Clo5eyQ=;
        h=From:To:Subject:Date:From;
        b=fYQF8rrvF1pekE5LG0oWEzzdfiSQSQXMaJjep/DB91rNFHfeUvaxJP6du7uMtodu0
         yhFSReCbLQJ+7V3dw7kcoUNtqdGieYjgMhyjkbLlMNG6in85la+S4A+NPjU8ZTT7ou
         gA97LfrA7mahG/pMwtxOMvCSmhtEvNZo27YhS63CXUYRYC4kRcDqMUz50ogv50GN7c
         pjHfrHkbUje69Tk+i5T1LphUoDw3rvFtdFywQ7QuqSQesQXJAdLb+f7E1VFp5yyLo3
         Xw3VZkEVgHy/Mmhp1UyutX4+KiCMphOjRStQ8y7YgSnU9zljA2sNnwAicsEzQwApYs
         hs9Y3kUgJjPBA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B62709d0b0000>; Tue, 03 May 2022 15:10:03 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Tue, 3 May 2022 15:10:03 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.033; Tue, 3 May 2022 15:10:03 +1200
From:   Lokesh Dhoundiyal <Lokesh.Dhoundiyal@alliedtelesis.co.nz>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Regarding _skb_refdst memory alloc/dealloc
Thread-Topic: Regarding _skb_refdst memory alloc/dealloc
Thread-Index: AQHYXptHGnZS9egJZ0yWppkefboFgg==
Date:   Tue, 3 May 2022 03:10:02 +0000
Message-ID: <53f2dbc3-3562-6d91-978e-63392010a668@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.16.78]
Content-Type: text/plain; charset="utf-8"
Content-ID: <43D0DC7B889EEB42B09374DB64634D86@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7GXNjH+ c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=8KpF8ikWtqQA:10 a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=hyhw3lZuv5VSnDFWxCcA:9 a=QEXdDO2ut3YA:10
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkkgaGF2ZSB0aGUgdHVubmVsIGRlc3RpbmF0aW9uIGVudHJ5IHNldCB2aWEgc2tiX2Rz
dF9zZXQgaW5zaWRlIA0KaXBfdHVubmVsX3Jjdi4gSSB3aXNoIHRvIHJlbGVhc2UgdGhlIG1lbW9y
eSByZWZlcmVuY2VkIGJ5IA0Kc2tiLT5fc2tiX3JlZmRzdCBhZnRlciB1c2UuDQoNCkNvdWxkIHlv
dSBwbGVhc2UgYWR2aXNlIHRoZSBhcGkgdG8gdXNlIGZvciBpdC4gSSBhbSBhc3N1bWluZyB0aGF0
IGl0IGlzIA0Kc2tiX2RzdF9kcm9wLCBJcyB0aGF0IGNvcnJlY3Q/DQoNCkNoZWVycywNCkxva2Vz
aA0K
