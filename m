Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985F156D7C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfFZPT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:19:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19898 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfFZPT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:19:27 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QF9Nwj015445;
        Wed, 26 Jun 2019 08:19:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kA47rDa59tZPECD8+L8HNRMX9PH9mbEt75L9WaAiLaI=;
 b=H0wNpgDcoMdBiFjnzMvFNJ/IkhuQUIUlnHrSN0zVA3utIlTcyosQiYCfIQX9qbjYRiW8
 +GibkYW6/zoi9yEUINALQYX9ivG8eH4hcGtDFsLcPdHO2HRVq9kUpeJRg9KP/NhsbpGb
 oYMW9oS3VcRj+K6vr78My9A0PCl/gxSTfpw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tc9t88bcm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 08:19:04 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 26 Jun 2019 08:19:02 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 26 Jun 2019 08:19:02 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Jun 2019 08:19:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kA47rDa59tZPECD8+L8HNRMX9PH9mbEt75L9WaAiLaI=;
 b=VcVX/KYTD4cLnR0dCNNzY48Lu0JhBfWSMCYmlaC5EhCkd/DTZ3tqSB3T8FTGhzHDWbAtRl2lkxOXxPrKGAjHiEUv/zonpiX8eY5qUiEvTFQonZtOyojXxqgzuOf+TUZfpsJSen9ygy6kKFoy4ztt+1N7CekEdMxbfZIJnSMeUMw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1277.namprd15.prod.outlook.com (10.175.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 15:19:00 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 15:19:00 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Index: AQHVK4MfT15tn2gAREGxInrd8zK0eaat87oAgAAaNQA=
Date:   Wed, 26 Jun 2019 15:19:00 +0000
Message-ID: <3AE4213C-9DFA-407F-B8D4-DB00950E577D@fb.com>
References: <20190625182303.874270-1-songliubraving@fb.com>
 <20190625182303.874270-2-songliubraving@fb.com>
 <CACAyw99isFcFhnrmagmzPPR1vNGqcmDU+Pq7SWeeZV8RSpeBug@mail.gmail.com>
In-Reply-To: <CACAyw99isFcFhnrmagmzPPR1vNGqcmDU+Pq7SWeeZV8RSpeBug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6898]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc841f6c-7b6f-47f0-0c55-08d6fa499df6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1277;
x-ms-traffictypediagnostic: MWHPR15MB1277:
x-microsoft-antispam-prvs: <MWHPR15MB1277213C9E77A1A10178D503B3E20@MWHPR15MB1277.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:469;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(199004)(71200400001)(33656002)(6512007)(25786009)(102836004)(6486002)(53546011)(57306001)(68736007)(14444005)(71190400001)(256004)(4326008)(486006)(66446008)(7736002)(46003)(66476007)(6506007)(76116006)(66946007)(73956011)(316002)(64756008)(66556008)(2906002)(53936002)(6436002)(4744005)(305945005)(11346002)(229853002)(446003)(476003)(2616005)(6116002)(5660300002)(6246003)(6916009)(86362001)(81156014)(81166006)(54906003)(36756003)(186003)(76176011)(8936002)(50226002)(478600001)(99286004)(14454004)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1277;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H76SC3RTnnB23PxUD8qg7rnwlfYXxnzYlXxavneQLQc6CJyvNwSsCN0fJYTccDH2LZO5oCksoKXdf5JpBrh3tX/+cbulrwjk6loi5E03x+ulFgsrgjiOjB7C7aa/ejh0vDbEW2nnKVdhnTgpCzo2P6xdac2+L62npbZoElvGmFgBGx9+r9pNp2VYYmeOsJHBfp3USPzKG3Mk0SH3FcF8TJ6sNPXC2KXgcCgIbzmhfKFPj7AgA1GsY6/li+HyFrEyl2cYaQVIL5WbfOHlfPD/deR5POROi/htwnDeCuvTy9FZY5DqR8sKlaSdX7/otkaDp9eWE3KNwUtDIdiiKvuqgOfYEpAQaNyRLlJvoweo/UFR/XOlhtThnAyJZa3jI600uciZIfq9hRD5DV2tA1ak/yxahQ23QrI3ca8/DJn2DY4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F36D91E8279E344395E331C1F8C1DB8B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc841f6c-7b6f-47f0-0c55-08d6fa499df6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 15:19:00.7657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1277
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=749 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2019, at 6:45 AM, Lorenz Bauer <lmb@cloudflare.com> wrote:
>=20
> On Tue, 25 Jun 2019 at 19:23, Song Liu <songliubraving@fb.com> wrote:
>>=20
>> This patch introduce unprivileged BPF access. The access control is
>> achieved via device /dev/bpf. Users with access to /dev/bpf are able
>> to access BPF syscall.
>>=20
>> Two ioctl command are added to /dev/bpf:
>>=20
>> The first two commands get/put permission to access sys_bpf. This
>> permission is noted by setting bit TASK_BPF_FLAG_PERMITTED of
>> current->bpf_flags. This permission cannot be inherited via fork().
>=20
> I know nothing about the scheduler, so pardon my ignorance. Does
> TASK_BPF_FLAG_PERMITTED apply per user-space process, or per thread?

It is per thread. clone() also clears the bit. I will make it more
clear int the commit log.=20

Thanks,
Song


