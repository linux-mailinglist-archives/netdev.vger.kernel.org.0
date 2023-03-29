Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B6B6CF6CD
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 01:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjC2XTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 19:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjC2XTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 19:19:21 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331E71B8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 16:19:17 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id m12-20020a62f20c000000b0062612a76a08so7872234pfh.2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 16:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680131956;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gihxk+7No2scFLMLBpp+6wyoNPNP1GnRy6PfH0IiWEM=;
        b=Tr9XXbhuifWlXfUlhy27lp7/3dU3BTkeG87rqjP79pDAydC7BA/vng0N1y0arfOkXL
         NH2arXYY0PaMGLhSGBLOh/COvPilLQ0BDMxkMgAmWqJJsMRbB3jGCYmJHcAex8WjhIYC
         xgs43qaUYx0Frwsk+E2SetSLamNfnzLABUPW1YD1TvUTzhK+8EhBW/5Hbr6g3yToPb+f
         JHwQ2v7RGe0CcQuqvidLMbUux/0XvTIu5oS1ICrf8I9LBsSgaDvYYs1OeIddbDCM1oYE
         ekBP2ocRhXD/Za0wl8ps8NW+42jdMKg+IAjxowEqREPiokx6mUI/wPx8o9yrV2Y2aZhn
         1npg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680131956;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gihxk+7No2scFLMLBpp+6wyoNPNP1GnRy6PfH0IiWEM=;
        b=TE0H+DbxhdocIsjSqSMl4GBZLN3g7wyd/lhRtgYR8d4IC1/VbmwPx127CtgFyIStTx
         shOqWYgUYA9ucuRlGnvABLEuvGvBqZ0aEQf6vP5AovKH/swA22nEhFCyxyN5vgMa/H7P
         rkGtN+OvJjUE21usf+wNpCULa0ZEoPMYaFgu0LGsrNb4D1f4PKKkLNZ3TM/GvT/012M0
         KJUC1SH8TUz3QMBzkIpBoAb3Y2tPfGSReBtJG4bAs/PnGt6z4zalXP5VjQLCwD4G7iPs
         jUR96spdo4gKXVk4ClQCRKe2XolNJaD8P5rmHpjN5U9ihJ55S6knDiQ8ozNaQEfkIyXJ
         nCIQ==
X-Gm-Message-State: AAQBX9e8qyYxbafPjoC35PsiC03Tx3OnYyeujKN/Iq5QA7zBxqg0UBwO
        QiV6EUziqpQwQT76UmU0A5Dd9Cs=
X-Google-Smtp-Source: AKy350ZVTSK9qGKwnEiYmz1DKrOYDBf7pVA2Lq3qWisrqZK/uAWx9h3eARPGxDMmvPCESi7n/Ardgkw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:a09:b0:625:dc5b:9d1d with SMTP id
 p9-20020a056a000a0900b00625dc5b9d1dmr11263039pfh.0.1680131956699; Wed, 29 Mar
 2023 16:19:16 -0700 (PDT)
Date:   Wed, 29 Mar 2023 16:19:15 -0700
In-Reply-To: <b9e5077f-fbc4-8904-74a8-cda94d91cfbf@redhat.com>
Mime-Version: 1.0
References: <168003451121.3027256.13000250073816770554.stgit@firesoul>
 <168003455815.3027256.7575362149566382055.stgit@firesoul> <ZCNjHAY81gS02FVW@google.com>
 <811724e2-cdd6-15fe-b176-9dfcdbd98bad@redhat.com> <ZCRy2f170FQ+fXsp@google.com>
 <b9e5077f-fbc4-8904-74a8-cda94d91cfbf@redhat.com>
Message-ID: <ZCTHc6Dp4RMi1YZ6@google.com>
Subject: Re: [PATCH bpf RFC 1/4] xdp: rss hash types representation
From:   Stanislav Fomichev <sdf@google.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDMvMjksIEplc3BlciBEYW5nYWFyZCBCcm91ZXIgd3JvdGU6DQoNCj4gT24gMjkvMDMvMjAy
MyAxOS4xOCwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPiA+IE9uIDAzLzI5LCBKZXNwZXIg
RGFuZ2FhcmQgQnJvdWVyIHdyb3RlOg0KPiA+DQo+ID4gPiBPbiAyOC8wMy8yMDIzIDIzLjU4LCBT
dGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+ID4gPiA+IE9uIDAzLzI4LCBKZXNwZXIgRGFuZ2Fh
cmQgQnJvdWVyIHdyb3RlOg0KPiA+ID4gPiA+IFRoZSBSU1MgaGFzaCB0eXBlIHNwZWNpZmllcyB3
aGF0IHBvcnRpb24gb2YgcGFja2V0IGRhdGEgTklDICANCj4gaGFyZHdhcmUgdXNlZA0KPiA+ID4g
PiA+IHdoZW4gY2FsY3VsYXRpbmcgUlNTIGhhc2ggdmFsdWUuIFRoZSBSU1MgdHlwZXMgYXJlIGZv
Y3VzZWQgb24gIA0KPiBJbnRlcm5ldA0KPiA+ID4gPiA+IHRyYWZmaWMgcHJvdG9jb2xzIGF0IE9T
SSBsYXllcnMgTDMgYW5kIEw0LiBMMiAoZS5nLiBBUlApIG9mdGVuICANCj4gZ2V0IGhhc2gNCj4g
PiA+ID4gPiB2YWx1ZSB6ZXJvIGFuZCBubyBSU1MgdHlwZS4gRm9yIEwzIGZvY3VzZWQgb24gSVB2
NCB2cy4gSVB2NiwgYW5kICANCj4gTDQNCj4gPiA+ID4gPiBwcmltYXJpbHkgVENQIHZzIFVEUCwg
YnV0IHNvbWUgaGFyZHdhcmUgc3VwcG9ydHMgU0NUUC4NCj4gPiA+ID4NCj4gPiA+ID4gPiBIYXJk
d2FyZSBSU1MgdHlwZXMgYXJlIGRpZmZlcmVudGx5IGVuY29kZWQgZm9yIGVhY2ggaGFyZHdhcmUg
TklDLiAgDQo+IE1vc3QNCj4gPiA+ID4gPiBoYXJkd2FyZSByZXByZXNlbnQgUlNTIGhhc2ggdHlw
ZSBhcyBhIG51bWJlci4gRGV0ZXJtaW5pbmcgTDMgdnMgIA0KPiBMNCBvZnRlbg0KPiA+ID4gPiA+
IHJlcXVpcmVzIGEgbWFwcGluZyB0YWJsZSBhcyB0aGVyZSBvZnRlbiBpc24ndCBhIHBhdHRlcm4g
b3Igc29ydGluZw0KPiA+ID4gPiA+IGFjY29yZGluZyB0byBJU08gbGF5ZXIuDQo+ID4gPiA+DQo+
ID4gPiA+ID4gVGhlIHBhdGNoIGludHJvZHVjZSBhIFhEUCBSU1MgaGFzaCB0eXBlICh4ZHBfcnNz
X2hhc2hfdHlwZSkgdGhhdCAgDQo+IGNhbiBib3RoDQo+ID4gPiA+ID4gYmUgc2VlbiBhcyBhIG51
bWJlciB0aGF0IGlzIG9yZGVyZWQgYWNjb3JkaW5nIGJ5IElTTyBsYXllciwgYW5kICANCj4gY2Fu
IGJlIGJpdA0KPiA+ID4gPiA+IG1hc2tlZCB0byBzZXBhcmF0ZSBJUHY0IGFuZCBJUHY2IHR5cGVz
IGZvciBMNCBwcm90b2NvbHMuIFJvb20gaXMgIA0KPiBhdmFpbGFibGUNCj4gPiA+ID4gPiBmb3Ig
ZXh0ZW5kaW5nIGxhdGVyIHdoaWxlIGtlZXBpbmcgdGhlc2UgcHJvcGVydGllcy4gVGhpcyBtYXBz
IGFuZCAgDQo+IHVuaWZpZXMNCj4gPiA+ID4gPiBkaWZmZXJlbmNlIHRvIGhhcmR3YXJlIHNwZWNp
ZmljIGhhc2hlcy4NCj4gPiA+ID4NCj4gPiA+ID4gTG9va3MgZ29vZCBvdmVyYWxsLiBBbnkgcmVh
c29uIHdlJ3JlIG1ha2luZyB0aGlzIHNwZWNpZmljIGxheW91dD8NCj4gPg0KPiA+ID4gT25lIGlt
cG9ydGFudCBnb2FsIGlzIHRvIGhhdmUgYSBzaW1wbGUvZmFzdCB3YXkgdG8gZGV0ZXJtaW5pbmcg
TDMgdnMgIA0KPiBMNCwNCj4gPiA+IGJlY2F1c2UgYSBMNCBoYXNoIGNhbiBiZSB1c2VkIGZvciBm
bG93IGhhbmRsaW5nIChlLmcuIGxvYWQtYmFsYW5jaW5nKS4NCj4gPg0KPiA+ID4gV2UgYmVsb3cg
bGF5b3V0IHlvdSBjYW46DQo+ID4NCj4gPiA+IMKgIGlmIChyc3NfdHlwZSAmIFhEUF9SU1NfVFlQ
RV9MNF9NQVNLKQ0KPiA+ID4gwqDCoMKgwqBib29sIGh3X2hhc2hfZG9fTEIgPSB0cnVlOw0KPiA+
DQo+ID4gPiBPciB1c2luZyBpdCBhcyBhIG51bWJlcjoNCj4gPg0KPiA+ID4gwqAgaWYgKHJzc190
eXBlID4gWERQX1JTU19UWVBFX0w0KQ0KPiA+ID4gwqDCoMKgwqBib29sIGh3X2hhc2hfZG9fTEIg
PSB0cnVlOw0KPiA+DQo+ID4gV2h5IGlzIGl0IHN0cmljdGx5IGJldHRlciB0aGVuIHRoZSBmb2xs
b3dpbmc/DQo+ID4NCj4gPiBpZiAocnNzX3R5cGUgJiAoVFlQRV9VRFAgfCBUWVBFX1RDUCB8IFRZ
UEVfU0NUUCkpIHt9DQo+ID4NCg0KPiBTZWUgVjIgSSBkcm9wcGVkIHRoZSBpZGVhIG9mIHRoaXMg
YmVpbmcgYSBudW1iZXIgKHRoYXQgaWRlYSB3YXMgbm90IGENCj4gZ29vZCBpZGVhKS4NCg0K8J+R
jQ0KDQo+ID4gSWYgd2UgYWRkIHNvbWUgbmV3IEw0IGZvcm1hdCwgdGhlIGJwZiBwcm9ncmFtcyBj
YW4gYmUgdXBkYXRlZCB0byBzdXBwb3J0DQo+ID4gaXQ/DQo+ID4NCj4gPiA+IEknbSB2ZXJ5IG9w
ZW4gdG8gY2hhbmdlcyB0byBteSAic3BlY2lmaWMiIGxheW91dC7CoCBJIGFtIGluIGRvdWJ0IGlm
DQo+ID4gPiB1c2luZyBpdCBhcyBhIG51bWJlciBpcyB0aGUgcmlnaHQgYXBwcm9hY2ggYW5kIHdv
cnRoIHRoZSB0cm91YmxlLg0KPiA+DQo+ID4gPiA+IFdoeSBub3Qgc2ltcGx5IHRoZSBmb2xsb3dp
bmc/DQo+ID4gPiA+DQo+ID4gPiA+IGVudW0gew0KPiA+ID4gPsKgIO+/ve+/ve+/ve+/vVhEUF9S
U1NfVFlQRV9OT05FID0gMCwNCj4gPiA+ID7CoCDvv73vv73vv73vv71YRFBfUlNTX1RZUEVfSVBW
NCA9IEJJVCgwKSwNCj4gPiA+ID7CoCDvv73vv73vv73vv71YRFBfUlNTX1RZUEVfSVBWNiA9IEJJ
VCgxKSwNCj4gPiA+ID7CoCDvv73vv73vv73vv70vKiBJUHY2IHdpdGggZXh0ZW5zaW9uIGhlYWRl
ci4gKi8NCj4gPiA+ID7CoCDvv73vv73vv73vv70vKiBsZXQncyBub3RlIF5eXiBpdCBpbiB0aGUg
VUFQST8gKi8NCj4gPiA+ID7CoCDvv73vv73vv73vv71YRFBfUlNTX1RZUEVfSVBWNl9FWCA9IEJJ
VCgyKSwNCj4gPiA+ID7CoCDvv73vv73vv73vv71YRFBfUlNTX1RZUEVfVURQID0gQklUKDMpLA0K
PiA+ID4gPsKgIO+/ve+/ve+/ve+/vVhEUF9SU1NfVFlQRV9UQ1AgPSBCSVQoNCksDQo+ID4gPiA+
wqAg77+977+977+977+9WERQX1JTU19UWVBFX1NDVFAgPSBCSVQoNSksDQo+ID4NCj4gPiA+IFdl
IGtub3cgdGhlc2UgYml0cyBmb3IgVURQLCBUQ1AsIFNDVFAgKGFuZCBJUFNFQykgYXJlIGV4Y2x1
c2l2ZSwgdGhleQ0KPiA+ID4gY2Fubm90IGJlIHNldCBhdCB0aGUgc2FtZSB0aW1lLCBlLmcuIGFz
IGEgcGFja2V0IGNhbm5vdCBib3RoIGJlIFVEUCAgDQo+IGFuZA0KPiA+ID4gVENQLsKgIFRodXMs
IHVzaW5nIHRoZXNlIGJpdHMgYXMgYSBudW1iZXIgbWFrZSBzZW5zZSB0byBtZSwgYW5kIGlzIG1v
cmUNCj4gPiA+IGNvbXBhY3QuDQo+ID4NCj4gPiBbLi5dDQo+ID4NCj4gPiA+IFRoaXMgQklUKCkg
YXBwcm9hY2ggYWxzbyBoYXZlIHRoZSBpc3N1ZSBvZiBleHRlbmRpbmcgaXQgbGF0ZXIgKGZvcndh
cmQNCj4gPiA+IGNvbXBhdGliaWxpdHkpLsKgIEFzIG1lbnRpb25lZCBhIGNvbW1vbiB0YXNrIHdp
bGwgYmUgdG8gY2hlY2sgaWYNCj4gPiA+IGhhc2gtdHlwZSBpcyBhIEw0IHR5cGUuwqAgU2VlIG1s
eDUgW3BhdGNoIDQvNF0gbmVlZGVkIHRvIGV4dGVuZCB3aXRoDQo+ID4gPiBJUFNFQy4gTm90aWNl
IGhvdyBteSBYRFBfUlNTX1RZUEVfTDRfTUFTSyBjb3ZlcnMgYWxsIHRoZSBiaXRzIHRoYXQgIA0K
PiB0aGlzDQo+ID4gPiBjYW4gYmUgZXh0ZW5kZWQgd2l0aCBuZXcgTDQgdHlwZXMsIHN1Y2ggdGhh
dCBleGlzdGluZyBwcm9ncyB3aWxsIHN0aWxsDQo+ID4gPiB3b3JrIGNoZWNraW5nIGZvciBMNCBj
aGVjay7CoCBJdCBjYW4gb2YtY2F1c2UgYmUgc29sdmVkIGluIHRoZSBzYW1lIHdheQ0KPiA+ID4g
Zm9yIHRoaXMgQklUKCkgYXBwcm9hY2ggYnkgcmVzZXJ2aW5nIHNvbWUgYml0cyB1cGZyb250IGlu
IGEgbWFzay4NCj4gPg0KPiA+IFdlJ3JlIHVzaW5nIDYgYml0cyBvdXQgb2YgNjQsIHdlIHNob3Vs
ZCBiZSBnb29kIGZvciBhd2hpbGU/IElmIHRoZXJlDQo+ID4gaXMgZXZlciBhIGZvcndhcmQgY29t
cGF0aWJpbGl0eSBpc3N1ZSwgd2UgY2FuIGFsd2F5cyBjb21lIHVwIHdpdGgNCj4gPiBhIG5ldyBr
ZnVuYy4NCg0KPiBJIHdhbnQvbmVlZCBzdG9yZSB0aGUgUlNTLXR5cGUgaW4gdGhlIHhkcF9mcmFt
ZSwgZm9yIFhEUF9SRURJUkVDVCBhbmQNCj4gU0tCIHVzZS1jYXNlcy4gIFRodXMsIEkgZG9uJ3Qg
d2FudCB0byB1c2UgNjQtYml0LzgtYnl0ZXMsIGFzIHhkcF9mcmFtZQ0KPiBzaXplIGlzIGxpbWl0
ZWQgKGdpdmVuIGl0IHJlZHVjZXMgaGVhZHJvb20gZXhwYW5zaW9uKS4NCg0KPiA+DQo+ID4gT25l
IG90aGVyIHJlbGF0ZWQgcXVlc3Rpb24gSSBoYXZlIGlzOiBzaG91bGQgd2UgZXhwb3J0IHRoZSB0
eXBlDQo+ID4gb3ZlciBzb21lIGFkZGl0aW9uYWwgbmV3IGtmdW5jIGFyZ3VtZW50PyAoaW5zdGVh
ZCBvZiBhYnVzaW5nIHRoZSByZXR1cm4NCj4gPiB0eXBlKQ0KDQo+IEdvb2QgcXVlc3Rpb24uIEkg
d2FzIGFsc28gd29uZGVyaW5nIGlmIGl0IHdvdWxkbid0IGJlIGJldHRlciB0byBhZGQNCj4gYW5v
dGhlciBrZnVuYyBhcmd1bWVudCB3aXRoIHRoZSByc3NfaGFzaF90eXBlPw0KDQo+IFRoYXQgd2ls
bCBjaGFuZ2UgdGhlIGNhbGwgc2lnbmF0dXJlLCBzbyB0aGF0IHdpbGwgbm90IGJlIGVhc3kgdG8g
aGFuZGxlDQo+IGJldHdlZW4ga2VybmVsIHJlbGVhc2VzLg0KDQpBZ3JlZSB3aXRoIFRva2Ugb24g
YSBzZXBhcmF0ZSB0aHJlYWQ7IG1pZ2h0IG5vdCBiZSB0b28gbGF0ZSB0byBmaXQgaXQNCmludG8g
YW4gcmMuLg0KDQo+ID4gTWF5YmUgdGhhdCB3aWxsIGxldCB1cyBkcm9wIHRoZSBleHBsaWNpdCBC
VEZfVFlQRV9FTUlUIGFzIHdlbGw/DQoNCj4gU3VyZSwgaWYgd2UgZGVmaW5lIGl0IGFzIGFuIGFy
Z3VtZW50LCB0aGVuIGl0IHdpbGwgYXV0b21hdGljYWxseQ0KPiBleHBvcnRlZCBhcyBCVEYuDQoN
Cj4gPiA+ID4gfQ0KPiA+ID4gPg0KPiA+ID4gPiBBbmQgdGhlbiB1c2luZyBYRFBfUlNTX1RZUEVf
SVBWNHxYRFBfUlNTX1RZUEVfVURQIHZzDQo+ID4gPiA+IFhEUF9SU1NfVFlQRV9JUFY2fFhYWCA/
DQo+ID4NCj4gPiA+IERvIG5vdGljZSwgdGhhdCBJIGFscmVhZHkgZG9lcyBzb21lIGxldmVsIG9m
IG9yJ2luZyAoInwiKSBpbiB0aGlzDQo+ID4gPiBwcm9wb3NhbC7CoCBUaGUgbWFpbiBkaWZmZXJl
bmNlIGlzIHRoYXQgSSBoaWRlIHRoaXMgZnJvbSB0aGUgZHJpdmVyLCAgDQo+IGFuZA0KPiA+ID4g
a2luZCBvZiBwcmUtY29tYmluZSB0aGUgdmFsaWQgY29tYmluYXRpb24gKGVudW0ncykgZHJpdmVy
cyBjYW4gc2VsZWN0DQo+ID4gPiBmcm9tLiBJIGRvIGdldCB0aGUgcG9pbnQsIGFuZCBJIHRoaW5r
IEkgd2lsbCBjb21lIHVwIHdpdGggYSBjb21iaW5lZA0KPiA+ID4gc29sdXRpb24gYmFzZWQgb24g
eW91ciBpbnB1dC4NCj4gPg0KPiA+DQo+ID4gPiBUaGUgUlNTIGhhc2hpbmcgdHlwZXMgYW5kIGNv
bWJpbmF0aW9ucyBjb21lcyBmcm9tIE0kIHN0YW5kYXJkczoNCj4gPiA+IMKgIFsxXSAgDQo+IGh0
dHBzOi8vbGVhcm4ubWljcm9zb2Z0LmNvbS9lbi11cy93aW5kb3dzLWhhcmR3YXJlL2RyaXZlcnMv
bmV0d29yay9yc3MtaGFzaGluZy10eXBlcyNpcHY0LWhhc2gtdHlwZS1jb21iaW5hdGlvbnMNCj4g
Pg0KPiA+IE15IG1haW4gY29uY2VybiBoZXJlIGlzIHRoYXQgd2UncmUgb3Zlci1jb21wbGljYXRp
bmcgaXQgd2l0aCB0aGUgbWFza3MNCj4gPiBhbmQgdGhlIGZvcm1hdC4gV2l0aCB0aGUgZXhwbGlj
aXQgYml0cyB3ZSBjYW4gZWFzaWx5IG1hcCB0byB0aGF0DQo+ID4gc3BlYyB5b3UgbWVudGlvbi4N
Cg0KPiBTZWUgaWYgeW91IGxpa2UgbXkgUkZDLVYyIHByb3Bvc2FsIGJldHRlci4NCj4gSXQgc2hv
dWxkIGdvIG1vcmUgaW4geW91ciBkaXJlY3Rpb24uDQoNClllYWgsIEkgbGlrZSBpdCBiZXR0ZXIu
IEJ0dywgd2h5IGhhdmUgYSBzZXBhcmF0ZSBiaXQgZm9yIFhEUF9SU1NfQklUX0VYPw0KQW55IHJl
YXNvbiBpdCdzIG5vdCBhIFhEUF9SU1NfTDNfSVBWNl9FWCB3aXRoaW4gWERQX1JTU19MM19NQVNL
Pw0KDQpBbmQgdGhlIGZvbGxvd2luZyBwYXJ0IHNlZW1zIGxpa2UgYSBsZWZ0b3ZlciBmcm9tIHRo
ZSBlYXJsaWVyIHZlcnNpb246DQoNCisvKiBGb3IgcGFydGl0aW9uaW5nIG9mIHhkcF9yc3NfaGFz
aF90eXBlICovDQorI2RlZmluZSBSU1NfTDMJCUdFTk1BU0soMiwwKSAvKiAzLWJpdHMgPSB2YWx1
ZXMgYmV0d2VlbiAxLTcgKi8NCisjZGVmaW5lIEw0X0JJVAkJQklUKDMpICAgICAgIC8qIDEtYml0
IC0gTDQgaW5kaWNhdGlvbiAqLw0KKyNkZWZpbmUgUlNTX0w0X0lQVjQJR0VOTUFTSyg2LDQpIC8q
IDMtYml0cyAqLw0KKyNkZWZpbmUgUlNTX0w0X0lQVjYJR0VOTUFTSyg5LDcpIC8qIDMtYml0cyAq
Lw0KKyNkZWZpbmUgUlNTX0w0CQlHRU5NQVNLKDksMykgLyogPSA3LWJpdHMgLSBjb3ZlcmluZyBM
NCBJUFY0K0lQVjYgKi8NCisjZGVmaW5lIEw0X0lQVjZfRVhfQklUCUJJVCg5KSAgICAgICAvKiAx
LWJpdCAtIEw0IElQdjYgd2l0aCBFeHRlbnNpb24gaGRyICANCiovDQorCQkJCSAgICAgLyogMTEt
Yml0cyBpbiB0b3RhbCAqLw0KDQo+ID4gRm9yIGV4YW1wbGUsIGZvciBmb3J3YXJkIGNvbXBhdCwg
SSdtIG5vdCBzdXJlIHdlIGNhbiBhc3N1bWUgdGhhdCB0aGUgIA0KPiBwZW9wbGUNCj4gPiB3aWxs
IGRvOg0KPiA+ICDCoMKgwqDCoCJyc3NfdHlwZSAmIFhEUF9SU1NfVFlQRV9MNF9NQVNLIg0KPiA+
IGluc3RlYWQgb2Ygc29tZXRoaW5nIGxpa2U6DQo+ID4gIMKgwqDCoMKgInJzc190eXBlICYgKFhE
UF9SU1NfVFlQRV9MNF9JUFY0X1RDUHxYRFBfUlNTX1RZUEVfTDRfSVBWNF9VRFApIg0KPiA+DQoN
Cj4gVGhpcyBjb2RlIGlzIGFsbG93ZWQgaW4gVjIgYW5kIHNob3VsZCBiZS4gSXQgaXMgYSBjaG9p
Y2Ugb2YNCj4gQlBGLXByb2dyYW1tZXIgaW4gbGluZS0yIHRvIG5vdCBiZSBmb3J3YXJkIGNvbXBh
dGlibGUgd2l0aCBuZXdlciBMNCB0eXBlcy4NCg0KPiA+ID4gPiA+IFRoaXMgcHJvcG9zYWwgY2hh
bmdlIHRoZSBrZnVuYyBBUEkgYnBmX3hkcF9tZXRhZGF0YV9yeF9oYXNoKCkgdG8gICANCj4gcmV0
dXJuDQo+ID4gPiA+ID4gdGhpcyBSU1MgaGFzaCB0eXBlIG9uIHN1Y2Nlc3MuDQoNCj4gVGhpcyBp
cyB0aGUgcmVhbCBxdWVzdGlvbiAoYXMgYWxzbyByYWlzZWQgYWJvdmUpLi4uDQo+IFNob3VsZCB3
ZSB1c2UgcmV0dXJuIHZhbHVlIG9yIGFkZCBhbiBhcmd1bWVudCBmb3IgdHlwZT8NCg0KTGV0J3Mg
Zml4IHRoZSBwcm90b3R5cGUgd2hpbGUgaXQncyBzdGlsbCBlYXJseSBpbiB0aGUgcmM/DQpNYXli
ZSBhbHNvIGV4dGVuZCB0aGUgdGVzdHMgdG8gZHJvcC9kZWNvZGUvdmVyaWZ5IHRoZSBtYXNrPw0K
DQo+IC0tSmVzcGVyDQoNCg==
