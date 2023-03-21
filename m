Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988D46C2E63
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCUKFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjCUKFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:05:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DFD457E8;
        Tue, 21 Mar 2023 03:05:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32L8HkXa016572;
        Tue, 21 Mar 2023 10:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=M3sd1aJ1ECt9kkTPcccOPGIwihSHswbtv4wHS9cIpOw=;
 b=deGt9zACW4ZbpOSgt7BFZC11/tRoQ5/4YQjWkkYsgOXCXbHBxvMipFif/tRMSSNAfqIN
 lQR5U1tZY1BfyTxGrPrC9CbPsmGGWKvRcRyB5xzIYV1nL4BztDmkWjcpP+LA6RhdK8Pi
 o5bS6uqO+nOrBgAwiChbrwZS1fX/44cVVGBcZ+natvY32xW/A0TsBjdkn747+M9FpHlR
 wDlwUBuY8q7ddERkr2L0To5VEBUNfnCglmxslIF5maqtgzhjn3o3TxucJLBGxkAcgdL2
 3pDbWNksJ//3GO/MSrFOG7+1GdvDa0PD9AwsZ7R7zpkrzO5yF2JBbMpVtAYWDFbM00Ce NQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd433ntxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 10:05:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32L9nRMc015477;
        Tue, 21 Mar 2023 10:05:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3r60vq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 10:05:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbBUrmjoTN/7l6WDeg3kiDW94jV6K+x0gV8ege+qmMdUeSb3BYcHefJxGxLppGNpDHRqhhcliAsxBaty2zQ6SSF+Cr26fXVwq//HMLSTqWeLT8/GC9zCcF1kR/gd/wCdNZi22Pt5Nd9eiAy0Xi5okIF7asX1ieE+It+LL/0Cnnnb8IB67Th6NiWVRPTMeMrWCjLXieXEKX2G6up/fEswF7m3EFu099c3Gkxif9uw35jt8A7JC/bGfNMqrFbAlOkfNkNGY4sMs2+LUewmYkytBvtCj/ur4zjE/dHKYyP5TrrrTcXctnZXoly9DfaDfVo6msDuHWe50Yb6xIqEQCKRbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3sd1aJ1ECt9kkTPcccOPGIwihSHswbtv4wHS9cIpOw=;
 b=SsXZBHERF7nhezTD+081lavqNJF9cCGutbv+2UCv1jDL6QZVmGlFivD1phHsaW7c3JtnYQVPXuMy9hGMkMziNcJjM871kBjYvs1TPRUf271X8W8wu5pHCAr59jfNwK5ceccGN2pnxU6HsKuMKVozuOo3eRpWrTm8WMGhlsKcijI72GHB75tD7J+DXHQEw/1TMPSaIApECEvOJee3piGR5EXshrvB8rXEkH1jS1AeGwurSxZdyNFNA94+icVPKiDGSuIizlMp++ScL6IJcvYBmRoC6DJGhgzGIqyRwg9jNwUgVhSqi4tdy+PNSDZkdHRzpD/7FBx8whfyjfLVc2vhGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3sd1aJ1ECt9kkTPcccOPGIwihSHswbtv4wHS9cIpOw=;
 b=GioQXjyQHBNV+xZzlzVghh8ftCX7TCS+tKep6dpsrGtlz7/qhCVoQ+jyWhodo0U68UNgFRJ9VK/RwgcraU+lfgxKCWIHhSb4LvGK81IdpdVuyCw0kgy6W5Ci2wy0Lz8L/uOAm7hsVxLsZN/kh7MXptWsTep0M+vVxMXNNPtgHX8=
Received: from SA1PR10MB6445.namprd10.prod.outlook.com (2603:10b6:806:29d::6)
 by CH2PR10MB4262.namprd10.prod.outlook.com (2603:10b6:610:a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 10:05:10 +0000
Received: from SA1PR10MB6445.namprd10.prod.outlook.com
 ([fe80::f9a9:7b84:81a4:e687]) by SA1PR10MB6445.namprd10.prod.outlook.com
 ([fe80::f9a9:7b84:81a4:e687%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 10:05:10 +0000
From:   Praveen Kannoju <praveen.kannoju@oracle.com>
To:     Praveen Kannoju <praveen.kannoju@oracle.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>
Subject: RE: [PATCH RFC] net/sched: use real_num_tx_queues in dev_watchdog()
Thread-Topic: [PATCH RFC] net/sched: use real_num_tx_queues in dev_watchdog()
Thread-Index: AQHZV2zBblfWFEKXpkuGOEDIKn7kEK8FCk+A
Date:   Tue, 21 Mar 2023 10:05:10 +0000
Message-ID: <SA1PR10MB6445AE5B65A9C85838142CE08C819@SA1PR10MB6445.namprd10.prod.outlook.com>
References: <20230315183408.2723-1-praveen.kannoju@oracle.com>
In-Reply-To: <20230315183408.2723-1-praveen.kannoju@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR10MB6445:EE_|CH2PR10MB4262:EE_
x-ms-office365-filtering-correlation-id: f5aef8ad-3c75-42ee-2a3c-08db29f3c190
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CGH9wSjU84dbEPeMYPq7BMCMl/h2E9veRnMsAFkK9bCTDwm/PBSnu7roOUySLd2pgtL4eNutfI/LwgrQRgXKU7DUV3UQrszFndLNJG46vX7iSKGT/fIePMo9G5zyhqeB8qrRLnFlBML/3Nvj6W2r6OcZq4ALh+O+uPMKho0veHx1SNVll8ERx9HFSYFvO+AuqRINlxbYOMu3B4SDRSjJ2TPyJKvW1QLZnQ2OvJsDfoWikfBWF+YsquVpHaDuZCYnP4gAYxby19ewTrfblg8IdY4GYbcd6+lSGFnhJBEizW/1Ut/6k9thTUFIkYSppfMXAaebL5aq+9wSuRLwMdu+H1PU949c08858q1IQuKMSTpaJCXRAIhKlGdmMfmp407VOH1WwOXbA4GM3DVXo48LKaa7YhGGJkqR9NHK921CVh/H9kU1jPsNDFuhVTQbarArrhetoWPCoaHYJ0Ypd8hZvUso78syw3wByunuVT7LNXZSBCQngMl0kbklSY2wh3Ldzoa4BdjAbH7VuG/o/ROCtZj9INzsrEIwekEpUretooAcOHgfHhGN1J0U81E8+3MOYYngv64QWMuiYDZ2XSFelfBikOI1PCs8xfiOcmK6CJSCtrXABi27HAvWAk3I9ThWHNfkZIITo8a3cJ0/6fBPO3gEqQPM7J1rqru5vYgqg7DoR8YxFJgTkcXly/lRpjj+bo+hFhgoo5vPAmzveaA0m2pfVAkZOCm64AHx3K374Ac=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6445.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(396003)(346002)(451199018)(38100700002)(86362001)(71200400001)(7696005)(316002)(110136005)(33656002)(54906003)(55016003)(8676002)(66946007)(5660300002)(66556008)(66476007)(76116006)(41300700001)(64756008)(52536014)(8936002)(4326008)(66446008)(44832011)(2906002)(478600001)(122000001)(83380400001)(107886003)(38070700005)(921005)(53546011)(6506007)(26005)(186003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hkEd+6kYhQ0J9Fbpb9gC2/KshGHSO/D5KSf3Mc/tlJ3jeBkczwS466l2yQie?=
 =?us-ascii?Q?DeN346fLmDAT2b7UU+gJa7aKk1Rn7/diSub5lJumUMxtCxlR5AywLtMnOjpG?=
 =?us-ascii?Q?KsqV60leuwFrOuhkiNXxwiV0Qg53m/I/jbEn+igPM46I90f4jF3out+2dufU?=
 =?us-ascii?Q?97D3ePoaH7sod8/KrwPg2jlglKEXIdTKxv9x/pQNwwOYAFjt+lo/QmdMBHZG?=
 =?us-ascii?Q?ASviAbLg7f3rbln/bocXgiBsBH9IM0cre2uQkochG7u8dnzRLm6o6MVG5h+r?=
 =?us-ascii?Q?37ZPFurfPH+REJeYRBpiip6+JsO2x4H0Fo3c0JOwhjrbDHGeM8xAS6BaSdsF?=
 =?us-ascii?Q?2dHERjrL7k/oYk2ByWh7frcst0Qa4bYxhI5/2b6iywG4t6+ekuETuBfmRbGw?=
 =?us-ascii?Q?oUrOqNOeLSxLImv8ICRtMV/D43Oo8eAWHZHAK2Lsra8hWGN0DlDjS+4PEBEG?=
 =?us-ascii?Q?sRq4xizV4RRvxSEeT7Jlu9QkaNj2I48bBwNZ+t1v8gqdJNd2mPxRi153/SPs?=
 =?us-ascii?Q?jeDYqZvDcD8Sb+fIFzYYY+itYtVF14GoOD/dphWLohhV1Gzcz8SOR+HVwcrs?=
 =?us-ascii?Q?q1Ve8FhVN9iCwOGIZB+mO6akwyQFzDGkt3BnLwRWE1lb4ofnzIi4b3aa4nkO?=
 =?us-ascii?Q?h2qeopfdTB2UIChfCuK+gKBbN53JxFvnYMFlhCZU31BKdpSC1OICgUBxq8r/?=
 =?us-ascii?Q?d5c+BxvkJoVGBoiqMORHIzvy4sO33R/pd9M3B5zEzPgt56m+8hJSUj9FGFvE?=
 =?us-ascii?Q?GOT8y877UAm/rSoYwkjyrvODPnozR/SoCKI7kIMAN7EB+B1wBcbNlFYx0ett?=
 =?us-ascii?Q?D2crLIZpgAcQovK/N/6RsEiIICRM01L2YJoFyh20GHuZHGtSJjQsPsXg4dTv?=
 =?us-ascii?Q?4DDWyV6REx01Ve3ZNBj3uMk/1yQWfSJ+bIs+0Fi2A5aLCv/K4NCTxJHRbrMk?=
 =?us-ascii?Q?7cPUXGeeWVTMsV4L0qu6i1X1uhf+dA2XNylX3BmnsCdvuPQ6qxdMWS6xCd5G?=
 =?us-ascii?Q?RrKPVDjcf+We2B9bKunSJVt5nQRwjFO0CCl2lZiaJkf9wBkKzKnh6oR7zf6N?=
 =?us-ascii?Q?oC1s7WoGX/1gk4t6keg0uj+fhYLFUXH/ubtRPRwx+nfj9YhnS0YG+2uVxI88?=
 =?us-ascii?Q?TT7d7LHzzlizz0CDujrt8PoNcYpI8rTW5TzMGPXTtDmakcfeaf4WdDhFxXcg?=
 =?us-ascii?Q?E9TCrMM/sj0+LPO/xmiP2luMcF/gE7FElMv+42YFJBnVftdtExffFknRCb2N?=
 =?us-ascii?Q?3yQ6fVonin9IuKE11z3ituoaFhIsSEk+tyyTeglNdr//S4hDzWXkVe28Szor?=
 =?us-ascii?Q?erCXOFe3PZ1bALawtnuTuzvVCDsuiqxySqa56W1vBQ3kPr4ZgTjwkRrWFUmk?=
 =?us-ascii?Q?mFU0e6xxz425gfR65cB1FEaG3UJi2GKEyz7m/b0+k8xjCBnhE16KBT0uLueQ?=
 =?us-ascii?Q?uKeh4x7Jo0geA4XKnZrsZvVMg2de2wqt0K/2csmANAOPbKPh/rW3HtDhWkdq?=
 =?us-ascii?Q?f5CcCUNJD3fWQJF/gtaRrN8qkWReZ8r7D6RpubSsih3LKjWwD/CGKDCLq/QD?=
 =?us-ascii?Q?AoTDyY6U4BMOHfEKDEXE2R74p7CxMd/lkAyfsY6N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?695PmyHT5kil5311nBYskEWC2QJj/AEPZonKmBMmle+LAvF1jgy6Um0W8MHU?=
 =?us-ascii?Q?zS/usCOm3gpeK0lTpVgwU6NiA3xgSyv/ufTr0rTnWuPSxdSzC6KDDNl+dpgQ?=
 =?us-ascii?Q?3svlY2B5OCkAGH9EwIbm1cNtdtRa56blP8lpxrdjr/VovQuKGio9MtOUkYJr?=
 =?us-ascii?Q?oYLgeOsi9B2fE/Eq3sIBsO7sny3g4fvB+R6A31eEF//hTziDu2vos/0dznuM?=
 =?us-ascii?Q?tFCwRHXP4kAKhGjrpxW/MKF0jTapqxYD7NceUwflIBG28THNrju2DMx57BDB?=
 =?us-ascii?Q?yQG0PUxMnvOErTbysG0kByDGiQfIm3Ld0EG8nFnOMTowfaCjLIORPTeyf0+b?=
 =?us-ascii?Q?5igiZhBVAEhF9FLKNum6L8U7m/ysT6rBNKu7/q79o3HZnSb/k2DhB2chgqKF?=
 =?us-ascii?Q?sUehke2kgYlUeuN/MlQ9U3mMhu3sa34CjPDnc312GP16h5mQKjVjIiSR+05N?=
 =?us-ascii?Q?sGAvgYpyMGPBGDLi0twepd2Hi4fCr0g+7j2uiENPN20C/hdMKYyAOIqQZFfk?=
 =?us-ascii?Q?4I2FnccsxKb+bj6HoH+OTdOr9+pcyX6HOF71khnAUNADiVyY089D6LyU9bcC?=
 =?us-ascii?Q?XWrrWXqsDhSfj1pNJlA7DVq7hwcjSC8t8l9aOjigmNmaAU3alwE6znJFMKiB?=
 =?us-ascii?Q?T1CtAeBeYPrsWskROKjCEDLQDlMG2V648r4WKpAjUkqCVzw4BNOzT9cHVcLz?=
 =?us-ascii?Q?aDDIFrweyDdQw69hnEkPrmX9poyTtG67ZdEAzdOGVqBY71WQ0cLlrbrz79JJ?=
 =?us-ascii?Q?vYuCEaBfU4jYaVqjkzCZu0mV02pj6oAU+rkUumf3DVjJxzZNmkY5Yr20ytI9?=
 =?us-ascii?Q?2yisyh55gJt2QkJxaNckxnebKmtROSjeIF8qON71oq62mhNmapCWvzABEsMo?=
 =?us-ascii?Q?BD+Ih6OPhXD+hSJsIytAotp2NxN41Xi1op3J9uPytELyzoWp2ecSryIWqUG9?=
 =?us-ascii?Q?oam4IXN+lMQ7djmhkw4GCuLro0geDNQNoRjqpetrQmU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6445.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5aef8ad-3c75-42ee-2a3c-08db29f3c190
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 10:05:10.4142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/vx9b6DK1KGIG17YmZ+kRq6T0JX0hDU8tJrNLk5f2Sfu54Mappb3VCYm8dRfetyBGdDolO0dtoH8kRbZUmQlb6cb55waF+RUmXyFFa7jV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4262
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_07,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210078
X-Proofpoint-ORIG-GUID: jSOJOiuhcnWaZMdk1jgI1gHIQ328fznF
X-Proofpoint-GUID: jSOJOiuhcnWaZMdk1jgI1gHIQ328fznF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping.=20

> -----Original Message-----
> From: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
> Sent: 16 March 2023 12:04 AM
> To: jhs@mojatatu.com; xiyou.wangcong@gmail.com; jiri@resnulli.us; davem@d=
avemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@=
vger.kernel.org
> Cc: Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>; R=
ama Nichanamatlu
> <rama.nichanamatlu@oracle.com>; Manjunath Patil <manjunath.b.patil@oracle=
.com>; Praveen Kannoju
> <praveen.kannoju@oracle.com>
> Subject: [PATCH RFC] net/sched: use real_num_tx_queues in dev_watchdog()
>=20
> Currently dev_watchdog() loops through num_tx_queues[Number of TX queues =
allocated at alloc_netdev_mq() time] instead of
> real_num_tx_queues [Number of TX queues currently active in device] to de=
tect transmit queue time out. Make this efficient by
> using real_num_tx_queues.
>=20
> Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
> ---
> PS: Please let me know if I am missing something obvious here.
>  net/sched/sch_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c index a9aa=
dc4e6858..e7d41a25f0e8 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -506,7 +506,7 @@ static void dev_watchdog(struct timer_list *t)
>  			unsigned int i;
>  			unsigned long trans_start;
>=20
> -			for (i =3D 0; i < dev->num_tx_queues; i++) {
> +			for (i =3D 0; i < dev->real_num_tx_queues; i++) {
>  				struct netdev_queue *txq;
>=20
>  				txq =3D netdev_get_tx_queue(dev, i);
> --
> 2.31.1

