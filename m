Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65540513845
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349137AbiD1P2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349125AbiD1P2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:28:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF2A887A5;
        Thu, 28 Apr 2022 08:25:16 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SDZgR4025808;
        Thu, 28 Apr 2022 15:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8GMKlDubwT4Ek9EXR7lBrnqUrzix6ydKfkaMHxHh6a4=;
 b=YAZJLFmwjyOqhVcCBlNi0hh2ij2I0kl7RZDMCaF5EJS528fBYZjMmDs3tUyjngNCvz6V
 eatnuKTHIGY1IsAS6f2OJge4eg8sktTOp98aNq/zL1UQcvSDFlQ/pelp/sgDCaMKdA3A
 ZLAa3jgQlZhlNulXnExNYZ9tE1m6B5tFjWCpmek7n2mkPyswKXp2zmDxGCOcSQLfii4A
 lefXgsayjc8bih3jHqbSlc6sgb5DlWd3ar969ws3RNP5XWeATtAwiOG8PkkPp6Of0uMt
 u3Vllc9PBhlQeBMtW7Eb+dYGcil2ZE+hteWLyB+TYZ09cJDVxN/XJVN8eY3Sl0U+LFGU rA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mvff5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 15:25:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SFBEqv017641;
        Thu, 28 Apr 2022 15:24:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w6u741-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 15:24:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bdd3JoIseB3DYa06vncgCb3fn73HTbSoPsiwq5BxBy5l2juJT8Wm+iKyUNg3qvLlOiNIgm0VsdOoH+z+l0apwQPwE0zc+shtxRqDMxaAWPG6f/rZdkFfQn1h0wiazuLeIG41lULqttnEds7e4y6Y44UJaEy9TtmXPeAoYf+HL+HnyFzSXcMuU6SB9fq2NPfLvbhBUFjV4FOGdNb5b6stsCNdo5bacEeylRU7IfWKkPmCcFjQrZnMNEyscyXUL5T6QVu6RCZCmJuUCrUgBAfSTbfjLy686DC7J4Dn/qIjvlIJ3lnaHhM005hjZ/iJGDp1TLt5RFIRwopArRrLm//VcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GMKlDubwT4Ek9EXR7lBrnqUrzix6ydKfkaMHxHh6a4=;
 b=fKkQKZyG65TWA86fkdV2g5477uoUKDkT0UwVFDFAUSVbLN6Lbr3keAVM9dh8IPHYUK1XpgZJW0N3Z61ObjmKPA8+5PnEY4MxyQhywHfd26s/gUMeAQZqtkemE9WGH8mZiWoXqB4K9Gnldz2c0PwuZx/w0I4cbc8cK4TXovSXUDDIQVeXKa23Qfzm6LxYQMnk16Z3ce8pP/PVitSBrswjhZBelZM6phC0R59jfW96SfCYNk9ms2bfgdCQZ0Winy5/+jCmRoR6zRVDc+dpL5ajCHZodc1/qj0fiYZ57S/Lt2rGBpKbQJlm2d1ccfltxzhu7zdWbvMZLtYvZuXStQX8lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GMKlDubwT4Ek9EXR7lBrnqUrzix6ydKfkaMHxHh6a4=;
 b=QjYyBwMVyDQ1R/10ocpPm7SStfM+YsQYv4d1DnDrI0cWsugU1HiswcZi8FmruNo26OoTRKWLArcxYrzh/w46La2N8VePKNrkdu2z16J4Z6dXwD2V99K0dq8boQdNIIMn88XVn4iq/AVtgswe/RFMcU5w/xjgNEa5ty/l3HuFHOw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB4783.namprd10.prod.outlook.com (2603:10b6:a03:2d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 15:24:55 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 15:24:55 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Boris Pismenny <borispismenny@gmail.com>
CC:     Alexander Krizhanovsky <ak@tempesta-tech.com>,
        Simo Sorce <simo@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Thread-Topic: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Thread-Index: AQHYU0RqwCfhD8h+BkiXOp6ayeNVBq0FEy8AgABugYA=
Date:   Thu, 28 Apr 2022 15:24:55 +0000
Message-ID: <33F93223-519B-47E9-8578-B18DCB8F1F8E@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <068945db-f29e-8586-0487-bb5be68c7ba8@gmail.com>
In-Reply-To: <068945db-f29e-8586-0487-bb5be68c7ba8@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bf1c485-6ce6-4fea-dd5f-08da292b3fcb
x-ms-traffictypediagnostic: SJ0PR10MB4783:EE_
x-microsoft-antispam-prvs: <SJ0PR10MB47835029AE4E73312ECED99D93FD9@SJ0PR10MB4783.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pGrPwjJAlAvRNGaBN0JUbelTKUg3xUP4F98IgKIm/KyFdJYqIVeiSstxEbtr4LJEpwLzflAHeaZipOD+/SRyLSfhuw2u40/FsnWa8X7+7oh5BgmIK4tBbL44VCaRSKM6QUjogvbb9z9U8CbeUUfrIZX9tKQ3wTY5fsAHiNQDjG4mVWfZ49XIe6O6IybEuV4OL4rNtQxdDqx16iegAq9u/cAEXnideJ3Fajyk0zGLyDIm3q3qPiZGz+Gm/8g25xAnuZQ/Xugr2s/kgX7QOJo8QZoIEOE+vnLxuRfzI+mYveLj9V2gZmZopvX/NqYVTr/297UO/BHrsJHMPgusVVtNml1D1jn99ISiwEroeHPwIyxMgrBj5uW3pDXqKkDO4/hcI+1367nMcBVYo9MVHQWga9fjKg3tIkVRdOsL2FfO8HPLlFRe5Wvz074UJmRshRjMVpnL7sBSXNkxloohaXJm/LC7KJCp/7KXwpElBsoxRFp2GHsRbWvByVgctEuJvj/XKummgSndy+YjZtYzNTvPjBnVcSbSSdXFc16VEih0Xr3j9ANorc/ZOxMIIGnXuhouJMfGCWPzedY28EMtloRB4V0X3tNugP7SyBCBBzLFuRgw0iQ5Ofwijqq1e0M5gM1XtuAu0YQ+J67otIZ0HbKuYeF7AO5qRLe+cI/ehj+71/EOxusn+WhFPsJkepAvZ5cr9jvwmNsI0rpG4xtHrvbvK3ZQKE47vEgf3snFxsBiHrB3W7AL0x+iWmdnFjd7LR7V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6512007)(26005)(2906002)(2616005)(36756003)(8936002)(186003)(53546011)(86362001)(122000001)(508600001)(5660300002)(6486002)(38070700005)(316002)(6916009)(54906003)(76116006)(33656002)(66946007)(83380400001)(38100700002)(71200400001)(66446008)(8676002)(64756008)(66556008)(91956017)(4326008)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B8qb3tYjNaFhZ2cf4PC4ALJXg5PM5qGAxqZ6DhPBjz5f6HMQuVpxz6fs7Vq5?=
 =?us-ascii?Q?g1AJWYPb1H6CcZhXaiV13aVjHRiZjZGLIr8kjDVS71VNxNZjyq8J8TAJbzPM?=
 =?us-ascii?Q?Oq15b5AN5uz/zuxVilV4P7CxRf79ZqiKPf2AkwdXQiZxgjcxnDBi+O4xn9rg?=
 =?us-ascii?Q?Mj9Mm5UL9Cgv2P31RTqo26wrFgMLAwmRTUjIE4l/b7zdBMbYf17XKbBHlhLU?=
 =?us-ascii?Q?/Z2Ap2Ff5GIIjrG5F6LllKg4oAAYnBtcbM+ZGz5Z9b05xgMEepOemglLnZDD?=
 =?us-ascii?Q?WLMgQ/YsJz374/Un6YxSBLn7qWeCl58l4eBHRBRhm/imE9cdncVk8oyEuqVu?=
 =?us-ascii?Q?VbczCGkOLLucZYgag7ADBWhCtMd346WHlWXk2AyHRY9do9NV+OFrl/d+Jv29?=
 =?us-ascii?Q?YhIRjJa7hblCVaHdLwJS0XczWSz7oj8xF7N0h24PFrDmEA8WgdfExxFK0L2/?=
 =?us-ascii?Q?3+9on+DVfsg0zwafC6HhGuNyHxJOd40wTRy+yoFTPsyoVPmQ92I1ipKhWC9S?=
 =?us-ascii?Q?a8UAaxVuis57ceintjQmAQN9xdmP05yofDVA4p0uy7+mH0O5cq+VfOCfBuT7?=
 =?us-ascii?Q?po0dZz9EGTw7RYdL1xcOaZNZacDNQQaRAdZsjTgKFEuVONBeTWfg7HQxxWDK?=
 =?us-ascii?Q?WJFSa8X5oZymT1zbVVUvu7keXtJ5sEJs6us5Dx5vMqQ+/Oqdy9M63UbkXZj0?=
 =?us-ascii?Q?PL9DheMou+8fU0vRi4S+FP6BIVppa/PsbxGf9TzlTK2op+x1mM0psWlqeudl?=
 =?us-ascii?Q?pZn+jGwgUk6eqk2rOANrVK2DR7XW06dp61S7KxslhBCXTT8mH81h180WE/ST?=
 =?us-ascii?Q?wixjv14lyjsX+rna01oT59LdfDwTszhwcCWe4ouwufNAh8X6I7IOoebxmplb?=
 =?us-ascii?Q?IksxC5SK6EjtK1pqtSftvRYi8WoaZSFCqP2qr2/ptS0pgwbl66l7a7HBTbTM?=
 =?us-ascii?Q?MpUKzOU/wy0mxIDk3btNbTbmZZ7adjY95ZUojPl6JWsp2DWsgde32euPI/X1?=
 =?us-ascii?Q?fNgyRrNlPt33FwcAnuwunroHtiJ822mzmn0/neBtkyZHU+y7adNOrcdXdG9G?=
 =?us-ascii?Q?m0Rs1+iCK4SbGIyD5cvEwTBQPEvZybuudzDVlpVZpla7jAfP0zSpEg42oYxI?=
 =?us-ascii?Q?rHGeE350KO+rqNNGWjzvsl2JDddRadbkIZzS9fN9w3LAKaVx+PV/13LCwC8J?=
 =?us-ascii?Q?JWfX42g9oJ6pxUKn8LRVE1ghAuRS/jA6efnJ6hV2boI84qRPNk2apnK6AwWL?=
 =?us-ascii?Q?OIk3CUkfOmrzTE9VakEx7rPxTUQAyy5KbGaKwK7cttMNQVZC6BQXg4PeORQy?=
 =?us-ascii?Q?ouQvILtRQGotoNqAdFchKTwbkgtr4JBkfN13LG1YDwUPDxAR7foFQopKeKoc?=
 =?us-ascii?Q?dG0MGpz1YkuwO3qACA8aJFdrLANwbTjMVB5RnthFWAVcjmPIzjtc3lmhZtFg?=
 =?us-ascii?Q?Oeors1HL7HzlwtB4qgrq0i+FD2rCLR2pYz9ydmuNEnwTeAtVVOYwMkQ1XW7g?=
 =?us-ascii?Q?c9heqFlaJ64zUrIecwU+37Q8//1jLscXwyNubTXjj0L/uvI/egnRJQYKMGMR?=
 =?us-ascii?Q?ZE9+x3aZnTJ4DU1xRSlYE3Dpbj9+QifWt2V78mhUS3E7p+CjJ2/mCmJDpl8z?=
 =?us-ascii?Q?zbPfa59dP+CNp62lP95T7QNc2jxVco+pFD0uBltmDzh9qSB+yVO4IsCRPLJ5?=
 =?us-ascii?Q?luY0QCt2lTV4FWgZvCs70px0QWvJ644ZxExJ6Il0dR7wn+o8sAZkXN2j+Vhf?=
 =?us-ascii?Q?KoLOAGRmdxkcjLj2+We1zCpAn75QA7E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <33782C8C631E7C4A94AB466EAB495238@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf1c485-6ce6-4fea-dd5f-08da292b3fcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 15:24:55.6847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2qy2Dm9NjeslZmUE6m5GlPENbmi3aOYmzeyZ81kkdJ7KMT3s1efLbdTXuvieP4NVjfzuqw52TQ6LqKBai31ZhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4783
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_02:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280092
X-Proofpoint-GUID: vmr-19xb3e5L3q533INABB62X2AAiMnp
X-Proofpoint-ORIG-GUID: vmr-19xb3e5L3q533INABB62X2AAiMnp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 28, 2022, at 4:49 AM, Boris Pismenny <borispismenny@gmail.com> wro=
te:
>=20
> On 18/04/2022 19:49, Chuck Lever wrote:
>> In-kernel TLS consumers need a way to perform a TLS handshake. In
>> the absence of a handshake implementation in the kernel itself, a
>> mechanism to perform the handshake in user space, using an existing
>> TLS handshake library, is necessary.
>>=20
>> I've designed a way to pass a connected kernel socket endpoint to
>> user space using the traditional listen/accept mechanism. accept(2)
>> gives us a well-understood way to materialize a socket endpoint as a
>> normal file descriptor in a specific user space process. Like any
>> open socket descriptor, the accepted FD can then be passed to a
>> library such as openSSL to perform a TLS handshake.
>>=20
>> This prototype currently handles only initiating client-side TLS
>> handshakes. Server-side handshakes and key renegotiation are left
>> to do.
>>=20
>> Security Considerations
>> ~~~~~~~~ ~~~~~~~~~~~~~~
>>=20
>> This prototype is net-namespace aware.
>>=20
>> The kernel has no mechanism to attest that the listening user space
>> agent is trustworthy.
>>=20
>> Currently the prototype does not handle multiple listeners that
>> overlap -- multiple listeners in the same net namespace that have
>> overlapping bind addresses.
>>=20
>=20
> Thanks for posting this. As we discussed offline, I think this approach
> is more manageable compared to a full in-kernel TLS handshake. A while
> ago, I've hacked around TLS to implement the data-path for NVMe-TLS and
> the data-path is indeed very simple provided an infrastructure such as
> this one.
>=20
> Making this more generic is desirable, and this obviously requires
> supporting multiple listeners for multiple protocols (TLS, DTLS, QUIC,
> PSP, etc.), which suggests that it will reside somewhere outside of net/t=
ls.
> Moreover, there is a need to support (TLS) control messages here too.
> These will occasionally require going back to the userspace daemon
> during kernel packet processing. A few examples are handling: TLS rekey,
> TLS close_notify, and TLS keepalives. I'm not saying that we need to
> support everything from day-1, but there needs to be a way to support the=
se.

I agree that control messages need to be handled as well. For the
moment, the prototype simply breaks the connection when a control
message is encountered, and a new session is negotiated. That of
course is not the desired long-term solution.

If we believe that control messages are going to be distinct for
each transport security layer, then perhaps we cannot make the
handshake mechanism generic -- it will have to be specific to
each security layer. Just a thought.


> A related kernel interface is the XFRM netlink where the kernel asks a
> userspace daemon to perform an IKE handshake for establishing IPsec SAs.
> This works well when the handshake runs on a different socket, perhaps
> that interface can be extended to do handshakes on a given socket that
> lives in the kernel without actually passing the fd to userespace. If we
> avoid instantiating a full socket fd in userspace, then the need for an
> accept(2) interface is reduced, right?

Certainly piping the handshake messages up to user space instead
of handing off a socket is possible. The TLS libraries would need
to tolerate this, and GnuTLS (at least) appears OK with performing
a handshake on an AF_TLSH socket.

However, I don't see a need to outright avoid passing a connected
endpoint to user space. The only difficulty with it seems to be
that it hasn't been done before in quite this way.


--
Chuck Lever



