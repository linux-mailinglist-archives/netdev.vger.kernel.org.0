Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7102D4D4E16
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239885AbiCJQDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241562AbiCJQDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:03:07 -0500
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 420EA18A790;
        Thu, 10 Mar 2022 08:01:39 -0800 (PST)
Received: by ajax-webmail-mail-app2 (Coremail) ; Fri, 11 Mar 2022 00:01:20
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.66.233]
Date:   Fri, 11 Mar 2022 00:01:20 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5ZGo5aSa5piO?= <duoming@zju.edu.cn>
To:     "Dan Carpenter" <dan.carpenter@oracle.com>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jreuter@yaina.de, kuba@kernel.org,
        davem@davemloft.net, ralf@linux-mips.org, thomas@osterried.de
Subject: Re: Re: [PATCH] ax25: Fix memory leaks caused by ax25_cb_del()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220310130508.GG3315@kadam>
References: <20220309150608.112090-1-duoming@zju.edu.cn>
 <20220310130508.GG3315@kadam>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2c28edff.f82b5.17f74902e09.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgAXEHrRICpiNJJCAA--.8618W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkFAVZdtYnj3gAAsF
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

SGVsbG8sCgpUaGFuayB5b3UgdmVyeSBtdWNoIGZvciBwb2ludGluZyB0aGUgd3JvbmcgcGxhY2Vz
IGluIG15IHBhdGNoLgoKPiBUaGlzIGlzIGEgdmVyeSBmcnVzdHJhdGluZyBwYXRjaCBiZWNhdXNl
IHlvdSBtYWtlIGEgbG90IG9mIHVubmVjZXNzYXJ5Cj4gd2hpdGUgc3BhY2UgY2hhbmdlcyBhbmQg
eW91IGRpZG4ndCBydW4gY2hlY2twYXRjaCBvbiB5b3VyIHBhdGNoLgo+IAo+IFRoZSB3aG9sZSBh
cHByb2FjaCBmZWVscyBsaWtlIHRoZSB3cm9uZyB0aGluZy4uLgoKSSB3aWxsIGZpeCBpdC4KCj4g
SSBoYXZlIHJlYWQgeW91ciBjb21taXQgbWVzc2FnZSwgYnV0IEkgZG9uJ3QgdW5kZXJzdGFuZCB3
aHkgd2UgY2FuJ3QKPiBqdXN0IHVzZSBub3JtYWwgcmVmY291bnRpbmcuICBJdCBzb3VuZHMgbGlr
ZSB0aGVyZSBpcyBhIGxheWVyaW5nCj4gdmlvbGF0aW9uIHNvbWV3aGVyZT8KClRoZSByb290IGNh
dXNlIG9mIHJlZmNvdW50IGxlYWsgaXMgc2hvd24gYmVsb3c6CgogICAgIChUaHJlYWQgMSkgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAoVGhyZWFkIDIpCmF4MjVfYmluZCgpICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfAogLi4uICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwKIGF4MjVfYWRkcl9heDI1ZGV2KCkgICAgICAgICAgICAgICAgICAgICB8IAog
IGF4MjVfZGV2X2hvbGQoKSAgIC8vKDEpICAgICAgICAgICAgICAgIHwKIC4uLiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB8CiBkZXZfaG9sZF90cmFjaygpICAgLy8oMikgICAg
ICAgICAgICAgICAgfCAKIC4uLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
IGF4MjVfZGVzdHJveV9zb2NrZXQoKQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgIGF4MjVfY2JfZGVsKCkgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8ICAgLi4uIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgICBzcGluX2xvY2tfYmgoJmF4MjVfbGlzdF9sb2NrKTsKICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgaGxpc3RfZGVsX2luaXQoJmF4MjUtPmF4MjVfbm9k
ZSk7IC8vKDMpIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICBz
cGluX3VubG9ja19iaCgmYXgyNV9saXN0X2xvY2spOwogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAKICAgICAodGhyZWFkIDMpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgCmF4MjVfa2lsbF9ieV9kZXZpY2UoKSAgICAgICAgICAgICAgICAgICAgfAog
c3Bpbl9sb2NrX2JoKCZheDI1X2xpc3RfbG9jayk7ICAgICAgICAgIHwKIGF4MjVfZm9yX2VhY2go
cywgJmF4MjVfbGlzdCkgeyAgICAgICAgICB8CiAgaWYgKHMtPmF4MjVfZGV2ID09IGF4MjVfZGV2
KSAgLy8oNCkgICAgfCAgIAogIC4uLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwKICAodGhlIGZvbGxvd2luZyBjb2RlIGNvdWxkIG5vdCBleGVjdXRlKSB8CgpGaXJzdGx5LCB3
ZSB1c2UgYXgyNV9iaW5kKCkgdG8gaW5jcmVhc2UgdGhlIHJlZmNvdW50IG9mIGF4MjVfZGV2IGlu
IApwb3NpdGlvbiAoMSkgYW5kIGluY3JlYXNlIHRoZSByZWZjb3VudCBvZiBuZXRfZGV2aWNlIGlu
IHBvc2l0aW9uICgyKS4KClRoZW4sIHdlIHVzZSBheDI1X2NiX2RlbCgpIGludm9rZWQgYnkgYXgy
NV9kZXN0cm95X3NvY2tldCgpCnRvIGRlbGV0ZSBheDI1X2NiIGluIGhsaXN0IGluIHBvc2l0aW9u
ICgzKSBiZWZvcmUgY2FsbGluZyBheDI1X2tpbGxfYnlfZGV2aWNlKCkuCiAKRmluYWxseSwgdGhl
IGRlY3JlbWVudHMgb2YgcmVmY291bnRzIGluIGF4MjVfa2lsbF9ieV9kZXZpY2UoKSB3aWxsIG5v
dCBiZSBleGVjdXRlZCwKYmVjYXVzZSBubyBzLT5heDI1X2RldiBlcXVhbHMgdG8gYXgyNV9kZXYg
aW4gcG9zaXRpb24gKDQpLgoKTXkgcGF0Y2ggYWRkcyB0d28gZmxhZ3MgaW4gYXgyNV9kZXYgaW4g
b3JkZXIgdG8gcHJldmVudCByZWZlcmVuY2UgY291bnQgbGVha3MuIApJZiB0aGUgYWJvdmUgY29u
ZGl0aW9uIGhhcHBlbnMsIHRoZSB0d28gInRlc3RfYml0IiBjaGVja3MgaW4gYXgyNV9raWxsX2J5
X2RldmljZSgpCmNvdWxkIHBhc3MgYW5kIHRoZSByZWZjb3VudHMgY291bGQgYmUgZGVjcmVhc2Vk
IHByb3Blcmx5LgoKPiBFdmVuIGlmIHdlIGdvIHdpdGggdGhpcyBhcHByb2FjaCAtPmtpbGxfZmxh
ZyBhbmQgLT5iaW5kX2ZsYWcgc2hvdWxkIGJlCj4gYm9vbGVhbnMuICBJdCBtYWtlcyBubyBzZW5z
ZSB0byBoYXZlIGEgdW5zaWduZWQgbG9uZyB3aGVyZSBvbmx5IEJJVCgyKQo+IGNhbiBiZSBzZXQu
CgpJIHdpbGwgY2hhbmdlIGtpbGxfZmxhZyBhbmQgYmluZF9mbGFnIHRvIGJvb2xlYW5zLgoKQmVz
dCB3aXNoZXMsCkR1b21pbmcgWmhvdQo=
