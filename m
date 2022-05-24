Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FEA5320B6
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 04:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbiEXCI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 22:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiEXCIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 22:08:54 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 8E0D692D3C;
        Mon, 23 May 2022 19:08:50 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Tue, 24 May 2022 10:08:39
 +0800 (GMT+08:00)
X-Originating-IP: [124.236.130.193]
Date:   Tue, 24 May 2022 10:08:39 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org
Subject: Re: [PATCH v3] mwifiex: fix sleep in atomic context bugs caused by
 dev_coredumpv
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <87ee0kyzvc.fsf@kernel.org>
References: <20220523052810.24767-1-duoming@zju.edu.cn>
 <87o7zoxrdf.fsf@email.froward.int.ebiederm.org>
 <6a270950.2c659.180f1a46e8c.Coremail.duoming@zju.edu.cn>
 <87ee0kyzvc.fsf@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <50aec6d7.2d054.180f3d2cbc0.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgBXX4snPoxidv+nAA--.8746W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgoAAVZdtZ1wFwAAsN
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkhlbGxvLAoKT24gTW9uLCAyMyBNYXkgMjAyMiAxOTozMTozNSArMDMwMCBLYWxsZSBWYWxvIHdy
b3RlOgoKPiA+PiA+IFRoZXJlIGFyZSBzbGVlcCBpbiBhdG9taWMgY29udGV4dCBidWdzIHdoZW4g
dXBsb2FkaW5nIGRldmljZSBkdW1wCj4gPj4gPiBkYXRhIGluIG13aWZpZXguIFRoZSByb290IGNh
dXNlIGlzIHRoYXQgZGV2X2NvcmVkdW1wdiBjb3VsZCBub3QKPiA+PiA+IGJlIHVzZWQgaW4gYXRv
bWljIGNvbnRleHRzLCBiZWNhdXNlIGl0IGNhbGxzIGRldl9zZXRfbmFtZSB3aGljaAo+ID4+ID4g
aW5jbHVkZSBvcGVyYXRpb25zIHRoYXQgbWF5IHNsZWVwLiBUaGUgY2FsbCB0cmVlIHNob3dzIGV4
ZWN1dGlvbgo+ID4+ID4gcGF0aHMgdGhhdCBjb3VsZCBsZWFkIHRvIGJ1Z3M6Cj4gPj4gPgo+ID4+
ID4gICAgKEludGVycnVwdCBjb250ZXh0KQo+ID4+ID4gZndfZHVtcF90aW1lcl9mbgo+ID4+ID4g
ICBtd2lmaWV4X3VwbG9hZF9kZXZpY2VfZHVtcAo+ID4+ID4gICAgIGRldl9jb3JlZHVtcHYoLi4u
LCBHRlBfS0VSTkVMKQo+ID4+ID4gICAgICAgZGV2X2NvcmVkdW1wbSgpCj4gPj4gPiAgICAgICAg
IGt6YWxsb2Moc2l6ZW9mKCpkZXZjZCksIGdmcCk7IC8vbWF5IHNsZWVwCj4gPj4gPiAgICAgICAg
IGRldl9zZXRfbmFtZQo+ID4+ID4gICAgICAgICAgIGtvYmplY3Rfc2V0X25hbWVfdmFyZ3MKPiA+
PiA+ICAgICAgICAgICAgIGt2YXNwcmludGZfY29uc3QoR0ZQX0tFUk5FTCwgLi4uKTsgLy9tYXkg
c2xlZXAKPiA+PiA+ICAgICAgICAgICAgIGtzdHJkdXAocywgR0ZQX0tFUk5FTCk7IC8vbWF5IHNs
ZWVwCj4gPj4gPgo+ID4+ID4gSW4gb3JkZXIgdG8gbGV0IGRldl9jb3JlZHVtcHYgc3VwcG9ydCBh
dG9taWMgY29udGV4dHMsIHRoaXMgcGF0Y2gKPiA+PiA+IGNoYW5nZXMgdGhlIGdmcF90IHBhcmFt
ZXRlciBvZiBrdmFzcHJpbnRmX2NvbnN0IGFuZCBrc3RyZHVwIGluCj4gPj4gPiBrb2JqZWN0X3Nl
dF9uYW1lX3ZhcmdzIGZyb20gR0ZQX0tFUk5FTCB0byBHRlBfQVRPTUlDLiBXaGF0J3MgbW9yZSwK
PiA+PiA+IEluIG9yZGVyIHRvIG1pdGlnYXRlIGJ1ZywgdGhpcyBwYXRjaCBjaGFuZ2VzIHRoZSBn
ZnBfdCBwYXJhbWV0ZXIKPiA+PiA+IG9mIGRldl9jb3JlZHVtcHYgZnJvbSBHRlBfS0VSTkVMIHRv
IEdGUF9BVE9NSUMuCj4gPj4gCj4gPj4gdm1hbGxvYyBpbiBhdG9taWMgY29udGV4dD8KPiA+PiAK
PiA+PiBOb3Qgb25seSBkb2VzIGRldl9jb3JlZHVtcG0gc2V0IGEgZGV2aWNlIG5hbWUgZGV2X2Nv
cmVkdW1wbSBjcmVhdGVzIGFuCj4gPj4gZW50aXJlIGRldmljZSB0byBob2xkIHRoZSBkZXZpY2Ug
ZHVtcC4KPiA+PiAKPiA+PiBNeSBzZW5zZSBpcyB0aGF0IGVpdGhlciBkZXZfY29yZWR1bXBtIG5l
ZWRzIHRvIGJlIHJlYnVpbHQgb24gYQo+ID4+IGNvbXBsZXRlbHkgZGlmZmVyZW50IHByaW5jaXBs
ZSB0aGF0IGRvZXMgbm90IG5lZWQgYSBkZXZpY2UgdG8gaG9sZCB0aGUKPiA+PiBjb3JlZHVtcCAo
c28gdGhhdCBpdCBjYW4gYmUgY2FsbGVkIGZyb20gaW50ZXJydXB0IGNvbnRleHQpIG9yIHRoYXQK
PiA+PiBkZXZfY29yZWR1bXBtIHNob3VsZCBuZXZlciBiZSBjYWxsZWQgaW4gYW4gY29udGV4dCB0
aGF0IGNhbiBub3Qgc2xlZXAuCj4gPgo+ID4gVGhlIGZvbGxvd2luZyBzb2x1dGlvbiByZW1vdmVz
IHRoZSBnZnBfdCBwYXJhbWV0ZXIgb2YgZGV2X2NvcmVkdW1wdigpLCAKPiA+IGRldl9jb3JlZHVt
cG0oKSBhbmQgZGV2X2NvcmVkdW1wc2coKSBhbmQgY2hhbmdlIHRoZSBnZnBfdCBwYXJhbWV0ZXIg
b2YgCj4gPiBremFsbG9jKCkgaW4gZGV2X2NvcmVkdW1wbSgpIHRvIEdGUF9LRVJORUwsIGluIG9y
ZGVyIHRvIHNob3cgdGhhdCB0aGVzZSAKPiA+IGZ1bmN0aW9ucyBjYW4gbm90IGJlIHVzZWQgaW4g
YXRvbWljIGNvbnRleHQuCj4gPgo+ID4gV2hhdCdzIG1vcmUsIEkgbW92ZSB0aGUgb3BlcmF0aW9u
cyB0aGF0IG1heSBzbGVlcCBpbnRvIGEgd29yayBpdGVtIGFuZCB1c2UKPiA+IHNjaGVkdWxlX3dv
cmsoKSB0byBjYWxsIGEga2VybmVsIHRocmVhZCB0byBkbyB0aGUgb3BlcmF0aW9ucyB0aGF0IG1h
eSBzbGVlcC4KPiA+Cj4gCj4gWy4uLl0KPiAKPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L21hcnZlbGwvbXdpZmlleC9pbml0LmMKPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21h
cnZlbGwvbXdpZmlleC9pbml0LmMKPiA+IEBAIC02MywxMSArNjMsMTkgQEAgc3RhdGljIHZvaWQg
d2FrZXVwX3RpbWVyX2ZuKHN0cnVjdCB0aW1lcl9saXN0ICp0KQo+ID4gIAkJYWRhcHRlci0+aWZf
b3BzLmNhcmRfcmVzZXQoYWRhcHRlcik7Cj4gPiAgfQo+ID4gIAo+ID4gK3N0YXRpYyB2b2lkIGZ3
X2R1bXBfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCj4gPiArewo+ID4gKwlzdHJ1Y3Qg
bXdpZmlleF9hZGFwdGVyICphZGFwdGVyID0KPiA+ICsJCWNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1
Y3QgbXdpZmlleF9hZGFwdGVyLCBkZXZkdW1wX3dvcmspOwo+ID4gKwo+ID4gKwltd2lmaWV4X3Vw
bG9hZF9kZXZpY2VfZHVtcChhZGFwdGVyKTsKPiA+ICt9Cj4gPiArCj4gPiAgc3RhdGljIHZvaWQg
ZndfZHVtcF90aW1lcl9mbihzdHJ1Y3QgdGltZXJfbGlzdCAqdCkKPiA+ICB7Cj4gPiAgCXN0cnVj
dCBtd2lmaWV4X2FkYXB0ZXIgKmFkYXB0ZXIgPSBmcm9tX3RpbWVyKGFkYXB0ZXIsIHQsIGRldmR1
bXBfdGltZXIpOwo+ID4gIAo+ID4gLQltd2lmaWV4X3VwbG9hZF9kZXZpY2VfZHVtcChhZGFwdGVy
KTsKPiA+ICsJc2NoZWR1bGVfd29yaygmYWRhcHRlci0+ZGV2ZHVtcF93b3JrKTsKPiA+ICB9Cj4g
PiAgCj4gPiAgLyoKPiA+IEBAIC0zMjEsNiArMzI5LDcgQEAgc3RhdGljIHZvaWQgbXdpZmlleF9p
bml0X2FkYXB0ZXIoc3RydWN0IG13aWZpZXhfYWRhcHRlciAqYWRhcHRlcikKPiA+ICAJYWRhcHRl
ci0+YWN0aXZlX3NjYW5fdHJpZ2dlcmVkID0gZmFsc2U7Cj4gPiAgCXRpbWVyX3NldHVwKCZhZGFw
dGVyLT53YWtldXBfdGltZXIsIHdha2V1cF90aW1lcl9mbiwgMCk7Cj4gPiAgCWFkYXB0ZXItPmRl
dmR1bXBfbGVuID0gMDsKPiA+ICsJSU5JVF9XT1JLKCZhZGFwdGVyLT5kZXZkdW1wX3dvcmssIGZ3
X2R1bXBfd29yayk7Cj4gPiAgCXRpbWVyX3NldHVwKCZhZGFwdGVyLT5kZXZkdW1wX3RpbWVyLCBm
d19kdW1wX3RpbWVyX2ZuLCAwKTsKPiA+ICB9Cj4gPiAgCj4gPiBAQCAtNDAxLDYgKzQxMCw3IEBA
IG13aWZpZXhfYWRhcHRlcl9jbGVhbnVwKHN0cnVjdCBtd2lmaWV4X2FkYXB0ZXIgKmFkYXB0ZXIp
Cj4gPiAgewo+ID4gIAlkZWxfdGltZXIoJmFkYXB0ZXItPndha2V1cF90aW1lcik7Cj4gPiAgCWRl
bF90aW1lcl9zeW5jKCZhZGFwdGVyLT5kZXZkdW1wX3RpbWVyKTsKPiA+ICsJY2FuY2VsX3dvcmtf
c3luYygmYWRhcHRlci0+ZGV2ZHVtcF93b3JrKTsKPiA+ICAJbXdpZmlleF9jYW5jZWxfYWxsX3Bl
bmRpbmdfY21kKGFkYXB0ZXIpOwo+ID4gIAl3YWtlX3VwX2ludGVycnVwdGlibGUoJmFkYXB0ZXIt
PmNtZF93YWl0X3Eud2FpdCk7Cj4gPiAgCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmYWRhcHRlci0+
aHNfYWN0aXZhdGVfd2FpdF9xKTsKPiAKPiBJbiB0aGlzIHBhdGNoIHBsZWFzZSBvbmx5IGRvIHRo
ZSBBUEkgY2hhbmdlIGluIG13aWZpZXguIFRoZSBjaGFuZ2UgdG8KPiB1c2luZyBhIHdvcmtxdWV1
ZSBuZWVkcyB0byBiZSBpbiBzZXBhcmF0ZSBwYXRjaCBzbyBpdCBjYW4gYmUgcHJvcGVybHkKPiB0
ZXN0ZWQuIEkgZG9uJ3Qgd2FudCBhIGNoYW5nZSBsaWtlIHRoYXQgZ29pbmcgdG8gdGhlIGtlcm5l
bCB3aXRob3V0Cj4gdGVzdGluZyBvbiBhIHJlYWwgZGV2aWNlLgoKVGhhbmsgeW91IGZvciB5b3Vy
IHN1Z2dlc3Rpb25zISBJIHdpbGwgb25seSBkbyB0aGUgQVBJIGNoYW5nZSBpbiBtd2lmaWVzIGFu
ZAprZWVwIG90aGVyIHBsYWNlcyB0aGF0IGNhbGwgZGV2X2NvcmVkdW1wdiByZW1haW4gdW5jaGFu
Z2VkLiBJIHdpbGwgdGVzdCB0aGUKbmV3IHNlcGFyYXRlIHBhdGNoZXMgb24gcmVhbCBNYXJ2ZWxs
IHdpZmkgY2hpcCB0aGVzZSBkYXlzLgoKQmVzdCByZWdhcmRzLApEdW9taW5nIFpob3U=
