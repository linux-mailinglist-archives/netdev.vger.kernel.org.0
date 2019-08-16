Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D0D901E7
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfHPMph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:45:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35080 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726075AbfHPMph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 08:45:37 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GCYxvf021127;
        Fri, 16 Aug 2019 05:45:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VGXZpwEtbt0b8fYzR4yjXOS9F3xf4EnBlVMisE8oKMU=;
 b=i7hpQw/hm4XeU2FoDgOC77xAfsHT1h7UH1W/QeucdVOi6ywKjDVz1dDG+S2lY5kNgP2z
 9q8ZWS4KF2JhDxKeWK3LRFzXfcH9SKBnIElN1BlsZqfM+xUcRNsLjjhIJ5omkTex014d
 fC9jxVcDG3R7m6sA4w6J2aCpGGl4L95zpU0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uds7agpcn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 16 Aug 2019 05:45:19 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 16 Aug 2019 05:45:17 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 16 Aug 2019 05:45:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDbsw1PAwNOf4furLmZIVzP9l7lPE48+eMRty9l7vsBFqRfRN2Zql7gXJb5F9dKO2K+RPvnfOgnEqqdnDdbVbfSvF3Y7o9m2iCswCQ+SlaUOTaYPySOMjGP9c0pbosp83/VdbQ+XZZZoMPbR8wq3TelSNC8ZW4Sk10PrdZwQVLIBS0M53sGnPNUM9gMyfZNocrHbtLfSIQ7jdBgX8gegdEPuGwo/lk2bk1hYXiB7XHjBYgrjjMMZvSFpFMY5v/LOlBWNX/Avr3O4HsJ9JrSrWLSEVsNtSMokl0QgdO1YesQeNC/PLXd4jKvvsHy87E4cnJLQYa1BfEABe2VD7qjivQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGXZpwEtbt0b8fYzR4yjXOS9F3xf4EnBlVMisE8oKMU=;
 b=ghM9buZL1yILQ6es1s8DX07zHMnwKKaYfjlG8GgdR0jwHtRx4zNT8AU8eLb4WEuVSinH33J2TmR476zU44iDOAs+PHVYYl0thnXB4JxyTEZnmKS1JakKD3jIc6qbcF6RbNm2uUzVh74/4PSlCQI1BXtKEGVLbVQiEqNhNX982lI72Q0JCxrdB3fAY3wWk6WrIR9rsg5OoRiRCq5qnE0bl8T+Bs4cjNzooQtYf/9/bBx08tDRq5y3Pp16qIXPYkvAujeH5a3dUvN6mhTaAgWS5GqmGGsVEdUyZF3fmj87plox3thDsOg2kIoRflTmK9VZteMIFrQCMkHNqoVFjk68+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGXZpwEtbt0b8fYzR4yjXOS9F3xf4EnBlVMisE8oKMU=;
 b=CDgiMAs/lmXnePw8m4iM5HQwy7loHyCesZaH3jVaFd1fYf/y7tvdokYnyl2epKPKhlM6ROSsiuxrk+zd9/UkqGLZhCzEXcrTwg66cyZ3dVSSGGTTfSSxo9I1CqKAZjSLMvvEWAoOdGaW3vtyirjdqp0e8KvWm0KAaSpKfCSJRc4=
Received: from DM5PR15MB1290.namprd15.prod.outlook.com (10.173.212.17) by
 DM5PR15MB1564.namprd15.prod.outlook.com (10.173.224.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 16 Aug 2019 12:45:16 +0000
Received: from DM5PR15MB1290.namprd15.prod.outlook.com
 ([fe80::4d32:13fc:cf5b:4746]) by DM5PR15MB1290.namprd15.prod.outlook.com
 ([fe80::4d32:13fc:cf5b:4746%7]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 12:45:16 +0000
From:   Chris Mason <clm@fb.com>
To:     Andy Grover <andy@groveronline.com>
CC:     Gerd Rausch <gerd.rausch@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Grover <andy.grover@oracle.com>,
        "Chris Mason" <chris.mason@oracle.com>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
Thread-Topic: linux-next: Signed-off-by missing for commits in the net-next
 tree
Thread-Index: AQHVU7P27NIdzAZTxUKiE+QIk9wPN6b8w9mAgAC7AgCAADqgAA==
Date:   Fri, 16 Aug 2019 12:45:16 +0000
Message-ID: <4265F394-B37F-43C1-85F7-15D2C030FF82@fb.com>
References: <20190816075312.64959223@canb.auug.org.au>
 <8fd20efa-8e3d-eca2-8adf-897428a2f9ad@oracle.com>
 <e85146f3-93a0-b23f-6a6e-11e42815946d@groveronline.com>
In-Reply-To: <e85146f3-93a0-b23f-6a6e-11e42815946d@groveronline.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: MailMate (1.12.5r5635)
x-clientproxiedby: BN6PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:405:3b::49) To DM5PR15MB1290.namprd15.prod.outlook.com
 (2603:10b6:3:b8::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:480::4aa3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54cf84ec-2854-433c-3cfd-08d7224796a9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1564;
x-ms-traffictypediagnostic: DM5PR15MB1564:
x-microsoft-antispam-prvs: <DM5PR15MB156430F05F608331BF35DE20D3AF0@DM5PR15MB1564.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(376002)(366004)(39860400002)(189003)(199004)(256004)(186003)(53936002)(14444005)(33656002)(71190400001)(25786009)(71200400001)(6116002)(4326008)(6246003)(4744005)(86362001)(2906002)(36756003)(229853002)(99286004)(6916009)(6486002)(8936002)(66446008)(66556008)(66476007)(53546011)(102836004)(50226002)(6506007)(386003)(8676002)(81166006)(81156014)(14454004)(66946007)(305945005)(7736002)(486006)(476003)(2616005)(5660300002)(316002)(11346002)(46003)(6512007)(54906003)(446003)(478600001)(52116002)(76176011)(64756008)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1564;H:DM5PR15MB1290.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nBeQPWXSh+YLep5ji57ZKZ/z/m2rdH/+j7AUCgDKFL8BpZiiuMy++Tp15srcTtaN0foy8Ngg0z5nDTqTHL4CPnq/0JO2okGfxymknOSTlbTOlod1eOuW9yxt2ybaKNG1hMVj98XcQ0krlW3kogTkXrBJ7oPJd/NbvYaLyZL+tUkcVtKBivzjlJs1+h/NGE0bMLnSR+vOdp7z00bJng8FnXvoykDrxpVIvasXY9lc6ET3F1wQGujMTJEEsQ51pTfzVBgiko69NxL73waZqYgWf4Pi9P0MDHONA0pBZjpGSqSYJqWTvzBNZmteV99ZBGX/m/Mg7Uz39FfLhplAOmC49KSmxxqJne4HqO2wt1HjT1atLV1RZ5HASIFWVALzmiJ3HmPEnImwpTKiPi5+xHaaQdxqyyvpRVYLQMLf5IJMJXc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cf84ec-2854-433c-3cfd-08d7224796a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 12:45:16.5079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: USL43fF04FjN0OaLqXrTExkWYIkWXXXMZjCyQSJsTcDipDTPuHTevF2L2suVf4s4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1564
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160130
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16 Aug 2019, at 5:15, Andy Grover wrote:

> On 8/16/19 3:06 PM, Gerd Rausch wrote:
>> Hi,
>>
>> Just added the e-mail addresses I found using a simple "google=20
>> search",
>> in order to reach out to the original authors of these commits:
>> Chris Mason and Andy Grover.
>>
>> I'm hoping they still remember their work from 7-8 years ago.
>
> Yes looks like what I was working on. What did you need from me? It's
> too late to amend the commitlogs...

Same question ;)  The missing signed-off-by is a mistake, but from the=20
point of view of the DCO, these patches are totally fine by me.

-chris
