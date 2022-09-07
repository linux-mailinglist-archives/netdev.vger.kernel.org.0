Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60185B0D78
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiIGTvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiIGTvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:51:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207899674E
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:51:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJYdXWVUaCM3IkIb4NeFMORzB8Rj+fp3OICFgNZxCm40wkzIGq6KvwXfBLkXxWtE3S5n7JGBUtzKQiSWJhlsLwA0f8Ct21m0BxWyjTlyGGD/dGFIm+NxrH4RmmqL3/4T18WJswV6+4UzW9VT+E7p1v+KQe5nZ6RsQ/eDzDbBarEpbm5Ok5BV5UlaE2zTu0LNYUCJ+iEo9qV4Ro0WuwvlxjFwqpz5YDE2xrsFdPQ6S2e2NDczj6OcnU76M5c6G+IC5yZ8diWNCLpwmgRKejDjkUnChcM8ujz7h0pMZIdUtLreuBpTtL992CipMPRz7UOLX42ULBd3AyuKtiPfrnJpXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+IJN3SB+iD1cU6AL0Ek1vuqVxYxWmvpzN8WT277NKuI=;
 b=U0CKhA9BWw3Z99ZYHlXiYl6NRlu0SLxVxlu5n39iNgZLe5UonJI8sjU6sgnry1FTgHUW9Gf7H0wCFYMFivC/jpNxYR3fCByyqVW31fBop3wKtZnnT47AZRyjT14JRu1lYkOh9RbGzZYLtmQo2n5cSj48AYwVSGBIuVBCH0/bY/0e1qBVyeWjGszsafv3XanBvFG64gNTEQqk+nMl95D3B6GopQDGqvGF6jYscvKpD8JGG8GhatSQ6WB9xrzagu0cVbJR/T4m2RGP1htJPevolCIZPZeaQ9CZobLAmYtqL/eBJxlszXdKbSDJm83M9qciG/J1ndia3Yb+rydWHhUc3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IJN3SB+iD1cU6AL0Ek1vuqVxYxWmvpzN8WT277NKuI=;
 b=Mbu9ofasYJ8n0isRYHcvc+IFC0B9khzclW2TolZP5jxE3mRvMRjlXjmjHY+2fWryG0aybcIaPlcrYH1rZJdxtESYUQQJb+kq2cKuWs+WBe9ZI/vUtGehDRPqsU+vHmcDwuuUjValpQIGid1yf+NgbZk3IrKBH82dcc1XPFADCJ7B9ofp8t2HeVKc4Dp4B220d7xC46aH0oo/gCyRWeiS6S3Fok0Qi9EEUKEkCL13xJqaQKl1TfohHDKFTTiG16xhm+jQdVmF5mlNblTE59aQ+1sts0CCkdw3hzYsD3Bsd7VHgkMRXvRs86LXz3Pvic2yK6Xyjq4Aay6AYfaxWT/C8g==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 7 Sep
 2022 19:51:38 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1429:e3e9:dc54:ba98%9]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 19:51:38 +0000
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
Thread-Index: AQHYwpEbqLdY6RByfkyoSMo8wpA6EK3TsrMAgABG8oCAAA3LAIAAADnAgAACroCAABYGQIAAJjCAgAALaACAAAQwAIAAAFDQgAADKICAAACIkIAAAuAAgAAASDA=
Date:   Wed, 7 Sep 2022 19:51:38 +0000
Message-ID: <PH0PR12MB54815E541D435DDC9339CA02DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907152156-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481291080EBEC54C82A5641DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907153425-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220907153425-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|DS0PR12MB6608:EE_
x-ms-office365-filtering-correlation-id: 9998ca3c-837a-49a1-4bb6-08da910a60c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gIO+y9fctrepHSHAgXp5tznskC0uXsn2ZH9+rmwhai6DGCyQZlkdWu3VmGBBDZmyk7wDd+9iLbZ/oQDSqaXHDucd7zfa3UWCat1ebfQOsluVvEbvVprPD+q0v8hOJcNZN7SxaoOKq0vtQhVa4MX3SMsP/zJVogPrBqNxKUXC0AUHgbh8Lc0U/tbzI20wZ+TuGj8/tGCbjpyNYwRdASNKfQIRorMu/wfAO2mbUJ2bMY2KMXvzwra4jTyxpXiYcufrfYo15nogoseJtoWX0g60pbFSKXTeee5/VzwNZm/VUk42FPeHGpV///51AXw4uRdF8BLnfY4r7di/Xbz0vE3S7ID696KUHiOIOMSEPw6fIliQ4+YwO/Yp2SgQ74ZBERS+jO2hL+x7rjmmBwWxfJY9lG4nI60Qtz6VGAAhCXQdaTPV3Ga4BhGE+aDFWq3yowrNtmQ+QItwWYrLH53cqParDOrJNqzlrIeZ9J5aunP78uIqXXMrDLSsf0itpgzBrP+SbjYRlx3tDt0WukWfN4RNIcvSx48P16XupM8Vg66vAEOVMEKlSJtH5M3ni2k2C83PDa+5V0+mIFtOluQ6mqerUdvxFpgRrgt3kht9kN/vvNOgVTxo7JKHag9F843OfinLPPzoSrWS5k6m7m5PchZtCt2MTgTLLNAeQX6EFIeomSAUx5sG4SsUFQW/AMohUNLf6GXbFkvJIVes9YJvzfGCEYWwv0IiuBHgtPFHN15xKFSCS38wUDHg67xCC3eARt2vh76Xgfbij+O1omxShgbvpcXQJb7NHN6+oFdfXB3TrSPI+ZVW/OGAaY8p8M/mxKiqnm2bep1Pophee7/5TuL7Ur6hBek7cjblO8H2aUjQHu+lfj3KMDHvs0uFG1A4ZaAR0bf93XiJBiPsSopvVdtJYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(71200400001)(41300700001)(45080400002)(7696005)(33656002)(6506007)(4326008)(8676002)(83380400001)(5660300002)(66476007)(2906002)(8936002)(38070700005)(9686003)(6916009)(55016003)(66446008)(66556008)(26005)(76116006)(66946007)(966005)(122000001)(7416002)(478600001)(54906003)(186003)(38100700002)(86362001)(316002)(52536014)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tOEThCXzTzoY9q+wATVlcf3we78vm3aZSQOecjBWj38zPZerklW6VoFRb9U7?=
 =?us-ascii?Q?+Eju+3f+QsnVAxmUqQrEKH1WY6TcnvJiQGwT1nALU0BnFxSx86Q/aZaL/Kf+?=
 =?us-ascii?Q?zI5X3DhcRUSVS0APiksm1zr7afsAqXXPl9uY9OvdjUN1XOSpuwPwyEcZd9DB?=
 =?us-ascii?Q?hclk/cxfdvQ5ryBuKkl9LA2l2qtFTq92rUFzyoH+C9f+0C/b2P+wNUilPcaO?=
 =?us-ascii?Q?N/QhCBKGO9CWAAPT8HzZAyAkrcT3ZZMoDpJoRxW7S/9+1Qo3CEnPSgJaRRZe?=
 =?us-ascii?Q?mHvocptf1kUxqI63Qn/TYSoKJpDUsgM5I7QR1FB8vDIyx90r2yaKzvzWJ31v?=
 =?us-ascii?Q?LXOOmwVYpAbSX3jqzJ/xl5mzJYkIc7oTDbby8EZIKtekWq2JeFzBk8MZplWs?=
 =?us-ascii?Q?gNOQqr+QeaPCcCuVtxVLHHYH7HOpfBfF1h5T2xc8t6sd4/mBng738fHVl6oB?=
 =?us-ascii?Q?LGLa1Tn7jnaV5AxTaO03ujj1dCOEQ0x/8F2i1J0YoUMbqJI01QVsMoVBECnu?=
 =?us-ascii?Q?q/pr8vcZKPAGfVJ1YM4YTGZKOAh8een0oMDj5mH9r8xNZXwFgWNOET34Frw9?=
 =?us-ascii?Q?V5DM8Slf/I1J86LVecpKW1PIGySP45TzIEmgcOWjfneu9LLNjx2eHIF+Zb2O?=
 =?us-ascii?Q?QyLl/M4orHZjo6h+R+5IsadV3b/GB00Ap/ayfiU5nqjjU5mOCaARVxRwYG6f?=
 =?us-ascii?Q?n6A+aI1iH23MJLSZx5tgP+FYFt8rUqYmHggrgq5JE/qLVaExrmI4lNM8Ll5G?=
 =?us-ascii?Q?oB4JnkzB8zt65V4fWSoUcrPfygifPeM3RL/zU2/sSewE8rpdnQ2NJV6FLoQD?=
 =?us-ascii?Q?27/qvDHCrp+b5lPXHhVr+EUmKZKqTiAzvQbVN4fCii82hHQMJ+/Ws6rLlNnG?=
 =?us-ascii?Q?ltx0yLcm07YejUCFQtJlM0RErRFE5m7bRm1U3UKYIGFzARG+YLvQcbtqCakv?=
 =?us-ascii?Q?GcTaWlQN5UIUR07Ag56/WJTJYQDXyXz268ajR7A+cLLq6l0RUmZ9BPX+y79L?=
 =?us-ascii?Q?8TqdxstkXYpiNTk0YyljZpS68Rj6jdJJjMXq+uzcnRrfXlOHvKVcVHSE0WO3?=
 =?us-ascii?Q?a76l3PxWLDPeAeUgKL7SVyt4yQvJd5eL2WLHfZf/8C1HFbvfyAjB5BYzE6KU?=
 =?us-ascii?Q?NX3VgYTBFOeM3Dmh4cbbrQonqK38tyor9TrBmwoRLMCqy6rOocVOKP89dI9K?=
 =?us-ascii?Q?XtH1tbyzmqdeI+cJghCZJ1r7ipXLLJ7/u6k4zW7/gCFF6BhKJgg1b/fGNmuL?=
 =?us-ascii?Q?ECVut1xzMwpmowtKC1gUDU14b5HhLBEWANfLE6e3waVc6UikqtWY0ETxGJY5?=
 =?us-ascii?Q?xQoAakFwQL4QO7C2rBG7ZvojxzYx/k/PBBu4ZOIi3sURmmGalJ6zdr+uwnu5?=
 =?us-ascii?Q?8zh1drt000sK1liwu+0geC/Cj9zkMwpc2j3E+KUOaYbLyy7S3bRXqJtDuPE/?=
 =?us-ascii?Q?nFU62aaio9CxWhab43TNx/1xrHoHXtmtqLZbG2c2QPIccT9dTlnht8qAwG4T?=
 =?us-ascii?Q?x0qTVSfwRZSV2M58S1C0uHI/yCxWO/dETfn+WQThd4Thkzi0H7PdPsz/iEoX?=
 =?us-ascii?Q?n3mNGJKASxbM0q5xLQo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9998ca3c-837a-49a1-4bb6-08da910a60c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 19:51:38.5080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wztZjY977kVKOp4pgy4rSuPFL+vRvNgSNsyO1CXmbK3ucj1QiXCjVF7X3ZF6HSn59iTARQmd66xhFRTdIygD0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6608
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
> Sent: Wednesday, September 7, 2022 3:36 PM
>=20
> On Wed, Sep 07, 2022 at 07:27:16PM +0000, Parav Pandit wrote:
> >
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Wednesday, September 7, 2022 3:24 PM
> > >
> > > On Wed, Sep 07, 2022 at 07:18:06PM +0000, Parav Pandit wrote:
> > > >
> > > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > > Sent: Wednesday, September 7, 2022 3:12 PM
> > > >
> > > > > > Because of shallow queue of 16 entries deep.
> > > > >
> > > > > but why is the queue just 16 entries?
> > > > I explained the calculation in [1] about 16 entries.
> > > >
> > > > [1]
> > > >
> > >
> https://lore.kernel.org/netdev/PH0PR12MB54812EC7F4711C1EA4CAA119DC
> > > 419@
> > > > PH0PR12MB5481.namprd12.prod.outlook.com/
> > > >
> > > > > does the device not support indirect?
> > > > >
> > > > Yes, indirect feature bit is disabled on the device.
> > >
> > > OK that explains it.
> >
> > So can we proceed with v6 to contain
> > (a) updated commit message and
> > (b) function name change you suggested to drop _fields suffix?
>=20
> (c) replace mtu =3D 0 with sensibly not calling the function when mtu is
> unknown.

>=20
>=20
> And I'd like commit log to include results of perf testing
> - with indirect feature on
Which device do you suggest using for this test?

> - with mtu feature off
Why is this needed when it is not touching the area of mtu being not offere=
d?

> just to make sure nothing breaks.
Not sure why you demand this.
Can you please share the link to other patches that ensured that nothing br=
eaks, for example I didn't see a similar "test ask" in v14 series [1]?
What is so special about current patch of interest vs [1] that requires thi=
s special testing details in commit log, and it is not required in [1] or p=
ast patches?
Do you have link to the tests done with synchronization tests by commit [2]=
?

This will help to define test matrix for developers and internal regression=
 and similar report in all subsequent patches like [1].

[1] https://lore.kernel.org/bpf/20220801063902.129329-41-xuanzhuo@linux.ali=
baba.com/
[2] 6213f07cb54
