Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3550753C1B5
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 04:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239895AbiFCAmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 20:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiFCAmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 20:42:36 -0400
Received: from azure-sdnproxy-1.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id F0CB1614F;
        Thu,  2 Jun 2022 17:42:30 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Fri, 3 Jun 2022 08:42:07
 +0800 (GMT+08:00)
X-Originating-IP: [106.117.80.109]
Date:   Fri, 3 Jun 2022 08:42:07 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jeff Johnson" <quic_jjohnson@quicinc.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        rafael@kernel.org
Subject: Re: [PATCH v4 1/2] devcoredump: remove the useless gfp_t parameter
 in dev_coredumpv
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <e8d9d010-7fa1-da61-feeb-43f0a101a323@quicinc.com>
References: <cover.1654175941.git.duoming@zju.edu.cn>
 <338a65fe8f30d23339cfc09fe1fb7be751ad655b.1654175941.git.duoming@zju.edu.cn>
 <e8d9d010-7fa1-da61-feeb-43f0a101a323@quicinc.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <397aa8b.4be56.181270327b5.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgDXQCDfWJliO88wAQ--.29039W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggKAVZdtaBKlgAAsD
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW5Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBUaHUsIDIgSnVuIDIwMjIgMTM6MzI6NDggLTA3MDAgSmVmZiBKb2huc29uIHdy
b3RlOgoKPiBPbiA2LzIvMjAyMiA2OjMzIEFNLCBEdW9taW5nIFpob3Ugd3JvdGU6Cj4gPiBUaGUg
ZGV2X2NvcmVkdW1wdigpIGNvdWxkIG5vdCBiZSB1c2VkIGluIGF0b21pYyBjb250ZXh0LCBiZWNh
dXNlCj4gPiBpdCBjYWxscyBrdmFzcHJpbnRmX2NvbnN0KCkgYW5kIGtzdHJkdXAoKSB3aXRoIEdG
UF9LRVJORUwgcGFyYW1ldGVyLgo+ID4gVGhlIHByb2Nlc3MgaXMgc2hvd24gYmVsb3c6Cj4gPiAK
PiA+IGRldl9jb3JlZHVtcHYoLi4uLCBnZnBfdCBnZnApCj4gPiAgICBkZXZfY29yZWR1bXBtCj4g
PiAgICAgIGRldl9zZXRfbmFtZQo+ID4gICAgICAgIGtvYmplY3Rfc2V0X25hbWVfdmFyZ3MKPiA+
ICAgICAgICAgIGt2YXNwcmludGZfY29uc3QoR0ZQX0tFUk5FTCwgLi4uKTsgLy9tYXkgc2xlZXAK
PiA+ICAgICAgICAgICAga3N0cmR1cChzLCBHRlBfS0VSTkVMKTsgLy9tYXkgc2xlZXAKPiA+IAo+
ID4gVGhpcyBwYXRjaCByZW1vdmVzIGdmcF90IHBhcmFtZXRlciBvZiBkZXZfY29yZWR1bXB2KCkg
YW5kIGNoYW5nZXMgdGhlCj4gPiBnZnBfdCBwYXJhbWV0ZXIgb2YgZGV2X2NvcmVkdW1wbSgpIHRv
IEdGUF9LRVJORUwgaW4gb3JkZXIgdG8gc2hvdwo+ID4gZGV2X2NvcmVkdW1wdigpIGNvdWxkIG5v
dCBiZSB1c2VkIGluIGF0b21pYyBjb250ZXh0Lgo+IAo+IHNob3VsZG4ndCB5b3UgcmVtb3ZlIHRo
ZSBnZnAgcGFyYW1ldGVyIHRvIGRldl9jb3JlZHVtcG0oKSBhcyB3ZWxsIHNpbmNlIAo+IGl0IGlz
IGFjdHVhbGx5IHdpdGhpbiB0aGF0IGZ1bmN0aW9uIHdoZXJlIGRldl9zZXRfbmFtZSgpIGlzIGNh
bGxlZCB3aGljaCAKPiBjYW5ub3QgYmUgZG9uZSBpbiBhdG9taWMgY29udGV4dD8KClRoYW5rcyBm
b3IgeW91ciBzdWdnZXN0aW9uLCBJIHdpbGwgcmVtb3ZlIHRoZSBnZnBfdCBwYXJhbWV0ZXIgb2Yg
ZGV2X2NvcmVkdW1wbSgpIGFzIHdlbGwuIAoKQmVzdCByZWdhcmRzLApEdW9taW5nIFpob3UK
