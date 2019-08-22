Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F67998AE7
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 07:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730901AbfHVFqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 01:46:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49894 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728497AbfHVFqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 01:46:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7M5ir5M019314;
        Wed, 21 Aug 2019 22:46:11 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uhad3tfrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 22:46:11 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id x7M5kB22020219;
        Wed, 21 Aug 2019 22:46:11 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uhad3tfrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 22:46:11 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 21 Aug
 2019 22:46:10 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.52) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 21 Aug 2019 22:46:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOpIbeWr+d2kArOFKliymLMl3Sy1vZdPTI7rk5l1gP4Q6/n/6R4IfM+hmir+W5vh13Kl7aw7inWXqaJXoUEV4LwpNVdZdKqdn/VzCULgKHH/K8MoCXeXYlPtgRwTkWr3qtKlcz7SC6gAvh7X6mUgkzIE3ucluoSRSd0lUXfCqrA12gGOifrxe/Q4RcScRSfMEDvSRj5HNkQg0xExeQ7iCNv7za15n9uB30es+4qmpj9pnthmbIE6JYxNOtf1p8FYxNQv8bjzX3Es6qqkDnOPSRpQSTxp1uQ5PyY07BkXc85aoANZJcwSEeMV4AqIqb3+xIOuHi70baeBVRkM+sXpsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnrP6+rnJW01k77rCTRlDYX89ljwYhpMir2IH8MtSsY=;
 b=FAXlHzfep9ADutqpd++Vpmf/Oc1Ds+3zp6midw5RwHwvi4PyMLKUBtihaDYaPb82pVI/NwsVY40P7oFvBPhwkJV1GhMlI3zQiTW50XGRXfK5yU32ewLNVn8IazjbjSBCE/qQ6fETC4na0IinekXGip0NRHiXMxqUy12sDH11qYNXJTMpKGx/TX0cbrxvEZsh5rnzDCDCOQL2A1M09Xy+aKpjWoMXNhNaBC4IC4TOVaFx6ZbC9IiRpp8A18x8OqCgDSRGPZWQvXRnjaQyAgIDfN3sJQB25faYZmdYyP2yqfgaFJiksnIh7iURxTQTJLaqKxsL49x7YYf3wWEnFf2dYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnrP6+rnJW01k77rCTRlDYX89ljwYhpMir2IH8MtSsY=;
 b=TvxqXK8Wt3CaBev/4tU3ScxZmj5nS7tbaHE6N34wLjFKr63zigGKtXvtksll0s1C75u6PRifgAF0Sr55SY2WnaDjIu97fUlERGjXC1IaVFx6AxTnGewWS3fG+hRVxyTD/MhoS6CN9kUIy+P/eFYFn2du77KtjKXljQmpovO/6+k=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB3215.namprd18.prod.outlook.com (10.255.236.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 05:46:07 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 05:46:07 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
CC:     Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>
Subject: RE: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
Thread-Topic: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
Thread-Index: AQHVV7/ZmldgulT65kmEtBsRoL+bcqcFVU2AgAFBwpA=
Date:   Thu, 22 Aug 2019 05:46:07 +0000
Message-ID: <MN2PR18MB2528511CEFCBC2BE07947BAAD3A50@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190820163112.50818-1-andriy.shevchenko@linux.intel.com>
 <1a3e6660-10d2-e66c-2880-24af64c7f120@linux.alibaba.com>
 <20190821092541.GW30120@smile.fi.intel.com>
In-Reply-To: <20190821092541.GW30120@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2402:3a80:52c:5247:9c86:6b60:b861:fd67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07662af0-b63c-4187-da30-08d726c4073a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB3215;
x-ms-traffictypediagnostic: MN2PR18MB3215:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB32152471459951084982C81DD3A50@MN2PR18MB3215.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(189003)(13464003)(199004)(76176011)(7696005)(102836004)(229853002)(316002)(53546011)(486006)(2906002)(6116002)(476003)(99286004)(74316002)(8676002)(54906003)(305945005)(6506007)(446003)(11346002)(186003)(46003)(110136005)(7736002)(4326008)(81166006)(81156014)(71190400001)(25786009)(71200400001)(52536014)(5660300002)(6246003)(33656002)(53936002)(9686003)(55016002)(6436002)(66476007)(66556008)(66946007)(66446008)(76116006)(64756008)(8936002)(256004)(478600001)(14444005)(14454004)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3215;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IvfSQ7WiE13+56Ad/6nNjq5UfGOgXz4cD11jjCNjmgxeQ/JkHLb8ZIP4/n10nF9/WQ6QHDFmjt8pKTXxAcbms7HQ7G7I4ILnh8CvHor20LTLgC+4Y9b3Cbmr6jjdduvhJ3BjeIrNU7zW3oG5IRSbd9aakEVpImhgW90yRw7BGVq9DnEXRaGl5hmSJOJqKSmIRnpau+363EnUEMHN7I8C4tQyDX0D3GAzJuHar0An6RS6l31rpq2whWO+GOnvpJUyBLs+uRzg6t3tM8Uiz76ODcj/g3BVEU+u/NQ37Huf0KWSFg2gUvfvkCLdg6hBOTn3MXz6CV7IFaAXytNTEI5rmUEqA5RrYTPLYeZ+g7u409ANCO7ik9hA9238jNdSGxAtDvlr3rUJqyhVx+zYzOAMjR/nxZOMiD0P7yQdqXVP0lE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 07662af0-b63c-4187-da30-08d726c4073a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 05:46:07.1218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aQs90TL/1jz26cy+IvqQoz6+k2crqKPqEmubmswWUplvpGwGWJGPMzYQdK3N2sZADKm2cZTKSxfmnZQMEkFF1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3215
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-22_04:2019-08-19,2019-08-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Andy Shevchenko
> Sent: Wednesday, August 21, 2019 2:56 PM
> To: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com>; Joel Becker <jlbec@evilplan.org>;
> ocfs2-devel@oss.oracle.com; Ariel Elior <aelior@marvell.com>; Sudarsana
> Reddy Kalluru <skalluru@marvell.com>; GR-everest-linux-l2 <GR-everest-
> linux-l2@marvell.com>; David S. Miller <davem@davemloft.net>;
> netdev@vger.kernel.org; Colin Ian King <colin.king@canonical.com>
> Subject: Re: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for
> wider use
>=20
> On Wed, Aug 21, 2019 at 09:29:04AM +0800, Joseph Qi wrote:
> > On 19/8/21 00:31, Andy Shevchenko wrote:
> > > There are users already and will be more of BITS_TO_BYTES() macro.
> > > Move it to bitops.h for wider use.
> > >
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > ---
> > >  drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h | 1 -
> > >  fs/ocfs2/dlm/dlmcommon.h                         | 4 ----
> > >  include/linux/bitops.h                           | 1 +
> > >  3 files changed, 1 insertion(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > > b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > > index 066765fbef06..0a59a09ef82f 100644
> > > --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > > +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > > @@ -296,7 +296,6 @@ static inline void bnx2x_dcb_config_qm(struct
> bnx2x *bp, enum cos_mode mode,
> > >   *    possible, the driver should only write the valid vnics into th=
e internal
> > >   *    ram according to the appropriate port mode.
> > >   */
> > > -#define BITS_TO_BYTES(x) ((x)/8)>
> > I don't think this is a equivalent replace, or it is in fact wrong
> > before?
>=20
> I was thinking about this one and there are two applications:
> - calculus of the amount of structures of certain type per PAGE
>   (obviously off-by-one error in the original code IIUC purpose of
> STRUCT_SIZE)
> - calculus of some threshold based on line speed in bytes per second
>   (I dunno it will have any difference on the Gbs / 100 MBs speeds)
>=20
I see that both the implementations (existing vs new) yield same value for =
standard speeds 10G (i.e.,10000), 1G (1000) that device supports. Hence the=
 change look to be ok.

> > >  /* CMNG constants, as derived from system spec calculations */
> > >
> > > diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> > > index aaf24548b02a..0463dce65bb2 100644
> > > --- a/fs/ocfs2/dlm/dlmcommon.h
> > > +++ b/fs/ocfs2/dlm/dlmcommon.h
> > > @@ -688,10 +688,6 @@ struct dlm_begin_reco
> > >  	__be32 pad2;
> > >  };
> > >
> > > -
> > > -#define BITS_PER_BYTE 8
> > > -#define BITS_TO_BYTES(bits)
> > > (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
> > > -
> > For ocfs2 part, it looks good to me.
> > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>=20
> Thanks!
>=20
> >
> > >  struct dlm_query_join_request
> > >  {
> > >  	u8 node_idx;
> > > diff --git a/include/linux/bitops.h b/include/linux/bitops.h index
> > > cf074bce3eb3..79d80f5ddf7b 100644
> > > --- a/include/linux/bitops.h
> > > +++ b/include/linux/bitops.h
> > > @@ -5,6 +5,7 @@
> > >  #include <linux/bits.h>
> > >
> > >  #define BITS_PER_TYPE(type) (sizeof(type) * BITS_PER_BYTE)
> > > +#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
> > >  #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr,
> BITS_PER_TYPE(long))
> > >
> > >  extern unsigned int __sw_hweight8(unsigned int w);
> > >
>=20
> --
> With Best Regards,
> Andy Shevchenko
>=20

