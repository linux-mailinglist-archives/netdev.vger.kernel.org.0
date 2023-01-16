Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4917E66B9EB
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbjAPJLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjAPJKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:10:54 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2048.outbound.protection.outlook.com [40.107.117.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB49816AC8;
        Mon, 16 Jan 2023 01:10:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmSXhcJxv0L6zpgiYDYa3XIVofj9KDKU1TS0Rlp8EG/YJrGmEzXNuXyF5g8RrPm0t+GlY/Pd7FhwUUueDoEXu0jHKWyuFLtuQTwOrtQw9sqUataeeaYFvX071KXc0jX3AGWVTDisCdl/mMH4+L+S8Lnjs8eJcmJ+J/yzPqpqic6pmL2iYk/rNO+Li3YehZAuWP7kxBGUCACtLrvf7N1x8NetI3ftejhcU0CuWdJLsdofHaWHYFq8xjWX5l9VlUlBjCyrfSx42ERkMwWOWu9lY6yqlgx6KTT4zJAEUPDlDLyPr2OV/F0srb7GcRFQqc5sjT0CrXFUs78ILImfGGneLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lg9KScYEMAUB7rIY6lFug3OvklQXzVKOIygCWrlhFRY=;
 b=OKNwtRZ/u71GEZmaCnVzoAeH+wg1n7J2edc20XFyAuNNaPOSm9IzNiP4jeyenz/d6eXfx/r4Uilt6gLAcJ+7R5r6lnA8Gy1S7Phet2JyKvvwiEqjrKge3eYhbLHiv1X39224gd/Zdow8JJm6aCQzWYQ3dX+wrvLIIlpg0MZZETv9WKVzK/GkY3wOwMqHI5rV1jwqkmdZMq3Bvf24AmSiznus8zLnRhogAoSW/yjndKCXD9LBi8bUjz1B9Ycv1bMAlLmc7Qak1HMHnKpK+aIiZT7KkXcA0gpPCmMHZ5Oocz4rMkMYCcuaV1kTCrMB1Ha4eeE87bcjzEeD2tdkKCkR0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lg9KScYEMAUB7rIY6lFug3OvklQXzVKOIygCWrlhFRY=;
 b=SNVTYk3UY/VzMsNd5SB3obohXQZIAZ1h0mjZW9A9pa69yDOLJZ/ptgL96SoM1qqhuhqw9/8+3WUMICB2EiSbeOP0pQemJR1n00wRlMEggGYcwpiZAjo6DziLbeFfvUqCPL/TAkIjhdqxjRgB1kjLlvQ1XbU3oP5ri+HH85uf5TJ1Mhv7SpHaItXkT9sCpclGsgRVgkGb88TGke5ES+UQtWQRP3mzW77nMwqvU5C/nm7B0FYyO1+zjAi6iPkNDuoebc/zgSx6I2HqA/eSt+N0wcWfcs2yqCC0T6xRMV/O2hyGzrble1FGeS4Ct6Ty4Yp8GFjtASwjpHMafdij9JlT0Q==
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by KL1PR06MB5944.apcprd06.prod.outlook.com (2603:1096:820:db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Mon, 16 Jan
 2023 09:09:57 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::dbda:208a:7bdb:4edf]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::dbda:208a:7bdb:4edf%8]) with mapi id 15.20.6002.013; Mon, 16 Jan 2023
 09:09:57 +0000
From:   Liming Wu <liming.wu@jaguarmicro.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "398776277@qq.com" <398776277@qq.com>
Subject: RE: [PATCH] vhost: remove unused paramete
Thread-Topic: [PATCH] vhost: remove unused paramete
Thread-Index: AQHZJJ2N3gj7oC+eSUa5U/izYwd7N66Y4ziAgAfnCqA=
Date:   Mon, 16 Jan 2023 09:09:57 +0000
Message-ID: <PSAPR06MB3942728A5B4734F34CA9D57BE1C19@PSAPR06MB3942.apcprd06.prod.outlook.com>
References: <20230110024445.303-1-liming.wu@jaguarmicro.com>
 <20230111082513.weu6go5k2nyfvkjh@sgarzare-redhat>
In-Reply-To: <20230111082513.weu6go5k2nyfvkjh@sgarzare-redhat>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR06MB3942:EE_|KL1PR06MB5944:EE_
x-ms-office365-filtering-correlation-id: 1a2cfaf2-f239-4663-6285-08daf7a17095
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C43sKUNhtXc4W/5eo3FB2iCrkKt4wCmLETt8j5amxHNbkqqx5g3004c3jFDG7CTb4QOFkUccx8y58B3vV6PYBOss3xnhfh2OtT71VeR0omoSEz/8/SCvVJ4LUGQxvwvqoBHAbuGMKIHVI9/13vyJUTay3etg+goZf13hkiN/x6vnQexCFergitImmLhUECSIeX0NWUJ/vtQNDFIl5u+Ut4iDXuaJkeZtAoSkZ9fuePVnHQxPDAD2Y6+B4I19jTJodkBWwDA/MbrwAvlZLYBcVMWYilQF9rAIuvHNnwoUe6L19RrlsFHadXb74LU3Hm6R1mCTJKrs65iobjoLUvNJ09+iJ2l5ysMhkhKcnHUcyC9EAs/hNOj6OLAd7npCQBjxEW7QGfVY2gCcfQnLHNbpfWZWqBO9Fbt4OGPpqB/15m/jXpzqUB0QtAEUOfNysWu3RUSDIBCR/VgHp7ij7J0XKF4os8WuQWOH3aSKCsfiyWbOvPTgfmn+frHSBlNiettJh+SQcXcmjgyIwFA5MIgzCZ2c8beJ5rcJ2GpXw30hdY2+fbXqgErK9/ag/o1J0XMQlP0tApu0lBHHSDcHiPO77Tie+BesCAatrISGY/H4I3r62BUVCWlHyVTKoRtQIeewqkHqk6s/HTZj4+NO4voV9i7sH3CsFf1UHltLCrPXpZIPmUZj4ahN3sbqJtqZ6rUMWxX4LX2xvWR2I0bnD581uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(39830400003)(376002)(136003)(451199015)(53546011)(122000001)(38100700002)(5660300002)(6506007)(76116006)(66476007)(66556008)(66446008)(64756008)(6916009)(8676002)(66946007)(4326008)(478600001)(2906002)(26005)(54906003)(38070700005)(186003)(71200400001)(7696005)(9686003)(4744005)(33656002)(44832011)(316002)(52536014)(8936002)(86362001)(41300700001)(83380400001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oQDNDw9GpXlASmwZuLchHmW8pIf2gYMw7w3BLh7t7xwNOoU+HNm1nLrzoak7?=
 =?us-ascii?Q?Ev2KH5CuruZ8oQZvbPe1N4SdBRfzKYmowKtrqiQF3/qJdd06qtByPDjSb7bs?=
 =?us-ascii?Q?bVaW8UXGYN1QbYO2hAFSAQ7DS7Jjfo/mISBH8oZviZuQXOoMXqWl7hgnUg2b?=
 =?us-ascii?Q?nTbymqWxkDuUPTimOvwnhZeaN5VrNt8NJsdOVDdaMGKRoVBNVi6lB+zM6Igo?=
 =?us-ascii?Q?f1hH0zJWPCLUUK6FARKcTC4zviAnBXi8pgSKPVhvVI8bKgE+k9o3yN7nHYHg?=
 =?us-ascii?Q?Mj7NHFjMF+vvaLe+l48RadffQ0KN+HMizQERm59jdl3JqRHag4TpmutGv1g1?=
 =?us-ascii?Q?bWFmCFL9Mf2wprT/SKmRtiOKTnzWrzi76NM9Qy4+fswG+Q9eCvgK8FRUN8eB?=
 =?us-ascii?Q?MmuBgpu7cPqVySB7i1OXc8nQQSCR1gYt7P6cyWwX2eqtDhAmOpI6G/lsFB26?=
 =?us-ascii?Q?kmCtFjfdn7Ab+WlVvo8sCeGrGqJGsLrayQc4P6Uv+6iUk4xyn/cl4DJQDhXh?=
 =?us-ascii?Q?1RwGirsOEKO4BpEgt5DhorbsVWbgJGjaJpYNbckSzoSjZu5GcS+lmUYDVcq1?=
 =?us-ascii?Q?jjDZuaH3nqXBKZe1PNx2Tauy3LnOGZF1EMPyx7aX2SXV39jqtkGHLNIBB/qx?=
 =?us-ascii?Q?8s5YrcsfaC2nst90hvKV9kGPb8GG7iLWPzt7xP3LHdYAU4LSXm5Tuzb8hjeu?=
 =?us-ascii?Q?udN+5pseukTm/cJSPqbrqTvAGu/kiegm3tcBPVP2bjIZ/mxJ6FafKkJNTV0A?=
 =?us-ascii?Q?vPVaUAeNGfu+4C696V6+CjBTJApVdd1W2d1hSFr9dRHL1t072qyTb/X79B6Y?=
 =?us-ascii?Q?FuxeUfziBlhCk3ioqHKyg5iWjufCTh2le4xjiuGVOCRlb370ptk3Pnw/Y0Hs?=
 =?us-ascii?Q?dtwXT4XJ6drbP2i0gVdUzAt2uTH8AUr3X0mDsJ0P5q9bZF55sh2RwAizVEsW?=
 =?us-ascii?Q?fmjZkQcwJsCQsADsN39XgD8e0FnEPRA6zXtLB2OmUxnMPJgv60MQpeWJCVJa?=
 =?us-ascii?Q?vZ0NBXGcDP/dbbwwUujv3TledPorxVM3YHaWvES+WzGttP5p3hDUO/JGVwJQ?=
 =?us-ascii?Q?EweXPpq4xli9gNxkpUyeLz5hLYqhnC3Bbz7CY+7lXovE52q2E2i0c+Q3WAKF?=
 =?us-ascii?Q?yh8XcHEuRUcH3c8R7rEyxB+4es6/XG/daIIENpKo40plbj3DVZX+VPU3uTKT?=
 =?us-ascii?Q?/NcjcXnqlH6Pbge3A8NN2xsMewA3yvpMSvyDL8jSfO+FyjTBoHunTj6rbclq?=
 =?us-ascii?Q?djYTYuw1x7v6j1wzM69NbZbcKPuv25fSTQzJdeOwkLWkKUKWLCoWa3c7ifqB?=
 =?us-ascii?Q?GMGJGRG1GQ5RYwB8bieAL4L43uA3z86C8gYEH+jmcfLGBpjzDLlbi9Fe8sQM?=
 =?us-ascii?Q?qsdA+GPuNFtzeqRN+o4+2PDIwlmxWVU//MsoqAiwn8pTGIWbiUK6gl9gsktI?=
 =?us-ascii?Q?IFMOEGgZ59HEIw/wVl9k8+pZ8xBfZfusLb91wh8LcMc33DefhmNYxmapC2yC?=
 =?us-ascii?Q?Inj+E6wi6xrNpJrubb4Xdibd/q9ouFqsWQy9Cj9rRSQNM4QxdNAhMZ+PY+s3?=
 =?us-ascii?Q?GgvTdelseMPwmfKt1I0vEXbbyHYQI67utyL8RL0K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a2cfaf2-f239-4663-6285-08daf7a17095
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 09:09:57.6823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vl50ImyITbp25cZbeQnwqeyO1JVS7dI6W302RT06DdTjvzLDCO0BQp391iljE1F8Qz6yzpX0WtS7gpFOiMcfcJKz7AneSKUkV/XPwKlW6Sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB5944
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Wednesday, January 11, 2023 4:25 PM
> To: Liming Wu <liming.wu@jaguarmicro.com>
> Cc: Michael S . Tsirkin <mst@redhat.com>; Jason Wang
> <jasowang@redhat.com>; kvm@vger.kernel.org; virtualization@lists.linux-
> foundation.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> 398776277@qq.com
> Subject: Re: [PATCH] vhost: remove unused paramete
>=20
> On Tue, Jan 10, 2023 at 10:44:45AM +0800, liming.wu@jaguarmicro.com wrote=
:
> >From: Liming Wu <liming.wu@jaguarmicro.com>
> >
> >"enabled" is defined in vhost_init_device_iotlb, but it is never used.
> >Let's remove it.
> >
> >Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
> >---
> > drivers/vhost/net.c   | 2 +-
> > drivers/vhost/vhost.c | 2 +-
> > drivers/vhost/vhost.h | 2 +-
> > drivers/vhost/vsock.c | 2 +-=20
> > 4 files changed, 4 insertions(+), 4 deletions(-)
>=20
> Little typo in the title s/paramete/parameter.
Thanks for the hints!
Do I need to resend this patch.

> A part of that, the patch LGTM:
>=20
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>=20

Thanks,
Liming Wu
