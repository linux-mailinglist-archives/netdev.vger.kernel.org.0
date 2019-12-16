Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0D71219F6
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfLPTa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:30:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26832 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbfLPTa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:30:59 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGJPOqg015753;
        Mon, 16 Dec 2019 11:30:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NLV0f8r6pAKfQ5g6lA4EnXqzBrLSPCs08HV5qC1YUxc=;
 b=KfIcO7s+PxWQprtrQcRHqQHZDQCxSLmmKF+/QFfCaG+557ByddWA7UTave+WqT6SgOnR
 UBJbwHhZcAHyuEyD1DMXXPsilSAKWD3PbdjnOEZPdOQIu0WMgkJgZV/FwmutqNpOss5e
 l9Bvv1NroOzFXgAQZ/gPKzvrYXcsEgbetTs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwtq14ag1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Dec 2019 11:30:43 -0800
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 11:30:42 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 11:30:42 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 11:30:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZN36sP/0299fuiRPQPefL4Skze9cqCJlktnm2wCUB1K2EWll3FqUqxMX2L/Tv45e79AdXkloGpVY5Xpzx0//6AzFbw4OmEH3jL1ujHCaSt44Q477VOPF2/urUdWVvjZa7x3UIhanrnh27EjkbxApTwTtFBHPLX3vcfVaOaZYktPLZM7RNRXk4dTUPHGbb5NmLbC7Pxe9OGHwofxSDlbf/+BAjGqrPVbSI+B6mE+QYn0Z58ZWUOY24XDYyIhSbhM8xoVQL9KII5cx3dvriXj8yKSH4DIOw5zkEqLseCYuC3/HzP1DO9LrT6Pbp4yoVvrMOXKovONs6k49VXGWN98GBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLV0f8r6pAKfQ5g6lA4EnXqzBrLSPCs08HV5qC1YUxc=;
 b=LqlEgIRFAfpYyEshKA1W6W0yg79qvWKsqVQ9BrKJ2fvPkRZx4GrsF9eFiKSoiTYWpjzPVBRObJHj9N2IdNzMlxR6jH7oqBbLgu/x5Qwotaul1BjMB9I0QjlhjI7lnSY2Z2Q4n/nsJF9P+ZOToRa/qOh/inRQV41KrizOHnWeIHRsvgwB2gEViNof/7wEzpg8bDoWVNhO/RkFj+33DuplUWW3nAMVh/mVLDz9IwPYGvHiK2ui+IAX8By68UzyrlUR1UdYJxtDgshv/jOSPMepC5CHN24Ic4bWjkQgG3SWK7Uh2Dmr1Q+1v7QcD1DuvGSDyHKemlc4RrqzYWC6Gb361g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLV0f8r6pAKfQ5g6lA4EnXqzBrLSPCs08HV5qC1YUxc=;
 b=TliymCelxckA6SrY0YLOFDK7Ethk0RGILPI/35EjhJAKWDvZKMswens7eXSxmXZtgISCrWZoYVTfvlKZhyUBSxfdHYhBcYrCyfz1ksjKRh4g15FXc/NtaQ6X3eohlC+G0HL3I6hb2MHXaGxVDOHP+M6ImbF0CCi7r3A9Jb1jBYY=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3712.namprd15.prod.outlook.com (52.132.174.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 19:30:41 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 19:30:41 +0000
From:   Martin Lau <kafai@fb.com>
To:     Neal Cardwell <ncardwell@google.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Thread-Topic: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
Thread-Index: AQHVsiI0ihgHNw98P02gRrT2dQLnz6e6BCYAgAMmK4A=
Date:   Mon, 16 Dec 2019 19:30:41 +0000
Message-ID: <20191216193037.y44zy5zxjko5qt3s@kafai-mbp.dhcp.thefacebook.com>
References: <20191214004737.1652076-1-kafai@fb.com>
 <20191214004758.1653342-1-kafai@fb.com>
 <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com>
 <CADVnQy=soQ8KhuUWEQj0n2ge3a43OSgAKS95bmBtp090jqbM_w@mail.gmail.com>
In-Reply-To: <CADVnQy=soQ8KhuUWEQj0n2ge3a43OSgAKS95bmBtp090jqbM_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0066.namprd14.prod.outlook.com
 (2603:10b6:300:81::28) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:71b2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eaec5169-17bf-4180-7d05-08d7825e6fb8
x-ms-traffictypediagnostic: MN2PR15MB3712:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3712BC56F6C237A4035F97D8D5510@MN2PR15MB3712.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(39860400002)(136003)(366004)(51914003)(189003)(199004)(8936002)(71200400001)(478600001)(81166006)(81156014)(6916009)(8676002)(6512007)(9686003)(66446008)(64756008)(66556008)(1076003)(66476007)(5660300002)(54906003)(316002)(86362001)(52116002)(53546011)(186003)(66946007)(6506007)(6486002)(4326008)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3712;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bfpKslu39COzU9JS42wM6hPSmt216GDA6gFOkrrufzq1XjPB+f+qAXWkIQoKVd1cjzAXqbk7AdCRkLm7cOv2ArIpaX92siX+dYoFRU23RSaBHEeAOyQ5t4A0CvcKkBOEN1xLoqPwo4cWiGb3yhp+3CTKotJek+fRMobtVj8lHGeoYJgMxjyveDo5bDc0WLh2OTJsnF6onoa4gMFrtBLK7QUxohSxT3tea/ABX4dqsFjHLw4TIEwfAyOSCb2TyRyUpC4qC0Qd0sH2W2OvwNuCuvPCEFoxCQxThAkbJaICpkOTVy3NRluCe9RzKfmecU2/k+V0QwuoQsQTjR2d7P1XdjPKP+Y/IVUe+n/W+BsWKqQMD8Y/tiLh7nBNHXaN5vXtIXMMadYUzhEBZhJveApxOGihPos24eIrUVvJrXCPCXT93jAth7mWnJHJPZEp4+OBQfawPqAd30BJGu8p7C3uFI8RdbFcM/4GCT7G3wrrPVhzXMLjnlyIS9z2AO4zROgP
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B3B80FEAA29CB0428ED0FE27D6E59842@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eaec5169-17bf-4180-7d05-08d7825e6fb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 19:30:41.2091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zHgUyAZSfN44ZnCLBOHgaydioPyFeOIYx3umxCDnIYhqx6DsdlCmUm66uTiyDSo5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3712
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 spamscore=0 mlxlogscore=581
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 02:25:14PM -0500, Neal Cardwell wrote:
> On Fri, Dec 13, 2019 at 9:00 PM Eric Dumazet <eric.dumazet@gmail.com> wro=
te:
> >
> >
> >
> > On 12/13/19 4:47 PM, Martin KaFai Lau wrote:
> > > This patch adds a helper to handle jiffies.  Some of the
> > > tcp_sock's timing is stored in jiffies.  Although things
> > > could be deduced by CONFIG_HZ, having an easy way to get
> > > jiffies will make the later bpf-tcp-cc implementation easier.
> > >
> >
> > ...
> >
> > > +
> > > +BPF_CALL_2(bpf_jiffies, u64, in, u64, flags)
> > > +{
> > > +     if (!flags)
> > > +             return get_jiffies_64();
> > > +
> > > +     if (flags & BPF_F_NS_TO_JIFFIES) {
> > > +             return nsecs_to_jiffies(in);
> > > +     } else if (flags & BPF_F_JIFFIES_TO_NS) {
> > > +             if (!in)
> > > +                     in =3D get_jiffies_64();
> > > +             return jiffies_to_nsecs(in);
> > > +     }
> > > +
> > > +     return 0;
> > > +}
> >
> > This looks a bit convoluted :)
> >
> > Note that we could possibly change net/ipv4/tcp_cubic.c to no longer us=
e jiffies at all.
> >
> > We have in tp->tcp_mstamp an accurate timestamp (in usec) that can be c=
onverted to ms.
>=20
> If the jiffies functionality stays, how about 3 simple functions that
> correspond to the underlying C functions, perhaps something like:
>=20
>   bpf_nsecs_to_jiffies(nsecs)
>   bpf_jiffies_to_nsecs(jiffies)
>   bpf_get_jiffies_64()
>=20
> Separate functions might be easier to read/maintain (and may even be
> faster, given the corresponding reduction in branches).
Yes.  It could be different bpf helpers.

I will take another look on these.
I may not need the nsecs <=3D> jiffies with CONFIG_HZ and
Andrii's recent extern var support.  The first attempt I tried
end-up a lot of codes on the bpf_prog side.  I may not have done
it right.  I will give it another try on this side.

Thanks for the feedbacks!
