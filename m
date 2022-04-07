Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DCA4F7EAB
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245092AbiDGMGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245105AbiDGMF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:05:57 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5D46CA0E9;
        Thu,  7 Apr 2022 05:03:26 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 7 Apr 2022 20:02:58
 +0800 (GMT+08:00)
X-Originating-IP: [10.181.226.201]
Date:   Thu, 7 Apr 2022 20:02:58 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Oliver Neukum" <oneukum@suse.com>
Cc:     linux-kernel@vger.kernel.org, chris@zankel.net, jcmvbkbc@gmail.com,
        mustafa.ismail@intel.com, shiraz.saleem@intel.com, jgg@ziepe.ca,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, jes@trained-monkey.org,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alexander.deucher@amd.com, linux-xtensa@linux-xtensa.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-hippi@sunsite.dk,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linma@zju.edu.cn
Subject: Re: Re: [PATCH 02/11] drivers: usb: host: Fix deadlock in
 oxu_bus_suspend()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <8ed7760a-471d-19a2-0a3b-1e0fc3a27281@suse.com>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <8b1201dc7554a2ab3ca555a2b6e2747761603d19.1649310812.git.duoming@zju.edu.cn>
 <8ed7760a-471d-19a2-0a3b-1e0fc3a27281@suse.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4170b816.3f4a8.18003e801f8.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgAXj2Ly0k5i+UeSAQ--.26944W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgQNAVZdtZE08wABsj
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBUaHUsIDcgQXByIDIwMjIgMTA6MDE6NDMgKzAyMDAgT2xpdmVyIE5ldWt1bSB3
cm90ZToKCj4gT24gMDcuMDQuMjIgMDg6MzMsIER1b21pbmcgWmhvdSB3cm90ZToKPiA+IFRoZXJl
IGlzIGEgZGVhZGxvY2sgaW4gb3h1X2J1c19zdXNwZW5kKCksIHdoaWNoIGlzIHNob3duIGJlbG93
Ogo+ID4KPiA+ICAgIChUaHJlYWQgMSkgICAgICAgICAgICAgIHwgICAgICAoVGhyZWFkIDIpCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IHRpbWVyX2FjdGlvbigpCj4gPiBveHVfYnVz
X3N1c3BlbmQoKSAgICAgICAgICB8ICBtb2RfdGltZXIoKQo+ID4gIHNwaW5fbG9ja19pcnEoKSAv
LygxKSAgICAgfCAgKHdhaXQgYSB0aW1lKQo+ID4gIC4uLiAgICAgICAgICAgICAgICAgICAgICAg
fCBveHVfd2F0Y2hkb2coKQo+ID4gIGRlbF90aW1lcl9zeW5jKCkgICAgICAgICAgfCAgc3Bpbl9s
b2NrX2lycSgpIC8vKDIpCj4gPiAgKHdhaXQgdGltZXIgdG8gc3RvcCkgICAgICB8ICAuLi4KPiA+
Cj4gPiBXZSBob2xkIG94dS0+bG9jayBpbiBwb3NpdGlvbiAoMSkgb2YgdGhyZWFkIDEsIGFuZCB1
c2UKPiA+IGRlbF90aW1lcl9zeW5jKCkgdG8gd2FpdCB0aW1lciB0byBzdG9wLCBidXQgdGltZXIg
aGFuZGxlcgo+ID4gYWxzbyBuZWVkIG94dS0+bG9jayBpbiBwb3NpdGlvbiAoMikgb2YgdGhyZWFk
IDIuIEFzIGEgcmVzdWx0LAo+ID4gb3h1X2J1c19zdXNwZW5kKCkgd2lsbCBibG9jayBmb3JldmVy
Lgo+ID4KPiA+IFRoaXMgcGF0Y2ggZXh0cmFjdHMgZGVsX3RpbWVyX3N5bmMoKSBmcm9tIHRoZSBw
cm90ZWN0aW9uIG9mCj4gPiBzcGluX2xvY2tfaXJxKCksIHdoaWNoIGNvdWxkIGxldCB0aW1lciBo
YW5kbGVyIHRvIG9idGFpbgo+ID4gdGhlIG5lZWRlZCBsb2NrLgo+IEdvb2QgY2F0Y2guCj4gPiBT
aWduZWQtb2ZmLWJ5OiBEdW9taW5nIFpob3UgPGR1b21pbmdAemp1LmVkdS5jbj4KPiA+IC0tLQo+
ID4gIGRyaXZlcnMvdXNiL2hvc3Qvb3h1MjEwaHAtaGNkLmMgfCAyICsrCj4gPiAgMSBmaWxlIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKQo+ID4KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9o
b3N0L294dTIxMGhwLWhjZC5jIGIvZHJpdmVycy91c2IvaG9zdC9veHUyMTBocC1oY2QuYwo+ID4g
aW5kZXggYjc0MTY3MDUyNWUuLmVlNDAzZGYzMzA5IDEwMDY0NAo+ID4gLS0tIGEvZHJpdmVycy91
c2IvaG9zdC9veHUyMTBocC1oY2QuYwo+ID4gKysrIGIvZHJpdmVycy91c2IvaG9zdC9veHUyMTBo
cC1oY2QuYwo+ID4gQEAgLTM5MDksOCArMzkwOSwxMCBAQCBzdGF0aWMgaW50IG94dV9idXNfc3Vz
cGVuZChzdHJ1Y3QgdXNiX2hjZCAqaGNkKQo+ID4gIAkJfQo+ID4gIAl9Cj4gPiAgCj4gPiArCXNw
aW5fdW5sb2NrX2lycSgmb3h1LT5sb2NrKTsKPiA+ICAJLyogdHVybiBvZmYgbm93LWlkbGUgSEMg
Ki8KPiA+ICAJZGVsX3RpbWVyX3N5bmMoJm94dS0+d2F0Y2hkb2cpOwo+ID4gKwlzcGluX2xvY2tf
aXJxKCZveHUtPmxvY2spOwo+ID4gIAllaGNpX2hhbHQob3h1KTsKPiA+ICAJaGNkLT5zdGF0ZSA9
IEhDX1NUQVRFX1NVU1BFTkRFRDsKPiA+ICAKPiAKPiBXaGF0IGlzIHRoZSBsb2NrIHByb3RlY3Rp
bmcgYXQgdGhhdCBzdGFnZT8gV2h5IG5vdCBqdXN0IGRyb3AgaXQgZWFybGllci4KCkkgdGhpbmsg
dGhlcmUgaXMgYSByYWNlIGNvbmRpdGlvbiBiZXR3ZWVuIG94dV9idXNfc3VzcGVuZCgpIGFuZCBv
eHVfc3RvcCgpLApzbyBJIHRoaW5rIHdlIGNvdWxkIG5vdCBkcm9wIHRoZSBveHUtPmxvY2sgZWFy
bGllci4KCiAgICAgICAgICAgICAgIChUaHJlYWQgMSkgICAgICAgICAgICAgICB8ICAgICAgICAg
KFRocmVhZCAyKQogb3h1X2J1c19zdXNwZW5kKCkgICAgICAgICAgICAgICAgICAgICAgfCBveHVf
c3RvcCgpCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IAogaGNkLT5z
dGF0ZSA9IEhDX1NUQVRFX1NVU1BFTkRFRDsgICAgICAgfCAgc3Bpbl9sb2NrX2lycSgmb3h1LT5s
b2NrKTsKIC4uLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgCiB3cml0ZWwo
bWFzaywgJm94dS0+cmVncy0+aW50cl9lbmFibGUpOyB8ICAuLi4KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgIHdyaXRlbCgwLCAmb3h1LT5yZWdzLT5pbnRyX2VuYWJs
ZSk7CiByZWFkbCgmb3h1LT5yZWdzLT5pbnRyX2VuYWJsZSk7ICAgICAgICB8CgpUaGUgb3h1LT5y
ZWdzLT5pbnRyX2VuYWJsZSBpcyBzZXQgdG8gMCBpbiBveHVfc3RvcCgpLCBhbmQgdGhlIHJlYWRs
KCkgaW4Kb3h1X2J1c19zdXNwZW5kKCkgd2lsbCByZWFkIHRoZSB3cm9uZyB2YWx1ZS4KClRoYW5r
cyBhIGxvdCBmb3IgeW91ciB0aW1lIGFuZCBhZHZpY2UuIElmIHlvdSBoYXZlIHF1ZXN0aW9ucywg
d2VsY29tZSB0byBhc2sgbWUuCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQo=
