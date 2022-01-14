Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9DB48E371
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiANEw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:52:27 -0500
Received: from mail-dm6nam08on2066.outbound.protection.outlook.com ([40.107.102.66]:48540
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233086AbiANEw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 23:52:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBKheyKEAySqv3PpMen73e5bOy4IsoEDAToiKP4ZuPnj2bmnVm9OWzIXl0jDu1EdkLF53rHoIvcm2U8W5BdLrky1hkwIvlsBpTpAxK9SrUyw4YCBV362m3pGpwQWZhJqab1NB0VphgE6ziiGcISdUPY+FyIXRMNT5jnwcr3+9+SlYjE7iYx7TSk4kVSUXM/gmi+pkhZRa1n1oR9SiSGDBkB3FE3MgzI0wfTzRBpLEPnfCAWI4o39RSgQLhFRIovmEWzNhJDqnGqQxgU8GcM0ViD00YCzVsL+yE9LXlmKQJjA1doMv1pFiAMTUh8DZQnCn3l7xVPvxKyxIe5V0vlN7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLPtsVKz6EeuHHvQIp+iJOYPbVCqqDHPwRnSKsqK9a0=;
 b=LcSDha28RPmVhHoYw49qsKW/gZZya4nRxxZ7igDuxH/ZYeqy+1DFMr8uel3Ux8wtAG6W36csXnz8+MfAqJiwXD8WQrS1Y8qrhmGMqeLdP65OQp5SdPy+kpAPJHxS0CwLNGY6fusm9LulSgl6Jg45om3RfPAX3chTbefORQ6NzegryT+J6FP1hruTvx2bCG6qba+CGGZJKP0NeN/gdN56TKz7+N8Q4zkAfGvxxyIWYK/hB43lCyEzKw9tA6Bu320YvXiKc84MEOxR0ee5Wc2KCLj1Eem2x03xVV4Gr+oZpoAgu3UjMyJ1VEpFVfqxL3Ljk27IAn3kunk13jYZk6d3Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLPtsVKz6EeuHHvQIp+iJOYPbVCqqDHPwRnSKsqK9a0=;
 b=kOgTDRDq1ULy8c2zciTKm7V23ZjsHZkMEum/Ny0ot1SALcBzRCPRpOq0bDeHoXYvqNBRC0S+KvwbRGyPiVG2VF6uqlA+AWOuEgUFk5CIuIR+ogWPZFJG5FjFAM6SG6wGYhgZt1pnnspta1FnK/4dDOQS9mGgStFMREYVV+wjfBS/koOFMjnhhvTpKEeW3TjKY8wnn39mII6wGCXGzkCxObKt2RF+iH1S4QApcFOiAp77jkLiLK2exTlZcQ1OFEh6jfTLwPPPFF+MVuYSYPDI+S3/Jp79S0/sn7fXyIZJ0KbZ9pckiSfAhYes0OK7xE+Pf57OyurJON2lAtQptTy74Q==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MN2PR12MB4157.namprd12.prod.outlook.com (2603:10b6:208:1db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 14 Jan
 2022 04:52:24 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5%3]) with mapi id 15.20.4888.011; Fri, 14 Jan 2022
 04:52:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2CAABGKAIAAAMHQgAAIZwCAAHsZAIABZRKAgAAxgHCAAaWsgIAAAHcg
Date:   Fri, 14 Jan 2022 04:52:24 +0000
Message-ID: <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111112418.2bbc0db4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d481953-4091-4efe-6ede-08d9d719a829
x-ms-traffictypediagnostic: MN2PR12MB4157:EE_
x-microsoft-antispam-prvs: <MN2PR12MB4157618578FBDD5CDDA10867DC549@MN2PR12MB4157.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4+ULcTiaQtg3HpK+Z1IXasSucm3Fzvjlw7gcAO/LKiL/dBFygeQuEmx4DNrZ9CBL4SXubaDxbPBWSaDa5s7+I9S9TZHY3+zeGVA2Rx5bgjSUoHN9hTgu7znV+bv5TMSnzorpqWGUCw0yVo3bHfuPPNSoTzJNH2M0and+CoWDHlefkGAyj/VoURUFQipc5nniTjphpI3UaUdOGcJryVOVDUDPqyVvnNYEecaLi6SBHEBFrSHUzStPebsfDe8jDTAvNcKGSmaLKjh8y0TWq71mxKx1cBXEN3sAilS4R0FcYD4cIUTVFsTWmnw/WKYfFT7IMh+44JiXOUBMQiL0so3LVXa4CpcZqKMXiZVHzbeONfP8C1KxwjotFd46OMDxEWT4LDPaeSGSsyVhlZKSGP307bEABq6C12yhzO3tvu9W41/BLK+V8yRG+2nWOLi0k5F8kBdB87XUNi2WmJoc0uh66uZm6ASxm1nwFIZwyRWwwqN2bD/JrGw3DdqciGeG9d3SxgfNlBLu80e+laV6srCB24T5BrFFdgE7kpdouBkp4boUuVC971hKj9v6BJaXZ/CwUBpTETRpv611nPxLeUQmwxFDOdbcmmY9xuGBJ1sZj/SHvmb50T2TT2lJrXslEDGIubkGeSOJgx/jdl0gCOlMCoPpfY34IYJ8ahU1lzH5SQiBcq3Y23/+qLFR8RtaRtu/4alkd3wRTrLM7LJkwh5oMuiuN1zyJO6W03M2/+a050eOSjWMw5dUyONN3ucrpx22nnmeV4XGSqPuf4EGyA7rfHgvxQpWZW0KiEmNuwV1iJM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(26005)(9686003)(55016003)(122000001)(8676002)(6506007)(33656002)(38100700002)(508600001)(4326008)(966005)(107886003)(66946007)(76116006)(52536014)(2906002)(186003)(5660300002)(8936002)(7696005)(66446008)(64756008)(66556008)(66476007)(71200400001)(86362001)(83380400001)(54906003)(316002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5Mx0RafZwAoHJdU2emsg4sy5j/Vwf8ceQOBf3Prgt2Qw1b0mx1Cm6HUFAmZc?=
 =?us-ascii?Q?AB4JleCVdviIZY+j82OfBYnNy2qpG0UoMJtW9SBvzcecIqf6hripMxvWyUFz?=
 =?us-ascii?Q?8pCX6co/pND5h0oZ2kLCjfnu26WavWTp/uyFI9VNVGguTxJ6SCrMMf7v7Lcl?=
 =?us-ascii?Q?6S/v3AfEIfJxuR9cDcp3/xqJp+2vPVcOA2c6BwuXOzSsqTB1sOijcCHf7fs5?=
 =?us-ascii?Q?r1puXkwzH/znmyBO+mPpFDK50+0MqCY0xZHpJeN85P0iS74bg9LW+4FM1zY5?=
 =?us-ascii?Q?mX5b4igQtrFuuJNgH6Z9L1Ni7+Q8BvVxYPLHRSbwP3LiljJUXK8Jq8zS3wjN?=
 =?us-ascii?Q?JgAo/LjDm5IauxYtkgeCXfwpSRvqDPYKmrMBLtvTFnrrE7ifI3YPnMuh973h?=
 =?us-ascii?Q?URkHTizXIdjuSBhV67e/eMl2Vtc712s2zpULv0otXMja5t6iK8HTQbcAqOzB?=
 =?us-ascii?Q?58upQyTFm6M8pp8I4CXbpPRnv1S1jhUnb0rrlKnIJUgxr5AcO2O9KRlkumOp?=
 =?us-ascii?Q?wK6B4q+Z0tcSRrH9i4vPlosesviC355W/vl3TrgBJ+N2lvsSNP8e3jg2S0i3?=
 =?us-ascii?Q?Tum9IU6q4onppb8JVlOYlpoLifmFzzOc0gcsA72XDs3Ut5kOfvy75Yi+Zbsj?=
 =?us-ascii?Q?IyWU0Kvs4Jlshsc6SQD/g3Qq8QgH1ehNKywJWIYwGyDIl/yYQoj7pR9/mBDV?=
 =?us-ascii?Q?fnrTHMmwtojhfYH8ArWrp6Oo+jblmrnXMI3m+AaZwqs7lGasIeBfkUBOz1QF?=
 =?us-ascii?Q?3GdaElamQbTse/k0MU9rKILXtZ5nrDe4GbOt07oJvo2477ZGMsGZP8MsUsgD?=
 =?us-ascii?Q?lwtcmqJPsAeoVkLE2O/lsSA4KZ94A6oe++LJoFT02zQijAxhD2qZ8eFqCVci?=
 =?us-ascii?Q?B++uQAVshZ9XeNKnD0VCXY0QSFsJjyx0jq2rMpPfE5PKgVh4PDQEtG1X0lgq?=
 =?us-ascii?Q?tmonehgeSeBzkPbj3O5no+CUW8R2mBGYzYflQsRAnIetbyaPigHinTQlkPn+?=
 =?us-ascii?Q?kL6Wnj+2La6BohSrg7CLEc9vNZCYo0C3DiFKWs0DehY6MGeKZ5goe5QQ6XEO?=
 =?us-ascii?Q?9AICkzfVouqwc8Lr8w88hTUmHNraaSdoqZtWFnxOCBGP2DWfQ/Uj81BCT3rK?=
 =?us-ascii?Q?Pw3wIFX90oLRYKz+VqZAxAA2arZwF5S0VFd0nmUB40rKv6mkjjByF2/F68dm?=
 =?us-ascii?Q?iAGJYSdpgw6JlCdaTKH6lOYygSujejr+UoaXErP6FQBdzXvOH2deduwMLhPx?=
 =?us-ascii?Q?oPLUsve+UV+xNKGQtReie2Uz1pk9inSZwa0YFZKHZLqWOa4WWdd5yK5QeL2e?=
 =?us-ascii?Q?UpxKTPonKyOk39Udlx5IDn20OMNwG5RV7ABGbtd3xsIOh3FPlaNgBh7avvCa?=
 =?us-ascii?Q?MKCZ/ySBcbArmddQF83TWwimLc5oNNtD4aEqj+XUOgNnm50L4m/FUAKL1nMv?=
 =?us-ascii?Q?6yHOwrRtJmAUwflz38BNYlHj+8IUVe+bMG1rYjCx23cU/lHa89Ca3QbdLUTg?=
 =?us-ascii?Q?HMX5CZ0MeBJrt41Le+XG1osaSc/U3HRmwzHd7kl9T007/nsIwqm7TbLBxdCP?=
 =?us-ascii?Q?9FiiEfiuVtq56hW5IohDIpUC+SjWTUvGIBfkz0J0p8eXn3MNeppLpcvC08R8?=
 =?us-ascii?Q?WumwIiXlzS2eRvpBi4GoUbQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d481953-4091-4efe-6ede-08d9d719a829
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 04:52:24.2820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KrgyNDAJuqDusruebLO173hnx+C8ga/44uhiFKqY9FPA2eQKs/UfobUV/75yakK1P/6v3aK1EZd+h8GqHSorIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, January 14, 2022 10:12 AM
>=20
> On Thu, 13 Jan 2022 03:37:47 +0000 Parav Pandit wrote:
> > > > The fairness among VFs is present via the QoS knobs. Hence it
> > > > doesn't hogg
> > > the entire crypto path.
>=20
> Could you please fix your email client? It's incorrectly wrapping the quo=
tes and
> at the same time not wrapping your replies at all. :( What client is this=
?
>
I will fix the client.
=20
> > > Why do you want to disable it, then?
> > Each enabled feature consumes
> > (a) driver level memory resource such as querying ip sec capabilities
> > and more later,
> > (b) time in querying those capabilities,
>=20
> These are on the VM's side, it's not hypervisors responsibility to help t=
he client
> by stripping features.
>=20
HV is composing the device before giving it to the VM.
VM can always disable certain feature if it doesn't want to use by ethtool =
or other means.
But here we are discussing about offering/not offering the feature to the V=
F from HV.
HV can choose to not offer certain features based on some instruction recei=
ved from orchestration.

> > (c) device level initialization in supporting this capability
> >
> > So for light weight devices which doesn't need it we want to keep it di=
sabled.
>=20
> You need to explain this better. We are pretty far from "trust"
> settings, which are about privilege and not breaking isolation.
>
We split the abstract trust to more granular settings, some related to priv=
ilege and some to capabilities.
=20
> "device level initialization" tells me nothing.
>
Above one belongs to capabilities bucket. Sw_steering belongs to trust buck=
et.
=20
> > > > It is the internal mlx5 implementation of how to do steering,
> > > > triggered by
> > > netdev ndo's and other devices callback.
> > > > There are multiple options on how steering is done.
> > > > Such as sw_steering or dev managed steering.
> > > > There is already a control knob to choose sw vs dev steering as
> > > > devlink
> > > param on the PF at [1].
> > > > This [1] device specific param is only limited to PF. For VFs, HV
> > > > need to
> > > enable/disable this capability on selected VF.
> > > > API wise nothing drastic is getting added here, it's only on differ=
ent
> object.
> > > (instead of device, it is port function).
> > > >
> > > > [1]
> > > > https://www.kernel.org/doc/html/v5.8/networking/device_drivers/mel
> > > > lano
> > > > x/mlx5.html#devlink-parameters
> > >
> > > Ah, that thing. IIRC this was added for TC offloads, VFs don't own
> > > the eswitch so what rules are they inserting to require "high
> > > insertion rate"? My suspicion is that since it's not TC it'd be
> > > mostly for the "DR" feature you have hence my comment on it not being
> netdev.
> > No it is limited to tc offloads.
> > A VF netdev inserts flow steering rss rules on nic rx table.
> > This also uses the same smfs/dmfs when a VF is capable to do so.
>=20
> Given the above are you concerned about privilege or also just resources =
use
> here? Do VFs have SMFS today?
Privilege.
VFs have SMFS today, but by default it is disabled. The proposed knob will =
enable it.
