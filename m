Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E2B4F813F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243057AbiDGOF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiDGOF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:05:56 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16996E09A5;
        Thu,  7 Apr 2022 07:03:52 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 7 Apr 2022 22:03:04
 +0800 (GMT+08:00)
X-Originating-IP: [10.181.226.201]
Date:   Thu, 7 Apr 2022 22:03:04 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jiri Slaby" <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, chris@zankel.net, jcmvbkbc@gmail.com,
        mustafa.ismail@intel.com, shiraz.saleem@intel.com, jgg@ziepe.ca,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, jes@trained-monkey.org,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        linux-xtensa@linux-xtensa.org, linux-rdma@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-hippi@sunsite.dk, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        "Russell King - ARM Linux" <linux@armlinux.org.uk>,
        linma@zju.edu.cn, rmk@flint.arm.linux.org.uk
Subject: Re: Re: [PATCH 01/11] drivers: tty: serial: Fix deadlock in
 sa1100_set_termios()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <656ffd1d-e7cf-d2c0-e0e6-c10215ba422b@kernel.org>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <e82ff9358d4ef90a7e9f624534d6d54fc193467f.1649310812.git.duoming@zju.edu.cn>
 <656ffd1d-e7cf-d2c0-e0e6-c10215ba422b@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2ad5aaaf.3fa1d.1800455f764.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgBnFvIY705iKQ2UAQ--.29015W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgMNAVZdtZE8AAAFsb
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBUaHUsIDcgQXByIDIwMjIgMDk6MDI6MDUgKzAyMDAgSmlyaSBTbGFieSB3cm90
ZToKCj4gPiBUaGVyZSBpcyBhIGRlYWRsb2NrIGluIHNhMTEwMF9zZXRfdGVybWlvcygpLCB3aGlj
aCBpcyBzaG93bgo+ID4gYmVsb3c6Cj4gPiAKPiA+ICAgICAoVGhyZWFkIDEpICAgICAgICAgICAg
ICB8ICAgICAgKFRocmVhZCAyKQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgc2Ex
MTAwX2VuYWJsZV9tcygpCj4gPiBzYTExMDBfc2V0X3Rlcm1pb3MoKSAgICAgICB8ICBtb2RfdGlt
ZXIoKQo+ID4gICBzcGluX2xvY2tfaXJxc2F2ZSgpIC8vKDEpIHwgICh3YWl0IGEgdGltZSkKPiA+
ICAgLi4uICAgICAgICAgICAgICAgICAgICAgICB8IHNhMTEwMF90aW1lb3V0KCkKPiA+ICAgZGVs
X3RpbWVyX3N5bmMoKSAgICAgICAgICB8ICBzcGluX2xvY2tfaXJxc2F2ZSgpIC8vKDIpCj4gPiAg
ICh3YWl0IHRpbWVyIHRvIHN0b3ApICAgICAgfCAgLi4uCj4gPiAKPiA+IFdlIGhvbGQgc3BvcnQt
PnBvcnQubG9jayBpbiBwb3NpdGlvbiAoMSkgb2YgdGhyZWFkIDEgYW5kCj4gPiB1c2UgZGVsX3Rp
bWVyX3N5bmMoKSB0byB3YWl0IHRpbWVyIHRvIHN0b3AsIGJ1dCB0aW1lciBoYW5kbGVyCj4gPiBh
bHNvIG5lZWQgc3BvcnQtPnBvcnQubG9jayBpbiBwb3NpdGlvbiAoMikgb2YgdGhyZWFkIDIuIEFz
IGEgcmVzdWx0LAo+ID4gc2ExMTAwX3NldF90ZXJtaW9zKCkgd2lsbCBibG9jayBmb3JldmVyLgo+
ID4gCj4gPiBUaGlzIHBhdGNoIGV4dHJhY3RzIGRlbF90aW1lcl9zeW5jKCkgZnJvbSB0aGUgcHJv
dGVjdGlvbiBvZgo+ID4gc3Bpbl9sb2NrX2lycXNhdmUoKSwgd2hpY2ggY291bGQgbGV0IHRpbWVy
IGhhbmRsZXIgdG8gb2J0YWluCj4gPiB0aGUgbmVlZGVkIGxvY2suCj4gPiAKPiA+IFNpZ25lZC1v
ZmYtYnk6IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1LmNuPgo+ID4gLS0tCj4gPiAgIGRy
aXZlcnMvdHR5L3NlcmlhbC9zYTExMDAuYyB8IDIgKysKPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90dHkvc2VyaWFsL3Nh
MTEwMC5jIGIvZHJpdmVycy90dHkvc2VyaWFsL3NhMTEwMC5jCj4gPiBpbmRleCA1ZmU2Y2NjZmMx
YS4uM2E1ZjEyY2VkMGIgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL3R0eS9zZXJpYWwvc2ExMTAw
LmMKPiA+ICsrKyBiL2RyaXZlcnMvdHR5L3NlcmlhbC9zYTExMDAuYwo+ID4gQEAgLTQ3Niw3ICs0
NzYsOSBAQCBzYTExMDBfc2V0X3Rlcm1pb3Moc3RydWN0IHVhcnRfcG9ydCAqcG9ydCwgc3RydWN0
IGt0ZXJtaW9zICp0ZXJtaW9zLAo+ID4gICAJCQkJVVRTUjFfVE9fU00oVVRTUjFfUk9SKTsKPiA+
ICAgCX0KPiA+ICAgCj4gPiArCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnNwb3J0LT5wb3J0Lmxv
Y2ssIGZsYWdzKTsKPiAKPiBVbmxvY2tpbmcgdGhlIGxvY2sgYXQgdGhpcyBwb2ludCBkb2Vzbid0
IGxvb2sgc2FmZSBhdCBhbGwuIE1heWJlIG1vdmluZyAKPiB0aGUgdGltZXIgZGVsZXRpb24gYmVm
b3JlIHRoZSBsb2NrPyBUaGVyZSBpcyBubyBjdXJyZW50IG1haW50YWluZXIgdG8gCj4gYXNrLiBN
b3N0IG9mIHRoZSBkcml2ZXIgb3JpZ2luYXRlcyBmcm9tIHJtay4gQ2NpbmcgaGltIGp1c3QgaW4g
Y2FzZS4KClRoYW5rcyBhIGxvdCBmb3IgeW91ciB0aW1lIGFuZCBhZHZpY2UuIEkgdGhpbmsgbW92
aW5nIHRoZSBkZWxfdGltZXJfc3luYygpCmJlZm9yZSB0aGUgbG9jayBpcyBnb29kLiBCZWNhdXNl
IHdlIG1heSB1c2UgInNhMTEwMF9lbmFibGVfbXMoJnNwb3J0LT5wb3J0KSIKdG8gc3RhcnQgdGhl
IHRpbWVyIGFmdGVyIHdlIGhhdmUgc2V0IHRlcm1pb3MuCgo+IEZXSVcgdGhlIGxvY2sgd2FzIG1v
dmVkIGJ5IHRoaXMgY29tbWl0IGFyb3VuZCBsaW51eCAyLjUuNTUgKGZyb20gCj4gZnVsbC1oaXN0
b3J5LWxpbnV4IFsxXSkKPiBjb21taXQgZjM4YWVmM2U2MmMyNmEzM2VhMzYwYTg2ZmRlOWIyN2Ux
ODNhMzc0OAo+IEF1dGhvcjogUnVzc2VsbCBLaW5nIDxybWtAZmxpbnQuYXJtLmxpbnV4Lm9yZy51
az4KPiBEYXRlOiAgIEZyaSBKYW4gMyAxNTo0MjowOSAyMDAzICswMDAwCj4gCj4gICAgICBbU0VS
SUFMXSBDb252ZXJ0IGNoYW5nZV9zcGVlZCgpIHRvIHNldHRlcm1pb3MoKQo+IAo+IFsxXSAKPiBo
dHRwczovL2FyY2hpdmUub3JnL2Rvd25sb2FkL2dpdC1oaXN0b3J5LW9mLWxpbnV4L2Z1bGwtaGlz
dG9yeS1saW51eC5naXQudGFyCj4gCj4gPiAgIAlkZWxfdGltZXJfc3luYygmc3BvcnQtPnRpbWVy
KTsKPiA+ICsJc3Bpbl9sb2NrX2lycXNhdmUoJnNwb3J0LT5wb3J0LmxvY2ssIGZsYWdzKTsKPiA+
ICAgCj4gPiAgIAkvKgo+ID4gICAJICogVXBkYXRlIHRoZSBwZXItcG9ydCB0aW1lb3V0LgoKCkJl
c3QgcmVnYXJkcywKRHVvbWluZyBaaG91
