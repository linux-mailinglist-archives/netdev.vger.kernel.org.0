Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D54E699AAF
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBPQ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBPQ6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:58:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F724B507
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:58:13 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GFO9ti009134;
        Thu, 16 Feb 2023 16:58:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=/ZPE3hrVV+IXU/cOTWmYNXC5lbkeB1yG9t569bLIJoc=;
 b=1k0teJi0IJehiCxSYG0K3I01LHH830CMV7otAlNQJYkkZQ7cR08Lthem0lMkFi522u5L
 VgzslnCJSA+duXmwSw3K75U0rJUTE4PmuCea9LH2bD6mf4BXoeDAGyEUmirMrqaTzlUK
 lvp3tXVuKAiHXN1/Ec7BZYUhe/Z/NnecCg8mv98XBD9ucXjghxIoEz5Zpm6dQdgbosFy
 9dgRO/RO0hKoEKt19MHn7F2abRWv3qV1IzjydcjB+85bRl5Zq2CgK3N3eAyLSyXT57Dn
 rLYQkIJRg/2FDfIjIIG41MhKYUo9phCeqst61FZhXVADv8Ziqluv7KTltiXeylFGlBBg 8Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2wa3rag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 16:58:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31GG7Ett015162;
        Thu, 16 Feb 2023 16:58:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f8w0f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 16:58:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkEvUIlWYXHOy7TrAzzULxXpEv4ReOasSMb3ZiMA/l6PI+Qj49orzkxmL3phxVRoFjr3m0F0FILzUMpKaaKF9cOn+r/PMHggntrIvhoogKrfDenAGeqrNPHGnOJ1kJfoBP37sAW5TKu1RaHQs5RXVeC30LY0G8w56PQaXJPBGWqJcXFx6Xz3tNXpcDMgYunHJUPbggTJ1CQSf5g3ZxuPYiVHYc9NawD1npuGxG2j8lNyn6L5GsmFCFZ+6sLyPRnMa7147euC1cm8JdeoUg4dx31CcO8h2ifaXfPETbHXm5273bm6dfST3Xw8t6W442TsnWxgOa2V7Lk5nscYPY8eSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZPE3hrVV+IXU/cOTWmYNXC5lbkeB1yG9t569bLIJoc=;
 b=GR3fmLDLL5+DxFgEtRWZ0W4CE7f7rKR9uDSKnWBet9tnp1l4m8Kyu70TFHRKkSJSlVQr8t810iMw4KrJDgTtcDqny+At8p7K5dD0Y0v1ty2UD1lfHL/1mgKZECw0eIVmE6UtseAFiB2tB3InwJ9iNRG/nVZIv0/v4ByQKHq1ClwLCnK/70T6GldRiWD8sH60mCwHoKWNwoeVMGaTsnQDNz4rsMdzx8VI/DateoqgFgxw26cuddydKUEq2xufHx7cILlh5b/sAvW4OR+EJ1k5FN6hzwRorPjvjwQiiU//7MM4ItuyYH8i5vR7We8lAoKxDXhFmVMLyoiBcul8bbdvaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZPE3hrVV+IXU/cOTWmYNXC5lbkeB1yG9t569bLIJoc=;
 b=drsByL0Oq6kSUZGjUJmVWh9LvDZew6Brkqm9vCU9ivw1bRlBfRcEBKRvbWiTz/6+/0X8qUCyw4kvbjcdhfnjoJ7lHNYemmC1kO2UZpJOmuU+kzJBJQ6ksFoA7SBOLU1VShhfyZwhqCpWyxjz6InyKviRJMSVVYemFJGbDVpEbaM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH0PR10MB5097.namprd10.prod.outlook.com (2603:10b6:610:c2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.6; Thu, 16 Feb
 2023 16:58:02 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%6]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 16:58:02 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v4 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v4 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZQXL4y0AJVz+Er0ij5JPtxaDJBK7RjaUAgAAikACAAByMgA==
Date:   Thu, 16 Feb 2023 16:58:02 +0000
Message-ID: <CFE94D37-1B2B-41D4-877F-081E15660497@oracle.com>
References: <167648817566.5586.11847329328944648217.stgit@91.116.238.104.host.secureserver.net>
 <167648899461.5586.1581702417186195077.stgit@91.116.238.104.host.secureserver.net>
 <df1c06c2a2b516e4adb5d74cf1f50935e745abdc.camel@redhat.com>
 <EF32EEAE-EEE3-4715-8048-F5E47A360D74@oracle.com>
In-Reply-To: <EF32EEAE-EEE3-4715-8048-F5E47A360D74@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CH0PR10MB5097:EE_
x-ms-office365-filtering-correlation-id: e4c85e5a-c0cd-4158-67ab-08db103ef71a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1G7yKmkK/iOcjtnx1HRIAnB+dEEJ7DrLQJ0IDaiY/gcnVWsL+khkGv30U0+awHQBtSYo5xoF7L549rS79/yxU1VEmUVq+GmMuzdekcO9MXBmsUc/25X/g+wZ87Oy3prx7408qIoidimaiXAPrrII0hNm8cku3IcHeQs1dHkrI2/5ezMyRpaaYt2ZKXHlXCfcaE0eKfPjeKymTXNLP+xH8n4QcldBPquzsl1Ex5bnXV6Ce+sQgXMuKZ2HQF+hbBHCL4XJNPBoKBT+op2OTWkil3BL9a4SbF+LGSZqZY9tV0vXnKYcSTrV8vHMOFxYT+7BBxJjQLSeoVJUW33DuTMgXofvzICOEnfhmFnZWPzIBr4K/nH6WnZIeEh5VGwv1VvB3E3KTlJH3RBbJBmY8XxsJnBQijxxGBMITLFj/qasZiZAhZgf2HW1QrMPCrQzj/6Qn9MD6qxWHt6bvS0QqlCxC0wRn0wOkxml/aeIydqlnXubr3wktHTQFoYtZuWd3xC2k2yY1oSKFuPBA18B2wvQYNgXIvrD29dTwSvnfFQCkpGYYSCa4Enxc1vhvWeZeyHe5vUAQ8jMWm0w6jvrm4R7IH1n9diX/8Bxl5Xh376xpnyZYTI6PYiSzckWVOIqU3vorRrkt3xL0nhKAmHd8pwPAD9/GU+2NiQ2Gxf/UsVbGe12F8IcUHhakWdht4oFFiX7SvzoYW4oWAiVRoA+TqtcooLZDHabg0u/gawF/q1Ksr7Mgey9uDFriZ+YEWnWd43u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(26005)(38070700005)(8936002)(5660300002)(41300700001)(83380400001)(36756003)(33656002)(2906002)(478600001)(6506007)(186003)(6486002)(53546011)(66476007)(6512007)(64756008)(66946007)(8676002)(76116006)(66556008)(66446008)(71200400001)(91956017)(6916009)(4326008)(54906003)(316002)(2616005)(38100700002)(122000001)(86362001)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IhqBblDbAzCKeMLsNBkeyBIWRW8xTA0IwB0+aVG0gdKlv5z5/OoxdOTtCBlq?=
 =?us-ascii?Q?kV12dNjeHbk3k2bYAnd2M1y+DWnMuIlKNd7eP4Ecv8NWvxzNmefK+PeEyY7m?=
 =?us-ascii?Q?JcKvahi/ErS3ukDRY+R4WSIQFiqVCQTODdp1fJyztx7zNKV/8Hv+qhCs2UKe?=
 =?us-ascii?Q?RxMxipgbg3Jx8XWHqYWkQvPFfzlU0fcGLwhIy7ma/5Mqkq8+j85LW9y8tsVp?=
 =?us-ascii?Q?9+WtwRBPJJog6NQ6YoBhGgRnvY1aa02EoUtf3Y1MoS19D4Wjx/0K6zha7TF+?=
 =?us-ascii?Q?f+W8uUaf8cg4NvPSekpimm1VBDeaOvDcLGceHZAFOnOPYjEmwtsGNEh0sSBB?=
 =?us-ascii?Q?/ny5Rf+XjRLv+Ss86Zv47Rnyl78Z1wieuXHlpztSD+9njivUxzwYahldZ3Gc?=
 =?us-ascii?Q?EMEKrHr7NAxRQlgdk9W+2Rcv/HLjsD0Nnrbc1OOZnRID7S3B2Cak+xGwg7cd?=
 =?us-ascii?Q?jLTdQIvdSSd+tf5PUrV7RIIFa6I/Sgt2IiiX4MOL8Vt1P4en9/Tr69Pf9Yza?=
 =?us-ascii?Q?uc2dd3rfz5yLrSvwWX09cKAQlMMS2g4rIgRGTP/z5gAvJTPu8+DpeJZwgkNc?=
 =?us-ascii?Q?1RZcyJr6FSxJF83JdHtmiL/EkTg+x2sj3m+XBt/7z8QrvZYr+GtT/LueAEW1?=
 =?us-ascii?Q?kDoQKsMpIaegK18//wAXjlViyOl249oxo8iOT2khzKMFJs91enpX/LmIDXsp?=
 =?us-ascii?Q?zNGkby25KDm/BDl43qI9H5EO7/OSk2L2X2/hcPI/DKaTFxYSE+noayYct5VT?=
 =?us-ascii?Q?UGPO/agVGtZzd1fQYcwiQoH7w7AcermsTTPq622V6UNAvVFJ5WVZg0UUTwVt?=
 =?us-ascii?Q?lkqg3I2JPjRkPBwlQZPTq30BwCh0TIT1G84ESljKGxuQds2TirYlqKPLs2pj?=
 =?us-ascii?Q?TN5tA1xRf6vj9sw7kxsSdacIo97OsbEW4DuX7P2ugdHjGqCMtf3+oCOVhLlT?=
 =?us-ascii?Q?DCArUDi6VkVZjzQ+vRgvOssubeCsKAP3J3PQekf18JfzvomW57hG+9V3Xinz?=
 =?us-ascii?Q?+oy7Bz0U52Cd4E5Gbm1uCUoPeawhmOidR+7rzFr7yiotUXhNCrSynMYPjSPd?=
 =?us-ascii?Q?Z+cG9XT/xwLUtDvPbww7YbmPjKTm3Ynti0HXm2OYTiGbpG3/rkOP03z9+Q88?=
 =?us-ascii?Q?Uf31TyUWM30VDNkq6ygW4Wi/S5w6G71OUwKuOTBZyeHhwaamTGDUk0ALuxPc?=
 =?us-ascii?Q?UDQM4tYwkzW3COo75soFo8AmV/I0G51+GqDJdOFyq523+kSgIUUShQsKyJ1l?=
 =?us-ascii?Q?AyeRvuYeYIVTQGbYjgqKEOdJJIqsE8IHv6HCqsiifF0heaDwjpVciN1G6ZC+?=
 =?us-ascii?Q?uev+xhHJNnvCjfmASRVKcI/3lOnudIRH/M+cwwRv+ZM5ESDWe+uP8zxaKsTT?=
 =?us-ascii?Q?JTZLs6SCH8hRVTD0+A+5b26ItFMb5rrbvYEvDJ47mrGSV68dEHZNJ6tiauGU?=
 =?us-ascii?Q?bkr87aj61B7I/R8OtDCiHxlpb3HtvqFtfJcz2Bc/8MyEnlsnCY8yhGXwkFya?=
 =?us-ascii?Q?VlYweB3GaMh8p7LX26MfJH1HxT/XJgacjtptFY2G2MhRKakiRYatC7jVpzJ4?=
 =?us-ascii?Q?qeYgpXH0Alo+OxS0ygvxvILWxgqAcv3OXwnu/AsP5J9xw1SMTjJPkYVFH+Yg?=
 =?us-ascii?Q?Bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A65D30666307594194B0E58B6A8C497C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: u7+uQctcexvYlG14wPa32FCfH7G4ST+AbsuBSl4A/D2187tCUK93V1il/STpvaTxuuomnRa+m7VPd45glGjofyhaM4mXJSfqSGrDw/W9ckyaxh2S/O0UPFHJGRfXxjNjnmca+M9QJtgZLzBZ3m3XcX6QOrLGLkNeIOZH2N1D8GgCzYFMWS0kXDyQ5r4KSlhPasxwSNKRZnDOb9GRaDNOiVdyOgljBCXO0SSew5M1NcXPubCunO+pOWAy92f/c2ld3L3PdIKDNv/R2LhvfXz/HSb6AxS8GxFoke41uQIE5e0UGG0Pik0Vj+nN47OOwNHLoK9VZiA4cRH4BSSp3f4+83EFnggw2pozZrOzKZtLDZ+ps4q96/jrooIdkhFm91HFN+qWlf8RdmhBj2bekautKhQ/KIZlQYLe8ilqnlTsldIDCg5qqJtZDABSkD61SrBodmFUf27F5zrUAOFdYoQkZQKZMuLh6zUJ5bM+rST0CKcUBDEIoMXntdUAgCOi3B5Cjwi8I355/ic+tQuGfztmkWexrCRv5yxw7PHOWu5Lgl+UEBHB54Di6T1br9YM3gwr1uWePG9XHJB3SQ5btEv/pZjIBhtXgxDLlVUmowe4ZujhyoAvEFUrtueds8WGk+TtxNPSee4eq0cK5lk01MRB2KcX3DMRcrslQ0OJWFyL9l7EqDnQiPmVRSL/0QhUokxbWEbvS+IQiGxWpAMB446uniEFxCjxkIlaKKuUeBVPjxT2JiKTxZbcp28eRuVghYL5e6f/UXU4A4NBA9T8ZhsyurqpYnfnLuQZbZZi5GrqxCW7N5/on/6eOA24bLg53qVSM79mQWkvdgrSp2Bs0OklHIpUmnhh1qn7A/9HvTRCbFaTnEiuQ0ccfchUfxNGGVUHt08RF/N42r0jYXGIJQNqJQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c85e5a-c0cd-4158-67ab-08db103ef71a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 16:58:02.2620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JHrcTCYgN86n/HGwk6BJGab4MazcMDVbXW0LsatMslZl4xcNbleI7xrEKOw7Hc1wo5/i45U5GRowuY+GgyabiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5097
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_13,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160148
X-Proofpoint-GUID: 7ZRjDbEjaSiXOOeYma-rI-dsLfIIcpC8
X-Proofpoint-ORIG-GUID: 7ZRjDbEjaSiXOOeYma-rI-dsLfIIcpC8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Feb 16, 2023, at 10:15 AM, Chuck Lever III <chuck.lever@oracle.com> wr=
ote:
>=20
>>=20
>> On Feb 16, 2023, at 8:12 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
>> On Wed, 2023-02-15 at 14:23 -0500, Chuck Lever wrote:
>>=20
>>> +static void __net_exit handshake_net_exit(struct net *net)
>>> +{
>>> +	struct handshake_req *req;
>>> +	LIST_HEAD(requests);
>>> +
>>> +	/*
>>> +	 * XXX: This drains the net's pending list, but does
>>> +	 *	nothing about requests that have been accepted
>>> +	 *	and are in progress.
>>> +	 */
>>> +	spin_lock(&net->hs_lock);
>>> +	list_splice_init(&requests, &net->hs_requests);
>>> +	spin_unlock(&net->hs_lock);
>>=20
>> If I read correctly accepted, uncompleted reqs are leaked.
>=20
> Yes, that's exactly right.
>=20
>=20
>> I think that
>> could be prevented installing a custom sk_destructor in sock->sk
>> tacking care of freeing the sk->sk_handshake_req. The existing/old
>> sk_destructor - if any - could be stored in an additional
>> sk_handshake_req field and tail-called by the req's one.
>=20
> I've been looking for a way to modify socket close behavior
> for these sockets, and this sounds like it's in the
> neighborhood. I'll have a look.
>=20
> So one thing we might do is have CMD_DONE act just as a way
> to report handshake results, and have the handshake daemon
> close the fd to signal it's finished with it. sk_destructor
> would then fire handshake_complete and free the
> handshake_req.
>=20
> Might make things a little more robust?

->sk_destruct is the wrong place to hook, since we need the
socket itself to stay around after the handshake completes.
Better would be hooking the close of the user space file
descriptor.

Yes, we could use ->sk_destruct to tear down the handshake_req,
if we don't mind it sticking around until the socket is
finally closed.


--
Chuck Lever



