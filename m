Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8093541DD89
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 17:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344239AbhI3PeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:34:01 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:53184
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245167AbhI3PeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 11:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGMqisxqbwLhPxKcti6Ya5GP62SZuNiRjPsAECrTvYffsbcvL3+qVpVbcXXMrGgVVBfFvQa9t+jODC87eShI97KK6v6lLyiBK3TucC7fY5QJKbgATCGEYNm5NXF00LpPU6b/bcW+jKfveygxNxV2CbcKmDcAnTbyNclOSZkvexNmT5Q+BFDxD0Rg6cHN25u4zyAYRRqob1/TUQ9M2lwo2LPMn4HoMMysXRucVkHRK6gkRHdpYbd/l9e3lf9tpr+Y5pE1x1myKPH3lz+LaaVfwLRP/MCIqa7Lwk4WN+5ycguQvhYNZntxzpImMQGHKuSr5M+nW7CEHiu3fiILUCv61A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=K6Bn6QoJ1HqCbpVXidFlPQvdy7F2EitkV8Q4UUgoIl0=;
 b=kX97AQSpnzbwN5CI6FqGTYc0DNjv0o0gdL+sGCwAu4r62lLj0NVEPUJfCqBJ1z7jmkrcwKi+Kk7DKzZtm+xP5s1I6JGcOc6xcrbkI5zhO+33078erjIELa23PZhFH7kRkK6m7b/Be+LivQPeqCBhNtnuz1+LyZwS9jt4gdNTX9831cggzTq/KzhrUKjiQJq0cXQ1F8V7QLt0tTdktrpz7WNnjp/BtCmL/44+V1YC96Z2kE/bMqa1/wYYsQbSAJljFs1QpPz4WM39pEEA1fHEKqSgFpg/AN5RTAgGumxD6ZSM69aUxt/UVM/Bx248iQJeyyE2RI2qWtn/+Y+6W/yfSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6Bn6QoJ1HqCbpVXidFlPQvdy7F2EitkV8Q4UUgoIl0=;
 b=msS4DBzbBxxz0wwB525o/cGlJlj9PQ1AThd3SGByqq2ImCAbFYJEtrhZyL5TmZc8QfQTsNt1H+Dc1t8T59u0SzDt98+z/oiop3VqmJuddlutBd7oLXR+MrTHe69vZHnOjkNYRavszeDIk3slxKxJUFE2IGwVurzdJfHJONfxeUctBCP/UiHGPEAiEzoCYHhJA4DjRpt/vlkiRfEJwE6EP2POdZjkoPjP0Dp0e43huAlPELuTyg6Cg/5bzkMMFfjx1iXXocTbPcxciLgNEqIMoGfu72RHIxRGo6PhLq9SxfYVN7rkTBI0Bw9qgmtnX4qDBAjIqcnuW71DjaHVda6LTA==
Received: from BN9PR03CA0883.namprd03.prod.outlook.com (2603:10b6:408:13c::18)
 by MN2PR12MB4550.namprd12.prod.outlook.com (2603:10b6:208:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Thu, 30 Sep
 2021 15:32:16 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::ee) by BN9PR03CA0883.outlook.office365.com
 (2603:10b6:408:13c::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend
 Transport; Thu, 30 Sep 2021 15:32:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 15:32:15 +0000
Received: from [172.27.13.136] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 30 Sep
 2021 15:32:10 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20210929063551.47590fbb.alex.williamson@redhat.com>
 <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
 <20210929075019.48d07deb.alex.williamson@redhat.com>
 <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
 <20210929091712.6390141c.alex.williamson@redhat.com>
 <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
 <20210929161433.GA1808627@ziepe.ca>
 <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
 <20210929232109.GC3544071@ziepe.ca>
 <d8324d96-c897-b914-16c6-ad0bbb9b13a5@nvidia.com>
 <20210930144752.GA67618@ziepe.ca>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <d5b68bb7-d4d3-e9d8-1834-dba505bb8595@nvidia.com>
Date:   Thu, 30 Sep 2021 18:32:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210930144752.GA67618@ziepe.ca>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a74c9264-44d8-44fe-91ee-08d984277b72
X-MS-TrafficTypeDiagnostic: MN2PR12MB4550:
X-Microsoft-Antispam-PRVS: <MN2PR12MB455074F1F4E32395F0C1F6C3DEAA9@MN2PR12MB4550.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bpxY4hO8q49g8+e6StaUjDvRj2HT/P3/6DBtZARt0fVsd4zAg/tb+6HHOM6aauxy+7+jsG5EuzajcqitdA6iXUz5mLkLKg/fbBRRSpaHjzRnJ02Uu/PUto8ByuaGMwwQ9ttc6NUh6U1XSj5R8ldJ+84uUfN+EqglL0nmLAbLK0A8cT3o11ThXAW/5LyaB4a+ZtT0U0S8az2S+HGdVC8wAcJ53UT9d6Wh1HQH/PnDF450fKO2c2dJW+Lh1oOiKjigQZOkBUX+skY6d1vba5MI9aGNMG4mjV6LmLylhakNSdLGIap/HcREx0PcApsMz5ec7BMgmL5AmJ7JwzkyH9IS/ncLDuPDS0tRnvW3ePJL8fqbMZC2bk3lgxNing2/OBpTVVc9oCaES7EcuNPOQk2Z82/ROfvDQpmqTuEGisfbHMqrs2gOWZ4T64Fwgd/Whncxzl/qUMpVTTYXbSXyuhKgTJs/c8ZWdWCdL4ILHYPJliAPz2FPj1PMJVSr1WBaTO05y3zpMgCIgqreNOTU61LiPmVzhfCGPrsSxLiSlEF5LHZwf0Q5DeF1ZgJlxNYnpq049N1a8f35cR6TzbIjvrqP7pPQlURe4zrxTB3/j78iwUsK/hbbJrvJ2NjqqiWdywRWD0Oiau+ZJ5B+guImKr+RxUZj8mB7ShCFw2ZP8OHvc8Fog1mA8tz3MIxBWlyjWjSjq4nUMKaSHPlNn9oyz6yU4ZUfu7jm7ElmXFBYsjkwniA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(6666004)(26005)(16526019)(186003)(47076005)(5660300002)(31696002)(336012)(86362001)(31686004)(426003)(356005)(70586007)(70206006)(7636003)(2616005)(83380400001)(8676002)(6916009)(8936002)(53546011)(508600001)(36860700001)(16576012)(7416002)(4326008)(54906003)(316002)(36756003)(82310400003)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 15:32:15.7725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a74c9264-44d8-44fe-91ee-08d984277b72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/30/2021 5:47 PM, Jason Gunthorpe wrote:
> On Thu, Sep 30, 2021 at 12:34:19PM +0300, Max Gurtovoy wrote:
>
>>> When we add the migration extension this cannot change, so after
>>> open_device() the device should be operational.
>> if it's waiting for incoming migration blob, it is not running.
> It cannot be waiting for a migration blob after open_device, that is
> not backwards compatible.
>
> Just prior to open device the vfio pci layer will generate a FLR to
> the function so we expect that post open_device has a fresh from reset
> fully running device state.

running also mean that the device doesn't have a clue on its internal 
state ? or running means unfreezed and unquiesced ?

>
>>> The reported state in the migration region should accurately reflect
>>> what the device is currently doing. If the device is operational then
>>> it must report running, not stopped.
>> STOP in migration meaning.
> As Alex and I have said several times STOP means the internal state is
> not allowed to change.
>
>>> driver will see RESUMING toggle off so it will trigger a
>>> de-serialization
>> You mean stop serialization ?
> No, I mean it will take all the migration data that has been uploaded
> through the migration region and de-serialize it into active device
> state.

you should feed the device way before that.

>
>>> driver will see SAVING toggled on so it will serialize the new state
>>> (either the pre-copy state or the post-copy state dpending on the
>>> running bit)
>> lets leave the bits and how you implement the state numbering aside.
> You've missed the point. This isn't a FSM. It is a series of three
> control bits that we have assigned logical meaning their combinatoins.
>
> The algorithm I gave is a control centric algorithm not a state
> centric algorithm and matches the direction Alex thought this was
> being designed for.
>   
>> If you finish resuming you can move to a new state (that we should add) =>
>> RESUMED.
> It is not a state machine. Once you stop prentending this is
> implementing a FSM Alex's position makes perfect sense.

You can look on it anyway you want. Three control bits or FSM. And I can 
look on it anyway I want.

The point is what bits/state you set during the resume phase:

1. you initialize at  _RUNNING bit == 001b. No problem.

2. state stream arrives, migration SW raise _RESUMING bit. should it be 
101b or 100b ? for now it's 100b. But according to your statement is 
should be 101b (invalid today) since device state can change. right ?

3. Then you should indicate that all the state was serialized to the 
device (actually to all the pci devices). 100b mean RESUMING and not 
RUNNING so maybe this can say RESUMED and state can't change now ?

4. all devices move to running 001b only after all devices moved to 100b.

Otherwise, devices will start changing each other internal states.

-Max.

>
> Jason
