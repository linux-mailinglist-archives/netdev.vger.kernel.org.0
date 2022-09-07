Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473625B0CDA
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiIGTGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiIGTGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:06:13 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BB490186
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVgB55Ybia5YORjAwpUo9VCjRF0d1n3qck+foNhN4MJKUKpKg9AuD0msTpSpCZ/26iCzb4d2QuLiuAvsVzoMmoBBkd4BHuptvScZMSW4tl0fMdMZocfrFD+kCOfcfZ4kDwTiIeWyy77t6+PiEf0bpMTO4BJ7oB25XmTlvHFToJOf8h7/r10WUmcJCWlPb/5cLQei2qgoUsWfMxf79sDEEJJqNk+BQovuYdPe4asnhHQg7IDTlyv6jfYHCI2drycQTLx+kkW51jKkFccycE2eYBGEpWTnvrYi/1ChV8/VzoNJ9ntZj2Hc4Ob2Bojjvf276RCqL7QbDR4epvx2bbRoag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5cW7wrJKOZDjb0f64TPf0pfDteuQUDeL29XrnMrKKQ=;
 b=MEHjiw7zL3TrdUgnmE6m0R5AmzD2JERag7efaqACdE/7H6P2LHE/fcIwDOnRarqswygWYOJPOs/qs0LsfFxyO9DWUU4CFXFRQyIKovRxv3+4lKtJDrdGLqIju7y5/UUk3UhoSO54l0A8Yt6qkNnnJkw0Rfk5dV6w44axAeiQfHvSeZSpRYVKgr2rBnxP3UamBxukjHkoKR7E9XKpiPVpT3KS4GCkQRKDOz7Y3TEIND+HOxF8XHBKo7VapMsjz4R4Uua4b5pMishtfK5j+uZ7RBHXkG+Vn6CvAbaw9Qfh05HDIiT88kjQ++u8G/cjYF02zthSkBSSHxhmWGIbGAND8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5cW7wrJKOZDjb0f64TPf0pfDteuQUDeL29XrnMrKKQ=;
 b=NjLLjg7tI6664PKKUgLeeXasptxznKHpGb2qEdLsKNvIAQPo3AqKk3Fh7dDpVfd5hIec4+7+IlokZsZVcBE78XyHRggIKOQTNUuPQFoPJ/pVPdbqHnFIr2ZzoLMhxlqkg8pBtUtgR67cqaCU15Fmmrh2s1qxyBHvPOKIiD0ThDzHVnOO0O0YUpjO2mbv77w3ZuUqy5um6Y/ZwiGo4B+Qla92cMcWxvhbZUr1Y24JIOiA5/B4aF6L/d+CmFTd8v+DaHuFmUXBBVwUgbr0v0ohfTncTqZFcQcP88qc1Mm6aCzTZTk0fqxG/LiP8q8Zz/AtSPXyShKbCjBMgSfrrGUPtQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MN2PR12MB4304.namprd12.prod.outlook.com (2603:10b6:208:1d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 19:06:09 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%9]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 19:06:09 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: RE: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Topic: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Thread-Index: AQHYwpEbqLdY6RByfkyoSMo8wpA6EK3TsrMAgABG8oCAAA3LAIAAADnAgAACroCAABYGQIAAJjCAgAALaAA=
Date:   Wed, 7 Sep 2022 19:06:09 +0000
Message-ID: <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
 <20220907012608-mutt-send-email-mst@kernel.org>
 <0355d1e4-a3cf-5b16-8c7f-b39b1ec14ade@nvidia.com>
 <20220907052317-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54812EC7F4711C1EA4CAA119DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220907141447-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|MN2PR12MB4304:EE_
x-ms-office365-filtering-correlation-id: 97afb3c3-fa40-462d-327a-08da91040613
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jo33mAAa177UtEI3WYbDadOKYc9wSxSBor0Hnwf1HE1KBeyTRiMkWYq2BbODAtvSGI86tXFMdlbF3wr6AG2OLA/WCPV6Oy1QZzmHZNYv/COMIgKuWXzEDQXatABmDTNdt6BUGK5CGFV1J6HatfjFRlPznyUOf2NWMhcqckB5tbk3Zggj+uCpnBr5+X/Vx1MfENJ930C4SVa/e4WECtCFsNU455OBKFIe81vAwGp3d6EEXogq1pqePZ2jn31Rsp7/nhfvE5y/c0tG2eS0TXxR9yVUxUjUm725gdEl3rEKWcj1T4e8/J3AxM847v5DW3nokR0IKskBlC0qHrUi120yDjmNtGGCyQyo5ZFlACeY++JT6BMJWsakrNqF2hkW7wVYKUfnvTGHqyrfTtGff3c8Jmh+eTezT4+9K0LFpRhIpA1XX3iveVo9iV4rk7M2kXIEiG7NK45biiEtfj7cYWb8EqTT2hmbVi5LIWHblh8y5y4FltKXxn5488m7pOfoUZ/JAh0HfJp20ywoNP2IQXKKxn9yMhgmMfHet5VUBjFMKcV+WjWmKpejLBcaW7UQWrl/CGNDaX+Uepap9krH3vu5aorJE1dF2q88/KCDTLQe0hQ7u2MvFWOwTU5o/XaX4UETxoabGQss6UmmKmkEqe+ZUXRyN8sDUvyy9awcq19rfFuqjjg6w1j72dvSuYTBMJl+Flj2vV5hBValP6is+TBEosSdtzLEuzxcuZ7ba2i7USO7zVnpiToitfgCxUnJB12muHrI1bg5uwn+Mz309YbpWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(186003)(66556008)(5660300002)(52536014)(2906002)(4326008)(8676002)(64756008)(66446008)(66476007)(8936002)(7416002)(66946007)(76116006)(33656002)(26005)(6506007)(7696005)(86362001)(9686003)(83380400001)(55016003)(41300700001)(478600001)(38070700005)(316002)(6916009)(54906003)(71200400001)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VWyuX5yWQGLOvgtcAkUYHIAYkRVd5Q7sXong+Hu+OE6g7gATfFCdYVKAf4ur?=
 =?us-ascii?Q?EcBuK91TA55odwRbuuYNQ93E+e2l4PUS1qVssxS0fMQPO+2En5jlvkpeZmqn?=
 =?us-ascii?Q?xQaZMb9mUH++owf9gsZgwGJSAkseFX+AYJyQMd8hmLKcfBZRM8hY2QmLIyM8?=
 =?us-ascii?Q?XeQ+75FEvd3jyWecPvAg5ZUVuJTUZMpnl2z/KIdGRXAS27GxTYOFNKdGg9T0?=
 =?us-ascii?Q?iTNoui5ovPLFP86LDhH+esMBjUqYV9Qan7ETKTKEgz87wf1+oQsGx02Fi5s1?=
 =?us-ascii?Q?AQGqXSomsokqNlZ9cw+UZzlPxdAgz7Tv0bD3Zj/fOnbxbKTd1BBJ3V0FKlap?=
 =?us-ascii?Q?ns3ta48yIpo04bsqm+mntLmoB29R0yw7swaFjP+Ym/x6SxtwZrzDj9gYDi26?=
 =?us-ascii?Q?i+C9DwgxeYbz9j5+y8y+Vf/RuThfwFDUZ+KxIKYHGJ7O5kA7WFPTaGAsxfrb?=
 =?us-ascii?Q?Lsg2trH9d/8qyGjSwbpq7MRr/Uhb8jV1b4+IxFwHceTWT7jii35jiy5xYeEf?=
 =?us-ascii?Q?9Qo1k6Gu+KUeoyQGWVIaVx6gBZuNudjr6M9VIPspt47eI0ZACiinvNWp0Z9Q?=
 =?us-ascii?Q?SCUn+J04DmEprXDdMgO4wg1zMHfbghS5wGtcCcLTdESXtDsXf7xVllc/xvYw?=
 =?us-ascii?Q?u1IvxyKbJ4jr7pXNc2eXukmERebo9M7rGb0wBqJY0MQkKOb3QvR7KMNsP78o?=
 =?us-ascii?Q?IHrHy3F1z0Xh/2XXyfRzD7ZExZ/9cuddMJyjFS9mpZ/KoglXEG8THlp/GVK1?=
 =?us-ascii?Q?13vIWVxX7W7i/uipIoFkUi30HpWJ6uN8gV01pvoRYkBrIDUrf+30pHr18gZ4?=
 =?us-ascii?Q?+oLAft68I01cU1/WsfJXYa6ZdR7YKWfSscRdg9rnvnl3VLOGIle6ROApslft?=
 =?us-ascii?Q?Vwys4AxYsHMYx0Y3krR39lAYYQlpMrOAhFNC7x5TZiKSz6k7OOMyOdn7zEdT?=
 =?us-ascii?Q?sLHvg8b4C0iy1mFty50O0BhHmPx6BymJomWLL/NzwxYsCNtuETCxRrbkIfOz?=
 =?us-ascii?Q?uM1oa/o66r6ocza0529nAf13Dlu8aHmjyn+0TZE/oDfRLGiaV9ED6QnqHJNh?=
 =?us-ascii?Q?ArC0TZO+K7DXEgk62Cl93C5mofpmB+8xuaxIGnzGzEfp35MbiM6YiKKy9phr?=
 =?us-ascii?Q?CRdqRwauj2ZdckjVnz+F0iTg3ec56JYlehIVe1J4mqWSWOaVB6E79GnS915W?=
 =?us-ascii?Q?AsOW3MSl1p01Gzjd9+N2brvqMh3YyDQSYz0BnlkIn0/22Lcnz7WS+oEy104R?=
 =?us-ascii?Q?2DD6KdqR6tS1CzJICDUvoiotcyzhXlm1eMq+zALSqM27RhhO3/ivpmM4KMId?=
 =?us-ascii?Q?aHgiZZpAVCzs+Mpu9nFZlHBO5LJgB0UfPTXAa4AII03PuGZ2fq1WC0xkb549?=
 =?us-ascii?Q?fCCqTz0zlgCVP83OjwmziJZPfi8xrFxGQl6Ov9FutRM8c8uwUdCTrcOsBZ3K?=
 =?us-ascii?Q?zFMmBaUu2rshq3DZ9AL3VNskwL0xiLbLJo4mw1RAy25LgAft2APb8017O63L?=
 =?us-ascii?Q?AAwjpHPdHvy87yyXjlwSzDK/ZSNj8ZlypzIJjlvnH8JgyMSz97jhCvO4MLgA?=
 =?us-ascii?Q?mEUuxLZVsle455m1fhM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97afb3c3-fa40-462d-327a-08da91040613
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 19:06:09.3852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IBjMb34Cey4fdoxR9rFLn2redwKpwMGslf5PB8bmsitQdY3jJYpwfiQap9bYbKDHS4JeYbFad/tUNhqCOegI3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4304
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Wednesday, September 7, 2022 2:16 PM
>=20
> On Wed, Sep 07, 2022 at 04:12:47PM +0000, Parav Pandit wrote:
> >
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Wednesday, September 7, 2022 10:40 AM
> > >
> > > On Wed, Sep 07, 2022 at 02:33:02PM +0000, Parav Pandit wrote:
> > > >
> > > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > > Sent: Wednesday, September 7, 2022 10:30 AM
> > > >
> > > > [..]
> > > > > > > actually how does this waste space? Is this because your
> > > > > > > device does not have INDIRECT?
> > > > > > VQ is 256 entries deep.
> > > > > > Driver posted total of 256 descriptors.
> > > > > > Each descriptor points to a page of 4K.
> > > > > > These descriptors are chained as 4K * 16.
> > > > >
> > > > > So without indirect then? with indirect each descriptor can
> > > > > point to
> > > > > 16 entries.
> > > > >
> > > > With indirect, can it post 256 * 16 size buffers even though vq
> > > > depth is 256
> > > entries?
> > > > I recall that total number of descriptors with direct/indirect
> > > > descriptors is
> > > limited to vq depth.
> > >
> > >
> > > > Was there some recent clarification occurred in the spec to clarify=
 this?
> > >
> > >
> > > This would make INDIRECT completely pointless.  So I don't think we
> > > ever had such a limitation.
> > > The only thing that comes to mind is this:
> > >
> > > 	A driver MUST NOT create a descriptor chain longer than the Queue
> > > Size of
> > > 	the device.
> > >
> > > but this limits individual chain length not the total length of all c=
hains.
> > >
> > Right.
> > I double checked in virtqueue_add_split() which doesn't count table
> entries towards desc count of VQ for indirect case.
> >
> > With indirect descriptors without this patch the situation is even wors=
e
> with memory usage.
> > Driver will allocate 64K * 256 =3D 16MB buffer per VQ, while needed (an=
d
> used) buffer is only 2.3 Mbytes.
>=20
> Yes. So just so we understand the reason for the performance improvement
> is this because of memory usage? Or is this because device does not have
> INDIRECT?

Because of shallow queue of 16 entries deep.
With driver turn around time to repost buffers, device is idle without any =
RQ buffers.
With this improvement, device has 85 buffers instead of 16 to receive packe=
ts.

Enabling indirect in device can help at cost of 7x higher memory per VQ in =
the guest VM.

