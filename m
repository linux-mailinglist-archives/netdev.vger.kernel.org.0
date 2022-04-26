Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF433510266
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352724AbiDZQB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244762AbiDZQBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:01:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCF0162F02;
        Tue, 26 Apr 2022 08:58:47 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QDSwfY003700;
        Tue, 26 Apr 2022 15:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OB81PmAP0CHMoWlu5DyGNFFJFwgvRpSo67z9XrUWXxg=;
 b=g2ktzzhMuBv1LrU5tUExLYAwjdOb+W23QYsoRDCed2vvL1/hTjMlch9X+w8xJjKqz0PZ
 Nu+Xs90jCrH08cBirMCdhy07a+nVl46XCRPeiMdaXijzD311SBMd5jJPVqO6Y180vMDl
 EUoaA7NNhMNhSI9PWeAHnmlT4OriJjQNYygRsPkTOPXpax77FJNH/aXvHOooixiPcLom
 dLO1NwnamXg3qi0BpSETCo9DmwoWnmwUfuWgX8RoP90Sbj8szyJ0iuLQf2WMwUQJurzY
 +GmKfDbnhjKV30V5mxJesg3uvkBQd6Olx2QQP4bJwE5GWSeLITTKxx/gpwPAHFRWsptb fg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4pc8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 15:58:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23QFp5iV014253;
        Tue, 26 Apr 2022 15:58:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w3gxvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 15:58:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a72Mh97fQWQsrELtilmAyFjzNiID+y4hza0S0iBM9ZqouZv4PMRpD8OiBV8tE6dyq6KILuQMB3KrhBc1sUhbef9qh8AzMAZtR3awzjwF+NYZau/PYgx3V6RQR5orkjoWvN1OGSj8r0H/yzLTvb+QWr2Ypq8fV0xEjSiLuVQty1KblzF3vbbnBXedsNkHsqsoT1SKb/R/sQcL8lBomKuOwTXXQIG6Z1gFZmG0pseAauCrwY7v4ndvPNjnWqwfghwcG4Mr1E36nQYlo3v8p7Y2+M0cy5Fru7ci/ierjNyCEU5mmjERWdQZgOdzno94/C2h8I8zNp4YyFMeArsIdt9b4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OB81PmAP0CHMoWlu5DyGNFFJFwgvRpSo67z9XrUWXxg=;
 b=neLn85OQGoMNP2kcY0ipyGta/XzNH/rinhm5nmxjiLYvWeIghpX/uZOlgX9aMvIPJVXpaE/C4I1TUCjvm1KVwj+AnhmwFu1DyNubMIe/dV8IgNMmu0ohHyrtnhiRLE/AVkH9VBN17atX9feYx5Xt9KLWoNpaKOyo6/7goleJGHMu3rxIton3A0AYGGTUJ7wW1rf8Licu/LPt6wOUyCrI9C6/yHyYFWEyvCokkv7NlJD3ykcjMMMIuVqs/igqHd24FB5mvLIq4OsBEqlEu1Zy2/DqoiZa8biwnurkPtG67GXN573OGfHshi3ZxAZT94Ug9ZvpLPiowncCfKYTNEPTbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OB81PmAP0CHMoWlu5DyGNFFJFwgvRpSo67z9XrUWXxg=;
 b=APptbBWEowNT+7XRIWZ7cKa5sO/B+y7xFl30e1YetiQmBXt0HKGekllwo30EkBS+fwiKLy7WaEGxjtBdPLsXf3SVnaeHUrpWHxCyq5V01rsi4u7bWlC+ZTTxfimsOszxITgZP8SbHz9koE2bKP7nRL4qrN58tBsWs+1hdeKfpF0=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MN2PR10MB4271.namprd10.prod.outlook.com (2603:10b6:208:199::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 15:58:29 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%7]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 15:58:29 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS handshake
 listener)
Thread-Topic: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Thread-Index: AQHYU0RqwCfhD8h+BkiXOp6ayeNVBq0A6XOAgAFYlQCAABKoAIAAEbcA
Date:   Tue, 26 Apr 2022 15:58:29 +0000
Message-ID: <BA6BB8F6-3A2A-427B-A5D7-30B5F778B7E0@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
 <E8809EC2-D49A-4171-8C88-D5E24FFA4079@oracle.com>
 <20220426075504.18be4ee2@kernel.org>
In-Reply-To: <20220426075504.18be4ee2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77452933-27f2-4e48-7aef-08da279d9b0b
x-ms-traffictypediagnostic: MN2PR10MB4271:EE_
x-microsoft-antispam-prvs: <MN2PR10MB4271F0F997B9475F6D30F37C93FB9@MN2PR10MB4271.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gkfOY9UaJu+nfpjV/Nx+/e7sbh7ASZIDrBVJmgWm8VANqVZ954vCrFbgp8SA2/Upq3DRPwdo27/EBGmTGqD2rW63Xwi5vw0qkd/kXcvqB0wZimY8AYucTXen/M4I0Lre8ug5njURkbNkzxKrBYdlW7L7qYLmrlUq9ZJo0skTcAcj2mC6OS+xLScGu1vSyYogPoO6KrOSTFcDihPFzt4+qNnTpjekZnqaoo1gOZ1L5Yg3ubh8/c4BFmD1xU3YE0Vo9eTveKbyo4wPdfS6ctNro8Lk6CgZWhEFdPjV+4D4b4gRjWv8jXH1fhVq8UpO9TCPCh0kk0T0ztFMSHjm1d04g9mPJrTIh3BbezbNY1CBm0XT+AkyWYN7MZDMSJPLn5Q13hOqYHSAZSV576UzUtfWub68ib9o83J8GfdGME6jr2AfzHZsGUFlhTlS5tK62OHcQr4JSFU4/fQ7iErnrolDG80VwXeIEQxOPV4nwX63+xS4DArS7EzpWpxepBVJjOmY6t7fq7h8HSV2jEK02bu6RzwgcFFvnQieWA/bjLukDt9fz7dPDlb6J+BY8I7BOqQZgfNWq7RA7S2waoKdtgf0YXEz8uyt4qFjz2CnGdU1CGZ6tiEpT1Nhnn+cvZgq07dIP69+NiosqzYSmWZUe3vA8owT/LS97j2Vj1PTP6UHRgLEwWUAhj+JziS4xTeUnk0PLmodJWApxALfdrGfHszrf4HkoGpu/Rf4NvAOPQFE4riJbJCCocZLsGWzpPd68pIY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(4326008)(83380400001)(6916009)(66946007)(8676002)(6486002)(86362001)(508600001)(122000001)(2906002)(38070700005)(38100700002)(5660300002)(64756008)(66556008)(66446008)(66476007)(2616005)(186003)(54906003)(76116006)(71200400001)(316002)(91956017)(26005)(53546011)(6506007)(33656002)(6512007)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eK0fZPenmab8Q+FU2vWqrHdhBrd/zwyr7daqKPeTUnE8roIYoglZAHBaSnCI?=
 =?us-ascii?Q?YLK9dsD6bZa7Ea1Zdaww1xe6DHRhUA12myP+cro1F4ENJdPFkTBWgIwtEn1r?=
 =?us-ascii?Q?/KP0PNAQAqBbv8QeB8UjsihFCjiTdfjQwld/e9fNxNG7HYAYCArmN+LniKEt?=
 =?us-ascii?Q?ee1lWYR5AiSiywMMHsoSxAZXrimrZSIGmFopx3qUid/u/DVGq2gT8X+sdGYy?=
 =?us-ascii?Q?w9NEUO9BQPg6zNckWSc3oEjRZ6YiJ0NhptW7km4bUYgXzP7laPZ1QgPw66vx?=
 =?us-ascii?Q?aiLSCNUV2lYLViJRjKLKnLo9R2sRVSQfrdJzL/mhz+bvvvQm75CLAkO2GCUa?=
 =?us-ascii?Q?DTqp+sX+YhpfAwn3nxSCy7pOwpI6oEKd/ImW75nXTI8n/ITj08erzkfbvslD?=
 =?us-ascii?Q?Rx36w266os4UrIXDUEoLsdBNxFN4jTAXcbdE01MRxASbm0jJrUC+SiaB14Qo?=
 =?us-ascii?Q?hFXpWUfDcE9v+wfq6mj9FdfOmsu0etFzP5sKshnpC4Cd3oWc8Sq5XuTxakGn?=
 =?us-ascii?Q?j9A5SIhelCIB1eDtYOCMxvUOH+IV5uK6IXWCqXLvJ5f7P4qeZnF9SW60zObL?=
 =?us-ascii?Q?Y0h5d7nu/TorDkaNLQtASklZxNWnOZQ0ayjYoAfnPf6+isJ5lHCp1h01aDDS?=
 =?us-ascii?Q?/YDnv1n384z07xnOkAEcV/+cLOsHJVVMQm1HsSC7N/ozSFOlTTcL/0MDg9aI?=
 =?us-ascii?Q?FvAtqF6rykxX4AYMq796Ty8++Z2LuNKja7DeLL+Agy8DA2/vEUeCocEffLK/?=
 =?us-ascii?Q?53EM0Ek0tdjKdOMj/klWGUepkhC4NZb59RGU0gYhoFh7CKjBUqheibT9wsCq?=
 =?us-ascii?Q?xd9gNJuBtJb3LZxbd7NSJopAErg0HI79+gxygC7INv/Z1VCc8k+5uMtuSKex?=
 =?us-ascii?Q?dG1rOJnjk89sdBrAfZkIoEAEv4RDpVeglCL/MTkqVP0Gkum+ISWKnk/VAN/+?=
 =?us-ascii?Q?OifRc4H9BIDzR6xBSk5gitvUq7ZHhbElu2A9ce2dS4TXz1pxVUB/iiR9Bx+S?=
 =?us-ascii?Q?1+PXmXjljHYE7T7iH98URwVato9/3d7cj3klvbGOSDCGFDn7Srkv1onEfNeS?=
 =?us-ascii?Q?tu5RE45oNSS8J0ibEXjwn86LU6+Ync0QfZ3fhv5XsI/huOPrgN9uwMjaBn4Z?=
 =?us-ascii?Q?hzYA0i5FgEemWRyXUS2jmZNpiVBrxYIMn5kFvNz8cjzuWrojC+xr8C/vKJI6?=
 =?us-ascii?Q?NcieEsgnXVKE+p/0xKbtc+zw3jUYgE+S9rFQtUdSzuNe6hiaByd3PBn4ikKA?=
 =?us-ascii?Q?CBlafM6r0C1KyoigcyZ5/onet2suQRZizZl4e0pqKcuaU62EW2xMjfs5lUeN?=
 =?us-ascii?Q?PCOcqCRHasxG+r/uuAhD63Q2gKyQHWmEhbvOf6Nv3ZLxGDxR2x6aK9bExcpH?=
 =?us-ascii?Q?NXmgmpvCT59nwxKU695xSWMwGz2rrtAjUo9hQAqcbkOuvR7M5YsXFkp9mv6d?=
 =?us-ascii?Q?fT7y1VeQ/0ZceakCjaZ0T1J2ZcXA5hrT8inSW0K7DHMg6boa2FbE3V9o2slm?=
 =?us-ascii?Q?tGOk1VhkDpxjK4bpsBwGu3EAScgCtq3hYqA0G54JVt8qS7YIsjqToeul/8fP?=
 =?us-ascii?Q?Q1efRM/wnl9YqTGESNrj3qkfzlP8LdJz+Bdf5YwKSi4P41NyKaD8t3yaknkk?=
 =?us-ascii?Q?mG3VPDoy7LEECk1acKHM6EMoF5+GdrsH5xBdQr0tHTWm4cRUGa1tSgNmkVQv?=
 =?us-ascii?Q?D44nopC8AG4WH5rJLxHjWW08y/O9/TTru3i3DAHcIkc+lyJhIbPECgX2Rs56?=
 =?us-ascii?Q?HrVHdXU75iYs6L4hxgm0I8i6XR8OU4g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <64E2B96AF1A06C419AD15E09EFB65BF3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77452933-27f2-4e48-7aef-08da279d9b0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 15:58:29.0749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0QMiT/ygn9+vpO3yQfq9iuWhztRWfgZPAK2jdMtmjO8ICgqN4NBPFTm0s6Bmd7ZzCLtZ7/kRQy6O+XY1v9EaQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4271
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_04:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=840
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260101
X-Proofpoint-ORIG-GUID: cNxx0F5KkMBruHhr--iprTh8_G7gJ22R
X-Proofpoint-GUID: cNxx0F5KkMBruHhr--iprTh8_G7gJ22R
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 26, 2022, at 10:55 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Tue, 26 Apr 2022 13:48:20 +0000 Chuck Lever III wrote:
>>> Create the socket in user space, do all the handshakes you need there
>>> and then pass it to the kernel.  This is how NBD + TLS works.  Scales
>>> better and requires much less kernel code. =20
>>=20
>> The RPC-with-TLS standard allows unencrypted RPC traffic on the connecti=
on
>> before sending ClientHello. I think we'd like to stick with creating the
>> socket in the kernel, for this reason and for the reasons Hannes mention=
s
>> in his reply.
>=20
> Umpf, I presume that's reviewed by security people in IETF so I guess
> it's done right this time (tm).

> Your wording seems careful not to imply that you actually need that,
> tho. Am I over-interpreting?

RPC-with-TLS requires one RPC as a "starttls" token. That could be
done in user space as part of the handshake, but it is currently
done in the kernel to enable the user agent to be shared with other
kernel consumers of TLS. Keep in mind that we already have two
real consumers: NVMe and RPC-with-TLS; and possibly QUIC.

You asserted earlier that creating sockets in user space "scales
better" but did not provide any data. Can we see some? How well
does it need to scale for storage protocols that use long-lived
connections?

Also, why has no-one mentioned the NBD on TLS implementation to
us before? I will try to review that code soon.


> This set does not even have selftests.

I can include unit tests with the prototype. Someone needs to
educate me on what is the preferred unit test paradigm for this
type of subsystem. Examples in the current kernel code base would
help too.


> Plus there are more protocols being actively worked on (QUIC, PSP etc.)
> Having per ULP special sauce to invoke a user space helper is not the
> paradigm we chose, and the time as inopportune as ever to change that.

When we started discussing TLS handshake requirements with some
community members several years ago, creating the socket in
kernel and passing it up to a user agent was the suggested design.
Has that recommendation changed since then?

I'd prefer an in-kernel handshake implementation over a user
space one (even one that is sharable amongst transports and ULPs
as my proposal is intended to be). However, so far we've been told
that an in-kernel handshake implementation is a non-starter.

But in the abstract, we agree that having a single TLS handshake
mechanism for kernel consumers is preferable.


--
Chuck Lever



