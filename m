Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC0B1234B5
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 19:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfLQSXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 13:23:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16890 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbfLQSXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 13:23:10 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHIMeaF019078;
        Tue, 17 Dec 2019 10:22:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JvcUnFwWIM3DIgv3X7+Fyn0MOKEI/rzSrowA2OxAwH8=;
 b=qQ/LOcLHy3m1HGsLMJr31+21T2rl8lHSOycQYzwXRXgsO2UTHQOYNCAyz2i3O1rzr8HB
 cuHlIDD+ViY6z0yRor1MHme2hJ+Rs7olU8TAXZj6yzZH/e3etDdv50CfVt7roH2+wat2
 Zk01/LYa6Lja9aKJcef3mzbTxSePM2YrS/4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxcwy65w5-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 10:22:52 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 10:22:33 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 10:22:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhSHlastRViWoNTY5DmPvMVPwOejT1TuMH8tYlIxy6jYinitLr9BoMquysa0PX8lL6hhnDryOVY20q1IPlheX9oiaU8uC5bNL5n/9fPIOjB/TtPoxV1XslwFKL7psTcIVvZqX0ivt4/Lc+x1TvdaslcaHOzgpyjFeAI/7hjietzsEoaMKZhKaXTRJVZ39lHOb7TYBNGs77NMC4x3t2XA9WBLkdAqUlxMEmTFdG71MHh9xjU0z80eVt8T5e6nEJsF2bjTrlvloBCnU4UqStMBvcLRYrH3ZffkDj8o9Spw2xZ6NBEKq10qylkyU5oim8MDY7+3Tswgmz77MDhFMlfldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvcUnFwWIM3DIgv3X7+Fyn0MOKEI/rzSrowA2OxAwH8=;
 b=K+dI+FjzHfW67C/jSWsJpMfb/+hM4UWEcYE2PmUQ7vxu5VG7bMPnsvvK9Q32CrHRTSasaJNIUXxn6YqoFYIUb8hpCXmPybu+lm7dvpfI+KwI6vpSVAS392S1/2VcupbgJTIhH/OcEHP/1ygzYFLia9yBDoFgoLRRFWJAhbd+EH3HO3O2Fle5otv5DEOann6410JrrrlFMNlKRaWY22juOmAia+R4wEsF+uzVcfSwdk4mZydWE30gk+QnJ7yDsmFdIWUkmCL657T+iURXpuw5IAmLNyx12BfxuAWDV0VD49N2bkK7sb0+aU2Y2XnZwkiAr/AZZnzagG9x/LQWvYAABQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvcUnFwWIM3DIgv3X7+Fyn0MOKEI/rzSrowA2OxAwH8=;
 b=KwHzUnuhTUDaUpLBEGx6/OD3pwOfMyNWlt4SiOls1Ed0ValLlWjpbVkm0pdzEbESc72tukKJfm9XZeBg18tTeqNaesnAGXI2+IaOOj5EaULNTmCPrXIjomgpBVfBCapcq8h4iHXFI8QcSqhSOPXOtwDla6WThvM5xfL+aiz/8hI=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3424.namprd15.prod.outlook.com (20.179.23.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 18:22:31 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 18:22:31 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Thread-Topic: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Thread-Index: AQHVsiI0ihgHNw98P02gRrT2dQLnz6e6BCYAgAP+9ICAAKaBAA==
Date:   Tue, 17 Dec 2019 18:22:31 +0000
Message-ID: <20191217182228.icbttiozdcmveutq@kafai-mbp.dhcp.thefacebook.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004758.1653342-1-kafai@fb.com>
 <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com>
 <CADVnQy=soQ8KhuUWEQj0n2ge3a43OSgAKS95bmBtp090jqbM_w@mail.gmail.com>
 <87o8w7fjd4.fsf@cloudflare.com>
In-Reply-To: <87o8w7fjd4.fsf@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0056.namprd17.prod.outlook.com
 (2603:10b6:300:93::18) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:77de]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4b643c3-cd3b-470d-2609-08d7831e149f
x-ms-traffictypediagnostic: MN2PR15MB3424:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB34247F8A2E3959F47C1FF4E4D5500@MN2PR15MB3424.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(396003)(346002)(376002)(366004)(199004)(189003)(4326008)(6916009)(66446008)(64756008)(66556008)(66476007)(5660300002)(3716004)(316002)(52116002)(1076003)(8936002)(8676002)(86362001)(6486002)(6506007)(66946007)(2906002)(186003)(81166006)(71200400001)(53546011)(81156014)(6512007)(9686003)(54906003)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3424;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: roEfc20808k68Pr7lX39VJyM+Lf3t8dAJBka7muS3P4eZ30Rszr2kdMKqMfc3G+JJoqmur28MpjwqW0Y18GXBTMSRE8tCnlFi5x1dNK9qtHAZt78duSoM+WpzZXEnCFkVrCPFuU0HckveZJUil4qAsbAVhsJR6ltaXz9s3OkQO2I0vRzIniOEokpD5hKmrjmeNmiNx0vTkErBxEvUXT/85pDshtrZWB6TcKvwzuqEifruDRGlPM/yK0FNmaAToEZF555dg9/Mdw4okWi/QWBI39MpnCFTktR+ayQ8k3AhXzR19mQy44uTzAAfzK8RDzuGNtaGydzGhFS4VSDjvnXSWq7ZA8caOTgw42XDHQ6n1GVcnXdGqaNJ3mR5F2DusMzCBhBkpq8e3ifqAJ5gw9DV7V/dySlqw6nOAY/kF2jbXFvhMqEoL2aSWQuwi1d6hT0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <65C18DE0A523E640BE79333D95E7AAA9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b643c3-cd3b-470d-2609-08d7831e149f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 18:22:31.6844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZrGO7Yb7VxULAG1NQSY84gzJ6Gsa0on1t9oUqD1X+LOlpgdSdCehntqGpdaCnah+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3424
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_03:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=617 phishscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912170144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 09:26:31AM +0100, Jakub Sitnicki wrote:
> On Sat, Dec 14, 2019 at 08:25 PM CET, Neal Cardwell wrote:
> > On Fri, Dec 13, 2019 at 9:00 PM Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
> >>
> >>
> >>
> >> On 12/13/19 4:47 PM, Martin KaFai Lau wrote:
> >> > This patch adds a helper to handle jiffies.  Some of the
> >> > tcp_sock's timing is stored in jiffies.  Although things
> >> > could be deduced by CONFIG_HZ, having an easy way to get
> >> > jiffies will make the later bpf-tcp-cc implementation easier.
> >> >
> >>
> >> ...
> >>
> >> > +
> >> > +BPF_CALL_2(bpf_jiffies, u64, in, u64, flags)
> >> > +{
> >> > +     if (!flags)
> >> > +             return get_jiffies_64();
> >> > +
> >> > +     if (flags & BPF_F_NS_TO_JIFFIES) {
> >> > +             return nsecs_to_jiffies(in);
> >> > +     } else if (flags & BPF_F_JIFFIES_TO_NS) {
> >> > +             if (!in)
> >> > +                     in =3D get_jiffies_64();
> >> > +             return jiffies_to_nsecs(in);
> >> > +     }
> >> > +
> >> > +     return 0;
> >> > +}
> >>
> >> This looks a bit convoluted :)
> >>
> >> Note that we could possibly change net/ipv4/tcp_cubic.c to no longer u=
se jiffies at all.
> >>
> >> We have in tp->tcp_mstamp an accurate timestamp (in usec) that can be =
converted to ms.
> >
> > If the jiffies functionality stays, how about 3 simple functions that
> > correspond to the underlying C functions, perhaps something like:
> >
> >   bpf_nsecs_to_jiffies(nsecs)
> >   bpf_jiffies_to_nsecs(jiffies)
> >   bpf_get_jiffies_64()
> >
> > Separate functions might be easier to read/maintain (and may even be
> > faster, given the corresponding reduction in branches).
>=20
> Having bpf_nsecs_to_jiffies() would be also handy for BPF sockops progs
> that configure SYN-RTO timeout (BPF_SOCK_OPS_TIMEOUT_INIT).
>=20
> Right now user-space needs to go look for CONFIG_HZ in /proc/config.gz
Andrii's extern variable work (already landed) allows a bpf_prog
to read CONFIG_HZ as a global variable.  It is the path that I am
pursuing now for jiffies/nsecs conversion without relying on
a helper.
