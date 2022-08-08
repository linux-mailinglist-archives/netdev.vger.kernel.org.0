Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D5358C674
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 12:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbiHHKca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 06:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235610AbiHHKc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 06:32:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA05FFB
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 03:32:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfkd0/PdeDQoo2cysDmvxcqKKgILj+odu6Xq/3emQMg7++SgO7erhoxxtuioPooIGurRH0z0bdEDFrnbH1zEJIQBDRrtsi5eTSEU9pg/uQFKTJeMI1Wml97SDwCqJa2wf/Xs1M3+dG/ABuIInu+eMZbZnJUD0LwGOJOe/C9CzWEBdvuDnmieF65rEqiQkU6BOC4iFfekZM1AIeFKaTyhhBzd2CAtdn5KGiLErDSpPpb8trtYWU2aJHiQU10ucdeLC6Vbd9qaV9WhWvuVAXfwGBiGOBIRkZV3rHZFukEFu0vKjVudiXq5ANpxxtLWZI5Lm4juMmEPZdu9ktiYa5Xw8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeHtoXfJsEENWEzNuArU6lcmzmd7TTsbdvTPfAQ/nmA=;
 b=bL9VBO6f6d5ODriCXBOTv828QAHzcvCNJLiXrcB3i2k3/ZcSgFxZS3xBiJbZjhpZ7D4M37YvaVclDJgDll6CPad4IhyVXwH4ok9YXAhPOoJtWkkt3x7rbTLoq0hVium5y1zC7TxSxRs7admZCywqhzDL3PImP3LHeqAXn2OtwxiZvuRuA900MyOV2jzp29sGXIwKujDK0IACsEOMdcMCS7k08umembB7Jf2N9VF4XhyYDIiNAxBCOgF49Yo9Ujl4oTrSBYCr23PyBYj6zHSTCcKnbcqEM79gLDsqWW4Rwc8xIW1TuMiJe5il1Wg5kzEjkBlfEK7S06p4Sg1S/L4t9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeHtoXfJsEENWEzNuArU6lcmzmd7TTsbdvTPfAQ/nmA=;
 b=M6qQkWY+1guwvti97YJ9Ed34+JHOJwf7gtiEwrEhV1FPfnC+85cBZdldtnbxthOFEiY31n/MSDXu5DFOZacnvUMsM/iiQxMjP5ACeVpBe5rIiGuynavgth1em2QX3qtjLuuOCXK1uslpfAikMqY9L9SGQQYsNAA2x7RA/kleHCIVAqFQgKd8vSfPMakuFFBfpT8/gyEIMfrq2RWhsHQEP8lDyincIaT//INv9dMTLtedRYzchBlH+cheuZCG5yFzfQpjiuP0RqWk23iZyCDTS4vITd3vTieT/fYeCtpfRq0S33Xs9GGso5+MjAL+ZpIhWo9Y/DB2nDEz2aQMhQF3yQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by DM5PR12MB1419.namprd12.prod.outlook.com (2603:10b6:3:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Mon, 8 Aug
 2022 10:32:25 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::1135:eee6:b8b0:ff09%6]) with mapi id 15.20.5504.019; Mon, 8 Aug 2022
 10:32:25 +0000
Date:   Mon, 8 Aug 2022 12:32:20 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [RFC iproute2 0/6] devlink: add policy check for all attributes
Message-ID: <YvDmNO6/QtXfJW8h@nanopsycho>
References: <20220805234155.2878160-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805234155.2878160-1-jacob.e.keller@intel.com>
X-ClientProxiedBy: FR3P281CA0162.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::14) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b743f5a-5686-485c-32aa-08da792948fb
X-MS-TrafficTypeDiagnostic: DM5PR12MB1419:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ybKCIy9f8Hj63ufrpQPb1/YmOA9XOnpgyb3ysqy77tppTlfsIjXNi7UP8k+4bbKt6NpDbdcrjOvLEKbTYi/eHo2K5ABLtppLVJvPETRs3uXBHowJmzy0ihm1GIU2GeeiFOEUN9bmxgVfT0zhn4KEvKNPfS8+u34OPAkVrBV1A4rIIT5fAqtOWNhYvbdfWMmLMIuML/DlMAzsUcuPzOvbMKK3+l7Bbs+219N/6T01amvdkzcp+hot5WY+bSvpXD8b/TkKhqBTvMt5vVg6g6MXWxqy0EAccIwsGWi+01nlquaohexKxBUlzI306OwGFajob+LwuVvHNiUX1bd8glkLqQjU8haFOy1hEUa7LwYItbyRTZiTtFmGUopWU8nL0rQnSCLztlgRxRWt7HO1rzet6rEJFLD00q0JHyMfGM0wxuePcR/tZx5XIUgtTKAF7ovNz97+KmHBA09PDte0k7YlIzH9sle9IsI0f65kNunXtoSrIt231JAjYbepfY388nlv/DZhraM1Jk6hJbFsh6oNe6RE0vIVv0H92Ia06mDOd4gMTEQDvJr+CU/Xb7Q83wOJ8EmL32nrFjLnA6sExvLbhlQSP+gIffORWHhzLIGMN9kHTMr9H/SMOEe+wuQ8y21NGlJfBsEEcxTRMw1+YZnfSgywZIWesU3IADQ9CWpXdmI1rVxNxE9ImKADams4MOKj6EoTnPCMS2ilHByqqAkDgj+SO5ou2Aw7B1XNNnwTBkF1LC9ONA/tHCSKqWaysPr+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(478600001)(6506007)(6666004)(41300700001)(6512007)(26005)(558084003)(86362001)(186003)(6486002)(6916009)(54906003)(9686003)(33716001)(4326008)(8676002)(316002)(66476007)(66556008)(66946007)(38100700002)(2906002)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s2xKZvJ5aMrWWzAUf1AOEy8z17+oD0LtF8/cNstO55HRnsRjxEsBu/2bDEo5?=
 =?us-ascii?Q?IztDjncFRZ5wT7by7o/3vdnoaSbRqfuOHqyMQEXSyPqu4BgBg1Ww3MBustSi?=
 =?us-ascii?Q?HmSUDcsrCib8VWqh97UzZHW4yYbsZcjUQ4gVTGGIfrssX6Tv+VzGPF5gEevm?=
 =?us-ascii?Q?JpuU5I8YDdFFW5xrNq5iAVNzTfrTLX969bhFguv9uHdSJrj8VUAzEo14VoQT?=
 =?us-ascii?Q?XJ3t6b9OIKP4o38KPniUHCBI25GvQzwqwaDqBeAFAdkZslhFYMyuOJ3wOD/r?=
 =?us-ascii?Q?AmEYuGaG/rD6bH7ETgDFSLmQScwidi/wrLw+6Kb2vGN3XGRekWTzig0x/4Uy?=
 =?us-ascii?Q?PXlP0ByeJ5gS47teWMehIyJYJ76PzY6ejwzvH+LAw8nP1cPrsaLbZNZDodO2?=
 =?us-ascii?Q?mi7ezLtV93qHsq2gh4oWF96e7oBLVpnloD0qIssSda9rONjU1zb0fQ7b1MVa?=
 =?us-ascii?Q?uxHLi3tUslJtxHIK97Q3QacvyNZXEQtj6SCnBte8biJ6/VpM6PLZpVvvQsvH?=
 =?us-ascii?Q?S0adAstv8dI7Cld3HxJ+2XtNWNRM9hNmZJVUeFBspfTHHom++PGRudbsJHO8?=
 =?us-ascii?Q?Wbz02znSVm/Xx+wIzd/Fp/6eFGDoPNwaetpdLfMUCnVg2C4gfrrSW7WjewzU?=
 =?us-ascii?Q?ugORY6+VGiOSjLCg4LreYiQ25jQNzMNsZ/82SwkLXUq5+RvgM8O/wrLeaoHL?=
 =?us-ascii?Q?jCZV7OhyPp9V8XcTIyz1BKm3Bhc/5IAbFqVxR0jdiVzqhHI93mZxVsEnj8kw?=
 =?us-ascii?Q?or+iyV1Uq+MqlCVwo5ZMjyGSNSy1CgrcN+x8oz78/xivx03DHyh+reTA+4EH?=
 =?us-ascii?Q?pa2woj40QbKuSK9rZfNT7tjGqB57tqdyQg9dmC24d4EJiLoZkRX32tLZMkfL?=
 =?us-ascii?Q?zWBerN5yJ2ZAt1frPMe+0gkg6IxHNG9PUQTPxxBecOwNUu9Z3Z8PMXMkofu4?=
 =?us-ascii?Q?3ziiOtmSqTCcuteDeqMWVG22KfnDNfTGOuxKAf8rOlQfp1Qa/+71lTBlLRXV?=
 =?us-ascii?Q?P4Yg/s0opbHbpKT1g+DeiRyH/l2kNtHGwm8qTGJ1GiCjnUk/PiEjz60EH0rd?=
 =?us-ascii?Q?mvwDPH3WbiBqlAkASiGywGyKIFy6rSR8ojrDAySzu1VEy97q6BmnbdQNWunm?=
 =?us-ascii?Q?eoKAwc9mJW9PNf3r2aiMTil7MjHFf+cyyFRtFOcBUfCf7230JmxgtVZi/CyF?=
 =?us-ascii?Q?4ly50JW2Fo2Etajl77o5B3Z/cOlSqB3Zg/714Aa5B+L1X8ahMISXXF0CQtoz?=
 =?us-ascii?Q?AFLxGxr1OkkH99JIHNh+8u/h1ptUhYa57qCcwHXFJRZ+bq5nUPFndJem29PC?=
 =?us-ascii?Q?0GUV257+pZgy49rdDUVK/h0uE7pWDOrCB/C3cIJhh7gUF3Wjf0hieCbbBYhz?=
 =?us-ascii?Q?8bwIg2Hi6EwmKzWjMDXIqAxRcQxyIOzK9ecfSuH1kQUDXuPH1HKdU0b4EXXG?=
 =?us-ascii?Q?oyL9HPbGwGAjud/WeQaZxHjNomJXzeLBYRw+fuq3hdXq3rOndcZA5hAT6euh?=
 =?us-ascii?Q?z+gP+owb1ZqLenTEnwCut9WffHGAjibx7vlZTGMnLKt973SQf3+0aipc6mVW?=
 =?us-ascii?Q?m/+mdhUv0Rf+d+3cVKc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b743f5a-5686-485c-32aa-08da792948fb
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 10:32:25.4044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1a/icV1ZVjV+VaJjok2RibMFz9H5QlLd+rvyjHLmrzAlZT/CkrAWRGFRb82CYJhh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1419
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 06, 2022 at 01:41:49AM CEST, jacob.e.keller@intel.com wrote:


[...]

>This is intended to eventually go along with improvements to the policy
>reporting in devlink kernel code to report separate policy for each command.

Can you explain this a bit please?
