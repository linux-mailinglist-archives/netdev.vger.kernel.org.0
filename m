Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE9B66E276
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjAQPlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbjAQPkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:40:16 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B2143936
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:38:02 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-212-3-NW2l7vPvm0IpR6lhilGA-1; Tue, 17 Jan 2023 15:37:59 +0000
X-MC-Unique: 3-NW2l7vPvm0IpR6lhilGA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 17 Jan
 2023 15:37:43 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Tue, 17 Jan 2023 15:37:43 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'ye.xingchen@zte.com.cn'" <ye.xingchen@zte.com.cn>,
        "3chas3@gmail.com" <3chas3@gmail.com>
CC:     "linux-atm-general@lists.sourceforge.net" 
        <linux-atm-general@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH linux-next] atm: lanai: Use dma_zalloc_coherent()
Thread-Topic: [PATCH linux-next] atm: lanai: Use dma_zalloc_coherent()
Thread-Index: AQHZKlWc44pBM0uMrEWvu+tqrnPEAq6ivi6Q
Date:   Tue, 17 Jan 2023 15:37:43 +0000
Message-ID: <913000213dd14e3b9da69270134aafa3@AcuMS.aculab.com>
References: <202301171721076625091@zte.com.cn>
In-Reply-To: <202301171721076625091@zte.com.cn>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogeWUueGluZ2NoZW5AenRlLmNvbS5jbg0KPiBTZW50OiAxNyBKYW51YXJ5IDIwMjMgMDk6
MjENCj4gDQo+IEluc3RlYWQgb2YgdXNpbmcgZG1hX2FsbG9jX2NvaGVyZW50KCkgYW5kIG1lbXNl
dCgpIGRpcmVjdGx5IHVzZQ0KPiBkbWFfemFsbG9jX2NvaGVyZW50KCkuDQoNCkknbSBzdXJlIEkn
dmUgYSBicmFpbiBjZWxsIHRoYXQgcmVtZW1iZXJzIHRoYXQgZG1hX2FsbG9jX2NvaGVyZW50KCkN
CmFsd2F5cyB6ZXJvcyB0aGUgYnVmZmVyLg0KU28gdGhlICd6YWxsb2MnIHZhcmlhbnQgaXNuJ3Qg
bmVlZGVkIGFuZCB0aGUgbWVtc2V0KCkgY2FuIGp1c3QNCmJlIGRlbGV0ZWQuDQpPVE9IIGlzIGl0
IHJlYWxseSB3b3J0aCB0aGUgY2h1cm4uDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJl
c3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsx
IDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

