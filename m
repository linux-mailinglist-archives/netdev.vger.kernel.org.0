Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E94C6D0B6E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbjC3QhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjC3QhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:37:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFA7C167;
        Thu, 30 Mar 2023 09:37:04 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UEEMGZ030236;
        Thu, 30 Mar 2023 16:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=N4BRLZtVCfVlYz3Da4Zd1uRD7w2gmR1l2GpibMZPdN8=;
 b=zwgSmp/w8+vaAD+VXHBk9gCd40Z3FLqAa61+38oCLK/5IbLOFue9GqzFayHacce0Yl+K
 9r89owUVZSEp0Cekt0JKT+93yAEXk000THt6LRKgZWoaJcBEXueJ3rn4piGhbTXrTmfs
 ErdqBouKIKJuLD7IyViDDWfdCy63hZrjXZtqvsiNg2iNghe+NZnlfUtb2OOHnJE9QNWS
 RaKmAlGBGUfuWG2zVV3eFw5nAb4KKj8fE1m1AZyL1T9QRzob7yx6m+PFYnPfigd1rwy4
 1aw96CFXiX+7wXyJhV3U4N/8q2nXkv25tOVJCq0Ti43Lwy2W2apFr1+9a4yi1j7grt9s EQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmq56u6tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 16:36:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32UG4gtZ036404;
        Thu, 30 Mar 2023 16:36:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdhg21n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 16:36:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTMPtB94IbvCHO3kcdzSM+JG5FDK5kaRF4Khj5ZaaWHgThaZ6h9W9T1eBedp/AatQ8fxhKKAOo5tvAeodaZZBG6GESFmETIM7Pw1BX2DwRfkTrRCBuCucIbl1wVUmQacex6VlKVvWzM2Ho+MWnyEeOL8tBl2C9TMQSgRBJDW5gbztS1NOtk7aVtTlGbOtgctm060t5Mn2MdVc2lFlxsKDjfYeXuIhWsjZ6NY3rVmYAhw+0bNNOOqCZsfJ+s2q2pRHa/Ben0vRBFyEkwaoqGpMO7BytCJetuE1nKhIuoSdGhyxD42Kpio3nlc4+H2sT0LOThJUouDzaE080ZdEIK3KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4BRLZtVCfVlYz3Da4Zd1uRD7w2gmR1l2GpibMZPdN8=;
 b=d4Sb79TlKX9qhzJ4UOoKHLBLoz12r8cuG9DkP7h6IUBw6jNeH492r6GPXh2dSiEMPJRmFYqPLttRJmEkbRKKoAHYNWVIArinBgrB3/+8Xo/b05PLGcb1pLNLdlPCjYjL4iFMDvZsKcVDcpR1lZU003jBfXYdf7BWzezsVug68jsrVcsMfw2yG95Hs5leEHtU6k8Qse1pZpo2dS6JGFdeVu624uqfIl9idvN3vGJIyz4ORUy5ZhuEpiAk6y5VV8TH2ihq4YYmJrWZjev4V92gd45fs9KocXmT6EddyI4zCyr2sy1+JY/k2TqtKL2SXrDNae7rUIBJA8WsEfpSlogUMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4BRLZtVCfVlYz3Da4Zd1uRD7w2gmR1l2GpibMZPdN8=;
 b=rlF5ErTvYGbSaH5MreEHVbiOuCuPfrrzJ3tZgI4Puc6KxFGvNG5p62V2u7+QvTwi9mawB4bbtGKHTGYfNqnaJjVHtgMmq9B2oCOCsKkQdaXfjAw28f64Hgq7G7TPMJA8iUff39OAsR86bwrgAG8CATU+txzuR2CJqgBLqRm46ho=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB6829.namprd10.prod.outlook.com (2603:10b6:208:427::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 16:36:35 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%6]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 16:36:35 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     David Howells <dhowells@redhat.com>
CC:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Topic: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES)
 rather then sendpage
Thread-Index: AQHZYkj+dLwZN/D8CEye9eJOITPkS68R4ZoAgAFpS4CAAAQ3AIAAAxGAgAAQoICAACQ0gA==
Date:   Thu, 30 Mar 2023 16:36:34 +0000
Message-ID: <A03755D2-3EEB-4A21-9302-6F03316F2709@oracle.com>
References: <3A132FA8-A764-416E-9753-08E368D6877A@oracle.com>
 <812034.1680181285@warthog.procyon.org.uk>
 <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com>
 <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-41-dhowells@redhat.com>
 <812755.1680182190@warthog.procyon.org.uk>
 <822317.1680186419@warthog.procyon.org.uk>
In-Reply-To: <822317.1680186419@warthog.procyon.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA1PR10MB6829:EE_
x-ms-office365-filtering-correlation-id: 7c2a2627-8745-4a19-9aca-08db313ced2e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t3MVZiURlgHa99R6fP1HR2YcoiykuYL6gio2AB0v+UXIOU4BdYOgPTq5wg+4jqbfS6lz3vBZCbYG8brDvN+fTzAulOMw0SDCBXmd+AWI4AHq1lQYkBDTtd3Nuv/QXXY69btq7Cy/U6Sf64NLBDziQsr5NfeQL2JIyWwzFFojy4KAc3pb/VK4w5rlbp1VfEB3sn9wy6r8kAhFUtn0W2xWocj0WX76TNJZ3SotKPKOv1V3OoPceCsAa374lpVVPrIxeaVG+ECqOX0cuMZMs9unfjE8AuI55wwEIfZ4Jeqwz27YJnV6HQPCqOf0drVkEJgOTRamZVYePwI8Aoq46KmJ8hr3BYaUZzV7f0U7FWriuaEiqPyrZd6ZUkyjWFqgAc3SsEGttyMt6OCfK6XKgmi1HXGZR+1WYHfReglyJTT7bvLlRX0dzRJy/rJz17RXJENX8hmkkYyUSRU1tVx7xPsHqQuUnDZ2FX9On/UXJAM6De13WQB/B98bCVwDhJ0p0spY0P5Pq/PEiZ/nxRtkCHQXpW6e1glFkC/IWcUPx7fxU0rNlnFqq6gfzF2VvVAQ6/a8fUa0Y+yUwWpw1OqcErtFx0P7smA4EiPWppu7PMMXsDCIiw0cYdCtU6KGHEV3pjjNVdxqS7WKOYEHY4FCIg5R1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199021)(71200400001)(6486002)(38070700005)(186003)(36756003)(26005)(6506007)(53546011)(33656002)(86362001)(6512007)(4326008)(54906003)(2906002)(8676002)(6916009)(8936002)(316002)(66476007)(41300700001)(122000001)(64756008)(83380400001)(66946007)(66556008)(66446008)(76116006)(38100700002)(91956017)(5660300002)(7416002)(478600001)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?L6j1/JwWQEMIOpl27nn2OqVq9G0mqAIVuepsXHU3g51IwRGUz6vwl7pFsel0?=
 =?us-ascii?Q?KVN3vYPK76xg9mTAs+43mCxQVeBphx2Gl6PZMGrW51ug//NuuMXMAgMynHrH?=
 =?us-ascii?Q?rROUwVkY6XfLf6rHc5YslL80ROYgMasc1mRiX4W6fOJRaUSO5d96RT6zv/jI?=
 =?us-ascii?Q?88yJhv8o3WNKQQUZ5nuT5YJV6tAQ7zqTVv3f5DZJyaJwsIGetVsVOlDERFOx?=
 =?us-ascii?Q?6DZ0RByOeEIf04nlHeoqUlRp6ZKmFllKM02n7KmAmNqzNw5tDYiAlI01+QJr?=
 =?us-ascii?Q?U8j5RKBeq5xzOmqIxG+Mxsl2yAoRLQjG3Tl3dirUgbFgddaA1BC1b7L1MnuJ?=
 =?us-ascii?Q?RjHuS4fOiotAOKntN64hDtnjx9DTO2MckXDAYHD4kK9eB+GQHmIh2z+hy3D0?=
 =?us-ascii?Q?qk8ykR3G9zdnQ79w4FWuq/mAHXtvI0RZvvHWZT6/Qh0fV0nlIFt/cp7BAF2B?=
 =?us-ascii?Q?Jnrp0hsXUtjdiTkF+dPLszk6hCGjlIOSoEghy0ZMSjAJDMdocjONdTVnkkFo?=
 =?us-ascii?Q?Mu72HKutI9cFKgAHBASNrOFF9Kpe3M3HFHR6mw26QWwhqDvCh134WY/IrClI?=
 =?us-ascii?Q?XiEnrE+p9rJnV8uB/RxawABx0PPsyzR8hKmPMv1Dqs8ABhhNsdrUO6avj3yl?=
 =?us-ascii?Q?a+eXfcXT2SyK50I+x4PK4hYJI6nyrcdeX63+hSilkXovoQq3D40JkAWTRVa1?=
 =?us-ascii?Q?uFqaIJ/O/dR7mGXsVnm+Vy2ocY/jI80jiFmxN1z0QLylK9fMrh1kfqq+JgKF?=
 =?us-ascii?Q?3nPogglHnDCC6Zl2Xc7P/G2SNbCM9VYMTCcBy43VgE/bSC/Xu+sIGMU+5j13?=
 =?us-ascii?Q?eNZTCVDQJGez20qQqopHIPW3YYZTTrs5+YLlCts7nLFHn3wRjCgzW/3x1OdT?=
 =?us-ascii?Q?h58z/+sobUswfZF/XL37AXjo9rUUzsCHNvRxDaUbvQncVFumIkrSgxSfQi60?=
 =?us-ascii?Q?VuPOT0eemRqWl6lXYKlJ8GyBo16geEdSPjEbaiuHtYgDwVMOz7ZevpW0R+lA?=
 =?us-ascii?Q?57D+7Xpt7lkKraE0vy1qGM+KtuUG8V/T7vzcoco15IwHHVAAyeg9W9CFcnI1?=
 =?us-ascii?Q?yBtTs9Gbx/ORAqRFTGkdl3q8VewRCvdVB4DDi6D5xyi/r+o39lzMFm4SXGOi?=
 =?us-ascii?Q?2JvxU8J4bmOdH6iCf4rdAmBWgYv6TS9KXNGrQk1ZIPr3v12wSLF3D74g9oXz?=
 =?us-ascii?Q?QiBFA8uOh9UERKO4wYwX2EkL6nAKYLGMP3LK0h6EnjaWdrcYrGEwb6AOEIRW?=
 =?us-ascii?Q?C+0SycEkeb7BR8EEXcOKb9UK0TtDvVJ8oGzkplcvwwOHjzvX2J4wMf/+eBGX?=
 =?us-ascii?Q?7PIpdnrlOaGVkXOiVyzqncHCNDwcwvoVbGf+rpQY6IMzeqeoRJaiNKbKdjpc?=
 =?us-ascii?Q?eZ9H8Bzvh10a6/MtsekH6t4kaZmKktmtS//V9EjzOD/gh5XSTxqz7ki6RaE3?=
 =?us-ascii?Q?LyAOX6Dw4KKDHZQ8OfBn/VFE3FK9z10SEDw2SWvarNU7n9Zeq6fmAsyVd2AB?=
 =?us-ascii?Q?1qdXUw09PYD+4235hFLJk5++40JaTfuq3adHGR8pSzy7AD+ax4WtJDjMZd8S?=
 =?us-ascii?Q?boak+gpEecTS4MbsuC/1p+cXQ9k9ufp7ICPGSwRKpVOigbNtJSTpSQEHCWT3?=
 =?us-ascii?Q?6A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA95331E082AFA4F9654B4CF3151B127@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?VvkqJQb+ue8+d0JyO3ORo62DSBsdeiRsxCOWV8rCZP8itmYvyCP86rY/bBko?=
 =?us-ascii?Q?80s9SN9pai3wNHLhU9iHnVGWGmbembX/GJyOeLC/jnfFjbZxWMFQBJAdvUWO?=
 =?us-ascii?Q?OLBNp59D5LpLzACOyRu2g2IWWl2qlDk3sn1seISLYXK+jQ1Gg4LA2UBHb3RP?=
 =?us-ascii?Q?xhgHEfD1Pg5mZTr2kDXUTlra6NF0mvjwm1dmp2tteUMOCf0iPhh0FOAyQvOo?=
 =?us-ascii?Q?cbYlAnxhVuA+ge6elpT6g11wTwJcj8OL7gNg+PD0LL8qBU7gByhDpQeeCw+5?=
 =?us-ascii?Q?2tXuQgRbCVNw0HJ3twRZP3vc5bN0tKplbnCW6gJ97O5ejJ4GNnzOadsmOXn/?=
 =?us-ascii?Q?8zoqRLo21C3NjVWFqCg3RlVu08iu+aXKYCHox2dE7IzyP13bwuTWw8WGC8tS?=
 =?us-ascii?Q?3VKFnuRkpwT4mTOarBeXdiNYjFzYgZuh8FjjSHN0/epDxgq9cvaw/ZBi+TGI?=
 =?us-ascii?Q?yDURfL+botjhCA35VDh5FUd/6MnDugjSwZXvEmOv2i1CJwWQ8iZ5OzXEVKlh?=
 =?us-ascii?Q?/9wZ034zKZhwkpT3d1cVudelFbrQ0Z3XpkyYvSeUBzPPdzUPGEdeAl9a7lWy?=
 =?us-ascii?Q?CdV8iXyRlxeMPPuJ6Y7PUiaMP9Z/4znqrcHoTov+S0JInaPk+1LClZFaZWE0?=
 =?us-ascii?Q?3fUu6OfnqexZAQIJj/0ZyxhGqh72no523rWYMgSk1hmydFfNSlv5Qc9gv5Dz?=
 =?us-ascii?Q?l1lGLdZtVo5RFOp4s63Pl0S244n6HtYRK1eNm6GKoRCuH5wNDXg/8pfwZqes?=
 =?us-ascii?Q?6aIzT41z+qNqY2R6S+1J92FtqTwjYzR46VwWgfsbO2B9u7l3FQ+3GofjhUby?=
 =?us-ascii?Q?vWS7BUTJ3USkZSb1Q49VcazKmAFRbPQZjA/cvNktcH9aPxhfeoqdjewJVAEp?=
 =?us-ascii?Q?jnk5AWBO9842gQ9+tEupyhBsAurH1BH01nTv10ELxoEtXcy+C/YwT9rQSLEd?=
 =?us-ascii?Q?yatp5m7nFkBEiUO6gX5iWlwjCy8SWW6PFx4/h28q4CjGH3tVsYk/XI2GkRky?=
 =?us-ascii?Q?ZV+Vj4/qfMTZ8d7sDVjumFVfdCZwsb281XlvukQFpSPrVE6ndzAPSO2zei9B?=
 =?us-ascii?Q?wWFnt1I7FjZDxXB+MEvAAT5k+9dvQnqlT1S/HvopoQ2OnnAxwgdQQrfVfHpA?=
 =?us-ascii?Q?ClmE1hQ92/7E?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2a2627-8745-4a19-9aca-08db313ced2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 16:36:34.9516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E/Ztf8IRjPrE4P9uhF0A+3xP7MBlpJOwFYvhKdnH3hQCkCZEw8P9GXmlFQDTtMYXBIbVHY9ROoANvyrdy6lePw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_09,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303300131
X-Proofpoint-GUID: jKQijQrS1HU5EJBuwZzvG4hvjvIpEUmz
X-Proofpoint-ORIG-GUID: jKQijQrS1HU5EJBuwZzvG4hvjvIpEUmz
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 30, 2023, at 10:26 AM, David Howells <dhowells@redhat.com> wrote:
>=20
> Chuck Lever III <chuck.lever@oracle.com> wrote:
>=20
>> Don't. Just change svc_tcp_send_kvec() to use sock_sendmsg, and
>> leave the marker alone for now, please.
>=20
> If you insist.  See attached.

Very good, thank you for accommodating my regression paranoia.

Acked-by: Chuck Lever <chuck.lever@oracle.com>


>=20
> David
> ---
> sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
>=20
> When transmitting data, call down into TCP using sendmsg with
> MSG_SPLICE_PAGES to indicate that content should be spliced rather than
> performing sendpage calls to transmit header, data pages and trailer.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> cc: Anna Schumaker <anna@kernel.org>
> cc: Chuck Lever <chuck.lever@oracle.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-nfs@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
> include/linux/sunrpc/svc.h |   11 +++++------
> net/sunrpc/svcsock.c       |   40 +++++++++++++--------------------------=
-
> 2 files changed, 18 insertions(+), 33 deletions(-)
>=20
> diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
> index 877891536c2f..456ae554aa11 100644
> --- a/include/linux/sunrpc/svc.h
> +++ b/include/linux/sunrpc/svc.h
> @@ -161,16 +161,15 @@ static inline bool svc_put_not_last(struct svc_serv=
 *serv)
> extern u32 svc_max_payload(const struct svc_rqst *rqstp);
>=20
> /*
> - * RPC Requsts and replies are stored in one or more pages.
> + * RPC Requests and replies are stored in one or more pages.
>  * We maintain an array of pages for each server thread.
>  * Requests are copied into these pages as they arrive.  Remaining
>  * pages are available to write the reply into.
>  *
> - * Pages are sent using ->sendpage so each server thread needs to
> - * allocate more to replace those used in sending.  To help keep track
> - * of these pages we have a receive list where all pages initialy live,
> - * and a send list where pages are moved to when there are to be part
> - * of a reply.
> + * Pages are sent using ->sendmsg with MSG_SPLICE_PAGES so each server t=
hread
> + * needs to allocate more to replace those used in sending.  To help kee=
p track
> + * of these pages we have a receive list where all pages initialy live, =
and a
> + * send list where pages are moved to when there are to be part of a rep=
ly.
>  *
>  * We use xdr_buf for holding responses as it fits well with NFS
>  * read responses (that have a header, and some data pages, and possibly
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 03a4f5615086..af146e053dfc 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -1059,17 +1059,18 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqst=
p)
> 	svc_xprt_received(rqstp->rq_xprt);
> 	return 0;	/* record not complete */
> }
> -
> +=20
> static int svc_tcp_send_kvec(struct socket *sock, const struct kvec *vec,
> 			      int flags)
> {
> -	return kernel_sendpage(sock, virt_to_page(vec->iov_base),
> -			       offset_in_page(vec->iov_base),
> -			       vec->iov_len, flags);
> +	struct msghdr msg =3D { .msg_flags =3D MSG_SPLICE_PAGES | flags, };
> +
> +	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, vec, 1, vec->iov_len);
> +	return sock_sendmsg(sock, &msg);
> }
>=20
> /*
> - * kernel_sendpage() is used exclusively to reduce the number of
> + * MSG_SPLICE_PAGES is used exclusively to reduce the number of
>  * copy operations in this path. Therefore the caller must ensure
>  * that the pages backing @xdr are unchanging.
>  *
> @@ -1109,28 +1110,13 @@ static int svc_tcp_sendmsg(struct socket *sock, s=
truct xdr_buf *xdr,
> 	if (ret !=3D head->iov_len)
> 		goto out;
>=20
> -	if (xdr->page_len) {
> -		unsigned int offset, len, remaining;
> -		struct bio_vec *bvec;
> -
> -		bvec =3D xdr->bvec + (xdr->page_base >> PAGE_SHIFT);
> -		offset =3D offset_in_page(xdr->page_base);
> -		remaining =3D xdr->page_len;
> -		while (remaining > 0) {
> -			len =3D min(remaining, bvec->bv_len - offset);
> -			ret =3D kernel_sendpage(sock, bvec->bv_page,
> -					      bvec->bv_offset + offset,
> -					      len, 0);
> -			if (ret < 0)
> -				return ret;
> -			*sentp +=3D ret;
> -			if (ret !=3D len)
> -				goto out;
> -			remaining -=3D len;
> -			offset =3D 0;
> -			bvec++;
> -		}
> -	}
> +	msg.msg_flags =3D MSG_SPLICE_PAGES;
> +	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec,
> +		      xdr_buf_pagecount(xdr), xdr->page_len);
> +	ret =3D sock_sendmsg(sock, &msg);
> +	if (ret < 0)
> +		return ret;
> +	*sentp +=3D ret;
>=20
> 	if (tail->iov_len) {
> 		ret =3D svc_tcp_send_kvec(sock, tail, 0);
>=20

--
Chuck Lever


