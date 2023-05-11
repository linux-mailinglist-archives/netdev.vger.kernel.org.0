Return-Path: <netdev+bounces-1854-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 926BB6FF511
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C94C32817FA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6318620;
	Thu, 11 May 2023 14:53:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1FB36D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:53:09 +0000 (UTC)
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id DBF6C120AF;
	Thu, 11 May 2023 07:52:46 -0700 (PDT)
Received: from iccccc$hust.edu.cn ( [172.16.0.254] ) by ajax-webmail-app2
 (Coremail) ; Thu, 11 May 2023 22:52:25 +0800 (GMT+08:00)
X-Originating-IP: [172.16.0.254]
Date: Thu, 11 May 2023 22:52:25 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: =?UTF-8?B?5YiY5rWp5q+F?= <iccccc@hust.edu.cn>
To: "david s. miller" <davem@davemloft.net>, 
	"david ahern" <dsahern@kernel.org>, 
	"eric dumazet" <edumazet@google.com>, 
	"jakub kicinski" <kuba@kernel.org>, 
	"paolo abeni" <pabeni@redhat.com>
Cc: hust-os-kernel-patches@googlegroups.com, yalongz@hust.edu.cn, 
	error27@gmail.com, "dongliang mu" <dzm91@hust.edu.cn>, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net/ipv6: silence 'passing zero to ERR_PTR()'
 warning
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20220802(cbd923c5)
 Copyright (c) 2002-2023 www.mailtech.cn hust
In-Reply-To: <20230413101005.7504-1-iccccc@hust.edu.cn>
References: <20230413101005.7504-1-iccccc@hust.edu.cn>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <5bd5bfa.4758.1880b4c8bb2.Coremail.iccccc@hust.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:GQEQrADHJswpAV1kAbTIAA--.8017W
X-CM-SenderInfo: bxsqjiirqqkko6kx23oohg3hdfq/1tbiAQkIEWRcidIctgABsZ
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
	HK_RANDOM_FROM,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Cgo+IC0tLS0t5Y6f5aeL6YKu5Lu2LS0tLS0KPiDlj5Hku7bkuro6ICJIYW95aSBMaXUiIDxpY2Nj
Y2NAaHVzdC5lZHUuY24+Cj4g5Y+R6YCB5pe26Ze0OiAyMDIzLTA0LTEzIDE4OjEwOjA1ICjmmJ/m
nJ/lm5spCj4g5pS25Lu25Lq6OiAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dD4sICJEYXZpZCBBaGVybiIgPGRzYWhlcm5Aa2VybmVsLm9yZz4sICJFcmljIER1bWF6ZXQiIDxl
ZHVtYXpldEBnb29nbGUuY29tPiwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwub3JnPiwg
IlBhb2xvIEFiZW5pIiA8cGFiZW5pQHJlZGhhdC5jb20+Cj4g5oqE6YCBOiBodXN0LW9zLWtlcm5l
bC1wYXRjaGVzQGdvb2dsZWdyb3Vwcy5jb20sIHlhbG9uZ3pAaHVzdC5lZHUuY24sIGVycm9yMjdA
Z21haWwuY29tLCAiSGFveWkgTGl1IiA8aWNjY2NjQGh1c3QuZWR1LmNuPiwgIkRvbmdsaWFuZyBN
dSIgPGR6bTkxQGh1c3QuZWR1LmNuPiwgbmV0ZGV2QHZnZXIua2VybmVsLm9yZywgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZwo+IOS4u+mimDogW1BBVENIIG5ldC1uZXh0IHYyXSBuZXQvaXB2
Njogc2lsZW5jZSAncGFzc2luZyB6ZXJvIHRvIEVSUl9QVFIoKScgd2FybmluZwo+IAo+IFNtYXRj
aCBjb21wbGFpbnMgdGhhdCBpZiB4ZnJtX2xvb2t1cCgpIHJldHVybnMgTlVMTCB0aGVuIHRoaXMg
ZG9lcyBhCj4gd2VpcmQgdGhpbmcgd2l0aCAiZXJyIjoKPiAKPiAgICAgbmV0LyBpcHY2LyBpY21w
LmM6NDExIGljbXB2Nl9yb3V0ZV9sb29rdXAoKQo+ICAgICB3YXJuOiBwYXNzaW5nIHplcm8gdG8g
RVJSX1BUUigpCj4gCj4gTWVyZ2UgY29uZGl0aW9uYWwgcGF0aHMgYW5kIHJlbW92ZSB1bm5lY2Vz
c2FyeSAnZWxzZScuIE5vIGZ1bmN0aW9uYWwKPiBjaGFuZ2UuCj4gCj4gU2lnbmVkLW9mZi1ieTog
SGFveWkgTGl1IDxpY2NjY2NAaHVzdC5lZHUuY24+Cj4gUmV2aWV3ZWQtYnk6IERvbmdsaWFuZyBN
dSA8ZHptOTFAaHVzdC5lZHUuY24+Cj4gLS0tCj4gdjEtPnYyOiBSZW1vdmUgdW5uZWNlc3Nhcnkg
J2Vsc2UnLgo+IFRoZSBpc3N1ZSBpcyBmb3VuZCBieSBzdGF0aWMgYW5hbHlzaXMsIGFuZCB0aGUg
cGF0Y2ggaXMgcmVtYWlucyB1bnRlc3RlZC4KPiAtLS0KPiAgbmV0L2lwdjYvaWNtcC5jIHwgMTcg
KysrKysrLS0tLS0tLS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTEg
ZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL25ldC9pcHY2L2ljbXAuYyBiL25ldC9pcHY2
L2ljbXAuYwo+IGluZGV4IDFmNTNmMmE3NDQ4MC4uYTEyZWVmMTFjN2VlIDEwMDY0NAo+IC0tLSBh
L25ldC9pcHY2L2ljbXAuYwo+ICsrKyBiL25ldC9pcHY2L2ljbXAuYwo+IEBAIC0zOTMsMTcgKzM5
MywxMiBAQCBzdGF0aWMgc3RydWN0IGRzdF9lbnRyeSAqaWNtcHY2X3JvdXRlX2xvb2t1cChzdHJ1
Y3QgbmV0ICpuZXQsCj4gIAkJZ290byByZWxvb2t1cF9mYWlsZWQ7Cj4gIAo+ICAJZHN0MiA9IHhm
cm1fbG9va3VwKG5ldCwgZHN0MiwgZmxvd2k2X3RvX2Zsb3dpKCZmbDIpLCBzaywgWEZSTV9MT09L
VVBfSUNNUCk7Cj4gLQlpZiAoIUlTX0VSUihkc3QyKSkgewo+IC0JCWRzdF9yZWxlYXNlKGRzdCk7
Cj4gLQkJZHN0ID0gZHN0MjsKPiAtCX0gZWxzZSB7Cj4gLQkJZXJyID0gUFRSX0VSUihkc3QyKTsK
PiAtCQlpZiAoZXJyID09IC1FUEVSTSkgewo+IC0JCQlkc3RfcmVsZWFzZShkc3QpOwo+IC0JCQly
ZXR1cm4gZHN0MjsKPiAtCQl9IGVsc2UKPiAtCQkJZ290byByZWxvb2t1cF9mYWlsZWQ7Cj4gLQl9
Cj4gKwllcnIgPSBQVFJfRVJSX09SX1pFUk8oZHN0Mik7Cj4gKwlpZiAoZXJyICYmIGVyciAhPSAt
RVBFUk0pCj4gKwkJZ290byByZWxvb2t1cF9mYWlsZWQ7Cj4gKwo+ICsJZHN0X3JlbGVhc2UoZHN0
KTsKPiArCXJldHVybiBkc3QyOwkvKiByZXR1cm5zIHN1Y2Nlc3Mgb3IgRVJSX1BUUigtRVBFUk0p
ICovCj4gIAo+ICByZWxvb2t1cF9mYWlsZWQ6Cj4gIAlpZiAoZHN0KQo+IC0tIAo+IDIuNDAuMAoK
cGluZz8=

