Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC424CAA5A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242427AbiCBQfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242354AbiCBQfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:35:16 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A67E4D276;
        Wed,  2 Mar 2022 08:34:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PafQ9DIuZhklW68GmKIl1cc9qhZzg8FbvOsqFSbsnigQ2/QHeHCWrew7/Tumj+i1YmsfBVzVqr5qoJ2MmWkPGGWFKjhtEIcli45/3Umd8PVYFWJvXM1wd0uMe4q4Di4VudAbgVMbOAEu7G5RFOwHF2LJlw9yXaeGpyblGn0w0IvMQLkhL1zJUr4+mC9hY490ytRDO6ObT3BjaYwe+d7aZrd1oTx+FZL1d3kQTTJINGn3kU6MQZLxVkTZteSetR/7CiAF7dOhll52pPt30TrcV2IvDP10HzDljOrGqIncKwx/JXFf1mmabfcImJPRGxmOAKQBV0BT7wGwqD65Z5wGXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TssYAoAC3gfqZYRyMCWHPdgevA7I9Qo/9OPxd32Ywu0=;
 b=kAFp5Bokiyn1+QVm66YvxVHS2Bb49BFEuh/VcHm0+5srh6gXnCIS1KRb4ZcVtCs+d8YZ08kn0T+WhbuX7jztmyfaC9odD1PzgmD8DiZkTuS7iLpcBWRxkIvpjBPlnhfx5294WupSysVVtwoGgMzNohswUAWmRyvgWmshagUBUUpTuE6VIFEBmmTzFHFEo0qANwvxY6X838u+HpOgIZjt7e64OQkyPBspguEuUF+Z6yCe8jVk5dxkz+BuEt9Ix/NzeISvEckx/R75U+fFu1T4bJfg8tJAjXifOOu+8++UBqqNO9Iyf1zsJEKowOGJkBkWSltoKw9IST1YrKtDEzDuZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TssYAoAC3gfqZYRyMCWHPdgevA7I9Qo/9OPxd32Ywu0=;
 b=MHMeLl1zdXXnlAC6nTWHBadPjQSp6WUsGMT4jjki9CqEuD1/u2U/EeWnlOoH6zwK1du7od9/UnC8dauaaxQ1ogrh5VQLFGuXrXZMB98zfOS9Tyfi0Ij0h6FPll06/hutEG52KjDu5wug+35BACLg7Yu48u272ZGnu0f2pXuqF3H1grmvk8+VpPENvx/rvAP/gi/g3M4eHoSm2rjNssYsGl80YVu6ZcPbCWsyk0tr/K0p+gpSHhMQGEkLEptDXw19uoY2aSHWwQGXhCAFkIErA45FLTgV4nkTyNXGpqgrmXXoF51xzh1JVMjiVx27H/u/7g2p+agK5e75CiNO3byZig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB4866.namprd12.prod.outlook.com (2603:10b6:208:1cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 16:34:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.015; Wed, 2 Mar 2022
 16:34:30 +0000
Date:   Wed, 2 Mar 2022 12:34:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Message-ID: <20220302163429.GR219866@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-10-yishaih@nvidia.com>
 <87tucgiouf.fsf@redhat.com>
 <20220302142732.GK219866@nvidia.com>
 <20220302083440.539a1f33.alex.williamson@redhat.com>
 <87mti8ibie.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mti8ibie.fsf@redhat.com>
X-ClientProxiedBy: MN2PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:23a::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25a731a0-2987-4166-8691-08d9fc6a8687
X-MS-TrafficTypeDiagnostic: BL0PR12MB4866:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB4866BA6BEE3F51A99B88A109C2039@BL0PR12MB4866.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jnCqhYQh94/Xf8Sx2DOfJ0yqtiio6Vlr3c9c1XBn65CLaHa/EOppolqHdFAVze46Gr80OGhCe6cUhOiwYul5cRIQfnCd7yXnt9Jv4y171ciX5oogVEfflWAXeVavvVbVxrMYcWkCC5Rwn8hTPybZOlItj3OfLAe2QXZNOfNNgQxVyetrHdjDKw1A1DOYmPEEYlkz+ZPL85JZ94w/3KvUYBUinY9v7lVI/OFxQArSyggTDvqrPnVb8yXZ3C+UsdezXmqIQ2GvGdbBSVb+JEcR726SXo+bugw6+8GI0YKBz64kNQDpUrLfzhXoZ+6TJMeMCECJHIqmYb8xgSRV0TELTSVy9KkqsuAqaYVJfXQp0/7G28OnrmUcL0OW20Mg+lUl1hUf14g8RLKG3v4UI586gA+mMlMewEBe2ewbhm217c2U0Nm60FIQ3ypIimGfM3mNG/ChjuyVsSDNooIyiTGym6ek0ONgH+ZElSLOhOmQOYrbVOGOi8YLvdZFa8mwtYNRPSWqF1Sk1KQ5+QXeBQjnysljWGzSGo3l27zE6AbHTkGDW4E5Qz+ejaMtI1pUC9Vc3VYB0RB6FgYKa0pUrgZcJ2BVtAJPwW7jYm4bKaQ9PII86SQC0ukgV/aUMp14zBIGm9gTtjBI0BE6i/l3I9FOgWI8HCXD2nhOfTXI8Nwqljae2pjlGsus3hqiz1NxVKa2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(6916009)(36756003)(6486002)(4326008)(316002)(66946007)(66556008)(66476007)(6512007)(6506007)(33656002)(26005)(186003)(2616005)(2906002)(1076003)(54906003)(508600001)(5660300002)(38100700002)(8936002)(7416002)(86362001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IEBpUmKWipor+p73E4cQwgqkpWjWBthWHFn8DWBs3Y7CC+4T96TYIn6evlao?=
 =?us-ascii?Q?1GhuLlwAVtIuPcJ6wyH+o7fhoQgIqSIJEZdpxcWSlEvmIKLlsXBEYnhG66LV?=
 =?us-ascii?Q?p9QqZXmkZIGQ4xHDYXgtifHpQjUlGZ98CA6XMRgGpDtxVEjEDKdL9/ai4BXb?=
 =?us-ascii?Q?GGvYwGoPM923veyczU/gq5zCXlkqSF856CfJ0TsIHvTQDj943E4APP+yO12o?=
 =?us-ascii?Q?Q6bjjf8jWq2na0CuGCRA/X8eNwgjUuQDJRDVV3IVkSwX7M/09GpqhMHBnIEe?=
 =?us-ascii?Q?0CzK7DD/QxKojQAIzofnje/Ho2+jKzTvoZwUAyFHaLYxjG98/KYxgm9+i3Q2?=
 =?us-ascii?Q?1PKPRAMafQ8Dtq4pT8E6GWyZUMSJuNYB+vyjBJo4IHHnPcwlP2IWmosJz7Ac?=
 =?us-ascii?Q?qseRdziHj/LPEbeCofB4s3wdRD1KZwjh8fV9vWaeanUQuN2yEjQArDWa2wp4?=
 =?us-ascii?Q?ev4h5G3CZ1dSnSjN9gxEljlC3jEUuTG/lyl6x5x8yhlbRA3mzHhJYcEapeSc?=
 =?us-ascii?Q?jfQusa52CzpB7kw7cnIsF3NcF+Xcv1wF7IC6snCEvAJeUO+L8g7joTOXtnQp?=
 =?us-ascii?Q?dPz1foux56PE9gvT1VJYbU5LnPL1GY30gA+gJDWAxqZYkqfJB/Es4jSQAIfA?=
 =?us-ascii?Q?p6VQJLYmLFIjvWO/rKQxHMNOQa2oB66AvYaDSE6R9mxCTvAw9Z7Wvv5ua+W2?=
 =?us-ascii?Q?iW8EHdDFyZ4EQH32Qai8wTsR7tZQnmsnneQnzbkZ9d7MbUgcXqoYNXjpny8O?=
 =?us-ascii?Q?BfYuw2M8a5zidAxeXmaM2IYZLxfFhsANA8g9m1r8D7IpyxKX3aDO6nin1cFm?=
 =?us-ascii?Q?SDMHzQ98kWE7RLJo2RoL5GsGUqCHjJvXccBtBOPQ+BQLTDEAaEvF+itUfUhG?=
 =?us-ascii?Q?9Mzsz4SPyQ2A500asVRY+dtBkH+PjR4Sz5vFG4EEptdQaKyxD6NKAhn+WJ2g?=
 =?us-ascii?Q?keUt458lh3vaublUz/xUa9bJ+aoGRqY3mSBugxi9INqrC0V6ZRXILT/MShtV?=
 =?us-ascii?Q?aCCtHsCkS2GHUTW+ZUSOR4f0LshXV4eOJwQj9imrL8sryzk0+VAjRvtA6oPE?=
 =?us-ascii?Q?wlhjwh6W8F0A0XLuJN4eSfiXOfB/LVo0YvGxZtMp/wYqpSv2WlR311tb4vur?=
 =?us-ascii?Q?7VhU6IWp3/XBcCDyUaKTPKsogk7gkoow33a5Pm4QbtDg/gDjDIOYpGeR93Yr?=
 =?us-ascii?Q?/V5l/HlShG2/fRrNR65OeoAw+N9tvsDG2lG0waGMEbYByFZJu1VTnw2Ggn/M?=
 =?us-ascii?Q?kLkFF0IsplJgegvj/zJ5ncaMAkczxQNPhrsWGvyi8zZTnzC6WYSwrISpHVpt?=
 =?us-ascii?Q?OG9J2u+lwOSkp0v1MVITN9MU52RHkOmz1FwxGiqvSgnVWA/ibDSiNx8qjSL1?=
 =?us-ascii?Q?Je9bONfvQc50k0Tvfbn1DNUQ/DxlYyAOpZ6G83j75NdSlK6XMtbt+tx+BIxf?=
 =?us-ascii?Q?iRpfkCMe4hzGyV8jn5hMZ+X8f2ydHmHGwWNdkQaW7N8WqtEWfdtT9XDQXKvs?=
 =?us-ascii?Q?Hwyt2JJ43cCP+cFxl2StZqEUrLpkvIng1R9czy86bqTDUsFq73B0jLDDZJXM?=
 =?us-ascii?Q?nXntCwMKtpjcQ1O63JA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25a731a0-2987-4166-8691-08d9fc6a8687
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:34:30.5115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mspPIDe0g9RxVLozYZHMNAml4+H83dSMQ9lK+2bc08J2kmvxtETCb3HGtKkQ8ZdP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4866
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 05:07:21PM +0100, Cornelia Huck wrote:
> On Wed, Mar 02 2022, Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Wed, 2 Mar 2022 10:27:32 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> >> On Wed, Mar 02, 2022 at 12:19:20PM +0100, Cornelia Huck wrote:
> >> > > +/*
> >> > > + * vfio_mig_get_next_state - Compute the next step in the FSM
> >> > > + * @cur_fsm - The current state the device is in
> >> > > + * @new_fsm - The target state to reach
> >> > > + * @next_fsm - Pointer to the next step to get to new_fsm
> >> > > + *
> >> > > + * Return 0 upon success, otherwise -errno
> >> > > + * Upon success the next step in the state progression between cur_fsm and
> >> > > + * new_fsm will be set in next_fsm.  
> >> > 
> >> > What about non-success? Can the caller make any assumption about
> >> > next_fsm in that case? Because...  
> >> 
> >> I checked both mlx5 and acc, both properly ignore the next_fsm value
> >> on error. This oddness aros when Alex asked to return an errno instead
> >> of the state value.
> >
> > Right, my assertion was that only the driver itself should be able to
> > transition to the ERROR state.  vfio_mig_get_next_state() should never
> > advise the driver to go to the error state, it can only report that a
> > transition is invalid.  The driver may stay in the current state if an
> > error occurs here, which is why we added the ability to get the device
> > state.  Thanks,
> >
> > Alex
> 
> So, should the function then write anything to next_fsm if it returns
> -errno? (Maybe I'm misunderstanding.) Or should the caller always expect
> that something may be written to new_fsm, and simply only look at it if
> the function returns success?

The latter is the general expectation in Linux.
 
Jason
