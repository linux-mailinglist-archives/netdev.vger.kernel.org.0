Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B31113D054
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgAOWuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:50:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13294 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727016AbgAOWuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:50:18 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00FMlUBK016424;
        Wed, 15 Jan 2020 14:50:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dZ9/PsPH/s0wSgeTA6u3Hj9eFUqfzy5TZfWjnrRtrgE=;
 b=c0LM/avDJiE2oEEZZUbWKVFC7gZk424SKlOK61wmocslRMFXlGe5jtWL50vVpgwhYpnv
 oXVA1A/7/wJbhp1fIUXbRr7ryjfTdcbCKNMWaqfUpef8eik3SVXoIV0EDoPlCrRmg0ro
 gOEvdBWJW3nL92pdicpSQybbmCxCw54+qGM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2xj5pt9yy3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Jan 2020 14:50:01 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 Jan 2020 14:50:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpUrdcp3ZBS/X7siUkhuHxo6Sf5pAqBtKyy2CmiT2W1UiHPuY/Rraa8F+8V0yiv5zobqIaCIqHvGAvo2Dgln33IQq9RymuFjkMz/Dry5flxaeWQSV7E0hdosXJ1ALJwXRQn12tvPY/virpeOd6C+Qd2A25T89MLDK1jnVUbUzyHKybZZi1NK99MGOcTSOIdQHXQ3LUdJ3ic+Qq5Rd1tH3NKIB1nnlAeyU5ucd9tCvbNsQMnOxvOBeOmq80FciMWTBovr6L0YmLeIVrb3FAISUDFnd8v0fvf9zMqEketzKo9obRuBX2GwxKOoVsA8LcvfK+96ny0PCS/Hz/NJC9Ecyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZ9/PsPH/s0wSgeTA6u3Hj9eFUqfzy5TZfWjnrRtrgE=;
 b=mexYDMOeYtI7lsYOmgIY7c6Om2Unim4g9bbxlr7nVkFy63lB4p/mwvHim8soj3E5RsWYblOFCfY1qbtQ5OUOstyrQyboU1Hvs7Z78tE/nRI63phJDhMpKEJDJXP2Iw6Gjs8NSaUqGsHdsCaypgEUFCWUf7HK4UBKAtipXagQ4nnDCJ69k+jaFC1MIsAPJCNkvoHmRW2vtzI5pJwLHaD8zcjAzkXqzPr0PQPaqHZiAQdUH2fNn2aqkOI9D3Y9bMrgISKyoCx3DUZ9wgORFu353sIhAYRT37yhiZG0sixPAT+c/FDvhWXFW47uSF+waVJ2Y2DPYBqa+lTUOGS24GcSsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZ9/PsPH/s0wSgeTA6u3Hj9eFUqfzy5TZfWjnrRtrgE=;
 b=b7WSDgl1Tmg6NjgY9klXs8shuLj+XdW4aebYNfgn6GndTpDFbf0eucBqrukvoeTrxkIs++OXrwGN8B3WyyQueKGKUlQmA0dj78FYssfbtqSXHz1N5r59ZSAyJ3UXxplMtTBUjEUjZqM59cWhng1xOIiXu0CheCSrwEXuRoTJ42E=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3582.namprd15.prod.outlook.com (52.132.172.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 15 Jan 2020 22:49:59 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 22:49:59 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::3:951d) by MWHPR1601CA0016.namprd16.prod.outlook.com (2603:10b6:300:da::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Wed, 15 Jan 2020 22:49:58 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 5/5] bpftool: Support dumping a map with
 btf_vmlinux_value_type_id
Thread-Topic: [PATCH v2 bpf-next 5/5] bpftool: Support dumping a map with
 btf_vmlinux_value_type_id
Thread-Index: AQHVy/Wi/rEobTqQmEOESUirDOtKAafsVEqA
Date:   Wed, 15 Jan 2020 22:49:59 +0000
Message-ID: <20200115224955.45evt277ino4j5zi@kafai-mbp.dhcp.thefacebook.com>
References: <20200115222241.945672-1-kafai@fb.com>
 <20200115222312.948025-1-kafai@fb.com>
 <CAEf4BzbBTqp7jDsTFdT60DSFSw7hX2wr3PB4a8p2pOaqs18tVA@mail.gmail.com>
In-Reply-To: <CAEf4BzbBTqp7jDsTFdT60DSFSw7hX2wr3PB4a8p2pOaqs18tVA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1601CA0016.namprd16.prod.outlook.com
 (2603:10b6:300:da::26) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:951d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd935081-e4a1-4a42-eab7-08d79a0d3fa8
x-ms-traffictypediagnostic: MN2PR15MB3582:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB358205A5D870EE9D345A0778D5370@MN2PR15MB3582.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(136003)(39860400002)(189003)(199004)(6916009)(81166006)(81156014)(2906002)(71200400001)(8676002)(478600001)(54906003)(7696005)(4744005)(52116002)(66556008)(64756008)(66446008)(66946007)(66476007)(5660300002)(53546011)(6506007)(16526019)(86362001)(186003)(9686003)(316002)(55016002)(8936002)(4326008)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3582;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SnoW72iivEIzvbLuso7tK0CkGtJYB3J5rd2YKquhNC1BN2ud8nA/5SRgthTYQQjVyQ/9t2fpmgWNSpo9hrHSIuaBy/kWO4n+xmlzLvZrJNpyONqIfisk5bXYBTt7GW+4OxCaJlH+OJwGcvPzBygA8LjB8GNXauZ3/UyK740uSgF/6H1QlY0nnCUXrg+uDtCkBl0cgynVBCmZlSeEOIBB6rKdZGhF8Cezrbikup83rQ/nOoTqb/UzJv0Z9m7Gk29HcFLZLGbr8Nac50x3Bq7bZQYUt11RhFYfEnXjq6464mEbi7BUxBH9yR5oiY5rSJUBFuPz4eseRqHnkJSrzdq45LDtpX98uvt8x+smwqDMOTS3EcReE00+dWXmjL1XGwgjraQANRPob4vU9ozRsQKlwompIaL8ZPIzcKjnqJUlmvX8Zm2A81NcStZGALz8Bzff
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1D71CEC4851C024789299123672FC348@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dd935081-e4a1-4a42-eab7-08d79a0d3fa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 22:49:59.1850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jv5WkwZe9PBEhMOKAggzE/g6v8B5GW5JTMQaEM+VdIKujlvm9ya4rX3Doo8fRTY7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_03:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=488 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 02:46:10PM -0800, Andrii Nakryiko wrote:
> On Wed, Jan 15, 2020 at 2:28 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch makes bpftool support dumping a map's value properly
> > when the map's value type is a type of the running kernel's btf.
> > (i.e. map_info.btf_vmlinux_value_type_id is set instead of
> > map_info.btf_value_type_id).  The first usecase is for the
> > BPF_MAP_TYPE_STRUCT_OPS.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
>=20
> LGTM.
>=20
> Acked-by: Andrii Nakryiko <andriin@fb.com>
Thanks for the review!

I just noticied I forgot to remove the #include "libbpf_internal.h".
I will respin one more.
