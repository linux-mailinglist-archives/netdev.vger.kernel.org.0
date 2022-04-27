Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD008511A72
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiD0OqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 10:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiD0OqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 10:46:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563373630B;
        Wed, 27 Apr 2022 07:43:08 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RCHYWb015475;
        Wed, 27 Apr 2022 14:42:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RenDz+k50MrloV1u4C45cKWL2n1eCbbodnGd5QnL9JI=;
 b=Oo0w46A86k19XNQvPcS1EsCYTIhYd10dmmIFFglHKJx8gb/tfYVEVGcBfTonDj34eiFy
 LkEzpRo1Q9Zie5FzT2rcWmGgJ2O4oHDDhycnRbXdEsbNzoOv4KjllTajRays6c5DBqYS
 gPkBtr+GIp/9ploG3BXVQM3k3ntsd9iLJKneq1d5GUMdsKxGc1bfuu2vpEYvIWm9FzxT
 A6nuJnklyysSDEbPAusHDoNhCWFc+5zmOlOq+gX2YCHk/TD6B6NZw5xKWo6paZghFZ6B
 CkAtqwLm9gPI8Co8bQwEClMuvHdB9E2AhMoyknF1F8nP9ytzrvx5EsLzBURM/4FAuszk GQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9as868-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 14:42:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23REf9pZ008911;
        Wed, 27 Apr 2022 14:42:55 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w4vj62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 14:42:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cb6Eqc/kyOaNjfq/4RX8iJe9jGDM5cuRxf4KsZL1EhYAlqmWsqEFhIsT4wX7d3FNC9OlLBPjxkR2I663um0pTr28lBE/ub4YGdlpX4WL6CHq3Yavr+5Lv9WO4cn//kL6fq4ehrVL2vguW76OUVBNUZcWz+gapCr3Jc5WSxNYcdFb5gJEbsdZIZID+W+uoBHiTDL5Rkszh+r7RCHYV07jzyHf2gfglo2hxP27lPxXCHiw8BbywyOOcIRxqzxRFroZXg8hLtGNfWaizrHN9+BbhmG/Va+7oHm8Fc62Slz3d+qHcfHqAUYFxsnLN5A682/SmZVVz/+xaJUlQY7Hp959Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RenDz+k50MrloV1u4C45cKWL2n1eCbbodnGd5QnL9JI=;
 b=i64qaQfXqabnLXITC9a7n0dphH0XkuKGSuGk0WTFZ6SJqJ2et8whZSwLiWsEYZdUo655+6ZVjnHZKA4fQxfda47MjEY2lpSx56xXjBb4aOyYNePbgNAABuWlPvikAQhvzbS5TlfFJ0vcLKOrYUSjPixV1yKCHWIEClo7bit3fpLvf9Z7MRtcYMZpR1zpOgSzs10kSlJ7zz6bWFQSTvFW3qrFExyFEOdzR5d+Yet64B/G13MMxN3Y0FH1rLKKRFvqrwLTFCRySc0CeAaPakcTTDzHDyR2Po6tph6NE33Dzy6+GhZoJfAVU/2wCXGWoN+GUGdF0DQ4pQME1kLqGoCX0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RenDz+k50MrloV1u4C45cKWL2n1eCbbodnGd5QnL9JI=;
 b=qx2F3KdVsqWRizqpdH3nGrHNQAaEFM/qDqa6KFN9oh2WxY07gsxYuzV9b0F+2CJq7H5qMFpp5PPrjvwgPhyf0aoXN6xZsq9fIHy2jG0hNu0Mc6fhkU3b7Sf9m4E5ZXE+KuzaaK3Z79JH7l+CvZ01GnsoacjrAVI5wUhC+lY1hCg=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SN4PR10MB5621.namprd10.prod.outlook.com (2603:10b6:806:20f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 27 Apr
 2022 14:42:53 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%9]) with mapi id 15.20.5206.013; Wed, 27 Apr 2022
 14:42:53 +0000
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
Thread-Index: AQHYU0RqwCfhD8h+BkiXOp6ayeNVBq0A6XOAgAFYlQCAABKoAIAAEbcAgACC9gCAAPo/AA==
Date:   Wed, 27 Apr 2022 14:42:53 +0000
Message-ID: <7B871201-AC3C-46E2-98B0-52B44530E7BD@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
 <E8809EC2-D49A-4171-8C88-D5E24FFA4079@oracle.com>
 <20220426075504.18be4ee2@kernel.org>
 <BA6BB8F6-3A2A-427B-A5D7-30B5F778B7E0@oracle.com>
 <20220426164712.068e365c@kernel.org>
In-Reply-To: <20220426164712.068e365c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dc8cd6f-a5e6-4850-d579-08da285c3624
x-ms-traffictypediagnostic: SN4PR10MB5621:EE_
x-microsoft-antispam-prvs: <SN4PR10MB5621E77F8B0F283B52FF982A93FA9@SN4PR10MB5621.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PvStKTscM5TTvytEbDp1OXOIZvC/RnEZUg7jr2a+oIc4WbP+KSMtfQuagey0WlhWUYt/yTUqxaXB2r/j4yajKvF/rrCX8Aobnw87xRB8EaL7FgkW/kzb2HqzuvpqiRPfXQFjbuzod+BPGNNKyM1vb3Ahe0eqaxT+UF43mkjaO8j2jZUU6sulDcg/2/bKLFSzBNBXOWHPnAJmZOjif3DPPHxBbUR/gaqU4zzNeNBg+qYYdyiYko6nCCHMw+o7xEdNY8dEPdiGmOZFleNLjzrCcdLMLEbBPkeM22fnB8DTWXBr/ZgdMGI8hohh4rMkBgZUvjgm+IVlW6J2YsgMsrdvm+FV9JLaeJTrM9hLa0B3zU3p/KqLmEq3uz2SOFRASnwYDHYIKC3onq4jU9crSSOiILD1Mgxys4DYmnYVvjYE81IOZP9MT1tTgNADno9Wi2P6gJG8aCbb9aAwRW8gKY29jHrFXBWfx/+q3P3elvuF40YQ4btkyOFlWI4GCJaKlZ4hSbLpFsv6/RiuhO3NiSvTCCB+W/bJ4YQNFvY3HLF1Ulb0UCbsV3timAdSswIm8a5Ip1EfbWl3xwOhWlbs8EBP8ag6bgZOqTJL5336nEXb9RNkT1R+hOoruYOaMMqHJamA1Bq8elPKm6Y3xcfjR2NYWytMcMgZlIHOJizBVRAoMi30+hBSSIPcWMhlu2DAgQio+GO8+vW53Ws9kgWsJrcPtQoywHohPTU4uWhoqj6Yq2minVKEISue0A01P77Av9do
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(26005)(91956017)(66446008)(8676002)(66946007)(66556008)(66476007)(64756008)(33656002)(8936002)(2616005)(76116006)(186003)(6506007)(36756003)(53546011)(6512007)(71200400001)(86362001)(5660300002)(83380400001)(122000001)(2906002)(508600001)(38100700002)(38070700005)(6486002)(6916009)(316002)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o3LcYZOfmvAy/Ykky0/D6JdSjVGIRgxvsYo9a6sM7BCL10pTmUxaTxg7pWMB?=
 =?us-ascii?Q?p8XcpHK0+W4Dh5QjgL1tR9tgO/nV+JqZoDorm4qd721PG0v5oIyJ8lfEJMIF?=
 =?us-ascii?Q?AXzOm/on1rHWhKOfX0ohrcCmdPSK3IWsXyymzCGl/9rHN1cNBGNKxAmV0wYs?=
 =?us-ascii?Q?0Yxxy3bxAZ2EiufBuThJYfAPYt7S/f+lRlF9lbh4yOx3fRj5st6ZmPuw1Wty?=
 =?us-ascii?Q?4uDpdht1WxZjN8AibnE+UEtUSJ2hlamJh/TWaWhgz2iX0wSJgzixROqytXEu?=
 =?us-ascii?Q?3NdO22Koj5bZXNJ1YlJAuUYYGXs1g85yNNsER7BKZThyaScOjj24bxbQFbaL?=
 =?us-ascii?Q?o8A8mp1RD3J23/oH4zVVrpUzzlu6xLZi1Ak0O30HQQRN85nAkdeyzXIxHCng?=
 =?us-ascii?Q?QB65OB27fv+ilO2KxLhwCutmMehNEYvaSAqbliSqKK5mHGzir+l1PISUQHyS?=
 =?us-ascii?Q?7OQubFuLf6fCfCbHaveTWkCp2lIHdEeZ+JxoP+mwRyZMXknWWtSpABQNNjXd?=
 =?us-ascii?Q?7Dchrpglqy1z5QDrBvz3QsFU3v9nUQNpQ4YhmJqzR4R0W0LEp+uXBDF8NwM3?=
 =?us-ascii?Q?ON/aK7gfeBqmoX4kDoPiFuyx7i0prOvKi6255E6xROwlkbhR13BKnNNmU1Wh?=
 =?us-ascii?Q?Nwkc1ZxIgMFbGjNGRhdrcd5KYc+HfK9P/7Q8RnlShFYC/Wh5o5jIPLbbBsdx?=
 =?us-ascii?Q?NIUbIKYJpCXbXz71kCgBud8EX/qSVjd8d+Oh+xym0mDqVuNvne2hagYXjQKr?=
 =?us-ascii?Q?8awAb6csqcFZDAgqiWjAkMY+FCCGKZp9drEvpJDgmr7TCk4Ki42jast0rXp1?=
 =?us-ascii?Q?UfZq+ZzW6VaMet+RR+B5wi3cjfmip8HWPUIkjA65jPbXdI8e9kYelHjufk8j?=
 =?us-ascii?Q?u6R+RRX+uBXK4uESKEeCqFKADB4NM832vzZc43/SRy61BbwtoE5rBgRIJDkH?=
 =?us-ascii?Q?hHLrRjtKWjMbwXwJmwGxRNnXEqFPH8e+sIDCtZf41vrvE91QG8QB0ug6iAyV?=
 =?us-ascii?Q?/riqBGG+axFMugVOJCCdpvmbGjrNV8szBvzJaE/rhl8XRpGyNxVDHb0o3QtW?=
 =?us-ascii?Q?uB4NS6Zz6cI1rF8j0P9wF1k49QHESDnJ40P8a/181oWg+dSOTOIr4EOJjog/?=
 =?us-ascii?Q?jkJBgQsD9SiBbZPQnRtFyk/9SCBaXQ1gqMZXHSW5fdSFlGrOhtNuCFskT2Jm?=
 =?us-ascii?Q?pXijfV8pYlOxVocEqFZGnrW7xMC8gl5RLHmrjUlWrwx9IGK5JFMEUBjtepe0?=
 =?us-ascii?Q?cJz8X40p2OWYaLOwJwVWyKS3xGcmo+QGjqmrPa5E1mPqdBbRiIZdd2XCsuuU?=
 =?us-ascii?Q?7Df00cab7AqFdpu1hKG+1LhKCdCAV65ZT+XjPokSaGgGkZyvhJUlQibledJc?=
 =?us-ascii?Q?TCZYPjUuHxfpxl75s9C1mZ07dlDHWynsPRyB7yEYJgbcG6Ev0sHZWcJ9iYlz?=
 =?us-ascii?Q?3gxhe7JkM/YtP177L++ZF1loSy+RCMHPocFymYDUfkZPjpF8jCox4QhJVWh9?=
 =?us-ascii?Q?4K8DmjSkTTmjxAIbnTcGhJdjNZ6ZU685x6XS6v6UuneMte5IMC+aM+SCtLMW?=
 =?us-ascii?Q?Fx7h7tNNu8z8hdmgb3SR1YDqd0yX9XzxvMdj3k5+yu2i6K1CnrhZVteWmpzF?=
 =?us-ascii?Q?WyKHeXzgXpYvn7c3h1/5wF++4dYdR/qqDcbIIzwrsk2dpyexAqJJs8KmLaoU?=
 =?us-ascii?Q?m6Cmmm1DF6IjwDlDDKM/ygatYpQ8Ug2W4oeIPfaRdlQy/J6E0nBGXdYfCSn0?=
 =?us-ascii?Q?JsBR5++Oi7hhMoqX61qUXd7Ag3Qtd04=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D658A0F9B1F36C4798C3ADB1F496A3CE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc8cd6f-a5e6-4850-d579-08da285c3624
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 14:42:53.6363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /KbUGynd7Hx2T/tcBOFVf5yuGVUmP4T1mtWTciOoGc6+BEwZ61/L6uJU1myvjDd3pxEqYMhv3sAb7KoJdOZjwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5621
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-27_04:2022-04-27,2022-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270093
X-Proofpoint-ORIG-GUID: R8h2mkxXdQ6uVrjZxB1hlXyLYxih7d0Q
X-Proofpoint-GUID: R8h2mkxXdQ6uVrjZxB1hlXyLYxih7d0Q
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 26, 2022, at 7:47 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Tue, 26 Apr 2022 15:58:29 +0000 Chuck Lever III wrote:
>>> On Apr 26, 2022, at 10:55 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>>>> The RPC-with-TLS standard allows unencrypted RPC traffic on the connec=
tion
>>>> before sending ClientHello. I think we'd like to stick with creating t=
he
>>>> socket in the kernel, for this reason and for the reasons Hannes menti=
ons
>>>> in his reply. =20
>>>=20
>>> Umpf, I presume that's reviewed by security people in IETF so I guess
>>> it's done right this time (tm). =20
>>=20
>>> Your wording seems careful not to imply that you actually need that,
>>> tho. Am I over-interpreting? =20
>>=20
>> RPC-with-TLS requires one RPC as a "starttls" token. That could be
>> done in user space as part of the handshake, but it is currently
>> done in the kernel to enable the user agent to be shared with other
>> kernel consumers of TLS. Keep in mind that we already have two
>> real consumers: NVMe and RPC-with-TLS; and possibly QUIC.
>>=20
>> You asserted earlier that creating sockets in user space "scales
>> better" but did not provide any data. Can we see some? How well
>> does it need to scale for storage protocols that use long-lived
>> connections?
>=20
> I meant scale with the number of possible crypto protocols,=20
> I mentioned three there.

I'm looking at previous emails. The "three crypto protocols"
don't stand out to me. Which ones?

The prototype has a "handshake type" option that enables the kernel
to request handshakes for different transport layer security
protocols. Is that the kind of scalability you mean?

For TLS, we expect to have at least:

 - ClientHello
  - X509
  - PSK
 - ServerHello
 - Re-key

It should be straightforward to add the ability to service
other handshake types.


>> Also, why has no-one mentioned the NBD on TLS implementation to
>> us before? I will try to review that code soon.
>=20
> Oops, maybe that thing had never seen the light of a public mailing
> list then :S Dave Watson was working on it at Facebook, but he since
> moved to greener pastures.
>=20
>>> This set does not even have selftests. =20
>>=20
>> I can include unit tests with the prototype. Someone needs to
>> educate me on what is the preferred unit test paradigm for this
>> type of subsystem. Examples in the current kernel code base would
>> help too.
>=20
> Whatever level of testing makes you as an engineer comfortable
> with saying "this test suite is sufficient"? ;)
>=20
> For TLS we have tools/testing/selftests/net/tls.c - it's hardly
> an example of excellence but, you know, it catches bugs here and=20
> there.

My question wasn't clear, sorry. I meant, what framework is
appropriate to use for unit tests in this area?


>>> Plus there are more protocols being actively worked on (QUIC, PSP etc.)
>>> Having per ULP special sauce to invoke a user space helper is not the
>>> paradigm we chose, and the time as inopportune as ever to change that. =
=20
>>=20
>> When we started discussing TLS handshake requirements with some
>> community members several years ago, creating the socket in
>> kernel and passing it up to a user agent was the suggested design.
>> Has that recommendation changed since then?
>=20
> Hm, do you remember who you discussed it with? Would be good=20
> to loop those folks in.

Yes, I remember. Trond Myklebust discussed this with Dave Miller
during a hallway conversation at a conference (probably Plumbers)
in 2018 or 2019.

Trond is Cc'd on this thread via linux-nfs@ and Dave is Cc'd via
netdev@.

I also traded email with Boris Pismenny about this a year ago,
and if memory serves he also recommended passing an existing
socket up to user space. He is Cc'd on this directly.


> I wasn't involved at the beginning of the=20
> TLS work, I know second hand that HW offload and nbd were involved=20
> and that the design went thru some serious re-architecting along=20
> the way. In the beginning there was a separate socket for control
> records, and that was nacked.
>=20
> But also (and perhaps most importantly) I'm not really objecting=20
> to creating the socket in the kernel. I'm primarily objecting to=20
> a second type of a special TLS socket which has TLS semantics.

I don't understand your objection. Can you clarify?

AF_TLSH is a listen-only socket. It's just a rendezvous point
for passing a kernel socket up to user space. It doesn't have
any particular "TLS semantics". It's the user space agent
listening on that endpoint that implements particular handshake
behaviors.

In fact, if the name AF_TLSH gives you hives, that can be made
more generic. However, that makes it harder for the kernel to
figure out which listening endpoint handles handshake requests.


>> I'd prefer an in-kernel handshake implementation over a user
>> space one (even one that is sharable amongst transports and ULPs
>> as my proposal is intended to be). However, so far we've been told
>> that an in-kernel handshake implementation is a non-starter.
>>=20
>> But in the abstract, we agree that having a single TLS handshake
>> mechanism for kernel consumers is preferable.
>=20
> For some definition of "we" which doesn't not include me?

The double negative made me blink a couple of times.

I'm working with folks from the Linux NFS community, the
Linux block community, and the Linux SMB community. We
would be happy to include you in our effort, if you would
like to be more involved.


--
Chuck Lever



