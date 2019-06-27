Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5831B578D1
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 03:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfF0BAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 21:00:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63358 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726728AbfF0BAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 21:00:33 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5R0vhgn003002;
        Wed, 26 Jun 2019 18:00:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=A4L9A/soYPtnkQlCSsqEqSWKMLw+JYl0uJNIg5QHzBs=;
 b=VRL7FIGkakILviH/n1H75lzvLDhtz6vyC2waqIBXj34JB7kAkXkYlrzGDpnjk9Dvgean
 CXBG4fqlL2ZukJjjbxa0C2IMlUdmab8BUKnJSaAu5qUbl9jMfiIxbRLxBvaH2qY9GdmT
 zkdY5+wuLF/o0z6zItqvE5auMPKjo0x1SOo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tcfqh0vf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 18:00:06 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 26 Jun 2019 18:00:05 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 26 Jun 2019 18:00:05 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Jun 2019 18:00:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4L9A/soYPtnkQlCSsqEqSWKMLw+JYl0uJNIg5QHzBs=;
 b=TsbLJNX6zTencOb0XaO+mumyJqR9negjBFHOfZ3d5zSGSeV/13y1x9mM6LE4zgmBp+Ar/Np6OoB65Fam6372WXJVDdmK98gqItOk7Mh7YTbwZi7hMCwEdTnzrKjCBFaOPur7eKFFXw2eSjgItnKMkMM4k7bO/1dphdWE8RUkdHc=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1952.namprd15.prod.outlook.com (10.175.8.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 01:00:03 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 01:00:03 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jannh@google.com" <jannh@google.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Index: AQHVK4MfT15tn2gAREGxInrd8zK0eaat8CiAgAAdbwCAAJRJAIAADmYA
Date:   Thu, 27 Jun 2019 01:00:03 +0000
Message-ID: <94404006-0D7E-4226-9167-B1DFAF7FEB2A@fb.com>
References: <20190625182303.874270-1-songliubraving@fb.com>
 <20190625182303.874270-2-songliubraving@fb.com>
 <9bc166ca-1ef0-ee1e-6306-6850d4008174@iogearbox.net>
 <5A472047-F329-43C3-9DBC-9BCFC0A19F1C@fb.com>
 <20190627000830.GB527@kroah.com>
In-Reply-To: <20190627000830.GB527@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:5a2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc7f8bec-f1fd-4df5-d5da-08d6fa9ac997
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1952;
x-ms-traffictypediagnostic: MWHPR15MB1952:
x-microsoft-antispam-prvs: <MWHPR15MB195284B1BABD8D576C78654AB3FD0@MWHPR15MB1952.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(136003)(39860400002)(376002)(366004)(199004)(189003)(33656002)(99286004)(64756008)(4326008)(478600001)(50226002)(2616005)(476003)(486006)(6246003)(8936002)(54906003)(316002)(102836004)(186003)(66446008)(71200400001)(53546011)(71190400001)(6506007)(76176011)(53936002)(36756003)(229853002)(6916009)(6486002)(6116002)(57306001)(6512007)(446003)(2906002)(6436002)(86362001)(25786009)(305945005)(8676002)(5660300002)(81166006)(46003)(81156014)(73956011)(76116006)(66946007)(66556008)(66476007)(256004)(68736007)(11346002)(7736002)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1952;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YJTMNC2DBb2IqUvog6SliffXrSwrpESPgEuxqcE0sfGk+DwYx2i8BUtSr6kUzEOwbfDoeL0sNt63PNXEhNgPe+30erryeJ5seQ0s81fv8RaW6Ed5otJeHBDzUB1GpF5hWnJO/nqqWJQpkp8D2xUjEKUysB33+fimTNUugY2y/lN6clvAcjrNrhdScNL1BD5BHS8pPnOSYXZ/tipuZ03/GA7WaXp/zSrBe+md66Gx4nb0Qx7ztusDyNGDlAL0L5w4qxDG2/FVGBbpWT72X7PNZK/CUA8KKGaFw9HsKfvf4/hNa5yvMHDnJKVb/ofKyHb+BLmjUYlJxI2UnFjjkVwHV+vYZsRxFd0xmaebS7WdgqkaStZi76NOmrKGJFvxZiQfKzzlUvnxlA3F0KXhUxfgu8JsvVUoWoYW3JCM4dbvwC8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8362171593A4E5448870DB542A4EA378@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc7f8bec-f1fd-4df5-d5da-08d6fa9ac997
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 01:00:03.2481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1952
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=897 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2019, at 5:08 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Wed, Jun 26, 2019 at 03:17:47PM +0000, Song Liu wrote:
>>>> +static struct miscdevice bpf_dev =3D {
>>>> +	.minor		=3D MISC_DYNAMIC_MINOR,
>>>> +	.name		=3D "bpf",
>>>> +	.fops		=3D &bpf_chardev_ops,
>>>> +	.mode		=3D 0440,
>>>> +	.nodename	=3D "bpf",
>>>=20
>>> Here's what kvm does:
>>>=20
>>> static struct miscdevice kvm_dev =3D {
>>>       KVM_MINOR,
>>>       "kvm",
>>>       &kvm_chardev_ops,
>>> };
>=20
> Ick, I thought we converted all of these to named initializers a long
> time ago :)
>=20
>>> Is there an actual reason that mode is not 0 by default in bpf case? Wh=
y
>>> we need to define nodename?
>>=20
>> Based on my understanding, mode of 0440 is what we want. If we leave it=
=20
>> as 0, it will use default value of 0600. I guess we can just set it to=20
>> 0440, as user space can change it later anyway.=20
>=20
> Don't rely on userspace changing it, set it to what you want the
> permissions to be in the kernel here, otherwise you have to create a new
> udev rule and get it merged into all of the distros.  Just do it right
> the first time and there is no need for it.
>=20
> What is wrong with 0600 for this?  Why 0440?

We would like root to own the device, and let users in a certain group=20
to be able to open it. So 0440 is what we need.=20

Thanks,
Song
