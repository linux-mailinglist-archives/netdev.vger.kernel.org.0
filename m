Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC69B6F4320
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 13:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbjEBLzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 07:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjEBLzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 07:55:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2122.outbound.protection.outlook.com [40.107.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D12049C6;
        Tue,  2 May 2023 04:55:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fN1oYrwfLBKm8xdOQxjCW7WA+Gw1LQxPuHeMEGLWFdZ8OxtKkpMDbpbfz/6s1m/Xj+0Ak8Gvv1WyoELgegfadQ8KFYKsBtkFAQ/bUv0l3WTC5eHRCDEzyvJ7ts+XTxE9JNIXvRXMCwcA1QNIcA+BSq+44Gbq+ywNb3WHZVODadnfWuyiZuC0nJsrXiveFIueEnandmaQpqSOxU7NRr2MzZeaukQH1lmI8EuXbX+hO8UhjHQWXTboX9mBA6o8mPnbRdg9OT+UaMsTN1PAcZf1iMzGDAWjErp8m68ZHACYSZdZ8W1uQ7aGc/4ZCwxKqGuPdnGvDc0S/8EG2f6OScCc2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LwlhMZ8PSjxyu4YaluINCyOvEuGXA2RcHgQvtuXeaw4=;
 b=e0CJnDYeUNpveeXZ5ATPk10goCp7ZNobX45aQrKi/lRLcmPfoNtBn+sLSMPbOp/R52L0eDaeh9pra5pKWxlmwV5Bi90nbWXh+sMAPYqHr2Cl32lGVntKkUyb+lPh/asfbOSqvn1jExkNws6ZFpVbiBDUGrPE/RmLvLszoveLREbdllRJeaOvzRCbrIdy6o888fw6K4HB03xhEaChjrmqSu/wkf6MqbxLm5KezEPpUAnBnqS1JyjMnVyv58T7XtfT9+jEtsDjwf3mhk9TahOVTNwYkY0DqZl1pzxTLR/YT6jLpLk8hR5PH6tINvDiJooDw8HTHXOSBFZr2M43Moanpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwlhMZ8PSjxyu4YaluINCyOvEuGXA2RcHgQvtuXeaw4=;
 b=Fr5AudOr8yHD3hXq/G1zuFrsq7Exb9WeoVFzmnK8JVjUtf9vw63OCgggdJB5YjI2UKaVjbkLZLBjRf/u8m/wsjQdKcC8fsS38da7RZ5NVbAXtWfkoaYvnxPmP6r6PBKlVb3Ma1maQ0dY+qnVeuL6FS0SBFjKPF1Wext+4eycNKM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4721.namprd13.prod.outlook.com (2603:10b6:208:327::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 11:55:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 11:55:12 +0000
Date:   Tue, 2 May 2023 13:55:04 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     Sai Krishna Gajula <saikrishnag@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [EXT] Re: [net PATCH v4 09/10] octeontx2-af: Skip PFs if not
 enabled
Message-ID: <ZFD6GIS+lrVn4AJs@corigine.com>
References: <20230426074345.750135-1-saikrishnag@marvell.com>
 <20230426074345.750135-10-saikrishnag@marvell.com>
 <ZEj2UYNavsn0xE/D@corigine.com>
 <MWHPR1801MB1918C1AE94BB287FE29FC76BD36F9@MWHPR1801MB1918.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR1801MB1918C1AE94BB287FE29FC76BD36F9@MWHPR1801MB1918.namprd18.prod.outlook.com>
X-ClientProxiedBy: AS4P250CA0006.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4721:EE_
X-MS-Office365-Filtering-Correlation-Id: ed00a6b0-738a-42bf-2636-08db4b0415ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNZZerde+Q/9up11wdkQnKVbB/lEBvRxdDNibVw8wyj/Aza0foET8/urBxCG2Pk/JqWdH9eB4ZO67QuzF/8sUEnAJf96w9H9aX4imi4P7bXUWvFkfqbUQLkIemOenCYtZJgCDSz4u+bTBbMQZMvA+4esJiU+IPPwq31GAXgUBi8PANOdaxBJrIn80insrjJqWtahxUYWYUQIQJlQ0PXU15uLSGbgHtrj0yzHKP4JqW6XlUnpDKqtyZf17zJH9Arx8gBkLpwJRp1sv5e0GkOmNGDkzz+nFOpkvBwcyBs5gXhvb0Eq8egbQExyQYwCbL62+eu3UGBNj/ajjRHJ8gIVRlDkWwMjHBBVMIGKqLJ2Lc4D31s8V9CXLbJbcvSgeImQTjJbCz+nl9RXYUBx/V2YaBavrFKQJGPtZCv+aDj0eZQBjclDiieGkzehmsTvTaNIvA8bZk/LKY7+Ma1GOC5Gib9V91mguYIgA5eK/X60WWWkoA63ekk1crUolJFGyeRxNYriDQgA7km5iOubyzaVT1HxI95So52MVrNJdIUiICT/HXp3ZBBikdzfa79VTGH0jLzwEvhKsmOs2db2XvB2RqC3OvFFRcWI61WyAhsxHg8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39830400003)(366004)(451199021)(38100700002)(478600001)(8936002)(8676002)(86362001)(66946007)(6916009)(66476007)(36756003)(4326008)(66556008)(41300700001)(54906003)(83380400001)(44832011)(7416002)(2906002)(186003)(316002)(53546011)(6506007)(6512007)(2616005)(5660300002)(6666004)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9omMJ/8wIwEQBvb7xuVFrQBhXQ3kwfxz/BalOFdnJEQpeGEuP7WJHWHPGsnt?=
 =?us-ascii?Q?5ukJ7rvEeCy+c9QwngSvubT1oe1YYCrlsxN44iaYx1+At0IFxllDf7odS32+?=
 =?us-ascii?Q?Vyam+aT5UE0KHa+PLKa6RtU2QRJI4OTTaZrsCpoVdSYQzC8lQMA/+ltqtpjJ?=
 =?us-ascii?Q?UX5rxojFlVYpJKxNoyBmie/5jhVcA2CT/rnPdKT2g3Uoy4OTU8ypJSxf3jrs?=
 =?us-ascii?Q?i9AMJfLpA/P5f+dqnVf/JeVoH/PZauaYpP5OTuFvNa4QrNrYz61ftsYMRO2O?=
 =?us-ascii?Q?vT8cNHhfhXXLGibiUWOyGrJqFDhhtUqXCmYA9CeEwA/I07w/25SVNXs/L12+?=
 =?us-ascii?Q?NdLs3hB2u1tLapElNxEGYWQLnEe5FgsHsHNKnnQyhnQf6DRJ2K8qXUnZSW+K?=
 =?us-ascii?Q?vPYcgdHaQ14mwU7PzKjT4ahyUmKgjYR+c4ROgxlcoS/E4MFcJKlEygrG50Nq?=
 =?us-ascii?Q?pLu0o3q/2ywRsPbFxLToXQV6v/1sGFj+4zdA4cctMkrmiJ/u49N76jHr7SHh?=
 =?us-ascii?Q?2FqxsZi+rZyEItMsg/njT61vUZJRuhCONYaaZnPmqp+aXeKYvLlG8eiesVEL?=
 =?us-ascii?Q?i+NfTJxduB/acDiPYKuLbnWPbNmTg/gn0t8pDtutQBlCKmJwNjcgXV4zbBvI?=
 =?us-ascii?Q?Jq2h49rGksl8L7bJNE5+Zp7m0S7wFCepVqbv/kOs3cxpGa+DDAKmSHrHzrUS?=
 =?us-ascii?Q?fQjkLXk1SiNzppWQBwMSAy2P1xaseT496v2fZIuWbQPkzNFLF1UlAvadb98T?=
 =?us-ascii?Q?xGad657/c3rarP/oVKOrIgYQzu7MDZcwEkcNA3iOjg9vcn01mRpVN+Dch2jn?=
 =?us-ascii?Q?DZdUsfiARjH+dN5fMjWGSthl+E/2cgJB6Aym7hoZ3XgK0fEKOdmioPbCuUIQ?=
 =?us-ascii?Q?8j7RQWdM1G1tEfqY8YlqRMwzmCn9WElqjCcIXoALQaVeOZVButzGfeoecteo?=
 =?us-ascii?Q?LLoF51wTZuM50Wpc9tui1E4fOVMNGimsQV+hys4E+1mtINA2Mlnx50GWb3qg?=
 =?us-ascii?Q?3GydHUtIhSyNWE10BWgYRZVECmNnvoUXtBw2fjJSmeX3o2R1ZoemMPTLXToT?=
 =?us-ascii?Q?GgsRQ8O3jC1RrrgOK0kDjoDTgVZcySbTv0qEQVseLxR0ce2oMOKHc70tHZWe?=
 =?us-ascii?Q?9PFAyam+87PlSAZM5kVYeh7PBkxIzdFIjnThNlUk0KrqxbJ0XJUKg3tFuce9?=
 =?us-ascii?Q?GbK3pwC1THBJJE+phh0RWKWR5QrUfDMij8mYLq1Nmn0N5JdjQqqrzgIS6hkQ?=
 =?us-ascii?Q?1HXVAo7xhq8Pan+hvd49V794hgiNmFNAprgIcn/ys8qcButoxoEU3ARv+DPt?=
 =?us-ascii?Q?f9mRXVi9V93DyJzGUNDXCSJ+hvVAlSjVhHqT6sW82uyHAtGJJo/miXs+Dox/?=
 =?us-ascii?Q?AFMy+f/5Vm1QT4s12lNZwvar9LqZr/JAU3VH8Fkrzo+gFYRSseFtojSxFtY6?=
 =?us-ascii?Q?+zXBpP5QhkzGnrsQXyH97turK8yk/iQalczemjTLDTawFs9QK4rYbRvxrpw4?=
 =?us-ascii?Q?DR+n9gfgYrpnc9aFRuGK/Ki3GJzHYrIQkff+7vEfie88MNaJ+wn1DOQtwVgr?=
 =?us-ascii?Q?vGJNP3jhKKVKHpkjsc1XqO6JGckKmpazmYzIRbWmVbcypTHBxvc4UyI2SvHU?=
 =?us-ascii?Q?joaYwPQEidxjngjYXQhldipooX57PMfH0H/iNdi5Jw+Sp3e/4bZ5coH/+/A7?=
 =?us-ascii?Q?qYxM9A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed00a6b0-738a-42bf-2636-08db4b0415ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 11:55:12.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gaRMOLeRlYJt5fvnvRYEfR5KULAHfg4Lsmatq1YIlzkr3sxb3NmK756BK6WXoBWOHhkU4t4wDqdvoEQgvPF/IfuL6mF92620kkjD9/BcsF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4721
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 03:10:53AM +0000, Ratheesh Kannoth wrote:
> Hi Simon,
> 
> Thanks for your review. Please find replies inline. 
> 
> -Ratheesh
> 
> > -----Original Message-----
> > From: Simon Horman <simon.horman@corigine.com>
> > Sent: Wednesday, April 26, 2023 3:31 PM
> > To: Sai Krishna Gajula <saikrishnag@marvell.com>
> > Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; leon@kernel.org; Sunil Kovvuri Goutham
> > <sgoutham@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> > Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> > <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> > Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Ratheesh Kannoth
> > <rkannoth@marvell.com>
> > Subject: [EXT] Re: [net PATCH v4 09/10] octeontx2-af: Skip PFs if not enabled
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Wed, Apr 26, 2023 at 01:13:44PM +0530, Sai Krishna wrote:
> > > From: Ratheesh Kannoth <rkannoth@marvell.com>
> > >
> > > Fiwmware enables set of PFs and allocate mbox resources based on the
> > > number of enabled PFs. Current driver tries to initialize the mbox
> > > resources even for disabled PFs, which may waste the resources.
> > > This patch fixes the issue by skipping the mbox initialization of
> > > disabled PFs.
> > 
> > FWIIW, this feels more like an enhancement than a fix to me.
>
> [Ratheesh Kannoth] I agree, commit message convey this change as
> enhancement. But this Code change fixes a crash in driver.  We will
> modify the commit message as below in next Patchset version.  " Firmware
> enables PFs and allocate mbox resources for each of the PFs.  Currently
> PF driver configures mbox resources without checking whether PF is
> enabled or not. This results in crash. This patch fixes this issue by
> skipping disabled PF's mbox initialization. "

Thanks, much appreciated.
