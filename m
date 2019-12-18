Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B72125310
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfLRUTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:19:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34022 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbfLRUTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:19:54 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIKGHrd006188;
        Wed, 18 Dec 2019 12:19:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5Tibem/iydgesLYWpKxAuKFUKEc5XbKJhz/PpRKlgBY=;
 b=nm+j2W1r1UrSHL4+tMAFIo5/ptThoUBkOXGMgRY3ibFiOMlCTOMtGuMMVqAowajLdydj
 EOsXiT45KQDjFLqRvwTVMqYD9rAvEtzgUouElltk0yY7vpSgry6/C9Po/Z6NB6ZKybNa
 KRxMqmtIsXXoXtoe3e2CadTeHneRkjhgjDw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wyqv4h4kb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 12:19:39 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 18 Dec 2019 12:19:38 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 18 Dec 2019 12:19:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWHUt5oBMp74myxQFRrD5MvxkQb+TPi7o90Nf3uZQyos3HxMj41FmW993IOkQQ7Nx0RRHIkdTSthAB7A32j94QBy1c6BS4wRy6s5gzYEFsg3Qvb8fA3JPVvIc6hdp/UbTufb750EwH1FzGRg/qc3542MG4dULnCerihWqCOlS6Jx77QEpjwn4TTFOFLod+PQ/7U5PfKIyeZ3H5hwzigIfr9CFwJs1+qTtgSJKi8i/wEN3Bn9utRYSdCH1Lbj6buS4xSxVx7aFjcXVQby9V4faQ1oAWSFj683HVUy5sT1PMZTO5PBmipkFkz74wh9JTbGU0ANFmxoror4YhAHljhlnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Tibem/iydgesLYWpKxAuKFUKEc5XbKJhz/PpRKlgBY=;
 b=nAWRDEMqzGZngpccOWw+PF5psalA36RlkP14kGbdbdXb+AzTFTzl6VdV3WfP0JVO8pVoLDkZ7vEG2nxKUTs/rcPY6UmAJyULDbCOkakuyOJTvNJbHO9IMw8TQBU+sPYl7u+KfDFcu01FIcyUbFTkxrhyCW+b8FTfi9YSE/I/UBZwxydE+w6FhVeEM9HXk4GNEB00Shrho5WL7yLvwyJ12QDvV2tBgG5LXWgROzDEU/W9Eb9gAklP2pEG660K4xVJVCTUQqTYtea20PRhHRtFjQxa3pQKrInhTvTfF/ZNDpEyUxlZ5vqgXAlkITHXS+mZ3RMAy53ZZq76E+AXY2LzkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Tibem/iydgesLYWpKxAuKFUKEc5XbKJhz/PpRKlgBY=;
 b=P+K3HdaDvEoF2M9hjJUp1+nNKxtBB1YBURpZ/tyZsiLVNXAVaRN1HC6Mon8/2cV1Mj4VLyNul5qnf7slsBes5+5tjVjcyHJul4zDeKnrro3Jyko4a59RgUe0JoQ8zWqcxaVoOHy4ViMHhnf7Yscjumy+XbArt08VjoG39BHavvQ=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3455.namprd15.prod.outlook.com (20.179.21.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 20:19:37 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 20:19:37 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
Thread-Topic: [PATCH bpf-next 11/13] bpf: libbpf: Add STRUCT_OPS support
Thread-Index: AQHVshgyWEoHfLDvE0Suwi3j+8Waaae/PFiAgABCBoCAAJ92gIAAEJoAgAALPQCAACMQgA==
Date:   Wed, 18 Dec 2019 20:19:37 +0000
Message-ID: <20191218201933.2ixhiz3n6zw75eg7@kafai-mbp.dhcp.thefacebook.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004803.1653618-1-kafai@fb.com>
 <CAEf4BzbJoso7A0dn=xhOkFMOcKqZ6wYp=XoqGiL+FO+0VKqh5g@mail.gmail.com>
 <20191218070341.fd2ypexmeca5cefa@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzaGcM6ose=2DJJO1qkRkiqEPR7gU4GizCvffADo5M29wA@mail.gmail.com>
 <20191218173350.nll5766abgkptjac@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzboyRio_KaQtd2eOqmH+x0FPfYp_CDfnUzv4H698j_wsQ@mail.gmail.com>
In-Reply-To: <CAEf4BzboyRio_KaQtd2eOqmH+x0FPfYp_CDfnUzv4H698j_wsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0080.namprd05.prod.outlook.com
 (2603:10b6:102:2::48) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::afeb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c825af51-acab-42fa-2309-08d783f79aa0
x-ms-traffictypediagnostic: MN2PR15MB3455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3455E5C2FE1271477A5B8974D5530@MN2PR15MB3455.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(366004)(396003)(39860400002)(199004)(189003)(9686003)(6512007)(86362001)(64756008)(66446008)(52116002)(5660300002)(4326008)(6486002)(478600001)(316002)(71200400001)(186003)(66556008)(66476007)(66946007)(6506007)(54906003)(1076003)(81156014)(81166006)(8936002)(6916009)(8676002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3455;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2zxhW3UAxtmOqHZqWRrCFM1+yplp7Nm5LxplFbNabmY+MUIHmODpIkNmct4KqEX0wWqWCH5blR4ryKX/xmlZn2xiZ3pOPe+52xlDtgIoj4ecMP7swU4SE9c0YYouHC7i4yICNMC2TGCASRRO9ewXX3w/TF08xg1Vp5pXFnKErUq5Emyj/4y1+zb6MnVBKkSJQOzvFdZEQtrje1Ucmd9KTXSS+iJ8pPxV8QGQVNEHVHPaehP2EadfIvyxNg3LpdL8wkRg/7Urfduf3q8SJux0rZEqUCtTbpAfQwp5zaGEoqtG5oAZYuhuXzoPxSfnFkGXRv812gKrAibvifY/dNZ6bhVcfYOlu5KAjN1px1X+QNgWuaLQUeRmSMoeo4vG9ZOd1WJry/JtPeoOxoD4myRtHW1Cz5QeA3IflRRgBGUElh/SeQ86NixYMHyQTjN/7yRr
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5EFAEA9761433C41B224931D15379E1E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c825af51-acab-42fa-2309-08d783f79aa0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 20:19:37.1720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FOIrO+ZWg2tnPIIfXeZxgBYlLFOh7SKU0t7fet+H9v9KryfXnHC7x1PNG4FnSGXn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_06:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=887 mlxscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 10:14:04AM -0800, Andrii Nakryiko wrote:
[ ... ]
>=20
> Where we do have problem is with bpf_link__destroy() unconditionally
> also detaching whatever was attached (tracepoint, kprobe, or whatever
> was done to create bpf_link in the first place). Now,
> bpf_link__destroy() has to be called by user (or skeleton) to at least
> free up malloc()'ed structs. But it appears that it's not always
> desirable that upon bpf_link destruction underlying BPF program gets
> detached. I think this will be the case for xdp and others as well.
>=20
> I think the good and generic way to go about this is to have this as a
> general concept of destroying the link without detaching BPF programs.
> E.g., what if we have new API call `void bpf_link__unlink()`, which
> will mark that link as not requiring to detach underlying BPF program.
> When bpf_link__destroy() is called later, it will just free resources
> allocated to maintain bpf_link itself, but won't detach any BPF
> programs/resources.
>=20
> With this, user will have to explicitly specify that he doesn't want
> to detach even when skeleton/link is destroyed. If we get consensus on
> this, I can add support for this to all the existing bpf_links and you
> can build on that?
Keeping the current struct_ops unreg mechanism (i.e.
bpf_struct_ops__unregister(), to be renamed) and
having a way to opt-out sounds good to me.  Thanks.
