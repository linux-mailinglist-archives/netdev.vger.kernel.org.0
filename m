Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB7A50FF78
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345949AbiDZNvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241669AbiDZNvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:51:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0B76D4FA;
        Tue, 26 Apr 2022 06:48:39 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QDT06N015405;
        Tue, 26 Apr 2022 13:48:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=askmJi/J06T97e47sb6f9TiS9Ky6jfT+kFmVeoCc4To=;
 b=f04HzeS5Lzztq9uBUKHsHHIyYTvPcrM0SDACSH/YFaGqJUAHXHpH2u3aWBha8uOZkjq4
 jPCxbpdXtWlCe7vkj6GZvZSufWK0rbOam4wfwFABvnLfIwFEBaK7vC2a+ZA0ys4efUvH
 EaYfAnuZ7pVT6Z0FARZztXTj2W9jt0JRMzOGljhfekmF3BCdnC8gTGdYm1auzO9qYiAq
 JUOxydryQjKtOyj96hAFz9lFKzOUNhQ72bxMVQkfPb5TSE/YYhD80DHYcMBY16CNZuBN
 FQLQSAq8uTnfmPI4kfjmafvNfEZNx0EeoD5Z+lojo+EnJxUTVawZYi2a+QLlBr3+T7A/ Fg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9ap2wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 13:48:24 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23QDk7Vi022918;
        Tue, 26 Apr 2022 13:48:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w3e8rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 13:48:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVRIK51DmbQcQimHdmAvrzy7nl4Hb9aswUJsy9KlOZf0UUw4aD0enYmIKkrmRbyk+kDAwjqztN49d9otp1WVK2ilIJAibRxdA2mz9BCs6mW7+PRoJlnWOe2tHzudTEB9wte2R1Y1gCg9SmtRAinOTFOEDeSCvzpvHIhW6Nzzw0jPS0yyLywI1YHDsMAqUpWvDuEaZbj9xNKz9cEcKpLwMXsxRykqDvr2Z0Q7RC4Lzx2iDf1YOEZWLe1I50OW7Vq2LUJnuV2uRSjUIysunbC0clk/5jwR8BeV8ALEySvmTCl10vL7553o6UwgzsnXw/CTPQxyeYwh2sDuTI2mLbRAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=askmJi/J06T97e47sb6f9TiS9Ky6jfT+kFmVeoCc4To=;
 b=PFoz8eza8CPj35j3F9lron4SYqzzQtBxgTnTloyF5sY268b5gWuolQxm7EG4gcbRQwUc15ct1ZnwB+eWLAJyEp3Hg/XrrY5z1CQDNSWAexRgZNzboflqfxl5r7VnWkus8IUmDwJXgESTpcynZ6bpoNOQj/5iO+4XXO+BvaNPytI7b+SVfzHt+4egLjireasMaiNFEgAL20uafdYGXJHHVGALrq+JuiJ0s4K/tgckG7BW0ELJHf3cHLny15KWbdwktIuxTQIFio3RQojuD1eiZRbcEKu92xOBtJn/5NfJ6comL5UAq5CkGJGWkNF+zoktxrI7TBnkiTttXOzG5YvxjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=askmJi/J06T97e47sb6f9TiS9Ky6jfT+kFmVeoCc4To=;
 b=LpQxNUKm8DlR2aCP+bIwJNNf0T9cIs1673qOD9S5eiKgdlJfO70Xy7XereO4JrZkSrSSOZ8YaPKFKqWpRc6Yc/uOlqZrhyiuelX9TswttPgFqBFaJ9CX1ji9YYNI1JQcaAYN0+QMI6Vf34HrnSROXa8QLrcNl9wwqO6aLNDwJt4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH0PR10MB4775.namprd10.prod.outlook.com (2603:10b6:510:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 13:48:20 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ed81:8458:5414:f59f%7]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 13:48:20 +0000
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
Thread-Index: AQHYU0RqwCfhD8h+BkiXOp6ayeNVBq0A6XOAgAFYlQA=
Date:   Tue, 26 Apr 2022 13:48:20 +0000
Message-ID: <E8809EC2-D49A-4171-8C88-D5E24FFA4079@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
 <20220425101459.15484d17@kernel.org>
In-Reply-To: <20220425101459.15484d17@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6213d43-d5f3-4066-f945-08da278b6ce6
x-ms-traffictypediagnostic: PH0PR10MB4775:EE_
x-microsoft-antispam-prvs: <PH0PR10MB47754F858343F47BD1F244C893FB9@PH0PR10MB4775.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /JZijHF/q+dWG6J6hTMYWMs7etw3JVG86bEXeWIBS3wTA1HPfpGDWzQwH+mcybm54gvFKqDN8+7Zk4zjBLSBn60a/Aj/9/JP0JngpdmeLVgkXcIvzth5GyP8lciLna2kpW+QaNglsJIcCiNOv5Vzd4ItpWdfA+jroQCiFZljjYFpeopboLubxLHn5F36iv17s6BitKXEaUJguiDsIpVkX+gRGQlIuNMkIY7qlApLE6fxLROBJe13/qEms+UDrZQi6fRKR4fUPCV5D85tj+sEETJz1wy8UokbGNgnMZGmhNitsOpz2GyUw7YvAle57/R6ChuRM+BZALIt1Pz6+8Dwy1tbkMEi3eqp5cz2mQYO8mguJfgJIt+474Ms3WaW+RX8FZBK34XMLI8Sg/gKFu3zItkt6hv3+bOyq2Y1mx1jsZimMUoBROaUSTXGHXZt60kFplZliQ/Fhm6B2gwZiWeypbmOlJPV0JHqcaXRY1YxHTzGZlV0VDnXrf/C5vMKE/5I2eU4LWBeLiYDUZ0jbWALk6cPUpNuEH4TDpS40MPwC7SPB41953IToloSc1lk1KGX9L6iU/6WujJxYTxCW7ehlR275IZ7/C30PzZaRwb1FDuJ60y5KvUkhhBWcgw/ckNfBCc/DQ11vn3OcqBjHrZ/BNVl1XBIPvIaH7YPvdXiEey5mQb4jfwHElpPX6VYdYFAXW0izgxIi4PWT698y8el32Qm7QgKNCOPBEst3SsuhDO8Y7HpuUPZJN8P60l4Np6m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(2616005)(186003)(71200400001)(76116006)(5660300002)(66556008)(66446008)(64756008)(66476007)(33656002)(6506007)(36756003)(6512007)(91956017)(53546011)(26005)(83380400001)(6916009)(316002)(66946007)(8676002)(4326008)(8936002)(508600001)(122000001)(2906002)(38070700005)(38100700002)(6486002)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bzZG9Q2j3C2k7fjjuinlDQ3v+wiaHgGmygMIjX+Ou3oim+Srw2iHOyotAbOu?=
 =?us-ascii?Q?Vk+1UxvH2T/8u2n73SZxubK5F3ND8MOdPJcAVTduaBU0YPFB1dup/8SxvgTg?=
 =?us-ascii?Q?C/lcg2TCbR2RtWBaClkL76xyQPb0RqqyB8qD8x3xL10+gcb6veBWA4LV2Kb7?=
 =?us-ascii?Q?+Y+m293l4OgvDZNzIEsIDcYMCCv3Qfxo5JzIC80e6ZlkSdaueXekR9ClcD2T?=
 =?us-ascii?Q?nqdhgME5UhO3ksorSgfYmgz/QqshtPxlKAKdKE1C/gWtyIvO2ertVISjpkDG?=
 =?us-ascii?Q?yurNbeINbMZhreCZLICT8vQ/UHFFVmYPEaIH8W67cxfspRwPxEe/0y1+nE9i?=
 =?us-ascii?Q?3mS0EziIJPzA3TYc3/DFvm8uCFSppXn3/61asdDeT7JWQvXGhtG1xyA6rwuN?=
 =?us-ascii?Q?WyKX/WZLIS8JPDL5GEqzotbLDdDUZe5mdpGYHGu4dJzPvzpssZM6oY0R380p?=
 =?us-ascii?Q?SpA5TMAWVIVYsihF7GWb9YADteNdaXABKNaLXnoyJ+3S8Q/C0tSyzHZNtC0V?=
 =?us-ascii?Q?37F2pSP7ex2Aj5uWG9TQFaH0qOjHsG4xwyn9vwCzfNRlsbja6zOWLG7fvwFl?=
 =?us-ascii?Q?PhfcBQ7NHhiZlk70ITkjqLlI0fSagAvh/EPYP137BC+g8ANtAIAWNDE1wYEf?=
 =?us-ascii?Q?ta1FoXJ/oFI1o5hKzUdHJCv5YlwsbvnUMbpGhbAQL026VV84JFpPS9dB2bxM?=
 =?us-ascii?Q?1NCx8o3dyRPN93hP9cDhwvXH/l59Wuir7aRVU/EHiJlU+Yae9SDAMQYhbCUy?=
 =?us-ascii?Q?13JlxLZ8PYEkWD01o73L9tIUGbg03UmlZdglECYjsKtpqRcZuqupN8tqXSei?=
 =?us-ascii?Q?yxpCUW2wVn/OenM6/bfbQzZ9yDeJ59xFSvObu/d4599z4MkCDhb3lSAs7oNS?=
 =?us-ascii?Q?JeHJO4nlUD5yZqBTJBjJT1zIPidA1WY+aK/weltuagyOBWZex0oWw8CVD+kT?=
 =?us-ascii?Q?wcgkw3OVV5k/QqiqKi68tJ+cCwITc58ZofZ9GplL923Vl/mw0Hc1v01n//Wr?=
 =?us-ascii?Q?8z8UXbpYfu1xxhl0CFrzrTUR7R4kRWS0mNC9FrgG7ewKy1hAQvBrd2PVGZN9?=
 =?us-ascii?Q?gkjAfOrDlHaOILhRWJj7OIvKHUYDZYZu+rm4A/RxoatkKEn64PVO6rqEX2rM?=
 =?us-ascii?Q?qAx8EUYf7FmhPEigoopNdI8b5JHDAq7sSbvLA6lYPJ4/tATq0Z7pm/e77rsA?=
 =?us-ascii?Q?Q1yq5PtcX1rElYC457YchXieoOi7zEdcekDgq/0LudgqoEFr6FDa2k8/8Qyu?=
 =?us-ascii?Q?DQ/E+PvAeBLU7t7cDlnHttAPuk9XB0t66hEZCi1g7XTfigtiN6HR1tTCSUXp?=
 =?us-ascii?Q?awQxmbDXnkE4N6/YdioWObicBPbHJuk+71iMa3E+tB1qvSOuEDbeUBi6LVX6?=
 =?us-ascii?Q?1Uju2jRSmNkgkMYf4QpXQExugouMpOo0SLbBJhPiDxHZaFbifO/nMfUJJYkW?=
 =?us-ascii?Q?rmma4oXHuQISRBLnuJg0f/5AFING8w/bkFXSjnRcnnOEh5pEoE7XiC3COd5I?=
 =?us-ascii?Q?IrOx1voiC9mfsAsxjMUdYZBwTetm0AAoeohBwmShMTv/ehVrm7LCjkkEBRd5?=
 =?us-ascii?Q?ib4NG+9bsQBim7ydpGd3JeEPvW6yuN/WTW3G2DZ4xHUIAB4szYH7k3uGsAbA?=
 =?us-ascii?Q?10ystYEjBhrybPNTrIKT9uLONe9BSO5SSnKwitk9phGRCKpMxK2Husq96st5?=
 =?us-ascii?Q?bAHF8HDxqwBTbbwcoSfTu2AJGS8V/UNvnUyhGCSWWrfzVjRID8OpMYa49DHM?=
 =?us-ascii?Q?T+J0tKVYq68lKdjVCvynW5LcKyJmdnE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <87054F540B3238479BE4D816F52ADBF8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6213d43-d5f3-4066-f945-08da278b6ce6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 13:48:20.6891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CPjNJTJNkGbh8GtiUX4XCWZjeyD2yS8voTJ+b0JPuCL82N11S7/9wmpCkG/OZyePqiY6/xQV9sWXU4QAqEcsaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4775
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_02:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=872
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260087
X-Proofpoint-ORIG-GUID: jYGzYmMKi85vQTUXhpgBJ2DomSjPrKYP
X-Proofpoint-GUID: jYGzYmMKi85vQTUXhpgBJ2DomSjPrKYP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub-

> On Apr 25, 2022, at 1:14 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Mon, 18 Apr 2022 12:49:50 -0400 Chuck Lever wrote:
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
>=20
> Create the socket in user space, do all the handshakes you need there
> and then pass it to the kernel.  This is how NBD + TLS works.  Scales
> better and requires much less kernel code.

The RPC-with-TLS standard allows unencrypted RPC traffic on the connection
before sending ClientHello. I think we'd like to stick with creating the
socket in the kernel, for this reason and for the reasons Hannes mentions
in his reply.

--
Chuck Lever



