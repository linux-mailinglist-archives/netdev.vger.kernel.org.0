Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D08657B34B
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiGTI4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGTI4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:56:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4709E67584
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:56:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGZKhV8GIV36ZDY/llwRUqn93bh8ZciXCEKdjNHtn6ike4RS1jtw2Ij3H5OenxU4Xr2ISmDBYk0B40SLVVRfThWnuMFamnlWywqywZyO9YmxSBRickuOWxHqfAsfiAQeqRYHEoJSV0Bur11lk1q1uTQiqJstkXwPabg01DP/SIr9GFSmqzL6+CqQ3l9CfpeXzi9fvoiehf7XfQl6QF/TlnRO/c0WU3fV9B6YtC/RcJbTPjWWmMHEiSaB460pOwnzma95goqt8n14K0WgHAH/ICgtkDQGZH3w7/LwDWKOVTVwiQeN9t1JdmZ9FKZejE/gjvLBpeDUol2j1ozeyJ09Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2Ep2U22fWfGaY7NUL914MT6w6M7hAXxoNNUQeSOrYA=;
 b=ZUyZhvBXw5VFhBX/87DFDdtOAqrP+9fySAQzMDUvblkIBa2iEwiC5ZxkE4eUGMSCAQFUUGs19uGwRL87muWYso1QYDPzKZs8MCWZqD3dn+OFutZULdNznOacioPzizGwK9pz4bJXlFHujY5aZ9PKlWokvApNkPW/HnCRYJoZhdNuBWTx+AnI4vW2BVdrB1FeMDHKXc7zv1XsNLW79kMhj59PanhU9wokwtumMhVnQnM6U/2RuJfoUnr2e9cTVgcK0zgl5qIQxKqeF7yZ9rUWpJdaXkG9MVntqhJ4X86SFrrd4yv77Pq6ZUGujhdU9UO8xEusFW/6MBtRBbZYkl222w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2Ep2U22fWfGaY7NUL914MT6w6M7hAXxoNNUQeSOrYA=;
 b=racx/i7J8u0nXzbQ8Pr20lw5zW9t8V2RryndS4A1wt0kY8UtpEGxuRAdCp3eGqt6XZI8IUiM+xHjxRKpl5y/1/WMfUcdnMNRfmKwhPtIimvFIGjRfV6WjIpi66i8r1zsh3HLOfed24zcIl+Kk0iwGCkaZBjcYujjULI9HPYcPhMKz8/HeD8RTz0W9GcQC3zWjCOsNx8npfohNdSzI0FzQESI2Ilttqs6McX2mFaDb6Y53VBfwlhz4tx0bt4m5I8kXQm9bTEIVCYP9icURan9THQwKzizt4/VJ6gvA7RiyX3CQq0h0k3/slmT2SWbd0rKOMi3uW4ibKYi1TO0lFOGmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 08:56:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 08:56:41 +0000
Date:   Wed, 20 Jul 2022 11:56:35 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 05/12] mlxsw: core_linecards: Expose HW
 revision and INI version
Message-ID: <YtfDQ6hpGKXFKfCD@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-6-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-6-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR08CA0115.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75a6b993-4867-4997-bae5-08da6a2dc3aa
X-MS-TrafficTypeDiagnostic: BL1PR12MB5753:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJyLYI3t8Vp2xgHpC3rs/gJdvZIrLhpcuNngxxeoDHWFm2IHYUfmiCWtCYD/m4SF3YYwkY2DoW67u10L0a49+IAPqyxz8FDUiiYFCN+Il2MjyHP6K1+t4WelTzYRk+gWVtGLzqnSE0ckzZIr1F9MbB4I2ERSbKymRQPTURbZSvjc8T5MtsKRElecwGkRVw9MWPwoEYlN/uQJTuBOwg9bn7975QfNmJmmUOu5Le/rxzNb5PFy6MXGN5Yza97jb6qymNuVHFX49dP94r75gtb03K2M8n12S/ftDKTtqPel0W+yacxhnYdPgQ3/CPb3XqJkokCCumEh8dXxkW4K8q2B7XSIvv9HQQq3t+tAGnfVGko7ABCBnsnW4wVXHjQ1t4JPk1z4AfJwgci5osmw04R99LvnED/UiOVkoxkSKCCj6zNeMcfTlqt47T60sYGZzPgFFpCA/xWJ7TbfuCegeWlsv892H52U57D+/MRfm7WnaSippIBXGSf16rStzf2rDzwFjBNus8n1xV0KMFTZhkxpLtIBU5xvEtqek8AFTANOtPq2wYsHOZP/fj8oMzzyyTxfW9jeo/Ek8Y+qd/0FHssnz4lZN443rCuN6LJmrOl5jsP+5luu92VWY9JbCtmZpQekSlYaLC5f8RwECmIMC8cgRJ+GzANpDYb3V4Xs+SdDEYDNaxWm6Leo0TTrYbY/my6mUOFFk9gUsayUy4LUsgcelrzIm7KjYse7VlscXH8cvf6bfUc2hNPBV3247/2dnUXY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(346002)(396003)(366004)(136003)(39860400002)(66556008)(478600001)(6666004)(41300700001)(186003)(33716001)(4744005)(8936002)(5660300002)(83380400001)(86362001)(66476007)(6506007)(66946007)(6916009)(2906002)(316002)(4326008)(38100700002)(6512007)(6486002)(8676002)(9686003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DElkIIji3lfh9QrnLCiU3BGy/6q87agIdIo5mIPDP2hvcuVwPLUbzzvutOdH?=
 =?us-ascii?Q?ulSiTqFJajnusw83p1sjPNtfudyHUqT3hqD8yk7QyMPD7JbIFloLVKybenFj?=
 =?us-ascii?Q?aTFs1d05PctQObNQG34US9lDxB8fvXIXhX2RWxxIocOm2ERVUBjt18mWQBDu?=
 =?us-ascii?Q?MQq8luAAWe2bKrRmy97+aaMashykfxfD25xgl/0Gn1oK2dB7DDYYPVeRq2ZJ?=
 =?us-ascii?Q?u4qYR0yelfi7Hk24pNJR6IzqR9AC7AZhYpVUQ5f5GvdAz8upgt5yMv8HiSin?=
 =?us-ascii?Q?NVodztj2194EjCUbBTV3A2bGbI0EsV0qECsY6O2x2JnKfbct/yVnF0UxomQ9?=
 =?us-ascii?Q?t2mv57E8RIeMyTr6Zygglu1ebr2QHm1ZlX/pnoV5vN6u+MSBHA2uQdSNNToN?=
 =?us-ascii?Q?9pMAjy36X6PJRXYj3nlU4DuTnuBCY+L+4cbmB8RRigHPltjQYC/mgeds5crb?=
 =?us-ascii?Q?GVIv7a4vaiXoG8s1rzMaO3ahKuAcYPJ0oDCM0NxvnF0obXTd2B/uCkvjNP9P?=
 =?us-ascii?Q?n5nJB5DdBLWUyROPV22ZJCb1KiY8EaTEhHp/j+w64yFCaZ/tXBI604/g2RCP?=
 =?us-ascii?Q?oOWmQ3d/cYnxe+yzYy8Eivr9xpievCTQOHzm4gTSS2UVlKd/hYE2Wx5xySyA?=
 =?us-ascii?Q?s1Cf9z1rBe+oHRF4sJZkaVxtVES3Y/oikq5yUahDbEzQgjkKYfz1SKrEIaus?=
 =?us-ascii?Q?yJoIouObhe9TXRj4gI61j3LvZbWgZgF1RuWaN5iZPRD5HtPAz01LpeUwu/c/?=
 =?us-ascii?Q?azLNX7CYScPIdMqSgHoB90Z9YV3ZgsXOqIHb73T6YskIEeXI7nzxbQL8l1wN?=
 =?us-ascii?Q?Jwc7LiOrKjMbx8wyKDM7nLq38qGXPQw+IwHLLxYzqEMerwMlXPF0SeKlejGS?=
 =?us-ascii?Q?+wQJEOMZF61firZzm61fLTN1VbpxMC+hdkK9UH/Xfu3c3LTh4OAdtt4o9vI8?=
 =?us-ascii?Q?+XwU8B1KwhZheHKZTvxHZ9Wjmdg5yiDjm4cK8Ikcf//UuU51rCqRAdQE0IQf?=
 =?us-ascii?Q?p/mB9G/5j5+Z5Fr7zdul5XhPr/GH8+Ww/lI1bEgrNtysSVC7WOVSDCdksdWu?=
 =?us-ascii?Q?Q7g3dnG+QRxHV2CYFI3dLzJLbMB5iV1atbRIuUZT1ZqXjdsp++sAz0tfC7lR?=
 =?us-ascii?Q?8wWDD/hCoMc8KEsspFSCRPHEanN1wXOspwbnvUkJ0WECYmFUszvlTm50pXL5?=
 =?us-ascii?Q?BMr5FYci/9h0eKflI8aaNnDtFVLDES4qYUPjs5DlF5UPek+dBRM9kHd927mx?=
 =?us-ascii?Q?XVr62caeWqYpagSooz+hLwfQZLhkRH3qbtBumSC+GuuphrOS5L73zmgSq/bz?=
 =?us-ascii?Q?4salt9tqhy+nmBLB548rTrMg7SV3fXyROLH1NzzxP5cEDKRIFjTqliQxnwqT?=
 =?us-ascii?Q?7G+qThlliKNV8vY9L6XezmY3e4Nx03a/V3jguZ70tC4zG4mGqn2KmRcQw7Yo?=
 =?us-ascii?Q?LOkyfW1YE9ygOyTU/RLCKtVLlNOTfG38UOnt94K955y+nCvKSZd3HIlgRr5g?=
 =?us-ascii?Q?k9BkIet1YiUdrYU8zYRe/QROocWo2p56faqNaPdZpGZUyFIsfkFZQO+oM/xp?=
 =?us-ascii?Q?nx+duVheGqHLJdU2bI8Anp5Ad9VI5XHCe76HtSF/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a6b993-4867-4997-bae5-08da6a2dc3aa
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:56:41.6414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zz/8QjU0g2khzTVK94yAfs37d6huhBe76MCKj2Mz4vPwuy3uJB+dryQDHkN3WIJN5lA3IgDCt8/OJ5/9soYfeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5753
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:48:40AM +0200, Jiri Pirko wrote:
> +int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
> +				    struct devlink_info_req *req,
> +				    struct netlink_ext_ack *extack)
> +{
> +	char buf[32];
> +	int err;
> +
> +	mutex_lock(&linecard->lock);
> +	if (WARN_ON(!linecard->provisioned)) {
> +		err = 0;

Why not:

err = -EINVAL;

?

> +		goto unlock;
> +	}
> +
> +	sprintf(buf, "%d", linecard->hw_revision);
> +	err = devlink_info_version_fixed_put(req, "hw.revision", buf);
> +	if (err)
> +		goto unlock;
> +
> +	sprintf(buf, "%d", linecard->ini_version);
> +	err = devlink_info_version_running_put(req, "ini.version", buf);
> +	if (err)
> +		goto unlock;
> +
> +unlock:
> +	mutex_unlock(&linecard->lock);
> +	return err;
> +}
> +
>  static int
>  mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>  			     u16 hw_revision, u16 ini_version)
> -- 
> 2.35.3
> 
