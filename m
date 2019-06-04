Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0336B34FA4
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfFDSNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:13:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33100 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbfFDSNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 14:13:09 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x54I3wIS016132;
        Tue, 4 Jun 2019 11:12:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8uvNnfy2bAzrVqsBVKUNHDe3Smh4uKYS9FPNPiJhmV8=;
 b=Tcwb2goRzCXr8ifr+vI1p69fDQiACaPaCHIZo/PS+e9LID1vPEJM/ygJBSg5R5tILhFW
 y+KqiXTSle62b5g/GCsr92QwsT1fG16zSewyD14L0qGvU+qBZQaUm0C2kv1zV/d8XaUL
 Qk3dLicqphRL6ZKpPTUawze7FYxnZk36SBc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2swsm5s0g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 04 Jun 2019 11:12:09 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 4 Jun 2019 11:12:08 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 4 Jun 2019 11:12:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uvNnfy2bAzrVqsBVKUNHDe3Smh4uKYS9FPNPiJhmV8=;
 b=XX+JuMYe5qhfV6gYbrxjztUOGJTsG1gEAusByvjupt6k62elXuGQgwCRBIJ8ah5fDoYw8qFo7pME0KJzT3b/PcNXTDcYQxy5QQt6eTS/WkaSk5qs2jDc1PyTPPYfdP/KZhZ24lD4EdWcKRAr/1FZU356rqEYZEXDi0VRhpBX73o=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1422.namprd15.prod.outlook.com (10.173.234.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Tue, 4 Jun 2019 18:12:06 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 18:12:06 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Thread-Topic: [PATCH v4 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Thread-Index: AQHVGirjcI+VnO6fB0unGrU2EDRHT6aLtNUAgAAL0ICAAA0JAA==
Date:   Tue, 4 Jun 2019 18:12:06 +0000
Message-ID: <20190604181202.bose7inhbhfgb2rc@kafai-mbp.dhcp.thefacebook.com>
References: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
 <20190603163852.2535150-2-jonathan.lemon@gmail.com>
 <20190604184306.362d9d8e@carbon>
 <87399C88-4388-4857-AD77-E98527DEFDA4@gmail.com>
In-Reply-To: <87399C88-4388-4857-AD77-E98527DEFDA4@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0070.namprd21.prod.outlook.com
 (2603:10b6:300:db::32) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:9b09]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2770448-3ffb-48c4-31b0-08d6e918269f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1422;
x-ms-traffictypediagnostic: MWHPR15MB1422:
x-microsoft-antispam-prvs: <MWHPR15MB14223B9801C433EBC1552E89D5150@MWHPR15MB1422.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(39860400002)(346002)(366004)(53434003)(199004)(189003)(52116002)(1076003)(8936002)(68736007)(256004)(76176011)(6486002)(6512007)(9686003)(46003)(476003)(316002)(71190400001)(71200400001)(386003)(99286004)(305945005)(102836004)(54906003)(186003)(478600001)(6506007)(53546011)(6436002)(229853002)(14454004)(73956011)(5660300002)(66476007)(66556008)(64756008)(14444005)(6246003)(4326008)(66946007)(25786009)(2906002)(6916009)(11346002)(81166006)(81156014)(7736002)(6116002)(446003)(8676002)(486006)(53936002)(86362001)(66446008)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1422;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1FMA9QnW0PRN6M4MeHP6guj2JHyGqXMKQL80TEbRHcRW4FP0Q1kVPi+9xEepoduy2375A4cKuRl4vvsnGTGqAZ7Bkb6dbV3F8HcURFdjZGotPiH3TKOeOKSIR1TVJNpiceRFTIw8Yk+DIlA9mYMS2ZZ5RTX222jZiIMsinhork7BQBVwSK1prOWazLhhGRYHzuSyoIKBTv83a+qE1iO8205j+JHVwjjDH4rEnrw2t0tbZMeOx6RxIllckJ1+4mSQavTBfuG+3T+LYTwa8q9Ub9EZHrlryy2v6qSUcizFK6Dm5wksYgaR050XE5MVczu76Ob/Sln30wKVMFRcZUdfe9hkVn9K8RVjJovdZfLvd8iEGPhzIXODCmBY3NX96btRThZHojPw8fDY37fw1P8tvGhMkU876BxQoKbYhuU9xP4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F5ADF45A9EC8334E84B41BBC8F752842@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e2770448-3ffb-48c4-31b0-08d6e918269f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 18:12:06.2723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1422
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=891 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040115
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 10:25:23AM -0700, Jonathan Lemon wrote:
> On 4 Jun 2019, at 9:43, Jesper Dangaard Brouer wrote:
>=20
> > On Mon, 3 Jun 2019 09:38:51 -0700
> > Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> >> Currently, the AF_XDP code uses a separate map in order to
> >> determine if an xsk is bound to a queue.  Instead of doing this,
> >> have bpf_map_lookup_elem() return the queue_id, as a way of
> >> indicating that there is a valid entry at the map index.
> >
> > Just a reminder, that once we choose a return value, there the
> > queue_id, then it basically becomes UAPI, and we cannot change it.
>=20
> Yes - Alexei initially wanted to return the sk_cookie instead, but
> that's 64 bits and opens up a whole other can of worms.
>=20
>=20
> > Can we somehow use BTF to allow us to extend this later?
> >
> > I was also going to point out that, you cannot return a direct pointer
> > to queue_id, as BPF-prog side can modify this... but Daniel already
> > pointed this out.
>=20
> So, I see three solutions here (for this and Toke's patchset also,
> which is encountering the same problem).
>=20
> 1) add a scratch register (Toke's approach)
> 2) add a PTR_TO_<type>, which has the access checked.  This is the most
>    flexible approach, but does seem a bit overkill at the moment.
I think it would be nice and more extensible to have PTR_TO_xxx.
It could start with the existing PTR_TO_SOCKET

or starting with a new PTR_TO_XDP_SOCK from the beginning is also fine.

> 3) add another helper function, say, bpf_map_elem_present() which just
>    returns a boolean value indicating whether there is a valid map entry
>    or not.
>=20
> I was starting to do 2), but wanted to get some more feedback first.
> --=20
> Jonathan
