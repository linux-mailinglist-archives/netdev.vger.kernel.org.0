Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887EA1750A2
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 23:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgCAWiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 17:38:10 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726418AbgCAWiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 17:38:09 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 021MbcJc014906;
        Sun, 1 Mar 2020 14:37:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=mD5LMU973O/KiPDdRRqVaYu3DT2ww50Fj7eza13G7vg=;
 b=coBDvs3EQvdjt9llkGnu9WNvyQL3dwsX2A2FLmEX75bQS5OC7QrEpyBUfL2fan6YELfb
 B49deocKas47iLg7rSXVOBapPyuWW9uY2vwsxmAe9UK1R+EVS8IESnqrYnmOzEd7mZ+q
 iXL12BbYG7WspZAXwkqxZqb//Tk9iAFSmHY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8du2108-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 01 Mar 2020 14:37:57 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 1 Mar 2020 14:37:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NA8LSwhuL/QcHsdA/K+M1zb3u52p1kNwuddNkhhq7yFTSHNbmKquUDBj27kVoKl2Rmm/1IkRNq6waJ4S2o1xFzNC000IS6WS5BzpAeVAV/v+2+HCFIMXNFfc7V58S3GC9XUm31GZlXgCf+uibIE/a7KDiTkeeQhNXgvMMknu2Ju6Cw4SSsfrlnWqTT1CCfbdfeKEV5yiuiHf5BMzLNh2OXnYXxYmkdWsvCXEPMKysl4c43Hnnb2Vn/wqTg+ZOB40yDY7HNkK9my+VrM2Q2gYnzWsjgE++FC7x1zUcj4EhkwK5k0uXNyiWFwbDXIdZyOrMWsajS/sOXmNHugV/T1xJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mD5LMU973O/KiPDdRRqVaYu3DT2ww50Fj7eza13G7vg=;
 b=YwlrRH0PeQF2tbcbNXoDA8ss0ABQsmmNtbWEF+Mjd3sz2FhmmuDYZlMXTLOrnsEHzQZDHD0bmh/8j6QtzHw8Io/JuUInmFb9y8TzSHmwxJ+jcTobMtJqECq2HfbzpeZCbOIX2rbXTQsg4TtSe37JUayHvyS1HmEe7SeJGpxFcyGZNj/bNdhJtkc/jUXXFCRxMFUGQX60oZzqJX75U8p2ma/m49s252/t1neM/2VoHbKhV/z2fQFqJtTBDHpee9FbKWA1nIP7nGGV7ZTppRZGTiGgJ12ml+qeG1sKGGelvMPRNTpVf1RiWkJ0IKF8G0PRu9NKDIb2u3B5NGOAEg+/GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mD5LMU973O/KiPDdRRqVaYu3DT2ww50Fj7eza13G7vg=;
 b=Kp3k+Z6JLylae/wLGmCk0mBgMI07WFNHnHxfWDtinYX/GgVVHh3dJsKV4Lu9neHYqJ/vUr0Dv9GJY97yY3LU6WC1xwPdfcPslaPZ6q1eqS5PTc2i0yfSfhW2O8sZ5yfd6LjvsB3axrlCNzuB/ZCQjrDbNVDAZ6RsSH1GE7R7Neo=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Sun, 1 Mar
 2020 22:37:41 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2772.019; Sun, 1 Mar 2020
 22:37:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile" command
Thread-Topic: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile"
 command
Thread-Index: AQHV7pCRwZ1HBc6vtU2QEGEJ7IlYy6gzIqyAgAE0OgA=
Date:   Sun, 1 Mar 2020 22:37:41 +0000
Message-ID: <27D50788-0EFB-4A08-B3A0-F3C8642BEF69@fb.com>
References: <20200228234058.634044-1-songliubraving@fb.com>
 <20200228234058.634044-2-songliubraving@fb.com>
 <72fc922e-68be-e63d-0488-b8bd35e7213b@fb.com>
In-Reply-To: <72fc922e-68be-e63d-0488-b8bd35e7213b@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c091:480::1:fe2d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f28c18b-b6c6-43a3-68e9-08d7be31271c
x-ms-traffictypediagnostic: MW3PR15MB3980:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB39809D3F2FE6EC67BD374DF9B3E60@MW3PR15MB3980.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0329B15C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(136003)(39860400002)(376002)(199004)(189003)(2906002)(66946007)(6512007)(186003)(8936002)(86362001)(33656002)(478600001)(36756003)(66556008)(6636002)(71200400001)(6506007)(66476007)(81156014)(53546011)(8676002)(81166006)(37006003)(54906003)(316002)(6862004)(6486002)(4326008)(5660300002)(76116006)(64756008)(66446008)(91956017)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3980;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MYvzb9iaahAbY6cu+0xc20x9RoHrvw82FeejgzngZrUFDxpFqGbZhf/kwmWV7pBCdMO/NsXIrlqpjzc7jISpFxiSF2Sfxsw+IjRCEY2LaMI41OW+wJ4VpgAWoDH31OMBLa0f3h/34eG7jX7rzyXpr32BPUojlAJHd/c9aPVtRHVq3k0jvT4KvWL4nn/7FRXeTbkmD4Icv9DXYY/4SQyWgaDU+uVR+WGbEVXmAkfL6Ksy9zTzx534HWolQqebRHB55JiI6rt2ElWY3yos2TnsSODzw5zMw5QXJkb8Cu/BuEEzQbIwVdWJHWvX48ruKki7iBq5SjRbwDGzQpKcaf58dnPDGR3HoAXF8M6/CDMrxzcsyH1nF8Q5sfTVpRIhj10fj/b3rcI1eRf8/9xLb7qeVjFrmeCnXRUDACYrwScm9wTfw8grUWan77lwwuyslD4B
x-ms-exchange-antispam-messagedata: 995xvVCyEvr2vBtcNv7ckDdyFCN/mBSNREp8wKTxO/DSU8i3eP2spSkvC51a1gYTwJkd0xU46BQ58MZTK/Vzx/XSpZJOc6XZnYAoW92LOoOJlo6Jg3fkwMeL7wLM5I0HHUTRPpO5NfV627i976NVBe16zwlM69D1FpUqhqSXDypm4i2rFRBacbWfOIdDQIUD
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D33B3D556547EE4690DC5A8A7506D453@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f28c18b-b6c6-43a3-68e9-08d7be31271c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2020 22:37:41.3320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FDhaYzDg3/G/Ni1GwU9nWbRxjAqW+QREJRxaJ0VBuUZgcPKVC9iPaxX3JaUHYrWlYjSz9dlgYdtkYCGxNoHV5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3980
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_08:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 29, 2020, at 8:14 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 2/28/20 3:40 PM, Song Liu wrote:
>> With fentry/fexit programs, it is possible to profile BPF program with
>> hardware counters. Introduce bpftool "prog profile", which measures key
>> metrics of a BPF program.
>> bpftool prog profile command creates per-cpu perf events. Then it attach=
es
>> fentry/fexit programs to the target BPF program. The fentry program save=
s
>> perf event value to a map. The fexit program reads the perf event again,
>> and calculates the difference, which is the instructions/cycles used by
>> the target program.
>> Example input and output:
>>   ./bpftool prog profile 3 id 337 cycles instructions llc_misses
>>         4228 run_cnt
>>      3403698 cycles                                              (84.08%=
)
>>      3525294 instructions   #  1.04 insn per cycle               (84.05%=
)
>>           13 llc_misses     #  3.69 LLC misses per million isns  (83.50%=
)
>=20
> if run_cnt is 0, the following is the result:
>=20
> -bash-4.4$ sudo ./bpftool prog profile 3 id 52 cycles instructions llc_mi=
sses
>=20
>                 0 run_cnt
>                 0 cycles=20
>                 0 instructions        #     -nan insn per cycle=20
>                 0 llc_misses          #     -nan LLC misses per million i=
sns
>=20
> -nan is a little bit crypto for user output. maybe just says
>  unknown insns per cycle
> in the comment?
>=20
> We can still display "0 cycles" etc. just to make output uniform.

Good catch! Will fix this in next version.=20

Song=
