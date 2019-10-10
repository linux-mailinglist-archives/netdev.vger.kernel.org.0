Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59DE5D317E
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfJJTlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:41:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19006 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbfJJTlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 15:41:35 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9AJN94J018950;
        Thu, 10 Oct 2019 12:41:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gfb9DcpaUgRvCEEx3YN/u2yAyUy6y7YkLaFNtQMsWIk=;
 b=h79+FdXh4nOgLusRGJyN2o/S51V+1HcTNS4wTg6LpDOyB20YjLv6H7AlCHdqlNLFQlq3
 JpS6Op0c21Ac1lUMycaIYYp+Mqyqn2iRcp53DzyZ1FnSNeKWX50FIJESTaCLNmbKNwPG
 5P4wl3wODonJafMMLpkuuSp2EMESIcYIX0M= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vj7wy9ht8-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Oct 2019 12:41:32 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 10 Oct 2019 12:41:32 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 10 Oct 2019 12:41:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FW+zfkoC+DQSDX5rWiLYzjuCpJoki0v46xoY2TC6XNyUfU64V4FngHrquFZ+ayCZKSwYPsz7PvBi7LkXwL04lUI241oxU0s97OwFtteWfX1IzSJfg6vhs3Ya9M42cMM+MjP3FK+CNnFTwNqGzBRsGsjJJOUFjbijt2tvRQihqLSVgyQE++hWUKwJ/aOBKs8H357WPJWuKStz3SGwfdJtSntIg32x6Zv+xAMSwZw9X6Z+OntE0qGSJOJnmXSsd0R3FJY81+QPIyv3xoyHkKyyNWRQ7zgPhYFVH/prGWobRhZkvUhcIhGhNqxab/X6u4WibS29pv8L182zFAY5rGWwEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfb9DcpaUgRvCEEx3YN/u2yAyUy6y7YkLaFNtQMsWIk=;
 b=Eq7qCu0TCZjAc8boXLYPUGKAcm0SfixnNOwBp84ORxlO6XxmhCfTbwYClnCIxUae0/vpT+TsUV8qvUfLTYk0R+igyX4WPMV1E0uF6+oFKS2VmKcAKrSECqheJ+ZIH1HvEBvUAokk/BxklfyD8idEjBVXZye7UwkfjgMBIPi+vmcqhCziF8IIT0caTsad4PPB2fqfkIeiQIw98BfnSQfmdtKBsP2QHJYieZ3qpb7/McV/PKvvBqVdEEHnEXRskMaZkfiDdwygJbdBpWIzo+nDa+YZkE38qbZ+L2ahvuOKYbCTKylKcodPtMzSC1whaKg+kTgxiUP+8JFbMdWMne5Z5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfb9DcpaUgRvCEEx3YN/u2yAyUy6y7YkLaFNtQMsWIk=;
 b=a1/00C+3Lw4DbSCapc1QJTNb9rBXXMoHK3zz2cpSq0zDQRnkeWGUds1PbmGVl5P8jMv0sRQqP7+S0DAljN+zdeicCEKdR0R6WuM+ARIjpu/20B/eIYPuEz5y+zykE5MGxbOBgvUXmzec3ku2z4svOgBGX+r+53nYHsJ+FWKkU/M=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3389.namprd15.prod.outlook.com (20.179.21.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 19:41:31 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 19:41:31 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [PATCH bpf-next v2 1/2] flow_dissector: Allow updating the flow
 dissector program atomically
Thread-Topic: [PATCH bpf-next v2 1/2] flow_dissector: Allow updating the flow
 dissector program atomically
Thread-Index: AQHVf5cVR/+HF2RrME+60egdLlLNFadURjuA
Date:   Thu, 10 Oct 2019 19:41:30 +0000
Message-ID: <20191010194127.h3j5jmqbspj4ewgt@kafai-mbp.dhcp.thefacebook.com>
References: <20191010181750.5964-1-jakub@cloudflare.com>
 <20191010181750.5964-2-jakub@cloudflare.com>
In-Reply-To: <20191010181750.5964-2-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0100.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::41) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::f49f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1b8f315-a794-40a4-507f-08d74db9d963
x-ms-traffictypediagnostic: MN2PR15MB3389:
x-microsoft-antispam-prvs: <MN2PR15MB33893922264B4903176D88E9D5940@MN2PR15MB3389.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(396003)(136003)(39860400002)(189003)(199004)(14454004)(66946007)(478600001)(64756008)(66446008)(5024004)(14444005)(256004)(66476007)(66556008)(6116002)(186003)(446003)(46003)(11346002)(229853002)(81166006)(8936002)(8676002)(71190400001)(86362001)(71200400001)(81156014)(486006)(476003)(7736002)(6916009)(1076003)(4326008)(52116002)(25786009)(6506007)(386003)(102836004)(6486002)(99286004)(6436002)(2906002)(5660300002)(4744005)(6246003)(76176011)(9686003)(316002)(305945005)(54906003)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3389;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8AdMUSXvHizG+pPBMzzeWelj2sPIMbOaHcBmJi6U54x2lK8JYhaytzwu6L42HmLMDZn1uy22BTTcakUqJ1p0RewsvL4ipyv7E93OWCfXNYWUdu/GQEdTea9Kd9UIYOecdjaZw3x3BQhsbYJlm8DLRHFANhhD1Mtj+IgMzdojq2R0KQlGZR0FIkDa6WrTW8ojRRXuQFM9JX+kbg3qDO9tkVKdU2FUGI94cbvEDr3kpL+tdsKYRQ4C1c0AlzIXmySo0t101zhPQ6dAsBIk8D/htkuxRXgIHSPNbXi1y7NjPOK1CGVCYXGCygpR0rgGZJGV3ejnU3ac14AoskiTnHke1EYfVOUnX1pY1rolYMckk2xFf58JIv1N5DvFLqGfnML4xSpxboJAxhRdTRyBM5jQhGNPIh+zSXD6JO+lW7rxo8M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <925B8F3E9672B547882629D7D799A821@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b8f315-a794-40a4-507f-08d74db9d963
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 19:41:30.9876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5x3vNwH8eSEzh3WC+OZFBdf4iaGj8LzsrffTpyco+Kb3oVFwaCKxERIaYOYaYssB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3389
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_06:2019-10-10,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=672
 mlxscore=0 priorityscore=1501 impostorscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 clxscore=1011 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 08:17:49PM +0200, Jakub Sitnicki wrote:
> It is currently not possible to detach the flow dissector program and
> attach a new one in an atomic fashion, that is with a single syscall.
> Attempts to do so will be met with EEXIST error.
>=20
> This makes updates to flow dissector program hard. Traffic steering that
> relies on BPF-powered flow dissection gets disrupted while old program ha=
s
> been already detached but the new one has not been attached yet.
>=20
> There is also a window of opportunity to attach a flow dissector to a
> non-root namespace while updating the root flow dissector, thus blocking
> the update.
>=20
> Lastly, the behavior is inconsistent with cgroup BPF programs, which can =
be
> replaced with a single bpf(BPF_PROG_ATTACH, ...) syscall without any
> restrictions.
>=20
> Allow attaching a new flow dissector program when another one is already
> present with a restriction that it can't be the same program.
Acked-by: Martin KaFai Lau <kafai@fb.com>
