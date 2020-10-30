Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70F02A0184
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgJ3Jf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:35:58 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3779 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3Jf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:35:57 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9bde880000>; Fri, 30 Oct 2020 02:36:08 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 30 Oct
 2020 09:35:42 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 30 Oct 2020 09:35:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz6F5eI34fR78jmjHwgRDj2MrjMar1EJrrObQ1EGCu87LX+jBzXVlj7lA9wfLY/xR0YOPfNF0/ugExg77qefuGT8wtynSbRSUSLZayUQP//RMUvc1Hc6zhgtVMKGY1WszHb379gFA9n3ixYLc2bmgADa+l9gf66Vl616y6/IMj7+Xy+6+xo6g52i9DzELnqgwgNmVzbZjycfo2R3J+69wG8Y1x3jmcysk6N9NsckBVzHrNnccBOgu0otogbA+nL50j7RLrqeyE6cpV8Kxpw2JvXQ5cOb1ZoFMoQ6DpzrMs2DHcznUdznHXfudc2kkbmwJjUK0lexF7OxEpFmzm1+OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWTAd7opkAERURr3qxfuOLB8iQ03YIm60A46/6r37+A=;
 b=XdkbgJGXSNnUqkFhstXLSmPoXPIBsGNV9Hkv/lJJNUWh1VP65DxXHL4DdPMW5rT+ud1m1g4qy9SbL6uWnVaBb6Wb5uJ20YWSYuzLuYpUuxIoOuXxykl2sw8auAmdgNyT9p3West+wuaPN+G/t2pHwZ1pjkn0tvrHSfHchIDV5vkElQc28pYXjsYBBHWXVR5CS+evRb0WTVTm/uA9daWUj+epvQ5F6z6lVaEXRijvIcp1HLHpgY2eRgM6VhmZHz5CjViMqripI8MUPm5iQblPEZSV2JZV7dWZsfbcS2xw9BZYqnVCdN1rDhX/CcFey2D83qwa5oKxpCbrmyvtmjMeQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3173.namprd12.prod.outlook.com (2603:10b6:a03:13d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Fri, 30 Oct
 2020 09:35:40 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%5]) with mapi id 15.20.3499.029; Fri, 30 Oct 2020
 09:35:40 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+34dc2fea3478e659af01@syzkaller.appspotmail.com>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linaro-mm-sig-owner@lists.linaro.org" 
        <linaro-mm-sig-owner@lists.linaro.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: WARNING in dma_map_page_attrs
Thread-Topic: WARNING in dma_map_page_attrs
Thread-Index: AQHWqbLPPEPI9mnwmUSeVEeL/Zim3qmnD9kAgAJKk0CAAcOagIAATcGAgAHhEQCAAp+JsA==
Date:   Fri, 30 Oct 2020 09:35:40 +0000
Message-ID: <BY5PR12MB4322B3F74495D950A2DF59FCDC150@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <000000000000335adc05b23300f6@google.com>
 <000000000000a0f8a305b261fe4a@google.com>
 <20201024111516.59abc9ec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <BY5PR12MB4322CC03CE0D34B83269676ADC190@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201027081103.GA22877@lst.de>
 <BY5PR12MB43221380BB0259FF0693BB0CDC160@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201028173108.GA10135@lst.de>
In-Reply-To: <20201028173108.GA10135@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.200.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7d9918c-bfb9-4581-240e-08d87cb72a78
x-ms-traffictypediagnostic: BYAPR12MB3173:
x-microsoft-antispam-prvs: <BYAPR12MB31738EAE4736D98E391A6F93DC150@BYAPR12MB3173.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OhdeXHUxt2FA/MFFECvZtby02BvFWOngEalRKPhMwX7HXiqNroxcJLH5avg7jEwRNj8T7QcAjflq3zZZgU46DF/q8unaxtbltdYq/VBZ2G/8KA4KrP3m3113umtKplIrTfbKcx01If97Jc7LpDaF+1oP9U20b8E+G9AhWAeTiFSR5ZTL9hFKEg4ht8ECpprlp0laZSh3HQ4l9RvYmuwliXdbJQnYgxU5Fz27qkVAkoMw35vBBOeCnz05nTGpUQwHcIeBYTrfGvEJktySPmrV4mjzhAUXHOpR8E6Rn4WOon5vis9DVqKHXovRR0P+3U4LNUOMdraOr7YsmekOr4nsOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(2906002)(6916009)(7416002)(7116003)(52536014)(66446008)(7696005)(55016002)(9686003)(64756008)(66476007)(8676002)(316002)(54906003)(76116006)(66556008)(66946007)(5660300002)(8936002)(55236004)(71200400001)(186003)(26005)(6506007)(86362001)(83380400001)(4326008)(33656002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: OjRmIRgh21a33RTAnR76YfN2xHA8BZkMcAiad1IcQRsDJiZcD5dk8eh6YHRgSzDbMB1wRx+d8MFrnTUHwkAoO9hmQcIRgxahirs4LrUnI0jVMa29bam4d8XXijmeQ450a36S1sjfErWxIGvCMmE/IfQwDY0Tfk4tk09uuWPheBPyEJlNI8o7jPcz8+3RytdqhBVLqbEJN6aPaY657b8HZV5IsnfzmdfQgaW7l/KxP+ppOwY/vp9TGsJqbKLau7rtcDCzUekrgHgmqZ+lg0zVpi+An0oR3Z97Oe6142/VMjFV+FF4wTiU8gvpWirSe59BrtTUiG15WhU9rbXBVTWdtc0D4Zbe5tkumxIMb5hj2UllnOh7/l5CIg+ZxrYxsWzhLG8JNUnrnN2YWx+LsJn+o4+4YqMFmqgXw7YAJsycP5slRTEJ3Q564dwfmd8ldp5HFArvh/EfFOjhJgjeI0JMP5gqrMY2hiSxlgMqE1w8PJmG2iW6OOQxPfdCgwxRsEMpx4ZxT6xj3wJjDWchx3N7lVBoQonvoTea86BfuhAdv0/NffR6n5gndOllyjU/t/y41QGRlXCJl5yBW+ostT2sReWBdyw3MXQG/kitAjjl5ecopDgyCn2U0SCh72hlOyQyAD+vjgXmCpUcdVCHAmct4w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d9918c-bfb9-4581-240e-08d87cb72a78
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 09:35:40.4718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CgHH+xAEN3e0xCD5oZ2wfdo63z7HVx5VtnIRjdiE2mTEDQAy8PSxd1ZyFSdVDbU12jS0GpPLURBpLCaBx/9vRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3173
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604050568; bh=dWTAd7opkAERURr3qxfuOLB8iQ03YIm60A46/6r37+A=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=KpW0208/lrHOJ6KvcoQdxl5iC32O7tO9okXla0wPDR+Zw97Z69XRc+q0SguKpq2l+
         0HIUs7u10Q/R4JrQhZcnUJ3AsVThXAlCyEu/zZJDviU8s5xAq7OaaT6mX5f5R3UWSN
         hcBvKcGyVANGHQW+IMY5xAYxPesySJunXDBfaOBL493f8+W00AAZEVlOcNMVz9zxTE
         V3Dq3HOqIGL0N4p/l+fO/+E3MfunBccgCtHF1G8FR86KUVu7f2C5kuLRHqPoub5VZx
         imiXBkInc2RZBp/wUdKF3rTxisShqrbEU0cM4kIvv1HSH5tgjMCCsH8THMFQe4U4S8
         8d+s/cqIgi82Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: hch@lst.de <hch@lst.de>
> Sent: Wednesday, October 28, 2020 11:01 PM
>=20
> On Tue, Oct 27, 2020 at 12:52:30PM +0000, Parav Pandit wrote:
> >
> > > From: hch@lst.de <hch@lst.de>
> > > Sent: Tuesday, October 27, 2020 1:41 PM
> > >
> > > On Mon, Oct 26, 2020 at 05:23:48AM +0000, Parav Pandit wrote:
> > > > Hi Christoph,
> > > >
> > > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > > Sent: Saturday, October 24, 2020 11:45 PM
> > > > >
> > > > > CC: rdma, looks like rdma from the stack trace
> > > > >
> > > > > On Fri, 23 Oct 2020 20:07:17 -0700 syzbot wrote:
> > > > > > syzbot has found a reproducer for the following issue on:
> > > > > >
> > > > > > HEAD commit:    3cb12d27 Merge tag 'net-5.10-rc1' of
> > > git://git.kernel.org/..
> > > >
> > > > In [1] you mentioned that dma_mask should not be set for
> dma_virt_ops.
> > > > So patch [2] removed it.
> > > >
> > > > But check to validate the dma mask for all dma_ops was added in [3]=
.
> > > >
> > > > What is the right way? Did I misunderstood your comment about
> > > dma_mask in [1]?
> > >
> > > No, I did not say we don't need the mask.  I said copying over the
> > > various dma-related fields from the parent is bogus.
> > >
> > > I think rxe (and ther other drivers/infiniband/sw drivers) need a
> > > simple dma_coerce_mask_and_coherent and nothing else.
> >
> > I see. Does below fix make sense?
> > Is DMA_MASK_NONE correct?
>=20
> DMA_MASK_NONE is gone in 5.10.  I think you want DMA_BIT_MASK(64).
> That isn't actually correct for 32-bit platforms, but good enough.
Ok. thanks for the input.
Sending updated fix to set 64-bit mask for 64-bit platform and 32-bit mask =
otherwise.
