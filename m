Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B9D433DBD
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 19:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhJSRul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 13:50:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4496 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234749AbhJSRuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 13:50:40 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JGSb9d025417;
        Tue, 19 Oct 2021 10:48:23 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bt1jtrc2n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 10:48:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PssDxABGWZj3i+juNDqkTq55QKrwDQb21BUoanDokiHSBdvgHWQMEICrP5yTpTcUBEPHYy4u+PuANqdFFdK/xSQ+PuAopreQuk7/HWvDTOhzH5arKBERZHbRcNbeWaWHhiSe/h3njXk5NJlU9u9IuPcBbq1IyS4Wz2sNTaXLVlcJYtKV+vfD4tP7k71AOW3cJ/XYM/qsGALYIR/zFBj8ry3w2Jwseey46nnd0BYDjP5EBR/uUkWHnIsFg+a7fLJj+TPULkLpFJ8HP8nWq1gPLbVof+9wqfM4/NJ+VPZr3kpuEUfQuJUv3CCHkPV9O/0DLo8V/keqEmtV3xbxC5/arA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTavmUfACzRi+l2hENXthDHDZ49fAsMlDnqBFmYH7AM=;
 b=LXiAYP7NavcywrgsAlGkXcU0ZJB/BkOas1Ko3OEli0T5rzqsNHVbMh9zM8Q5KQhclGLnXVxT47Qg6NdnYZ3o5AHDH4kfn+lWg895r2f1Y+WSRIo4lGd1G+W8YNtEfrOKJO2RzjF7zrrGL0XhzOjLewSmsz92h2AwNK7HCxdLNNoWsloSBxsVY6fTolaJPlf0NHaiXG+OyITK9XZZX48m6rzPRTk13J4k6CA0MnijHmllG3RjdELda5H7srJjCVHvGJoTjUm6LNGIMlEidxox1eTcY+FTzhyPcoDIkE0XAlkKOnac8yqrpfoJah9AvcjApSXZdHkgvdhO6zY9wYOTpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTavmUfACzRi+l2hENXthDHDZ49fAsMlDnqBFmYH7AM=;
 b=F729es/CknrRyjNgPx966gjt44cLMZ8XdHbdHSjRa1TOQEKVfTWNhYL9Ks+go4Z8Jd2E66KJ7wEIdeUOx2jX+lmVtVlp7yDD1P/e/ZBcut1clPcqkMHYtTEHuCxAnXe7T/8ozXrQyBeAjpAANduiXRQSyBvtpNweHrwBxiLp+O0=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BY5PR18MB3265.namprd18.prod.outlook.com (2603:10b6:a03:194::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Tue, 19 Oct
 2021 17:48:19 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%9]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 17:48:19 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: marvell: prestera: add firmware v4.0
 support
Thread-Topic: [PATCH net-next v2] net: marvell: prestera: add firmware v4.0
 support
Thread-Index: AQHXxRGAwM925CxqVkui2CjLJlZaww==
Date:   Tue, 19 Oct 2021 17:48:19 +0000
Message-ID: <SJ0PR18MB4009EC646887EC524A02E62AB2BD9@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1634623424-15011-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <YW6+r9u2a9k6wKF+@lunn.ch>
 <SJ0PR18MB40099BBA546BFBE941B969DCB2BD9@SJ0PR18MB4009.namprd18.prod.outlook.com>
 <YW7v7VjQF6ZZOb/L@lunn.ch>
In-Reply-To: <YW7v7VjQF6ZZOb/L@lunn.ch>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 7bc4a500-651b-9764-0557-3cfb9967b00c
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45d6c7b1-d228-4201-1334-08d99328a313
x-ms-traffictypediagnostic: BY5PR18MB3265:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BY5PR18MB3265F4E298B70BB0A0253E75B2BD9@BY5PR18MB3265.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EqnvIw8OuaPtcuyyUdr/9NtvGKcUBoqrmr6ViFXnM+f108XfHM9OcggLOYZwNlRjK7k30f5nHLoZR9neysSG+BLtfZajNBhCw3oO5JmdkKiuBTVo7+3aCZLAryCgZKPUEcaCJ64kWHwdwt1/qIXLMnMaM5vJ5sNWLCNQmozfobYADSfwyLt8lcMLGYrJ7alydFLjyoPtmdEdbopKIsIwR/HjNYg0W/lI8OldVej42jttILZ1E4rbBb8IzGoKamk70zuy81jM52ROZx1VkxQUhBQ2ejua7ZML/aUi98H5QWIx+L0CaOST11aPIgscdeiGQy3xVfakwvoWs891qfYU6NN0kK6l94VS2v9j5rondVE4d87EUrZG9FGDy5GjTe/yQ2NXw+wM04B8v95n909jVC7LcyoA1nJgHC5AvOnDHSHlgB6qHDLDo5izWqJMZgUyyXeI1ajqQUo9/IrtbgfkqH1yPx3QPcQSbXHf0cnn0r6P4CN6v7t/CEBrlfx1uHflrxR/EqQHSppN+6nnxySHI13Ioin0Zo4QOw3xHlH9ks3wq1Y3jdx6A4TrE2jV+1wUVkVapAGxr2XMzJq5/Eq+MyRykVlQ84zQvwGs9qXKULktYSTFSc3ljXh1FMPtY2TQLsDkTJnltdB6g+4KO2X4+qfa5OAYjvxADOOYMfQt4V3+h+oWlYZ3NpsTObe2g+yeXejIfonGVQ/JBTdm59rByw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(186003)(8936002)(26005)(4326008)(6506007)(66946007)(66556008)(5660300002)(66446008)(64756008)(66476007)(508600001)(316002)(2906002)(6916009)(7696005)(54906003)(9686003)(55016002)(52536014)(76116006)(122000001)(38100700002)(83380400001)(86362001)(71200400001)(33656002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?EwL9iYu+u1pxWZKyfuY2cudVUwlGho3OFdFLgqB60XVTobTiR+AYFOS7QL?=
 =?iso-8859-1?Q?cq9wdMmQQCVomE0czYOqP4BnkAPQN5sCgC3NKC9FTncX72yGgV/+vbVaWL?=
 =?iso-8859-1?Q?scFncfuLd1vRWFYRXgyoCKqvFnESRjQejDQnz1UrejkYqzTUYIzecHCMWN?=
 =?iso-8859-1?Q?Fvbz1wXNnDoIJKhpvY97TbvmgfUaudMIzGjrLtU2/qOIEuHoQK8MQV/49X?=
 =?iso-8859-1?Q?vR80AUGlvaQ4ygAdPWDTcopfvAtxxQfUeo6Fsndo2JQAe3lw0xkSiY5Rfl?=
 =?iso-8859-1?Q?61e+aIHXMnEq4YxzbJbDMry7H9Fnm0MLSRTbOZU0dzVrG1AFhOfi6BXJj2?=
 =?iso-8859-1?Q?FEDNi8ElxoyFRYoP9+QoSReGBZwoJUZikQwGbxJjEcGudsvufRv41+TjnN?=
 =?iso-8859-1?Q?NuIZ/qQLWLqM4b3W6zELP0tWe59RK2oixk7Ptwcc3Oah6X4DTwuDd8DtEe?=
 =?iso-8859-1?Q?tK4joIyzYscrK0uKLYcivTxvqX6EfVG0IK9oM+t2npN85c7mhBBb0eO9TM?=
 =?iso-8859-1?Q?E4uHEbbjmnY5oysIuTHmCFfUvDZXQUTVHH/G1wKkwgvP+cWSFXoD1O7f1V?=
 =?iso-8859-1?Q?6nKLRnmpJ3cSTYSVgx/gMyhFu8bMxjPtto/qA5qce7BbQwjkctDGied6OE?=
 =?iso-8859-1?Q?E5FOXHMLU5DxzVqTYOjNZbWe5drSggol1tU+SEs85dZChZt958+CZS9lC+?=
 =?iso-8859-1?Q?GXjKbbwXcXH4OGiBWZ8fN3MoEhxcO5byz3CgJIQw9mDJUT4aJXsHpGn0kC?=
 =?iso-8859-1?Q?9eUQf8jMAUHpmFPw1l4039IXqLPlXz84QIlOU1ef9sosqqvXaHPDqeLQh/?=
 =?iso-8859-1?Q?dPJVOfDvIMDaWZG8a9oducPhmPioBEwmVihlXT2h0VNVqWcU3q/CBSPyDQ?=
 =?iso-8859-1?Q?a4NPtlMnpFQCad+GgnE9u5wQ71M+FtgECilBksPHQuohmTCgf2IA3cmVic?=
 =?iso-8859-1?Q?Hdz9jZcGcqlLAxnObRjt0J6pOy+dN/CMUyP0azjsGwrVYhWXhNaP7zHHaJ?=
 =?iso-8859-1?Q?vJCP3Ak+oJyjyjlxUVLfC7E0YT1/WgwvR2aG1FPFHK0YRca4L1gRmIobbQ?=
 =?iso-8859-1?Q?8ns8Wv1OF/J1cMTkcYzPLFLnohYyPapq8K+UojcKrGJLlDWAl+yOWxz1TX?=
 =?iso-8859-1?Q?Ojc1W7TIl8s0IMOctu7nb+OJ7LNOYxvQreWdzEhs1MhI9EsE0NphL9f2cO?=
 =?iso-8859-1?Q?qR8WrOcOwZKFje0su7geGKydERLNXlnysbwi4Ty8s6Jtr3ryFOawf5pwMW?=
 =?iso-8859-1?Q?xgyy9JcX2NleXmLwqwQkSy8LL1UjWKWeUVLrTteJWmVfHfLUZkVi5d7kCX?=
 =?iso-8859-1?Q?CYeWM1dmjEqSFnQpDhk5l1YPZpRmK8uG52GpPS8YNk4NkqluGxQmqk8weU?=
 =?iso-8859-1?Q?ERTKbfA/fIKWsYnH9cqgia8/7hldUW/MpE8QhXhhkTSPbId4SIxMyboUMb?=
 =?iso-8859-1?Q?Bkyajw226hthjKISczydE0FvGdAYulUftfbM9Eh54nYmr/G+auOZMMF282?=
 =?iso-8859-1?Q?FknudayhzG3g6nNUV1s5dEPxlPzgNEVuTnCb8OF14oadP8uWC5igkn4WTa?=
 =?iso-8859-1?Q?KBPTJSUo6v6vVSEjQmyEuNeY3tygzdbjCyeyWasAxemRMVEvJmi5cZ9jbf?=
 =?iso-8859-1?Q?IEgSFb/PShjbrgqsTBsjj/fVCf3cph8hQwQP+IjIe+8dhclGA76LdHfw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d6c7b1-d228-4201-1334-08d99328a313
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2021 17:48:19.2810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r4TjDVpKEbeOCrpuJSs8BoV9nrldJLM/Wn14jths0eH4T0MAxH/i6wNHysbpfEprSAvfeUtcdg9hGTn7CTdb4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3265
X-Proofpoint-GUID: 7lhijnT4vo8h1mGAAQYfXsmrWTxrF5is
X-Proofpoint-ORIG-GUID: 7lhijnT4vo8h1mGAAQYfXsmrWTxrF5is
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,=0A=
=0A=
> > - Major changes have been made to new v4.0 FW ABI to add support of new=
 features,=0A=
> >   introduce the stability of the FW ABI and ensure better forward compa=
tibility=0A=
> >   for the future vesrions.=0A=
> =0A=
> So this point needs bring out in the commit message. You need to explain =
why you think you will never need another ABI break. How your new design al=
lows extensible, what you have fixed in your old design which has causes tw=
o ABI breaks.=0A=
=0A=
With the current set of features that v4.0 FW ABI supports, we don't expect=
 any changes because of stable ABI that was defined and tested through long=
 period of time. Also, the ABI may be extended in case of new features, but=
 it will not break the backward compatibility.=0A=
=0A=
- Most of the changes are related to L1 ABI, where MAC and PHY API configur=
ation are splitted.=0A=
- ACL ABI has been splitted to low-level TCAM and Counters ABI to provide m=
ore HW ACL capabilities for future driver versions.=0A=
=0A=
I will update the commit message accordingly with the description as a patc=
h-set v3.=0A=
=0A=
> =0A=
> Given this is the second time you have broken the ABI, i need convincing.=
=0A=
> =0A=
> > - All current platforms using this driver have dedicated OOB mgmt port,=
 thus the=0A=
> >   user still be able to do upgrade of the FW. So, no "Bricks in broom c=
losets" :).=0A=
> =0A=
> So your cabling guidelines suggest a dedicated Ethernet cable from the br=
oom closet to the NOC for the OOB port? I suspect most users ignore this, a=
nd do management over the network. They only use the OOB port when they hav=
e bricked the device because they installed a kernel upgrade over the netwo=
rk, without upgrading the firmware.=0A=
> =0A=
> 	Andrew=0A=
=0A=
Regards,=0A=
Volodymyr=
