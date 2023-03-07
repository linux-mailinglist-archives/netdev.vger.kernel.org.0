Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3336C6ADA35
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjCGJWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjCGJWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:22:39 -0500
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AD2953724;
        Tue,  7 Mar 2023 01:22:19 -0800 (PST)
Received: from dzm91$hust.edu.cn ( [172.16.0.254] ) by ajax-webmail-app2
 (Coremail) ; Tue, 7 Mar 2023 17:21:49 +0800 (GMT+08:00)
X-Originating-IP: [172.16.0.254]
Date:   Tue, 7 Mar 2023 17:21:49 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91@hust.edu.cn>
To:     "miquel raynal" <miquel.raynal@bootlin.com>
Cc:     "denis kirjanov" <dkirjanov@suse.de>,
        "alexander aring" <alex.aring@gmail.com>,
        "stefan schmidt" <stefan@datenfreihafen.org>,
        "david s. miller" <davem@davemloft.net>,
        "eric dumazet" <edumazet@google.com>,
        "jakub kicinski" <kuba@kernel.org>,
        "paolo abeni" <pabeni@redhat.com>,
        syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] net: ieee802154: fix a null pointer in
 nl802154_trigger_scan
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20220802(cbd923c5)
 Copyright (c) 2002-2023 www.mailtech.cn hust
In-Reply-To: <20230307100903.71e2d9b2@xps-13>
References: <20230307073004.74224-1-dzm91@hust.edu.cn>
 <782a6f2d-84ae-3530-7e3c-07f31a4f303b@suse.de>
 <20230307100903.71e2d9b2@xps-13>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2b209456.234a2.186bb608224.Coremail.dzm91@hust.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: GQEQrAAXHeEtAgdk+_VbAQ--.24936W
X-CM-SenderInfo: asqsiiirqrkko6kx23oohg3hdfq/1tbiAQsDD17Em4N7owACse
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tCj4g5Y+R5Lu25Lq6OiAiTWlxdWVsIFJheW5hbCIg
PG1pcXVlbC5yYXluYWxAYm9vdGxpbi5jb20+Cj4g5Y+R6YCB5pe26Ze0OiAyMDIzLTAzLTA3IDE3
OjA5OjAzICjmmJ/mnJ/kuowpCj4g5pS25Lu25Lq6OiAiRGVuaXMgS2lyamFub3YiIDxka2lyamFu
b3ZAc3VzZS5kZT4KPiDmioTpgIE6ICJEb25nbGlhbmcgTXUiIDxkem05MUBodXN0LmVkdS5jbj4s
ICJBbGV4YW5kZXIgQXJpbmciIDxhbGV4LmFyaW5nQGdtYWlsLmNvbT4sICJTdGVmYW4gU2NobWlk
dCIgPHN0ZWZhbkBkYXRlbmZyZWloYWZlbi5vcmc+LCAiRGF2aWQKPiAgUy4gTWlsbGVyIiA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD4sICJFcmljIER1bWF6ZXQiIDxlZHVtYXpldEBnb29nbGUuY29tPiwg
Ikpha3ViCj4gIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwub3JnPiwgIlBhb2xvIEFiZW5pIiA8cGFi
ZW5pQHJlZGhhdC5jb20+LCBzeXpib3QrYmQ4NWIzMTgxNjkxM2EzMmU0NzNAc3l6a2FsbGVyLmFw
cHNwb3RtYWlsLmNvbSwgbGludXgtd3BhbkB2Z2VyLmtlcm5lbC5vcmcsIG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmcsIGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcKPiDkuLvpopg6IFJlOiBbUEFU
Q0hdIG5ldDogaWVlZTgwMjE1NDogZml4IGEgbnVsbCBwb2ludGVyIGluIG5sODAyMTU0X3RyaWdn
ZXJfc2Nhbgo+IAo+IEhlbGxvLAo+IAo+IGRraXJqYW5vdkBzdXNlLmRlIHdyb3RlIG9uIFR1ZSwg
NyBNYXIgMjAyMyAxMTo0Mzo0NiArMDMwMDoKPiAKPiA+IE9uIDMvNy8yMyAxMDozMCwgRG9uZ2xp
YW5nIE11IHdyb3RlOgo+ID4gPiBUaGVyZSBpcyBhIG51bGwgcG9pbnRlciBkZXJlZmVyZW5jZSBp
ZiBOTDgwMjE1NF9BVFRSX1NDQU5fVFlQRSBpcwo+ID4gPiBub3Qgc2V0IGJ5IHRoZSB1c2VyLgo+
ID4gPiAKPiA+ID4gRml4IHRoaXMgYnkgYWRkaW5nIGEgbnVsbCBwb2ludGVyIGNoZWNrLgo+IAo+
IFRoYW5rcyBmb3IgdGhlIHBhdGNoISBUaGlzIGhhcyBiZWVuIGZpeGVkIGFscmVhZHk6Cj4gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtd3Bhbi8yMDIzMDMwMTE1NDQ1MC41NDc3MTYtMS1t
aXF1ZWwucmF5bmFsQGJvb3RsaW4uY29tL1QvI3UKCk9oLCBJIHNlZS4gVGhhbmtzIGZvciB5b3Vy
IHJlcGx5LgoKQSBzbWFsbCBpc3N1ZTogc2hvdWxkIHdlIHN0aWxsIGNoZWNrICFubGFfZ2V0X3U4
KGluZm8tPmF0dHJzW05MODAyMTU0X0FUVFJfU0NBTl9UWVBFXSk/Cgo+IAo+ID4gPiBSZXBvcnRl
ZC1hbmQtdGVzdGVkLWJ5OiBzeXpib3QrYmQ4NWIzMTgxNjkxM2EzMmU0NzNAc3l6a2FsbGVyLmFw
cHNwb3RtYWlsLmNvbQo+IAo+IEp1c3QgZm9yIHJlZmVyZW5jZSwgdGhpcyB0YWcgc2hhbGwgbm90
IGJlIHVzZWQ6Cj4gCj4gCSJQbGVhc2UgZG8gbm90IHVzZSBjb21iaW5lZCB0YWdzLCBlLmcuCj4g
CWBgUmVwb3J0ZWQtYW5kLXRlc3RlZC1ieWBgIgo+IAlEb2N1bWVudGF0aW9uL3Byb2Nlc3MvbWFp
bnRhaW5lci10aXAucnN0Cj4gCgpPa2F5LiBUaGlzIGlzIHN1Z2dlc3RlZCBieSBTeXpib3QuIEkg
d2lsbCB1c2Ugc2VwYXJhdGUgdGFncyBpbiB0aGUgZnV0dXJlLgoKPiA+ID4gU2lnbmVkLW9mZi1i
eTogRG9uZ2xpYW5nIE11IDxkem05MUBodXN0LmVkdS5jbj4gIAo+ID4gCj4gPiBQbGVhc2UgYWRk
IGEgRml4ZXM6IHRhZyAKPiA+IAo+ID4gPiAtLS0KPiA+ID4gIG5ldC9pZWVlODAyMTU0L25sODAy
MTU0LmMgfCAzICsrLQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQo+ID4gPiAKPiA+ID4gZGlmZiAtLWdpdCBhL25ldC9pZWVlODAyMTU0L25sODAy
MTU0LmMgYi9uZXQvaWVlZTgwMjE1NC9ubDgwMjE1NC5jCj4gPiA+IGluZGV4IDIyMTVmNTc2ZWUz
Ny4uMWNmMDBjZmZkNjNmIDEwMDY0NAo+ID4gPiAtLS0gYS9uZXQvaWVlZTgwMjE1NC9ubDgwMjE1
NC5jCj4gPiA+ICsrKyBiL25ldC9pZWVlODAyMTU0L25sODAyMTU0LmMKPiA+ID4gQEAgLTE0MTIs
NyArMTQxMiw4IEBAIHN0YXRpYyBpbnQgbmw4MDIxNTRfdHJpZ2dlcl9zY2FuKHN0cnVjdCBza19i
dWZmICpza2IsIHN0cnVjdCBnZW5sX2luZm8gKmluZm8pCj4gPiA+ICAJCXJldHVybiAtRU9QTk9U
U1VQUDsKPiA+ID4gIAl9Cj4gPiA+ICAKPiA+ID4gLQlpZiAoIW5sYV9nZXRfdTgoaW5mby0+YXR0
cnNbTkw4MDIxNTRfQVRUUl9TQ0FOX1RZUEVdKSkgewo+ID4gPiArCWlmICghaW5mby0+YXR0cnNb
Tkw4MDIxNTRfQVRUUl9TQ0FOX1RZUEVdIHx8Cj4gPiA+ICsJICAgICFubGFfZ2V0X3U4KGluZm8t
PmF0dHJzW05MODAyMTU0X0FUVFJfU0NBTl9UWVBFXSkpIHsKPiA+ID4gIAkJTkxfU0VUX0VSUl9N
U0coaW5mby0+ZXh0YWNrLCAiTWFsZm9ybWVkIHJlcXVlc3QsIG1pc3Npbmcgc2NhbiB0eXBlIik7
Cj4gPiA+ICAJCXJldHVybiAtRUlOVkFMOwo+ID4gPiAgCX0gIAo+IAo+IAo+IFRoYW5rcywKPiBN
aXF1w6hsCgoKLS0KQmVzdCByZWdhcmRzLApEb25nbGlhbmcgTXUK
