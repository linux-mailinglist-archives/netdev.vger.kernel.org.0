Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BE1589A3B
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 11:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbiHDJ7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 05:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239404AbiHDJ7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 05:59:23 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0EB6612D
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 02:59:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ax/c+tyvBv/8YNtv2oSTZEde288AROuTCYeqGtvfrYJ3+PvOhUWhIN0hCQvoecofvlQdVgCfvhfkWwWailJo3mpJAgNI2VXjiHOWc5cpBtTl4Mko521vY7ijYOVf02IY/p9RX5iu3wcVz7QEIjSAlFq0pQ+kpHgvT6HlZ+8Wm4/9qo6TMPLE8Eqa8zcigapqPvnzOOryH8TSaCq04U+t3+WrKrIf2EkfHGIOPjnjX+dfIHCojVGLxuLoRPEzy3aDVqXhJl0r8Un30kSnkEWwYzCttGDVx6QsUlcYMstc04CD0fX2oqn5opCsAakq55sVf767yho1tBUCVeese57oyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+U+04ZoBa5AidPbyME/xtRy+dOIdTZwaU+rkqdSjbs=;
 b=DCLH9jzWr8DaxwPjByUKxwb5u3K3jhs/G44i99VeWXuFIMdjHPugnpDo0PkyJi/IHLjCwXLSUsjhdSDqGCdXYg/xCE1WBRS8xb+J3kfI3e0+AyD7Ny5nGUjzUMe7jG5TCwKQfQz0HmLfcEv3athCrJssER7PKM0n/9QasNwJxye/kkdhLDJgiTxH1h+L1BiEqXZ5WqACnf3doht0Ph1gOlV9pkuD6NIS2fea76deNw0pbcNlcsCgY1ETKwtiNW8IvySrWWBm0fcNHjIXBGdzt5C0sCkSjPSw/nP8YLWtP4HO4EFQvXqLkTBvRQsfQZ8fuD3V6V3BcmIWG4zYuAuq6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+U+04ZoBa5AidPbyME/xtRy+dOIdTZwaU+rkqdSjbs=;
 b=JL1t5PPKG8q+0JK84e5AnEQm5akZ3a5NhlNG3jXAfkybJcuBYVui3h0athtESW0Har2GgUf//Q0un+HMnzpM6tWd4dTqJdG30M1siQGKfPUv2ARt6kYmYgQm0U+mexKc1Hj++jYURh0XLYBLnAvtfMIgyKbHHqZ7p5Q532byLxhUzu2NCU4eILBCsK1nxqU6KSJ5UiDZHigAW01EQ00GxC2G0VMf5KqmwQrzE1WVvGLXvv9KcYV/RWXTAM5Ry/WDROfegLdlIBbTMyrbRbeeE4a1FsuUDhW1jCzKdCOvTu5TcKHJUG+t4oCRHggRjbrsjC4DjAmZocmLtbZbif+Tlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by BN6PR12MB1300.namprd12.prod.outlook.com (2603:10b6:404:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 09:59:20 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09%5]) with mapi id 15.20.5482.016; Thu, 4 Aug 2022
 09:59:20 +0000
Date:   Thu, 4 Aug 2022 11:59:15 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     dsahern@kernel.org, stephen@networkplumber.org, kuba@kernel.org,
        netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH iproute2-next v6 1/1] devlink: add support for running
 selftests
Message-ID: <YuuYc/pSJR9h+Mq1@nanopsycho>
References: <20220804091802.36136-1-vikas.gupta@broadcom.com>
 <20220804091802.36136-2-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804091802.36136-2-vikas.gupta@broadcom.com>
X-ClientProxiedBy: AS9PR06CA0260.eurprd06.prod.outlook.com
 (2603:10a6:20b:45f::25) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bde60341-74c7-49ce-379a-08da7600002e
X-MS-TrafficTypeDiagnostic: BN6PR12MB1300:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g1yxE6WaMJNjMS1DzrHExxkhbaSwsxfwzARa9Q5c5Sm1cBzc2mTf3Hxs1BPe1GF4+fRFsapQud5UebbGFvJRqHum5f4lnIy35WIUrwRYk1quNm47KIC5RBXxA06u4KnTHRfJl09wlDQrliqfSnpTtxB5SdakzdQldKXKebrUWPZfeJtfFdx2oRRF2qlRSYfVySUK5iAZ4IVCFf0azuE6XpLLA09M9XgXx8DHmCIbUI1MxP2MpVzwuNnvcmSwljYDMXEUe3lNxaqgnImtoKkzWKlIt3bUZiL5FwRMeRwaGa3dMSB/+PW9+raZm3gYdHT4iDBSU2DiESEUwU67LTXUJHEwjZK+vDgTOiZLRLoV9sdSltCCVBewfLDxLd7ZaA1ECK5NPKY9SHpcvbuEnmsEfHlTYIRXvKCjTR4ap0DyvMafiFzAW7NkLTUP1H5pQCQM8KGtuPk2J7tgzl22GASBapFWOAew9YXcZgTVtrApyJvFkcY+Ec9I/iJKTBL7jFD8/zaxYevoC4x0beRypPrVAAulXSIck7jchc/Rqp/IEpFUrjOhu2n8lLbcEw7jXBrJXd7RI0iEC5wztITUZmpAFZeKpPpMEDlN3hUEYxWzyXaC1yu2zBsjXcCT8/2mROqyRG90J1z99QYH5u/0OrA0psbsCG7GIkgixIy2V0x3vA6G26TOOLqVmF+OhzkevNT2SAoI1ZVakDHZFbFaiSbtNrvYnkTL87uHewZ6mACd0co=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(6512007)(6916009)(9686003)(6506007)(86362001)(66476007)(4326008)(66556008)(8676002)(26005)(66946007)(38100700002)(33716001)(5660300002)(186003)(8936002)(4744005)(316002)(83380400001)(2906002)(6486002)(478600001)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Re7boaFk6q9NS66jsUZSHMj1n2oKBcNXMZAtEjrjKDKlQDBOHgy6ve6sjlZZ?=
 =?us-ascii?Q?8azpPY5F1xf0+IieGNpl2Rj9uBBpo79dtDPzEEIv9izJsSyZfmbp0G0MfhFC?=
 =?us-ascii?Q?C+WNPaRCd7OV0zYKAj+8X9eptP76WQ/AtaKApedlHWL7hjysJnNEAv3yWzga?=
 =?us-ascii?Q?tytNz+1uwtPmhUynYY0L3by0lB0am/bZvK8ZDfw7CfUCfN/VO+KIlwnV/rD1?=
 =?us-ascii?Q?JTOYnkAhWMxvDW2ALiJme///GrqQTd39S7vzYFURHKDZ7eeFKiODBNy2LrfG?=
 =?us-ascii?Q?aBf7COZFdKoNw+jFibMBn9UqDHeoOhBK5xLunKz8gp+tiUjEs6kz9AiUTk6U?=
 =?us-ascii?Q?AkNjBX2qB3/eWLEB3nyx8yTgtHoEBCeUpG9vnUuEYljtmCSl3r5MCz2LQjnH?=
 =?us-ascii?Q?707Y2t0C1rVH/bBcwie84fob7I4w8jHbWtW9mHuLyBQaLKelStTakCOnB8dc?=
 =?us-ascii?Q?TDI68SL9VchhYUZ8/fzdObfOj/tXB0IChnLZouT99t0Ex34TTy5aNtGQ5WIT?=
 =?us-ascii?Q?3/qrHeAhJOjCXG+kG9Y4VBdxBtKl2z9BVC6MMUw+65J98uwamyd4ZaTfPImZ?=
 =?us-ascii?Q?/S1KNDx0yomFct+65aD6DGV8/nWXj3XYoKX46naqC2m6Y+NnQ0ACJunFMZ8A?=
 =?us-ascii?Q?91Z4RlTxaxmtk/0QPkSGuyTe3JZ8HigEdT0rg5HmeuX1IaUs6leumwaNRfnC?=
 =?us-ascii?Q?97hwBY+vkcTsRSSuVIAOsrHLydtzX0cVfFQ237pf4qTB7z/ElMLxGYcsQY71?=
 =?us-ascii?Q?s3VOir14/6haMccrezBHq70kfHJzYLoazJPqXAFJIDCvj4lf0gZgbo6bldLv?=
 =?us-ascii?Q?RqcntkrXMOcL4xE89iAZpcHL+6HSLSGYaEDtyww1gVbgM1IjJ0rddw2A9+s1?=
 =?us-ascii?Q?f9X0DWIULIFf44dhsinbmUDaPY1FzRIWSeQ2vymi7U49ugq8nQStZataUEXe?=
 =?us-ascii?Q?P5/xm+r3VggCr0kEEqBTHcEN82pXupcTx5jgg9NRSiWNwKeFwganB9+x3j1a?=
 =?us-ascii?Q?KsvyekICqjh9s4XRUipKfSfQgizc+eSNF1A6SyV5Rw1Ob6++jzQc+OrpfSHl?=
 =?us-ascii?Q?Dw98d6+sag8PWj/f/gnwisv40XlAdSrjDOq5pbenMYLeRDRlU9Ww2BevEzYK?=
 =?us-ascii?Q?5Kg50umieXlE/VVz0o1eDWljS+g2a3+ZbsPJ2Ati/unLVfTWSo/mfY6RuEcu?=
 =?us-ascii?Q?DzCyE/NoIaH6hRNjjVvBVW40XTPCDpWRJPaR5I9uuTOPbH+FOKr3UEn19jvy?=
 =?us-ascii?Q?e0mQzmj0us9qEV9ky1/CgM4UUZvnxbXQILBLIkZ2MkJ4At0jLBNVbZwySuFd?=
 =?us-ascii?Q?QPuil/46SuHXNrUVn/GoDWQDL9vRZxBwxUmfqZA82ldjBwNMoC/8hkgqBOXN?=
 =?us-ascii?Q?kMapb6YcNtT0166eA/KLOm86zFtY7Y9eUztkJehXR1mQetEqmg3vWYQ/ICap?=
 =?us-ascii?Q?80UySg2ORaLB2m6E0d02LQRDv3kwpZfdth5HXrVQ/M9QgqdtITRuvkijWO6G?=
 =?us-ascii?Q?0V9O6duoPL5D6QtKjYuq7Mz5Zq89OoZJyQxPVuVZEDEICViXaExA82SnbaUM?=
 =?us-ascii?Q?w9+4XQH8nBhB3aEmqJw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde60341-74c7-49ce-379a-08da7600002e
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 09:59:20.2702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cs5Iz0lTtw0ycOb0qu4quc67hY1EkRvTzesTbokEpmdIvMtP5dNS5Mf0IQHc6c6W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1300
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 04, 2022 at 11:18:02AM CEST, vikas.gupta@broadcom.com wrote:
>Add commands and helper APIs to run selftests.
>Include a selftest id for a non volatile memory i.e. flash.
>Also, update the man page and bash-completion for selftests
>commands.
>
>Examples:
>$ devlink dev selftests run pci/0000:03:00.0 id flash
>pci/0000:03:00.0:
>    flash:
>      status passed
>
>$ devlink dev selftests show pci/0000:03:00.0
>pci/0000:03:00.0
>      flash
>
>$ devlink dev selftests show pci/0000:03:00.0 -j
>{"selftests":{"pci/0000:03:00.0":["flash"]}}
>
>$ devlink dev selftests run pci/0000:03:00.0 id flash -j
>{"selftests":{"pci/0000:03:00.0":{"flash":{"status":"passed"}}}}
>
>Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Next time, don't send cover letter for a single patch.
