Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D5C5F1E5C
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 19:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiJARQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 13:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJARQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 13:16:14 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90057.outbound.protection.outlook.com [40.107.9.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6142B6112F
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 10:16:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1BSJf78mQcKZOVewSrcWjqRXJl3Qk5eYnvxnnHG8Id7VTNt8JYrwMMEhVZvWS7x2FL3POPeL0I9qh5C/6fuT6xxEofkgkVybQ5sg4he0ftdgpujQEyDggwiAYg8g8gsy7R+TnWbfSi4HHx96iOdtMbe+NZ3R2BbsbeagGrxXEfYwGqVFnX2tccK8BhP+XdxSzmsAMBj2pGn9I3tPe9aDkz9tRtSiAUR6TX20zqehTIJsXwK0cyMJURWOffZymPKpn9rd3tFaip4H9YfjweTnO0FSyjlXkfmx9w1S7TlZyQjIS8luPvVszr+DoqIHakN3qptUujsTrfpSn1swKeAeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0KCewFJxUMWV89rVL6tXAJFHAzbItLq3B+xX7/iENg=;
 b=oL/rNQeLkPB5yvQ9DYR4QXuJXPjFKN1CU8DUkb/swuAFKqz9zY6lqpUhyE8gMhV4tupvA+raYepOv/ZXWgm7nEja2+r56Nj3Zz95a1sI3aGCfI2RX8xW35oAwwWUJY6vBLUD5qYHmrHXIvh65SVjxQEumSeQHf2HmJ/QNqfXFxqqnKW7gzV54jNaK1/7LCtR2OWkDs30guV+U7g9NoEzPu1ECMiZdJibYt+aRq1A19IWbzyK7+s+fEW7HkP/ETpwr4ed7slBFfgunUsB3v1r/Rj7jr7ghGV8cvQlyjUF4N46DIfHOyt6vhtds09rojOEhsTfHmKbunro90vegcbrKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0KCewFJxUMWV89rVL6tXAJFHAzbItLq3B+xX7/iENg=;
 b=3nJpFt1Ehm29xRvrusBrVrn+ONzS2UpNp0ht2ZkpAuMmnY/j7McKJnQ0sHT0xX+bZHydTKvcfgGbdp7lZ40yp4xTE4eJs8huHS1XUDZtXwFxtlb09yZa4Is9T7NtdQdWA1qgrhmu7/Oqx2NHnxan1K08rCyeURfPCVS4l5Klit3KVNsC7oUeJ4/ETxMYcERLH67pFoHru4gZgvZ8t6qDs3GczAPvBBoTlubrIEAvdrM67yTLuCicUqxMoxbsLxGUUUgnPXx2EH1xs/VV9R5STCuSE7QDP2TXp/zwa7DxgWFe+Zxys6b+6BrwWFtCZlH4C38blhWQZMhaMWyx23dA0A==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB3189.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 17:16:08 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c854:380d:c901:45af]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c854:380d:c901:45af%5]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 17:16:08 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>
CC:     "David S. Miller" <davem@davemloft.net>
Subject: 126 ms irqsoff Latency - Possibly due to commit 190cc82489f4 ("tcp:
 change source port randomizarion at connect() time")
Thread-Topic: 126 ms irqsoff Latency - Possibly due to commit 190cc82489f4
 ("tcp: change source port randomizarion at connect() time")
Thread-Index: AQHY1bl+lRKJey/M40yxzWKFMR9yPA==
Date:   Sat, 1 Oct 2022 17:16:08 +0000
Message-ID: <03a06114-bc63-bc01-be38-535bcc394612@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR0P264MB3189:EE_
x-ms-office365-filtering-correlation-id: e85678b5-1b99-4de3-5b9d-08daa3d0a16c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xdbRhR/63vr5+nl76IqcizsrNm20VK9VMmpcIOmMQkTIbJ9fbycI8AT7D/V9MRAWauzm9CtTilOa9YcVewJX74Po8k6bb5JcAIQaPYbdYQIvzX8jatzQu44Rp/T6U+GMGwwC2GJqpcu2zffr10Ix6tV8/GYQplZghCdran8M00Od1QaNvIENsUU1TCRUTK7dh6RaaHeQKq/QycTJYsAoALM0ETo7XYCt5V6SBRkN3C++/3nzNJ8ps1XO8AjT5qWqDXGVtmETgMZDTsIDjKXO+vJiukkjnsjbVMNfBaXaFd1uTXcqtzkAJFjpS3eh4HUofYXIgPUdLCxnkQ+BqJr/VpWu2BHyETVFOcOqJBePScQF9gm2QyPBI+2BMyD+sfNutDsSuRQXB2nCCrFuOWp96cuCTM2vfpvzzpbf92gij6flyBWFwmfgqNVpPmGK88to7JZVyA64S1HdkZ83YK883FQGo1iOaH/zLxNjrWelM9bWWBpyJclW4MPzUFNwRtkRnuBf4PmtjsOlquY4gHy3o2V35kXBboSXeSBQThg5+QJiXHLZjBsO5fNtjgN1I42MvBVzr9OANH9/mXLpeO5TG+HLuUssatTuG5sfwCJhN5F9uALKLlvmEHscW5jft7Inw2erC/JgCQ8CTK1sl3Zuhcq0ImZXjVIXXJvpcdwB/2/aoRh/FoKoMqYUVXL8a9e/fo8d81QcWK3smoBasTgzeo6V4tduWFRMd7jFZhu0qud504fzItygCfcu7BNaY6o3bxM0PRpdvheMEybJk5+wBZHwtui5L+7GRanj3I3196vjXCcSp//XByj83WWnhwEaiGyrkenlB9tG8abRDTK8Xw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39840400004)(346002)(376002)(136003)(366004)(451199015)(66446008)(41300700001)(66946007)(66556008)(76116006)(64756008)(66476007)(91956017)(4326008)(2906002)(5660300002)(8936002)(44832011)(8676002)(6512007)(26005)(110136005)(6506007)(478600001)(316002)(6486002)(71200400001)(36756003)(86362001)(31686004)(38070700005)(31696002)(83380400001)(186003)(2616005)(38100700002)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uzl1Q1VPd1Npdk1xMFIxQndkSVpYaWM0RXNmWGFEd3JTWEQraGtDam40R2VU?=
 =?utf-8?B?dlZEeHpCTTRvT04zU1UvTW9Gc0F1L3k0b3RWNUdadXVDUkN2SGw1ajB5ejFi?=
 =?utf-8?B?WkpXd2JQem9rZjR6cGlnRVVFaGFqNkZYbkt4ZkFqRVY2enZFUmJ2Q2pUU3NY?=
 =?utf-8?B?a3RmYklaL3hnS2FxT25YeDZoSHJHbllnRUU4cVRIdkRUb052dzFFRmJkeGZp?=
 =?utf-8?B?NVViaGhPRHR4S2g3SmtrMlhSVHJObzBpcEs3cHkyVnZsOUJqUnFZaGhQRHUx?=
 =?utf-8?B?S2tUdXZYbytjZmM1U1pjVndBYWh2d0Q0aEIrQ3JhMzBWZlp0KzdQVndUZXRX?=
 =?utf-8?B?S0FwbHdGcmtndS9sOU4rNGprbC9EK3picm5VK0EwcldZSjZ0c1kzY25FdUFa?=
 =?utf-8?B?d0xEdFNSUjk4ZmoxQlRYSHNUQ3UxdzRod3V1citwcmhwdU9Ga0N5dXdSdE41?=
 =?utf-8?B?d05ONEljbFV0Si83dkNjdU4rQkl2MGo3WW9EcVN3Y29NTFFsajNZbTV5aFh3?=
 =?utf-8?B?a3FwckNQVWphVDlNU1dlWU9vZjJLQXgvUzV2aVFiU1FTYVRhQU43a1RneUl6?=
 =?utf-8?B?SEZ6L0w4c2tpbUY5bnhMTzJ0ZG1ubWROL0lxSzhFTDlOKy9iT3I5cHUwSmw3?=
 =?utf-8?B?MlU1TlNmcFU4eUJpeEZTKy9MUzM2eDdYd1B1WHljZGU3aFV4eDJhMHRhalEz?=
 =?utf-8?B?YlQzMk5EbHdVSHZkZ0hkZGpEZnppYzJwRlJwK01YeWVQSFVFajlsMTRLcjhp?=
 =?utf-8?B?cm1mRXFEM3pkT0QyWnVSNHZNRUllZkJDdWtEUWhrVjFlS0ZkNGNkMHJnaVBl?=
 =?utf-8?B?SlBPb0FmTzNjTndFTFMwWnh2Z0ZVN0Z2Y0xEaEpNZytUQmdSUW1yU1ZMSGxG?=
 =?utf-8?B?NFh3R2w2dVEzbUFFVUtDby9RT2pleEcxcFNaWURYSWVwRlBUMXJJNS80L3o4?=
 =?utf-8?B?S0diWVhyck1OWkJJTTRDRklDL2RKZStObk1WTXpNWGJ1eHVMVGRHd3psS0Fk?=
 =?utf-8?B?MC9jYjlkTElRUmpsR2owS2g4ZzFVRFFGYzBFWFRoUGhqRVV3d1hTWEhqZ2JU?=
 =?utf-8?B?Mit3NllrMU9POGY5YlJCQjdQL00zdkI3cFhUK1VkUnVpUUIvQXlZbFVyM0hp?=
 =?utf-8?B?NFpqY09KSGZ0YzMxNmp3Z2VVZE1SamFnZWQvZUt2SVFKYU94RjJJL3dWeU9V?=
 =?utf-8?B?WERiR1djY0RMdWx3NG8xQkl3aUQ1QTNJWXczdHFLOVE4bWJBMTlmT3NPSmNj?=
 =?utf-8?B?Z3JHdUlpcHdSZDg3WllHVG5vM1gvQUFvRjJJNCt4QjdBWSt1WU0xVkhWM0d5?=
 =?utf-8?B?TjZmNGk1MklSZGl3K1luU3VLK0V5UzYybnJNQXNTYkZrcmNRcWtkcGxFTXps?=
 =?utf-8?B?dVRxcW9WU2daS2tyb1dibXNyRG5VY1pBWE01cUUzVFVSUDJqclE1SXhKRHpM?=
 =?utf-8?B?VmNQRGNMMXdZRkE4TXJjUEJWdXE2bEVZOHF6dHk2VTRRM2ZZMFcwcXI0RmVk?=
 =?utf-8?B?Sy9NUkpxVmxxRkhLdFBFcHZYTXNyUEQ4bnlmTzNUR0pEV2daZm5jSlVPcit3?=
 =?utf-8?B?NGNmZ0pyNXJTSkl5NDFQcU5JWVZJc2pxOHh4RmlpRDl1UGwxcEMwTEh4TEFl?=
 =?utf-8?B?NjNPSVdJWThmaVgxL0VXQzFvL1JNczlBTU5jdEJSNVdISjZIK2dHUjBMNURH?=
 =?utf-8?B?eWsvc25iNklxVWJmbEQ3U1hLOHg0VGYyM1VXb3F1MzZIcWdUSGdzNlpjY1pN?=
 =?utf-8?B?L05uemJsOWY1blFPUDNoL3VGZlUwS1h3UDlaa2RiSUVXTHc0R2ZkeldqaVVC?=
 =?utf-8?B?MXFZbDJLZ0poNFpYY2NnOWJ1YjMybEpkVVJ3T09KR0ZsRWVGcDJ6bWNyK3ZB?=
 =?utf-8?B?eTNRa1hOZEx4WnpBK1BNMDZJVDc1L1BNWmRQR2tOWXZGVm5KTTBxRjBOd0tT?=
 =?utf-8?B?RWNIRkFkZGlBVkYxUTlKcEF1NkJMS0t6U2hFQUY1cHpzMzRObjlOd2RqeWxF?=
 =?utf-8?B?K05FVEpFQm92UXA5aTNzWW0xNER6UDNKdEVWekt5eXZTekc0TXJoaTlPcU9t?=
 =?utf-8?B?bksxcHUxdzZTQUJUbVM5TnhYVS9JeS9JQ1dDKzdOd0ZJYjdVWjBSbUlwMENG?=
 =?utf-8?B?S25rdVEwN3RiYm9sRU5rK29MMHZIaE82WFh4V1krTmVXRnY2Q1ozTENHS0Uz?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <697720F6C8DB0D4786F54B68B599EC8B@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e85678b5-1b99-4de3-5b9d-08daa3d0a16c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2022 17:16:08.2948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rveeViZ4f4f0bk11btFapq78tdp3ow++iIdsnYCJ6NJN9pJ5w/KqXprt+pPq2UgwPoFJ3PDtbPRavRRk4RdqK2HRuolOt5KCKOyY+j6/Few=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3189
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCldpdGggcmVjZW50IGtlcm5lbHMgSSBoYXZlIGEgaHVnZSBpcnFzb2ZmIGxhdGVuY3kg
aW4gbXkgYm9hcmRzLCBzaG9ydGx5IA0KYWZ0ZXIgc3RhcnR1cCwgZnJvbSB0aGUgY2FsbCB0byBu
ZXRfZ2V0X3JhbmRvbV9vbmNlKCkgaW4gDQpfX2luZXRfaGFzaF9jb25uZWN0KCkuDQoNCk9uIGEg
bm9uIGluc3RydW1lbnRlZCBrZXJuZWwsIElSUXMgYXJlIGRpc2FibGVkIGR1cmluZyBhcHByb3hp
bWF0ZWx5IDgwIA0KbWlsbGlzZWNvbmRzLiBXaXRoIHRoZSB0cmFjZXMgaW4gZ29lcyB0byAxMjYg
bWlsbGlzZWNvbmRzLg0KDQpXYXMgYXBwYXJlbnRseSBpbnRyb2R1Y2VkIGJ5IGNvbW1pdCAxOTBj
YzgyNDg5ZjQgKCJ0Y3A6IGNoYW5nZSBzb3VyY2UgDQpwb3J0IHJhbmRvbWl6YXJpb24gYXQgY29u
bmVjdCgpIHRpbWUiKQ0KDQpUcmFjZSBiZWxvdy4NCg0KV291bGQgdGhlcmUgYmUgYSB3YXkgdG8g
cGVyZm9ybSB0aGUgY2FsbCB0byBnZXRfcmFuZG9tX2J5dGVzKCkgd2l0aG91dCANCmRpc2FibGlu
ZyBJUlEgPw0KDQpUaGFua3MNCkNocmlzdG9waGUNCg0KIyB0cmFjZXI6IGlycXNvZmYNCiMNCiMg
aXJxc29mZiBsYXRlbmN5IHRyYWNlIHYxLjEuNSBvbiA2LjAuMC1yYzUtczNrLWRldi0wMjM1MS1n
ZWJjOTVmNjlhN2Q0DQojIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQojIGxhdGVuY3k6IDEyNjMzNyB1cywgIzgyMDcv
ODIwNywgQ1BVIzAgfCAoTTpwcmVlbXB0IFZQOjAsIEtQOjAsIFNQOjAgSFA6MCkNCiMgICAgLS0t
LS0tLS0tLS0tLS0tLS0NCiMgICAgfCB0YXNrOiBDT1JTdXJ2LTM1MiAodWlkOjAgbmljZTowIHBv
bGljeTowIHJ0X3ByaW86MCkNCiMgICAgLS0tLS0tLS0tLS0tLS0tLS0NCiMgID0+IHN0YXJ0ZWQg
YXQ6IF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUNCiMgID0+IGVuZGVkIGF0OiAgIF9yYXdfc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZQ0KIw0KIw0KIyAgICAgICAgICAgICAgICAgICAgXy0tLS0tLT0+IENQ
VSMNCiMgICAgICAgICAgICAgICAgICAgLyBfLS0tLS09PiBpcnFzLW9mZi9CSC1kaXNhYmxlZA0K
IyAgICAgICAgICAgICAgICAgIHwgLyBfLS0tLT0+IG5lZWQtcmVzY2hlZA0KIyAgICAgICAgICAg
ICAgICAgIHx8IC8gXy0tLT0+IGhhcmRpcnEvc29mdGlycQ0KIyAgICAgICAgICAgICAgICAgIHx8
fCAvIF8tLT0+IHByZWVtcHQtZGVwdGgNCiMgICAgICAgICAgICAgICAgICB8fHx8IC8gXy09PiBt
aWdyYXRlLWRpc2FibGUNCiMgICAgICAgICAgICAgICAgICB8fHx8fCAvICAgICBkZWxheQ0KIyAg
Y21kICAgICBwaWQgICAgIHx8fHx8fCB0aW1lICB8ICAgY2FsbGVyDQojICAgICBcICAgLyAgICAg
ICAgfHx8fHx8ICBcICAgIHwgICAgLw0KICBDT1JTdXJ2LTM1MiAgICAgICAwZC4uLi4gICAgNHVz
IDogX3Jhd19zcGluX2xvY2tfaXJxc2F2ZQ0KICBDT1JTdXJ2LTM1MiAgICAgICAwZC4uLi4gICAx
M3VzKzogcHJlZW1wdF9jb3VudF9hZGQgDQo8LV9yYXdfc3Bpbl9sb2NrX2lycXNhdmUNCiAgQ09S
U3Vydi0zNTIgICAgICAgMGQuLjEuICAgMjV1cys6IGRvX3Jhd19zcGluX2xvY2sgDQo8LV9yYXdf
c3Bpbl9sb2NrX2lycXNhdmUNCiAgQ09SU3Vydi0zNTIgICAgICAgMGQuLjEuICAgMzZ1cyA6IGdl
dF9yYW5kb21fYnl0ZXMgPC1fX2luZXRfaGFzaF9jb25uZWN0DQogIENPUlN1cnYtMzUyICAgICAg
IDBkLi4xLiAgIDQ1dXMgOiBfZ2V0X3JhbmRvbV9ieXRlcy5wYXJ0LjAgDQo8LV9faW5ldF9oYXNo
X2Nvbm5lY3QNCiAgQ09SU3Vydi0zNTIgICAgICAgMGQuLjEuICAgNTV1cyA6IGNybmdfbWFrZV9z
dGF0ZSANCjwtX2dldF9yYW5kb21fYnl0ZXMucGFydC4wDQogIENPUlN1cnYtMzUyICAgICAgIDBk
Li4xLiAgIDY1dXMrOiBrdGltZV9nZXRfc2Vjb25kcyA8LWNybmdfbWFrZV9zdGF0ZQ0KICBDT1JT
dXJ2LTM1MiAgICAgICAwZC4uMS4gICA3N3VzKzogY3JuZ19mYXN0X2tleV9lcmFzdXJlIDwtY3Ju
Z19tYWtlX3N0YXRlDQogIENPUlN1cnYtMzUyICAgICAgIDBkLi4xLiAgIDg5dXMrOiBjaGFjaGFf
YmxvY2tfZ2VuZXJpYyANCjwtY3JuZ19mYXN0X2tleV9lcmFzdXJlDQogIENPUlN1cnYtMzUyICAg
ICAgIDBkLi4xLiAgMTAxdXMrOiBjaGFjaGFfcGVybXV0ZSA8LWNoYWNoYV9ibG9ja19nZW5lcmlj
DQogIENPUlN1cnYtMzUyICAgICAgIDBkLi4xLiAgMTI5dXMgOiBjaGFjaGFfYmxvY2tfZ2VuZXJp
YyANCjwtX2dldF9yYW5kb21fYnl0ZXMucGFydC4wDQogIENPUlN1cnYtMzUyICAgICAgIDBkLi4x
LiAgMTM5dXMrOiBjaGFjaGFfcGVybXV0ZSA8LWNoYWNoYV9ibG9ja19nZW5lcmljDQogIENPUlN1
cnYtMzUyICAgICAgIDBkLi4xLiAgMTYwdXMgOiBjaGFjaGFfYmxvY2tfZ2VuZXJpYyANCjwtX2dl
dF9yYW5kb21fYnl0ZXMucGFydC4wDQogIENPUlN1cnYtMzUyICAgICAgIDBkLi4xLiAgMTcwdXMr
OiBjaGFjaGFfcGVybXV0ZSA8LWNoYWNoYV9ibG9ja19nZW5lcmljDQogIENPUlN1cnYtMzUyICAg
ICAgIDBkLi4xLiAgMTkxdXMgOiBjaGFjaGFfYmxvY2tfZ2VuZXJpYyANCjwtX2dldF9yYW5kb21f
Ynl0ZXMucGFydC4wDQogIENPUlN1cnYtMzUyICAgICAgIDBkLi4xLiAgMjAwdXMrOiBjaGFjaGFf
cGVybXV0ZSA8LWNoYWNoYV9ibG9ja19nZW5lcmljDQogIENPUlN1cnYtMzUyICAgICAgIDBkLi4x
LiAgMjIxdXMgOiBjaGFjaGFfYmxvY2tfZ2VuZXJpYyANCjwtX2dldF9yYW5kb21fYnl0ZXMucGFy
dC4wDQogIENPUlN1cnYtMzUyICAgICAgIDBkLi4xLiAgMjMxdXMrOiBjaGFjaGFfcGVybXV0ZSA8
LWNoYWNoYV9ibG9ja19nZW5lcmljDQoNCgk4MTgyIHggdGhlIGFib3ZlIHR3byBsaW5lDQoNCiAg
Q09SU3Vydi0zNTIgICAgICAgMGQuLjEuIDEyNjI3NXVzIDogY2hhY2hhX2Jsb2NrX2dlbmVyaWMg
DQo8LV9nZXRfcmFuZG9tX2J5dGVzLnBhcnQuMA0KICBDT1JTdXJ2LTM1MiAgICAgICAwZC4uMS4g
MTI2Mjg1dXMrOiBjaGFjaGFfcGVybXV0ZSA8LWNoYWNoYV9ibG9ja19nZW5lcmljDQogIENPUlN1
cnYtMzUyICAgICAgIDBkLi4xLiAxMjYzMDl1cyA6IF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSANCjwtX19kb19vbmNlX2RvbmUNCiAgQ09SU3Vydi0zNTIgICAgICAgMGQuLjEuIDEyNjMxOHVz
KzogZG9fcmF3X3NwaW5fdW5sb2NrIA0KPC1fcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUNCiAg
Q09SU3Vydi0zNTIgICAgICAgMGQuLjEuIDEyNjMzMHVzKzogX3Jhd19zcGluX3VubG9ja19pcnFy
ZXN0b3JlDQogIENPUlN1cnYtMzUyICAgICAgIDBkLi4xLiAxMjYzNDZ1cys6IHRyYWNlX2hhcmRp
cnFzX29uIA0KPC1fcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUNCiAgQ09SU3Vydi0zNTIgICAg
ICAgMGQuLjEuIDEyNjM4N3VzIDogPHN0YWNrIHRyYWNlPg0KICA9PiB0Y3BfdjRfY29ubmVjdA0K
ICA9PiBfX2luZXRfc3RyZWFtX2Nvbm5lY3QNCiAgPT4gaW5ldF9zdHJlYW1fY29ubmVjdA0KICA9
PiBfX3N5c19jb25uZWN0DQogID0+IHN5c3RlbV9jYWxsX2V4Y2VwdGlvbg0KICA9PiByZXRfZnJv
bV9zeXNjYWxs
