Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D5652D199
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 13:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiESLhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 07:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiESLhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 07:37:01 -0400
X-Greylist: delayed 4751 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 04:36:58 PDT
Received: from azure-sdnproxy-1.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 8F41339828;
        Thu, 19 May 2022 04:36:57 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 19 May 2022 19:36:35
 +0800 (GMT+08:00)
X-Originating-IP: [124.236.130.193]
Date:   Thu, 19 May 2022 19:36:35 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     linux-kernel@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: wireless: marvell: mwifiex: fix sleep in
 atomic context bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <87fsl53jic.fsf@kernel.org>
References: <20220519101656.44513-1-duoming@zju.edu.cn>
 <87fsl53jic.fsf@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <257f8e7.216cd.180dc1af4d3.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgDHa7jDK4ZifB2FAA--.10644W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkPAVZdtZx1iAACsY
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

SGVsbG8sCgpPbiBUaHUsIDE5IE1heSAyMDIyIDEzOjI3OjA3ICswMzAwIEthbGxlIFZhbG8gd3Jv
dGU6Cgo+ID4gVGhlcmUgYXJlIHNsZWVwIGluIGF0b21pYyBjb250ZXh0IGJ1Z3Mgd2hlbiB1cGxv
YWRpbmcgZGV2aWNlIGR1bXAKPiA+IGRhdGEgb24gdXNiIGludGVyZmFjZS4gVGhlIHJvb3QgY2F1
c2UgaXMgdGhhdCB0aGUgb3BlcmF0aW9ucyB0aGF0Cj4gPiBtYXkgc2xlZXAgYXJlIGNhbGxlZCBp
biBmd19kdW1wX3RpbWVyX2ZuIHdoaWNoIGlzIGEgdGltZXIgaGFuZGxlci4KPiA+IFRoZSBjYWxs
IHRyZWUgc2hvd3MgdGhlIGV4ZWN1dGlvbiBwYXRocyB0aGF0IGNvdWxkIGxlYWQgdG8gYnVnczoK
PiA+Cj4gPiAgICAoSW50ZXJydXB0IGNvbnRleHQpCj4gPiBmd19kdW1wX3RpbWVyX2ZuCj4gPiAg
IG13aWZpZXhfdXBsb2FkX2RldmljZV9kdW1wCj4gPiAgICAgZGV2X2NvcmVkdW1wdiguLi4sIEdG
UF9LRVJORUwpCj4gPiAgICAgICBkZXZfY29yZWR1bXBtKCkKPiA+ICAgICAgICAga3phbGxvYyhz
aXplb2YoKmRldmNkKSwgZ2ZwKTsgLy9tYXkgc2xlZXAKPiA+ICAgICAgICAgZGV2X3NldF9uYW1l
Cj4gPiAgICAgICAgICAga29iamVjdF9zZXRfbmFtZV92YXJncwo+ID4gICAgICAgICAgICAga3Zh
c3ByaW50Zl9jb25zdChHRlBfS0VSTkVMLCAuLi4pOyAvL21heSBzbGVlcAo+ID4gICAgICAgICAg
ICAga3N0cmR1cChzLCBHRlBfS0VSTkVMKTsgLy9tYXkgc2xlZXAKPiA+Cj4gPiBUaGlzIHBhdGNo
IG1vdmVzIHRoZSBvcGVyYXRpb25zIHRoYXQgbWF5IHNsZWVwIGludG8gYSB3b3JrIGl0ZW0uCj4g
PiBUaGUgd29yayBpdGVtIHdpbGwgcnVuIGluIGFub3RoZXIga2VybmVsIHRocmVhZCB3aGljaCBp
cyBpbgo+ID4gcHJvY2VzcyBjb250ZXh0IHRvIGV4ZWN1dGUgdGhlIGJvdHRvbSBoYWxmIG9mIHRo
ZSBpbnRlcnJ1cHQuCj4gPiBTbyBpdCBjb3VsZCBwcmV2ZW50IGF0b21pYyBjb250ZXh0IGZyb20g
c2xlZXBpbmcuCj4gPgo+ID4gRml4ZXM6IGY1ZWNkMDJhOGIyMCAoIm13aWZpZXg6IGRldmljZSBk
dW1wIHN1cHBvcnQgZm9yIHVzYiBpbnRlcmZhY2UiKQo+ID4gU2lnbmVkLW9mZi1ieTogRHVvbWlu
ZyBaaG91IDxkdW9taW5nQHpqdS5lZHUuY24+Cj4gCj4gSGF2ZSB5b3UgdGVzdGVkIHRoaXMgb24g
cmVhbCBoYXJkd2FyZT8gT3IgaXMgdGhpcyBqdXN0IGEgdGhlb3JldGljYWwKPiBmaXg/CgpUaGlz
IGlzIGEgdGhlb3JldGljYWwgZml4LiBJIGRvbid0IGhhdmUgdGhlIHJlYWwgaGFyZHdhcmUuCgpC
ZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQo=
