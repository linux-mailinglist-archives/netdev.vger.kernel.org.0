Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADFDD587AC
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfF0QwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:52:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47470 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726445AbfF0QwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:52:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5RGivhG025723;
        Thu, 27 Jun 2019 09:51:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=e7G+FANWOXs5t43tx6tfWKL7NV7gDb3/u66cKn9sHl4=;
 b=EZJC1dBy47j4OJC+UN4AELCSbuIwqcvWh4Wx+6gWIWZOktxq619fWJJhWhGXdohxhUjY
 qtW6BlGfbVDYt0VtEb6es/mZei2+Z20XAWVO9acvT95WwSUFKRd8QS7x+7mGvmpneUXr
 hlAETvGGrgSbSn4ISTemrCU7QE2MLZv/jwc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tcc49vcae-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Jun 2019 09:51:51 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 09:51:43 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 09:51:21 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Jun 2019 09:51:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=bxSxCxb8WlGj4yLKNY0JJu4zsQ8OecWgq735Szk0cOsZnowOzb/a6sKKA3iAfLJ89SID+kdgSog8Stutd3yXN7r3ZDsIMLLPlFj1+gEt/5PV1uHZn5TxspOYTnGWkxHsqH3EEC1rBEFBVNUUPdhh69DTjo+26MDoB3TpqxJQVQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7G+FANWOXs5t43tx6tfWKL7NV7gDb3/u66cKn9sHl4=;
 b=ftaJwNveKDCWe3dNGrUlGEm5nWPPMBYRH6tVnl0aDALsrTxFI0j9GXr4k2BY/wVQNVrX7r1ViYmKTpizAVkEif7HtHsZsiNk1ABTX2Chfvsj055p8c9qZ1+sVC+FKoQFGi6od0L1J31sPDIjJGKVuc67xmvz3M/k8OqyspMBdf8=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7G+FANWOXs5t43tx6tfWKL7NV7gDb3/u66cKn9sHl4=;
 b=KDByNi3DtBMiIhRmM3asAlliByYIdhyEAvGvwKJurw9QdtNIt+CKDJbKsJuGbbIwwur50ZIWir4WQDM5eOG6EsBdtHu+iD7FY/Co+VJ/r1eWPtwRbVE8nI1XRkh4vxXhape+nI1SImi19NbXQePIV24gNSwk+DhkhihYE1LllJw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1213.namprd15.prod.outlook.com (10.175.7.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 16:51:20 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 16:51:20 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jannh@google.com" <jannh@google.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Index: AQHVK4MfT15tn2gAREGxInrd8zK0eaat8CiAgAAdbwCAAJRJAIAADmYAgAEF5ICAAAPlgA==
Date:   Thu, 27 Jun 2019 16:51:20 +0000
Message-ID: <48E35F58-0DAD-40BA-993F-8AB76587A93B@fb.com>
References: <20190625182303.874270-1-songliubraving@fb.com>
 <20190625182303.874270-2-songliubraving@fb.com>
 <9bc166ca-1ef0-ee1e-6306-6850d4008174@iogearbox.net>
 <5A472047-F329-43C3-9DBC-9BCFC0A19F1C@fb.com>
 <20190627000830.GB527@kroah.com>
 <94404006-0D7E-4226-9167-B1DFAF7FEB2A@fb.com>
 <20190627163723.GA9643@kroah.com>
In-Reply-To: <20190627163723.GA9643@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:a913]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c92663da-ee0d-463b-cbc1-08d6fb1fae49
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1213;
x-ms-traffictypediagnostic: MWHPR15MB1213:
x-microsoft-antispam-prvs: <MWHPR15MB12136E72BB283134E79BA10DB3FD0@MWHPR15MB1213.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(136003)(39860400002)(376002)(199004)(189003)(446003)(186003)(53546011)(476003)(6506007)(46003)(486006)(2616005)(11346002)(25786009)(4326008)(305945005)(7736002)(6116002)(316002)(5660300002)(54906003)(102836004)(6436002)(6486002)(33656002)(66946007)(53936002)(256004)(64756008)(66556008)(66476007)(6512007)(81166006)(81156014)(8676002)(2906002)(50226002)(478600001)(8936002)(99286004)(76176011)(6916009)(6246003)(57306001)(86362001)(229853002)(14454004)(71190400001)(71200400001)(76116006)(68736007)(66446008)(36756003)(73956011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1213;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wNvLreGlRQu06QmTvQXeakYuHOMa4LFDBJz7nlLNYQW3z94f31m4Ja4Q78f6MirNI6uz3zb9fFlNvCWj06yuZZfQgTmZZb/aBYuPCcbydaZ/g+tSEQyOnwW7x8IdIRBjnW+uhADjt2C+9GrhnYNovZk2tQV1SWgdEYIB+hbqgT9fc4xbLzuZh2FW1h3TXIwUkey2LrMNC4SHLSbFFSgohvwqaif5ntFbADSHYNPrmkCbNrWgZqM2AzZ7ku/2FZWnd80cJc6lJJ1SBCtwfNa4Mvu6tG1jHQb16whCjQTX6u6H2DqRHbN4bCh65FO8bvezONu70TCAOc/YGtU/VL071N1qKiWshbvzpHarXPVH5d3HIS1ykP+eNTPdF4iVJDimjOmhhwqMGkHNmBnQlIdhN1ErP7B6oo7l4KoD3V31abw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0905705A02FA0B4C91997A34FCC4A71B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c92663da-ee0d-463b-cbc1-08d6fb1fae49
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 16:51:20.4702
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1213
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=947 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 27, 2019, at 9:37 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Thu, Jun 27, 2019 at 01:00:03AM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Jun 26, 2019, at 5:08 PM, Greg KH <gregkh@linuxfoundation.org> wrote=
:
>>>=20
>>> On Wed, Jun 26, 2019 at 03:17:47PM +0000, Song Liu wrote:
>>>>>> +static struct miscdevice bpf_dev =3D {
>>>>>> +	.minor		=3D MISC_DYNAMIC_MINOR,
>>>>>> +	.name		=3D "bpf",
>>>>>> +	.fops		=3D &bpf_chardev_ops,
>>>>>> +	.mode		=3D 0440,
>>>>>> +	.nodename	=3D "bpf",
>>>>>=20
>>>>> Here's what kvm does:
>>>>>=20
>>>>> static struct miscdevice kvm_dev =3D {
>>>>>      KVM_MINOR,
>>>>>      "kvm",
>>>>>      &kvm_chardev_ops,
>>>>> };
>>>=20
>>> Ick, I thought we converted all of these to named initializers a long
>>> time ago :)
>>>=20
>>>>> Is there an actual reason that mode is not 0 by default in bpf case? =
Why
>>>>> we need to define nodename?
>>>>=20
>>>> Based on my understanding, mode of 0440 is what we want. If we leave i=
t=20
>>>> as 0, it will use default value of 0600. I guess we can just set it to=
=20
>>>> 0440, as user space can change it later anyway.=20
>>>=20
>>> Don't rely on userspace changing it, set it to what you want the
>>> permissions to be in the kernel here, otherwise you have to create a ne=
w
>>> udev rule and get it merged into all of the distros.  Just do it right
>>> the first time and there is no need for it.
>>>=20
>>> What is wrong with 0600 for this?  Why 0440?
>>=20
>> We would like root to own the device, and let users in a certain group=20
>> to be able to open it. So 0440 is what we need.=20
>=20
> But you are doing a "write" ioctl here, right?  So don't you really need

By "write", you meant that we are modifying a bit in task_struct, right?
In that sense, we probably need 0220?


> 0660 at the least?  And if you "know" the group id, I think you can
> specify it too so udev doesn't have to do a ton of work, but that only
> works for groups that all distros number the same.

I don't think we know the group id yet.=20

>=20
> And why again is this an ioctl instead of a syscall?  What is so magic
> about the file descriptor here?

We want to control the permission of this operation via this device.=20
Users that can open the device would be able to run the ioctl. I think=20
syscall cannot achieve control like this, unless we introduce something=20
like CAP_BPF_ADMIN?

Thanks,
Song

