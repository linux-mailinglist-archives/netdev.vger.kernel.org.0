Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1AA46BCB
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfFNVVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:21:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43532 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbfFNVVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 17:21:36 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5ELHrOs005779;
        Fri, 14 Jun 2019 14:20:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kN+TIvxIvsY+ujmB+32Te6EgisXyyxEvtgu16EoVV/w=;
 b=VBBVbX75zkfQNxMFtvCDAEDiDJD/Q4/HAZKb4bm77rjD2ktVYEfqCDVGMV06efigK6yt
 /s/8B7sC8pyo4xFJjg6O4L0+2+jTSfA2/vtxDPQMkcir4hmQcRVg7MNbaWuZxIz8HY5G
 cFrsggClASTg/Cce75W1eYLh/IE7+1F39hI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t4euus0mn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 Jun 2019 14:20:18 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 14 Jun 2019 14:20:16 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 14 Jun 2019 14:20:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kN+TIvxIvsY+ujmB+32Te6EgisXyyxEvtgu16EoVV/w=;
 b=Gm288nW4JOfnItRbjeP07Yzu+L19IkJ6kq3sjV4FiwjF93T9Fg/k4/ew/RRtqmW0fuXcYUJJBeVzeIBh0TffrdJ2CgCQ3bJd5sH6HpeqNpBC8wFm3r/PDkC3KMq386lVEa5Xvl3v0LdQzLZ+HZ4jSU3F01/8VCumnCZ2RDdNLvM=
Received: from DM5PR15MB1163.namprd15.prod.outlook.com (10.173.215.141) by
 DM5PR15MB1225.namprd15.prod.outlook.com (10.173.214.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Fri, 14 Jun 2019 21:20:15 +0000
Received: from DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::38aa:95ca:d50f:9745]) by DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::38aa:95ca:d50f:9745%3]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 21:20:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Kairui Song <kasong@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 1/5] perf/x86: Always store regs->ip in
 perf_callchain_kernel()
Thread-Topic: [PATCH v2 1/5] perf/x86: Always store regs->ip in
 perf_callchain_kernel()
Thread-Index: AQHVItsdAJpQ0uR78USgIdN7QwfW8aaboX+AgAAC0ICAAALTgIAAARKA
Date:   Fri, 14 Jun 2019 21:20:15 +0000
Message-ID: <64A24F81-6844-442D-9FA5-DE1835C70529@fb.com>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <81b0cdc5aa276dac315a0536df384cc82da86243.1560534694.git.jpoimboe@redhat.com>
 <20190614205614.zr6awljx3qdg2fnb@ast-mbp.dhcp.thefacebook.com>
 <20190614210619.su5cr55eah5ks7ur@treble>
 <20190614171625.470c9e3e@gandalf.local.home>
In-Reply-To: <20190614171625.470c9e3e@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [199.201.64.135]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28dd6e06-0a22-49f2-05fd-08d6f10e184c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1225;
x-ms-traffictypediagnostic: DM5PR15MB1225:
x-microsoft-antispam-prvs: <DM5PR15MB1225C8711E82F6695765D56FB3EE0@DM5PR15MB1225.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(86362001)(186003)(7736002)(476003)(486006)(2616005)(6486002)(26005)(6506007)(305945005)(6436002)(53936002)(229853002)(53546011)(66066001)(76176011)(36756003)(446003)(57306001)(99286004)(102836004)(81166006)(81156014)(8936002)(50226002)(8676002)(11346002)(6916009)(316002)(4744005)(68736007)(256004)(7416002)(2906002)(5660300002)(4326008)(6512007)(73956011)(25786009)(66446008)(64756008)(91956017)(6246003)(14454004)(71200400001)(3846002)(54906003)(6116002)(478600001)(71190400001)(76116006)(33656002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1225;H:DM5PR15MB1163.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: u6wac68xdEL615bPGyzEvwANMmfeNJ+KYgjCbnud1h0qQKERpfrKWMiw49MSA1qfj5ylbjbyHTlTyzmM1Jsy7ISpa0/nW1wb2iyD1Bbdc8s17hhkJmbLyGZRu6A0f6MXPZ3TTynp+LVc+NgUo98EC6M+dwZnfDPooQLHI5vBUq9XvlmHjf3rS+r+A3bwLcm+FCD+cgQxugjTgJDJo6mEH+kUf1RsTOLpvoX5b7miBtaAmTk17D6mVXo+1xaJ8cOod1ITzT1nCVgr0V0r3RDlfbGShD6A9YklzrxlQ1WNNgFWML5THh75f3uR/7IZaX1pQNERMg55yTnnt2fW1v53LMZldr3N0mn+u/rjtRhe2x67ostMR3obBoBlh7UR4tI3kprwRD1lO6z9XpOEBhY9BaHRNuxCnZY4MXpjiOD4Q2Y=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2AFB23BE2CE0C343A8276D2C01EBBB5F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 28dd6e06-0a22-49f2-05fd-08d6f10e184c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 21:20:15.7604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1225
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=782 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 14, 2019, at 2:16 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> On Fri, 14 Jun 2019 16:06:19 -0500
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>=20
>>> It's not cool to remove people's SOB.
>>> It's Song's patch. His should be first and your second. =20
>>=20
>> His original patch didn't have an SOB.  I preserved the "From" field.
>=20
> Then it can't be accepted. It needs an SOB from the original author.
>=20
> Song, Please reply with a Signed-off-by tag.
>=20
> Thanks!
>=20
> -- Steve

Yes, Sir!

Signed-off-by: Song Liu <songliubraving@fb.com>

It was my fault to forget it in the first place. Sorry for the confusion.

Song
