Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA215B79E7
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiIMSoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiIMSoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:44:01 -0400
X-Greylist: delayed 5491 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Sep 2022 11:21:35 PDT
Received: from m1550.mail.126.com (m1550.mail.126.com [220.181.15.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47EA9E28
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 11:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=cfyVT
        BQBOjLBhxQeTGWGA4RoBGV0BspF/SXXaWKTn/0=; b=LvOGcYqpUUmh3rs8KT3zl
        xlJEUa7QzDSZ70ur0FRXT+G3yQaEe2Rg3K4DZlpcoUvp/lWeShi6OKBo4+icOl4z
        /FoGz6hg/k9+gBBAt8PR8u+aqNuKChF85XT2SLA49f6Stfxd2qyHJiUHzLzclBij
        JazzRaJCN5/q9Ukd8BKtug=
Received: from windhl$126.com ( [117.136.0.43] ) by ajax-webmail-wmsvr50
 (Coremail) ; Tue, 13 Sep 2022 23:13:20 +0800 (CST)
X-Originating-IP: [117.136.0.43]
Date:   Tue, 13 Sep 2022 23:13:20 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, linmq006@gmail.com
Subject: Re:[PATCH v2] of: mdio: Add of_node_put() when breaking out of
 for_each_xx
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <20220913125659.3331969-1-windhl@126.com>
References: <20220913125659.3331969-1-windhl@126.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <622cae81.8543.18337696f77.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: MsqowABHnfERniBjgkxsAA--.44452W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbizhR7F18RP0pETwACsE
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKQXQgMjAyMi0wOS0xMyAyMDo1Njo1OSwgIkxpYW5nIEhlIiA8d2luZGhsQDEyNi5jb20+IHdy
b3RlOgo+SW4gb2ZfbWRpb2J1c19yZWdpc3RlcigpLCB3ZSBzaG91bGQgY2FsbCBvZl9ub2RlX3B1
dCgpIGZvciAnY2hpbGQnCj5lc2NhcGVkIG91dCBvZiBmb3JfZWFjaF9hdmFpbGFibGVfY2hpbGRf
b2Zfbm9kZSgpLgo+Cj5GaXhlczogNjZiZGVkZTQ5NWM3ICgib2ZfbWRpbzogRml4IGJyb2tlbiBQ
SFkgSVJRIGluIGNhc2Ugb2YgcHJvYmUgZGVmZXJyYWwiKQo+Q2M6IE1pYW9xaWFuIExpbiA8bGlu
bXEwMDZAZ21haWwuY29tPgo+Q28tZGV2ZWxvcGVkLWJ5OiBNaWFvcWlhbiBMaW4gPGxpbm1xMDA2
QGdtYWlsLmNvbT4KPlNpZ25lZC1vZmYtYnk6IExpYW5nIEhlIDx3aW5kaGxAMTI2LmNvbT4KPlNp
Z25lZC1vZmYtYnk6IE1pYW9xaWFuIExpbiA8bGlubXEwMDZAZ21haWwuY29tPgoKSGksIE1pYW9x
aWFuLCAKdGhpcyBTb2Igc2hvdWxkIGRpcmVjdGx5IGZyb20geW91LApwbGVhc2UgZG8gaXQhCgoK
Pi0tLQo+IHYyOiB1c2UgcHJvcGVyIHRhZyBhZHZpc2VkIGJ5IEpha3ViIEtpY2luc2tpCj4gdjE6
IGZpeCB0aGUgYnVnCj4KPiBkcml2ZXJzL25ldC9tZGlvL29mX21kaW8uYyB8IDEgKwo+IDEgZmls
ZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQo+Cj5kaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvbWRp
by9vZl9tZGlvLmMgYi9kcml2ZXJzL25ldC9tZGlvL29mX21kaW8uYwo+aW5kZXggOWUzYzgxNWEw
NzBmLi43OTZlOWM3ODU3ZDAgMTAwNjQ0Cj4tLS0gYS9kcml2ZXJzL25ldC9tZGlvL29mX21kaW8u
Ywo+KysrIGIvZHJpdmVycy9uZXQvbWRpby9vZl9tZGlvLmMKPkBAIC0yMzEsNiArMjMxLDcgQEAg
aW50IG9mX21kaW9idXNfcmVnaXN0ZXIoc3RydWN0IG1paV9idXMgKm1kaW8sIHN0cnVjdCBkZXZp
Y2Vfbm9kZSAqbnApCj4gCXJldHVybiAwOwo+IAo+IHVucmVnaXN0ZXI6Cj4rCW9mX25vZGVfcHV0
KGNoaWxkKTsKPiAJbWRpb2J1c191bnJlZ2lzdGVyKG1kaW8pOwo+IAlyZXR1cm4gcmM7Cj4gfQo+
LS0gCj4yLjI1LjEK
