Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3419D6CC9F7
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 20:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjC1STk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 14:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjC1STj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 14:19:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A581732
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 11:19:35 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SIFbUT020601;
        Tue, 28 Mar 2023 18:19:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=oUz5vDelGiheH46akoZns5aCWFTgHFpf/4uCl/CCfno=;
 b=PmhHFEq3qoMhqGTJ9/dONN/IN5LiGC0FanxMunsTD+rHNERjA+h9dTyFnpT/+un5Q3sR
 Rf22ltva8TPv9ftY623H2nOHM0hBde/oTu9QxtocougKdy7a2ViNKQ4s0eLMNKiQRI+J
 zoXT7zUoh5mMsUnTQVOtiAaiwkLWGylIFpqIYY4c9UAntpSg4GXCzIrxd/b+lhCn7txJ
 4YM2Hi/FjG7w7iwHJU9utk8Mi5wJNqVh+4EVMDYn0UAVaA8QfOzzUgMCb0rGJYE7lW7V
 9vyuzLDn8B3A16plqcXgOJy8guFqxY5Smu7SEaUkWdQTIMINb4XmcMh1ne3kRvzMmWtv jg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pm5bnr0db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 18:19:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32SHrKEC020373;
        Tue, 28 Mar 2023 18:19:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2048.outbound.protection.outlook.com [104.47.51.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd71d3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 18:19:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcnNcQsvptL0Oi74oGF+m4Ii4KWRd+9dzkg4V6mtRsy5VInokUpbR8zrEu4EE/0LkUPc4h4b2u9ZA/f8mqFRJQQwKzOBRVoJ9/1RrTchM7efGFm/rVV0GLsxc+N0A0/+cmiNLqvEbLNBHIIgwpkBxfL1cIMhOU09i9cEQ2aOwdtVclBdXKgmfp3p7QHHtmrM8RtLONDr0nk4kchXM0FPNGkJSD+TsKfZH0a854QkADaDq1lTt/Je4+TEpCirqmfnk+ruIDOLQ7UvtCUdsGapIduqHy97yUFT8M8AXWPv7hTG/uxsV4xKtUoy8TDLzVNyjOmStcXAJ3lg+AdplK/YYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oUz5vDelGiheH46akoZns5aCWFTgHFpf/4uCl/CCfno=;
 b=Kv/jwXRrI6+wFjE30/ENctmS0p6SCantX2n7H5tATYK69xNzfGf4bJSpRTZ9+rI4LNY3l0KQ0tO3ki9qccD9jhX8s9rP5E2AAnJId5mCP5tw1df3o3VxbY1xwMNDWCzA1Fw3580Br9smKXoEWcke/19i95kZlaIy8OaVRWDllIHQXnJrXDvt2+DomFNLDPb0CkR6GUFrWkNMJqfNnbIkmH6Uqb/3tVgJ19NX+YQP09S3RLz3bBZzct1nQr/bg5wAnVxzxkZNGEVrzQudxbqF5+2ZmP1Z/CxpFwb5921O/l+9toHBxz7t3eD2xTePvKGKG2KO6fuQNZrrvpYfrF7kdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUz5vDelGiheH46akoZns5aCWFTgHFpf/4uCl/CCfno=;
 b=Rd05d0FCrSHcM3zSri46JT5Z9SNodyPXJXwDB8kAo3m27m2XLigDL0MenUgmKqF8pZZlQ75+UrDX3wpCTui+nFooZoNc02HXckGfcCbl9pwaWijrZ+GY2s7/vZeHrBkgUwioDVX6uwqffqj5s6IGu4Y6ONlmTft9X7NOBVp01MA=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB5993.namprd10.prod.outlook.com (2603:10b6:208:3ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Tue, 28 Mar
 2023 18:19:22 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%6]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 18:19:22 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jeff Layton <jlayton@redhat.com>
CC:     Chuck Lever <cel@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZWbVGJzLbQ29BsEW987typvYRiq8Qjv+AgAABOQA=
Date:   Tue, 28 Mar 2023 18:19:22 +0000
Message-ID: <8154E3F3-C8A2-4BCF-8DFC-E00EA7B9CF80@oracle.com>
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
 <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
 <3e4e33c19a9c608be863d2d7207f5a9cb7db795f.camel@redhat.com>
In-Reply-To: <3e4e33c19a9c608be863d2d7207f5a9cb7db795f.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA1PR10MB5993:EE_
x-ms-office365-filtering-correlation-id: 01ec7611-f392-4131-72d7-08db2fb8f486
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EbxYoDTBSc7PU5TqEvy1QqEuNzh0GUmlteHXmiKzPKunaVFYzRR5pP9rSOW8iQFnOO0CwkhJsXKuaod8ngZORl18Jdedv6ghafs0UKdzQDb0bGJPITwfrj37iUUbdKhxnEIGdt5pFsYpZH052XCXE42nJd6YjJ5CFT+ZDPnt4fkO2MkylqWiArQ9i7xHIuiW+S6moanxlUsTm5s2wIcHn8VQ18AI0PjwwFR/mrfUAuZMjMCEJLJld+c2SJP+F7KGfQ7lvg4JWIFqJjCbWlEWcprwypBn2yH4QTK5+ITFKasIL7bqB4xhdqBzKK+lSfYxDOlX5kvQcQcP+uFJaTYHTo8Vl9WmoJ0TVvQXs3M/W/t2c30tpn9DMF+/Y9WHFlUBc6dw2ueyqCxpY0Cqa5IWSvdzLh6/noTW0v8IUwqtBSXsCKASxkrFI1M+IcOLQsW79MoB2ViV0H3wFz40QH0tjWmURbpGPI1XmGYYNAbQIL1htrSb4Ytsc3SVzHR2BHrL9rzLbHauklf7yzf7+BsMb4Fo+4qU9jqVXk4tS6glB+7LKldZeWYkLePMnP21p8XZkQmBsqPC5M6vknKAINYg/pW+Ts8AbCeQa2akpINhyWfQbuG40NElFbTKBW9sgErDNce09xkELyEcA5y3n/vQ+u8tuaKn//T0zI81HOlXX5M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199021)(30864003)(66946007)(71200400001)(6486002)(2906002)(6506007)(41300700001)(54906003)(33656002)(122000001)(38070700005)(478600001)(107886003)(64756008)(66446008)(76116006)(6916009)(316002)(66476007)(186003)(5660300002)(36756003)(8936002)(91956017)(4326008)(66556008)(86362001)(8676002)(83380400001)(53546011)(38100700002)(6512007)(26005)(2616005)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rnL6p1ZL931HltoIIGvKgbF7DwUHMKm1cUVetV8U9Mdu8+OvBGQkRT1ZES6h?=
 =?us-ascii?Q?9EKtImp+/iHp3u1PCcbm5G8C1fxncMGLULkbLDjIBTqat3R84QADM3CeeQdH?=
 =?us-ascii?Q?W9MN+IoOeKcGncMl1fwIAcuR3XFOmmL+G6Dq1YcbKrZPdNhU35+wn5kFSzyD?=
 =?us-ascii?Q?BcgoZ2Ry8jCA9716c968CZ2IkayFJKPxl4PF+0bza/bFKbQm/13bc4Ret13h?=
 =?us-ascii?Q?VoMtoFd6KBjIvnf5RsyjufsfIboL4vqtiExDXBZceyaOmsqSQUHf1Rs0Mwpb?=
 =?us-ascii?Q?3MKMC4hBMRC0+EwgR2vD8VuTRaOECXbDK6jqsndqw1wpDSZ+yW0FhxqLQdYO?=
 =?us-ascii?Q?uKhXUUATDWHyeAlHBhNxiTOpiY8RsPFUXb1NnFOr3pjCsSknF6Q2JV2S3JUX?=
 =?us-ascii?Q?1V+CzTartosf15TbO26sTUNGG1hbnMUXycru/fAxVG2pKg6tYWyd3m+mkZ7x?=
 =?us-ascii?Q?s3ZlX4BIdRODbUeWzPDCS+zlrRDqojbbuOPZblgbbfXuIJqTiLFgYvnuehF5?=
 =?us-ascii?Q?KqFsjcNMSiuYxRj9txQS6h52Iv7GXdn559d5QVzx/pfm0FiS32zn7klsihPJ?=
 =?us-ascii?Q?omhvm1zKZXbUfm+Y6uhRNUCGjedkTS1kiBjUPXjQxCahYzUsrUD6G1uXB98I?=
 =?us-ascii?Q?u8+U2KKAT9JiFMwMtFr9QgC+9AHYla0HQWDcaydAuh9LsnpIQygpFgIEkJ79?=
 =?us-ascii?Q?IXECdv0QbmwYoFjAgOj/ZywgopoENd3WcGmEWMcR35B5zZMTW/ElPFGoJuO3?=
 =?us-ascii?Q?/VGkPhs02doIFd/3JjkYsPagQ379DXqblCuWEfXrro4XA840qBT4iXbxFl4q?=
 =?us-ascii?Q?lPKHfeK4HpU10pOJ8cSNKVi5LiwmhO9nOHejGZc+TmCFk0R2apTpZR+CTB6/?=
 =?us-ascii?Q?T9x6XQCXmwbW8xyjJGRXGUJxeGCpmsMbOrE6ZEZgMeqEu/Lbio1r2TQcSPgx?=
 =?us-ascii?Q?DCOd/tq4yhzXZq/GakegzNgObYgwtikGzWcbHXpQXhi2Ruuowy9oTcK25Si1?=
 =?us-ascii?Q?HulqYQRGRw1Uawk1fj2wAPJ/3fWTnpgseYR+OwgLkexEPBzLJg4Abv94A97a?=
 =?us-ascii?Q?Soq44S41IZvRq6nqCBj6Gu1D0VYm0nc6jl+lcvcbfyVxEnuTx/lfFXiVORpy?=
 =?us-ascii?Q?vY9HjjJ1qZYh/51d8IRvlViAb/m3UvC9KNCd6WwoN3T8mm4AmEV54S3FAjCt?=
 =?us-ascii?Q?cHpqq9qbrQI0vPcyAn0ZnD/TZr82R57a3YNKph2g/93hmhzmnUErs4yx7C/2?=
 =?us-ascii?Q?ZssraUoTJHX1/2U7E/8acIt/1wPM93uXGkKmhhMI4cSxyVhhMVwpgpFIDApT?=
 =?us-ascii?Q?ITsjYeYLeDL8tFFZhOMCFUQNAzI2FwKRlIcpe2TwSAtti/hie6RqHfSN3VKA?=
 =?us-ascii?Q?DLafD5X5q8eUQunLaRY6hRIh6kC4FFyGXG/G0GILe8snor3/Y1GB17GNXgWJ?=
 =?us-ascii?Q?LyrvUus32ifTxrmPZmoR/chvYJue6mRQ36bDgiPwxCPVxotaxrplUKQZMqJg?=
 =?us-ascii?Q?IjwOdMIBIzKEorvoGenQWgb+TT9W7DfZql00tXlDrUDRWPDyYC4GgQaAeSM5?=
 =?us-ascii?Q?Ng0llCpmHTXCM79kcZSsnqPPCjAujkKVUmVNRpOv/JCV7FtNRg7spkLfxise?=
 =?us-ascii?Q?Mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BD9FDC7C085C8D4ABC638767362C428C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wcVyqwzGM9aeQ9g9upW07WQfaxkZjuoqtcCXdJU/losbIzanXHAFHDf1VlzO0U1v+7SLan0nvs9OpBhN/ODEXLunlOVmMhdtThh2BuY3Sln+DGmWoSWtPfR2G1Xguy+Q/8wGNlHDyR3F9pXuaKCleVEfDDegJ2uH2TqOIJiLbOBnWpdBCIb2SzFHxuKicp+zxxAs3ZsGAOIoC0L1B3YId6VK0FS2QLI1rTnCrrxa6TfM0JGz52b2EHFSvjMuTPV2+PPVTBxy7KpLEc/Skl8lboTum3gKk52Hs60BseiWwx+RBBIEgS7MIwy5GJuSBIxgVOYkFGjOE7XlOh5727iK5kdjYI8ZjbWSoZGqWH1qD7Piw/+wmqKzV+9pgXbFcBZAypUpjSUSbxk7C7chQXkgDsIKmDssdVRVneUAGlFXvVBGxEZofGOQwAIS+fDZJt4nm91ugXE0CIrT/wnSqA42OZwSe5Y2hxNSMz/20QuhMKk72XvFcqAYBUDTVjiXxF36EuU0+bKO8C4CqkBVekxk7toeJtUO6WV4J1FyE5ujuEDgDGa6QGATT6vVptVI+qa7BYiP6f4xrii5VeYVqm5eHEBRdlyEnOma9hYRCkLpU7jvWLj92mnpa/mJpKbMgWiDiQCjACchza2HxjOCcbNgGkV+1rKIcvR9DJ1Jfn41XnqIu7v2lyluC+ify6fkb+uMF9n4qYyizrku+AHtPqrb0FTUUVvy3Q1QMHWcYaUXD8AYmbSHYZlS3QWFyFumkS24k+Q1VETRoaODnJKzE2uKUTTgSB1asVcCPh7tForzC3fa2c15BnZ76y3f6WRR7w7FGb0G4LBIjFAYa8qWcsKwfOIN2L1YGc3iuEbvFrd/tg/NbiDGvlJvrzMmhJJQvFZst05VKcrSYdpqGcMDw4hFow==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01ec7611-f392-4131-72d7-08db2fb8f486
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 18:19:22.5884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fNEoElVIN1j1IJqqHvMfWlcvshrcJY9wV6c+h/+WIJIa1SVpCgJLqMIRQKr9v664uRxKU6UeW7kCYXC1ydu+Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5993
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280143
X-Proofpoint-GUID: bNUV-TC0JqQkc6-pqYO02dGnqGvK-xmi
X-Proofpoint-ORIG-GUID: bNUV-TC0JqQkc6-pqYO02dGnqGvK-xmi
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 28, 2023, at 2:14 PM, Jeff Layton <jlayton@redhat.com> wrote:
>=20
> On Sat, 2023-03-18 at 12:18 -0400, Chuck Lever wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>>=20
>> When a kernel consumer needs a transport layer security session, it
>> first needs a handshake to negotiate and establish a session. This
>> negotiation can be done in user space via one of the several
>> existing library implementations, or it can be done in the kernel.
>>=20
>> No in-kernel handshake implementations yet exist. In their absence,
>> we add a netlink service that can:
>>=20
>> a. Notify a user space daemon that a handshake is needed.
>>=20
>> b. Once notified, the daemon calls the kernel back via this
>>   netlink service to get the handshake parameters, including an
>>   open socket on which to establish the session.
>>=20
>> c. Once the handshake is complete, the daemon reports the
>>   session status and other information via a second netlink
>>   operation. This operation marks that it is safe for the
>>   kernel to use the open socket and the security session
>>   established there.
>>=20
>> The notification service uses a multicast group. Each handshake
>> mechanism (eg, tlshd) adopts its own group number so that the
>> handshake services are completely independent of one another. The
>> kernel can then tell via netlink_has_listeners() whether a handshake
>> service is active and prepared to handle a handshake request.
>>=20
>> A new netlink operation, ACCEPT, acts like accept(2) in that it
>> instantiates a file descriptor in the user space daemon's fd table.
>> If this operation is successful, the reply carries the fd number,
>> which can be treated as an open and ready file descriptor.
>>=20
>> While user space is performing the handshake, the kernel keeps its
>> muddy paws off the open socket. A second new netlink operation,
>> DONE, indicates that the user space daemon is finished with the
>> socket and it is safe for the kernel to use again. The operation
>> also indicates whether a session was established successfully.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>> Documentation/netlink/specs/handshake.yaml |  122 +++++++++++
>> MAINTAINERS                                |    8 +
>> include/trace/events/handshake.h           |  159 ++++++++++++++
>> include/uapi/linux/handshake.h             |   70 ++++++
>> net/Kconfig                                |    5=20
>> net/Makefile                               |    1=20
>> net/handshake/Makefile                     |   11 +
>> net/handshake/genl.c                       |   57 +++++
>> net/handshake/genl.h                       |   23 ++
>> net/handshake/handshake.h                  |   82 +++++++
>> net/handshake/netlink.c                    |  316 ++++++++++++++++++++++=
++++++
>> net/handshake/request.c                    |  307 ++++++++++++++++++++++=
+++++
>> net/handshake/trace.c                      |   20 ++
>> 13 files changed, 1181 insertions(+)
>> create mode 100644 Documentation/netlink/specs/handshake.yaml
>> create mode 100644 include/trace/events/handshake.h
>> create mode 100644 include/uapi/linux/handshake.h
>> create mode 100644 net/handshake/Makefile
>> create mode 100644 net/handshake/genl.c
>> create mode 100644 net/handshake/genl.h
>> create mode 100644 net/handshake/handshake.h
>> create mode 100644 net/handshake/netlink.c
>> create mode 100644 net/handshake/request.c
>> create mode 100644 net/handshake/trace.c
>>=20
>>=20
>=20
> [...]
>=20
>> diff --git a/net/handshake/request.c b/net/handshake/request.c
>> new file mode 100644
>> index 000000000000..3f8ae9e990d2
>> --- /dev/null
>> +++ b/net/handshake/request.c
>> @@ -0,0 +1,307 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Handshake request lifetime events
>> + *
>> + * Author: Chuck Lever <chuck.lever@oracle.com>
>> + *
>> + * Copyright (c) 2023, Oracle and/or its affiliates.
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <linux/socket.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/skbuff.h>
>> +#include <linux/inet.h>
>> +#include <linux/fdtable.h>
>> +#include <linux/rhashtable.h>
>> +
>> +#include <net/sock.h>
>> +#include <net/genetlink.h>
>> +#include <net/netns/generic.h>
>> +
>> +#include <uapi/linux/handshake.h>
>> +#include "handshake.h"
>> +
>> +#include <trace/events/handshake.h>
>> +
>> +/*
>> + * We need both a handshake_req -> sock mapping, and a sock ->
>> + * handshake_req mapping. Both are one-to-one.
>> + *
>> + * To avoid adding another pointer field to struct sock, net/handshake
>> + * maintains a hash table, indexed by the memory address of @sock, to
>> + * find the struct handshake_req outstanding for that socket. The
>> + * reverse direction uses a simple pointer field in the handshake_req
>> + * struct.
>> + */
>> +
>> +static struct rhashtable handshake_rhashtbl ____cacheline_aligned_in_sm=
p;
>> +
>> +static const struct rhashtable_params handshake_rhash_params =3D {
>> +	.key_len		=3D sizeof_field(struct handshake_req, hr_sk),
>> +	.key_offset		=3D offsetof(struct handshake_req, hr_sk),
>> +	.head_offset		=3D offsetof(struct handshake_req, hr_rhash),
>> +	.automatic_shrinking	=3D true,
>> +};
>> +
>> +int handshake_req_hash_init(void)
>> +{
>> +	return rhashtable_init(&handshake_rhashtbl, &handshake_rhash_params);
>> +}
>> +
>> +void handshake_req_hash_destroy(void)
>> +{
>> +	rhashtable_destroy(&handshake_rhashtbl);
>> +}
>> +
>> +struct handshake_req *handshake_req_hash_lookup(struct sock *sk)
>> +{
>> +	return rhashtable_lookup_fast(&handshake_rhashtbl, &sk,
>=20
> Is this correct? It seems like we should be searching for the struct
> sock pointer value, not on the pointer to the pointer (which will be a
> stack var), right?

I copied this from the nfsd_file and nfs4_file code we added recently.
rhashtable_lookup_fast takes a pointer to the key, so a pointer to a
pointer should be correct in this case.


>> +				      handshake_rhash_params);
>> +}
>> +
>> +static noinline bool handshake_req_hash_add(struct handshake_req *req)
>> +{
>> +	int ret;
>> +
>> +	ret =3D rhashtable_lookup_insert_fast(&handshake_rhashtbl,
>> +					    &req->hr_rhash,
>> +					    handshake_rhash_params);
>> +	return ret =3D=3D 0;
>> +}
>> +
>> +static noinline void handshake_req_destroy(struct handshake_req *req)
>> +{
>> +	if (req->hr_proto->hp_destroy)
>> +		req->hr_proto->hp_destroy(req);
>> +	rhashtable_remove_fast(&handshake_rhashtbl, &req->hr_rhash,
>> +			       handshake_rhash_params);
>> +	kfree(req);
>> +}
>> +
>> +static void handshake_sk_destruct(struct sock *sk)
>> +{
>> +	void (*sk_destruct)(struct sock *sk);
>> +	struct handshake_req *req;
>> +
>> +	req =3D handshake_req_hash_lookup(sk);
>> +	if (!req)
>> +		return;
>> +
>> +	trace_handshake_destruct(sock_net(sk), req, sk);
>> +	sk_destruct =3D req->hr_odestruct;
>> +	handshake_req_destroy(req);
>> +	if (sk_destruct)
>> +		sk_destruct(sk);
>> +}
>> +
>> +/**
>> + * handshake_req_alloc - consumer API to allocate a request
>> + * @sock: open socket on which to perform a handshake
>> + * @proto: security protocol
>> + * @flags: memory allocation flags
>> + *
>> + * Returns an initialized handshake_req or NULL.
>> + */
>> +struct handshake_req *handshake_req_alloc(struct socket *sock,
>> +					  const struct handshake_proto *proto,
>> +					  gfp_t flags)
>> +{
>> +	struct sock *sk =3D sock->sk;
>> +	struct net *net =3D sock_net(sk);
>> +	struct handshake_net *hn =3D handshake_pernet(net);
>> +	struct handshake_req *req;
>> +
>> +	if (!hn)
>> +		return NULL;
>> +
>> +	req =3D kzalloc(struct_size(req, hr_priv, proto->hp_privsize), flags);
>> +	if (!req)
>> +		return NULL;
>> +
>> +	sock_hold(sk);
>> +
>> +	INIT_LIST_HEAD(&req->hr_list);
>> +	req->hr_sk =3D sk;
>> +	req->hr_proto =3D proto;
>> +	return req;
>> +}
>> +EXPORT_SYMBOL(handshake_req_alloc);
>> +
>> +/**
>> + * handshake_req_private - consumer API to return per-handshake private=
 data
>> + * @req: handshake arguments
>> + *
>> + */
>> +void *handshake_req_private(struct handshake_req *req)
>> +{
>> +	return (void *)&req->hr_priv;
>> +}
>> +EXPORT_SYMBOL(handshake_req_private);
>> +
>> +static bool __add_pending_locked(struct handshake_net *hn,
>> +				 struct handshake_req *req)
>> +{
>> +	if (!list_empty(&req->hr_list))
>> +		return false;
>> +	hn->hn_pending++;
>> +	list_add_tail(&req->hr_list, &hn->hn_requests);
>> +	return true;
>> +}
>> +
>> +void __remove_pending_locked(struct handshake_net *hn,
>> +			     struct handshake_req *req)
>> +{
>> +	hn->hn_pending--;
>> +	list_del_init(&req->hr_list);
>> +}
>> +
>> +/*
>> + * Returns %true if the request was found on @net's pending list,
>> + * otherwise %false.
>> + *
>> + * If @req was on a pending list, it has not yet been accepted.
>> + */
>> +static bool remove_pending(struct handshake_net *hn, struct handshake_r=
eq *req)
>> +{
>> +	bool ret;
>> +
>> +	ret =3D false;
>> +
>> +	spin_lock(&hn->hn_lock);
>> +	if (!list_empty(&req->hr_list)) {
>> +		__remove_pending_locked(hn, req);
>> +		ret =3D true;
>> +	}
>> +	spin_unlock(&hn->hn_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +/**
>> + * handshake_req_submit - consumer API to submit a handshake request
>> + * @req: handshake arguments
>> + * @flags: memory allocation flags
>> + *
>> + * Return values:
>> + *   %0: Request queued
>> + *   %-EBUSY: A handshake is already under way for this socket
>> + *   %-ESRCH: No handshake agent is available
>> + *   %-EAGAIN: Too many pending handshake requests
>> + *   %-ENOMEM: Failed to allocate memory
>> + *   %-EMSGSIZE: Failed to construct notification message
>> + *   %-EOPNOTSUPP: Handshake module not initialized
>> + *
>> + * A zero return value from handshake_request() means that
>> + * exactly one subsequent completion callback is guaranteed.
>> + *
>> + * A negative return value from handshake_request() means that
>> + * no completion callback will be done and that @req has been
>> + * destroyed.
>> + */
>> +int handshake_req_submit(struct handshake_req *req, gfp_t flags)
>> +{
>> +	struct sock *sk =3D req->hr_sk;
>> +	struct net *net =3D sock_net(sk);
>> +	struct handshake_net *hn =3D handshake_pernet(net);
>> +	int ret;
>> +
>> +	if (!hn)
>> +		return -EOPNOTSUPP;
>> +
>> +	ret =3D -EAGAIN;
>> +	if (READ_ONCE(hn->hn_pending) >=3D hn->hn_pending_max)
>> +		goto out_err;
>> +
>> +	req->hr_odestruct =3D sk->sk_destruct;
>> +	sk->sk_destruct =3D handshake_sk_destruct;
>> +	spin_lock(&hn->hn_lock);
>> +	ret =3D -EOPNOTSUPP;
>> +	if (test_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags))
>> +		goto out_unlock;
>> +	ret =3D -EBUSY;
>> +	if (!handshake_req_hash_add(req))
>> +		goto out_unlock;
>> +	if (!__add_pending_locked(hn, req))
>> +		goto out_unlock;
>> +	spin_unlock(&hn->hn_lock);
>> +
>> +	ret =3D handshake_genl_notify(net, req->hr_proto->hp_handler_class,
>> +				    flags);
>> +	if (ret) {
>> +		trace_handshake_notify_err(net, req, sk, ret);
>> +		if (remove_pending(hn, req))
>> +			goto out_err;
>> +	}
>> +
>> +	trace_handshake_submit(net, req, sk);
>> +	return 0;
>> +
>> +out_unlock:
>> +	spin_unlock(&hn->hn_lock);
>> +out_err:
>> +	trace_handshake_submit_err(net, req, sk, ret);
>> +	handshake_req_destroy(req);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(handshake_req_submit);
>> +
>> +void handshake_complete(struct handshake_req *req, unsigned int status,
>> +			struct genl_info *info)
>> +{
>> +	struct sock *sk =3D req->hr_sk;
>> +	struct net *net =3D sock_net(sk);
>> +
>> +	if (!test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
>> +		trace_handshake_complete(net, req, sk, status);
>> +		req->hr_proto->hp_done(req, status, info);
>> +		__sock_put(sk);
>> +	}
>> +}
>> +
>> +/**
>> + * handshake_req_cancel - consumer API to cancel an in-progress handsha=
ke
>> + * @sock: socket on which there is an ongoing handshake
>> + *
>> + * XXX: Perhaps killing the user space agent might also be necessary?
>> + *
>> + * Request cancellation races with request completion. To determine
>> + * who won, callers examine the return value from this function.
>> + *
>> + * Return values:
>> + *   %true - Uncompleted handshake request was canceled or not found
>> + *   %false - Handshake request already completed
>> + */
>> +bool handshake_req_cancel(struct socket *sock)
>> +{
>> +	struct handshake_req *req;
>> +	struct handshake_net *hn;
>> +	struct sock *sk;
>> +	struct net *net;
>> +
>> +	sk =3D sock->sk;
>> +	net =3D sock_net(sk);
>> +	req =3D handshake_req_hash_lookup(sk);
>> +	if (!req) {
>> +		trace_handshake_cancel_none(net, req, sk);
>> +		return true;
>> +	}
>> +
>> +	hn =3D handshake_pernet(net);
>> +	if (hn && remove_pending(hn, req)) {
>> +		/* Request hadn't been accepted */
>> +		trace_handshake_cancel(net, req, sk);
>> +		return true;
>> +	}
>> +	if (test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
>> +		/* Request already completed */
>> +		trace_handshake_cancel_busy(net, req, sk);
>> +		return false;
>> +	}
>> +
>> +	__sock_put(sk);
>> +	trace_handshake_cancel(net, req, sk);
>> +	return true;
>> +}
>> +EXPORT_SYMBOL(handshake_req_cancel);
>> diff --git a/net/handshake/trace.c b/net/handshake/trace.c
>> new file mode 100644
>> index 000000000000..1c4d8e27e17a
>> --- /dev/null
>> +++ b/net/handshake/trace.c
>> @@ -0,0 +1,20 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Trace points for transport security layer handshakes.
>> + *
>> + * Author: Chuck Lever <chuck.lever@oracle.com>
>> + *
>> + * Copyright (c) 2023, Oracle and/or its affiliates.
>> + */
>> +
>> +#include <linux/types.h>
>> +
>> +#include <net/sock.h>
>> +#include <net/netlink.h>
>> +#include <net/genetlink.h>
>> +
>> +#include "handshake.h"
>> +
>> +#define CREATE_TRACE_POINTS
>> +
>> +#include <trace/events/handshake.h>
>>=20
>>=20
>>=20
>=20
> --=20
> Jeff Layton <jlayton@redhat.com>

--
Chuck Lever


