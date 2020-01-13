Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C82B139D38
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgAMXXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:23:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11204 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729254AbgAMXXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 18:23:13 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00DNN2gT021005;
        Mon, 13 Jan 2020 15:23:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hcjVUhJD2qVPP8mnTSuqq1ucfhEHMqlJ362trvPW4yQ=;
 b=KZ17z+/VNLH7SC6f885B4uhFdz88Wt4+FGG93YiNFSNYt7rXmcnUeERJEEY1RC2/2nRy
 EesdQLbt0yYBPnfvf9XYqga1O4vpk7835RrZkpQVnLEiG9P4QlAY/HHkshJ5Vh6OYoH9
 RGYkIFc5KAOO3kruH9h1FW3s1eLSuWSHhCg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xfxt477q4-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 15:23:07 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 13 Jan 2020 15:23:02 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 13 Jan 2020 15:23:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VaUTwVtW2OJev+463d0UeOOrPMUqpl/kk5VANz5DSrMdT9tXVau2JSYUpHLBoyzB2btIAk/tr583MMKQpzJNGqX1YiasWBRH7ifp9IYJJeWLsArMEAiSSijINhxvLdhQkTNhPNHG3ViY2id0kZD+gZY463IuMzS5LWoRJzZTFNXefIWbw9yB32dauweDdmI0Gkpaz9poC0ay32WHGa29pNqbjZ3S3KvFIdEBhkmUYMdTrn24mM3uQNWnmOeNPnTPkppSwJ2TsIrlzOfZrxTuWSvhfkl2D5eSlGtwgPAPdrr4S5QFfAz1YSonC1eFDboVYZfbuXBRDXZqo2Sr9/pm5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcjVUhJD2qVPP8mnTSuqq1ucfhEHMqlJ362trvPW4yQ=;
 b=f4c0wmcOTukN+OpOUA50D3kdGSB8tK57/en0gggGy9GKJzkdWElxSorCYrS3U6Eg27xtqOYxeeGKPuKOjYaUiVBOK6hURmhgn4GpTEWNnbZ8ACp6WkWpd67AMZjdkJrzyX0QU4Rrm+LtsWcLarOcvgKsNH9QOYUMhAcDtneYgcKrT1x1PucgSGvzFhhDBeLDaScyUGb57C035nYqSx9Rex6EEGIG1KHLXCmQXzw1QYnH1pi4R2Z3xwGM+UBCBSy4l335d62CiZUKPF6nGwQbFkUbHXthuoxifl0lNpk/a+XecXiC+zwBZnINOND8d1xQT7M3QmCKs1CORE7Kq+M6vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcjVUhJD2qVPP8mnTSuqq1ucfhEHMqlJ362trvPW4yQ=;
 b=gHbaRQCT0lvrmZSXoncTlV/fHjeFWhsZSrKKUa5ffhECp6i7922GqSiHjhCTdizf+JwXooOBoWwwr/qBCACdEBx1+kLFpEHiKa/yaDS9srJRLTn0RInYFEQvQDoJ+FcJ5k9wxDER2w/cDK62n3tPukUsbRkgm7nQvzyVqk++jKY=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3581.namprd15.prod.outlook.com (52.132.172.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 23:23:01 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 23:23:01 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::1:34fe) by MWHPR14CA0045.namprd14.prod.outlook.com (2603:10b6:300:12b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.13 via Frontend Transport; Mon, 13 Jan 2020 23:22:59 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 04/11] tcp_bpf: Don't let child socket inherit
 parent protocol ops on copy
Thread-Topic: [PATCH bpf-next v2 04/11] tcp_bpf: Don't let child socket
 inherit parent protocol ops on copy
Thread-Index: AQHVx6PcokuSwoBS/kqqpxf+r/8DbKfpMPEAgAAFTwCAAAs/gA==
Date:   Mon, 13 Jan 2020 23:23:01 +0000
Message-ID: <20200113232257.y5cvyvs2lpzpgidr@kafai-mbp.dhcp.thefacebook.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
 <20200110105027.257877-5-jakub@cloudflare.com>
 <20200113222342.suypc3rgib7xbkjl@kafai-mbp.dhcp.thefacebook.com>
 <87ftgjrna5.fsf@cloudflare.com>
In-Reply-To: <87ftgjrna5.fsf@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0045.namprd14.prod.outlook.com
 (2603:10b6:300:12b::31) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:34fe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f5a3238-08fa-4460-99c1-08d7987f8823
x-ms-traffictypediagnostic: MN2PR15MB3581:
x-microsoft-antispam-prvs: <MN2PR15MB3581AB63290A8E592E9D3CB9D5350@MN2PR15MB3581.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(376002)(366004)(346002)(189003)(199004)(86362001)(6916009)(316002)(66446008)(1076003)(54906003)(6506007)(478600001)(53546011)(6666004)(55016002)(186003)(9686003)(71200400001)(64756008)(66556008)(66946007)(52116002)(7696005)(2906002)(8676002)(8936002)(81156014)(81166006)(5660300002)(16526019)(4326008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3581;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yBEOzig0TGmKCTMwWrfWmFjU+FE0L7AQV3ia8ZEQlcB0HKHz6uilOOgSzBn9K06FUb8MdyYAWxSdAHQnuDhxjWZAcnJ+8hMphpRdEC3dBZ1RZw0R+ZCt5p/7eJy5p8P3IgsJqVFSrDy7K9o1jY384/t9yK3vCxhnmvVCJ/EcfcKgrK0JhIpEH7tyeuxnQwdwFXvcjRv8yeHGKDfrqAbHvq2rW7xrOE/POdqeJfVXG+xsbPFa0CyVWdh80oRpd6ra7Hh3Ivd3HOYRcExUw26NYpf5roW+nuFdqxLCFoCgaQtJGcXdbWu4dzZoPEiXC5aPCHJrXeqs7720h6knAI8tZBFpLKAj1T7MmV9RiSUQJ6JKrfKLvuZ9YHbPKtbmFJ9/9wV5ffWEXl87tjZN2F5vrnr5wAhMSERqXOr7k/Y8QpL306m0vyxt8NWn+1pJ0tJM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C19D2E785C15D649ACA11043F99B3637@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5a3238-08fa-4460-99c1-08d7987f8823
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 23:23:01.0846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l2756KZ4NB+0XgHa6oxoMtc0e2PI7NvWRTCJlpr3V0Ajr+MHih4oPdhHAakIjKbE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3581
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_08:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 mlxlogscore=816 impostorscore=0 priorityscore=1501
 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 11:42:42PM +0100, Jakub Sitnicki wrote:
> On Mon, Jan 13, 2020 at 11:23 PM CET, Martin Lau wrote:
> > On Fri, Jan 10, 2020 at 11:50:20AM +0100, Jakub Sitnicki wrote:
> >> Prepare for cloning listening sockets that have their protocol callbac=
ks
> >> overridden by sk_msg. Child sockets must not inherit parent callbacks =
that
> >> access state stored in sk_user_data owned by the parent.
> >>
> >> Restore the child socket protocol callbacks before the it gets hashed =
and
> >> any of the callbacks can get invoked.
> >>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >>  include/net/tcp.h        |  1 +
> >>  net/ipv4/tcp_bpf.c       | 13 +++++++++++++
> >>  net/ipv4/tcp_minisocks.c |  2 ++
> >>  3 files changed, 16 insertions(+)
> >>
> >> diff --git a/include/net/tcp.h b/include/net/tcp.h
> >> index 9dd975be7fdf..7cbf9465bb10 100644
> >> --- a/include/net/tcp.h
> >> +++ b/include/net/tcp.h
> >> @@ -2181,6 +2181,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msgh=
dr *msg, size_t len,
> >>  		    int nonblock, int flags, int *addr_len);
> >>  int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
> >>  		      struct msghdr *msg, int len, int flags);
> >> +void tcp_bpf_clone(const struct sock *sk, struct sock *child);
> >>
> >>  /* Call BPF_SOCK_OPS program that returns an int. If the return value
> >>   * is < 0, then the BPF op failed (for example if the loaded BPF
> >> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> >> index f6c83747c71e..6f96320fb7cf 100644
> >> --- a/net/ipv4/tcp_bpf.c
> >> +++ b/net/ipv4/tcp_bpf.c
> >> @@ -586,6 +586,19 @@ static void tcp_bpf_close(struct sock *sk, long t=
imeout)
> >>  	saved_close(sk, timeout);
> >>  }
> >>
> >> +/* If a child got cloned from a listening socket that had tcp_bpf
> >> + * protocol callbacks installed, we need to restore the callbacks to
> >> + * the default ones because the child does not inherit the psock stat=
e
> >> + * that tcp_bpf callbacks expect.
> >> + */
> >> +void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
> >> +{
> >> +	struct proto *prot =3D newsk->sk_prot;
> >> +
> >> +	if (prot->recvmsg =3D=3D tcp_bpf_recvmsg)
> > A question not related to this patch (may be it is more for patch 6).
> >
> > How tcp_bpf_recvmsg may be used for a listening sock (sk here)?
>=20
> It can't be used. It's a way of checking if sock has tcp_bpf callbacks
> that I copied from sk_psock_get_checked:
ic.  It seems only tcp_bpf_close and tcp_bpf_unhash may be useful.
Asking because it intuitively made me think how tcp_bpf_recvmsg/sendmsg/...=
etc
may be used since they are also set to listening sk.

>=20
> static inline struct sk_psock *sk_psock_get_checked(struct sock *sk)
> {
> 	struct sk_psock *psock;
>=20
> 	rcu_read_lock();
> 	psock =3D sk_psock(sk);
> 	if (psock) {
> 		if (sk->sk_prot->recvmsg !=3D tcp_bpf_recvmsg) {
> 			psock =3D ERR_PTR(-EBUSY);
> 			goto out;
> 		}
>         ...
>=20
> This makes me think that perhaps it deserves a well-named helper.
>=20
> >
> >> +		newsk->sk_prot =3D sk->sk_prot_creator;
> >> +}
> >> +
