Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FDF3BEEE
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbfFJVvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:51:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52850 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726556AbfFJVvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:51:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5ALlXIo006078;
        Mon, 10 Jun 2019 14:50:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8jKe2IqRPEFLjRBIF9QPyAzp+i2b8q3PqJZHKnm4SJM=;
 b=No/trT/bLNHjYUtZ6TSTjq+KDvm06+sl30p2B0iC0ooUFgzrHKgE3BNmY6/ohTvdiQFt
 SqaszQjRwtfbrLEIywnYfbqnMYkUp6hvqDZfpbbK6fB3sw9IK7cFBSgkNBjcOaG3R2C9
 YUuhbzp6HtcNJGeo8MLy0SuPP3/VZ+ntpAg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t1njwjjpt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 10 Jun 2019 14:50:25 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Jun 2019 14:50:24 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Jun 2019 14:50:24 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 10 Jun 2019 14:50:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jKe2IqRPEFLjRBIF9QPyAzp+i2b8q3PqJZHKnm4SJM=;
 b=HflaQeTxbF1rnipGPdorGoKAo87FOAGa81q6G4km7VT11TypifsTgVv+v0G0E5UjFBZzoYCaRZNvVewN3BUHqpMX0oGPkvznX07eDm9kgd2/ZeWkZVHqzqlIbbjPd+5i8/09yZ4QzANi88SJYHSqovz/hDF512B3291O6TC+TYY=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1439.namprd15.prod.outlook.com (10.173.235.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Mon, 10 Jun 2019 21:50:23 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 21:50:23 +0000
From:   Martin Lau <kafai@fb.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v3 0/2] ipv6: Fix listing and flushing of cached route
 exceptions
Thread-Topic: [PATCH net v3 0/2] ipv6: Fix listing and flushing of cached
 route exceptions
Thread-Index: AQHVHiW7EB+fm/k9V0qJI3aslTUcg6aVbUgAgAADawA=
Date:   Mon, 10 Jun 2019 21:50:23 +0000
Message-ID: <20190610215020.tkctmgxus6xx32ke@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1560016091.git.sbrivio@redhat.com>
 <37a62d04-0285-f6de-84b5-e1592c31a913@gmail.com>
In-Reply-To: <37a62d04-0285-f6de-84b5-e1592c31a913@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0032.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::45) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:4395]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57236448-b4ac-4db3-b633-08d6ededa3b3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1439;
x-ms-traffictypediagnostic: MWHPR15MB1439:
x-microsoft-antispam-prvs: <MWHPR15MB1439729BC197BEAB4A6AA365D5130@MWHPR15MB1439.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(366004)(396003)(346002)(189003)(199004)(53936002)(73956011)(66946007)(25786009)(71190400001)(478600001)(9686003)(86362001)(6246003)(4326008)(6512007)(54906003)(66556008)(64756008)(2906002)(14454004)(71200400001)(1411001)(305945005)(7736002)(66476007)(66446008)(316002)(8936002)(81156014)(81166006)(76176011)(256004)(52116002)(476003)(5660300002)(8676002)(6116002)(446003)(1076003)(6916009)(11346002)(6486002)(99286004)(6506007)(186003)(102836004)(229853002)(6436002)(486006)(4744005)(46003)(386003)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1439;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IFTNS2UDnFtp+VdZNhMqxZtxq91vTKljEo88SxbTef4nAPUY4AMOev3qtXoDROSbFUpf0A2AQ0BU3QvBTVfKR0dLdxO2I8x+ypQyH6CFY1H1TnY80q3dwGmxPloVm1N+rkBw55Z31efIV7c+q9KyDZR17J+NbkZBT8O3HCEEki0/R7hLQLGXsVHKLb0eIzLWDAy6JWjRVGCmaNdDsbaeyAUsLLvIHnhYPsbvnjmoiTgFmrKPsxVHj5fvREFSj4NlwK0bNNhSlM+maa5Bg4esfboUKe+RGHN1RcZM/5nBnyVieH290ljb8lWl/8uTFyEHRJDf45WbK0B30yjuFBo9swZbqCc+9TKAW73gssOTab4AV2mT6Wl5WYOJq9L2g880PQqhx6E3GUsREA4Fmz0zUGYGtq1oeID7oOc/bkiv0fU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EE66971770973545950269F0049EC57B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 57236448-b4ac-4db3-b633-08d6ededa3b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 21:50:23.2442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1439
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-10_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=573 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 03:38:06PM -0600, David Ahern wrote:
> The ability to list exceptions was deleted 2 years ago with 4.15. So far
> no one has complained that exceptions do not show up in route dumps.
> Rather than perturb the system again and worse with different behaviors,
> in dot releases of stable trees, I think it would be better to converge
> on consistent behavior between v4 and v6. By that I mean without the
> CLONED flag, no exceptions are returned (default FIB dump). With the
> CLONED flag only exceptions are returned.
+1
