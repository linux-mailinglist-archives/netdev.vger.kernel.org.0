Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0174690621
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBILK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBILKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:10:25 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2109.outbound.protection.outlook.com [40.107.6.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E0611647
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 03:10:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWM6WNAE3/DzBk8H52Bo9+intZ7FXeUjNEQB929v254KECSXhalV8TX5NnxR+5vhDF4JOv2vz2uDhMtvKg80TQW7mxD/p5Hr45QDs28Y6ubglslLhHR9hcXH1FrhKJVCyG8OKMXrIS4QyI1BK/kT6tifBtvefP2pGPnthkWUXD1FzWsjYvaRZB2swRrdv3XyjcUNDixhb2pYd+XhUB7qowS8Q7DkHfLDALqAHTGR+D7Oapxw6gHxFGp/AIrLcu9hp8ixN2S9BZLtzGBu9w8lPgEEHIiRgAzwRdTBPK3cmfSJ6YWkeOqCUl6G+Bj36jRst03wkvefrEwhqEEwlyoBLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vl+E3WUWfQS54bQ/qMEycqStubTMCMDhTLPRcoS6/Hc=;
 b=LpKWgizDdXvptDh3mqXLirQbDlGWRnfaArBr2+9N/26rx6wTqOOhcJ6lh7vzNdPOYi+y07VoSabUu/fNOmGWf08V4/DJtGHBqCRi3gjKBomV53VLL0zZnL2fx8BNlDGbx8QSQZ5e97gTgeK77/O/hHDHdyhohPMR5la/wxK4G0e+h8v7DvlCPppri49P7cDMh7UPeS+GRbAmzc+VvLjEjEv1Shz7+k09rkv6bQV+NHOJhYnDdOanxQLzMfNYz1sF7BTzzvMK5x622FeXBaRk7s0BsWXAHWt7NH8yTlcxQeUc8fUgUgbMYL8+pz6rdV1lH+Z3nw5D1WwcWaK/BLVwag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vl+E3WUWfQS54bQ/qMEycqStubTMCMDhTLPRcoS6/Hc=;
 b=XQbSO0bkz+G5Q0LFd4eGU/pYK2s7vVWqJtOB7YCumRomA6IH+7JO1Q1XBHxVB7VfnI10d3/TfLGk5ElYLID3CQ1RQqeaOJeXRhzpq3dXMMbaQPyRaYXosqeBSLonlPYPWaaPDvF+Sq9pWBxqttUtgHToV4HbS6J37tVOLoCtV2Q=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by PA4PR05MB9537.eurprd05.prod.outlook.com (2603:10a6:102:26a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Thu, 9 Feb
 2023 11:10:17 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4%3]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 11:10:16 +0000
From:   Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com" 
        <syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com>
Subject: RE: [PATCH v2 net 1/1] tipc: fix kernel warning when sending SYN
 message
Thread-Topic: [PATCH v2 net 1/1] tipc: fix kernel warning when sending SYN
 message
Thread-Index: AQHZO4wkQ0Q1caB6ZUahNZVZ+KhuCq7GbkcAgAAGXWA=
Date:   Thu, 9 Feb 2023 11:10:16 +0000
Message-ID: <DB9PR05MB907893AE1AECD3CA1F91D40F88D99@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20230208070759.462019-1-tung.q.nguyen@dektech.com.au>
 <b36e496792de3d1811ea38f19588e5a5b32a9d2c.camel@redhat.com>
In-Reply-To: <b36e496792de3d1811ea38f19588e5a5b32a9d2c.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|PA4PR05MB9537:EE_
x-ms-office365-filtering-correlation-id: cc464afc-f6a8-40e6-9d69-08db0a8e396c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6R0JcF/da40GyVoqpx1i5swRQCzVwGW4tBbmEzs4HLNUEznJIYCahpxM5hpwXSwiVqMzLiBM8ANSUSppN1tHFHtlwbCJOf0O1kkLJmSiQuklbEkgZHchdsCGnwoW82oHFvCemc60S22h9rYI96B//UUYkuqyH83v6Kfduq5l1qKlpC8I5mhMjDMN172tZbcJUzTwEO+BFBYI1mGte4bjbN4kmBBvKQrbHsEJZkMdrGfVLHjrz69wRY88aonbaNUYniuUxN8DVmQNPbdVBsvvYa5tVK0HZ+qvc5K+V4q4wzORb2Ftq6bKd/ugzJTNYgp4uwdPXxAGdP5UR6345c8uPsOJyGUultV60YyQc4XWOMLt07Kxl1+m7WlvuW6tx9gsxtLjivMMWPO9+U7w1ZYYCawOujJRukHCrsfkG6t7rYmxQv+VD44U1Qat7dngHCgMPys6hIgv5COS4WA9Pb3iP7jRsUvJHi+KKFuO3rNi4i1ID2TF9/te1CupUoYgUnabyoNUaz6PYqd83ONq5HCyRdud7BRJ6aTsDo46t0DksvLJXVwgt1ZJCAhsi0EUkqgWaGohyBOf2UkW8FuIBgeBKtWeOE+ZBpRriBmAnF98B1cG7r+SEItxO6Moqr1csUNA0gFYHKJLJbxwTKR6IYZrFf4HdYB8asvEZCTWGojJ5NyRw5xXx8kWyF1tk9gtC75hsXB1+S1ZeCjhGyq96hyJ1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(39850400004)(346002)(396003)(366004)(451199018)(316002)(41300700001)(66946007)(54906003)(66556008)(66476007)(64756008)(66446008)(8936002)(52536014)(5660300002)(4326008)(110136005)(478600001)(8676002)(186003)(83380400001)(26005)(71200400001)(7696005)(76116006)(38070700005)(9686003)(6506007)(33656002)(55016003)(38100700002)(86362001)(2906002)(122000001)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGprVGlwRGlUU1diWE5zUmZRRnVnZmRyZFREa3Bod245QmgwQnUrUDhTNWFs?=
 =?utf-8?B?YUVVcjlENWNPRTBKRU90U2N3RUo0Rmc1b2w1bVF0ZS9ab01Ha3lrSXdTZHlS?=
 =?utf-8?B?RHBwaE4rcnVhWDdDV2NxaEpIZHBMQ2JLNTlqcitneEtGTTc2Y0dXTk8zYTVK?=
 =?utf-8?B?VHJiZXhCVndteDhuNTB5aGlEaVltM0JlbHQvTFRtblZQL0FmUEZHempRYTRi?=
 =?utf-8?B?M3kzbFFRSWpyaXY5OGsvNjFMd2R6NTMxQ3BxUmE5UlNrc29jd2pXSFd3VmFt?=
 =?utf-8?B?TG9SOW9tRllkeGMzS0pwRTBicmx3QWduWHYrODYzRHo1cFlZZFhUVFdBM0F2?=
 =?utf-8?B?TE9yYXBUcSt4ZkdoMDFacGJwdE4rcUsxcy9mQVdMZzNnQ0RMSjhwQnFGcEx5?=
 =?utf-8?B?UWpYMzFvR2hkVCsvbDlzbU9McEY5V0M5WTN1bVhmQXdlRlNhVXliTS9WUTl2?=
 =?utf-8?B?QnVhVE1EbHowbGxaZ0N5QWhxUG9aeGY2T0ZxdGQvRSt6a09kcG5VS050Zm5D?=
 =?utf-8?B?WkM0SktwS2VOS09LemM4NmdVTFpaZUdPaVJBNTlRdEJnTjkwYk14c21USzJL?=
 =?utf-8?B?OGlXemllN0ZBbWdob2FlN2RFbUxZVTYyUUtFZDJySDE1bEcrYzZ2eUdwWDBK?=
 =?utf-8?B?d1BnbDFPV2x2U3dZSjlYbEZpckFTVkxTVkxtVm8xL2VMbktQWnlMdVlKbnhu?=
 =?utf-8?B?QzhhbktSMGFzTDVQVENkTGp0ZmJPUmhCZERNUDBwRVoyT0VONXQzNDFRU04v?=
 =?utf-8?B?c1pyL0RheFRGbDhybk9XZjg3SThCQmdCRU5QbXp2cHNZYlZhS1hJVFpIQ0pz?=
 =?utf-8?B?ZUVTVTBQUHlpSkRNNTNWYSsrYVlTOHdwanh4bTFtZmY2RFpGazExUkllOW45?=
 =?utf-8?B?YjB6ZUVmbFdCUTJRbXdtazE0REZCNFprN0FSM2ZUNUIxU1lBR3BQK0MyWU0r?=
 =?utf-8?B?UEFUZGl2bTkyUjFaZmRkemdKWEJVb3dlVjQ2YUdoeXE3UUlkNWxWVDg1U2dk?=
 =?utf-8?B?UURoVUxwRUlONlZFRVdFKzA0SUVFNEpLQ3NLUzBmcXBpaUZxVHB3bFZwaGJ0?=
 =?utf-8?B?dEJYYThMR3pPaWtyeXJMRXR1QzlKL1N6d3NaQjFhRGdDa3d3eDJXMUtqazNH?=
 =?utf-8?B?OUVURnIrQ2Vxb3FtbEJNTStMdkx3aDhGSk9vckx3YnB5QWJGelU0R2hPcXZW?=
 =?utf-8?B?SDVVcnJtMVU5OTRxV0t0MGphRnBlbkFDbzRxNmVoQlpaZlB4TElaVkNoUVY2?=
 =?utf-8?B?T2FNdTR4cnFuaFZqay8xSVY2eUM0cnF1SHVSZjBYdFc0MUpOdnN0aktyKzFq?=
 =?utf-8?B?SUxWZFB1WlUvdnFocnJnR01hMmZHK2E5ck9POVhsOTlQb1laQW5zbE1rUTJQ?=
 =?utf-8?B?T2pSVGh6VS9SdmtHdjBHNENQc1AyNlJ6YzZIbmQ4QkFTbEF0Y1Q0QkFYUFNF?=
 =?utf-8?B?bTBqZTV4dFFBMzl2azJCbzJ3QTVmY0ZPM05qMzJMZDRHVHhuMHJEcThiRE9z?=
 =?utf-8?B?UE0rc0dvOEZKcjJ6eHFJMTNXTlFDb3hWQnZySFRnWUV5Q0taanN0MkptNUZF?=
 =?utf-8?B?RjVySEtiRGZCS01sRDROcFo3N2R0Y3FqcStMMng4d2I2Y3lQTXI2M2gzcWN4?=
 =?utf-8?B?L2o1KzRESFI3a3FrREZ3Y0VuYnRpMGZSSEdvZnlNUGZLWm5RbUlhd2VCNXAv?=
 =?utf-8?B?a0VkOGxrS1doamZEWndJMjI3b3FzSGc1TmRPSGlRTlNOY2ltM2FjT0trQUNo?=
 =?utf-8?B?SExtSEc2cDVsb29kME9zVTlrWGhPekdsOVlWMjR2dU5DVVhyY3dmL0p4Z3Fm?=
 =?utf-8?B?c1U2U3FabjBZb215a1NER0xidGY4dFR0SGR3UmpNQUhRWHIvbDRsbzFHSlZu?=
 =?utf-8?B?WGd3cmxDSitKM2RLc0JCNEZ1c3ZiQnQyWHV5dzA5ZGZ3MVFzU1dONDV4Y1ph?=
 =?utf-8?B?d0JJdk5uREptYXRJYlRLck11R2lCZVBQTitnWVVFRkJJaDZKaHlwc3lUanJw?=
 =?utf-8?B?S0hxTE9Ca2NtbmppbkhLR043MlY2U3E1Q1crb01WSkhnRnBWbWxjODFKbXo3?=
 =?utf-8?B?SWp1SjFxYVVKL3VURmlFY0xyazdMUjVMRkJGaTZhY1VSUkkvY08wc05hbXAx?=
 =?utf-8?B?N1AxaVNYOW1tUGZ2WHBzQ0RDcjNOd24wM1YzWjZ1REMvYXRhK01LaHdkSU9s?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc464afc-f6a8-40e6-9d69-08db0a8e396c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 11:10:16.7486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B5SoQeIr0nIM7NyViFF6uuYT07Xj+IYEeHFlvVqPOVo3ikavxvalwkBvYv5gKC79lj1YXp3Z5Kj2UcL3Q5kbrEkAw8+YSPed1GFIsOwoiBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR05MB9537
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IFBhb2xvIEFiZW5pIDxwYWJl
bmlAcmVkaGF0LmNvbT4NCj5TZW50OiBUaHVyc2RheSwgRmVicnVhcnkgOSwgMjAyMyA1OjM5IFBN
DQo+VG86IFR1bmcgUXVhbmcgTmd1eWVuIDx0dW5nLnEubmd1eWVuQGRla3RlY2guY29tLmF1Pjsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPkNjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtl
cm5lbC5vcmc7IGVkdW1hemV0QGdvb2dsZS5jb207IGptYWxveUByZWRoYXQuY29tOyB5aW5nLnh1
ZUB3aW5kcml2ZXIuY29tOw0KPnZpcm9AemVuaXYubGludXgub3JnLnVrOyBzeXpib3QrZDQzNjA4
ZDA2MWU4ODQ3ZWM5ZjNAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQ0KPlN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjIgbmV0IDEvMV0gdGlwYzogZml4IGtlcm5lbCB3YXJuaW5nIHdoZW4gc2VuZGluZyBT
WU4gbWVzc2FnZQ0KPg0KPk9uIFdlZCwgMjAyMy0wMi0wOCBhdCAwNzowNyArMDAwMCwgVHVuZyBO
Z3V5ZW4gd3JvdGU6DQo+PiBXaGVuIHNlbmRpbmcgYSBTWU4gbWVzc2FnZSwgdGhpcyBrZXJuZWwg
c3RhY2sgdHJhY2UgaXMgb2JzZXJ2ZWQ6DQo+Pg0KPj4gLi4uDQo+PiBbICAgMTMuMzk2MzUyXSBS
SVA6IDAwMTA6X2NvcHlfZnJvbV9pdGVyKzB4YjQvMHg1NTANCj4+IC4uLg0KPj4gWyAgIDEzLjM5
ODQ5NF0gQ2FsbCBUcmFjZToNCj4+IFsgICAxMy4zOTg2MzBdICA8VEFTSz4NCj4+IFsgICAxMy4z
OTg2MzBdICA/IF9fYWxsb2Nfc2tiKzB4ZWQvMHgxYTANCj4+IFsgICAxMy4zOTg2MzBdICB0aXBj
X21zZ19idWlsZCsweDEyYy8weDY3MCBbdGlwY10NCj4+IFsgICAxMy4zOTg2MzBdICA/IHNobWVt
X2FkZF90b19wYWdlX2NhY2hlLmlzcmEuNzErMHgxNTEvMHgyOTANCj4+IFsgICAxMy4zOTg2MzBd
ICBfX3RpcGNfc2VuZG1zZysweDJkMS8weDcxMCBbdGlwY10NCj4+IFsgICAxMy4zOTg2MzBdICA/
IHRpcGNfY29ubmVjdCsweDFkOS8weDIzMCBbdGlwY10NCj4+IFsgICAxMy4zOTg2MzBdICA/IF9f
bG9jYWxfYmhfZW5hYmxlX2lwKzB4MzcvMHg4MA0KPj4gWyAgIDEzLjM5ODYzMF0gIHRpcGNfY29u
bmVjdCsweDFkOS8weDIzMCBbdGlwY10NCj4+IFsgICAxMy4zOTg2MzBdICA/IF9fc3lzX2Nvbm5l
Y3QrMHg5Zi8weGQwDQo+PiBbICAgMTMuMzk4NjMwXSAgX19zeXNfY29ubmVjdCsweDlmLzB4ZDAN
Cj4+IFsgICAxMy4zOTg2MzBdICA/IHByZWVtcHRfY291bnRfYWRkKzB4NGQvMHhhMA0KPj4gWyAg
IDEzLjM5ODYzMF0gID8gZnByZWdzX2Fzc2VydF9zdGF0ZV9jb25zaXN0ZW50KzB4MjIvMHg1MA0K
Pj4gWyAgIDEzLjM5ODYzMF0gIF9feDY0X3N5c19jb25uZWN0KzB4MTYvMHgyMA0KPj4gWyAgIDEz
LjM5ODYzMF0gIGRvX3N5c2NhbGxfNjQrMHg0Mi8weDkwDQo+PiBbICAgMTMuMzk4NjMwXSAgZW50
cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NjMvMHhjZA0KPj4NCj4+IEl0IGlzIGJlY2F1
c2UgY29tbWl0IGE0MWRhZDkwNWU1YSAoImlvdl9pdGVyOiBzYW5lciBjaGVja3MgZm9yIGF0dGVt
cHQNCj4+IHRvIGNvcHkgdG8vZnJvbSBpdGVyYXRvciIpIGhhcyBpbnRyb2R1Y2VkIHNhbml0eSBj
aGVjayBmb3IgY29weWluZw0KPj4gZnJvbS90byBpb3YgaXRlcmF0b3IuIExhY2tpbmcgb2YgY29w
eSBkaXJlY3Rpb24gZnJvbSB0aGUgaXRlcmF0b3INCj4+IHZpZXdwb2ludCB3b3VsZCBsZWFkIHRv
IGtlcm5lbCBzdGFjayB0cmFjZSBsaWtlIGFib3ZlLg0KPj4NCj4+IFRoaXMgY29tbWl0IGZpeGVz
IHRoaXMgaXNzdWUgYnkgaW5pdGlhbGl6aW5nIHRoZSBpb3YgaXRlcmF0b3Igd2l0aA0KPj4gdGhl
IGNvcnJlY3QgY29weSBkaXJlY3Rpb24uDQo+Pg0KPj4gRml4ZXM6IGYyNWRjYzc2ODdkNCAoInRp
cGM6IHRpcGMgLT5zZW5kbXNnKCkgY29udmVyc2lvbiIpDQo+PiBSZXBvcnRlZC1ieTogc3l6Ym90
K2Q0MzYwOGQwNjFlODg0N2VjOWYzQHN5emthbGxlci5hcHBzcG90bWFpbC5jb20NCj4+IEFja2Vk
LWJ5OiBKb24gTWFsb3kgPGptYWxveUByZWRoYXQuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogVHVu
ZyBOZ3V5ZW4gPHR1bmcucS5uZ3V5ZW5AZGVrdGVjaC5jb20uYXU+DQo+PiAtLS0NCj4+IHYyOiBh
ZGQgRml4ZXMgdGFnDQo+Pg0KPj4gIG5ldC90aXBjL21zZy5jIHwgMyArKysNCj4+ICAxIGZpbGUg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL25ldC90aXBjL21z
Zy5jIGIvbmV0L3RpcGMvbXNnLmMNCj4+IGluZGV4IDVjOWZkNDc5MWM0Yi4uY2NlMTE4ZmVhMDdh
IDEwMDY0NA0KPj4gLS0tIGEvbmV0L3RpcGMvbXNnLmMNCj4+ICsrKyBiL25ldC90aXBjL21zZy5j
DQo+PiBAQCAtMzgxLDYgKzM4MSw5IEBAIGludCB0aXBjX21zZ19idWlsZChzdHJ1Y3QgdGlwY19t
c2cgKm1oZHIsIHN0cnVjdCBtc2doZHIgKm0sIGludCBvZmZzZXQsDQo+Pg0KPj4gIAltc2dfc2V0
X3NpemUobWhkciwgbXN6KTsNCj4+DQo+PiArCWlmICghZHN6KQ0KPj4gKwkJaW92X2l0ZXJfaW5p
dCgmbS0+bXNnX2l0ZXIsIElURVJfU09VUkNFLCBOVUxMLCAwLCAwKTsNCj4NCj5JdCBsb29rcyBs
aWtlIHRoZSByb290IGNhdXNlIG9mIHRoZSBwcm9ibGVtIGlzIHRoYXQgbm90IGFsbCAoaW5kaXJl
Y3QpDQo+Y2FsbGVycyBvZiB0aXBjX21zZ19idWlsZCgpIHByb3Blcmx5IGluaXRpYWxpemUgdGhl
IGl0ZXIuDQo+DQo+dGlwY19jb25uZWN0KCkgaXMgb25lIG9mIHN1Y2ggY2FsbGVyLCBidXQgQUZB
SUNTIGV2ZW4gdGlwY19hY2NlcHQoKSBjYW4NCj5yZWFjaCB0aXBjX21zZ19idWlsZCgpIHdpdGhv
dXQgcHJvcGVyIGl0ZXIgaW5pdGlhbGl6YXRpb24gLSB2aWENCj5fX3RpcGNfc2VuZHN0cmVhbSAt
PiBfX3RpcGNfc2VuZG1zZy4NCj4NCj5JIHRoaW5rIGl0J3MgYmV0dGVyIGlmIHlvdSBhZGRyZXNz
IHRoZSBpc3N1ZSBpbiByZWxldmFudCBjYWxsZXJzLA0KPmF2b2lkaW5nIHVubmVlZGVkIGFuZCBj
b25mdXNpbmcgY29kZSBpbiB0aXBjX21zZ19idWlsZCgpLg0KSSBhbSBmdWxseSBhd2FyZSBvZiBj
YWxsZXJzICh3aXRob3V0IGluaXRpYWxpemluZyBpb3ZlYykgb2YgdGhpcyBmdW5jdGlvbi4gTXkg
aW50ZW50aW9uIHdhcyB0byBtYWtlIGFzIGxlc3MgY2hhbmdlIGFzIHBvc3NpYmxlLg0KRG8geW91
IHRoaW5rIHVzaW5nICBpb3ZfaXRlcl9rdmVjKCkgaW5zdGVhZCBpbiB0aGUgY2FsbGVycyBtYWtl
IHNlbnNlIGlmIEkgZ28gZm9yIHdoYXQgeW91IHN1Z2dlc3RlZCA/DQo+DQo+VGhhbmtzLA0KPg0K
PlBhb2xvDQoNCg==
