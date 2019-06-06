Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 385AD37904
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 17:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfFFP5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 11:57:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47238 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729165AbfFFP5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 11:57:45 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56Fql8s015370;
        Thu, 6 Jun 2019 08:57:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WPRjPadkciujUXvvkMr8e21baC3JQsnVvZD5I/AUh34=;
 b=Rs56/fSiLCdDjHvb68OFFZ5xt3OI/GOxyshDTZ/7capI7qT4HpjPhV/jGkuo+dKpxUSJ
 RFCwBFiaqvER+ueCeniTIidZVaYMZQ2+zB0YTwG5Q1gQLrmlECZ45Y1ZECIZrd4Qwf7U
 3DCuDD42fJunLTchbVN4D0PvxFN8D5JyK3Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sxsmr2e8b-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 06 Jun 2019 08:57:21 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 08:57:20 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 08:57:20 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Jun 2019 08:57:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPRjPadkciujUXvvkMr8e21baC3JQsnVvZD5I/AUh34=;
 b=dgKuVZrvha7KX4Z9X67Oo6veX6ayhvl73OY1IV466CVSOTJ9dHDF6aKDZAzBj1Hg+QcdkG34CmEjDWWXxYmUZ2NSfylXmF84TK48V5pnq8XBgcHh+qQRX9jCliDfe7XIMxIDg5O3WI/Qk0SANm9qHM1YYRosBAKNnw/dUWAQr38=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1728.namprd15.prod.outlook.com (10.174.254.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 15:57:18 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Thu, 6 Jun 2019
 15:57:18 +0000
From:   Martin Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "Andrey Ignatov" <rdna@fb.com>, "m@lambda.lt" <m@lambda.lt>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf v2 0/4] Fix unconnected bpf cgroup hooks
Thread-Topic: [PATCH bpf v2 0/4] Fix unconnected bpf cgroup hooks
Thread-Index: AQHVHHUuaWSShmAwL0eAUhYynE5lcqaOyBqA
Date:   Thu, 6 Jun 2019 15:57:18 +0000
Message-ID: <20190606155715.gxxbr7f4odxv4zxb@kafai-mbp.dhcp.thefacebook.com>
References: <20190606143517.25710-1-daniel@iogearbox.net>
In-Reply-To: <20190606143517.25710-1-daniel@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::35) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:5827]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e701fc3-b87e-421e-41e3-08d6ea97a6c5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1728;
x-ms-traffictypediagnostic: MWHPR15MB1728:
x-microsoft-antispam-prvs: <MWHPR15MB17289E509013CADF2ADDF582D5170@MWHPR15MB1728.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(4744005)(81166006)(7736002)(8936002)(6512007)(5660300002)(71190400001)(1076003)(6486002)(8676002)(52116002)(6116002)(99286004)(486006)(2906002)(4326008)(76176011)(71200400001)(305945005)(476003)(14444005)(11346002)(6916009)(102836004)(446003)(6506007)(386003)(46003)(186003)(478600001)(256004)(68736007)(561944003)(53936002)(9686003)(64756008)(81156014)(6246003)(25786009)(316002)(229853002)(86362001)(66476007)(54906003)(66556008)(66946007)(14454004)(6436002)(66446008)(73956011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1728;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: locX88bMSHfisJkzUUhpJDzpJHu9hB3rHtoR7xjbpZHucyENdO8KprUmNiexB8zObqBuroc0wdsT1erW/1GZqHewse6gqQV/4k2e5fwwDF1nVF7jyM9BBCCUFKcZhZ5j51b2JpuI9shYbTc6j9LknnDTMvIbhhPer0e4KaeMp2NywVxXAt9szvCYfInrYguojRjy4w5VV2P4wUk8Gd8RpmaJfkokej+G7uC8azYjqPq7OTR59/PYOgneZ/g7VA7ajTZ16XGxbaO87sTKMbCN6jpbMZUWP5gY7LxNGcZd26SeZIarSfGlzZp9OGas+PuwzzTyGEn4F6VP0hp1s6FKBwDftWCUFefEHC+hu4f0fYpidQ+1DutMj6vHmKFNe8XPISRFVliUWfkvOE22PZry4uwATsbBsKMp/DB2k7DNHq0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <822A7FA3A73517458604B4BEEF462A39@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e701fc3-b87e-421e-41e3-08d6ea97a6c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 15:57:18.2113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1728
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=593 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060108
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 04:35:13PM +0200, Daniel Borkmann wrote:
> Please refer to the patch 1/4 as the main patch with the details
> on the current sendmsg hook API limitations and proposal to fix
> it in order to work with basic applications like DNS. Remaining
> patches are the usual uapi and tooling updates as well as test
> cases. Thanks a lot!
Acked-by: Martin KaFai Lau <kafai@fb.com>
