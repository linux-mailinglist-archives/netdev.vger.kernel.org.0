Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5F35F6CBA
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJFRWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJFRWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:22:30 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C091ACA2A
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 10:22:29 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id h1-20020a62b401000000b0056161cd284fso1450247pfn.16
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 10:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9RggNsVVi3cyrSbmg5yhAvnMYTKt2Ro8KNpkYruYnb0=;
        b=B0aSWe192koGou04BL6g1GI/na/w+bvOrNGS2+vvT8134tsrV3u6TQdO3rA1fITpDX
         PXrPpMzaIwgRnQ7BiQ2eR3qFdpA2jux8xad8PVBb6wZpEVcHZZrgw/+V/auDMU+Gkf2b
         vdH9q10KdnnW6WEc18tsRkVUVT4T4+6+kEjGea3lzyZAu3tOSPCLNreMgmbbMJBaaPqX
         iuR/K1x2FGGxoY4rMgu0yz6omXMZ6E2byY86pmWnzr/M+sg+5J6nx4Px8NB9OQwp/bC8
         uaPX/MR8o29SqoOkKMVOHeVbnhO96y9dKzATLQrsZ1lK1AUt83WTjoxr+J60BbAK4/wj
         iv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9RggNsVVi3cyrSbmg5yhAvnMYTKt2Ro8KNpkYruYnb0=;
        b=yumqmON8p5hUM2VBpnj+FqIIQ+XegDcF8C7JgJmjOVlXulc+eWQkCzXif0Sjc8nfCy
         wc3FdIQpgFR9p0Ec3e8kp2OCQ38hz5C2kGBKRsqS++VqFGyEkpN5kPNJvUAKhz44pwfB
         svaRP9J+evEg39Vh3YZaVuasYrDAbe8MT19KWwE9ge4XTNIeSi6vQ6bouQc3fya0VJTx
         Yjc/d+rmQC+oH/Ed7z3I567ld/TH2Ys9y08nJG6PcYiI3892ByPT/i842VqH13ybLF0H
         AxtWEHWGZDGWOEs7VKSZxTQTByG4nk7czVutR1tGCDNYSUx8pk3B7nLrkO+Jc83R7/6F
         i1IQ==
X-Gm-Message-State: ACrzQf0AIr2Th2MgcmBfTFBxRMgDmwq+pRnWM0TQcIYtBuoFvarX7cbi
        6nS38GN/1VRAlVhD3r2rQhxR0FU=
X-Google-Smtp-Source: AMsMyM5rriQaWAkk6+qQ5tCTTbOWxBtlRsIiQmEqt8ZG4qWak7HUNOLwVku/3oxeShbb+eR13QLSLVU=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:4a51:b0:20b:d92:516e with SMTP id
 lb17-20020a17090b4a5100b0020b0d92516emr754008pjb.86.1665076948641; Thu, 06
 Oct 2022 10:22:28 -0700 (PDT)
Date:   Thu, 6 Oct 2022 10:22:26 -0700
In-Reply-To: <be3f16a2-8422-4a34-3eb9-3943753d453e@redhat.com>
Mime-Version: 1.0
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com> <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev> <20221004175952.6e4aade7@kernel.org>
 <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
 <87h70iinzc.fsf@toke.dk> <Yz3RQbh2TocpnuX0@google.com> <be3f16a2-8422-4a34-3eb9-3943753d453e@redhat.com>
Message-ID: <Yz8O0rn7ps/m8iGi@google.com>
Subject: Re: [xdp-hints] Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP
 gaining access to HW offload hints via BTF
From:   sdf@google.com
To:     Maryam Tahhan <mtahhan@redhat.com>
Cc:     "Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?=" <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMDYsIE1hcnlhbSBUYWhoYW4gd3JvdGU6DQo+IE9uIDA1LzEwLzIwMjIgMTk6NDcsIHNk
ZkBnb29nbGUuY29tIHdyb3RlOg0KPiA+IE9uIDEwLzA1LCBUb2tlIEjvv71pbGFuZC1K77+9cmdl
bnNlbiB3cm90ZToNCj4gPiA+IFN0YW5pc2xhdiBGb21pY2hldiA8c2RmQGdvb2dsZS5jb20+IHdy
aXRlczoNCj4gPg0KPiA+ID4gPiBPbiBUdWUsIE9jdCA0LCAyMDIyIGF0IDU6NTkgUE0gSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4gIA0KPiB3cm90ZToNCj4gPiA+ID4+DQo+ID4gPiA+
PiBPbiBUdWUsIDQgT2N0IDIwMjIgMTc6MjU6NTEgLTA3MDAgTWFydGluIEthRmFpIExhdSB3cm90
ZToNCj4gPiA+ID4+ID4gQSBpbnRlbnRpb25hbGx5IHdpbGQgcXVlc3Rpb24sIHdoYXQgZG9lcyBp
dCB0YWtlIGZvciB0aGUgZHJpdmVyDQo+ID4gPiB0byByZXR1cm4gdGhlDQo+ID4gPiA+PiA+IGhp
bnRzLsKgIElzIHRoZSByeF9kZXNjIGFuZCByeF9xdWV1ZSBlbm91Z2g/wqAgV2hlbiB0aGUgeGRw
IHByb2cNCj4gPiA+IGlzIGNhbGxpbmcgYQ0KPiA+ID4gPj4gPiBrZnVuYy9icGYtaGVscGVyLCBs
aWtlICdod3RzdGFtcCA9IGJwZl94ZHBfZ2V0X2h3dHN0YW1wKCknLCBjYW4NCj4gPiA+IHRoZSBk
cml2ZXINCj4gPiA+ID4+ID4gcmVwbGFjZSBpdCB3aXRoIHNvbWUgaW5saW5lIGJwZiBjb2RlIChs
aWtlIGhvdyB0aGUgaW5saW5lIGNvZGUNCj4gPiA+IGlzIGdlbmVyYXRlZCBmb3INCj4gPiA+ID4+
ID4gdGhlIG1hcF9sb29rdXAgaGVscGVyKS7CoCBUaGUgeGRwIHByb2cgY2FuIHRoZW4gc3RvcmUg
dGhlDQo+ID4gPiBod3N0YW1wIGluIHRoZSBtZXRhDQo+ID4gPiA+PiA+IGFyZWEgaW4gYW55IGxh
eW91dCBpdCB3YW50cy4NCj4gPiA+ID4+DQo+ID4gPiA+PiBTaW5jZSB5b3UgbWVudGlvbmVkIGl0
Li4uIEZXSVcgdGhhdCB3YXMgYWx3YXlzIG15IHByZWZlcmVuY2UNCj4gPiA+IHJhdGhlciB0aGFu
DQo+ID4gPiA+PiB0aGUgQlRGIG1hZ2ljIDopwqAgVGhlIGppdGVkIGltYWdlIHdvdWxkIGhhdmUg
dG8gYmUgcGVyLWRyaXZlciBsaWtlICANCj4gd2UNCj4gPiA+ID4+IGRvIGZvciBCUEYgb2ZmbG9h
ZCBidXQgdGhhdCdzIGVhc3kgdG8gZG8gZnJvbSB0aGUgdGVjaG5pY2FsDQo+ID4gPiA+PiBwZXJz
cGVjdGl2ZSAoSSBkb3VidCBtYW55IGRlcGxveW1lbnRzIGJpbmQgdGhlIHNhbWUgcHJvZyB0byAg
DQo+IG11bHRpcGxlDQo+ID4gPiA+PiBIVyBkZXZpY2VzKS4uDQo+ID4gPiA+DQo+ID4gPiA+ICsx
LCBzb3VuZHMgbGlrZSBhIGdvb2QgYWx0ZXJuYXRpdmUgKGdvdCB5b3VyIHJlcGx5IHdoaWxlIHR5
cGluZykNCj4gPiA+ID4gSSdtIG5vdCB0b28gdmVyc2VkIGluIHRoZSByeF9kZXNjL3J4X3F1ZXVl
IGFyZWEsIGJ1dCBzZWVtcyBsaWtlICANCj4gd29yc3QNCj4gPiA+ID4gY2FzZSB0aGF0IGJwZl94
ZHBfZ2V0X2h3dHN0YW1wIGNhbiBwcm9iYWJseSByZWNlaXZlIGEgeGRwX21kIGN0eCBhbmQNCj4g
PiA+ID4gcGFyc2UgaXQgb3V0IGZyb20gdGhlIHByZS1wb3B1bGF0ZWQgbWV0YWRhdGE/DQo+ID4g
PiA+DQo+ID4gPiA+IEJ0dywgZG8gd2UgYWxzbyBuZWVkIHRvIHRoaW5rIGFib3V0IHRoZSByZWRp
cmVjdCBjYXNlPyBXaGF0IGhhcHBlbnMNCj4gPiA+ID4gd2hlbiBJIHJlZGlyZWN0IG9uZSBmcmFt
ZSBmcm9tIGEgZGV2aWNlIEEgd2l0aCBvbmUgbWV0YWRhdGEgZm9ybWF0ICANCj4gdG8NCj4gPiA+
ID4gYSBkZXZpY2UgQiB3aXRoIGFub3RoZXI/DQo+ID4NCj4gPiA+IFllcywgd2UgYWJzb2x1dGVs
eSBkbyEgSW4gZmFjdCwgdG8gbWUgdGhpcyAocmVkaXJlY3RzKSBpcyB0aGUgbWFpbg0KPiA+ID4g
cmVhc29uIHdoeSB3ZSBuZWVkIHRoZSBJRCBpbiB0aGUgcGFja2V0IGluIHRoZSBmaXJzdCBwbGFj
ZTogd2hlbiAgDQo+IHJ1bm5pbmcNCj4gPiA+IG9uIChzYXkpIGEgdmV0aCwgYW4gWERQIHByb2dy
YW0gbmVlZHMgdG8gYmUgYWJsZSB0byBkZWFsIHdpdGggcGFja2V0cw0KPiA+ID4gZnJvbSBtdWx0
aXBsZSBwaHlzaWNhbCBOSUNzLg0KPiA+DQo+ID4gPiBBcyBmYXIgYXMgQVBJIGlzIGNvbmNlcm5l
ZCwgbXkgaG9wZSB3YXMgdGhhdCB3ZSBjb3VsZCBzb2x2ZSB0aGlzIHdpdGggIA0KPiBhDQo+ID4g
PiBDTy1SRSBsaWtlIGFwcHJvYWNoIHdoZXJlIHRoZSBwcm9ncmFtIGF1dGhvciBqdXN0IHdyaXRl
cyBzb21ldGhpbmcgIA0KPiBsaWtlOg0KPiA+DQo+ID4gPiBod190c3RhbXAgPSBicGZfZ2V0X3hk
cF9oaW50KCJod190c3RhbXAiLCB1NjQpOw0KPiA+DQo+ID4gPiBhbmQgYnBmX2dldF94ZHBfaGlu
dCgpIGlzIHJlYWxseSBhIG1hY3JvIChvciBhIHNwZWNpYWwga2luZCBvZg0KPiA+ID4gcmVsb2Nh
dGlvbj8pIGFuZCBsaWJicGYgd291bGQgZG8gdGhlIGZvbGxvd2luZyBvbiBsb2FkOg0KPiA+DQo+
ID4gPiAtIHF1ZXJ5IHRoZSBrZXJuZWwgQlRGIGZvciBhbGwgcG9zc2libGUgeGRwX2hpbnQgc3Ry
dWN0cw0KPiA+ID4gLSBmaWd1cmUgb3V0IHdoaWNoIG9mIHRoZW0gaGF2ZSBhbiAndTY0IGh3X3Rz
dGFtcCcgbWVtYmVyDQo+ID4gPiAtIGdlbmVyYXRlIHRoZSBuZWNlc3NhcnkgY29uZGl0aW9uYWxz
IC8ganVtcCB0YWJsZSB0byBkaXNhbWJpZ3VhdGUgb24NCj4gPiA+IMKgwqAgdGhlIEJURl9JRCBp
biB0aGUgcGFja2V0DQo+ID4NCj4gPg0KPiA+ID4gTm93LCBpZiB0aGlzIGlzIGJldHRlciBkb25l
IGJ5IGEga2Z1bmMgSSdtIG5vdCB0ZXJyaWJseSBvcHBvc2VkIHRvICANCj4gdGhhdA0KPiA+ID4g
ZWl0aGVyLCBidXQgSSdtIG5vdCBzdXJlIGl0J3MgYWN0dWFsbHkgYmV0dGVyL2Vhc2llciB0byBk
byBpbiB0aGUgIA0KPiBrZXJuZWwNCj4gPiA+IHRoYW4gaW4gbGliYnBmIGF0IGxvYWQgdGltZT8N
Cj4gPg0KPiA+IFJlcGxpZWQgaW4gdGhlIG90aGVyIHRocmVhZCwgYnV0IHRvIHJlaXRlcmF0ZSBo
ZXJlOiB0aGVuIGJ0Zl9pZCBpbiB0aGUNCj4gPiBtZXRhZGF0YSBoYXMgdG8gc3RheSBhbmQgd2Ug
ZWl0aGVyIHByZS1nZW5lcmF0ZSB0aG9zZSBicGZfZ2V0X3hkcF9oaW50KCkNCj4gPiBhdCBsaWJi
cGYgb3IgYXQga2Z1bmMgbG9hZCB0aW1lIGxldmVsIGFzIHlvdSBtZW50aW9uLg0KPiA+DQo+ID4g
QnV0IHRoZSBwcm9ncmFtIGVzc2VudGlhbGx5IGhhcyB0byBoYW5kbGUgYWxsIHBvc3NpYmxlIGhp
bnRzJyBidGYgaWRzDQo+ID4gdGhyb3duDQo+ID4gYXQgaXQgYnkgdGhlIHN5c3RlbS4gTm90IHN1
cmUgYWJvdXQgdGhlIHBlcmZvcm1hbmNlIGluIHRoaXMgY2FzZSA6LS8NCj4gPiBNYXliZSB0aGF0
J3Mgc29tZXRoaW5nIHRoYXQgY2FuIGJlIGhpZGRlbiBiZWhpbmQgIkkgbWlnaHQgcmVjZWl2ZSAg
DQo+IGZvcndhcmRlZA0KPiA+IHBhY2tldHMgYW5kIEkga25vdyBob3cgdG8gaGFuZGxlIGFsbCBt
ZXRhZGF0YSBmb3JtYXQiIGZsYWc/IEJ5IGRlZmF1bHQsDQo+ID4gd2UnbGwgcHJlLWdlbmVyYXRl
IHBhcnNpbmcgb25seSBmb3IgdGhhdCBzcGVjaWZpYyBkZXZpY2U/DQoNCj4gSSBkaWQgYSBzaW1w
bGUgUE9DIG9mIEplc3BlcnMgeGRwLWhpbnRzIHdpdGggQUYtWERQIGFuZCBDTkRQIChDbG91ZCBO
YXRpdmUNCj4gRGF0YSBQbGFuZSkuIEluIHRoZSBjYXNlcyB3aGVyZSBteSBhcHAgaGFkIGFjY2Vz
cyB0byB0aGUgSFcgSSBkaWRuJ3QgbmVlZCAgDQo+IHRvDQo+IGhhbmRsZSBhbGwgcG9zc2libGUg
aGludHMuLi4gSSBrbmV3IHdoYXQgRHJpdmVycyB3ZXJlIG9uIHRoZSBzeXN0ZW0gYW5kICANCj4g
dGhleQ0KPiB3ZXJlIHRoZSBoaW50cyBJIG5lZWRlZCB0byBkZWFsIHdpdGguDQoNCj4gU28gYXQg
cHJvZ3JhbSBpbml0IHRpbWUgSSByZWdpc3RlcmVkIHRoZSByZWxldmFudCBCVEZfSURzIChhbmQg
c29tZSAgDQo+IGNhbGxiYWNrDQo+IGZ1bmN0aW9ucyB0byBoYW5kbGUgdGhlbSkgZnJvbSB0aGUg
TklDcyB0aGF0IHdlcmUgYXZhaWxhYmxlIHRvIG1lIGluIGENCj4gc2ltcGxlIHRhaWxxICh0Ymgg
dGhlcmUgd2VyZSBzbyBmZXcgSSBjb3VsZCd2ZSBwcm9iYWJseSB1c2VkIGEgc3RhdGljDQo+IGFy
cmF5KS4NCg0KPiBXaGVuIHByb2Nlc3NpbmcgdGhlIGhpbnRzIHRoZW4gSSBvbmx5IG5lZWRlZCB0
byBpbnZva2UgdGhlIGFwcHJvcHJpYXRlDQo+IGNhbGxiYWNrIGZ1bmN0aW9uIGJhc2VkIG9uIHRo
ZSByZWNlaXZlZCBCVEZfSUQuIEkgZGlkbid0IGhhdmUgYSBtYXNzaXZlDQo+IGNoYWlucyBvZiBp
Zi4uLmVsc2UgaWYuLi4gZWxzZSBzdGF0ZW1lbnRzLg0KDQo+IEluIHRoZSBjYXNlIHdoZXJlIHdl
IGhhdmUgcmVkaXJlY3Rpb24gdG8gYSB2aXJ0dWFsIE5JQyBhbmQgd2UgZG9uJ3QNCj4gbmVjZXNz
YXJpbHkga25vdyB0aGUgdW5kZXJseWluZyBoaW50cyB0aGF0IGFyZSBleHBvc2VkIHRvIHRoZSBh
cHAsIGNvdWxkICANCj4gd2UNCj4gbm90IHN0aWxsIHVzZSB0aGUgeGRwX2hpbnRzIChhcyBwcm9w
b3NlZCBieSBKZXNwZXIpIHRoZW1zZWx2ZXMgdG8gaW5kaWNhdGUNCj4gdGhlIHJlbGV2YW50IGRy
aXZlcnMgdG8gdGhlIGFwcGxpY2F0aW9uPyBvciBldmVuIGluZGljYXRlIHRoZW0gdmlhIGEgbWFw
ICANCj4gb3INCj4gc29tZXRoaW5nPw0KDQoNCklkZWFsbHkgdGhpcyBhbGwgc2hvdWxkIGJlIGhh
bmRsZWQgYnkgdGhlIGNvbW1vbiBpbmZyYSAobGliYnBmL2xpYnhkcD8pLg0KV2UgcHJvYmFibHkg
ZG9uJ3Qgd2FudCBldmVyeSB4ZHAvYWZfeGRwIHVzZXIgdG8gY3VzdG9tLWltcGxlbWVudCBhbGwg
dGhpcw0KYnRmX2lkLT5sYXlvdXQgcGFyc2luZz8gVGhhdCdzIHdoeSB0aGUgcmVxdWVzdCBmb3Ig
YSBzZWxmdGVzdCB0aGF0IHNob3dzDQpob3cgbWV0YWRhdGEgY2FuIGJlIGFjY2Vzc2VkIGZyb20g
YnBmL2FmX3hkcC4NCg==
