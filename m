Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADFA22A367
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733285AbgGVX4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:56:45 -0400
Received: from mail-eopbgr690095.outbound.protection.outlook.com ([40.107.69.95]:42049
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733112AbgGVX4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 19:56:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/hbObLSdfxvgejmp16Y2kvSrCmT4lV+Zj9yvaGOqf8Af8NWZjZRh8ABS3Q0i7GeRICWtNyinZIBHOKZ8RuQc9JfPSlZ25qkNR4xzmcihC9FbaonCZTFKFYJlkq8uhOkHIz0nxUu06LiMw7QtNu+krWFIVU+jVGpG5EqG/Pe3SPIaS+ldQk4J8jhK11/6zgHWlRZG27xse+imRaFGUEEshtTz6OjNS7yMim4h/JLo0oGQifJZ+UgmxkdIfVM8pA+40gnXfuJJmDfwJmIQc/jVO6iZIecBlrzkWj7a8JVZPuZNlrYI1XP+Ftq0lvCLCpRFsdJ2GBv7DBwyJ65x4xhBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rv6XjiWUkY7dUz9YDu1m5U02Txpb/4JzoiZ43uhaR3E=;
 b=JPBEWwoE1NcWTuSs4LQVI4GoJW37rnRlS0ZCDwJMLuC/4BeKnxO8Tf7nksgce3pjrVNpxa+ziXWSeqBN/Oz8BOfVN2s+3oLsov5H5WhIL82mkE1G6WHvQKm7/HNTqlFsIBu6zow9FG2j6pP/JlSHUKS+pXrddgQ1Z3KyN2ZtOdxEu/50MYEH7ByzuUndXS4rW1Iz+gUKiNlFnmraOLYI6y9d4jbXkfC46Ht3bUQ3N+jtpI1sLxPdq3DkF9TZLnlSM3d56w4yCAUp4osBcmJuJboj01nEhjCWKAIBhFSUVgKPjj4v6j/O3Fya3tWYXM9moNSB7bvy+Tk+VA7114a25A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rv6XjiWUkY7dUz9YDu1m5U02Txpb/4JzoiZ43uhaR3E=;
 b=PnZThPhWd30bx1BMnuVGuAvrflFhhp2Md7XzAaZzL1kmpCYVxwmYnLs01zPIPjaHOe0CLH0EngkktCBz8/QoRqHDlcPivVKZQJrgZLTU8xP6Nquma+b+pIgRJgptEsmLac9rKiTq99cOOTbSqtWct/JHca3Pb0i37senxYB9uT8=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR2101MB0731.namprd21.prod.outlook.com (2603:10b6:301:81::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.0; Wed, 22 Jul
 2020 23:56:41 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%8]) with mapi id 15.20.3239.005; Wed, 22 Jul 2020
 23:56:41 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RE: [RFC 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Thread-Topic: [RFC 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Thread-Index: AQHWXwAfq8py9R1cgk6EBitVHLoMRqkUP0WwgAAGfoCAAALYQA==
Date:   Wed, 22 Jul 2020 23:56:41 +0000
Message-ID: <MW2PR2101MB10525571DACE6447A8C269B8D7790@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-4-boqun.feng@gmail.com>
 <MW2PR2101MB1052E3D15D411A5DC62A60F2D7790@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <20200722234321.GC35358@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
In-Reply-To: <20200722234321.GC35358@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-22T23:56:39Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f7fc97a8-9fc5-470e-b13c-4ecc7021a1e6;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0baecf83-fc7a-4b50-5db1-08d82e9ae148
x-ms-traffictypediagnostic: MWHPR2101MB0731:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2101MB0731A298183BF5549E3D2041D7790@MWHPR2101MB0731.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xAReN8uuhXI3kbdLMRzVRuQ2oa3cprQXevpKVsoQrw1Al4s2ltOAzdpCoaYGcMBmACvfPlMHTuyU8PIXrvTA8JKF3AcvE712LP3/2nyOVpj6fr/QQpQJm8EJCw+TbMIqLwZ5qMf14l+QCxGRjy9WepZyXgwD03vNtsmDknFRzfKwbsh4HYSkQiw6KafM+FNcpMxxYihfRxlGgJ1jma2cVJesRUShLt8img4lFbPlPFUgL5ay0BPM0g6Z/nnE+TcNk+6xA7YoB6hgm0y402YjxQKKEplu6pMyz4F6yI8PjmlHUmiOKCUZtcUdrCJD4NjC/XDQt372duCBnEh9YkprQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(10290500003)(54906003)(71200400001)(7696005)(5660300002)(66446008)(66946007)(83380400001)(7416002)(76116006)(86362001)(478600001)(64756008)(66556008)(66476007)(186003)(26005)(6506007)(8990500004)(82950400001)(82960400001)(4326008)(8936002)(33656002)(316002)(8676002)(52536014)(6916009)(9686003)(55016002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Nj9QTs01t8dne7QOC5vJHSz94IWf42gh9SGt1KX3v6OthG5M8MRJ+jjlaroCxTkgmuJCTdTXIfPqYm8v9LBVMxLLszDDi/zCM+rJePCQbdZP0xuwr3bNtY4fAIsav8ou08U3QOlplDKI0F7o5+l51rSviEM1CrSdYJAlrHQzCw87P7HQNbGsLIJ06fwEkqoK8es3DiBS8OMBfcvztjPRtcVsSwZ8UhuKd4iogUxmFNvC8cAcSTi57MZy/Tgv4Wfn9DyfVBng0R9HnMhuucJS1A8HXhpyE3aSbcI4KK5fxdpx8LmBZn/a9g655FMGW4eUMLMpv+hL2iJj+bfo4gmpxcze5e3b2w9mkMu5eBaXCrllsCR4nRI/S6KkVQrvC1jSotbJ6dW3cOYORVKmkCjbyTOTpWDiS3X98v8e9r+I5uGN3uCpKVdmpRt9TvLASaB9dGBqxJJSPWDu1dsbeJdR0+HmgmeEkQjBJEGmCgHAHGzDPkGvTKDwRdoNykQGwlf6fZx3JJDNNHicbBmYl7ATxUtlxAPc/T+NX3y9YassSaxd3aG/+t9XrDLUh5Xwz8lW4qz6oYZYl6+LWG9VI29GYnwdKI3mT7fILTES8aeCd8t1S3Igl+vpoqUYxzyMX7ODQt44uBAZ5UH66svL1BSYpw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0baecf83-fc7a-4b50-5db1-08d82e9ae148
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 23:56:41.0493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6NUSNLOVWEKBPtuna78x2YmMtAfj9OrN7NzCEt1PZ7nGWZav1OHERJrYrJCkRPAUPJTInmi8qKHI1THifJr2qkOUFFF3RLPtulMwZFfXv68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0731
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Wednesday, July 22, 2020 4:43=
 PM
>=20
> On Wed, Jul 22, 2020 at 11:25:18PM +0000, Michael Kelley wrote:
> > From: Boqun Feng <boqun.feng@gmail.com> Sent: Monday, July 20, 2020 6:4=
1 PM
> > >
> > > This patch introduces two types of GPADL: HV_GPADL_{BUFFER, RING}. Th=
e
> > > types of GPADL are purely the concept in the guest, IOW the hyperviso=
r
> > > treat them as the same.
> > >
> > > The reason of introducing the types of GPADL is to support guests who=
se
> > > page size is not 4k (the page size of Hyper-V hypervisor). In these
> > > guests, both the headers and the data parts of the ringbuffers need t=
o
> > > be aligned to the PAGE_SIZE, because 1) some of the ringbuffers will =
be
> > > mapped into userspace and 2) we use "double mapping" mechanism to
> > > support fast wrap-around, and "double mapping" relies on ringbuffers
> > > being page-aligned. However, the Hyper-V hypervisor only uses 4k
> > > (HV_HYP_PAGE_SIZE) headers. Our solution to this is that we always ma=
ke
> > > the headers of ringbuffers take one guest page and when GPADL is
> > > established between the guest and hypervisor, the only first 4k of
> > > header is used. To handle this special case, we need the types of GPA=
DL
> > > to differ different guest memory usage for GPADL.
> > >
> > > Type enum is introduced along with several general interfaces to
> > > describe the differences between normal buffer GPADL and ringbuffer
> > > GPADL.
> > >
> > > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > > ---
> > >  drivers/hv/channel.c   | 140 +++++++++++++++++++++++++++++++++++----=
--
> > >  include/linux/hyperv.h |  44 ++++++++++++-
> > >  2 files changed, 164 insertions(+), 20 deletions(-)
> >
> > [snip]
> >
> > >
> > >
> > > @@ -437,7 +528,17 @@ static int __vmbus_open(struct vmbus_channel *ne=
wchannel,
> > >  	open_msg->openid =3D newchannel->offermsg.child_relid;
> > >  	open_msg->child_relid =3D newchannel->offermsg.child_relid;
> > >  	open_msg->ringbuffer_gpadlhandle =3D newchannel->ringbuffer_gpadlha=
ndle;
> > > -	open_msg->downstream_ringbuffer_pageoffset =3D newchannel-
> > > >ringbuffer_send_offset;
> > > +	/*
> > > +	 * The unit of ->downstream_ringbuffer_pageoffset is HV_HYP_PAGE an=
d
> > > +	 * the unit of ->ringbuffer_send_offset is PAGE, so here we first
> > > +	 * calculate it into bytes and then convert into HV_HYP_PAGE. Also
> > > +	 * ->ringbuffer_send_offset is the offset in guest, while
> > > +	 * ->downstream_ringbuffer_pageoffset is the offset in gpadl (i.e. =
in
> > > +	 * hypervisor), so a (PAGE_SIZE - HV_HYP_PAGE_SIZE) gap need to be
> > > +	 * skipped.
> > > +	 */
> > > +	open_msg->downstream_ringbuffer_pageoffset =3D
> > > +		((newchannel->ringbuffer_send_offset << PAGE_SHIFT) - (PAGE_SIZE -
> > > HV_HYP_PAGE_SIZE)) >> HV_HYP_PAGE_SHIFT;
> >
> > I couldn't find that the "downstream_ringbuffer_pageoffset" field
> > is used anywhere.  Can it just be deleted entirely instead of having
> > this really messy calculation?
> >
>=20
> This field is part of struct vmbus_channel_open_channel, which means
> guest-hypervisor communication protocal requires us to set the field,
> IIUC. So I don't think we can delete it.

Indeed, you are right.  I mis-read it as a field in struct vmbus_channel,
but that's not the case.  Thanks.

>=20
> To deal with the messy calculation, I do realize there is a similar
> calculation in hv_gpadl_hvpfn() too, so in the next version, I will
> add a new helper to do this "send offset in guest virtual address to
> send offset in GPADL calculation", and use it here and in
> hv_gpadl_hvpfn(). Thoughts?

Yes, that helps.

>=20
> > >  	open_msg->target_vp =3D newchannel->target_vp;
> > >
> > >  	if (userdatalen)
> > > @@ -497,6 +598,7 @@ static int __vmbus_open(struct vmbus_channel *new=
channel,
> > >  	return err;
> > >  }
> > >
> > > +
> >
> > Spurious add of a blank line?
> >
>=20
> Yeah, I will fix this, thanks!
>=20
> Regards,
> Boqun
>=20
> > >  /*
> > >   * vmbus_connect_ring - Open the channel but reuse ring buffer
> > >   */
> > > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> > > index 692c89ccf5df..663f0a016237 100644
> > > --- a/include/linux/hyperv.h
> > > +++ b/include/linux/hyperv.h
> > > @@ -29,6 +29,48 @@
> > >
> > >  #pragma pack(push, 1)
> > >
> > > +/*
> > > + * Types for GPADL, decides is how GPADL header is created.
> > > + *
> > > + * It doesn't make much difference between BUFFER and RING if PAGE_S=
IZE is the
> > > + * same as HV_HYP_PAGE_SIZE.
> > > + *
> > > + * If PAGE_SIZE is bigger than HV_HYP_PAGE_SIZE, the headers of ring=
 buffers
> > > + * will be of PAGE_SIZE, however, only the first HV_HYP_PAGE will be=
 put
> > > + * into gpadl, therefore the number for HV_HYP_PAGE and the indexes =
of each
> > > + * HV_HYP_PAGE will be different between different types of GPADL, f=
or example
> > > + * if PAGE_SIZE is 64K:
> > > + *
> > > + * BUFFER:
> > > + *
> > > + * gva:    |--       64k      --|--       64k      --| ... |
> > > + * gpa:    | 4k | 4k | ... | 4k | 4k | 4k | ... | 4k |
> > > + * index:  0    1    2     15   16   17   18 .. 31   32 ...
> > > + *         |    |    ...   |    |    |   ...    |   ...
> > > + *         v    V          V    V    V          V
> > > + * gpadl:  | 4k | 4k | ... | 4k | 4k | 4k | ... | 4k | ... |
> > > + * index:  0    1    2 ... 15   16   17   18 .. 31   32 ...
> > > + *
> > > + * RING:
> > > + *
> > > + *         | header  |           data           | header  |     data=
      |
> > > + * gva:    |-- 64k --|--       64k      --| ... |-- 64k --|-- 64k --=
| ... |
> > > + * gpa:    | 4k | .. | 4k | 4k | ... | 4k | ... | 4k | .. | 4k | .. =
| ... |
> > > + * index:  0    1    16   17   18    31   ...   n   n+1  n+16 ...   =
      2n
> > > + *         |         /    /          /          |         /         =
      /
> > > + *         |        /    /          /           |        /          =
     /
> > > + *         |       /    /   ...    /    ...     |       /      ...  =
    /
> > > + *         |      /    /          /             |      /            =
   /
> > > + *         |     /    /          /              |     /             =
  /
> > > + *         V    V    V          V               V    V              =
 v
> > > + * gpadl:  | 4k | 4k |   ...    |    ...        | 4k | 4k |  ...    =
 |
> > > + * index:  0    1    2   ...    16   ...       n-15 n-14 n-13  ...  =
2n-30
> > > + */
> > > +enum hv_gpadl_type {
> > > +	HV_GPADL_BUFFER,
> > > +	HV_GPADL_RING
> > > +};
> > > +
> > >  /* Single-page buffer */
> > >  struct hv_page_buffer {
> > >  	u32 len;
> > > @@ -111,7 +153,7 @@ struct hv_ring_buffer {
> > >  	} feature_bits;
> > >
> > >  	/* Pad it to PAGE_SIZE so that data starts on page boundary */
> > > -	u8	reserved2[4028];
> > > +	u8	reserved2[PAGE_SIZE - 68];
> > >
> > >  	/*
> > >  	 * Ring data starts here + RingDataStartOffset
> > > --
> > > 2.27.0
> >
