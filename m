Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D176BC1CB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbjCOXyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbjCOXyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:54:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDC352918
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:54:17 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FLe8jM007739;
        Wed, 15 Mar 2023 23:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=rMEuAL4puVti7wGIjKy8+8qdkgKUQ1hjdsBQ7ao7a0E=;
 b=acbkc8p67BnCpgtNria0UWkYSxHOgAbGLVYci7fB7s1Z1jj2yU2kPoN7JfyqrsofozAe
 LEZj+Pri/JI/87XDqei9cxP9dilYFRwhbeGFnfSqcVrNXJvUXG0Ef5kmVDkICJETpRDd
 7AeUvjjM9cjeZwoccty+aLPqp3hRqVo19mAb4as//R3PEBfiWdDQUXB9GOI6m0OXSD8O
 sg7J3MsVJiCI0DEzL9CQF3R8U4C6biEAe1mNbGm2ZDBOWlhaE2eyI6DvwPJcUBlLbdZV
 dx39X/tusqOywijO6p/sEYF67qXs9BniofCQSnOP9PIraHDYerOWZYDTTmzJ9dC5wZFy jQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbp4ur5sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 23:54:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FMwKgW036851;
        Wed, 15 Mar 2023 23:54:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq9gsb6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 23:54:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caPZVILqDYPSGGtnEyFRKT+mfQlYv7FMfdfPxj/mSOAFOqqGfaVkp6wvFuBZpF33Gx/OE22h1N50/n4VA7VTPrTl1KbvoNwvcv5c2Cqrif9+b0FO8QslgbyQjP+jaHJnPa1gN2VkfE2HbUSqoF1uy7pFMuVDkmRQrBKacwXruKp0uGbKmuwlpMbvif9SlpPxnhgaUVBtQ17YQm2ptjF40jq3PpHNy0psr34HRYjCt8lcg2sTxkVksQ3jmc8tegOcTF8gfeEATpMGMr8YnMIuRoOTG/SqIwki+WTaHEyLbUoK5MYrmwGOL0LaW3ufjXh1pYdfIzAAQ9ICqx7/nekDYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMEuAL4puVti7wGIjKy8+8qdkgKUQ1hjdsBQ7ao7a0E=;
 b=lAFD6PVo5VX8C/TQrxJepisHSOXyn7GTo3fbYiRnurQhHVw7OLUwPhiUW1ABeMdvQ4xTFtXtt96jj7ZGgohdP2AlMU3JeFHLDWw/kCp6mmupleRnWqO8ZmmIiDDWQM6cM6FjvN133YbuV1OnG9zYIG8egunpVS7Bx1G33+4jiDiyzD62mBBHxwmSphJU8F6YnolbJJwzU7xRDStXxDD1pq44p2pxLj1VwJw027G3P8SrOmDYHkrVlPlpU7jkeCxFqt5K5fWq1oaaYQBTFCuyJ7iKL5ej7jPADa1k10XOuYFW8n056oZcWlh+CLTd7rnIRUmMODP2Fy/Li3UBvkXEKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMEuAL4puVti7wGIjKy8+8qdkgKUQ1hjdsBQ7ao7a0E=;
 b=ySkhdKUk/WjgIvWFG8JYaq4Bve0zehB3b72XfdBG3snFHV9yel3yhA6o2AV2yimFIVuOSWiFpS8Kp6fNeQL3jJyTbwgXVzbI+A7257llKhnxu0Ql+V7hoTM80BgvbvfdsBZehLZI+2xIS6w2AhkX0jkn7NAyB+yAHQHxtLQIysI=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH2PR10MB4373.namprd10.prod.outlook.com (2603:10b6:610:a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 23:53:51 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%6]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 23:53:51 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net 0/3] ynl: another license adjustment
Thread-Topic: [PATCH net 0/3] ynl: another license adjustment
Thread-Index: AQHZV5KBK1NP85TtHU6gxhqUXuPIo678g6IA
Date:   Wed, 15 Mar 2023 23:53:50 +0000
Message-ID: <60899F07-F6E0-4217-B0DC-9E1532A01946@oracle.com>
References: <20230315230351.478320-1-kuba@kernel.org>
In-Reply-To: <20230315230351.478320-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CH2PR10MB4373:EE_
x-ms-office365-filtering-correlation-id: 7e9d9355-a912-430b-e77d-08db25b086d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2npWnrYgqA4/P/JhspeXqCm3tXle3EWNXfStpq0z1R/J5iTMKWbEk62p3Sr1euNh7NjbjLhDVAwrPShFCzBBknIjpMx69C37V2uVJeowdND5yNFqbliyb4hWF7r9UOoNwekA1XLYSC6j3CACTQr1jOK9D9Cn7+8x3auyamz9S796S6lAUgNPsBdWhaJDa2zlJ1dLQYxN7645Su9skX9YS9Lj5BNdpfAYZVNQgEk2WsJftgq70+x/pE2rQH/JXJFrvMn0bE4mh8kR61Eh12Re1WE940Z8MYGdqBVohlcxjvYMhOVwwrYFW41g/87H0A78lj0fhGX1t7hGHTNhO28RvcHRtcRO7AuGfhgWOdCzIcCa66992A43lM7xWPu0a+XJzi/lBgISypZXZ0B9F32g0xOlxSXg0ywcle1dN28wEcAFUUYJ/Ad/k35o5NExzrnK5kmAl/WuUtLQ+pfuauOcmQhmMrZGtj6chCaMR0lw7Lx7vGbo4lPSSSgaRFLCApk7PXYWYDTmo5G2Kr2ruIWFjS40Q8aJt0B8dWQ2deBTFIKpNB3BevCC7zuO9y4kkqTBXW8U7diFx2fV6HLz9oO+HbdAxJmYHotsrNpeNMDPiR7B4VyJUMAqVAjVOrbHTJDagu4d1DZdEwMJ1wccTiSnLa1nmxQXHSTZhL5acohnV+aWQeemv5S1Ee6t+PDjw6bjpfKZ2+WOvkIdef76KyLgOXkVI+7JTz19pcjFtXT2kM0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199018)(2906002)(122000001)(83380400001)(36756003)(5660300002)(316002)(41300700001)(66946007)(64756008)(66556008)(38100700002)(66446008)(8936002)(8676002)(33656002)(66476007)(38070700005)(4326008)(6916009)(76116006)(91956017)(86362001)(54906003)(478600001)(2616005)(186003)(6512007)(6486002)(53546011)(6506007)(71200400001)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RmGUTkXScojD1IV4iGn5ZSsHpzpI0QHL3n6FV5zP/PX0P3bxFz0pALUZiTfe?=
 =?us-ascii?Q?k8BPbgYbrGC5tl1CavMQJ8mcaqMM6tc3Tvm+07nCy5wpVX5lTqrrQwcQyPMs?=
 =?us-ascii?Q?R6YX12doRNE52KhrMYQLgoCYoNc38lCR4q2rZJ/kdEPCtcAXP385p10wJsLn?=
 =?us-ascii?Q?iaphCYgi5O5gluSlNI66TgiEvlZdHk25Xr6Bd2vVLNqegsqFEwCMZdGCttDJ?=
 =?us-ascii?Q?oh7C1OU0gxyGnETU0o8pDxO0/55yHI0myQr4ggMF3bILb7mLWJ+0jkcwuElZ?=
 =?us-ascii?Q?a6WwRpp3Ik2KADrYy1L8vBpMCt5wcUwhCSyOSDN0oLQKvFqXIibcqqUUL7mv?=
 =?us-ascii?Q?HOZyXyuOZHKIF7ppyOP4qARqKTHFJBhxM0lpoiBRAWHt6NY7BwdZWQ+S+6JH?=
 =?us-ascii?Q?9LHmCjwof5202fQTP+Em6s1Z+YgU7IhObdzdzAt3HhyFJaFbZK++ktJpt6h/?=
 =?us-ascii?Q?w3qVYP6tFAhsQtpkpcgWT8k0UHMxR3YDujVL5BhF10DjrCo8LlziAo/OB8al?=
 =?us-ascii?Q?KMESbfH2eBMvOcxRW9tJq47EDYG1pM3+YSop5Tw5ip/a2ctYYxuQzq/4u2ia?=
 =?us-ascii?Q?bGMSVKtc84QdAehTDicWrX5XDpOps39iTsAoSqy7lOqoZn1EWw2NMPx5RLP2?=
 =?us-ascii?Q?J4tar0WA7GYZo38DX4xmbU9yuFnhMACXsPAYf6jAurMhLm3EIrjl67zPc8tR?=
 =?us-ascii?Q?oSPWQywtngIZ9fbleFWcJWg/LtG9elHMX8jywHlFeraj0QZqvps+2R0i6KFC?=
 =?us-ascii?Q?anV9Q0X/KSSKLyn2XiSMioAmclb7QtEckuJycCtaLwBhRZTlNajoENGthTgE?=
 =?us-ascii?Q?BBnocsUmmAc+bdwg4EDnhv8iuFGOGUzh19UBKKCMb5ojA6ybbcTXT1PPBgcK?=
 =?us-ascii?Q?1hykxX5Ud1eFC5SpDwZPw0Pscuy0D7+E/WcuOpqPCIwhiqoziQbiok1L92s3?=
 =?us-ascii?Q?mCnUQ2sOA0QVQFz1vU4/V4VLiJP0k6MN+w+UdU7gH8rx2IG1rPAP5gCNDSKI?=
 =?us-ascii?Q?Fbh3NqcGib+0JYDiG4S//VkLRkzuQMywZ1boJU31QOAHeCgjMSc+1Sq+R2Wm?=
 =?us-ascii?Q?JCOybmJEL19uCXq6XQs4+FH6A7AMRXOd1MShGtF57tKDp24//1Wlvnj+znRN?=
 =?us-ascii?Q?BrivChjWaEgPVUYqqbHdl8zLirs6g4jzJDeUAC/lQVa8ksb/EKX7L4vje4UQ?=
 =?us-ascii?Q?L6FUan5SQBCGhLXZ4IPNsccqgUn3LOlZI4SuL9LzMKtTml524ZvBlbXajwKv?=
 =?us-ascii?Q?WFCmPQQCn0kjpTOqZ38f2+c5vf73R+96dW9PTJuXpDCFURJUjPCpv7iz9TVM?=
 =?us-ascii?Q?vprRorV7B8Ze70fV3SDmPR9H05fkSVbis2Ub/mQJFxmebmaR04SkSmaxE7XI?=
 =?us-ascii?Q?tbEcKsRwcvH8YZErDuJ0aejAZ2K6k3BWTN1YIRII3jnGT3KqlrxV7A0UOOfU?=
 =?us-ascii?Q?p/fJoVPmjiWPlsPJWq983/cTAB+wbctt1mHpGL5tFW/vlVHU738fw8LOk0qp?=
 =?us-ascii?Q?UDK3qrwWRBuxSFNhoQPCvG8oY/KMyvmNFy1ck6vHVDyx1fnJ/UBwquE1iHTC?=
 =?us-ascii?Q?3ng7A3fmR14QmOd09qLKZ84Fklmf6Bt/h4TXJnJj6U4ohHljU6q16bijPk0u?=
 =?us-ascii?Q?Hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ABD7157997582A459F50E269F0216B11@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: j8PT4G1XcUI27Qr7md+qmhTfHdytymyIqDOl4xZtFgwpGh1g/g0ylDOKvMKNWGMG6dFQ+IeCCEd/GnoSfo6z3Lk34bdCGPa+AxkFOuzLpsOGDcbjppMf8yni+EovEE2hlAlymO+zcaLjvc8Gaf+ZIKfzEpQHzeBQqO+P+JrOcJjI4c4VDcIm4JOu5gMKUPfwyp1NfQYLR/B0okHlgVYZ1/PRK/nhf6idSHZ69CxK6o5QcFbEwL47ETQWbNkEySb1zSZEhn6adrqVsFEWARpeyP5h+17gllpg2xcQFtv9SR63EPobtMqreT/DHff7WHZeHWx9/dveyyA1pnZDViamO4NTuh3/Of8BYff3LxoywFa5fYCRd19vBL6KYfdb0NTsaRe7nWzTuYOKQi2vXuHYlZf2m1yfjcpGMjVcdwk10tsCdAjhq8GYZLH5Wp8dhWmzdxkyWK2f2TNWairF2Y0SB4uA0mMTygDF/U30zImPYLemFSP9xghBRYto+boTiqAKx4tmqQF+383U2Q4HxZPNmXA/Jnaq3Dg6Ee3/MaKr1kCuHi4/xvKHNH0IOZeROPGUC8UXGV1mJjIu29BGVIbZiSfSxhfrXOt9SycpfM86XjoZdLLWnFudguTN2t9JadOJoQUga4grS5UucX83ySygL0uNol7CAlEF8MKlWDODvQAIoPxzMIBg7fRea8tRjkZQUko6D8/cuLLH52nk1dvb/ZpQMkk4q9URyiRsflgBfP2JAx5VbFiUwZq8HDxH/FyIJ2qCXRYh7b9jqnK4y3E6R2dGK6B3qVLbLb/Puvmio2pl/uukwvdXcW9Sv+em+dBMT8fVi354e7PM6idyqGEYmJw2mHhc2InRyNdLnqMgNtaY769lI+l8s6rZbHMxR08QeVjd7WVHee3I+D5ulcoYVQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e9d9355-a912-430b-e77d-08db25b086d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 23:53:50.9275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4CyzM946Bg4OsLLmlZAKN9slQIrsu9gpQn8REMCgAmmi+PQJGXxif8BXpBRjX7EIPA46ciOxynmfHGSniraU9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4373
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_12,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303150195
X-Proofpoint-ORIG-GUID: ehra6sH84C1qJXBsKi6UgWIFU9AgKDMS
X-Proofpoint-GUID: ehra6sH84C1qJXBsKi6UgWIFU9AgKDMS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 15, 2023, at 7:03 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> Hopefully the last adjustment to the licensing of the specs.
> I'm still the author so should be fine to do this.
>=20
> Jakub Kicinski (3):
>  tools: ynl: make definitions optional again
>  ynl: broaden the license even more
>  ynl: make the tooling check the license
>=20
> Documentation/netlink/genetlink-c.yaml        |  2 +-
> Documentation/netlink/genetlink-legacy.yaml   |  2 +-
> Documentation/netlink/genetlink.yaml          |  2 +-
> Documentation/netlink/specs/ethtool.yaml      |  2 +-
> Documentation/netlink/specs/fou.yaml          |  2 +-
> Documentation/netlink/specs/netdev.yaml       |  2 +-
> Documentation/userspace-api/netlink/specs.rst |  3 ++-
> include/uapi/linux/fou.h                      |  2 +-
> include/uapi/linux/netdev.h                   |  2 +-
> net/core/netdev-genl-gen.c                    |  2 +-
> net/core/netdev-genl-gen.h                    |  2 +-
> net/ipv4/fou_nl.c                             |  2 +-
> net/ipv4/fou_nl.h                             |  2 +-
> tools/include/uapi/linux/netdev.h             |  2 +-
> tools/net/ynl/lib/nlspec.py                   | 11 ++++++++++-
> tools/net/ynl/ynl-gen-c.py                    | 15 ++++++++-------
> 16 files changed, 33 insertions(+), 22 deletions(-)

Reviewed-by: Chuck Lever <chuck.lever@oracle.com>

--
Chuck Lever


