Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593D06787E
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 06:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfGMEyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 00:54:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43304 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725916AbfGMEyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 00:54:39 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6D4qVJU005175;
        Fri, 12 Jul 2019 21:54:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Kt8M0xg3DjW9p8Wd5cKcZhvee9qfCoSjapUQP9xBfXE=;
 b=EVz/HXWE6fxSsFXeTDfEuijttzv1hXQF9WZ8OgMeRi7Nr0kV2GOxX9nR2+uWkJs92tZe
 M78cVkz73w10ksG1xJ9VHB2B2b6uUZFSmxwTpYDrJsEyJUS6T7//69wgB5mHxGYOsLmv
 kagWEvJyBIPy7Hxthn4l5TZbO+Z5KZiJqqE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2tpu9taj31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 21:54:18 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 12 Jul 2019 21:54:16 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 12 Jul 2019 21:54:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kt8M0xg3DjW9p8Wd5cKcZhvee9qfCoSjapUQP9xBfXE=;
 b=IxWXoNDsHbV+7UqBH0XvPM4whzJIo6jqaIGsicxqCgoyS7Hhx8+EaWPoE/GhsF7gWaw6aZ+MGQjESXb2rLbPR5rf/Ghh9Y+njyhp3IspQcGFNZ+8QIrBcbYzauldkNab2DUqYJTnC0bxBwJ8N6/OC3mPZOIxbUX2Yq3qnCbWR4Y=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1358.namprd15.prod.outlook.com (10.173.232.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Sat, 13 Jul 2019 04:54:14 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::d9b8:60e6:ba58:dc76]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::d9b8:60e6:ba58:dc76%8]) with mapi id 15.20.2052.022; Sat, 13 Jul 2019
 04:54:14 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf 1/3] bpf: fix BTF verifier size resolution logic
Thread-Topic: [PATCH v3 bpf 1/3] bpf: fix BTF verifier size resolution logic
Thread-Index: AQHVONbyBEuzXvOGV06rV3/a/IuM/6bH/FCA
Date:   Sat, 13 Jul 2019 04:54:14 +0000
Message-ID: <20190713045405.oyqddjksn535ddzb@kafai-mbp>
References: <20190712172557.4039121-1-andriin@fb.com>
 <20190712172557.4039121-2-andriin@fb.com>
In-Reply-To: <20190712172557.4039121-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0065.namprd12.prod.outlook.com
 (2603:10b6:300:103::27) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:6a94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1f45c61-9ce7-4474-80cf-08d7074e26e1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1358;
x-ms-traffictypediagnostic: MWHPR15MB1358:
x-microsoft-antispam-prvs: <MWHPR15MB1358FED9033343FA3BAF1B9AD5CD0@MWHPR15MB1358.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(376002)(346002)(396003)(136003)(366004)(51914003)(199004)(189003)(2906002)(5660300002)(6486002)(71200400001)(9686003)(71190400001)(6636002)(4326008)(6436002)(4744005)(8936002)(25786009)(53936002)(6512007)(6862004)(478600001)(66446008)(66476007)(66946007)(316002)(66556008)(64756008)(54906003)(229853002)(33716001)(256004)(52116002)(68736007)(305945005)(14444005)(14454004)(6116002)(81166006)(8676002)(81156014)(7736002)(46003)(86362001)(11346002)(186003)(102836004)(446003)(386003)(6506007)(6246003)(486006)(76176011)(99286004)(1076003)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1358;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DOXeh4sOWGfpzjF3EXpqvSg9XWvferICZmfHBTlcMgfDFMCjGS20xiMB74WkdP8BQkYI+nVHE7zDs8nzDWK4/RpIjxbvK79f6y2LJZLoxNdvi5T5KmMxltt7GD3m3/KkgJHNGZy0NjO9/hydREMT0rvPYRAf+jwIhmiIwyyas/l/4BgNMsmfncmTAgtmBxZ9MmcHPS+OOZkS2vbiMGuDpUBV2YsR4OZxg4Law2G+eQbo5GY3UOQv/jm9+HLmzhLw7vIhb9sK+cItVh4RBdxiycBzmlEEtUAzIL4nJjk+gobu3RkbgSADu8GC+RdHZaY0pmPPKDwSdIwAta0cqb6iCNoWekinfgUPmxsX4VrBR2jzUCVXyCNt721PMzrqO5MRyCHJEcbWLMOP2EeYxofls0klEyC/OfJ0Wx+ot273xuw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <655AFA424E7EF04490D801336202A67B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f45c61-9ce7-4474-80cf-08d7074e26e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2019 04:54:14.1113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1358
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-13_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=455 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907130057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 10:25:55AM -0700, Andrii Nakryiko wrote:
> BTF verifier has a size resolution bug which in some circumstances leads =
to
> invalid size resolution for, e.g., TYPEDEF modifier.  This happens if we =
have
> [1] PTR -> [2] TYPEDEF -> [3] ARRAY, in which case due to being in pointe=
r
> context ARRAY size won't be resolved (because for pointer it doesn't matt=
er, so
> it's a sink in pointer context), but it will be permanently remembered as=
 zero
> for TYPEDEF and TYPEDEF will be marked as RESOLVED. Eventually ARRAY size=
 will
> be resolved correctly, but TYPEDEF resolved_size won't be updated anymore=
.
> This, subsequently, will lead to erroneous map creation failure, if that
> TYPEDEF is specified as either key or value, as key_size/value_size won't
> correspond to resolved size of TYPEDEF (kernel will believe it's zero).
Thanks for the fix.

Acked-by: Martin KaFai Lau <kafai@fb.com>
