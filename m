Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76B7F56FA
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391015AbfKHTOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:14:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44740 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390693AbfKHTOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:14:49 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA8J9iIa009300;
        Fri, 8 Nov 2019 11:14:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nunCWavD89YTneHOOmrUlLndwiFkMX/GpAdBp75wYxE=;
 b=UD90vbyL8DTGjnMTXH+Su44UBiZIh1iobeVhFsGnC3yI+2u/VZvv0edV938yw2Otcbl9
 a1mFIg6W6JDq0IY/vcPPOc+wCEUKs+Kz9luiv33SVqMq4VA3BlSLLXVd62DkZkjpeXol
 ZwWk2eioYxWrxTX/p+HyIemeNBWGgN75G8I= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w5ckcgmw9-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 11:14:35 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 11:14:18 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 11:14:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1HFyFJcXK2xOzaywWZr21dzvASt4KPdG1EyctLi/Jy7oS5k6YoQcNTvJdpYYtuiiiubi3MoG4kPZSNadcX8EEwYvZ7NJbcIWN737+QrJKzMZDKd7yxMExzlWRZu9A7pALXERba4/hS7m/e8KJMa95LgHjF2R4mKUHGAV27mnEFi6NP8yTrnGcoBYMhND+YDuYwgssEmkBq+PiToOtv6o10Jm/nVkzGffnoKM92RvWcwMmQy61bjAlxVyTEZdeMsCW8R29yLp1owiSv9yu/Vv4Dz9z6NFn6L6BK3Xqc1AWlskpkPb06zxXVrFie76hM/PpUde0PLvnFsFakSFsE/Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nunCWavD89YTneHOOmrUlLndwiFkMX/GpAdBp75wYxE=;
 b=ItZ/6+BfJJydr/FoW7UXA7d2EFeUIiYYEqp2J72slXu6gy/EUjnq6bx3tJucXPAKPMiqqJtpvHEgBiWPei+EDRmn/BT0d1Ps7ojChvHcL0/+VE/fmuIk+e8qC93/d4C4yoPCwG/K45UVegnDlowuq469aAfQEFoDPeZXsUlquYYndQAtMPasb0JrCUFk10KkTUdysSYhiARcGNfUuA8sv+CrWidc6HR5KqDQ4r5VL24EW0uLicdPHQZ1TyB6k575fDzJtJDuBeqKZIu8AndRHGV82gNo5ieI7mxVlNZEqyCKhdU6JV34OyZz29n04sKFVH4oCBuJbidp0hzldxJipg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nunCWavD89YTneHOOmrUlLndwiFkMX/GpAdBp75wYxE=;
 b=IiLOBk1+U5cH91i4m9sB795Ratg1jVGa3a7IXm8cM2GUnDl52wQcC6X5hHofb3LC62Psg7dK7Scb+227mrEwBO3mfSkfq0Zr716xpL23UZr+WqcxIbNvdtsuos6cAdJnrqymH+PLMgeHrq9JZo+ow2Xoh52S5EODjTZEW5u71U4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1565.namprd15.prod.outlook.com (10.173.235.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 19:14:17 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 19:14:17 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 16/18] libbpf: Add support for attaching BPF
 programs to other BPF programs
Thread-Topic: [PATCH v3 bpf-next 16/18] libbpf: Add support for attaching BPF
 programs to other BPF programs
Thread-Index: AQHVlf+YwwRq5FosuE2y6hpnfHhzDqeBoMoAgAAETQCAAABWAA==
Date:   Fri, 8 Nov 2019 19:14:17 +0000
Message-ID: <484B1B7E-8B72-4BF1-A8DB-ECEEAC69E269@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-17-ast@kernel.org>
 <88611E3B-DD55-4D33-AA15-73DE58F8D44D@fb.com>
 <624d217e-ac6f-f69b-855d-b3b533ed5104@fb.com>
In-Reply-To: <624d217e-ac6f-f69b-855d-b3b533ed5104@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ed99466-35c0-438f-7b90-08d7647fd9cb
x-ms-traffictypediagnostic: MWHPR15MB1565:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB156523025602E221BB9C3375B37B0@MWHPR15MB1565.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(396003)(366004)(136003)(199004)(189003)(99286004)(54906003)(50226002)(6486002)(6436002)(64756008)(7736002)(25786009)(4326008)(6512007)(36756003)(14454004)(229853002)(316002)(86362001)(46003)(76176011)(6116002)(37006003)(6862004)(71200400001)(53546011)(66556008)(66476007)(186003)(102836004)(478600001)(2616005)(76116006)(2906002)(6636002)(71190400001)(446003)(6246003)(8676002)(66446008)(5024004)(476003)(8936002)(305945005)(486006)(256004)(5660300002)(66946007)(33656002)(81156014)(81166006)(6506007)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1565;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NZLRWIZyCDAeYEXNbEpPaOoUyJzFf6yiWHW/bBej19tgAlUiz6tvfxpfbrQ33fsXKx1N/9opcPaiH6BggDB4nBKW1Eman/EXIp7HLGdLsUHV5lJgX2Y5SO8WQaZTiMkKHxae7g7atfTZ5v6baBcCFKQElezHV+YcYUoIUlhr3OqoRmcPtrtw5b++j51NYEJYSKuFqjsuwlq+KIPCoofj9CY+TFQgfxundGblfc6yVynBiOEPNubrLonRkSF2y/iMfiJt+vaQFjTwmr9qWtWu7FD8kidwmlpvK+tFr59frEqaKBwb69UIA64f+YqoXpWtQpIlv5HL8uUOxWkNAInRmLG+CcxO1XG4CJGJP7/0Epm0cw7/Y/iGFS043TxnBS7wpZW+48iHviTMK5G2k5vPcgDECCbvdfbW7fMZ5cUHEi8jsyLylXSiteggnxGBBfnj
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3206EA231CFAAF46BC7A8E8BAC867817@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed99466-35c0-438f-7b90-08d7647fd9cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 19:14:17.2880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pPYpQ0BKypvGEEZNwvd9DdR/60ULPRnZ8fjkUqazdJCzyyfZiMz2s+ktdhl9OyLsmgzq/pmCK6PvQ/orqihysg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1565
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 8, 2019, at 11:13 AM, Alexei Starovoitov <ast@fb.com> wrote:
>=20
> On 11/8/19 10:57 AM, Song Liu wrote:
>>=20
>>=20
>>> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>>>=20
>>> Extend libbpf api to pass attach_prog_fd into bpf_object__open.
>>>=20
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>> ---
>>=20
>> [...]
>>=20
>>> +static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog=
_fd)
>>> +{
>>> +	struct bpf_prog_info_linear *info_linear;
>>> +	struct bpf_prog_info *info;
>>> +	struct btf *btf =3D NULL;
>>> +	int err =3D -EINVAL;
>>> +
>>> +	info_linear =3D bpf_program__get_prog_info_linear(attach_prog_fd, 0);
>>> +	if (IS_ERR_OR_NULL(info_linear)) {
>>> +		pr_warn("failed get_prog_info_linear for FD %d\n",
>>> +			attach_prog_fd);
>>> +		return -EINVAL;
>>> +	}
>>> +	info =3D &info_linear->info;
>>> +	if (!info->btf_id) {
>>> +		pr_warn("The target program doesn't have BTF\n");
>>> +		goto out;
>>> +	}
>>> +	if (btf__get_from_id(info->btf_id, &btf)) {
>>> +		pr_warn("Failed to get BTF of the program\n");
>>> +		goto out;
>>> +	}
>>> +	err =3D btf__find_by_name_kind(btf, name, BTF_KIND_FUNC);
>>> +	btf__free(btf);
>>> +	if (err <=3D 0) {
>>> +		pr_warn("%s is not found in prog's BTF\n", name);
>>> +		goto out;
>> 		^^^ This goto doesn't really do much.
>=20
> yeah. it does look a bit weird.
> I wanted to keep uniform error handling, but can remove it
> if you insist.

I think it is good as-is.=20

Thanks,
Song=
