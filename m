Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3085916EC2B
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 18:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbgBYRLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 12:11:33 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730941AbgBYRLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 12:11:33 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PGv5jP009442;
        Tue, 25 Feb 2020 09:11:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=RKzzU7f8GwVHq500inEHMGtIJNX3hmU+uc5cO2JrJCE=;
 b=P4BQtfUGVB/JK82vq9ZFtiZC8Fpx7UaNebkbZQrNt6CLYCFU9gTgNlOZuF8Jrda3DKA7
 ps81RMm3ghzyB82imrokBeAn/4HIj6X+NC6rJF8Os4kCPHBEaTMq6Z+VxzL8aMjzZR8E
 plK040FVKYu9JAYKluIlCXV9jzyz2TycWHQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yd1mjsurb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 Feb 2020 09:11:17 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 25 Feb 2020 09:11:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JoLvCSsiP/0gvy5pxW/RU5qg1Ofty5LvUZC+2k5mEIuE695GwDQt7lVC+HdXg64XORwYkBgxLuuFhtGkFP2m8SVzJrYUZu/5o53Ijhj0JgZMTOUkCbTkiL2j2jlNOBwIacCt0RhNMflVeuxaiSAr0FBLUcAqOQ/7k9mzykPGSjOecGcZlUXbmnlIEFZOLOaiSNqhgTZhGOqffC+oDSHZdC4p6To1rLdi7XRAR2i0QPsFzRpD/gOTFvQYIoZjqezo304xF3f7dyyG9zfO7zfY19+b0lP4ou/RR+dDygGH3tskWKkkvOLt7EDeFqKyRwDq1Mx4jN6YD9Tc0eJAO5uHpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKzzU7f8GwVHq500inEHMGtIJNX3hmU+uc5cO2JrJCE=;
 b=QWpu/0lK05qJE8bDp1vWQaZBAHrViZQxQcimhap0Rg/+irpZnP0we2lZNbjmMVwh6h5/2YAKO0mjj+4CuH0eBZiodBhbb01+MFm6x6LKhI8VzEAXYV32JQqPVy32WPfNzRTqkLEoAeVn7tLrBDTbVD7QoHjDH0vGnU/OYz72RRgfNlXn78h/xBFe33Fvv20aOV4bZGa2rshrvl/ruMN/8rjZA6g2ueuGqDGWWQZByP5ckiF6bBpXbywcEhQTi0UWhm/6cU59EdTXCNjIrYH0XinIZ1TrTVxLrEdJYCEuKPpbDmES8+qwV7meeU2Y0kH5XUz10+MmzskSOdz3Luww/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKzzU7f8GwVHq500inEHMGtIJNX3hmU+uc5cO2JrJCE=;
 b=TaH1VH6R3w1LuZQJvBmAPsIMdySvpXxxINacS/foFndqjSENB3C55SS5s9sIdgYuKrMFG0QTlUwJFvTuK4Wl0MlJ3S6juN9FIgP0ngT3VsjI26TbY9Ymi2TbVMIkKfJ8L9RdhMiXOwsNHrZgP6oefSmtmc7rS+o5TekIBSmyqq8=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27) by MW2PR1501MB2060.namprd15.prod.outlook.com
 (2603:10b6:302:c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.22; Tue, 25 Feb
 2020 17:11:09 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30%7]) with mapi id 15.20.2729.033; Tue, 25 Feb 2020
 17:11:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/4] bpf: inet_diag: Dump bpf_sk_storages in
 inet_diag_dump()
Thread-Topic: [PATCH bpf-next 4/4] bpf: inet_diag: Dump bpf_sk_storages in
 inet_diag_dump()
Thread-Index: AQHV6OdpFJALiiaPJEa4qZATj5ZKCqgrbFeAgAC+OgCAAADFgA==
Date:   Tue, 25 Feb 2020 17:11:09 +0000
Message-ID: <7BD5CBDC-840B-404C-9992-AAE94190E8E2@fb.com>
References: <20200221184650.21920-1-kafai@fb.com>
 <20200221184715.24186-1-kafai@fb.com>
 <CAPhsuW4BuGQP8+QGG+E9A+n=8DV0Gg=UmWzeScrbFxBp7O_ojw@mail.gmail.com>
 <20200225170824.dhwkw2ojzsfz223k@kafai-mbp>
In-Reply-To: <20200225170824.dhwkw2ojzsfz223k@kafai-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:dc77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2b8a490-0adf-419f-530f-08d7ba15b57d
x-ms-traffictypediagnostic: MW2PR1501MB2060:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB206047E59DF7E392BF9AD762B3ED0@MW2PR1501MB2060.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(346002)(396003)(366004)(189003)(199004)(2906002)(186003)(6862004)(81156014)(81166006)(8936002)(86362001)(6506007)(8676002)(53546011)(6636002)(71200400001)(5660300002)(54906003)(4326008)(2616005)(66946007)(37006003)(66556008)(76116006)(66476007)(66446008)(36756003)(478600001)(64756008)(6512007)(33656002)(6486002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2060;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cW2uPjC4d1Toy/7NBnbTsfNH4hU7sFStCjR4wLZqTgmhbebsVNRJ7wldX1oj5rgfpSLHBsllUN6jn5rXo8NglmpKp5ss3cYXOhM7aQJtG2h3GUec27x3anBq1+U4coTQK9YbIjnthx8E6QkZYLQMk+DOEsbWyN2TkszWsEXckq7MGz/0mdpLYOw2YieEn2f44KvYDSI75jxXyXBSq9cg/C+7qIIuyGhcej5e+2ACwmDLQBAvYRHrXRWwoLDnevwYy8BtN8VfC4OhEv+zUFsn/J0M3VTO++mdA14jQVk5Kb8ik5TE0E2x2gCCgBPJAvjX6jvRKQkOomqBt2LmM+9CW2eXnSSbO33QKnBIwePtI/NsFebWIlARyDyQOZfcTzUVUNtK/LW1A7D/e7twffSOFKxVF42kYtGf06IBv+nZSNDBtxzT0aqIKmMD7d3TMjBm
x-ms-exchange-antispam-messagedata: 5Dig4rntctet1Y+GvtOxSB/N7ZNTbB8d5D1uJu7py9oS70j7rJawSlJROQLiBnfD8dvZi+iBjkGUVaotEOz1jwZJNT/avdPhtn4KbMyx3y+dJErGWLjsubonNiK6/P6vxWShK7VPUYepU9JlwqbcMRO3fOvLnUQqaXePMCxq0bTTkwam1xt1+VE13oJKsvSI
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0E011F4F38AE0B41A17BBBBA0EC966C7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b8a490-0adf-419f-530f-08d7ba15b57d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 17:11:09.7054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l3nbZILX8niQWH9FAN6QmPErz9A7DiBtIgbRMr4dEMV7HYtTFD0i3MbXCf+U0tYYUt6Lg4Jgi2BQiwRbiBHTbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2060
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_06:2020-02-25,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 mlxlogscore=774 mlxscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 25, 2020, at 9:08 AM, Martin Lau <kafai@fb.com> wrote:
>=20
> On Mon, Feb 24, 2020 at 09:47:33PM -0800, Song Liu wrote:
>> On Fri, Feb 21, 2020 at 10:49 AM Martin KaFai Lau <kafai@fb.com> wrote:
>>>=20
>>> This patch will dump out the bpf_sk_storages of a sk
>>> if the request has the INET_DIAG_REQ_SK_BPF_STORAGES nlattr.
>>>=20
>>> An array of SK_DIAG_BPF_STORAGE_REQ_MAP_FD can be specified in
>>> INET_DIAG_REQ_SK_BPF_STORAGES to select which bpf_sk_storage to dump.
>>> If no map_fd is specified, all bpf_sk_storages of a sk will be dumped.
>> [...]
>>=20
>>> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
[...]
>=20
>>> @@ -1022,8 +1069,11 @@ static int __inet_diag_dump(struct sk_buff *skb,=
 struct netlink_callback *cb,
>>>                            const struct inet_diag_req_v2 *r)
>>> {
>>>        const struct inet_diag_handler *handler;
>>> +       u32 prev_min_dump_alloc;
>>>        int err =3D 0;
>>>=20
>>> +again:
>>> +       prev_min_dump_alloc =3D cb->min_dump_alloc;
>>>        handler =3D inet_diag_lock_handler(r->sdiag_protocol);
>>>        if (!IS_ERR(handler))
>>>                handler->dump(skb, cb, r);
>>> @@ -1031,6 +1081,12 @@ static int __inet_diag_dump(struct sk_buff *skb,=
 struct netlink_callback *cb,
>>>                err =3D PTR_ERR(handler);
>>>        inet_diag_unlock_handler(handler);
>>>=20
>>> +       if (!skb->len && cb->min_dump_alloc > prev_min_dump_alloc) {
>>=20
>> Why do we check for !skb->len here?
> skb contains the info of sk(s) to be dumped to the userspace.
> It may contain no sk info (i.e. !skb->len),  1 sk info, 2 sk info...etc.
> It only retries if there is no sk info and the cb->min_dump_alloc becomes
> larger (together, it means the current skb is not large enough to fit one
> sk info).

I see. Thanks for the explanation.=20

Acked-by: Song Liu <songliubraving@fb.com>=
