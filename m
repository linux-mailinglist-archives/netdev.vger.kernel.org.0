Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA4A5800CF
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbiGYOdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiGYOdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:33:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94D8CE32;
        Mon, 25 Jul 2022 07:33:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=feADdquyAmY2vHtxlaBAM6Gr+BtVzvAS+RkjwKuk0kvJlvH8wrUBqgE+wdS6UYmfDM5sTwieYi7N2ojhYNzl9s12HyJ3y8Nn7mibJ/HQRWE68I2KgXGniXSzk9ruhwpoK0gDn7LvVSqckGeL2yW2tBkZwoxLyiVhWTOwsyXajQvs2pyydmhmSauroaIBSlMZ0ijwONnkn+6vi4lqxLJuVouX+f3YY2Bn/UuCj/n9Qw93XplNgb/co/oQ0oDTYD1jhfv2cmKlpbk/KdPS9FdHjkIulkTCkqrFdHdo8oVcCpdhdH1ZGXAhEJ6W6iqXLUHErpZwfA5wVb8bVyCTUthtxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oW43rfGm6s1bxRPbrbEAI7eGtQWxvIAQkcEoSnhlGpo=;
 b=CB+FZfBA2cRzY1uzffMiolvQrj3Iy3agOK9QZ65XtjcYbstDC/Qq5gbImn2JNjSw5Wt/lbB0TO4L5p68ZOx76K/4gE+7ey6boYITEy9G19MZfK31tlPt0qjyaT1uNo647TIKQmnoAfl0+1DbdDF7APawziL11Z2LtixFoy44p3GOdh+W6FrFB1IWpvsRm/tZI0/7fNAZAQcby60jTnDzKF8CwHTTtBpfInDCxpcvG8edXHqWkDtdLOyIAZOnm3w8te0wEMGptR78BZtYsZvRvQKuK9yURa77ObyVoBVg5WF4F1NtfTrGYtiDVd3ldQ4EaHoMlDvuSh6gg7+/gAv/+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oW43rfGm6s1bxRPbrbEAI7eGtQWxvIAQkcEoSnhlGpo=;
 b=nthN9kSv9KLirbvrpHn43G1anIhdrZBSp86vrVGwFof56IIsqgISATASrVVnMUGZVY9YOSwpmnmTlewM8p1SDzoHPMDbIyr0pWjfITTaz8LCM4E/q+9AwBcWRKzrdzhAS1U/12vUg/WFenzPTt02Z93tKyu/B8l8JFaojYM0N/6mX1tfWhxd1qUsNJXcqP57vt6ELpiMxVMpK4IbDq/kdm3FlBykBpJXmCCgovQCNCaPLuE94RDXYCIwhaFLwkD+uJYs0hH/2FFCT+L0TkEinY5mU6FZ27U+QEXBayW2aFAosCp9uLZyI4ugLL1BroXiH0103ZaPerXfD+BronQ78Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB3557.namprd12.prod.outlook.com (2603:10b6:a03:ad::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Mon, 25 Jul
 2022 14:33:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 14:33:05 +0000
Date:   Mon, 25 Jul 2022 11:33:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <20220725143303.GC3747@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220721120518.GZ4609@nvidia.com>
 <BN9PR11MB52767FB07E8C4F3C3059A1658C959@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52767FB07E8C4F3C3059A1658C959@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MW4PR04CA0242.namprd04.prod.outlook.com
 (2603:10b6:303:88::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 325ccbd9-97a1-4661-1725-08da6e4a9658
X-MS-TrafficTypeDiagnostic: BYAPR12MB3557:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64D76EaxiwXsyMTA7Oxvq5PYowt+Qrpoa15+ch35RSqTsBt9Iej7jio/wCy/bYbbdbgnDh52zbCjhd17h26a8Sd7v2dL58F2zYHa27VCiG7EdjLIZsMFboxRcRWZexkOefHFX9sY1VopLsbazmIEVem12tEIQYQnVNHJDqbEjdGoDNZtzygew1Gomin9L5/naqe2E9CcaLJ5CtlEXbCeIAJvJzEHWwQBOiSKyMMx0jDHIkS6ylCUzpRRs5p6kCxSSs820n48SV1zL2SuyyA2H5CQPVcrPQQpRMkHXpceYT/0IhUZ/IFYr5iRQye3Zvma5RP/g9VrWIvcvAp0srUmo5WUS6N2VLVoJSFa9szdVuMjmd8nTfBh6kedP8p5E/NjXQGP2LTezJepos5zqnBMJ9532c/yc7zbTtB+zRHmCs5p171qT4l2ZJ6cEYcIy6UxOpdBbH1DkVbI5oR97qi4VchoYPa8RJjHQpTUYtXnikX3PBf7x9jV7gQYWDwqLCBSKVsSFw9V7LJg9WRTGbey855rOP41B4J+vU2WIRtUxlBTYqQ0ZSHuwKAVzKuswG78IUU5TR6hFsd4MhLJe/ijGW2uebLM4ZwYoxXjGFh9sxTuuo2bDiEegrd7zI/SPU8bL7Y4L++F4/JRLR0BpLVIetKAN2T8m5FTo7h5/92IYKWPqw3KWXxl5CUZMNrMsqyZHIhmMrg/4lF2D/nfWOFTmpI4sVfQP+RBUIh+F9rS9RRlC5j7M9CUZaUdnbVCnulo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(38100700002)(2616005)(33656002)(6862004)(86362001)(36756003)(8936002)(2906002)(83380400001)(1076003)(186003)(6506007)(26005)(478600001)(6486002)(6512007)(54906003)(316002)(41300700001)(66556008)(8676002)(4326008)(66946007)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gb4gHgqA1F33WWYQqnd8F/Ng0oZJ4pKJ/1uUqyoL4+XH/TPEtsaB/5I9lPIS?=
 =?us-ascii?Q?B8881V4WIakVQ+k+bgW5g3sI/glR3GguojbtVgon1feuPLQejIHfhWoQ6+lx?=
 =?us-ascii?Q?oflScuMSawdnJhM27WKbK9nncVMilSk20PEe28LysaDjOhn2LX01uHJyNRUn?=
 =?us-ascii?Q?8gczWlewxCGZrITfpPEL48KREPsfsBjg9cnmYKG9gT7AeY7IVXRXfBq7l6XT?=
 =?us-ascii?Q?Xd5AfiIgJofngUnqPyYEjarmto+jB1KBwXH94HntQ+cjmKJoVxYPdVkRLJNV?=
 =?us-ascii?Q?WDLbYQdxv5Y71ktvjMgd7f6Z7Te1OYF3F0rggrG+R5r2lVuADhJDmzkpoRJK?=
 =?us-ascii?Q?VsxoayGl2z3xP/200dAnw8PFNkypK1EOH/MAIF1X2BbaRTK/YZRISwT4XEWK?=
 =?us-ascii?Q?emDmo3KX3AM0pWuItXD8IxLAbtWvE2l87bCjWob9xaDuRarLIJdgqB/huGmE?=
 =?us-ascii?Q?vzNuNHXJiR01ECWS8CTYjHQor53XjpNbTS1v3/Xk4EYRglKznti5xUPjmWS2?=
 =?us-ascii?Q?wsWXhJ4PU/FLgLW5i2TQ3GnO4Q/bABqDPVDbLxbU8sp/8B/oNEK6gUH+BX+I?=
 =?us-ascii?Q?xXvDFRPiAG/FPNwT28GG1BqG5dc26E+A7oQFvWFr9Jim9WqjKF0W6dGDXUNo?=
 =?us-ascii?Q?x0HF1jtmV7t1OSY9DVse5gVulDKZeP+mEI+yrLkMgStQ+sZMnH3HcYuBgc7E?=
 =?us-ascii?Q?5SLj6VNv2aC3XfuhYk7UW3jJPS6KU21PF1aF+A5+w8nn1cDb9+xJ10yPCjag?=
 =?us-ascii?Q?KnCNa/ae9UOwoRYwLcmzZ7e7Oro0RHF/u1NGzC62gShNACrsPb5kiQ7LprUm?=
 =?us-ascii?Q?e66CE6C0SvviVnfgdSjOmv0+2a2tr5iGtuiuQdR+dEzxfuCGz0kJstppM65y?=
 =?us-ascii?Q?+98Ru9KFseUiVI6HKnDRDSeTTeX3HQ9tKrActJG2mpMJOeBAwEvjB7ww0ZC2?=
 =?us-ascii?Q?KhlDsBKB8HShkikWcp+7/9rt+9O+jXRTlaWnlDkSR6dKwjRMNVMAAhupbsWs?=
 =?us-ascii?Q?VPFnqKjC2pBDxEgQBHAp12F2RtKapf4YKz84xO2UXemuPXNrksDc8wIBHl3z?=
 =?us-ascii?Q?clfkNkA54rim5no9uXUhG33BVlWi/MQqOaBgO6nTbMMUjfu5EuwR7duCtnGD?=
 =?us-ascii?Q?x5s8tCFmdqvQiT7S/3kaYcbWBhXjT3uV/2POQW5to1hiEFT6s/sEbamMGjE7?=
 =?us-ascii?Q?xwydwd29diWLOlU6hR9ZpSpvh8M43KgQx/vrR/tlHiM9Bn6cW72iPeZZoaIn?=
 =?us-ascii?Q?Y0p2Amq1DwQTH1Tl+/x9lOJ0A+KaExzS0YGMpapXcoIpidnERuw/2/NbAySJ?=
 =?us-ascii?Q?3yGgAYuIDa4PaEZMFgePYUBUOZ9Mhttf0erbqlPrOUIsf9IjmH+r/ZHsPWIi?=
 =?us-ascii?Q?bQkxmAsp6Crlw+fCZZj+HZkZxTBPrPZ4IwgO1qpy1E2bFW1NTIYSHJcFOX9Y?=
 =?us-ascii?Q?mU3D72PSWPUpeAdPaKo4t1RXQLruQlpy/uR5YWDgevaTGDyTUqSNYEAztcqB?=
 =?us-ascii?Q?Lal3ZtdV9ZczvPdKwx6/j10sIMs8dk2BSo64UChWY6yMbabTTGu0qRNZ/PeT?=
 =?us-ascii?Q?rOYpBUQ1Pql9AkovmfJa+xxpPYeeZgxRyEiG1+uI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325ccbd9-97a1-4661-1725-08da6e4a9658
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 14:33:05.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NspotDGPr8bsqOJR8xAEwMn4zC3eRjPXJ+yzjBUPS3bjSp1jnVjCf8x7DEkM9LfQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3557
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 07:20:16AM +0000, Tian, Kevin wrote:

> I got that point. But my question is slightly different.
> 
> A practical flow would like below:
> 
> 1) Qemu first requests to start dirty tracking in 4KB page size.
>    Underlying trackers may start tracking in 4KB, 256KB, 2MB,
>    etc. based on their own constraints.
> 
> 2) Qemu then reads back dirty reports in a shared bitmap in
>    4KB page size. All trackers must update dirty bitmap in 4KB
>    granular regardless of the actual size each tracker selects.
> 
> Is there a real usage where Qemu would want to attempt
> different page sizes between above two steps?

If you multi-thread the tracker reads it will be efficient to populate
a single bitmap and then copy that single bitmapt to the dirty
transfer. In this case you want the page size conversion.

If qemu is just going to read sequentially then perhaps it doesn't.

But forcing a fixed page size just denies userspace this choice, and
it doesn't make the kernel any simpler because the kernel always must
have this code to adapt different page sizes to support the real iommu
with huge pages/etc.

Jason
