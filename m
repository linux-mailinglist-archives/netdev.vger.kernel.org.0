Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947C4B3FB0
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 19:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732238AbfIPRmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 13:42:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6458 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732173AbfIPRmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 13:42:53 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8GHbpHf017834;
        Mon, 16 Sep 2019 10:42:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=f3rfe45VYeIVgJx+XgEDinlkXLzGtFl5YtTP5uR8X+o=;
 b=Wvzjt+A9IvBc9J97vgnSH2hz0cEGFfz6GvOPcn25cEax1YeoqadVkduupVJBb2TFvw/n
 RktH33WP7EuITOzPDalgQY8IQI91ImexaQnRdCEgoNkm89XtvTEkBo+i7cieK6k9yVXU
 cJ3VE/n9FQdvBfyXIpR6RpucS8GiBzEKO1E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2v1fwsnnud-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Sep 2019 10:42:48 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Sep 2019 10:42:40 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Sep 2019 10:42:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwORh2BhK7rR57PJ0EJIusoryqcQAXKS7WNZqODdVcPkSafzoEmZp5N2Vjf55XPFY0Ods7gXfQxJIl8ebHt8hyq1JplahSAsRADwkDUa4V+atagevI105vt+0BRc0+6rBvw8OO5H14PXjcwQrRvTsDcv5y7X8ac0Vo6m1d/INfwkeRCYW+MfRDMRlyQC+49kalAQE/oWz4+pco2GRYovXOI/CwAjUaJ5mIrbt6GtKcvy2WqW1wJVVHIB70Jtk9aMntGsGwxM3Tt6IHYCYdch43J5Jffk/MLyPclrmHGyo6X82pjx+41oNkAR4fhCjQF/lyc9FqNYuGH2sZ3MY88ojA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3rfe45VYeIVgJx+XgEDinlkXLzGtFl5YtTP5uR8X+o=;
 b=DGNk8aUrRGUgA572gWIis5pN8emZ/vcqYNyOa8TDjun8am90ZVLpsYv9eT1foUO587YZpFEdsBnnK62d+pKDvvHjJ0qktcsOKt+btMuxm/aAtSHMA9hEFJTixup0eq6ZIMLm4vaP4RFvR7Y2oZZAREv7JfD4HH2C+2sYFmGiOUXJ/uiUaAQakC7/C7DD1kvWXPgvdOeNyxCbwUljisFVfe9/WCKLbpP9tv2uHqL0EJNhEENLbmI6s5osXm0SU+tBMN3lm3noRXT4SL5gz6Tep7MdOG3XNsSqfuwkDouzAbEeA5zuaMm9gJuPAl9i5ZMWsu8Mb8u19OxmPLMj6F1kwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3rfe45VYeIVgJx+XgEDinlkXLzGtFl5YtTP5uR8X+o=;
 b=Mu8PDAMA4cEpycTdlHYAFczJ5QLf4tt8S1SEUpfRKQ+og9mh8HLQGykr0KoqojoIMfjeJnK0bRxy6WhEBc2KH9tytKMCbdsegt0nDvbg3o7emR0fHXz0aZI172b+jYZV5RmSgp5bVgRzgnM1QHGR1SxWEUl3/htmf97uF/vXQ+o=
Received: from CY4PR15MB1207.namprd15.prod.outlook.com (10.172.180.17) by
 CY4PR15MB1383.namprd15.prod.outlook.com (10.172.159.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.23; Mon, 16 Sep 2019 17:42:40 +0000
Received: from CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3]) by CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3%6]) with mapi id 15.20.2263.023; Mon, 16 Sep 2019
 17:42:40 +0000
From:   Thomas Higdon <tph@fb.com>
To:     Neal Cardwell <ncardwell@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH v5 1/2] tcp: Add TCP_INFO counter for packets received
 out-of-order
Thread-Topic: [PATCH v5 1/2] tcp: Add TCP_INFO counter for packets received
 out-of-order
Thread-Index: AQHVaopDJcZ18s3ro0Kvu9zbXZ4gtKcrUTWAgANF5AA=
Date:   Mon, 16 Sep 2019 17:42:39 +0000
Message-ID: <20190916174220.GA41212@tph-mbp>
References: <20190913232332.44036-1-tph@fb.com>
 <CADVnQynfwJ8HWstz-HAa7AMOGRhDC7nqKwMCKpe2Fvm7kUQgkA@mail.gmail.com>
In-Reply-To: <CADVnQynfwJ8HWstz-HAa7AMOGRhDC7nqKwMCKpe2Fvm7kUQgkA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR1301CA0032.namprd13.prod.outlook.com
 (2603:10b6:405:29::45) To CY4PR15MB1207.namprd15.prod.outlook.com
 (2603:10b6:903:110::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c091:500::2:a3cb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd8de920-f882-4a76-8995-08d73acd44d2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR15MB1383;
x-ms-traffictypediagnostic: CY4PR15MB1383:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1383A3359B24453B44EF4334DD8C0@CY4PR15MB1383.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(136003)(366004)(346002)(376002)(396003)(55674003)(189003)(199004)(1076003)(81156014)(6246003)(8676002)(966005)(81166006)(478600001)(14454004)(9686003)(6512007)(7736002)(305945005)(6306002)(6436002)(25786009)(4326008)(53936002)(6486002)(6916009)(33656002)(2906002)(8936002)(229853002)(6116002)(99286004)(86362001)(64756008)(66946007)(71200400001)(71190400001)(66556008)(33716001)(66476007)(66446008)(53546011)(102836004)(386003)(446003)(6506007)(5660300002)(46003)(476003)(76176011)(11346002)(52116002)(14444005)(256004)(486006)(316002)(54906003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1383;H:CY4PR15MB1207.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mYU4wtgsm1AQV2neeNhBwA9SNhqScSN8VIicZOkjNola2HZ1Cx3rdOmT8gi72MtvmMaQbQ8oq5nq1Xm7Iohi9z9pqGWr0URycacaOzNFaz/MGU/bZcuBsD/LwPpT1AgKU8k6D/1IqXKQXU5M5U5PDiFX5ioscnUvvt6xDzPtO9N+Ck0vFkW5Cog8/NliB4I1DU0/4/OjH+rQ40WhOH+5XP+/uQuOjMXvnOEfue3zGWqaU8uQT89MKHQSLzlAvFWqWYVJix4RQk9ECWNas+vypJKnohNaiKjARN4YhmIrjiJyYJM9G4H4JXCjFi6A/Twr5DnZup4uS6/Sg19e//gkUq9qj6DsAGQekQENbiQ+RkGxDIx+YarjrpADnBLrAU0nMMvdWBhCLiD3hv3VsdwQQrEuZsjhqGZwqy1m7suY67s=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F41465349153C749999016DFFA76AEE1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bd8de920-f882-4a76-8995-08d73acd44d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 17:42:39.8547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aCFAt0LBOMqvrDCng/TJv81UsKgTmARUZRA8Hx6YPKzUiGlj4oCf7+Lkroga5T3o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1383
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_07:2019-09-11,2019-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=712 spamscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909160175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 11:43:25AM -0400, Neal Cardwell wrote:
> On Fri, Sep 13, 2019 at 7:23 PM Thomas Higdon <tph@fb.com> wrote:
> >
> > For receive-heavy cases on the server-side, we want to track the
> > connection quality for individual client IPs. This counter, similar to
> > the existing system-wide TCPOFOQueue counter in /proc/net/netstat,
> > tracks out-of-order packet reception. By providing this counter in
> > TCP_INFO, it will allow understanding to what degree receive-heavy
> > sockets are experiencing out-of-order delivery and packet drops
> > indicating congestion.
> >
> > Please note that this is similar to the counter in NetBSD TCP_INFO, and
> > has the same name.
> >
> > Also note that we avoid increasing the size of the tcp_sock struct by
> > taking advantage of a hole.
> >
> > Signed-off-by: Thomas Higdon <tph@fb.com>
> > ---
> > changes since v4:
> >  - optimize placement of rcv_ooopack to avoid increasing tcp_sock struc=
t
> >    size
>=20
>=20
> Acked-by: Neal Cardwell <ncardwell@google.com>
>=20
> Thanks, Thomas, for adding this!
>=20
> After this is merged, would you mind sending a patch to add support to
> the "ss" command line tool to print these 2 new fields?
>=20
> My favorite recent example of such a patch to ss is Eric's change:
>   https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/mis=
c/ss.c?id=3D5eead6270a19f00464052d4084f32182cfe027ff

Yes, and thank you for the help in getting this into a good state!

From looking at that "ss" patch, it seems like we would need to wait
until iproute2-next's include/uapi/linux/tcp.h has received a merge from
kernel net-next before we'd be able to apply a patch for "ss" that uses
the new fields.

In the meantime, as you've asked, I will go ahead and send a patch for
iproute2-next's "ss" with the assumption that these tcpinfo changes have
already been merged.
