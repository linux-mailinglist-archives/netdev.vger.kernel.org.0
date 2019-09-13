Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F036B21F3
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388414AbfIMO3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 10:29:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53752 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387600AbfIMO3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 10:29:50 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DEPJx3006602;
        Fri, 13 Sep 2019 07:29:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8j0xp3DK0aK5l0UvfFrHpx7CNX0bKow9LoF3sT0i1G8=;
 b=MR7lAKw1O74ditMAUi9bmGw+w2MamCrS61zuivIW68S/beTfnAH3ipPfNcEPPhjsPvIP
 fOZSQ2E3SaBsL+JccgWoBodVpB9kql1jNiYq5higa4WaKdviGdFDD/eJ9QAql8MqcM7a
 rY17/T1kVND03J/E17k4z80A7urxqI1KPkE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uytd8c9mg-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 07:29:46 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 07:29:44 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 07:29:44 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 07:29:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZitIWnhLYXud8a55TmdQz1CEYDhpxrSoGwSBA2qgYdYzv9dzQyIqOaurIJNhamiUuvbG5o1pUPgn6GYnphlbsn0ApUM3Q4fu0wmK/woG7DSG2O3DjhVVOeZVECwdZg4EPGVIHheo7U09LLHaIAjgnk5gYL6cakQpIv0kMycKVj/q9yTcy8fG05QUzNW0NKkhWlEUfzJopN8Jho7nCUyps0E1844YwaCZKvJt4VjG8lWb3HgU8IIegB9Yk63qAJ3NZyfVUlqjucW+y6ZWuPTMNeN4g6IDxap23wOjQZyCmgvUsJnPqMgJv7fkEkNoSuBgAQTn7eCPgBpizGwf1/BnrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8j0xp3DK0aK5l0UvfFrHpx7CNX0bKow9LoF3sT0i1G8=;
 b=B/db8Mtk9Rz87x90ppQCzcjLDt0eeh522Jqle7Kf/TL40dlZVSRlQIi8gC7h1VaZ3xvg7FgO/vYUHr+xQusmzChaQNSYPIBL//0Bn0V2Sc9/Yd5lt+2OyzHi6stcMx2vZsM5VB/qfgmF6dwvIn73Im3b9qfncW/4uIKxBrBHxBBpJTA7UJ1FoRE+eMZH06RV6qLXKEOC7RV9iT9ygLVlfZcq1Cb1bBh/Eco4v3DbzIqAxPi5itWvnWfnoNaU1mXnQlVXMKPCmKF6Nx5SwnlIaxSO90nnvbEtdubRcJUrIN8ShDA//xSjEVwNbYEVst9w5FhP4PQPnW7w3pX0mz1Pag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8j0xp3DK0aK5l0UvfFrHpx7CNX0bKow9LoF3sT0i1G8=;
 b=i7gyzRkDjrceHQiAyXo0wlct0+eglQvIf/dO6GNkKLfit3KvpBjV7b5HTXdoPIxrvGR3SvjGFx76aglRg0KDpk1ivqtl0UdIYkcEy5R+P0oU0xXM9O9RYzwSe3DcwWgyMJHmFMGTRCEXKq8YLYJEO3DbcZsbOmYk9XTf2S8xDb8=
Received: from CY4PR15MB1207.namprd15.prod.outlook.com (10.172.180.17) by
 CY4PR15MB1349.namprd15.prod.outlook.com (10.172.157.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Fri, 13 Sep 2019 14:29:43 +0000
Received: from CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3]) by CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3%6]) with mapi id 15.20.2241.025; Fri, 13 Sep 2019
 14:29:43 +0000
From:   Thomas Higdon <tph@fb.com>
To:     Dave Taht <dave.taht@gmail.com>
CC:     Neal Cardwell <ncardwell@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Dave Jones" <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH v3 2/2] tcp: Add rcv_wnd to TCP_INFO
Thread-Topic: [PATCH v3 2/2] tcp: Add rcv_wnd to TCP_INFO
Thread-Index: AQHVaPC1u+0FA2Nc1EGWGQFEck7I86cnNhwAgACM/YCAAepbAA==
Date:   Fri, 13 Sep 2019 14:29:43 +0000
Message-ID: <20190913142936.GA84687@tph-mbp>
References: <20190911223148.89808-1-tph@fb.com>
 <20190911223148.89808-2-tph@fb.com>
 <CADVnQynNiTEAmA-++JL7kMeht+dzfh2b==R_UJnEdnX3W=3k8g@mail.gmail.com>
 <CAA93jw7q71mpenRMD0dWiVNap1WKD6O4+GCBagcPa5OhHTMErw@mail.gmail.com>
In-Reply-To: <CAA93jw7q71mpenRMD0dWiVNap1WKD6O4+GCBagcPa5OhHTMErw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR11CA0068.namprd11.prod.outlook.com
 (2603:10b6:404:f7::30) To CY4PR15MB1207.namprd15.prod.outlook.com
 (2603:10b6:903:110::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:500::3:79fa]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8a7e072-bb03-4104-8c54-08d73856d162
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1349;
x-ms-traffictypediagnostic: CY4PR15MB1349:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1349B885AD95D71722D7D1DBDDB30@CY4PR15MB1349.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(366004)(39860400002)(396003)(346002)(376002)(199004)(189003)(66476007)(6436002)(66556008)(5660300002)(53546011)(6512007)(33716001)(64756008)(1076003)(6506007)(66446008)(71190400001)(6246003)(99286004)(52116002)(11346002)(476003)(9686003)(6116002)(71200400001)(478600001)(6486002)(229853002)(53936002)(14454004)(7736002)(186003)(386003)(316002)(76176011)(256004)(486006)(46003)(6916009)(54906003)(446003)(2906002)(81156014)(8676002)(25786009)(81166006)(86362001)(33656002)(4326008)(66946007)(8936002)(305945005)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1349;H:CY4PR15MB1207.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZAs63+4s0ACJ3UbW2r1eoxasNY+LfTKB0MQpB4DVQ4yrlXMG/2HLlTKoBAtfN7yyIsoDxFamcNrO62Qu31a8Bef7vZmTxIXFKWQq9eUqvPCeSMV3bFpQ/Ba++plI9OlGFfWb3tvZ2OB+j+Y6iF0Qok6a7ao3H57G1AKkKCawmugFFM4mD8/QttAnv8nSrLg56/ai30hb4JKmxsCTujecOjYPCWNlKUT3da7cJiVOa9Df787apdACg0rM6vhgEopZEVv0ii//slm9Q918qv93IrnHOQow9G2Scb72UobHzT2V6fy25csk9Gjlpwwbz9VD8tK+fZotRBFOMt6C2h9EpcIN31RzrJrPKhgEyp/tK78e2HGCwoZiEnb+rueUotl7hvCj6jlZRrv2s5zvtw3W67OBjC5Yps/GMNYivhAKddA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <47565335DD75484C9728471FEB5A6018@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a7e072-bb03-4104-8c54-08d73856d162
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 14:29:43.2072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YbMcc29JW2W3F8jrAO/cdOWx3iRUJDMRdfYDJDkKxtiPW2N89xlDsnG8sYI07QCy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1349
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_07:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 bulkscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 10:14:33AM +0100, Dave Taht wrote:
> On Thu, Sep 12, 2019 at 1:59 AM Neal Cardwell <ncardwell@google.com> wrot=
e:
> >
> > On Wed, Sep 11, 2019 at 6:32 PM Thomas Higdon <tph@fb.com> wrote:
> > >
> > > Neal Cardwell mentioned that rcv_wnd would be useful for helping
> > > diagnose whether a flow is receive-window-limited at a given instant.
> > >
> > > This serves the purpose of adding an additional __u32 to avoid the
> > > would-be hole caused by the addition of the tcpi_rcvi_ooopack field.
> > >
> > > Signed-off-by: Thomas Higdon <tph@fb.com>
> > > ---
> >
> > Thanks, Thomas.
> >
> > I know that when I mentioned this before I mentioned the idea of both
> > tp->snd_wnd (send-side receive window) and tp->rcv_wnd (receive-side
> > receive window) in tcp_info, and did not express a preference between
> > the two. Now that we are faced with a decision between the two,
> > personally I think it would be a little more useful to start with
> > tp->snd_wnd. :-)
> >
> > Two main reasons:
> >
> > (1) Usually when we're diagnosing TCP performance problems, we do so
> > from the sender, since the sender makes most of the
> > performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
> > From the sender-side the thing that would be most useful is to see
> > tp->snd_wnd, the receive window that the receiver has advertised to
> > the sender.
>=20
> I am under the impression, that particularly in the mobile space, that
> network behavior
> is often governed by rcv_wnd. At least, there's been so many papers on
> this that I'd
> tended to assume so.
>=20
> Given a desire to do both vars, is there a *third* u32 we could add to
> fill in the next hole? :)
> ecn marks?

Neal makes some good points -- there is a fair amount of existing
information for deriving receive window. It seems like snd_wnd would be
more valuable at this moment. For the purpose of pairing up these __u32s
to get something we can commit, I propose that we go with
the rcv_ooopack/snd_wnd pair for now, and when something comes up later,
one might consider pairing up rcv_wnd.
