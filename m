Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CF553206D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 03:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiEXByw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 21:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiEXByv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 21:54:51 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 08AF37B9F5;
        Mon, 23 May 2022 18:54:47 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Tue, 24 May 2022 09:54:29
 +0800 (GMT+08:00)
X-Originating-IP: [124.236.130.193]
Date:   Tue, 24 May 2022 09:54:29 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Brian Norris" <briannorris@chromium.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "amit karwar" <amitkarwar@gmail.com>,
        "Ganapathi Bhat" <ganapathi017@gmail.com>,
        "Sharvari Harisangam" <sharvari.harisangam@nxp.com>,
        "Xinming Hu" <huxinming820@gmail.com>, kvalo@kernel.org,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] mwifiex: fix sleep in atomic context bugs caused by
 dev_coredumpv
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <CA+ASDXNBeN6k6y+eY06FkheNTNWN02P2uT9bB09KtBok0LVFfQ@mail.gmail.com>
References: <20220523052810.24767-1-duoming@zju.edu.cn>
 <87o7zoxrdf.fsf@email.froward.int.ebiederm.org>
 <6a270950.2c659.180f1a46e8c.Coremail.duoming@zju.edu.cn>
 <CA+ASDXNBeN6k6y+eY06FkheNTNWN02P2uT9bB09KtBok0LVFfQ@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4fe65d9a.2cf82.180f3c5d1d6.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgBXX4vVOoxi5OanAA--.8720W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgsAAVZdtZ1uzAABsI
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

SGVsbG8sCgpPbiBNb24sIDIzIE1heSAyMDIyIDEyOjQyOjQ0IC0wNzAwIEJyaWFuIHdyb3RlOgoK
PiAoSSB0aGluayBwZW9wbGUgZ2VuZXJhbGx5IGFncmVlZCBvbiB0aGlzIGFwcHJvYWNoLCBidXQg
cGxlYXNlIHN1Ym1pdCBhCj4gbmV3IHNlcmllcywgd2l0aCBzZXBhcmF0ZSBwYXRjaGVzKQo+IAo+
IE9uIE1vbiwgTWF5IDIzLCAyMDIyIGF0IDEyOjI3IFBNIDxkdW9taW5nQHpqdS5lZHUuY24+IHdy
b3RlOgo+ID4gV2hhdCdzIG1vcmUsIEkgbW92ZSB0aGUgb3BlcmF0aW9ucyB0aGF0IG1heSBzbGVl
cCBpbnRvIGEgd29yayBpdGVtIGFuZCB1c2UKPiA+IHNjaGVkdWxlX3dvcmsoKSB0byBjYWxsIGEg
a2VybmVsIHRocmVhZCB0byBkbyB0aGUgb3BlcmF0aW9ucyB0aGF0IG1heSBzbGVlcC4KPiAKPiBZ
b3UgZW5kIHVwIHdpdGggYSB0aW1lciB0aGF0IGp1c3QgZXhpc3RzIHRvIGtpY2sgYSB3b3JrIGl0
ZW0uIEVyaWMKPiBzdWdnZXN0ZWQgeW91IGp1c3QgdXNlIGEgZGVsYXllZF93b3JrLCBhbmQgdGhl
biB5b3UgZG9uJ3QgbmVlZCBib3RoIGEKPiB0aW1lciBhbmQgYSB3b3JrIHN0cnVjdC4KCkkgd2ls
bCBzdWJtaXQgYSBuZXcgc2VyaWVzLCBvbmUgaXMgcmVtb3ZpbmcgdGhlIGdmcF90IHBhcmFtZXRl
ciBvZiBkZXZfY29yZWR1bXB2LAphbm90aGVyIGlzIHVzaW5nIGl0IHByb3Blcmx5IGluIG13aWZp
ZXgocHV0IHRoZSBkZXZfY29yZWR1bXB2IGluIHRoZSBkZWxheWVkX3dvcmspLgpUaGFuayB5b3Ug
Zm9yIHlvdXIgc3VnZ2VzdGlvbnMhCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQ==
