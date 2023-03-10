Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D7A6B4B4E
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbjCJPjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbjCJPim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:38:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505241241CA
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 07:26:09 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32AF4SIK016584;
        Fri, 10 Mar 2023 15:25:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=qITTzf0B2aX3axq0VHNcN0vP+qz6OG+XXB4siZtRGpA=;
 b=cochL8/BaaiKF+EXmhwpLqgRwlGqO/mVj81eZZENQVeqDHzr4XEAsS2TWZbaMLNx5W7t
 ASc8hWVAJr++HDEMjDr3fubVcUxkNpPZDcfGn5nAnObG4U5MbT69uPA3iOuVcb5ICiDY
 TOyZrKYmo6NjzGstp5pT7NX25rtMVeGVsD8E1QgsUTUO08PAIxAF4Sfa3LdPcIdGj+UH
 ENFOe3QeoVx1SApHa0GNRFTzxpwHzK+eDYa7Gx1B3IhF1+49D5bTCe1tEfVAB9fAal2O
 nKwf7lox+5TIftFKjDJbugExjgsZOVGOJfuNqiZMAm/R606zPrJjVxeIb2ZYVPBkGIff xQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn99tf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 15:25:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32AF6QN4021713;
        Fri, 10 Mar 2023 15:25:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6frbv96x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 15:25:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bwve0drbyVIHbKAsmMFpLz8LYwbhU28aKqQTJbwWdcWZVBgNG6eN5qrzryePL23v2O1ZUrovTulQOfEtbmND0YtqvVXd9EfBM7FBwvnELaa3vcKo5MTT203PcFhUXEVmbab1uNXQb8newZw+cQKG25067zLOSLRO7TQRV8SsDt6bgMbgJN16oWwYaTrrs9dskTKeXEb3uKT2OEhfG3RtpcVKVAFvDkd9QZpl/V/XKi8yIUGpFrM0jzEjpL7zPrv7THP+ZMbKUV+J9xx0OSgRXsUA5qwcG1RB7SNFdaWXta3u8DKi+Ov79vretm7cn3Klh+51oLt6KB016f1MLzgy+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qITTzf0B2aX3axq0VHNcN0vP+qz6OG+XXB4siZtRGpA=;
 b=VD+QVl5f7tKXJ7peaxxxsxY+OI8tOyZU8L7eu7A1yPM1tEBff2tM1aU4WZExyCmftVknhmNasOKo2MM1iIX0CissVNIweDlrx9Al9imVQ6bLEw1aa/oRVkRZmmYF+kvQOoX4nJAgB5YkclwODjfGPCoReBk0du6Lwuc4dohHri/2ko8uf+KF78HEXdrE/HliN6XPTdtRS9f6tXaS1gpMkvMG3OKnsQFia6xl9iiGyVKTbHJTZ8ypAoPrDsI7D7ZMI1iOUSbII9WhxASPO9BnVn/DzIO82jHxwZPUfSh9iz+8LpYBp0BxWF1Dy+vg3G2EIKo9LjvBzxISG56RZNJiRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qITTzf0B2aX3axq0VHNcN0vP+qz6OG+XXB4siZtRGpA=;
 b=kUi7ed1XGejyTkf7skMWOxuyOQEUe/CTrV3rqJMRn5OrbNYDT5OmiVSBprng8xfSMKpdIa+Ma1DYkQPcEY1JoC/0SNXC2aSO/1M6YU7MCJn+MDWIbkddwXDg3pkoO6sA8qI/682VdtD6sbm3tR6xtIv7Yrsuy6rYSM9rmw46QOo=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS7PR10MB5309.namprd10.prod.outlook.com (2603:10b6:5:3a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 15:25:50 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%7]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 15:25:50 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v6 2/2] net/tls: Add kernel APIs for requesting a TLSv1.3
 handshake
Thread-Topic: [PATCH v6 2/2] net/tls: Add kernel APIs for requesting a TLSv1.3
 handshake
Thread-Index: AQHZTgE1BAFJOgD+FEerf4Dwg5V2/q70LSyA
Date:   Fri, 10 Mar 2023 15:25:49 +0000
Message-ID: <BD185601-F6B7-4BD1-B98A-4BEEBAD738D2@oracle.com>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
 <167786949822.7199.14892713296931249747.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167786949822.7199.14892713296931249747.stgit@91.116.238.104.host.secureserver.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS7PR10MB5309:EE_
x-ms-office365-filtering-correlation-id: 47e7f3cb-bf51-4726-0848-08db217bbab2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z1R44277plXkowjV8yhi+Ib5trc4M0A26qtTD31DYE/VuZGalRwsIWG1YjRxVIVtio0haq8zCKYjEcmUn0tJ07RgmklO9HzLxp8c47cgsLJJyiALPV4TRN0vZTjoWPGai/kzAASLR8h2wbpCMuzgqImtGDgIhDjsNbE2R64gi9nip2E6QRk+703MBmbbKGSowBhfV+yh6c0OMOz4SCxcmnXg1ilhMNsNBG/pjLCpO04VTt4W9x3dsY54+K5mHXtG2PfW8EDMUvQP1q/aAtuQcgfguiCccjPZyU9mNmQqvAs2W5Lpxibeh9TpsIY9d4C1b8uBNzwAKt6QfIulKLgQuXJzgB209AH9m/3YIeUUvFnYXdDs0GLk5HlLSxzVf2tAjsgre/JiketyzfLBxUeHmjoaRvhMRu0Ur95lXOs88WQnPN/Zc5gLlyhn5BmwEzZIGEkWC6UjX4E9dSFCioRDsmmk/wvkdU2pajxAjgdt5GPoDHbtKrQBuYv5Xaky3qdTXraefO5G+Xy8hXFmE4iUqelSHsC83Ihh2N42q3gger6hSpsi/sKtDEwga1QOkoGuYF3eiu/aPpJFSdOhgU4eK8jNGX9NjbzacZT2X4XcqJFQI2NfQ5+cWXhd7auu+7s1uwdYL3CYZprlsfpaS2SkZb1rBsQM6S2986ECcepknsWXFL3fa2I8q5ltjLdLKtgoZlAFP7bu7nVP5bxqdnpvOvYNSHIPhwMKwyHuDWfynzY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199018)(30864003)(5660300002)(36756003)(110136005)(83380400001)(26005)(478600001)(107886003)(6506007)(6512007)(6486002)(2616005)(71200400001)(53546011)(186003)(91956017)(38070700005)(8676002)(4326008)(76116006)(66476007)(66446008)(64756008)(66946007)(33656002)(8936002)(41300700001)(66556008)(86362001)(54906003)(38100700002)(316002)(122000001)(2906002)(45980500001)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G/0LI2QVs//ahagLhXWWRExXBgkFBHjyWgof17UsfvSOP6Pzr01gEKWhgMta?=
 =?us-ascii?Q?hgUDq+Iy1JAYJJR5zMgohVZK6Yglwo/7W7wNMHKoU6P7EjjH4cIJGoFPsALi?=
 =?us-ascii?Q?LgSlZtM9BBf0vk+3p3NpBj7PksZiySN6dHqBeJCvbMtYwVEUYWOaN3Lq6VHZ?=
 =?us-ascii?Q?G15/Oa2bG5ZPfLNAPnTMdTuVKsGptrBcx8xeNZA8DmxJ5/ykQLnxTFU1deIc?=
 =?us-ascii?Q?pryXLc6XejvRSOTbKA8OGvdTm6yz5yJnvAQg5uHxc6amw5R7+7aliBjk99C7?=
 =?us-ascii?Q?12nBuwLvgwBosDzwWSN3LxD4wppZG6RIz0HAjRgrT/yAuro7dDF+VWmuMnVN?=
 =?us-ascii?Q?2RfRPa88+AklXEAye1Z3tLVmFvDsRfg+DWk91Y7rVY/hYeWUkzMjE/+1nLch?=
 =?us-ascii?Q?KqzA1Ggha9llGFCknLOvxAlGfXaBney9LV2kXqnhvJpzakK4YdjEBQlULNuv?=
 =?us-ascii?Q?U0dj4GSqaGpJtf09IrwzplgmtP09FP3Bz6y4OlYRfIeZSArv1jW8zYW1Su0Q?=
 =?us-ascii?Q?8TJdRpJydHstVSFLZ5nw7yyFfY34bh/1ykH3HTIhBJK7c+SaEAcZiOZ1+//A?=
 =?us-ascii?Q?TY72+gnXrAvmqwCuCAi4E9GRnpANlvPg5W4mu6WzSGAhlMHtPTIrPIisaNUH?=
 =?us-ascii?Q?sKOOW6x6YwwymPb8ihoAmrES0C7wB5iJBzOx5KUiV3URhiq5LhmUlZAcXULh?=
 =?us-ascii?Q?SLovIDnOjTKWZFjZ7ucFA4XUlftHgTGYEnVQNcOllQf5irK3lncQYHDFq29F?=
 =?us-ascii?Q?yyk4MgpCN+sYfW/9sUjbeS3vVwM+MBErvWHT5P6eGKEqwIAuyO6YMN9U9vjK?=
 =?us-ascii?Q?MZ9D4tevMd9p5dnkvaSUrs8aGJapi0P+6wE4lAViszemEUi39vkUv79MgBYK?=
 =?us-ascii?Q?ZLAM4Lo25pPqi0QEe4T9Q/pF+9Q2ODx6T2tJ1h1Qr1sRQzOFsF+vv19krTDC?=
 =?us-ascii?Q?oaBbdJYOHfALgGup45672rmshS5Uh9Qu5LKGUu76VDwwDHoJnedKzqZB6iJK?=
 =?us-ascii?Q?bDI74EeD6hnLDLmlzHJkumCyQQFlule1I9FitzQl2GKFBxqft0rE7p+S/wXE?=
 =?us-ascii?Q?8i/pJFn/8ps1Nrfn9jeQoLNDjKhoQ1TBhZIzwZ6+YfFhPOysAUZtbxyxz5fw?=
 =?us-ascii?Q?rj4P0RPDBoH/kQetmnDB12s7K6uHR3LSNwLPif4n0m7HJK69ryJmFotGS/G5?=
 =?us-ascii?Q?uRY2vHAR2Dq2oCw0q1IVw9KEWi7TH4qGWU0VAy8pWINRxWsfCcMFFMlM2gmD?=
 =?us-ascii?Q?jdBst+HbMxWSaYuuEq789xE6hmgOpvE3e4ZU3ZaNjqBpvDk1lJrSTdTaLQqY?=
 =?us-ascii?Q?/QzQQx86nU267pG02ew2jLRc/i6uwVZzn4lljfSoNWtwAMSA4U24BK7vwSiH?=
 =?us-ascii?Q?2XRi0nAjxkigXHZ9/Be1TrX5aypaF1yn4dp4Q4SHbPJvo0GYmmwTXxKy27lo?=
 =?us-ascii?Q?PSrghvP4Qae4TO6Q8s3CvcA4wouhEaCfGftzriHpaeyGOH0OqPoanKEluiBU?=
 =?us-ascii?Q?AhXgPBAMaJ159+cv9vk7/2KdtpXp2cqaUs8BnaNKhUBcIuB1zZ3aCaEMsymH?=
 =?us-ascii?Q?hF5ukwmpFskftvQtAyUe8LWEcqtnTRnz8SLm7uT+yFDGtc8kd+cDPRf7i6Pk?=
 =?us-ascii?Q?aQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B0E11F64E5C0ED4A917942194C06774E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wih1a2BRw/F8tzt/yZ0cZXEsP4sFv+FrNXRFYklYxOyV3veSkk9kGo//xH8vlYsck4eG3WsnuOwwMWikBynoh3roYxOxLGqYiLL59oJgQXWzVwdibSrrDA73Y5RqSeEDoZXEtDjWK6Z3UMWtACmtVnBPE7OM7n9OP1SWYXHbZGCoWkeV7adu7pGD7J/vvnc7mWrW2hqH7j3vsYba4y3MpvzcioiSqPXvxxlArEWXhJsbJdbukpOj7RgCFjwDin3IF1SQ4aQKdipdAPn5uOMi1zEDq+zRYFNsCUnnkxMYzlmvMi0VFt7znKwJHGtPxIl7mITI2wGHp+GhdGlaKijkb0sPbZW7a/Mv//WqrQ4m5Vn7+BBq4vt7jtXRi5WEQ6B/a6Itzp3uPNxeUUnVq1xOyka7iGFp88nYc2xdNxxxhFUoO2jlZ9uhgvgWMNYlP5NkpIsL+34X6aTbrmorfyivW15GFbLzm6d2KuciG91XLVLn+EXCyEd5IiQIDt64UDuRp8ExSxt1uWLo7PaAkEasnw+1JhAEDcj7TjqwNy82T0smsSbvtI5qgsW1WVN7Br5fa1MEZCRLoN8wRYt/KMHRFZRoKS2nVM0BBHjmQl0O/1gZlODV8ohCRbO5ur3Z7O6b589eImsbgfWqNmZQvBV9D8BiHt9YQhWA22bhUKDS3K0IQ5Zjpv4DILVLliw2pWqbAiiwVHvl1aF5wJy8iIrZXwU7RmmNfmNpfaEmydokNR3F1zG9XtIytZWBIekIR+W/gxRqOBqiMlzoVGmvOuRhxsDrqaB82Dog9iMe3MMRiymPLpXDMcEeTCecfuRWklU33l6QHxNN1qM9TMOD+KkpRZLebcm05EMf2NQySIi0lMgPwGg6pUiPOjrMPHfqpcBlIObJYhh/5u2MTHGBRdkFcw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e7f3cb-bf51-4726-0848-08db217bbab2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 15:25:49.9356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tAipGfxCD/fB4yO0dP7/x35L8QyZgnKWjF+UQGUoaIraQVqJPgTpopqljY0Y5CyOpWa6e8APMjlGDI0m5/UY6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5309
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_06,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100124
X-Proofpoint-GUID: WUYsDth60X6rczod_RPISng0RxFmoM8O
X-Proofpoint-ORIG-GUID: WUYsDth60X6rczod_RPISng0RxFmoM8O
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 3, 2023, at 1:51 PM, Chuck Lever <cel@kernel.org> wrote:
>=20
> From: Chuck Lever <chuck.lever@oracle.com>
>=20
> To enable kernel consumers of TLS to request a TLS handshake, add
> support to net/tls/ to request a handshake upcall.
>=20
> This patch also acts as a template for adding handshake upcall
> support to other kernel transport layer security providers.
>=20
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
> Documentation/netlink/specs/handshake.yaml |    4=20
> Documentation/networking/index.rst         |    1=20
> Documentation/networking/tls-handshake.rst |  219 ++++++++++++++++
> include/net/tls.h                          |   29 ++
> include/uapi/linux/handshake.h             |    2=20
> net/handshake/netlink.c                    |    1=20
> net/tls/Makefile                           |    2=20
> net/tls/tls_handshake.c                    |  391 +++++++++++++++++++++++=
+++++
> 8 files changed, 647 insertions(+), 2 deletions(-)
> create mode 100644 Documentation/networking/tls-handshake.rst
> create mode 100644 net/tls/tls_handshake.c
>=20
> diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/n=
etlink/specs/handshake.yaml
> index 8367f50fb745..49c3bd9ca6a9 100644
> --- a/Documentation/netlink/specs/handshake.yaml
> +++ b/Documentation/netlink/specs/handshake.yaml
> @@ -21,7 +21,7 @@ definitions:
>     name: handler-class
>     enum-name:
>     value-start: 0
> -    entries: [ none ]
> +    entries: [ none, tlshd ]
>   -
>     type: enum
>     name: msg-type
> @@ -135,3 +135,5 @@ mcast-groups:
>   list:
>     -
>       name: none
> +    -
> +      name: tlshd
> diff --git a/Documentation/networking/index.rst b/Documentation/networkin=
g/index.rst
> index 4ddcae33c336..189517f4ea96 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -36,6 +36,7 @@ Contents:
>    scaling
>    tls
>    tls-offload
> +   tls-handshake
>    nfc
>    6lowpan
>    6pack
> diff --git a/Documentation/networking/tls-handshake.rst b/Documentation/n=
etworking/tls-handshake.rst
> new file mode 100644
> index 000000000000..0580e4d1b67c
> --- /dev/null
> +++ b/Documentation/networking/tls-handshake.rst
> @@ -0,0 +1,219 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +In-Kernel TLS Handshake
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Transport Layer Security (TLS) is a Upper Layer Protocol (ULP) that runs
> +over TCP. TLS provides end-to-end data integrity and confidentiality in
> +addition to peer authentication.
> +
> +The kernel's kTLS implementation handles the TLS record subprotocol, but
> +does not handle the TLS handshake subprotocol which is used to establish
> +a TLS session. Kernel consumers can use the API described here to
> +request TLS session establishment.
> +
> +There are several possible ways to provide a handshake service in the
> +kernel. The API described here is designed to hide the details of those
> +implementations so that in-kernel TLS consumers do not need to be
> +aware of how the handshake gets done.
> +
> +
> +User handshake agent
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +As of this writing, there is no TLS handshake implementation in the
> +Linux kernel. To provide a handshake service, a handshake agent
> +(typically in user space) is started in each network namespace where a
> +kernel consumer might require a TLS handshake. Handshake agents listen
> +for events sent from the kernel that indicate a handshake request is
> +waiting.
> +
> +An open socket is passed to a handshake agent via a netlink operation,
> +which creates a socket descriptor in the agent's file descriptor table.
> +If the handshake completes successfully, the handshake agent promotes
> +the socket to use the TLS ULP and sets the session information using the
> +SOL_TLS socket options. The handshake agent returns the socket to the
> +kernel via a second netlink operation.
> +
> +
> +Kernel Handshake API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +A kernel TLS consumer initiates a client-side TLS handshake on an open
> +socket by invoking one of the tls_client_hello() functions. First, it
> +fills in a structure that contains the parameters of the request:
> +
> +.. code-block:: c
> +
> +struct tls_handshake_args {
> +	struct socket		*ta_sock;
> +	tls_done_func_t		ta_done;
> +	void			*ta_data;
> +	unsigned int		ta_timeout_ms;
> +        key_serial_t            ta_keyring;
> +	key_serial_t		ta_my_peerid;
> +	key_serial_t		ta_my_privkey;
> +};
> +
> +The @ta_sock field references an open and connected socket. The consumer
> +must hold a reference on the socket to prevent it from being destroyed
> +while the handshake is in progress. The consumer must also have
> +instantiated a struct file in sock->file.
> +
> +
> +@ta_done contains a callback function that is invoked when the handshake
> +has completed. Further explanation of this function is in the "Handshake
> +Completion" sesction below.
> +
> +The consumer can fill in the @ta_timeout_ms field to force the servicing
> +handshake agent to exit after a number of milliseconds. This enables the
> +socket to be fully closed once both the kernel and the handshake agent
> +have closed their endpoints.
> +
> +Authentication material such as x.509 certificates, private certificate
> +keys, and pre-shared keys are provided to the handshake agent in keys
> +that are instantiated by the consumer before making the handshake
> +request. The consumer can provide a private keyring that is linked into
> +the handshake agent's process keyring in the @ta_keyring field to preven=
t
> +access of those keys by other subsystems.
> +
> +The use of the @ta_my_peerid and @ta_my_privkey fields depends on which
> +authentication mode is requested. For example to start an x.509-
> +authenticated TLS session:
> +
> +.. code-block:: c
> +
> +  ret =3D tls_client_hello_x509(args, gfp_flags);
> +
> +The function returns zero when the handshake request is under way. A
> +zero return guarantees the callback function @ta_done will be invoked
> +for this socket. The function returns a negative errno if the handshake
> +could not be started. A negative errno guarantees the callback function
> +@ta_done will not be invoked on this socket.
> +
> +The handshake argument structure is filled in as above. The consumer
> +fills in the @ta_my_peerid field with the serial number of a key that
> +contains an x.509 certificate. The consumer fills in the @ta_my_privkey
> +field with the serial number of a key that contains the private key for
> +that certificate.
> +
> +
> +To initiate a client-side TLS handshake with a pre-shared key, use:
> +
> +.. code-block:: c
> +
> +  ret =3D tls_client_hello_psk(args, gfp_flags);
> +
> +In this case, the consumer fills in the @ta_my_peerid field with the
> +serial number of a key that contains a pre-shared key to be used for the
> +handshake. The other fields are filled in as above.
> +
> +
> +To initiate an anonymous client-side TLS handshake use:
> +
> +.. code-block:: c
> +
> +  ret =3D tls_client_hello_anon(args, gfp_flags);
> +
> +The handshake agent presents no peer identity information to the remote
> +during this type of handshake. Only server authentication (ie the client
> +verifies the server's identity) is performed during the handshake. Thus
> +the established session uses encryption only.
> +
> +
> +Consumers that are in-kernel servers use:
> +
> +.. code-block:: c
> +
> +  ret =3D tls_server_hello_x509(args, gfp_flags);
> +
> +or
> +
> +.. code-block:: c
> +
> +  ret =3D tls_server_hello_psk(args, gfp_flags);
> +
> +The argument structure is filled in as above.
> +
> +
> +If the consumer needs to cancel the handshake request, say, due to a ^C
> +or other exigent event, the consumer can invoke:
> +
> +.. code-block:: c
> +
> +  bool tls_handshake_cancel(sock);
> +
> +This function returns true if the handshake request associated with
> +@sock has been canceled. The consumer's handshake completion callback
> +will not be invoked. If this function returns false, then the consumer's
> +completion callback has already been invoked.
> +
> +
> +Handshake Completion
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +When the handshake agent has completed processing, it notifies the
> +kernel that the socket may be used by the consumer again. At this point,
> +the consumer's handshake completion callback, provided in the @ta_done
> +field in the tls_handshake_args structure, is invoked.
> +
> +The synopsis of this function is:
> +
> +.. code-block:: c
> +
> +typedef void	(*tls_done_func_t)(void *data, int status,
> +				   key_serial_t peerid);
> +
> +The consumer provides a cookie in the @ta_data field of the
> +tls_handshake_args structure that is returned in the @data parameter of
> +this callback. The consumer uses the cookie to match the callback to the
> +thread waiting for the handshake to complete.
> +
> +The success status of the handshake is returned via the @status
> +parameter:
> +
> ++-----------+----------------------------------------------+
> +|  errno    |  meaning                                     |
> ++=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> +|  0        |  TLS session established successfully        |
> ++-----------+----------------------------------------------+
> +|  EACCESS  |  Remote peer rejected the handshake or       |
> +|           |  authentication failed                       |
> ++-----------+----------------------------------------------+
> +|  ENOMEM   |  Temporary resource allocation failure       |
> ++-----------+----------------------------------------------+
> +|  EINVAL   |  Consumer provided an invalid argument       |
> ++-----------+----------------------------------------------+
> +|  ENOKEY   |  Missing authentication material             |
> ++-----------+----------------------------------------------+
> +|  EIO      |  An unexpected fault occurred                |
> ++-----------+----------------------------------------------+
> +
> +The @peerid parameter contains the serial number of a key containing the
> +remote peer's identity or the value TLS_NO_PEERID if the session is not
> +authenticated.
> +
> +A best practice is to close and destroy the socket immediately if the
> +handshake failed.
> +
> +
> +Other considerations
> +--------------------
> +
> +While a handshake is under way, the kernel consumer must alter the
> +socket's sk_data_ready callback function to ignore all incoming data.
> +Once the handshake completion callback function has been invoked, normal
> +receive operation can be resumed.
> +
> +Once a TLS session is established, the consumer must provide a buffer
> +for and then examine the control message (CMSG) that is part of every
> +subsequent sock_recvmsg(). Each control message indicates whether the
> +received message data is TLS record data or session metadata.
> +
> +See tls.rst for details on how a kTLS consumer recognizes incoming
> +(decrypted) application data, alerts, and handshake packets once the
> +socket has been promoted to use the TLS ULP.
> diff --git a/include/net/tls.h b/include/net/tls.h
> index 154949c7b0c8..c8a964a62ded 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -512,4 +512,33 @@ static inline bool tls_is_sk_rx_device_offloaded(str=
uct sock *sk)
> 	return tls_get_ctx(sk)->rx_conf =3D=3D TLS_HW;
> }
> #endif
> +
> +enum {
> +	TLS_NO_KEYRING =3D 0,
> +	TLS_NO_PEERID =3D 0,
> +	TLS_NO_CERT =3D 0,
> +	TLS_NO_PRIVKEY =3D 0,
> +};
> +
> +typedef void	(*tls_done_func_t)(void *data, int status,
> +				   key_serial_t peerid);
> +
> +struct tls_handshake_args {
> +	struct socket		*ta_sock;
> +	tls_done_func_t		ta_done;
> +	void			*ta_data;
> +	unsigned int		ta_timeout_ms;
> +	key_serial_t		ta_keyring;
> +	key_serial_t		ta_my_peerid;
> +	key_serial_t		ta_my_privkey;
> +};
> +
> +int tls_client_hello_anon(const struct tls_handshake_args *args, gfp_t f=
lags);
> +int tls_client_hello_x509(const struct tls_handshake_args *args, gfp_t f=
lags);
> +int tls_client_hello_psk(const struct tls_handshake_args *args, gfp_t fl=
ags);
> +int tls_server_hello_x509(const struct tls_handshake_args *args, gfp_t f=
lags);
> +int tls_server_hello_psk(const struct tls_handshake_args *args, gfp_t fl=
ags);
> +
> +bool tls_handshake_cancel(struct socket *sock);

When TLS handshake consumers are built-in but TLS is built
as a module, these API calls become undefined references:

ld: net/sunrpc/xprtsock.o: in function `xs_tls_handshake_sync':
/home/cel/src/linux/linux/net/sunrpc/xprtsock.c:2560: undefined reference t=
o `tls_client_hello_x509'
ld: /home/cel/src/linux/linux/net/sunrpc/xprtsock.c:2552: undefined referen=
ce to `tls_client_hello_anon'
ld: /home/cel/src/linux/linux/net/sunrpc/xprtsock.c:2572: undefined referen=
ce to `tls_handshake_cancel'
ld: net/sunrpc/xprtsock.o: in function `xs_reset_transport':
/home/cel/src/linux/linux/net/sunrpc/xprtsock.c:1257: undefined reference t=
o `tls_handshake_cancel'
ld: net/sunrpc/svcsock.o: in function `svc_tcp_handshake':
/home/cel/src/linux/linux/net/sunrpc/svcsock.c:449: undefined reference to =
`tls_server_hello_x509'
ld: /home/cel/src/linux/linux/net/sunrpc/svcsock.c:458: undefined reference=
 to `tls_handshake_cancel'

This was fine for our prototype: we just don't build it that
way. But it won't work long-term.

What is the approach that would be most acceptable to address
this?


> +
> #endif /* _TLS_OFFLOAD_H */
> diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshak=
e.h
> index 6e0c608a6b91..fe888abb4be8 100644
> --- a/include/uapi/linux/handshake.h
> +++ b/include/uapi/linux/handshake.h
> @@ -11,6 +11,7 @@
>=20
> enum {
> 	HANDSHAKE_HANDLER_CLASS_NONE,
> +	HANDSHAKE_HANDLER_CLASS_TLSHD,
> };
>=20
> enum {
> @@ -67,5 +68,6 @@ enum {
> };
>=20
> #define HANDSHAKE_MCGRP_NONE	"none"
> +#define HANDSHAKE_MCGRP_TLSHD	"tlshd"
>=20
> #endif /* _UAPI_LINUX_HANDSHAKE_H */
> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> index 6f3a7852742b..454063bdd645 100644
> --- a/net/handshake/netlink.c
> +++ b/net/handshake/netlink.c
> @@ -260,6 +260,7 @@ static const struct genl_split_ops handshake_nl_ops[]=
 =3D {
>=20
> static const struct genl_multicast_group handshake_nl_mcgrps[] =3D {
> 	[HANDSHAKE_HANDLER_CLASS_NONE] =3D { .name =3D HANDSHAKE_MCGRP_NONE, },
> +	[HANDSHAKE_HANDLER_CLASS_TLSHD] =3D { .name =3D HANDSHAKE_MCGRP_TLSHD, =
},
> };
>=20
> static struct genl_family __ro_after_init handshake_genl_family =3D {
> diff --git a/net/tls/Makefile b/net/tls/Makefile
> index e41c800489ac..7e56b57f14f6 100644
> --- a/net/tls/Makefile
> +++ b/net/tls/Makefile
> @@ -7,7 +7,7 @@ CFLAGS_trace.o :=3D -I$(src)
>=20
> obj-$(CONFIG_TLS) +=3D tls.o
>=20
> -tls-y :=3D tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
> +tls-y :=3D tls_handshake.o tls_main.o tls_sw.o tls_proc.o trace.o tls_st=
rp.o
>=20
> tls-$(CONFIG_TLS_TOE) +=3D tls_toe.o
> tls-$(CONFIG_TLS_DEVICE) +=3D tls_device.o tls_device_fallback.o
> diff --git a/net/tls/tls_handshake.c b/net/tls/tls_handshake.c
> new file mode 100644
> index 000000000000..a7ac923b0d6b
> --- /dev/null
> +++ b/net/tls/tls_handshake.c
> @@ -0,0 +1,391 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Establish a TLS session for a kernel socket consumer
> + *
> + * Author: Chuck Lever <chuck.lever@oracle.com>
> + *
> + * Copyright (c) 2021-2023, Oracle and/or its affiliates.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/socket.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/key.h>
> +
> +#include <net/sock.h>
> +#include <net/tls.h>
> +#include <net/genetlink.h>
> +#include <net/handshake.h>
> +
> +#include <uapi/linux/keyctl.h>
> +#include <uapi/linux/handshake.h>
> +
> +struct tls_handshake_req {
> +	void			(*th_consumer_done)(void *data, int status,
> +						    key_serial_t peerid);
> +	void			*th_consumer_data;
> +
> +	int			th_type;
> +	unsigned int		th_timeout_ms;
> +	int			th_auth_mode;
> +	key_serial_t		th_keyring;
> +	key_serial_t		th_peerid;
> +	key_serial_t		th_certificate;
> +	key_serial_t		th_privkey;
> +};
> +
> +static struct tls_handshake_req *
> +tls_handshake_req_init(struct handshake_req *req,
> +		       const struct tls_handshake_args *args)
> +{
> +	struct tls_handshake_req *treq =3D handshake_req_private(req);
> +
> +	treq->th_timeout_ms =3D args->ta_timeout_ms;
> +	treq->th_consumer_done =3D args->ta_done;
> +	treq->th_consumer_data =3D args->ta_data;
> +	treq->th_keyring =3D args->ta_keyring;
> +	treq->th_peerid =3D TLS_NO_PEERID;
> +	treq->th_certificate =3D TLS_NO_CERT;
> +	treq->th_privkey =3D TLS_NO_PRIVKEY;
> +	return treq;
> +}
> +
> +/**
> + * tls_handshake_destroy - callback to release a handshake request
> + * @req: handshake parameters to release
> + *
> + */
> +static void tls_handshake_destroy(struct handshake_req *req)
> +{
> +}
> +
> +/**
> + * tls_handshake_done - callback to handle a CMD_DONE request
> + * @req: socket on which the handshake was performed
> + * @status: session status code
> + * @tb: other results of session establishment
> + *
> + */
> +static void tls_handshake_done(struct handshake_req *req,
> +			       unsigned int status, struct nlattr **tb)
> +{
> +	struct tls_handshake_req *treq =3D handshake_req_private(req);
> +	key_serial_t peerid =3D TLS_NO_PEERID;
> +
> +	if (tb && tb[HANDSHAKE_A_DONE_REMOTE_AUTH])
> +		peerid =3D nla_get_u32(tb[HANDSHAKE_A_DONE_REMOTE_AUTH]);
> +
> +	treq->th_consumer_done(treq->th_consumer_data, -status, peerid);
> +}
> +
> +#if IS_ENABLED(CONFIG_KEYS)
> +static int tls_handshake_private_keyring(struct tls_handshake_req *treq)
> +{
> +	key_ref_t process_keyring_ref, keyring_ref;
> +	int ret;
> +
> +	if (treq->th_keyring =3D=3D TLS_NO_KEYRING)
> +		return 0;
> +
> +	process_keyring_ref =3D lookup_user_key(KEY_SPEC_PROCESS_KEYRING,
> +					      KEY_LOOKUP_CREATE,
> +					      KEY_NEED_WRITE);
> +	if (IS_ERR(process_keyring_ref)) {
> +		ret =3D PTR_ERR(process_keyring_ref);
> +		goto out;
> +	}
> +
> +	keyring_ref =3D lookup_user_key(treq->th_keyring, KEY_LOOKUP_CREATE,
> +				      KEY_NEED_LINK);
> +	if (IS_ERR(keyring_ref)) {
> +		ret =3D PTR_ERR(keyring_ref);
> +		goto out_put_key;
> +	}
> +
> +	ret =3D key_link(key_ref_to_ptr(process_keyring_ref),
> +		       key_ref_to_ptr(keyring_ref));
> +
> +	key_ref_put(keyring_ref);
> +out_put_key:
> +	key_ref_put(process_keyring_ref);
> +out:
> +	return ret;
> +}
> +#else
> +static int tls_handshake_private_keyring(struct tls_handshake_req *treq)
> +{
> +	return 0;
> +}
> +#endif
> +
> +static int tls_handshake_put_peer_identity(struct sk_buff *msg,
> +					   struct tls_handshake_req *treq)
> +{
> +	if (treq->th_peerid =3D=3D TLS_NO_PEERID)
> +		return 0;
> +
> +	if (nla_put_u32(msg, HANDSHAKE_A_ACCEPT_PEER_IDENTITY,
> +			treq->th_peerid) < 0)
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +
> +static int tls_handshake_put_certificate(struct sk_buff *msg,
> +					 struct tls_handshake_req *treq)
> +{
> +	struct nlattr *entry_attr;
> +
> +	if (treq->th_certificate =3D=3D TLS_NO_CERT &&
> +	    treq->th_privkey =3D=3D TLS_NO_PRIVKEY)
> +		return 0;
> +
> +	entry_attr =3D nla_nest_start(msg, HANDSHAKE_A_ACCEPT_CERTIFICATE);
> +	if (!entry_attr)
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u32(msg, HANDSHAKE_A_X509_CERT,
> +			treq->th_certificate) < 0)
> +		goto out_cancel;
> +	if (nla_put_u32(msg, HANDSHAKE_A_X509_PRIVKEY,
> +			treq->th_privkey) < 0)
> +		goto out_cancel;
> +
> +	nla_nest_end(msg, entry_attr);
> +	return 0;
> +
> +out_cancel:
> +	nla_nest_cancel(msg, entry_attr);
> +	return -EMSGSIZE;
> +}
> +
> +/**
> + * tls_handshake_accept - callback to construct a CMD_ACCEPT response
> + * @req: handshake parameters to return
> + * @gi: generic netlink message context
> + * @fd: file descriptor to be returned
> + *
> + * Returns zero on success, or a negative errno on failure.
> + */
> +static int tls_handshake_accept(struct handshake_req *req,
> +				struct genl_info *gi, int fd)
> +{
> +	struct tls_handshake_req *treq =3D handshake_req_private(req);
> +	struct nlmsghdr *hdr;
> +	struct sk_buff *msg;
> +	int ret;
> +
> +	ret =3D tls_handshake_private_keyring(treq);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret =3D -ENOMEM;
> +	msg =3D genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		goto out;
> +	hdr =3D handshake_genl_put(msg, gi);
> +	if (!hdr)
> +		goto out_cancel;
> +
> +	ret =3D -EMSGSIZE;
> +	ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_SOCKFD, fd);
> +	if (ret < 0)
> +		goto out_cancel;
> +	ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MESSAGE_TYPE, treq->th_type=
);
> +	if (ret < 0)
> +		goto out_cancel;
> +	if (treq->th_timeout_ms) {
> +		ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_TIMEOUT, treq->th_timeout_=
ms);
> +		if (ret < 0)
> +			goto out_cancel;
> +	}
> +
> +	ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_AUTH_MODE,
> +			  treq->th_auth_mode);
> +	if (ret < 0)
> +		goto out_cancel;
> +	switch (treq->th_auth_mode) {
> +	case HANDSHAKE_AUTH_PSK:
> +		ret =3D tls_handshake_put_peer_identity(msg, treq);
> +		if (ret < 0)
> +			goto out_cancel;
> +		break;
> +	case HANDSHAKE_AUTH_X509:
> +		ret =3D tls_handshake_put_certificate(msg, treq);
> +		if (ret < 0)
> +			goto out_cancel;
> +		break;
> +	}
> +
> +	genlmsg_end(msg, hdr);
> +	return genlmsg_reply(msg, gi);
> +
> +out_cancel:
> +	genlmsg_cancel(msg, hdr);
> +out:
> +	return ret;
> +}
> +
> +static const struct handshake_proto tls_handshake_proto =3D {
> +	.hp_handler_class	=3D HANDSHAKE_HANDLER_CLASS_TLSHD,
> +	.hp_privsize		=3D sizeof(struct tls_handshake_req),
> +
> +	.hp_accept		=3D tls_handshake_accept,
> +	.hp_done		=3D tls_handshake_done,
> +	.hp_destroy		=3D tls_handshake_destroy,
> +};
> +
> +/**
> + * tls_client_hello_anon - request an anonymous TLS handshake on a socke=
t
> + * @args: socket and handshake parameters for this request
> + * @flags: memory allocation control flags
> + *
> + * Return values:
> + *   %0: Handshake request enqueue; ->done will be called when complete
> + *   %-ESRCH: No user agent is available
> + *   %-ENOMEM: Memory allocation failed
> + */
> +int tls_client_hello_anon(const struct tls_handshake_args *args, gfp_t f=
lags)
> +{
> +	struct tls_handshake_req *treq;
> +	struct handshake_req *req;
> +
> +	req =3D handshake_req_alloc(args->ta_sock, &tls_handshake_proto, flags)=
;
> +	if (!req)
> +		return -ENOMEM;
> +	treq =3D tls_handshake_req_init(req, args);
> +	treq->th_type =3D HANDSHAKE_MSG_TYPE_CLIENTHELLO;
> +	treq->th_auth_mode =3D HANDSHAKE_AUTH_UNAUTH;
> +
> +	return handshake_req_submit(req, flags);
> +}
> +EXPORT_SYMBOL(tls_client_hello_anon);
> +
> +/**
> + * tls_client_hello_x509 - request an x.509-based TLS handshake on a soc=
ket
> + * @args: socket and handshake parameters for this request
> + * @flags: memory allocation control flags
> + *
> + * Return values:
> + *   %0: Handshake request enqueue; ->done will be called when complete
> + *   %-ESRCH: No user agent is available
> + *   %-ENOMEM: Memory allocation failed
> + */
> +int tls_client_hello_x509(const struct tls_handshake_args *args, gfp_t f=
lags)
> +{
> +	struct tls_handshake_req *treq;
> +	struct handshake_req *req;
> +
> +	req =3D handshake_req_alloc(args->ta_sock, &tls_handshake_proto, flags)=
;
> +	if (!req)
> +		return -ENOMEM;
> +	treq =3D tls_handshake_req_init(req, args);
> +	treq->th_type =3D HANDSHAKE_MSG_TYPE_CLIENTHELLO;
> +	treq->th_auth_mode =3D HANDSHAKE_AUTH_X509;
> +	treq->th_certificate =3D args->ta_my_peerid;
> +	treq->th_privkey =3D args->ta_my_privkey;
> +
> +	return handshake_req_submit(req, flags);
> +}
> +EXPORT_SYMBOL(tls_client_hello_x509);
> +
> +/**
> + * tls_client_hello_psk - request a PSK-based TLS handshake on a socket
> + * @args: socket and handshake parameters for this request
> + * @flags: memory allocation control flags
> + *
> + * Return values:
> + *   %0: Handshake request enqueue; ->done will be called when complete
> + *   %-ESRCH: No user agent is available
> + *   %-ENOMEM: Memory allocation failed
> + */
> +int tls_client_hello_psk(const struct tls_handshake_args *args, gfp_t fl=
ags)
> +{
> +	struct tls_handshake_req *treq;
> +	struct handshake_req *req;
> +
> +	req =3D handshake_req_alloc(args->ta_sock, &tls_handshake_proto, flags)=
;
> +	if (!req)
> +		return -ENOMEM;
> +	treq =3D tls_handshake_req_init(req, args);
> +	treq->th_type =3D HANDSHAKE_MSG_TYPE_CLIENTHELLO;
> +	treq->th_auth_mode =3D HANDSHAKE_AUTH_PSK;
> +	treq->th_peerid =3D args->ta_my_peerid;
> +
> +	return handshake_req_submit(req, flags);
> +}
> +EXPORT_SYMBOL(tls_client_hello_psk);
> +
> +/**
> + * tls_server_hello_x509 - request a server TLS handshake on a socket
> + * @args: socket and handshake parameters for this request
> + * @flags: memory allocation control flags
> + *
> + * Return values:
> + *   %0: Handshake request enqueue; ->done will be called when complete
> + *   %-ESRCH: No user agent is available
> + *   %-ENOMEM: Memory allocation failed
> + */
> +int tls_server_hello_x509(const struct tls_handshake_args *args, gfp_t f=
lags)
> +{
> +	struct tls_handshake_req *treq;
> +	struct handshake_req *req;
> +
> +	req =3D handshake_req_alloc(args->ta_sock, &tls_handshake_proto, flags)=
;
> +	if (!req)
> +		return -ENOMEM;
> +	treq =3D tls_handshake_req_init(req, args);
> +	treq->th_type =3D HANDSHAKE_MSG_TYPE_SERVERHELLO;
> +	treq->th_auth_mode =3D HANDSHAKE_AUTH_X509;
> +	treq->th_certificate =3D args->ta_my_peerid;
> +	treq->th_privkey =3D args->ta_my_privkey;
> +
> +	return handshake_req_submit(req, flags);
> +}
> +EXPORT_SYMBOL(tls_server_hello_x509);
> +
> +/**
> + * tls_server_hello_psk - request a server TLS handshake on a socket
> + * @args: socket and handshake parameters for this request
> + * @flags: memory allocation control flags
> + *
> + * Return values:
> + *   %0: Handshake request enqueue; ->done will be called when complete
> + *   %-ESRCH: No user agent is available
> + *   %-ENOMEM: Memory allocation failed
> + */
> +int tls_server_hello_psk(const struct tls_handshake_args *args, gfp_t fl=
ags)
> +{
> +	struct tls_handshake_req *treq;
> +	struct handshake_req *req;
> +
> +	req =3D handshake_req_alloc(args->ta_sock, &tls_handshake_proto, flags)=
;
> +	if (!req)
> +		return -ENOMEM;
> +	treq =3D tls_handshake_req_init(req, args);
> +	treq->th_type =3D HANDSHAKE_MSG_TYPE_SERVERHELLO;
> +	treq->th_auth_mode =3D HANDSHAKE_AUTH_PSK;
> +	treq->th_peerid =3D args->ta_my_peerid;
> +
> +	return handshake_req_submit(req, flags);
> +}
> +EXPORT_SYMBOL(tls_server_hello_psk);
> +
> +/**
> + * tls_handshake_cancel - cancel a pending handshake
> + * @sock: socket on which there is an ongoing handshake
> + *
> + * Request cancellation races with request completion. To determine
> + * who won, callers examine the return value from this function.
> + *
> + * Return values:
> + *   %true - Uncompleted handshake request was canceled or not found
> + *   %false - Handshake request already completed
> + */
> +bool tls_handshake_cancel(struct socket *sock)
> +{
> +	return handshake_req_cancel(sock);
> +}
> +EXPORT_SYMBOL(tls_handshake_cancel);


--
Chuck Lever


