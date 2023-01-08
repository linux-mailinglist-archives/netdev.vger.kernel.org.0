Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC7166195F
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 21:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbjAHUfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 15:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjAHUfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 15:35:31 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B69AB4BD;
        Sun,  8 Jan 2023 12:35:26 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 775015FD02;
        Sun,  8 Jan 2023 23:35:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1673210122;
        bh=TCq52kcKV/J4zSTRILhb+Ziq3T6/w8ItLE2NuTjw30w=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=gFFaTQCSMMwWV2uZbPn2P7rdZLGBs6ravZ1KMbI1lK0Ug4iH9ybDog5vJWEz0GVGD
         qhX6NG7q0Q4tHiSyVc4Dzovyt3Zbc+5SiDVHQb756ltzZmBsR44M98JpCOXaN/ApYS
         zHfTZCZ+oLJ7U8rj0VE8dafNPGAiyRBdlklY45G7DcdrCT8LD8lflWN28K9hrb/EVf
         xeS2c2DSiNWxhvLY177MFZVECCUt4CoD4e1D10ogNnWVaiGVFoKcsjuc1s16+cCeJL
         qfEs3wZABmH1LZT6tZaPqqsICMoKdpRjxDTQEFM+ps5vyz1y1GuPTSobf7I2uGijYy
         iLvr6na5pSfXw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  8 Jan 2023 23:35:19 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [PATCH net-next v6 0/4] vsock: update tools and error handling
Thread-Topic: [PATCH net-next v6 0/4] vsock: update tools and error handling
Thread-Index: AQHZI6C4l/Z0Y69LvkeRvu+gUqG55w==
Date:   Sun, 8 Jan 2023 20:35:18 +0000
Message-ID: <9ad41d2b-bbe9-fe55-3aba-6a1281b6aa1b@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <345230C68B50354A937D4AE2EC5F3B85@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/01/08 17:38:00 #20747751
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGF0Y2hzZXQgY29uc2lzdHMgb2YgdHdvIHBhcnRzOg0KDQoxKSBLZXJuZWwgcGF0Y2gNCk9uZSBw
YXRjaCBmcm9tIEJvYmJ5IEVzaGxlbWFuLiBJIHRvb2sgc2luZ2xlIHBhdGNoIGZyb20gQm9iYnk6
DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2Q4MTgxOGI4NjgyMTZjNzc0NjEzZGQwMzY0
MWZjZmU2M2NjNTVhNDUNCi4xNjYwMzYyNjY4LmdpdC5ib2JieS5lc2hsZW1hbkBieXRlZGFuY2Uu
Y29tLyBhbmQgdXNlIG9ubHkgcGFydCBmb3INCmFmX3Zzb2NrLmMsIGFzIFZNQ0kgYW5kIEh5cGVy
LVYgcGFydHMgd2VyZSByZWplY3RlZC4NCg0KSSB1c2VkIGl0LCBiZWNhdXNlIGZvciBTT0NLX1NF
UVBBQ0tFVCBiaWcgbWVzc2FnZXMgaGFuZGxpbmcgd2FzIGJyb2tlbiAtDQpFTk9NRU0gd2FzIHJl
dHVybmVkIGluc3RlYWQgb2YgRU1TR1NJWkUuIEFuZCBhbnl3YXksIGN1cnJlbnQgbG9naWMgd2hp
Y2gNCmFsd2F5cyByZXBsYWNlcyBhbnkgZXJyb3IgY29kZSByZXR1cm5lZCBieSB0cmFuc3BvcnQg
dG8gRU5PTUVNIGxvb2tzDQpzdHJhbmdlIGZvciBtZSBhbHNvKGZvciBleGFtcGxlIGluIEVNU0dT
SVpFIGNhc2UgaXQgd2FzIGNoYW5nZWQgdG8NCkVOT01FTSkuDQoNCjIpIFRvb2wgcGF0Y2hlcw0K
U2luY2UgdGhlcmUgaXMgd29yayBvbiBzZXZlcmFsIHNpZ25pZmljYW50IHVwZGF0ZXMgZm9yIHZz
b2NrKHZpcnRpby8NCnZzb2NrIGVzcGVjaWFsbHkpOiBza2J1ZmYsIERHUkFNLCB6ZXJvY29weSBy
eC90eCwgc28gSSB0aGluayB0aGF0IHRoaXMNCnBhdGNoc2V0IHdpbGwgYmUgdXNlZnVsLg0KDQpU
aGlzIHBhdGNoc2V0IHVwZGF0ZXMgdnNvY2sgdGVzdHMgYW5kIHRvb2xzIGEgbGl0dGxlIGJpdC4g
Rmlyc3Qgb2YgYWxsDQppdCB1cGRhdGVzIHRlc3Qgc3VpdGU6IHR3byBuZXcgdGVzdHMgYXJlIGFk
ZGVkLiBPbmUgdGVzdCBpcyByZXdvcmtlZA0KbWVzc2FnZSBib3VuZCB0ZXN0LiBOb3cgaXQgaXMg
bW9yZSBjb21wbGV4LiBJbnN0ZWFkIG9mIHNlbmRpbmcgMSBieXRlDQptZXNzYWdlcyB3aXRoIG9u
ZSBNU0dfRU9SIGJpdCwgaXQgc2VuZHMgbWVzc2FnZXMgb2YgcmFuZG9tIGxlbmd0aChvbmUNCmhh
bGYgb2YgbWVzc2FnZXMgYXJlIHNtYWxsZXIgdGhhbiBwYWdlIHNpemUsIHNlY29uZCBoYWxmIGFy
ZSBiaWdnZXIpDQp3aXRoIHJhbmRvbSBudW1iZXIgb2YgTVNHX0VPUiBiaXRzIHNldC4gUmVjZWl2
ZXIgYWxzbyBkb24ndCBrbm93IHRvdGFsDQpudW1iZXIgb2YgbWVzc2FnZXMuIE1lc3NhZ2UgYm91
bmRzIGNvbnRyb2wgaXMgbWFpbnRhaW5lZCBieSBoYXNoIHN1bQ0Kb2YgbWVzc2FnZXMgbGVuZ3Ro
IGNhbGN1bGF0aW9uLiBTZWNvbmQgdGVzdCBpcyBmb3IgU09DS19TRVFQQUNLRVQgLSBpdA0KdHJp
ZXMgdG8gc2VuZCBtZXNzYWdlIHdpdGggbGVuZ3RoIG1vcmUgdGhhbiBhbGxvd2VkLiBJIHRoaW5r
IGJvdGggdGVzdHMNCndpbGwgYmUgdXNlZnVsIGZvciBER1JBTSBzdXBwb3J0IGFsc28uDQoNClRo
aXJkIHRoaW5nIHRoYXQgdGhpcyBwYXRjaHNldCBhZGRzIGlzIHNtYWxsIHV0aWxpdHkgdG8gdGVz
dCB2c29jaw0KcGVyZm9ybWFuY2UgZm9yIGJvdGggcnggYW5kIHR4LiBJIHRoaW5rIHRoaXMgdXRp
bCBjb3VsZCBiZSB1c2VmdWwgYXMNCidpcGVyZicvJ3VwZXJmJywgYmVjYXVzZToNCjEpIEl0IGlz
IHNtYWxsIGNvbXBhcmluZyB0byAnaXBlcmYnIG9yICd1cGVyZicsIHNvIGl0IHZlcnkgZWFzeSB0
byBhZGQNCiAgIG5ldyBtb2RlIG9yIGZlYXR1cmUgdG8gaXQoZXNwZWNpYWxseSB2c29jayBzcGVj
aWZpYykuDQoyKSBJdCBhbGxvd3MgdG8gc2V0IFNPX1JDVkxPV0FUIGFuZCBTT19WTV9TT0NLRVRT
X0JVRkZFUl9TSVpFIG9wdGlvbi4NCiAgIFdob2xlIHRocm91Z2h0cHV0IGRlcGVuZHMgb24gYm90
aCBwYXJhbWV0ZXJzLg0KMykgSXQgaXMgbG9jYXRlZCBpbiB0aGUga2VybmVsIHNvdXJjZSB0cmVl
LCBzbyBpdCBjb3VsZCBiZSB1cGRhdGVkIGJ5DQogICB0aGUgc2FtZSBwYXRjaHNldCB3aGljaCBj
aGFuZ2VzIHJlbGF0ZWQga2VybmVsIGZ1bmN0aW9uYWxpdHkgaW4gdnNvY2suDQoNCkkgdXNlZCB0
aGlzIHV0aWwgdmVyeSBvZnRlbiB0byBjaGVjayBwZXJmb3JtYW5jZSBvZiBteSByeCB6ZXJvY29w
eQ0Kc3VwcG9ydCh0aGlzIHRvb2wgaGFzIHJ4IHplcm9jb3B5IHN1cHBvcnQsIGJ1dCBub3QgaW4g
dGhpcyBwYXRjaHNldCkuDQoNCkhlcmUgaXMgY29tcGFyaXNvbiBvZiBvdXRwdXRzIGZyb20gdGhy
ZWUgdXRpbHM6ICdpcGVyZicsICd1cGVyZicgYW5kDQondnNvY2tfcGVyZicuIEluIGFsbCB0aHJl
ZSBjYXNlcyBzZW5kZXIgd2FzIGF0IGd1ZXN0IHNpZGUuIHJ4IGFuZA0KdHggYnVmZmVycyB3ZXJl
IGFsd2F5cyA2NEtiKGJlY2F1c2UgYnkgZGVmYXVsdCAndXBlcmYnIHVzZXMgOEspLg0KDQppcGVy
ZjoNCg0KICAgWyBJRF0gSW50ZXJ2YWwgICAgICAgICAgIFRyYW5zZmVyICAgICBCaXRyYXRlDQog
ICBbICA1XSAgIDAuMDAtMTAuMDAgIHNlYyAgMTIuOCBHQnl0ZXMgIDExLjAgR2JpdHMvc2VjIHNl
bmRlcg0KICAgWyAgNV0gICAwLjAwLTEwLjAwICBzZWMgIDEyLjggR0J5dGVzICAxMS4wIEdiaXRz
L3NlYyByZWNlaXZlcg0KDQp1cGVyZjoNCg0KICAgVG90YWwgICAgIDE2LjI3R0IgLyAgMTEuMzYo
cykgPSAgICAxMi4zMEdiL3MgICAgICAgMjM0NTVvcC9zDQoNCnZzb2NrX3BlcmY6DQoNCiAgIHR4
IHBlcmZvcm1hbmNlOiAxMi4zMDE1MjkgR2JpdHMvcw0KICAgcnggcGVyZm9ybWFuY2U6IDEyLjI4
ODAxMSBHYml0cy9zDQoNClJlc3VsdHMgYXJlIGFsbW9zdCBzYW1lIGluIGFsbCB0aHJlZSBjYXNl
cy4NCg0KUGF0Y2hzZXQgd2FzIHJlYmFzZWQgYW5kIHRlc3RlZCBvbiBza2J1ZmYgdjkgcGF0Y2gg
ZnJvbSBCb2JieSBFc2hsZW1hbjoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIz
MDEwNzAwMjkzNy44OTk2MDUtMS1ib2JieS5lc2hsZW1hbkBieXRlZGFuY2UuY29tLw0KDQpDaGFu
Z2Vsb2c6DQogdjUgLT4gdjY6DQogLSBSRkMgLT4gbmV0LW5leHQgdGFnDQogLSB2c29ja19wZXJm
Og0KICAgLSBmb3JnZXQgdG8gdXBkYXRlIFJFQURNRTogR2IvcyAtPiBHQml0cy9zDQoNCiB2NCAt
PiB2NToNCiAtIEtlcm5lbCBwYXRjaDogdXBkYXRlIGNvbW1pdCBtZXNzYWdlDQogLSB2c29ja19w
ZXJmOg0KICAgLSBGaXggdHlwbyBpbiBjb21taXQgbWVzc2FnZQ0KICAgLSBVc2UgImZwcmludGYo
c3RkZXJyLCIgaW5zdGVhZCBvZiAicHJpbnRmKCIgZm9yIGVycm9ycw0KICAgLSBNb3JlIHN0YXRz
IGZvciB0eDogdG90YWwgYnl0ZXMgc2VudCBhbmQgdGltZSBpbiB0eCBsb29wDQogICAtIFByaW50
IHRocm91Z2hwdXQgaW4gJ2dpZ2FiaXRzJyBpbnN0ZWFkIG9mICdnaWdhYnl0ZXMnKGFzIGluDQog
ICAgICdpcGVyZicgYW5kICd1cGVyZicpDQogICAtIE91dHB1dCBjb21wYXJpc29ucyBiZXR3ZWVu
ICdpcGVyZicsICd1cGVyZicgYW5kICd2c29ja19wZXJmJw0KICAgICBhZGRlZCB0byBDVi4NCg0K
IHYzIC0+IHY0Og0KIC0gS2VybmVsIHBhdGNoOiB1cGRhdGUgY29tbWl0IG1lc3NhZ2UgYnkgYWRk
aW5nIGVycm9yIGNhc2UgZGVzY3JpcHRpb24NCiAtIE1lc3NhZ2UgYm91bmRzIHRlc3Q6DQogICAt
IFR5cG8gZml4OiBzL2NvbnRvbHMvY29udHJvbHMNCiAgIC0gRml4IGVycm9yIG91dHB1dCBvbiAn
c2V0c29ja29wdCgpJ3MNCiAtIHZzb2NrX3BlcmY6DQogICAtIEFkZCAndnNvY2tfcGVyZicgdGFy
Z2V0IHRvICdhbGwnIGluIE1ha2VmaWxlDQogICAtIEZpeCBlcnJvciBvdXRwdXQgb24gJ3NldHNv
Y2tvcHQoKSdzDQogICAtIFN3YXAgc2VuZGVyL3JlY2VpdmVyIHJvbGVzOiBub3cgc2VuZGVyIGRv
ZXMgJ2Nvbm5lY3QoKScgYW5kIHNlbmRzDQogICAgIGRhdGEsIHdoaWxlIHJlY2VpdmVyIGFjY2Vw
dHMgY29ubmVjdGlvbi4NCiAgIC0gVXBkYXRlIGFyZ3VtZW50cyBuYW1lczogcy9tYi9ieXRlcywg
cy9zb19yY3Zsb3dhdC9yY3Zsb3dhdA0KICAgLSBVcGRhdGUgdXNhZ2Ugb3V0cHV0IGFuZCBkZXNj
cmlwdGlvbiBpbiBSRUFETUUNCg0KIHYyIC0+IHYzOg0KIC0gUGF0Y2hlcyBmb3IgVk1DSSBhbmQg
SHlwZXItViB3ZXJlIHJlbW92ZWQgZnJvbSBwYXRjaHNldChjb21tZW50ZWQgYnkNCiAgIFZpc2hu
dSBEYXNhIGFuZCBEZXh1YW4gQ3VpKQ0KIC0gSW4gbWVzc2FnZSBib3VuZHMgdGVzdCBoYXNoIGlz
IGNvbXB1dGVkIGZyb20gZGF0YSBidWZmZXIgd2l0aCByYW5kb20NCiAgIGNvbnRlbnQoaW4gdjIg
aXQgd2FzIHNpemUgb25seSkuIFRoaXMgYXBwcm9hY2ggY29udHJvbHMgYm90aCBkYXRhDQogICBp
bnRlZ3JpdHkgYW5kIG1lc3NhZ2UgYm91bmRzLg0KIC0gdnNvY2tfcGVyZjoNCiAgIC0gZ3JhbW1h
ciBmaXhlcw0KICAgLSBvbmx5IGxvbmcgcGFyYW1ldGVycyBzdXBwb3J0ZWQoaW5zdGVhZCBvZiBv
bmx5IHNob3J0KQ0KDQogdjEgLT4gdjI6DQogLSBUaHJlZSBuZXcgcGF0Y2hlcyBmcm9tIEJvYmJ5
IEVzaGxlbWFuIHRvIGtlcm5lbCBwYXJ0DQogLSBNZXNzYWdlIGJvdW5kcyB0ZXN0OiBzb21lIHJl
ZmFjdG9yaW5nIGFuZCBhZGQgY29tbWVudCB0byBkZXNjcmliZQ0KICAgaGFzaGluZyBwdXJwb3Nl
DQogLSBCaWcgbWVzc2FnZSB0ZXN0OiBjaGVjayAnZXJybm8nIGZvciBFTVNHU0laRSBhbmQgIG1v
dmUgbmV3IHRlc3QgdG8NCiAgIHRoZSBlbmQgb2YgdGVzdHMgYXJyYXkNCiAtIHZzb2NrX3BlcmY6
DQogICAtIHVwZGF0ZSBSRUFETUUgZmlsZQ0KICAgLSBhZGQgc2ltcGxlIHVzYWdlIGV4YW1wbGUg
dG8gY29tbWl0IG1lc3NhZ2UNCiAgIC0gdXBkYXRlICctaCcgKGhlbHApIG91dHB1dA0KICAgLSB1
c2UgJ3N0ZG91dCcgZm9yIG91dHB1dCBpbnN0ZWFkIG9mICdzdGRlcnInDQogICAtIHVzZSAnc3Ry
dG9sJyBpbnN0ZWFkIG9mICdhdG9pJw0KDQpCb2JieSBFc2hsZW1hbigxKToNCiB2c29jazogcmV0
dXJuIGVycm9ycyBvdGhlciB0aGFuIC1FTk9NRU0gdG8gc29ja2V0DQoNCkFyc2VuaXkgS3Jhc25v
digzKToNCiB0ZXN0L3Zzb2NrOiByZXdvcmsgbWVzc2FnZSBib3VuZCB0ZXN0DQogdGVzdC92c29j
azogYWRkIGJpZyBtZXNzYWdlIHRlc3QNCiB0ZXN0L3Zzb2NrOiB2c29ja19wZXJmIHV0aWxpdHkN
Cg0KIG5ldC92bXdfdnNvY2svYWZfdnNvY2suYyAgICAgICAgIHwgICAzICstDQogdG9vbHMvdGVz
dGluZy92c29jay9NYWtlZmlsZSAgICAgfCAgIDMgKy0NCiB0b29scy90ZXN0aW5nL3Zzb2NrL1JF
QURNRSAgICAgICB8ICAzNCArKysNCiB0b29scy90ZXN0aW5nL3Zzb2NrL2NvbnRyb2wuYyAgICB8
ICAyOCArKysNCiB0b29scy90ZXN0aW5nL3Zzb2NrL2NvbnRyb2wuaCAgICB8ICAgMiArDQogdG9v
bHMvdGVzdGluZy92c29jay91dGlsLmMgICAgICAgfCAgMTMgKysNCiB0b29scy90ZXN0aW5nL3Zz
b2NrL3V0aWwuaCAgICAgICB8ICAgMSArDQogdG9vbHMvdGVzdGluZy92c29jay92c29ja19wZXJm
LmMgfCA0NDEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQogdG9vbHMv
dGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCAxOTcgKysrKysrKysrKysrKysrLS0NCiA5IGZp
bGVzIGNoYW5nZWQsIDcwNSBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkNCg0KLS0gDQoy
LjI1LjENCg==
