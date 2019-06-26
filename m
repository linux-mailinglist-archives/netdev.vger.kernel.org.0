Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D86A56E69
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfFZQLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:11:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22014 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725958AbfFZQLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:11:09 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5QG6cOc013714;
        Wed, 26 Jun 2019 09:10:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ooJa41z/jS049P7woVJSwgqKq63oCaBJ0uNKU12MvNk=;
 b=R40LjjDU0hS8Ci2qoBobXYnPyXFCgOn2E8ACVW//3ADSBemCb43Mcan2LW8Ae3ArO0Bv
 tk+VZmKMox6Rd9GN950hK0vgY230cbul/cdyp7JrC8Xs/8YByV24Tn7We7dWj6YnOymN
 VVckxwk0T8Pc8rB+hYb3ozysncapE7RwesA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2tbpv84but-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 09:10:45 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 26 Jun 2019 09:10:27 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 26 Jun 2019 09:10:26 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Jun 2019 09:10:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooJa41z/jS049P7woVJSwgqKq63oCaBJ0uNKU12MvNk=;
 b=Mc9Hxvkh0/preuS8NV3aW6ykIXKRJ8rXPsVjqOWAGbea78lv5IBcMmz0lpIh9k77Y6eWrcqmKyEtfiLELwJFWXfXfRQs6Xol82q5tJYNJFnTgievbNEt+yP711o30QlY+tij/OQhNRqMxmIo3Er1AT9ySMM+Rge3df1/XUs9unQ=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1405.namprd15.prod.outlook.com (10.173.233.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Wed, 26 Jun 2019 16:10:25 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 16:10:25 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Index: AQHVK4MfT15tn2gAREGxInrd8zK0eaat87oAgAAaNQCAAAIbAIAADEIA
Date:   Wed, 26 Jun 2019 16:10:25 +0000
Message-ID: <68BB91E5-B70C-4640-9550-8CAB62E5F6C6@fb.com>
References: <20190625182303.874270-1-songliubraving@fb.com>
 <20190625182303.874270-2-songliubraving@fb.com>
 <CACAyw99isFcFhnrmagmzPPR1vNGqcmDU+Pq7SWeeZV8RSpeBug@mail.gmail.com>
 <3AE4213C-9DFA-407F-B8D4-DB00950E577D@fb.com>
 <CACAyw9-MAXOsAz7DnCBq+32yc575TEiwm_6P-3KWKmZWmAqUfg@mail.gmail.com>
In-Reply-To: <CACAyw9-MAXOsAz7DnCBq+32yc575TEiwm_6P-3KWKmZWmAqUfg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6898]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1065a19a-480d-4cc1-68f6-08d6fa50cc7f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1405;
x-ms-traffictypediagnostic: MWHPR15MB1405:
x-microsoft-antispam-prvs: <MWHPR15MB14056140181A73BC31D03DE8B3E20@MWHPR15MB1405.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(376002)(39860400002)(346002)(199004)(189003)(76176011)(478600001)(99286004)(81166006)(6506007)(81156014)(53546011)(102836004)(186003)(57306001)(8676002)(2906002)(256004)(14454004)(4744005)(7736002)(6116002)(6916009)(305945005)(86362001)(5660300002)(8936002)(53936002)(66946007)(6486002)(73956011)(316002)(76116006)(6512007)(446003)(68736007)(33656002)(486006)(476003)(2616005)(229853002)(4326008)(71200400001)(71190400001)(50226002)(36756003)(64756008)(66556008)(66446008)(66476007)(25786009)(46003)(54906003)(6436002)(6246003)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1405;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HC+wx+5DBpQtjz6SY94N4IqBFjrr3EjiPa5FLignWtIYz4X+mnf24VsX+yzQJh1kUN/Fyk0UlilyyIBFBpEPJs3YOyS9Dd+0dBOq/PMpoLil5TUvMcnh60B11BDnIIM0tNPkkIothHUteHJQQakVMYrUdXySSrLZM8EFNeuxyEz97m8Tar7wdZh/e13QuQ30bI9Y2aRSMieTd3t6UrwFLM3BcNGR5d1B9uPQJLaq0+znu65tqidFixOZHsx3X2nTCi9dPn4Q5WKh2Ias9gYxRd28MriQKetSAwH/4i8jjFrMnD4+vk23vttbyiivQJgn+WTcbEABbzs1tauoYfsySZ84RWKNv9mJ6vAm8r5KHvwfrfCURi6+fRslK4lxzmxQiuQ9Kw+splImGuplcVDadstRd4u72vATAgH/IvwTJHY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1395DC8E03F13B4EB8D881A20708B6CA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1065a19a-480d-4cc1-68f6-08d6fa50cc7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 16:10:25.3582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1405
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=881 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2019, at 8:26 AM, Lorenz Bauer <lmb@cloudflare.com> wrote:
>=20
> On Wed, 26 Jun 2019 at 16:19, Song Liu <songliubraving@fb.com> wrote:
>>> I know nothing about the scheduler, so pardon my ignorance. Does
>>> TASK_BPF_FLAG_PERMITTED apply per user-space process, or per thread?
>>=20
>> It is per thread. clone() also clears the bit. I will make it more
>> clear int the commit log.
>=20
> In that case this is going to be very hard if not impossible to use
> from languages that
> don't allow controlling threads, aka Go. I'm sure there are other
> examples as well.
>=20
> Is it possible to make this per-process instead?

We can probably use CLONE_THREAD flag to differentiate clone() and=20
fork(). I need to read it more carefully to determine whether this is=20
accurate and safe.=20

Thanks,
Song
