Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0FE4C1C00
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 20:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244364AbiBWTSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 14:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244326AbiBWTSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 14:18:11 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7740F45AEF;
        Wed, 23 Feb 2022 11:17:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abA5V7sLye4XcVm6WeE8pB6FfQsz//RKz3bbrkW+bjrJALAvp5dmv9yv8u2Xb/3DjBgNkaZkqhRirOuB+/WVpvmtEjSxmm8Cu8bZBwSznmOIN6e9ciSoOZQQrxPPdHq2Iyqu871eElM4FZ2ev4GYWjBo4Pmy5bD4zl/mqejKDYAIzuJhVeDzxP8Y/yqQdLceRpbUznFCEDCNX5qwkK5u7RlX8wkWpU4GHqpOdgXqC9/tIEcpEjuG5tikFnb7G4IyCMkq6r+cZ6DOFSnRLVRX4TKqsdpo8TxG8n8wv37VOn6bTrtIs7U3txZpsN401O2RMtUqdjHbTa7ym/nDDcFfZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVzH3y6YlW2vJaeqWc8c5XyABKNW+XhQyuPG2AqIVbQ=;
 b=ORnlhiQDmpMf9FYEQ/jeTBBaR2LOyvxOd2bx5V7nw/yI5b84oTOUW4kK4RonW9hgu02W0Gfwdxh1ho7FR9fnmEiJcOQUXSF9nKEJVWHPyUEqtoBNji2M7shLHG23WFUeaj1XF76gnQS2kAT1HtspAo/ZYxVg0g89cQdbZ+1u7b7xGg3G38pZaUAKd3JSWmhPDhFALxB+tptlYbGkHo/BNIdk8m3QSYpTcWyS4dMMCUeZdeqIdeKmTeWeRwR20cGbll4G/7cCmSl9bnS9eFF8K7Wu1LcUzQjZjYEh2yU9u+1ZMQrcizzGsZPDpk0+G+tMBASSoTTSWORqtre1X5ohQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVzH3y6YlW2vJaeqWc8c5XyABKNW+XhQyuPG2AqIVbQ=;
 b=G5qPqTamdIw3Uip1cggRhBUvZL/NMcjqJq8EQGEw5E34oh7Ma7Y/HskHslfAG5+oQHBCEr1NN91Fzlmd4EIIppOSx1khlMpjGqNZReobitdYZhOjqLylXVQYb1g8rgRZmau3yei8qGgZRKhMLJxsaSiVvEPWkSy+1Ne26r7j39IUV36Y0M+n2g+ct0hc0yHk1BpsJECb4HT6hoP4Hg7xxTXxOc95TKPceOuSoEGdwSGwS6/8gr4LBXFrhoaSDeIRkbmOWkhOC7AbojjvYZhoqPXLjF+DsmMjLbiDohDQuIc9OYAR1Z/+0pC8zajvC2D0g09KxK6b+CUetvh4/ThO0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB5556.namprd12.prod.outlook.com (2603:10b6:208:1cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 19:17:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 19:17:40 +0000
Date:   Wed, 23 Feb 2022 15:17:39 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 06/15] net/mlx5: Introduce migration bits
 and structures
Message-ID: <20220223191739.GB408623@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-7-yishaih@nvidia.com>
 <20220223120902.57b2c32c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223120902.57b2c32c.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:208:c0::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c75b1d52-ec5e-4ebc-dd77-08d9f70128c2
X-MS-TrafficTypeDiagnostic: BL0PR12MB5556:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB55567769C9E80B46A7F24A33C23C9@BL0PR12MB5556.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vMw7bG6TrQ6vAAt5GpyrHYNp9IpFebyyKnrxsZo3c2mYJ0kcHfIYgVwQOdZMMLmiWeaJkq+50+QcE5oYj0jWtv010guNOxIibQ2ciVl9YuGKqOzXeZkiF+gBqxbrbFhFlDe/j5e9WZKn0tJpJ6H/crQQ6r2C4FpPnanT5/ThuMduBsIrRsn9MOZZgD0j2VqOWshIN0SYvG5y7gFg9Hyac/4wJnksIq0D9p0BVvzdBp+43Xz1ly7Q8Xs6K0TpbmIUxZizbujdf2ZvZu8jo7Z2P5SRddQP0lqMKFtetK5HSwvz6eDrdqv21/l9MhPlKaspkJmZS0ENJHC1zjEYYSO+ujEUApUCuBDOyoxsFxQq1q3qCzg2ow1LThdBbjI705Uty3LihRbkzhgaWCriPErvIsTb64og03SRngOpWzt5jYo++giTyP6RLRYCmZstQzyRfOTzircr3M86XsycJV1HeCtcTYxfBTg3ea5BmKnGperq7TLUGYhrakzGBLwicIZfeZyllMlbbf+487blQn6i2stRl8TDs4jme1W1t7Fg0jMVsf2YPByktBykCJSNFxukZJKfmGtEd8BCVJv6/3Kp5yfQ6wMgsLLtw8fH0zEY42rATu0diqqE3LLyF6BjNNqt2bMOfpdas4BEDLYodY4kzTRj90omchmSMfhyJXtZGEYk0Zv2RSPl3liMiOUsbNs1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(4326008)(8936002)(33656002)(6916009)(508600001)(316002)(66476007)(66556008)(66946007)(8676002)(38100700002)(6506007)(6486002)(36756003)(186003)(5660300002)(6512007)(7416002)(26005)(83380400001)(4744005)(2616005)(1076003)(2906002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D894B1REFngcC/Rg3piI2tgzkFhpW+Auws0Jgz9Azpy69dvG4UIClNZD80d5?=
 =?us-ascii?Q?bLn5Fm2vv1x2g7nFqHKh1JeekWIzZMelqvPzL0woZ325vGCGdpdqEptj3yn3?=
 =?us-ascii?Q?qC/AjuvK7H/zXDXzGf08TU531HbPsMRUdLcT+fNlxy0pkWdile+DDHrZIkyJ?=
 =?us-ascii?Q?/jgakbcbSiJkjq5WGEkgceheGhTmjpotBSfbANlkxaD0Smu5ELxlUmtKqUb7?=
 =?us-ascii?Q?BPc5CMDNYUO7KKjsEqVQM/ARDX08YeFez4k5O27rMj6eTjVnOWMlp/j5HY2x?=
 =?us-ascii?Q?38WqO8Kh97cUwbQ8wF89MJl6LpLWV8mL5wYEwK2Zyq5vef9pkVV1i7VGYj5b?=
 =?us-ascii?Q?uw2AfXziBXoKdPBvI++CsWrW7A/cbZFKpyuJwwRU6CrqlnYi7HHCiH53sQOV?=
 =?us-ascii?Q?xemeyr0LO/T72XG5Syu/1GXSwb2vtn/PpcqBEd1zFbgnaunea6eTYUYuSLo5?=
 =?us-ascii?Q?VddC8hANmFmU41TEwVHPj1PZYeAaarenhhxxG9Yl+l/oD+3mpGvlShLd+Civ?=
 =?us-ascii?Q?rENyli2FpBHt+kgu65FIgScYCllFZvuNO774heowR2kEq8LNBx08CCphtOPa?=
 =?us-ascii?Q?W+o3fRc/UW3iVXmhDXfBNsw//NGSDDhzvnx9BP1UqZ90qhLtUyXLMJy3wGXy?=
 =?us-ascii?Q?HIR0qVpbNV7Eoirsn3cIsXKnLWZ3i56bqsAhZm6Qiijrx1j0zmn8sKCzxq0O?=
 =?us-ascii?Q?v0/zAOZAkTw8jelQbqOIrd001DFK6goENtC1tovys0p3e2045/VdZ7fOGKXy?=
 =?us-ascii?Q?ssixJImLDpgvSSEZpbQ0y5rpxGGthNAyDmF/B/P0TWOjc0XysZRRSsv/BnBE?=
 =?us-ascii?Q?PYE/NRYfFXiOQ/ZCKTjQ6bZaM9ijGnvFH6odMzxgUXgeXwu+i/FwE6PzBTEk?=
 =?us-ascii?Q?ITSMeROaIDsDPUy2fh2yASW8MwQCzAE0VWRH8ZTXi1vL+cR7Gzenq3TZLsqy?=
 =?us-ascii?Q?VrkDWOFANnXyOjGFAeojT+tO2XqE9ES6yxPdM4BVbU8nXpZEu+aK3rTiwUpG?=
 =?us-ascii?Q?MelvmcKOMJ4c8eL64anOpJwL0gLPEraoFCFiYUV171Q1jprIQorI/yTC/i+B?=
 =?us-ascii?Q?p+eS66Vb0s6gWZ6EO2qhm6wyUOuHn7ktT9MkPEAaS9S000UyYEdOrQpHDIM/?=
 =?us-ascii?Q?kx5t+Ay8ZMBjuW6qhPv/i16UZmQXTmTT0zqTxIo3m3F1kSkC8ws7/MVSvyMN?=
 =?us-ascii?Q?NmD00Ghjt+SCEAx3eR+wwrqCcrqVlH11DwrAtwWm0BbS+c459OEw2agSD9sf?=
 =?us-ascii?Q?mbQ9nc4W9TXjQcRTMOKNTD27RTcpf/6F3qKbQi2eKbNUdQ85I1iB47qFuAkS?=
 =?us-ascii?Q?Cn7goYikZ2k+N3GN/lvCTKhHqlzSgPD8GdW1oXypooCcL84NUg+3GD9eGhOd?=
 =?us-ascii?Q?Rlz+Ms5c3WlWfqvfJhkLz+0G9KxUcz6OnGok1BhrbkREU07BkoHmHSestEFC?=
 =?us-ascii?Q?UlIuUyvVphFgW2yHopaJX7GU1JMhOMGTRhTRO42VAuOxrk8GUjIFzU1MOjXM?=
 =?us-ascii?Q?T49KOu0B60e/Sh73eJlBKE7Cfjwo9QZvhgbBf+f0QRXHZQxQcUmn3wEEBraG?=
 =?us-ascii?Q?+lbHOx4wqQQs7Gpf7rk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75b1d52-ec5e-4ebc-dd77-08d9f70128c2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 19:17:40.1929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4TQgcf0wkRRXOkzYkEQnHPEj7+Jf+aNINyu/L5e8xupvh1pwPlJwgfJaWlN8RAo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5556
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 12:09:02PM -0700, Alex Williamson wrote:
> On Sun, 20 Feb 2022 11:57:07 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> >  
> > +enum {
> > +	MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_MASTER  = 0x0,
> > +	MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_SLAVE   = 0x1,
> > +};
> ...
> > +
> > +enum {
> > +	MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_SLAVE   = 0x0,
> > +	MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_MASTER  = 0x1,
> > +};
> 
> Please consider using more inclusive terminology.  Thanks,

Lets use initiator/responder - I think that is still aligned with
PCIe?

Jason
