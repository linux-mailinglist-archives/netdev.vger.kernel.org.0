Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9AE5F528E
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 12:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiJEK3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 06:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJEK3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 06:29:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3085004C
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 03:29:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwkATPtTNGu3PducEFMNkgbju6dvl2V5vy/ZcedYyhvLCUm/+EC9A0h0EsOVq42EB70jiPBuYlQx5Bve2wOHFRNQe8gLn+uueEV9JG4IXUV/y+qvMCxfiUtQfv6DNV0LLPG2ANuj5RONoXR/ZNoyp5+QmXXAJo423kV4htNrmdIA6itgwKrL2VT1uhFJitDuWmVxwVhzn01wOCz/DE5qGChoMt2y7MFVP9lCxM5MUIe9lJoA30n3+zblduiLWnz/yZ6sCSFeOOZ4lieBieVHuTHhMF5Q0cSgbn/cSo2vkOmbeyaF0NaX0q5aigeXUvhuVCTteUGjJEG05sSfGOCr4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsHXqevA5s7mVLGqpfKfKECr8qBlQXee1hGcCAvao0M=;
 b=VLmktR3Loe5Qf3ZZGpgaEQQEqF6JkRCpUuXosOG7xd7BK2A3ashHV49hA30DOIW1VCK/yMbLcy7xxcnTzHxUlqwgZwvBeN17AYTgNi7ZolPBT9wOKikJZNZQXiGfU77C0EGFdInGUO4Rx6wKqhfqVLBcRm9EsKlryCk9nF3CMi0AdZc6oN1PzrA/088xhqy+xPcDLHfGrsJh61MhPvusOpU57nHD4INv+ZD+2FuU7qOxjCu18TYYLMEdSEo1GfyqDW/bhLyJbueyxBcPpT3wTbZA3zrlJkozbk3H7EIz8szroM3zCln2NglNLmkIETK3Nk7Rf3LU00P5d7M42bS+2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsHXqevA5s7mVLGqpfKfKECr8qBlQXee1hGcCAvao0M=;
 b=KWzusdqp02EKqjCbXKGo+7k5a/53VBdSvbQgTl3nYgTsFoo2Lx/7orrkObpVVg/0LZrZGM9IyZsveAdWdaLmrD3lOj9Qbhhr1VJlmduJ5703nCM/FUMWy2+PiL6oKtUzYzPm7/478+W0BTcPJis5W6LJRBUBnnvhWin46QxysTMTGuqj7dgfiNhem1BBeBoYtZR4VzA3CAoe94WV8C8S8CR74rJs2/9qnKLGHHRMma1oWVgb1b6K/j9tO3f7YS5wYhB7XFp3kl2vkNkm1dyo4zSOZLrAce1SQc8xiFWB3N7R6ILajovefsrZt9NFw+Eg8UAI+iE/Zp18Wxs8hcDV+Q==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BY5PR12MB5015.namprd12.prod.outlook.com (2603:10b6:a03:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 10:29:11 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::f166:64a7:faf9:659a]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::f166:64a7:faf9:659a%5]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 10:29:11 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
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
Thread-Index: AQHYvagejmrtcrshK0GYXpgvFbRGE63rUekAgAAHfNCAAAOhgIAAJx0AgBRKnTA=
Date:   Wed, 5 Oct 2022 10:29:10 +0000
Message-ID: <PH0PR12MB54817CD89ECD1D0856103421DC5D9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
        <20220901021038.84751-3-gavinl@nvidia.com>
        <20220922052734-mutt-send-email-mst@kernel.org>
        <PH0PR12MB5481374E6A14EFC39533F9A8DC4E9@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220922060753-mutt-send-email-mst@kernel.org>
 <20220922053458.66f31136@kernel.org>
In-Reply-To: <20220922053458.66f31136@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|BY5PR12MB5015:EE_
x-ms-office365-filtering-correlation-id: 11b93476-caaf-4660-c2f1-08daa6bc714f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VGCT7McVY/RQZIxEQlrEyphm8yTutVq2ufNbRX9ewpNmAXEZC7sm1qDElN9Z0NVCZSUvnuMvF0IHOVxJhBlMxxHDDDZ9ciqfcffXcIKV9uxv409tgu2MthF/1xc3wdlspxr75bk21DhGoqVEwJW3s8TnIkSkT04/y7Bx4zJe8owmtR5alXCLRLJU+Cruo1GCTyfUJ01CsC2V1SXukzs534eLkbDgCxaC18thScIEFeIDJtGR0K/e/XoV0bi5JLxG/5cyLne0+zeTAjaV9RwctBiH7XJBlHo4hVm83pMqYaouuYkDAxkpFgFShvk33jO332JKKCEwYmLNc3em3J+hY2/+brJQbsy8PyLTJsm+FBQbmhNmCCwLuywI/q7whHSv0BTfGBdXeRlVHJM3pDP1MuneUyCKArIw6gRzGJLeFHYgPVzSL0aP2HToO7GvOpUcj5iwfgpg3y3sZ7/Gs1NCM/8Tj3TI51Q6YhkYllx6whk0DtsDqtknLxVK7kF03OuIbuELfj7JN+5QDVtAkqcn9xNuZ+IHnVD/7fxxRkDIYv1Bd9v472YmFpShGSOLGHgTy+vVLV9cnQgOS4MoxhDqM2yokSD8qsRXC8dxjGVsfK5Nq4sFdjE26GSX4Hoj0hdadOIWf54knnI6xbyV+VVlo35ZEXut2g4JC8uoB+V/i4C/yJETUTLff0S6SXWLZNdvbXQcYzVbXPs554bbze8PFjlqH1XLBHiKesZRqBEUoL8tgqWgxnhjhNpl2Z1lhWJ5XwnK8xG6iddEgP1d2tMbZTzDWOA3OoAz75x4CQdAG5fzKm0g+5+PcIT7ZT2QPn6T9R6yRZOCdIFth+EJ0Ox1M9NmnSijWuR4/bVaYnMk0VU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199015)(71200400001)(38070700005)(54906003)(110136005)(966005)(52536014)(86362001)(41300700001)(8936002)(4744005)(7416002)(66556008)(5660300002)(316002)(76116006)(66476007)(33656002)(66446008)(64756008)(8676002)(4326008)(66946007)(9686003)(55016003)(186003)(122000001)(26005)(478600001)(83380400001)(38100700002)(7696005)(6506007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sHi7kw61Sqo1aV1bHHP2Oz0k8JHPiulx8YL2y8uoIvaZVjFS9k4JPIuG8VQm?=
 =?us-ascii?Q?Lmf7IKFeYyFyf+bjepls8H8vcqGLoVC2w14a78VwXl7mvBRyoEM4r0Q1IyfO?=
 =?us-ascii?Q?vtizbf3eNaXd9+KzTU7c2n9KPRZ4hzjwW38cvI60EkOhhRPZnKOc98oiUf5X?=
 =?us-ascii?Q?IvUVNnoQoUh8z856wrneF1HrNILengZhBhoj9YR6+v2pVRYMvROO3GhDtE8q?=
 =?us-ascii?Q?FIcBUqMP+R7CqkX+Fpo/GcuwTFaLCncma34jhKNcOV8CrjkFPz3XDPGzE0cs?=
 =?us-ascii?Q?pDB9FT5ysFrEc20vsgrZo96yWGNm4BQWXKCMNR0ydOXCUkl4Vz09mgCmQBQp?=
 =?us-ascii?Q?JNVufYoeybUWchMPJq2xvMi4KHdmA+Ls7JfklyA4g+dmzfMD7YFdUWGnHKPK?=
 =?us-ascii?Q?uF7GBcFYG8cpa8trRVw86IVRNjZNQmrBcYotqIFUYKs/1LOtVtIXZVjOTs7r?=
 =?us-ascii?Q?UzTIUu9Re/5Okf9taX3ik54uFufqvoY+a32KTtMm1o90Hq+ZcHTnr3vP5edF?=
 =?us-ascii?Q?XrrhFJ7aANZvSiDFoQ27KfoAz9FMd8BtLjrW+o1u/ZJJ+Fr8x0MuQ+ri67dE?=
 =?us-ascii?Q?I2QH37Mj7te3xMO3CG91G5P8pYpJ4Op4nW4fWezt5qMXUG0TNZplyDrw8fHF?=
 =?us-ascii?Q?O49aC04wGBD3GfH5VQyAZuJJsy/8JJCQq1PKyYTPNByHYlk5VqPsL5BTFLkF?=
 =?us-ascii?Q?H8pVunXWkDFnNaG3EVDCINkIpc8PLb/JvdaH9ZC56HAgNUaL8trHB17cmmcB?=
 =?us-ascii?Q?3ecX5CVkogcE3soaWJCgVqn7klDs3uYK0ay4QVzzXgaVm5HZgpsNxYoSZR/+?=
 =?us-ascii?Q?Cu5zaHBO077x19NC0Zi4MmGkeJD14KBLgLxHDUSVpwwDp8wZMLG2kcFCE0/O?=
 =?us-ascii?Q?82j63bN87ZcF2ouGpExuWThHXS7z2o/juwN+ED0d2dRASCTEXxLUdnjI+BiN?=
 =?us-ascii?Q?I802D/X2l9qAUBGaKKCEJpZoUIQgDOpvS+7wJsC0kDuRl2noB8SAeAyA6MDM?=
 =?us-ascii?Q?oGHuYgLLZqzE+cx6vZ8QyoGOyxD685n2Fx/S3Cemva4WrprbOEyMX/8NsiLt?=
 =?us-ascii?Q?vmlaxLwO2SPuMQpRxKV/45gLegmtYCWgbR6drNaZxAWVDr8xOjAcp38XSvp6?=
 =?us-ascii?Q?I7DQupNz233S4ZLW13DqZotPqqke0PFXjbSF+5iYOivT0LD76i2s+l/SifJi?=
 =?us-ascii?Q?Dg2VrdMgQFfnZ4DINFNPCtDWl+dHq/VMqKg9jRBwqkPMc342LR3V62Aizif9?=
 =?us-ascii?Q?yCsyg6dZAqyRRqHSIxHqKEzz0HCx5fycRwSyeI1LDwEIjus/caWZelCOenm6?=
 =?us-ascii?Q?kAIxlkLq5XOCuJu/qzZaBNPO9Nn/QOUc8luyhx4E8zqucs86NKMXlkHzSKAA?=
 =?us-ascii?Q?drdBlMfyp9V0sfT242yUNXLk3e8ZxoszlN593oIQMr/PV9rxiUtC4oTSHQpC?=
 =?us-ascii?Q?n3+xjyij9b00euMDfhlnLrYFzXfb0d+LNt5Dw4duEKU1dmcYQg9nffeSyrgj?=
 =?us-ascii?Q?3n/02omUkHUPPzljdqf9Tqggq/XdMpabQgJUmh5aIuH62IQ0AAixOdAVxnuS?=
 =?us-ascii?Q?BaR0lxeZFFO5EUwaDxE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b93476-caaf-4660-c2f1-08daa6bc714f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2022 10:29:11.1148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p2nvX2sR36OgaWterJk8GcBEZ9eRJWoEmjTGIXoXts/hi+b3ADlVGkwGpUfuMV9w6OykuMc+WNcjoR50evPn9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5015
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 22, 2022 6:05 PM
>=20
> On Thu, 22 Sep 2022 06:14:59 -0400 Michael S. Tsirkin wrote:
> > It's nitpicking to be frank. v6 arrived while I was traveling and I
> > didn't notice it.  I see Jason acked that so I guess I will just apply
> > as is.
>=20
> Oh, you wanna take it? The split on who takes virtio_net is a touch uncle=
ar
> but if it makes more sense here to go via virtio feel free to slap my ack=
 on the
> v6.

Michael,

Did you get a chance to take this?
I don't see it at https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost=
.git/log/?h=3Dlinux-next
