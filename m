Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB49852F588
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352285AbiETWOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiETWOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:14:31 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EABD19FF59
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 15:14:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgReqXZrfgGRE3uvBKuq2rADw/mR8G+ZdtgqSUkP10P+MMjkOsivEAg8RgRrE9omHEHQHrjLrgIlq0QcA7a3NNCS7kn57L1yDsE8uLq7QC7dYejXA0EcSlj8pZrMtDhRVRQ3c1AkLHwifbccgPnWMYsdzufZMUdqKVfoBuQSLqkKNwh7ObHvz5mo/CnV4J7vAyDjr1FH4tY+wrLI6W0G9Mb8iQb7tbfnt9U9aK0lEEbnfXaeODK/QQy5emuHPc1EvCq+5i8b7kalai5WdsG+PtX1WpK03s9ilo62+UcWETLVkC2HRZGl4S7wKHaaB1rCfRSDRffArGHJTLL/Mrt+aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05Tl/0L8QLBIMxuCkQRBPpNQaDdscOX2lP6VqqdzGYo=;
 b=F8xdR8FAgGbiODA4UvPaztvXe33k5DI647Al9thuUPuFyDXEbje9aQXAmuWinP3YNHEPMlXVMZz1DIvLV0Q21ocflL8U+oBVvZUh1La0e+W96wBcgxPELCOCpWyt9Mx910STARS6p1v3G3t+pzN8XVeKIwHm0gDtW3dW4+Rb5o6tsqu8VH4e3P2r6GU/FAW2iXUlHph0BEp4tSm5B/Wi1t2orHrV0APSYuSzZIO1alE2QZKeQFqqVI+szDiVFst9fOXmiDmgIegb6bFZIepOUgASTBrtTbcCWsBZ1XVBGVKrsina2R9MMUM7qbwqe4lSoJGhndqSYfBIQDqB4ub0gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05Tl/0L8QLBIMxuCkQRBPpNQaDdscOX2lP6VqqdzGYo=;
 b=eXQ16XDrLZZHzRgLnLkbb/YpkEFchkRrl5nE7QXECMS3Pmxhs76pNd3tHZGFwY+A7qoEsvrT4q6oLgv0CwORFFWvtLThkxsvSvnwSaUM5FwgJMFsIWk4bhMx2j8BU9LrHDz6E5Q6diAeq+IOajOETAO2qrLnByExeoPMO07xRh3aulR3iFo8neIzMMyewXCyeS3zy98Y0majss8JkNdROobY/aES4bBxe10mhubxVSU94G4h114QUb6IWxYHjLqMxsYgO1/wXSFgwzuphTU/4+8EsMM3vTlqRPbIIE2UUM1Na6b9cp8dRCpCrXVUBKlR0VmcxAJ7XPxWmB7bM7dXmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR12MB1815.namprd12.prod.outlook.com (2603:10b6:903:122::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 22:14:29 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5273.015; Fri, 20 May 2022
 22:14:29 +0000
Date:   Fri, 20 May 2022 15:14:27 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: net <> net-next conflicts
Message-ID: <20220520221427.nx3fz7rfgvez3kxc@sx1>
References: <20220519113122.6bb6809a@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220519113122.6bb6809a@kernel.org>
X-ClientProxiedBy: BY5PR17CA0037.namprd17.prod.outlook.com
 (2603:10b6:a03:167::14) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7817a4d6-cffd-4404-b3d8-08da3aae1b8f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1815:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB18156A0BE5583E959BE2E0B4B3D39@CY4PR12MB1815.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zHgqXxrrKiOyQ//MIWXlgQycUt6e3Gpot6hLD0omqx7nkQu+4LBeeq+Dj/0EavoZNpyT7WL3UxEH0zmRILPulHbSDPxbHYpSXC+A9eZPFbe20SRDaZ9mYvDErvjhSbM6lsipecqAdfNPjk2H4uNxRmdoTd0RYQHZcX+KgcS6pvwi80QF3uVlx8JlqAJV/ieoQEqG+xQm9JwO9f7FzlI6NUHhvIrcag2YeDzslmVBD02DR1BzvbpWQ51jSIh4mLGO3zic42h5dCTYsNQdtO9uN5HM9DIAXMNGuVyawNDhP3rni7V2YXg8+DxWnbb2b9anJYF7OGM80RX3reeYV7GGUE36i7BPMipl/bD5KXIsTYAqLtv1ZonYQ0r4VWVkRRE8gMt85W/Mv7u+WBdPZNlGS40pOKfTJQIFfdMiyf0Ui99axiESLHXp1nVrjEuZN7Nfj5Hp63YQ9Mx9iz3jKzLnZQNSl14Y66qo1YsfsUae79fGedSFFccYv3WazAv5azco4M3mfUZ9xDI3GkVqENhjCVhZLuWh3MdeRXi/LgS0FddN4gd9SLb80sfEdgBMk/lW53V1MndqosVTcaRZgaPMqPgx+XuUUdY0Fd3QmvBv+2qTgAocUPrxxAtaNy+/1DTilsAD9/K6xtz0kfjj8ih9IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(4326008)(8676002)(38100700002)(33716001)(6486002)(66476007)(508600001)(6512007)(9686003)(2906002)(66556008)(6506007)(66946007)(1076003)(8936002)(186003)(86362001)(5660300002)(316002)(6916009)(54906003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QkbEDUT2tLaePuZplhNG7cx9hNMtlOxxb+MMm7dBX/88+6irPXpte+JzRPxb?=
 =?us-ascii?Q?A0OzlgOn6lmOW7gux0kFJ7Us1b/Ocv0149YLtItOAJ/hAWuQlex+aY1T1IJJ?=
 =?us-ascii?Q?NyTVw5RHoqgHOVLDlU/Cq3n7FbCoaJKsybKcLreE0T8t2zBoXJndKWgVLSd/?=
 =?us-ascii?Q?AHEN4b3S5k2VH7hQvBSMIurOvcHcLYtHtGUxsKmExJWVJ/CqXtXX7+Ti0CWq?=
 =?us-ascii?Q?Khn+Zj710LDuAabq+8VcXqjTOcCQ4TcFdsnP+LtBDTjcM0FnoDuPvOcxOqN2?=
 =?us-ascii?Q?a2YyNSz8Uq+Aq7K0ciLMC9XbWf3KNq3GECZp3YkbEsro6iSZ3aAonB2aLOjq?=
 =?us-ascii?Q?AOoFfie3GNd0YPr4sfJvyyIClbVTTKYwoMqpwBfWj9xuWoT7DQs7/5y6qzXU?=
 =?us-ascii?Q?hEJIEE1TR4y0qLOU2AtVQTj3ZD2bPCYvBriI8JQywEgc5XALR/8Y7+DzDM4t?=
 =?us-ascii?Q?0UvYSjyXV1wmYPT0jyCh5g2Zq1h5CJgrKUXAzNT6Lt2SRE1erK8X7AtXV6tl?=
 =?us-ascii?Q?EcYFccaFpnWCTAQZ8tBiVTjy7Fcs9FAV4A/OpKTGkX2UpIaZvcyqr4Q7qby6?=
 =?us-ascii?Q?HfH+sGHUfBUTggHXEITsw9jLAVerw703YB5zRXBp4GtLUYkHhkYy3zuv9HTI?=
 =?us-ascii?Q?PK7Yj3Q+chzb5XlwVCO2+eaYA/hUude0X+uDqsoEQdcTT088NcG5RVroHrxY?=
 =?us-ascii?Q?e6plyzH8HrvTba2QCpNyUhj+JMtk2yN84OjHwRWQRNzydLAyc5RP+UGFMKPi?=
 =?us-ascii?Q?lumknu7uvKjMfD/5CdnPtgA9eRbjrb2+g5roIScwyUzg2NEV2qcHnnE1ZpIJ?=
 =?us-ascii?Q?vNto0sdfPKitI2yjWLswcoGmeieDo4S/wtXH/CxyW1TGKitI596th8Az4WGf?=
 =?us-ascii?Q?tCmMqebC+/JUfHhz7sG1PLxZ0aDQ7vYeV8RMVTh2x4VLEFqqEW4bQlpGlbiN?=
 =?us-ascii?Q?9ytfNpksJMrHnzWwh2ZR5NtQg5r5LlSL6mC8V/3m/ZViAgpfBwCrj50V60TU?=
 =?us-ascii?Q?m6U4Xhfn6d5kcKh93ljMD6Dllzm+QwyneyeIB5qibNIBwMUYl+7qlQwVk5oB?=
 =?us-ascii?Q?PbUcrzRAE8qVVBPsfSFFYYzpjUGzM2Jlfff4RhrB13gZt/gwOFidwVknKD/4?=
 =?us-ascii?Q?lUUqcOHw9a0WNpsflY+7Z2KFWLZBThJnHMw77FXr/SmIhpCfRPR0zFOExKLc?=
 =?us-ascii?Q?4hr+KqDajE2UDbFAwOuPnll/ZyLqo7VG9qp+EkNZV9V4GcU1CW1QLM7WP3Ot?=
 =?us-ascii?Q?GDwLYTGEn+rWO5PHj9MYb1uBovA9BAmooekx6Kk7si7YbmcioIyZpG/FKvWU?=
 =?us-ascii?Q?4HdbEcDzWjHSGeTwDJmAR0czFZp13epy2MfWoLuIhs2sE1Ki1bwfImt1Gsid?=
 =?us-ascii?Q?LlI/rmilx9qZM2d+B+mKQPf/7EdJh2lMREynVsz3YXlclRoUodYATj7H4G1N?=
 =?us-ascii?Q?gu6p+evfx1WtM3sXfzVg+R8eonmrBt1W1ghrNvPDJEaO7UKn3Q02/u28XZHy?=
 =?us-ascii?Q?NoG5Mu+agmDCjFHxZZYblqH5fO7YXB6KuKpkoIt33yB1nHEu5vlU/P7KtjW7?=
 =?us-ascii?Q?ZOOl/nElAPiwfquWPaNcAwy/wOCPqGl9RslNZEwbezSmLWuzVj8+SZY17YXw?=
 =?us-ascii?Q?Kevc8FEXo0cfkzZBOn+hCXmadE35EJze+1oRBdDOcX5C3SRB0za1S2kKv1uu?=
 =?us-ascii?Q?ltuFXOYqhDxvOnKv7sRUHscIYX/VuRXs0mZis2lYhBH993YbgQ14aif43qm/?=
 =?us-ascii?Q?cnR64Uywws830afUS4p+uX5LdcgOBssORVGOz2vg77O6xf2M2qSi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7817a4d6-cffd-4404-b3d8-08da3aae1b8f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 22:14:29.0593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scicqPNu+OsXXlWwPKzVGddjvk1EBKKS4t6OlJ3NHzcY9lYskeXJQGBitPYXjqjCQAS21Nxyojw6YlUiZZtGWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1815
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 May 11:31, Jakub Kicinski wrote:
>Hi!
>
>The conflicts in today's net -> net-next merge were pretty tedious.
>
>First off - please try to avoid creating them.
>
>If they are unavoidable - please include the expected resolution
>in the cover letter and mark the cover letter with [conflict]
>(i.e.  [PATCH tree 0/n][conflict]) so we can easily find them days
>later when doing the merge.

Ack, and sorry, will make sure to avoid this as much as possible.

