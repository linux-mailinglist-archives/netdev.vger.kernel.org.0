Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F4F12A2E4
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 16:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLXPRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 10:17:37 -0500
Received: from mail-eopbgr20079.outbound.protection.outlook.com ([40.107.2.79]:24350
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbfLXPRh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 10:17:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ska2S6eb/4f3vqiTvkLIriWW3U0boHtYID4XY3g2iJtq2R14B+JYDeG2l+J3RAITkAruSMRFmfi1Pv+ujSTnlZ3fjmLxJZINQzDdwZ9vlERE3kU85L4JKyMaadZLv0NMoSP8QpqkSTadEM4kAcxU9Zxrlp+aeeOalOTBlyW9JQKqtD9H5bahRr/GdbgipWSWq6kiJcsf52ZsfADGXcsuyfllpVVH37CFmDGlnrQwvm3oQceyqNFPrbf3A5Cu5TIuHCqEe/XXlK7/OcsVF8B+7TT2zHeAeb43J6g38GlxlWT+WZHe0h4CcpjyqDAuFtX47KYSNad6bN8ccwnLb3cj3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPSN0JMDCJ45ueFfT51E3BuCik/zHq0rnStjvyInugA=;
 b=HsT+CtLa8HIoEuvlXow2Q5lOo7meTCUWU0CCQas8axTv5bI9DRsYPh23mwoLByzrQelOLmZ8XiaTW/ynRvdZX2O4vQcuGjS3/6iL/cWSq7R8N5dpbWnR879EO/rU9lsFPluDCZZBf61sTTIDA8+mkfNZzEz9at9UgUSLScAQ4xoTWDkZUXdtEr2oiGecYmbZH/XM4jd8rJ7lKNpoy0KbCKbIOsNrxZaDnPMe4QKslhffN312dcX/6+YN91pessW4iJ5ybgYGzKDltksXGoVh+R1jN3c3U/H6EpgvP8WT3NZKbsZ7YSw4vxyypSrkhZSS4yqsBfyu+eS7ZZSjOd06PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPSN0JMDCJ45ueFfT51E3BuCik/zHq0rnStjvyInugA=;
 b=jKXSlNisdsKh4YPwZTUT3tc1b9NcHx+pu75i1vk1mHD3l+4CJ1ZH0/3WI1/JkDn9Abm3TKYAbP6a9I8YmOTdGwrvHNaDCvt0dYCKXi4YFnWbIsTnRMFrmMx3jW/VGkaOerURByVeIiP69nNId5JTSf9+gLT14B0O6i/5fgexZTY=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6269.eurprd05.prod.outlook.com (20.177.49.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Tue, 24 Dec 2019 15:17:33 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::79d0:a1c8:b28:3d10]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::79d0:a1c8:b28:3d10%5]) with mapi id 15.20.2559.017; Tue, 24 Dec 2019
 15:17:33 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Davide Caratti <dcaratti@redhat.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net 2/2] net/sched: add delete_empty() to filters and use
 it in cls_flower
Thread-Topic: [PATCH net 2/2] net/sched: add delete_empty() to filters and use
 it in cls_flower
Thread-Index: AQHVujzvXWoQGgrAT0+/xfnjdLyyZKfJK4WAgAAz7QCAAAaXgA==
Date:   Tue, 24 Dec 2019 15:17:33 +0000
Message-ID: <vbf4kxp3g8m.fsf@mellanox.com>
References: <cover.1577179314.git.dcaratti@redhat.com>
 <a59aea617b35657ea22faaafb54a18a4645b3b36.1577179314.git.dcaratti@redhat.com>
 <vbf7e2m2bno.fsf@mellanox.com>
 <49bdcf7998d31d12716c60af0a47414adc76f284.camel@redhat.com>
In-Reply-To: <49bdcf7998d31d12716c60af0a47414adc76f284.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0236.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::32) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a44c1cdd-fc3c-4567-57e4-08d788846680
x-ms-traffictypediagnostic: VI1PR05MB6269:|VI1PR05MB6269:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB626986DDE8F18252061C48D9AD290@VI1PR05MB6269.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0261CCEEDF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(5660300002)(86362001)(2906002)(6512007)(4326008)(54906003)(66946007)(81156014)(81166006)(8676002)(66476007)(71200400001)(64756008)(66556008)(66446008)(6916009)(52116002)(4001150100001)(6486002)(26005)(316002)(186003)(6506007)(2616005)(36756003)(478600001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6269;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7xN+SAYnTPlU06XUOkn1QlBS5+xXMCHyL03H3vH7k/OtbmM+Sd05XAHCMTKOJXYlcsXbPlumrJUsCVD2zQmljzE8D5SMlkIV9CXcGfSFP062vPNOVJbM2tgr/pdw+8VhWffFy0YIrdUaZeqeq/MybzZknXvdl9kItuD9tD4QKg/vvwWxoE+OUgL2Z/Yu/5/05fNtnQD4B5g7zuhxu0Y8or9Snk6QSz5qnGEml/SzPyE4YSWqSGwlumlwjx8W9p/QDNd4KCa/zQR0AstYbe1uhTR3PzbrkfSEiULmEl205Kg08kWLh6f9QvT8tP+SN9tQEMtoLw6J2lRZRQZKT7K7bwy+l9J3jZUcxOt4Nhc8unXhXQqggAH4x3Kqg5LzkE03w1iTeb07HS5oWlTDwTlQX6hD7axc/Md0IgwfUZiw8FDxCGyLinMZFenuLEZ5S7i9
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a44c1cdd-fc3c-4567-57e4-08d788846680
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2019 15:17:33.4641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RVkju6SibSVnjosrKzP8zc+eSFQOP0//Jr36t+qjmrQlpeJYB8+jlrx3WwyNsBoHbKnNJUXpbMZfJhIhTXQOLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6269
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 24 Dec 2019 at 16:53, Davide Caratti <dcaratti@redhat.com> wrote:
> hello Jamal and Vlad,
>
> thanks for looking at this.
>
> On Tue, 2019-12-24 at 11:48 +0000, Vlad Buslov wrote:
>> I guess we can reduce this code to just:
>>
>> spin_lock(&tp->lock);
>> tp->deleting =3D idr_is_empty(&head->handle_idr);
>> spin_unlock(&tp->lock);
>
> on the current version of delete_empty() for cls_flower, we are assuming
> an empty filter also when the IDR is allocated, but its refcount is zero:
>
> 1931         idr_for_each_entry_continue_ul(&head->handle_idr, f, tmp, id=
) {
> 1932                 /* don't return filters that are being deleted */
> 1933                 if (!refcount_inc_not_zero(&f->refcnt))
> 1934                         continue;
> 1935                 if (arg->fn(tp, f, arg) < 0) {
> 1936                         __fl_put(f);
> 1937                         arg->stop =3D 1;
> 1938                         break;
> 1939                 }
> 1940                 __fl_put(f);
> 1941                 arg->count++;
> 1942         }
>
> but probably this is relevant to dump(), not delete(). Correct?

I don't think that it is possible to get filter with refcnt=3D=3D0 from idr
when holding the tp lock (filter is inserted with refcnt=3D=3D1 and removed
from idr before releasing the last reference in fl_delete()). fl_walk()
doesn't take the lock by itself so it needs to deal with concurrent
removals.

>
>  # ./tdc.py -c flower -d enp2s0
>
> ^^ I'm running several loops of this, just to make sure. If I don't find
> anything relevant in few hours, I will send a v2.
> thanks!
