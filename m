Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E9358959
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfF0R4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:56:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46184 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726405AbfF0R4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:56:21 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RHka8J003440;
        Thu, 27 Jun 2019 10:56:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4SZT8wVN4+BSw4lbdFNKUFRopc0Pil8T9DEGkN7YPlM=;
 b=H84VhpVkmEQ4IxJBXBYNKJEEW6Gc40cEBNIXdTW9fuZcB01TrvvQmU/Mu0lrAqd6MiV8
 uKfpJ81cxaVCSHE3Y1+fyRq6uRQMbDg9fYpwCO8bHKi8QlcFychWhTAyFjDvur4W88jn
 hbt6LQf5x9r1mLuftIBzO1zcumGMz06GqbA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2td0y50fy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 10:56:00 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 27 Jun 2019 10:55:59 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 27 Jun 2019 10:55:59 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Jun 2019 10:55:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SZT8wVN4+BSw4lbdFNKUFRopc0Pil8T9DEGkN7YPlM=;
 b=NDOUOeqcbMTXafX8rNZmKZsCEUZXyYPp/sxm/PvpX2h8BmNAOGU2kGWpURn5UN9b5sa+H9PUmR17P3ErQPikRA/ZDBO2y3j6iqxA2Pc7+b65VyHEGZsaQzV87ciLfWMfqZ71ZhYrY8c3BHfCxGJJ+ax9qEPlYCXeT5cHmZ/IlYM=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1791.namprd15.prod.outlook.com (10.174.255.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 17:55:58 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 17:55:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: capture value in BTF type info for
 BTF-defined map defs
Thread-Topic: [PATCH bpf-next 1/3] libbpf: capture value in BTF type info for
 BTF-defined map defs
Thread-Index: AQHVLHX5c/0tlkdQh02ogvUGijo9IKavwlqAgAAFowCAAAI7gA==
Date:   Thu, 27 Jun 2019 17:55:58 +0000
Message-ID: <079A7D73-697C-4CFD-97F3-7CFB741BE4C3@fb.com>
References: <20190626232133.3800637-1-andriin@fb.com>
 <20190626232133.3800637-2-andriin@fb.com>
 <E28D922F-9D97-4836-B687-B4CBC3549AE1@fb.com>
 <CAEf4Bza1p4ozVV-Vn8ibV6JRtGc_voh-Mkx51eWvuVi1P8ogSA@mail.gmail.com>
In-Reply-To: <CAEf4Bza1p4ozVV-Vn8ibV6JRtGc_voh-Mkx51eWvuVi1P8ogSA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:a913]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89ebcb3b-ee81-4689-412d-08d6fb28b5d6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1791;
x-ms-traffictypediagnostic: MWHPR15MB1791:
x-microsoft-antispam-prvs: <MWHPR15MB1791EB5631E5BEF7D00C0DFEB3FD0@MWHPR15MB1791.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(396003)(346002)(366004)(189003)(199004)(53546011)(6486002)(6506007)(76176011)(53936002)(6436002)(46003)(305945005)(50226002)(6116002)(33656002)(102836004)(6512007)(186003)(476003)(2616005)(14454004)(486006)(71190400001)(71200400001)(36756003)(256004)(2906002)(316002)(25786009)(54906003)(68736007)(99286004)(4326008)(11346002)(57306001)(446003)(64756008)(66446008)(66476007)(66556008)(6246003)(81156014)(81166006)(7736002)(6916009)(76116006)(8676002)(73956011)(5660300002)(66946007)(8936002)(478600001)(86362001)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1791;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8VzrZkoK55QpwuCCP1D3ItEuJhE/6O7p9836LUMDh9/AxPxe9CUtH8tMaJ4A3x8Z+QDFAGTOXPh9xz7fJ/YfDwwf/ue1R9qP3UKRhUSQNmn4E1paHHNIoiYTpiGo+Ez5Db92PPrIARo219qddQlWQrqZbJsmnu4PQDy0GRfGSrzw1FbDCxTWHSRwNLiOI2yvAXeuVPyvO788aLghBvM2MSGYDR6847uneCFr76j8qPO88aQT4SR3qdYlzI3+0S8u+Xfe82iKYIlFbDkz+wxKrxLKfbzLTBql6KLW5UT+k+NPwAffSC/Z11wR5VHTOV5pUqNtKWpiDMHoqr+v45qmFNOmwZec9ambkeaLTK30e9H1FoEqoJftqaSDsNFz89qninxBi/GWipMqzA6GWZ3dbu6eKeP184/YzEaMqXgZ53o=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94983CB48E5BEF409DB20B7960CF3C83@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ebcb3b-ee81-4689-412d-08d6fb28b5d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 17:55:58.5633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1791
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=607 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270205
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 27, 2019, at 10:47 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Thu, Jun 27, 2019 at 10:27 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jun 26, 2019, at 4:21 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> Change BTF-defined map definitions to capture compile-time integer
>>> values as part of BTF type definition, to avoid split of key/value type
>>> information and actual type/size/flags initialization for maps.
>>=20
>> If I have an old bpf program and compiled it with new llvm, will it
>> work with new libbpf?
>=20
> You mean BPF programs that used previous incarnation of BTF-defined
> maps? No, they won't work. But we never released them, so I think it's
> ok to change them. Nothing should be using that except for selftests,
> which I fixed.

I see. This makes sense.=20

>=20
>>=20
>>=20
>>>=20
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>=20
> <snip>
>=20
>>> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/=
selftests/bpf/bpf_helpers.h
>>> index 1a5b1accf091..aa5ddf58c088 100644
>>> --- a/tools/testing/selftests/bpf/bpf_helpers.h
>>> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
>>> @@ -8,6 +8,9 @@
>>> */
>>> #define SEC(NAME) __attribute__((section(NAME), used))
>>>=20
>>> +#define __int(name, val) int (*name)[val]
>>> +#define __type(name, val) val *name
>>> +
>>=20
>> I think we need these two in libbpf.
>=20
> Yes, but it's another story for another set of patches. We'll need to
> provide bpf_helpers as part of libbpf for inclusion into BPF programs,
> but there are a bunch of problems right now with existing
> bpf_heplers.h that prevents us from just copying it into libbpf. We'll
> need to resolve those first.
>=20
> But then again, there is no use of __int and __type for user-space
> programs, so for now it's ok.

OK. How about we put these two lines in an separate patch?

Thanks,
Song

