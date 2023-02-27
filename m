Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC16A494E
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjB0SLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjB0SLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:11:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BBC1F495
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:11:04 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RG0Sqa010775;
        Mon, 27 Feb 2023 18:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=rXw3VlSTqxH3KyXFX0gUNLS4Q1f6ZSdrKKc4h8VNy+I=;
 b=IPf+9FtQaLux6/FBylN7BF0hkYNgHR6QV1FwA07eF5BSjqaQ9lKchTvPsggNf16jg0SU
 kj4kKTsHyahGOdV4LLkutQ54nuUqhhg6OWLSkbx71F7FeZYgdNUCvgUK+PNGm4v4wtT2
 QFMh6AUvxPXUkjX9rKpbWZffd/DUMRWQ5RbiiixbTEcRGLw4Nv+E4oDf7wS0UgVj9bW+
 p/HY+iluSXV0FaAVrS75tgjQUdhlEN6d5/KMXY7xyPEIIL5ig1vsXGZMQGr00B7VFMbI
 RUqmwqxnTzZwXgUQ8rzClU4/Sl774K0TlseJHTJdvBfFsqBrOZIxasTReXSSbDVVb7Nw 9A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb7wm9qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 18:10:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31RGudYq013095;
        Mon, 27 Feb 2023 18:10:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s5n1yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 18:10:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzWun5mItLJxbsImgku4uSaZq9H9BwQSdoIUgnyxBzVo6052JDNhW75e+vthinGtWR/XUdlUDky+CyCjQ5/0OLasjp7yE/6syLaWr9L7BuIQqWOgLNqzrYLPEzm9zqd91fRe/Ywev5D6lQY3DB3w585+sQlWmLAjrDr+K7VeqVyKMi5yFi+Y97ujcfxFOlI7hIzuHT/d1uzB82Cxib2c4nk25MTrEjQcnfLHA7QzeE3+op7hj3nOWrcJ1kYhm3RRxNNmcj+MUrVz2/LZrAHjuSMoXwtYtgOnflbtQy8lwoXuZ4HXKbiq+qmv95IlhwnUyQi/tWdjMRTbl9FeIgTF1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXw3VlSTqxH3KyXFX0gUNLS4Q1f6ZSdrKKc4h8VNy+I=;
 b=hrR6BtAXGwXFNinPRPbqlR/gKO74gr4+Lmr4JAH8DaBbh0uzf6c9m2CBSW5oM/447nng21rDqEA63JmGg54uOxVxbj11N9/Zu2cEyqvmd5lVNxQgF8x4W3hnit/8oI8OdxkeYuL4CYXBK7BleC/gInD46z7w0X5mVL1DMjnrrYhxvE5NvvE+Umx9+xf556IeUQ4UXHLrx0NhFpoKPIq2jixgnVI4PmomHV9MfTIaNGqTpiiNhruRPPYviY7rD5Z5XXQTxCNHZrLVp59BW+QWPIns7d/wKCn3R2/qS9RMdlquusgmicFqHOpsYqq3ENtEwEnMbm8W6Y56Nazii6ZClw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXw3VlSTqxH3KyXFX0gUNLS4Q1f6ZSdrKKc4h8VNy+I=;
 b=EJ7W2iN++BQNwuDAVakvAAtlk9ErEAXA1H8ECed8RJ+/v3m+W6SPG+En25dCF3nigB7+TLdPsn7XiGHhVfUMMmm87e6qjCNB0OzSf0OrZjRRxSQZtPU0z6TInkU0zIEk/ILdMpfe1ynsVY5uVprjgXkAUCbsWiza0KFG/3gp4BI=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH7PR10MB6554.namprd10.prod.outlook.com (2603:10b6:510:205::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.14; Mon, 27 Feb
 2023 18:10:50 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%7]) with mapi id 15.20.6156.016; Mon, 27 Feb 2023
 18:10:50 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     Chuck Lever <cel@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>
Subject: Re: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZSITpzXcU72XpWUqa2tRUnzVdcK7iiYuAgABdpYCAAARFAIAABu2AgAAcTACAAA3tAA==
Date:   Mon, 27 Feb 2023 18:10:50 +0000
Message-ID: <69541D93-7693-4631-9263-DE77D289AA71@oracle.com>
References: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
 <167726635921.5428.7879951165266317921.stgit@91.116.238.104.host.secureserver.net>
 <17a96448-b458-6c92-3d8b-c82f2fb399ed@suse.de>
 <1B595556-0236-49F3-A8B0-ECF2332450D4@oracle.com>
 <006c4e44-572b-a6f8-9af0-5f568913e7a0@suse.de>
 <90C7DF9C-6860-4317-8D01-C60C718C8257@oracle.com>
 <71affa5a-d6fa-d76b-10a1-882a9107a3b4@suse.de>
In-Reply-To: <71affa5a-d6fa-d76b-10a1-882a9107a3b4@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH7PR10MB6554:EE_
x-ms-office365-filtering-correlation-id: d8b2ec1c-bd3d-4488-b968-08db18edf56a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +7scKSRrqd0nqBGEVP0kfWfsBZf6NID4yp05OhuKivI40j/La2FtAAsQVtrJgDT9OS3SMdChC/wbC31A3frJEMvFtmWcNhWLEAk6BbO6I1T+g5f7/bQLCkJR+5sgKftjNKBHEMEnihGkT/g9cSp7vFfTaDTDP2f3tPWXLR/p6B9QzqsZZbEKpREOacQg2H6Vex9duo782tul/qfZRCn0m7yRVFtDC1g3BJhkUGLoxL4p2kOH0Z/zYDtjvTIIrts8GqzZreqz06HZ4r5YATz6DLZRezLnGugYljZnQAKUfJdZG8DNTYZA8SfRGKIQcnJaDFOCeqi2ZXlezewdsRQZR1Zy0sRfuUQ1i93CRwOpZRTtERkUA0JqiceB91K92U/g9Vl355Basog65nePMiLOAD5TyslhoUOy/LmoHUSDELWpC+8fs46o2dKa7TdaDb/6I0JJyggEGBXztwboaBYgqqEL9t2/XsDrGx2NwJoiT/witAn6wPWgu23C2vA+iWrpA8z2r49lQB9hxyQ9K0iMnMcI2+tbBy8C2VjgtPUe1MRf6bSa99ZtO0cmoPw8Zsx9kqR6o9IpLWRS4nOOJJnys5XYoR7iIUTKUJ2PlPE+o7MAemdXRuwPia1JQ2EDtHF7AaVY39/mJVV3n7xvyJvcSsDGxiMHNjbE5EjeIqeXEMPhWfiOkhWTG9JMeLGgM/WUN5GAtjdZFToDWZrEczRwufLFja8p8W2GgC/saP5LOjY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199018)(66899018)(316002)(33656002)(36756003)(54906003)(86362001)(26005)(38100700002)(122000001)(6506007)(83380400001)(6512007)(53546011)(38070700005)(186003)(2616005)(91956017)(5660300002)(71200400001)(8936002)(2906002)(6486002)(478600001)(6916009)(4326008)(41300700001)(8676002)(76116006)(66446008)(66946007)(66556008)(66476007)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1snZ8ClYvBUrotwwJolQ7YlJ2e/bOPzlZjDgE3SuxWlB4dENHNXj8VNhL9iu?=
 =?us-ascii?Q?2gYXIAh1ic1fFrZg662eFDJlI/8ARXfGd5lEZsMg73k+jPQcSLOgoOGUj5pp?=
 =?us-ascii?Q?SfmzevcSN+ob0qlDx9I4KmQ6XVI5IdSQQzop+D9QxVNSELv78a7WcTtGtocs?=
 =?us-ascii?Q?UtJWC/Ywlkd7JXn+s4ABCpDhQJiB9nM83zN/GtbavZdw+HCdzxXzLHizSfvt?=
 =?us-ascii?Q?e/BuFE7IjB1koRO64OVwDiejsjkkvje3eGvemAesuzgmbJgZBKRxa9Whz7mr?=
 =?us-ascii?Q?BDpjEAhjSQF3cKjsaNQ9l/0VWDxPpFxtm9FmAsdv2b01zw7EwAbJbleURdIx?=
 =?us-ascii?Q?y8HifEFGug9i/6ybrIUqHs0xxKmLdPm51VWasEm5oMHiRVrRxa+4n9MR/+fi?=
 =?us-ascii?Q?8j1JfL7gatztv+SmZu+90E8gRfPYt1dVlL4Uw7slQZbDh559wtfebRaKJqN1?=
 =?us-ascii?Q?ML+HSzOmk+gYJXZoaogeQfOvzYtbt6jA7Gk0IRpqO+1UOqzQ2Cdbw/sDMBkC?=
 =?us-ascii?Q?RzMxD47cJL10uW7x0c0D6FAGdTw9G2YN0f5jb2VCYYH1j2JiO8ExyZhKTXUA?=
 =?us-ascii?Q?fvP5IwLXi40ZXhrsHXXdTk69MKNBAcxyrqeoxH9c4bmheM9LjlYDOMLtCSLc?=
 =?us-ascii?Q?TujlkSIh2jc2SQNvnumFS6tG96R7JdORjm41dYT1xcXReEO2gUL/5eTSHEQW?=
 =?us-ascii?Q?p9L+aXRyA0sDkCEMLg8MuJd022UvaqqRl8Ud6Mc3lfOvm/VhU2BTd5EaqCXo?=
 =?us-ascii?Q?r+upqobecqFmJmdxhjyIdxQcOamleDo6OYMQQUm2BG1ZgLm8iOV+9o1+Bs1L?=
 =?us-ascii?Q?4aTPvFdfHQXbWYFA6fPygNuU6D6B4JPz5sUWQT3T7M7pt36yCuHjs6Lwxexa?=
 =?us-ascii?Q?Fmsjr7M/5sXE917bDtkCSrR4+dHBqPXRyEdctL/CzWl0TS+aGiviXzDsi2VU?=
 =?us-ascii?Q?WLNYvlApIRM16zhwWhLPyyxJzdfgv80rQq7G3xIrk3pbYNUeEGYOUg9GDC/M?=
 =?us-ascii?Q?yosvbYmfas1q8GmLX6+YGVEDhNhZpdWAKxIoHyf7aHckmALJpCJG5vf3UIz3?=
 =?us-ascii?Q?g9T1WCqHiEHPayjHqkT/5/lDHHGtM7V1EVrHsottdONCuzhpUmQBiKj4YyCy?=
 =?us-ascii?Q?aCLtJ0EN0tTv6UjrDb29MouvMy4ZjkUXGnirGe0Gm9V9YLcew+ruqBF1OFIb?=
 =?us-ascii?Q?wQy0Pm1xIqVJo+MSgvbd80zZA2vN7/0zRiCb0Ps3kujrjf7PBUX0EXTkl2z/?=
 =?us-ascii?Q?W++1rna34DMTnDBN5Wy4emNtlKLgbd/gYAQVPtOleVzpXO0sG2fQuBsdaPac?=
 =?us-ascii?Q?SN+UIPS9tV4VVY+LfUg5MYIUynfDyvIeMLydVweRSkzsvJuTBNS28A4Id/3A?=
 =?us-ascii?Q?VDTiHubq6Ug2rZ/lo5vRifC3Ua9D924KinT0gmIw7i/wc9fmCZp9XZX7n+Db?=
 =?us-ascii?Q?SFToJW0E05Qcw2nqftCFSpNSXuEJlis+N3laIV1/jSXjf9LOUkcyKou4RQrW?=
 =?us-ascii?Q?1OHnK6qJUqbJGBpDv/ol52qiyptSWSvkTUeWrhnXrm95O2j2F8p+LCEB2jMp?=
 =?us-ascii?Q?NTjThMGBR4+iy6guV01RfLlBUydIWlGV3Ynb7nXpUagZrTrtu/DxdP6L29fk?=
 =?us-ascii?Q?mA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2D084D10F8402D43B2180D2C121C4994@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UWqnw+3tn6D0FBLxt0csczFbrrAlDN+Nytq51VLsy9vt24EnmHOUAd3ssOFpUnYdy92W3cX3Irb1I8lPFW1YjV7EVR2WIp4Hx4YqU2JMdYccohBZ+rjWD8uhRJ/sPoRB3CaneGgDdNToQys2rEM7qZ+JjU/WQ7Y01mtcBuu6Eey4tDotKZaRM2ZX/UAuLW1vczQ/bd+BrZAzyfbgerUVKb6tCcIstrJ4V81pOSAw+GeoFWasrZOSjK5O36kapQYp1wP691PBMOh1uiJKOjHLwkQlx6Y8BFdNJUlHClzWRkRj5W7MqW5HwtvoktleevGYgGZAhvq6+VTvTAhb6fozNnCyZNi9k31GGCPXZtAyBw8hOOMrDzIrn1Jckbh6Qvm1fBoKgilOf7k97W0JyeRkYfJSU+cf0yaZwBz/E+Zj8Nyh5O4JrwW0/NV82uN4q2RLL4sL7HHQHGWkeHt0+Zj1LubiA11iHImlYctJuZaYxp+gqlA4xn9ob+FnxuvRY1tw5dqeSfXn3DqGQCUNA2Sdj+HPUtWEFz3jwcbD8OH84YxbMJteZEZJ5tipXe7VfkA1ld465sdFzj0Vwk87j2FbEHxz/DDbcjOel1zNhlgMExRVCoi14HLcYTriDjnU0lW1JWM611RKtReClwS/7fc4NoOILzfa77zRsdnseaHYG1tgnxJ6z7dQLquOUje9LtP2XLjTOT4afSf89Ymvo6X7/+kKdh7SJ4fdlKNvfuIQnbC2mHMG4ULHquoBngeh9H7xfeN6zj98JHRw00UaZ/yOku/evJOjFiFgKm1V8Kt6p1mo2at8pZClnMrtdamxm/ecvZogO+ahXzENYL/6fiNVIGxR/guVHuAwxOIApYhthp/+S7Qjw0VMGZAox2PRNeE1fUyAh3B06Zh/Gbxrc7mw5ED9eNSQLC8qguv0C+MZcUY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b2ec1c-bd3d-4488-b968-08db18edf56a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 18:10:50.5869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ofws0GD+3YQ2zQ1Kk+VXyOOdOUOQejaLmptnpAeEFY+tyzzMRiTPe8ZK18w4ObnDdd2j7/lkMdoiyC5zQjWQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6554
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_15,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=508 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302270142
X-Proofpoint-GUID: T6PP5pIGRBbN8QfF_ffz9BUbcVSGXzH5
X-Proofpoint-ORIG-GUID: T6PP5pIGRBbN8QfF_ffz9BUbcVSGXzH5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 27, 2023, at 12:21 PM, Hannes Reinecke <hare@suse.de> wrote:
>=20
>> On 2/27/23 16:39, Chuck Lever III wrote:
>>> On Feb 27, 2023, at 10:14 AM, Hannes Reinecke <hare@suse.de> wrote:
>>>=20
>>> Problem here is with using different key materials.
>>> As the current handshake can only deal with one key at a time
>>> the only chance we have for several possible keys is to retry
>>> the handshake with the next key.
>>> But out of necessity we have to use the _same_ connection
>>> (as tlshd doesn't control the socket). So we cannot close
>>> the socket, and hence we can't notify userspace to give up the handshak=
e attempt.
>>> Being able to send a signal would be simple; sending SIGHUP to userspac=
e, and wait for the 'done' call.
>>> If it doesn't come we can terminate all attempts.
>>> But if we get the 'done' call we know it's safe to start with the next =
attempt.
>> We solve this problem by enabling the kernel to provide all those
>> materials to tlshd in one go.
> Ah. Right, that would work, too; provide all possible keys to the 'accept=
' call and let the userspace agent figure out what to do with them. That ma=
kes life certainly easier for the kernel side.
>=20
>> I don't think there's a "retry" situation here. Once the handshake
>> has failed, the client peer has to know to try again. That would
>> mean retrying would have to be part of the upper layer protocol.
>> Does an NVMe initiator know it has to drive another handshake if
>> the first one fails, or does it rely on the handshake itself to
>> try all available identities?
>> We don't have a choice but to provide all the keys at once and
>> let the handshake negotiation deal with it.
>> I'm working on DONE passing multiple remote peer IDs back to the
>> kernel now. I don't see why ACCEPT couldn't pass multiple peer IDs
>> the other way.
> Nope. That's not required.
> DONE can only ever have one peer id (TLS 1.3 specifies that the client se=
nds a list of identities, the server picks one, and sends that one back to =
the client). So for DONE we will only ever have 1 peer ID.
> If we allow for several peer IDs to be present in the client ACCEPT messa=
ge then we'd need to include the resulting peer ID in the client DONE, too;=
 otherwise we'll need it for the server DONE only.
>=20
> So all in all I think we should be going with the multiple IDs in the ACC=
EPT call (ie move the key id from being part of the message into an attribu=
te), and have a peer id present in the DONE all for both versions, server a=
nd client.

To summarize:

---

The ACCEPT request (from tlshd) would have just the handler class
"Which handler is responding". The kernel uses that to find a
handshake request waiting for that type of handler. In our case,
"tlshd".

The ACCEPT response (from the kernel) would have the socket fd,
the handshake parameters, and zero or more peer ID key serial
numbers. (Today, just zero or one peer IDs).

There is also an errno status in the ACCEPT response, which
the kernel can use to indicate things like "no requests in that
class were found" or that the request was otherwise improperly
formed.

---

The DONE request (from tlshd) would have the socket fd (and
implicitly, the handler's PID), the session status, and zero
or one remote peer ID key serial numbers.

The DONE response (from the kernel) is an ACK. (Today it's
more than that, but that's broken and will be removed).

---

For the DONE request, the session status is one of:

0: session established -- see @peerid for authentication status
EIO: local error
EACCES: handshake rejected

For server handshake completion:

@peerid contains the remote peer ID if the session was
authenticated, or TLS_NO_PEERID if the session was not
authenticated.

status =3D=3D EACCES if authentication material was present from
both peers but verification failed.

For client handshake completion:

@peerid contains the remote peer ID if authentication was
requested and the session was authenticated

status =3D=3D EACCES if authentication was requested and the
session was not authenticated, or if verification failed.

(Maybe client could work like the server side, and the
kernel consumer would need to figure out if it cares
whether there was authentication).


Is that adequate?


--
Chuck Lever



