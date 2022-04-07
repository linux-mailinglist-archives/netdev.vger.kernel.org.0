Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C934F7DAA
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 13:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbiDGLOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 07:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiDGLOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 07:14:43 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85F5713F00;
        Thu,  7 Apr 2022 04:12:40 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 7 Apr 2022 19:12:17
 +0800 (GMT+08:00)
X-Originating-IP: [10.181.226.201]
Date:   Thu, 7 Apr 2022 19:12:17 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Sergey Shtylyov" <s.shtylyov@omp.ru>
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
Subject: Re: Re: [PATCH 11/11] arch: xtensa: platforms: Fix deadlock in
 rs_close()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <1195e776-328d-12fe-d1f8-22085dc77b44@omp.ru>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <9ca3ab0b40c875b6019f32f031c68a1ae80dd73a.1649310812.git.duoming@zju.edu.cn>
 <1195e776-328d-12fe-d1f8-22085dc77b44@omp.ru>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <6728929.3f2bf.18003b99de6.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgDnXmIRx05icIeRAQ--.17700W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkNAVZdtZExngAIsP
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

SGVsbG8sCgpPbiBUaHUsIDcgQXByIDIwMjIgMTI6NDI6MzEgKzAzMDAgU2VyZ2V5IFNodHlseW92
IHdyb3RlOgoKPiA+IFRoZXJlIGlzIGEgZGVhZGxvY2sgaW4gcnNfY2xvc2UoKSwgd2hpY2ggaXMg
c2hvd24KPiA+IGJlbG93Ogo+ID4gCj4gPiAgICAoVGhyZWFkIDEpICAgICAgICAgICAgICB8ICAg
ICAgKFRocmVhZCAyKQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfCByc19vcGVuKCkK
PiA+IHJzX2Nsb3NlKCkgICAgICAgICAgICAgICAgIHwgIG1vZF90aW1lcigpCj4gPiAgc3Bpbl9s
b2NrX2JoKCkgLy8oMSkgICAgICB8ICAod2FpdCBhIHRpbWUpCj4gPiAgLi4uICAgICAgICAgICAg
ICAgICAgICAgICB8IHJzX3BvbGwoKQo+ID4gIGRlbF90aW1lcl9zeW5jKCkgICAgICAgICAgfCAg
c3Bpbl9sb2NrKCkgLy8oMikKPiA+ICAod2FpdCB0aW1lciB0byBzdG9wKSAgICAgIHwgIC4uLgo+
ID4gCj4gPiBXZSBob2xkIHRpbWVyX2xvY2sgaW4gcG9zaXRpb24gKDEpIG9mIHRocmVhZCAxIGFu
ZAo+ID4gdXNlIGRlbF90aW1lcl9zeW5jKCkgdG8gd2FpdCB0aW1lciB0byBzdG9wLCBidXQgdGlt
ZXIgaGFuZGxlcgo+ID4gYWxzbyBuZWVkIHRpbWVyX2xvY2sgaW4gcG9zaXRpb24gKDIpIG9mIHRo
cmVhZCAyLgo+ID4gQXMgYSByZXN1bHQsIHJzX2Nsb3NlKCkgd2lsbCBibG9jayBmb3JldmVyLgo+
ID4gCj4gPiBUaGlzIHBhdGNoIGV4dHJhY3RzIGRlbF90aW1lcl9zeW5jKCkgZnJvbSB0aGUgcHJv
dGVjdGlvbiBvZgo+ID4gc3Bpbl9sb2NrX2JoKCksIHdoaWNoIGNvdWxkIGxldCB0aW1lciBoYW5k
bGVyIHRvIG9idGFpbgo+ID4gdGhlIG5lZWRlZCBsb2NrLgo+ID4gCj4gPiBTaWduZWQtb2ZmLWJ5
OiBEdW9taW5nIFpob3UgPGR1b21pbmdAemp1LmVkdS5jbj4KPiA+IC0tLQo+ID4gIGFyY2gveHRl
bnNhL3BsYXRmb3Jtcy9pc3MvY29uc29sZS5jIHwgNCArKystCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvYXJj
aC94dGVuc2EvcGxhdGZvcm1zL2lzcy9jb25zb2xlLmMgYi9hcmNoL3h0ZW5zYS9wbGF0Zm9ybXMv
aXNzL2NvbnNvbGUuYwo+ID4gaW5kZXggODFkN2M3ZThmN2UuLmQ0MzFiNjFhZTNjIDEwMDY0NAo+
ID4gLS0tIGEvYXJjaC94dGVuc2EvcGxhdGZvcm1zL2lzcy9jb25zb2xlLmMKPiA+ICsrKyBiL2Fy
Y2gveHRlbnNhL3BsYXRmb3Jtcy9pc3MvY29uc29sZS5jCj4gPiBAQCAtNTEsOCArNTEsMTAgQEAg
c3RhdGljIGludCByc19vcGVuKHN0cnVjdCB0dHlfc3RydWN0ICp0dHksIHN0cnVjdCBmaWxlICog
ZmlscCkKPiA+ICBzdGF0aWMgdm9pZCByc19jbG9zZShzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5LCBz
dHJ1Y3QgZmlsZSAqIGZpbHApCj4gPiAgewo+ID4gIAlzcGluX2xvY2tfYmgoJnRpbWVyX2xvY2sp
Owo+ID4gLQlpZiAodHR5LT5jb3VudCA9PSAxKQo+ID4gKwlpZiAodHR5LT5jb3VudCA9PSAxKSB7
Cj4gPiArCQlzcGluX3VubG9ja19iaCgmdGltZXJfbG9jayk7Cj4gPiAgCQlkZWxfdGltZXJfc3lu
Yygmc2VyaWFsX3RpbWVyKTsKPiA+ICsJfQo+ID4gIAlzcGluX3VubG9ja19iaCgmdGltZXJfbG9j
ayk7Cj4gCj4gICAgRG91YmxlIHVubG9jayBpZmYgdHR5LT5jb3VudCA9PSAxPwoKWWVzLCBUaGFu
a3MgYSBsb3QgZm9yIHlvdXIgdGltZXIgYW5kIGFkdmljZS4gSSBmb3VuZCB0aGVyZSBpcyBubyBy
YWNlIGNvbmRpdGlvbgpiZXR3ZWVuIHJzX2Nsb3NlIGFuZCByc19wb2xsKHRpbWVyIGhhbmRsZXIp
LCBJIHRoaW5rIHdlIGNvdWxkIHJlbW92ZSB0aGUgdGltZXJfbG9jawppbiByc19jbG9zZSgpLCBy
c19vcGVuKCkgYW5kIHJzX3BvbGwoKS4KCkJlc3QgcmVnYXJkcywKRHVvbWluZyBaaG91
