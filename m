Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E0A13B930
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 06:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgAOFqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 00:46:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11894 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbgAOFqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 00:46:32 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00F5d3QC009208;
        Tue, 14 Jan 2020 21:46:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4lD3+jxgFaxDhY4Bb8K2ABVt4vPpVvy932m1iaNNPB4=;
 b=ezkJrIfSk2YS4z4mS/qxeM137VDUKh+b3hvVwBYqnv6/Goqi303Y4RInQlc2Ud15ySjc
 vscHVW4PGaWe4BLK5pUQqTHYunOOfAaNB66/H6avHJIbREgEY4SePxr73ArrjBHxWxby
 /trDXi4b2Cezdf+O2dEMJAq27b6r86Lw9OU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhaj2d9mw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Jan 2020 21:46:15 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 14 Jan 2020 21:46:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwrspRzFTOax16OeaQMqXM3QlFRtTsQUuExCj6hIl8RXlGPdo8L2COP3li38jNA19lcvALbaOMT9Xh7pAQ4Y/PVYTXjRfdmw0/iDZ1T74Ktehcu3U/YCDbLw0kDc7rB5c4rSWLo+DJIcTWkWpF8O8W9+whkwpjRz86d2FzDNHVOuSX51i5GEeSpwe14cLtL1kVvx6JVhUkqRWcnie9P0VmVOXDMUI59Q8ZVvQpFSuVCJmKD7HLi7OzrbOub1MRiQuAjwZPgtHo5/TLLv6GpPdqdn78Fc7vxEwbVS8Eq82oi7bDbDQg0wYyeGB+7MO4HumsEruBLdyee3NbS1IFP4/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lD3+jxgFaxDhY4Bb8K2ABVt4vPpVvy932m1iaNNPB4=;
 b=WFgEMjuhA8nrKmgDgZcdxMzg0jCOFx8ROGcsFNL17BVZeGNkDt2ORUyRLUH+BykQ2Tq2ohHL9FprP0tcFKv9iODS/lnd1cTK8G9ooFEHB/9qbitD7uSVxdVkra4BcV/qmMMeVFk2J+eO5pjQLWz/IoTDo/Fo4BwC+jdbhztdyYrQso0hn0fdsqZnP8iT9wdgTkQx4UJmTzytv/L5FSrw3G+kvqtS86UkkVjUQcFfp3UzFCPkN9VUQbuvwXtrZMhYztrW8c8UuLlw3lHouR3gxIDHiUJ52pZqNa+CCjtUK2jkXSHkMphgpWR56SFboMXBoWWqg7HLa4Yyi7C8XUJB1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lD3+jxgFaxDhY4Bb8K2ABVt4vPpVvy932m1iaNNPB4=;
 b=F2wuxqvnijKNU6alFtUOQxftAy+8oAfU0Vnp2XY0LkomQkvAXdS1Z1tySLsQQg7CtKXBJgZukCHUKKJPSOZSqdHtfMQvFN3TA3m9/ZX0243D0od/4Ih7Uba8q5WDDzfg+VSiAaeIAviMD9+/bcYWg1jSLufQOxiMm1GN9ecNvd8=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3358.namprd15.prod.outlook.com (20.178.255.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 15 Jan 2020 05:46:00 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 05:46:00 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::55) by MWHPR22CA0039.namprd22.prod.outlook.com (2603:10b6:300:69::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 05:45:58 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Paul Chaignon <paul.chaignon@orange.com>
Subject: Re: [PATCH bpf-next 1/5] bpftool: Fix a leak of btf object
Thread-Topic: [PATCH bpf-next 1/5] bpftool: Fix a leak of btf object
Thread-Index: AQHVy0CcGU1wwbV1C0WwVNWoyIearqfrN5kA
Date:   Wed, 15 Jan 2020 05:46:00 +0000
Message-ID: <20200115054554.sb4nrpmvaulnqya3@kafai-mbp.dhcp.thefacebook.com>
References: <20200114224358.3027079-1-kafai@fb.com>
 <20200114224400.3027140-1-kafai@fb.com>
 <CAEf4BzZd-NmpJqYStpDTSAFmN=EDCLftqoYBaSAKECOY8ooR_w@mail.gmail.com>
In-Reply-To: <CAEf4BzZd-NmpJqYStpDTSAFmN=EDCLftqoYBaSAKECOY8ooR_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0039.namprd22.prod.outlook.com
 (2603:10b6:300:69::25) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6ee2439-8cee-4b7e-51ff-08d7997e332d
x-ms-traffictypediagnostic: MN2PR15MB3358:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB335862285A90E1D92DF396C8D5370@MN2PR15MB3358.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(396003)(136003)(346002)(376002)(189003)(199004)(5660300002)(8676002)(478600001)(1076003)(8936002)(6666004)(86362001)(81156014)(81166006)(66946007)(16526019)(55016002)(64756008)(66446008)(66556008)(66476007)(186003)(53546011)(6506007)(54906003)(71200400001)(4326008)(52116002)(7696005)(316002)(2906002)(9686003)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3358;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 06+UkhTUFi4NPSnJTFT31PP/PiM22xngadWxV7KEof/pXN9dcxLcKB7AFmcbwh+5OzkPtuJ+HkA3l6aZtqvaK/rgnJG2U1lvFD1P3IOQWW70kFwWBkmDfOt24eXbdwDJHZxANsOyUnU0EM6Wak06mrMawSwdOALTSE6JIk7CTcOYH50LQv5ar+yGQ+cW8Dog5n0B2neBCD4+ERqjIvUpEMGBiqDOB076bHl6TAAoBTTXYoj7U8AJALYT2HPqWZ8t7cUv++I7FdVc6ccRQbQoPrHEVoT/lmtqGOq3WrpsUMenHlZTZtcVYGWqTlw/LgHCvi3CesWHM/gAytCFaeVa37T7bMezNdt17+yvw4MakUC7IKASuMpsQus13kvZrOk/BUXqOc1k0nvTlI/b112whGfGo+8JBwMBaYdz0GWppARgAC83uG8TJ1XLxt1BVYOq
Content-Type: text/plain; charset="us-ascii"
Content-ID: <167702DB855F654AA094103A43E500AE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ee2439-8cee-4b7e-51ff-08d7997e332d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 05:46:00.3459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b+WGtNulrcUGYXfg30pyCCFluXG/X4ojHyeqMpZTjaFDW+x3MXqW7jYD+4pKC2d5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3358
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001150045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 05:10:03PM -0800, Andrii Nakryiko wrote:
> On Tue, Jan 14, 2020 at 2:44 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > When testing a map has btf or not, maps_have_btf() tests it by actually
> > getting a btf_fd from sys_bpf(BPF_BTF_GET_FD_BY_ID). However, it
> > forgot to btf__free() it.
> >
> > In maps_have_btf() stage, there is no need to test it by really
> > calling sys_bpf(BPF_BTF_GET_FD_BY_ID). Testing non zero
> > info.btf_id is good enough.
> >
> > Also, the err_close case is unnecessary, and also causes double
> > close() because the calling func do_dump() will close() all fds again.
> >
> > Fixes: 99f9863a0c45 ("bpftool: Match maps by name")
> > Cc: Paul Chaignon <paul.chaignon@orange.com>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
>=20
> this is clearly a simplification, but isn't do_dump still buggy? see belo=
w
>=20
> >  tools/bpf/bpftool/map.c | 16 ++--------------
> >  1 file changed, 2 insertions(+), 14 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> > index c01f76fa6876..e00e9e19d6b7 100644
> > --- a/tools/bpf/bpftool/map.c
> > +++ b/tools/bpf/bpftool/map.c
> > @@ -915,32 +915,20 @@ static int maps_have_btf(int *fds, int nb_fds)
> >  {
> >         struct bpf_map_info info =3D {};
> >         __u32 len =3D sizeof(info);
> > -       struct btf *btf =3D NULL;
> >         int err, i;
> >
> >         for (i =3D 0; i < nb_fds; i++) {
> >                 err =3D bpf_obj_get_info_by_fd(fds[i], &info, &len);
> >                 if (err) {
> >                         p_err("can't get map info: %s", strerror(errno)=
);
> > -                       goto err_close;
> > -               }
> > -
> > -               err =3D btf__get_from_id(info.btf_id, &btf);
> > -               if (err) {
> > -                       p_err("failed to get btf");
> > -                       goto err_close;
> > +                       return -1;
> >                 }
> >
> > -               if (!btf)
> > +               if (!info.btf_id)
> >                         return 0;
>=20
> if info.btf_id is non-zero, shouldn't we immediately return 1 and be
> done with it?
No.  maps_have_btf() returns 1 only if all the maps have btf.

>=20
> I'm also worried about do_dump logic. What's the behavior when some
> maps do have BTF and some don't? Should we use btf_writer for all,
> some or none maps for that case?
For plain_text, btf output is either for all or for none.
It is the intention of the "Fixes" patch if I read it correctly,
and it is kept as is in this bug fix.
It will become clear by doing a plain text dump on maps with and
without btf.  They are very different.

Can the output format for with and without BTF somehow merged for
plain text?  May be if it is still common to have no-BTF map
going forward but how this may look like will need another
discussion.

> I'd expect we'd use BTF info for
> those maps that have BTF and fall back to raw output for those that
> don't, but I'm not sure that how code behaves right now.
The json_output is doing what you described, print BTF info
whenever available.

>=20
> Maybe Paul can clarify...
>=20
>=20
> >         }
> >
> >         return 1;
> > -
> > -err_close:
> > -       for (; i < nb_fds; i++)
> > -               close(fds[i]);
> > -       return -1;
> >  }
> >
> >  static int
> > --
> > 2.17.1
> >
