Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A983C52E0FD
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343883AbiETAJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiETAJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:09:16 -0400
X-Greylist: delayed 49890 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 17:09:13 PDT
Received: from azure-sdnproxy-3.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id CA60395499;
        Thu, 19 May 2022 17:09:13 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Fri, 20 May 2022 08:08:59
 +0800 (GMT+08:00)
X-Originating-IP: [124.236.130.193]
Date:   Fri, 20 May 2022 08:08:59 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jeff Johnson" <quic_jjohnson@quicinc.com>
Cc:     "Kalle Valo" <kvalo@kernel.org>, linux-kernel@vger.kernel.org,
        amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: wireless: marvell: mwifiex: fix sleep in
 atomic context bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <18852332-ee42-ef7e-67a3-bbd91a6694ba@quicinc.com>
References: <20220519135345.109936-1-duoming@zju.edu.cn>
 <87zgjd1sd4.fsf@kernel.org>
 <699e56d5.22006.180dce26e02.Coremail.duoming@zju.edu.cn>
 <18852332-ee42-ef7e-67a3-bbd91a6694ba@quicinc.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4e778cb1.22654.180decbcb8e.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgAHbtgb3IZikq2LAA--.13527W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAg0QAVZdtZyOgwABsw
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

SGVsbG8sCgpPbiBUaHUsIDE5IE1heSAyMDIyIDA4OjQ4OjQ0IC0wNzAwIEplZmYgSm9obnNvbiB3
cm90ZToKCj4gPj4+IFRoZXJlIGFyZSBzbGVlcCBpbiBhdG9taWMgY29udGV4dCBidWdzIHdoZW4g
dXBsb2FkaW5nIGRldmljZSBkdW1wCj4gPj4+IGRhdGEgb24gdXNiIGludGVyZmFjZS4gVGhlIHJv
b3QgY2F1c2UgaXMgdGhhdCB0aGUgb3BlcmF0aW9ucyB0aGF0Cj4gPj4+IG1heSBzbGVlcCBhcmUg
Y2FsbGVkIGluIGZ3X2R1bXBfdGltZXJfZm4gd2hpY2ggaXMgYSB0aW1lciBoYW5kbGVyLgo+ID4+
PiBUaGUgY2FsbCB0cmVlIHNob3dzIHRoZSBleGVjdXRpb24gcGF0aHMgdGhhdCBjb3VsZCBsZWFk
IHRvIGJ1Z3M6Cj4gPj4+Cj4gPj4+ICAgICAoSW50ZXJydXB0IGNvbnRleHQpCj4gPj4+IGZ3X2R1
bXBfdGltZXJfZm4KPiA+Pj4gICAgbXdpZmlleF91cGxvYWRfZGV2aWNlX2R1bXAKPiA+Pj4gICAg
ICBkZXZfY29yZWR1bXB2KC4uLiwgR0ZQX0tFUk5FTCkKPiAKPiBqdXN0IGxvb2tpbmcgYXQgdGhp
cyBkZXNjcmlwdGlvbiwgd2h5IGlzbid0IHRoZSBzaW1wbGUgZml4IGp1c3QgdG8gCj4gY2hhbmdl
IHRoaXMgY2FsbCB0byB1c2UgR0ZQX0FUT01JQz8KCkJlY2F1c2UgY2hhbmdlIHRoZSBwYXJhbWV0
ZXIgb2YgZGV2X2NvcmVkdW1wdigpIHRvIEdGUF9BVE9NSUMgY291bGQgb25seSBzb2x2ZQpwYXJ0
aWFsIHByb2JsZW0uIFRoZSBmb2xsb3dpbmcgR0ZQX0tFUk5FTCBwYXJhbWV0ZXJzIGFyZSBpbiAv
bGliL2tvYmplY3QuYyAKd2hpY2ggaXMgbm90IGluZmx1ZW5jZWQgYnkgZGV2X2NvcmVkdW1wdigp
LgoKIGtvYmplY3Rfc2V0X25hbWVfdmFyZ3MKICAga3Zhc3ByaW50Zl9jb25zdChHRlBfS0VSTkVM
LCAuLi4pOyAvL21heSBzbGVlcAogICBrc3RyZHVwKHMsIEdGUF9LRVJORUwpOyAvL21heSBzbGVl
cAoKQmVzdCByZWdhcmRzLApEdW9taW5nIFpob3U=
