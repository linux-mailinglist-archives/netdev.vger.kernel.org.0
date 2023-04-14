Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8400F6E2374
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 14:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjDNMiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 08:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjDNMiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 08:38:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CD5B461
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 05:37:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ky1Iv5IIzaiNrWh3LtReC301iIAm2LwIVqIrHKFX5RBLl5x0hozDBPbwQ619Jq42kRuI0qA+Vg9gimHiCjRFwJn00P8Xd5nWg2ZIsTISz9c83uGTggWgR5WujPKfH9TdXIUb93l02ILw+MUqRPvzBbEQNRhEr/QqUbtJlyaOVNSdaTF174VKklZQ8HHS5083vhD8AQSMO5lNIvmxSuflAQ4G7U+anaoYkG2DdUwQymjHZQ2JTQyrVfVq7kv0WRWlp1jf0YHPU+MU5yDVsD4jQg9Bmz9ycWr4gzPuchEGooY+FzZADXgV1Sdg4+PEEQQq5RX1O98RbeimYZ2WMpAaKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BlxSRy9jcL9hd/ApavXS1JMDe99F13pSbryvA5/P6+U=;
 b=HQfDSieqWcwyGRP2Mir8xqZ7FmbJ5S3zNttmtoM/ZnWHoq0INep5EByIhCJ5+5JuEy7en8n7TUZxjV2KPHzQDdPNZq5akE6CWNssOxhiJ1A449Ra7nPsz6Gfu2lrY+khoaNEuZl0hNZ0piDbLJv01ltFAjS8D7y0Jh07SK80HE9GElT/uVRYcndixEVN5QFbZ7QnsHT90hcsKF+ewVM20A6G7D7FA7XCd2+YHCS3ibDM7RVuPFew1/dxFlzWuq8O3e1/r98KVcYMsJ8yndhmjLtxXEk7XwLvQ842BFxWPZoXsdLxC7QH8iZW3/qCYj2r+zEEAr0C68eNq5YKrN0How==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlxSRy9jcL9hd/ApavXS1JMDe99F13pSbryvA5/P6+U=;
 b=MPbE9DMwDNMUbJ0ulxPMKNxECpG/YUtJk6LPwQKao3m8Sq2WxVS9hzNOuvVS9nv9iFZ91fN+EbveKcO9S43NLmQVF1t7tnuEvPBdXTZBL1Ufj23pw8duizSsY1WCHCWsD3Ayv3E2bT3pGBu5XqEw6R87urS0McIW9Qb9Al+XHjq0BcNyKdYF8k7EJ9b8UM6XEY0eIBBpcUdHFCB/PUGIEaWtDPQrmFpO1WocY7PXh8puZn4Ztu2fLNSvhKMqOEqigkz3owYRVKrXEhV268BdaXT3pQFdMNyxnM3liLQYHp+6RSy+z657IOtOYEP/NpGGA5TBblaywH6+1CPulK62yQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB5864.namprd12.prod.outlook.com (2603:10b6:8:7b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Fri, 14 Apr
 2023 12:37:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 12:37:40 +0000
Date:   Fri, 14 Apr 2023 09:37:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     Leon Romanovsky <leon@kernel.org>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v8 net-next 10/14] pds_core: add auxiliary_bus devices
Message-ID: <ZDlJES8t0nivTQLz@nvidia.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
 <20230330234628.14627-11-shannon.nelson@amd.com>
 <20230401182701.GA831478@unreal>
 <fc39973a-3f57-87d0-ff46-15a09e9b5f58@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc39973a-3f57-87d0-ff46-15a09e9b5f58@amd.com>
X-ClientProxiedBy: SJ0PR05CA0173.namprd05.prod.outlook.com
 (2603:10b6:a03:339::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB5864:EE_
X-MS-Office365-Filtering-Correlation-Id: 25dad543-2ab0-4c94-708f-08db3ce50913
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vpPebvVnPbQekM8hmI62ZPWOZwImONfgfgap5ony7jQnL1nJ6vahDoPGJvrFS/DQmxRBkU6Ew3jzzTLxMGV8J1+jjfcFDHA4zWM4DUHmU5Bd+yTroCrwGnZeb/EiEGh7klN9Tqu687LTIaMEAgWQXgo3PN2XldV/ddqWSOj2eqHJtsqNiQfn0uDFJYyXL3GHce+RKwhyKAjMpBBBJ5zW/aMQ0teyYTf/HxOH2VVuk3t0A1XB/jmu61ocjUOfA5I6fLVXfXRs8P/a3bIcCWRxiII24F1sWOYuK+WlCpl3dEqQivz9mh3qwHAXaTnY6lezFMWNMVQ3dAbigRqbgLn4l0SG800YTAzVvTJNf9zMGDCCACYTdczgtoGzQil12KLcdpBznAqsqFjTmTCvhg2s1BeYXqp/cZW/aNW3tbWQE8nG9ryQs6qIaRH+C/fecTS+79rwLDRrIstfaWKmrO1BUK+EgyQOS9OsA0U/VPTzs3Dm6vuoR2XQbUEvBBt59L71tTQeFS/9WqJ9yJ+UIXSWbDy3XXRTBeEp6lcqw5Jsot9eZTV+/tSDMYczKgg+YTwW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199021)(4326008)(66946007)(66556008)(66476007)(6916009)(478600001)(316002)(5660300002)(41300700001)(38100700002)(8936002)(186003)(83380400001)(2616005)(6486002)(6666004)(6512007)(6506007)(26005)(86362001)(36756003)(2906002)(8676002)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fXZgrgK0zP+UEPAesc2PXgDX7k7Zm6Vv+Z8TW3cm5BW8wzK/7Imo0B7eo4xg?=
 =?us-ascii?Q?g4YJu5USaMoZE2G2yzzMZbw/RC2hZ2YilUGgEfeSYxo98pdRuclT/mllE9Zf?=
 =?us-ascii?Q?+VnfVhw1XO1pN6Avd9O5xTF8XqnA4L+mzGwfEFTbQpRnGO7WqXCsH1nDbJTu?=
 =?us-ascii?Q?Y7BTtK6Dr5L7/6iNZYPhkD9lrtoMsNI25XmQaIvVQJpml4ejT3HhDWnxmx39?=
 =?us-ascii?Q?5IjmVOmo4V3pqJ4D95BFXQYgYRrfy2JHDifduQEuIv+MKxFXKWgUK0k+MkVR?=
 =?us-ascii?Q?DK32sR2ITHAmC4q0XsfMaSSS4SfhhLghNJ8ObktckSy9Wm0a72+bxkasO9Qy?=
 =?us-ascii?Q?GFqPKZ3Z7Z4si0T2WIPWolv7oiLhknJ7L6xiEOGYISd/FA+EgCQZvB32+fer?=
 =?us-ascii?Q?HAZ2A6yrEvenJ+2hxzi/ANExJaDJeGAOZV9YEJB7TIzOGET5P5qAD0BIS0I+?=
 =?us-ascii?Q?1Cj85coWfXHdcvNnk6XxPi2PXCQwbCJooj2+U6kU9blxkv3Hrt0GslM6Ccrv?=
 =?us-ascii?Q?XsykEKPbdaKCtynQhONrzKas7Xt5kZhxCWXUPqKgJT49YPN3cIq9bFd4Wu1a?=
 =?us-ascii?Q?gzbXOlPbPBdkmfV7Si4JakFVjw8Pk0PuqshkWq+cBB4VQh/I2uOsVA0Ta9A2?=
 =?us-ascii?Q?ZDShspW8chPAiozC2Ry68yb+0G9sJ7va+XlmYcV5QC9lK3cuO4oW+s+9mmTK?=
 =?us-ascii?Q?mXjBL+RT6YCjEsESFYdcO/1tsiCPMxXifvg5AYEBXRR2YC9NZMRcb6kj0eZV?=
 =?us-ascii?Q?5eRkBYH5nuCs7WdnaXxlEbVjJorkmaW7HMz/a9LDCiMZuTHNxWPDINcydx/k?=
 =?us-ascii?Q?IhCW3SBqv1Gwb/bXEifC2Mgy7YYIDhh2SYKXOHu6rel2otfVciTYqBXCox0G?=
 =?us-ascii?Q?KXzDHED2d5uQ4DuHE8NkwQhTZbBcXGhOzG2kXab2JkWJztwcgoFlsjEIGIp+?=
 =?us-ascii?Q?0JyvkM9Cj97cHn0d6Qr2bGaRbTDJCkPG0VfbUR7597RpK6s8Ek1cJs9Vxcf7?=
 =?us-ascii?Q?S8pGRwdR3a5/WjPF/bF8huxbkcRYY4y30WGoLZpCwAC2Npi6fWUjVlEXeVjc?=
 =?us-ascii?Q?btdCVQV8HY4WbC+vdSlru7RJShtpPzl5sbvS6X0LkwRQAeNlKkcCWbb+bm7r?=
 =?us-ascii?Q?oPAgvZYQgsp7t/Y0OeczOqkrPTisLyzzmrBUP3m4E5O7YjMzGJik3zwIblOt?=
 =?us-ascii?Q?aHLtqf9FNxhcX5lBtrCsrHhZ25HH3E/cdZrzywLCCD4CGJPMr3R1v0mZ1AHw?=
 =?us-ascii?Q?NUCJMpdIxw4OkkZwehTXCFj7tLGKm6FFEB9ndakdg06XpUv8CsZVcnAw2DEN?=
 =?us-ascii?Q?QmjB09jtvi++nu9PPI+krg2mDes2iztKEdCibZeQi51O1azJmMT5kwfXyc+I?=
 =?us-ascii?Q?7CkvT4sxyoBKjfKpqvxa8sjdaPG+Z3HTnHdh+RB+uhO7YLCnPU7F54IYXYZb?=
 =?us-ascii?Q?Og8IZyj6qss5NaKdxWv9Wmaeujb5cFZg4LRvJs5Y8xZXU7d6T4ETNJoglyaO?=
 =?us-ascii?Q?hU0gXBQvnJHGM66iKdD6Pw4iruDgT8TLYZeuy+SNkA+/mhvR4Ek6+lQ0/l7l?=
 =?us-ascii?Q?aYmYFSXhc0IHQgd3RWBemNmRIWFTXG0cxEfhOhWj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25dad543-2ab0-4c94-708f-08db3ce50913
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 12:37:40.4822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LB0dJlt47S6x7DyF59i4kghkx9raYW8oTZ2HKjqq5NAaLjYsP3YaFMrHydE7U72g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5864
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 01:15:03PM -0700, Shannon Nelson wrote:

> We have a PF device that has an adminq, VF devices that don't have an
> adminq, and the adminq is needed for some basic setup before the rest of the
> vDPA driver can use the VF.  To access the PF's adminq we set up an
> auxiliary device per feature in each VF - but currently only offer one
> feature (vDPA) and no sub-devices yet.  We're trying to plan for the future.

It is the same remark I gave for the VFIO integration, the bound VF
driver should use pci_iov_get_pf_drvdata() to reach to its PF driver
and operate the admin queue. Make sure to read the comment of the
function to lock it properly.

There should not be a parallel aux device for the VF device, the
purpose of the aux device is not to allow you to find things like
admin queue objects, it is to represent a slice of device
functionality that doesn't already have a struct device
representation.

Drivers should not attempt to 'dual bind' aux device and pci device as
the original vfio patches tried to do.

Jason
