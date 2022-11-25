Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85818638EB7
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 18:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiKYRAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 12:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKYRAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 12:00:36 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DB921E1E;
        Fri, 25 Nov 2022 09:00:34 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 205995FD0D;
        Fri, 25 Nov 2022 20:00:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669395633;
        bh=Vy7tglWDZchkmeNCXURGl6jAA6MukTO4JV60RU6e8rs=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=ZBx3e+YVjbQtbi46YKkDQWvBmqPT20z0EnWtlbTjKyLN3gfeUylNxhzHdIe8RYt/g
         6hG5pXusrmzrn8lzCayTiUC5GISrJdu/a3YJwgerBXOVkGKfAes1R4GVKtbOF/kz2Q
         eZBh5CONIO4ytCeCgZNtO0sdzKnzm+fY1wxts2NDEXVb470sCBMVR0AHUmvAHla0KA
         hMY3c4L+auQZYmthTf/Q9nQvj3/0xSUb6xTI/HLaXDlnVAokkHjJE6nNJdqMMb6e8g
         gOG1xBp6BEo6lVJtoTaMiflEBZlyRJfXW+uN/utAc4U08oiKU4ysxonp6L/60qrrh5
         9je7u4SVF5ULw==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Fri, 25 Nov 2022 20:00:31 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Dexuan Cui" <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        "Arseniy Krasnov" <AVKrasnov@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v2 0/6] vsock: update tools and error handling
Thread-Topic: [RFC PATCH v2 0/6] vsock: update tools and error handling
Thread-Index: AQHZAO9tLgclKwOwKEaUfQ8774hEhw==
Date:   Fri, 25 Nov 2022 17:00:31 +0000
Message-ID: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <22F201B3173A6F4898FFFF72891F788A@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/25 14:59:00 #20610704
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGF0Y2hzZXQgY29uc2lzdHMgb2YgdHdvIHBhcnRzOg0KDQoxKSBLZXJuZWwgcGF0Y2hlcw0KVGhy
ZWUgcGF0Y2hlcyBmcm9tIEJvYmJ5IEVzaGxlbWFuLiBJIHRvb2sgc2luZ2xlIHBhdGNoIGZyb20g
Qm9iYnk6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2Q4MTgxOGI4NjgyMTZjNzc0NjEz
ZGQwMzY0MWZjZmU2M2NjNTVhNDUNCi4xNjYwMzYyNjY4LmdpdC5ib2JieS5lc2hsZW1hbkBieXRl
ZGFuY2UuY29tLyBhbmQgc3BsaXQgaXQgdG8gdGhyZWUNCnBhdGNoZXMgYWNjb3JkaW5nIGRpZmZl
cmVudCBwYXJ0cyBvZiB2c29jayBzdWJzeXN0ZW0uDQoNCkkgdXNlZCBpdCwgYmVjYXVzZSBmb3Ig
U09DS19TRVFQQUNLRVQgYmlnIG1lc3NhZ2VzIGhhbmRsaW5nIHdhcyBicm9rZW4gLQ0KRU5PTUVN
IHdhcyByZXR1cm5lZCBpbnN0ZWFkIG9mIEVNU0dTSVpFLiBBbmQgYW55d2F5LCBjdXJyZW50IGxv
Z2ljIHdoaWNoDQphbHdheXMgcmVwbGFjZXMgYW55IGVycm9yIGNvZGUgcmV0dXJuZWQgYnkgdHJh
bnNwb3J0IHRvIEVOT01FTSBsb29rcw0Kc3RyYW5nZSBmb3IgbWUgYWxzbyhmb3IgZXhhbXBsZSBp
biBFTVNHU0laRSBjYXNlIGl0IHdhcyBjaGFuZ2VkIHRvDQpFTk9NRU0pLiBTbywgb25lIG9mIHRo
cmVlIHBhdGNoZXMgdXBkYXRlcyBhZl92c29jay5jLCBrZWVwaW5nIGVycm9yDQpjb2RlIGZyb20g
dHJhbnNwb3J0IHVudG91Y2hlZCwgd2hpbGUgYW5vdGhlciAyIHBhdGNoZXMgc2F2ZSBvcmlnaW5h
bA0KYmVoYXZpb3VyIGZvciBIeXBlci1WIGFuZCBWTUNJLg0KDQpQbGVhc2UsIEh5cGVyLVYgYW5k
IFZNQ0kgZ3V5cywgY291bGQgWW91IHRha2UgYSBsb29rPyBJcyBwcmV2aW91cw0KYmVoYXZpb3Vy
IHJlYWxseSBuZWVkZWQ/DQoNCjIpIFRvb2wgcGF0Y2hlcw0KU2luY2UgdGhlcmUgaXMgd29yayBv
biBzZXZlcmFsIHNpZ25pZmljYW50IHVwZGF0ZXMgZm9yIHZzb2NrKHZpcnRpby8NCnZzb2NrIGVz
cGVjaWFsbHkpOiBza2J1ZmYsIERHUkFNLCB6ZXJvY29weSByeC90eCwgc28gSSB0aGluayB0aGF0
IHRoaXMNCnBhdGNoc2V0IHdpbGwgYmUgdXNlZnVsLg0KDQpUaGlzIHBhdGNoc2V0IHVwZGF0ZXMg
dnNvY2sgdGVzdHMgYW5kIHRvb2xzIGEgbGl0dGxlIGJpdC4gRmlyc3Qgb2YgYWxsDQppdCB1cGRh
dGVzIHRlc3Qgc3VpdGU6IHR3byBuZXcgdGVzdHMgYXJlIGFkZGVkLiBPbmUgdGVzdCBpcyByZXdv
cmtlZA0KbWVzc2FnZSBib3VuZCB0ZXN0LiBOb3cgaXQgaXMgbW9yZSBjb21wbGV4LiBJbnN0ZWFk
IG9mIHNlbmRpbmcgMSBieXRlDQptZXNzYWdlcyB3aXRoIG9uZSBNU0dfRU9SIGJpdCwgaXQgc2Vu
ZHMgbWVzc2FnZXMgb2YgcmFuZG9tIGxlbmd0aChvbmUNCmhhbGYgb2YgbWVzc2FnZXMgYXJlIHNt
YWxsZXIgdGhhbiBwYWdlIHNpemUsIHNlY29uZCBoYWxmIGFyZSBiaWdnZXIpDQp3aXRoIHJhbmRv
bSBudW1iZXIgb2YgTVNHX0VPUiBiaXRzIHNldC4gUmVjZWl2ZXIgYWxzbyBkb24ndCBrbm93IHRv
dGFsDQpudW1iZXIgb2YgbWVzc2FnZXMuIE1lc3NhZ2UgYm91bmRzIGNvbnRyb2wgaXMgbWFpbnRh
aW5lZCBieSBoYXNoIHN1bQ0Kb2YgbWVzc2FnZXMgbGVuZ3RoIGNhbGN1bGF0aW9uLiBTZWNvbmQg
dGVzdCBpcyBmb3IgU09DS19TRVFQQUNLRVQgLSBpdA0KdHJpZXMgdG8gc2VuZCBtZXNzYWdlIHdp
dGggbGVuZ3RoIG1vcmUgdGhhbiBhbGxvd2VkLiBJIHRoaW5rIGJvdGggdGVzdHMNCndpbGwgYmUg
dXNlZnVsIGZvciBER1JBTSBzdXBwb3J0IGFsc28uDQoNClRoaXJkIHRoaW5nIHRoYXQgdGhpcyBw
YXRjaHNldCBhZGRzIGlzIHNtYWxsIHV0aWxpdHkgdG8gdGVzdCB2c29jaw0KcGVyZm9ybWFuY2Ug
Zm9yIGJvdGggcnggYW5kIHR4LiBJIHRoaW5rIHRoaXMgdXRpbCBjb3VsZCBiZSB1c2VmdWwgYXMN
CidpcGVyZicsIGJlY2F1c2U6DQoxKSBJdCBpcyBzbWFsbCBjb21wYXJpbmcgdG8gJ2lwZXJmKCkn
LCBzbyBpdCB2ZXJ5IGVhc3kgdG8gYWRkIG5ldw0KICAgbW9kZSBvciBmZWF0dXJlIHRvIGl0KGVz
cGVjaWFsbHkgdnNvY2sgc3BlY2lmaWMpLg0KMikgSXQgaXMgbG9jYXRlZCBpbiBrZXJuZWwgc291
cmNlIHRyZWUsIHNvIGl0IGNvdWxkIGJlIHVwZGF0ZWQgYnkgdGhlDQogICBzYW1lIHBhdGNoc2V0
IHdoaWNoIGNoYW5nZXMgcmVsYXRlZCBrZXJuZWwgZnVuY3Rpb25hbGl0eSBpbiB2c29jay4NCg0K
SSB1c2VkIHRoaXMgdXRpbCB2ZXJ5IG9mdGVuIHRvIGNoZWNrIHBlcmZvcm1hbmNlIG9mIG15IHJ4
IHplcm9jb3B5DQpzdXBwb3J0KHRoaXMgdG9vbCBoYXMgcnggemVyb2NvcHkgc3VwcG9ydCwgYnV0
IG5vdCBpbiB0aGlzIHBhdGNoc2V0KS4NCg0KUGF0Y2hzZXQgd2FzIHJlYmFzZWQgYW5kIHRlc3Rl
ZCBvbiBza2J1ZmYgdjQgcGF0Y2ggZnJvbSBCb2JieSBFc2hsZW1hbjoNCmh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL25ldGRldi8yMDIyMTEyNDA2MDc1MC40ODIyMy0xLWJvYmJ5LmVzaGxlbWFuQGJ5
dGVkYW5jZS5jb20vDQoNCkNoYW5nZWxvZzoNCiB2MSAtPiB2MjoNCiAtIFRocmVlIG5ldyBwYXRj
aGVzIGZyb20gQm9iYnkgRXNobGVtYW4gdG8ga2VybmVsIHBhcnQNCiAtIE1lc3NhZ2UgYm91bmRz
IHRlc3Q6IHNvbWUgcmVmYWN0b3JpbmcgYW5kIGFkZCBjb21tZW50IHRvIGRlc2NyaWJlDQogICBo
YXNoaW5nIHB1cnBvc2UNCiAtIEJpZyBtZXNzYWdlIHRlc3Q6IGNoZWNrICdlcnJubycgZm9yIEVN
U0dTSVpFIGFuZCAgbW92ZSBuZXcgdGVzdCB0bw0KICAgdGhlIGVuZCBvZiB0ZXN0cyBhcnJheQ0K
IC0gdnNvY2tfcGVyZjoNCiAgIC0gdXBkYXRlIFJFQURNRSBmaWxlDQogICAtIGFkZCBzaW1wbGUg
dXNhZ2UgZXhhbXBsZSB0byBjb21taXQgbWVzc2FnZQ0KICAgLSB1cGRhdGUgJy1oJyAoaGVscCkg
b3V0cHV0DQogICAtIHVzZSAnc3Rkb3V0JyBmb3Igb3V0cHV0IGluc3RlYWQgb2YgJ3N0ZGVycicN
CiAgIC0gdXNlICdzdHJ0b2wnIGluc3RlYWQgb2YgJ2F0b2knDQoNCkJvYmJ5IEVzaGxlbWFuKDMp
Og0KIHZzb2NrOiByZXR1cm4gZXJyb3JzIG90aGVyIHRoYW4gLUVOT01FTSB0byBzb2NrZXQNCiBo
dl9zb2NrOiBhbHdheXMgcmV0dXJuIEVOT01FTSBpbiBjYXNlIG9mIGVycm9yDQogdnNvY2svdm1j
aTogYWx3YXlzIHJldHVybiBFTk9NRU0gaW4gY2FzZSBvZiBlcnJvcg0KDQpBcnNlbml5IEtyYXNu
b3YoMyk6DQogdGVzdC92c29jazogcmV3b3JrIG1lc3NhZ2UgYm91bmQgdGVzdA0KIHRlc3QvdnNv
Y2s6IGFkZCBiaWcgbWVzc2FnZSB0ZXN0DQogdGVzdC92c29jazogdnNvY2tfcGVyZiB1dGlsaXR5
DQoNCiBuZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgICAgICAgICB8ICAgMyArLQ0KIG5ldC92bXdf
dnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jIHwgICAyICstDQogbmV0L3Ztd192c29jay92bWNpX3Ry
YW5zcG9ydC5jICAgfCAgIDkgKy0NCiB0b29scy90ZXN0aW5nL3Zzb2NrL01ha2VmaWxlICAgICB8
ICAgMSArDQogdG9vbHMvdGVzdGluZy92c29jay9SRUFETUUgICAgICAgfCAgMzQgKysrKw0KIHRv
b2xzL3Rlc3RpbmcvdnNvY2svY29udHJvbC5jICAgIHwgIDI4ICsrKw0KIHRvb2xzL3Rlc3Rpbmcv
dnNvY2svY29udHJvbC5oICAgIHwgICAyICsNCiB0b29scy90ZXN0aW5nL3Zzb2NrL3V0aWwuYyAg
ICAgICB8ICAxMyArKw0KIHRvb2xzL3Rlc3RpbmcvdnNvY2svdXRpbC5oICAgICAgIHwgICAxICsN
CiB0b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3BlcmYuYyB8IDQwMCArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysNCiB0b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3Qu
YyB8IDE5MyArKysrKysrKysrKysrKysrKy0tDQogMTEgZmlsZXMgY2hhbmdlZCwgNjcwIGluc2Vy
dGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuMjUuMQ0K
