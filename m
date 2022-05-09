Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6848551F6C0
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiEIIMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiEIIMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:12:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B24C1E058D
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 01:08:10 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-168-D1LhAHGPOUarfVKGgWJo7w-1; Mon, 09 May 2022 09:05:15 +0100
X-MC-Unique: D1LhAHGPOUarfVKGgWJo7w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Mon, 9 May 2022 09:05:14 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Mon, 9 May 2022 09:05:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: RE: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
Thread-Topic: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
Thread-Index: AQHYYgRPzMKysL/YVUSCrJFMkDh2Ca0WMlPg
Date:   Mon, 9 May 2022 08:05:14 +0000
Message-ID: <171fa77b3b1d44a797b7433783973fb7@AcuMS.aculab.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-13-eric.dumazet@gmail.com>
 <20220506153414.72f26ee3@kernel.org>
 <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
 <20220506185405.527a79d4@kernel.org> <202205070026.11B94DF@keescook>
 <CANn89iLS_2cshtuXPyNUGDPaic=sJiYfvTb_wNLgWrZRyBxZ_g@mail.gmail.com>
In-Reply-To: <CANn89iLS_2cshtuXPyNUGDPaic=sJiYfvTb_wNLgWrZRyBxZ_g@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDA3IE1heSAyMDIyIDEyOjE5DQouLi4uDQo+IE5J
QyBkcml2ZXJzIHNlbmQgbWlsbGlvbnMgb2YgcGFja2V0cyBwZXIgc2Vjb25kLg0KPiBXZSBjYW4g
bm90IHJlYWxseSBhZmZvcmQgY29weWluZyBlYWNoIGNvbXBvbmVudCBvZiBhIGZyYW1lIG9uZSBi
eXRlIGF0IGEgdGltZS4NCg0KQW55IHJ1bi10aW1lIGNoZWNrcyBvbSBtZW1jcHkoKSBhcmUgYWxz
byBnb2luZyB0byBraWxsIHBlcmZvcm1hbmNlLg0KDQpUaGUgJ3VzZXIgY29weSBoYXJkZW5pbmcn
IHRlc3RzIGFscmVhZHkgaGF2ZSBhIG1lYXN1cmFibGUNCmVmZmVjdCBvbiBzeXN0ZW0gY2FsbHMg
bGlrZSBzZW5kbXNnKCkuDQoNCglEYXZpZA0KIA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFr
ZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwg
VUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

