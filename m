Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EF06ED21F
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjDXQKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjDXQKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:10:30 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B6F7D9F
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 09:10:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0cOfQRIMp/U4OvE0i4PmRwbRUnbot5F5sAX/10CDJdwh+cbHfPQ4/0pJIhu3Pu+svPJQDc/x76MB2y91pcCwqaqMdYXt+FUgU5pyEzo6A+mofhg+v29vvFcJshkvQamUDtMjz4X0u+2jneUn1R+YHbgVwbrbcTOzLayQYNSB4UvtjCq2NZmiBE5XLYD4Z1M/BQHoUosnN4Fa1O752gKANtxmG2dXQ9ehQv1IDVTZFdbcrRbZV+dPZ4Vkrh3Zwy7NaNiFlY8OfUeIlgRBJE7TsRk4C3RKYuJmT0VzOJygtYvlSqpyl4AEUlEDIJfPcUUCcLhohc0z0vczRjxhceuYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVbME3uqANi0MS2NoWkEyfnipIAy6xxOWna7k5C/JzA=;
 b=nmLkmUbQlKEdv+eWbLNWOksvxxkj/rek4lwJFley79HozAZ82lKtUezu+C2DYBA9noznDfaobyrwK/r5wfxjPRGWjVZKTpcBUanDqJ2wMYWipeu7qol03Ga6j+rkedQDZV6NQQmZ7wlpDZ3niwV8lcBpdhcu8Rr7WkF/4wdEvk2UuICNjS/aJH2nCUS97s7SY1FUH/V9aXP+3qyW2mhYxJHsKzarpIQeKM0tctLg3JA0OpyOilz/JYzRncMRJHsK2IXlE+XG1T/9Ca9lmQTGi9/T9m/S2w36zR/ZgpAj9PSYAtbnW5s6OgrrN1DqWVBjwoRwWMhVfEJwrio629LBrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVbME3uqANi0MS2NoWkEyfnipIAy6xxOWna7k5C/JzA=;
 b=MEGWKQF72BvKuVNH2NHSXbjS1XNPPUgnzcE7skiAU/hcwzlJwzPEKn7nz2ESTbIiBpDkHI2mtfdI3yOfqozm1scG2cr4lebr3QB/38ocmloRx3nfpa3Y2t9mo+V7u2s0ZZJWRCH1hNpJ+1UHnjZnYQVAe7EEP8BFE0NMClkOrVQRxIuvuvhTp75wfc5DibYSgBvCRpWaYr7CebB83MxtRiZW0Jty4ypwJIaDWEEVlkcjKIXIMG41GRDnuf6PPTMnQYt7Inrvgq8uof6aJyNDfDxt3BG8+GESMdu4cuUEr+aQQgFh1wfTsWTUoV+4ncFCkMkjgKiu5VX5DE1gUFFyCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB8218.namprd12.prod.outlook.com (2603:10b6:8:f2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 16:10:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%3]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 16:10:18 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        liuhangbin@gmail.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 0/2] bridge: Add support for per-{Port, VLAN} neighbor suppression
Date:   Mon, 24 Apr 2023 19:09:49 +0300
Message-Id: <20230424160951.232878-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0445.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB8218:EE_
X-MS-Office365-Filtering-Correlation-Id: f7d32cfa-4506-474a-f0a7-08db44de65cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kYPJqjOj++N0pkChMJvDA6hgGUOJr5s2YBar12O652vMcfi8UJRn7/pbjc96RV8gxa6EtIXly0JU/3sHqH6oATTMW2EC7xlE+N4M8ZA8MPH2Xg9BumpZTpYPh+atyf8TkdJG4IDuakeZX6H+mhhMyhzkDF8MpU7WmNlKELrb6P4R9JQ3RP3T9WFZo9cTaf8ZW9wffUosh1jksrB8LQl5DNl2tk1YJFAw3Fr/Vx9iEhY7HtPPKgEe+oiPbLPBffYlZdr+4WyOWWe39y6NoeCnQxn0Xi4LpXMsf1jJpH/almAP2G//9R7gZBKSNCif1bYt7XA/b2ZYzIbDbAF2BIRKqQ50pN5Rv+PZxevBuUvamTV0FVy9cW18DU8/b+7xN91aBWWNRmE3g3Pr7999F+AS8HtGJmbBzLzak2sNfPaoOvNi7oSULn2TN3xfVt86E4DWqOknPlgl7HDdCsky4T963KSo+OUgPNnhLs2vBwA3BeSKe6xQu53pncVFLkkWhmo0K8mrVXquyJCb1aSY4Fv+xRFSwjlV8jn7lTAEOEbA8LaJwQpBOiITpejyrqUZ+93I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(36756003)(478600001)(316002)(4326008)(6916009)(66476007)(66556008)(66946007)(41300700001)(4744005)(2906002)(8936002)(8676002)(5660300002)(38100700002)(2616005)(6512007)(6506007)(1076003)(26005)(86362001)(186003)(107886003)(6666004)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rq72sHh/eXu0lp4Y6ppEtXMU/juqmDUgbZpzR/Fx3rIzU33XRfHLkiADOa7N?=
 =?us-ascii?Q?C+MAeOqmbzCyCB3fMyCl0hAdPlAv2XPNvavDcVtE8t2RlWaxuvNw+OERMoPJ?=
 =?us-ascii?Q?4Ld8BU80bILyTsj8gc0wDWMk9EKxcw9ck4c7PLIGvW++S4C6hIEO4HkMSfA9?=
 =?us-ascii?Q?S0h3XiloMRdgzpD5RcZvkYyFecAQUaizLs60u7SNwq30FDU127j798/Q9T07?=
 =?us-ascii?Q?fpsbvrAJ5y4H/D8OSCH0L4vytTmxmZFCA3RoEs7KcCOyYvwu+ceLrQ43Havq?=
 =?us-ascii?Q?YdC9wITGVAExVFh++Q0RDfQzSbog5VjIj3HKYtgtXM7HuF0c/ILkU5khLgUd?=
 =?us-ascii?Q?OERCWF+9UEftG4SO3Pl4f+P3WvESpUNm/csOHD+fjBixdWrr+t86jhXhNanp?=
 =?us-ascii?Q?kIvwvF00cGXIKJRRynrAhPOgZaiCNbrd93pg0Nf4y8uHlth2S0df1pkAcXjx?=
 =?us-ascii?Q?PUG3AwiT4wYEMG1yWYfTfEjMVx0+7U5buTaLB6qokTp/MjeJNhK6RM4jHHzo?=
 =?us-ascii?Q?z7oKQnPupGw3Aa8qCyTMNL7nW55xUoNRis1G7jExWIHrllZLq0KNBTdViKKU?=
 =?us-ascii?Q?H/orSsKnyIWLVBS0B/tRI9aUMlACgl07/j02WCm0ZbhumihhEpMPwm6KoMll?=
 =?us-ascii?Q?7DaSiwxmSQ1kVhYDzfcrTBOW0v4/xzVsYqfHmcembn5SajHqimvxHMcmZfLD?=
 =?us-ascii?Q?opBNVPvWGHvMNFSniwG4EUYoYd0u3W3AY+AMOEwwtzfn7WKmdJTM6FO/66a7?=
 =?us-ascii?Q?DZKtg7/dL4XOwx8ZbAwR+W49PFPQzmC9xMhtLACiBBXlwm/IurikCkeKiDpb?=
 =?us-ascii?Q?jjRPsIT2hsWV7WkDAG8Jsct0ThWlXvj/LyV9ZzynEm5tyv2KM8PKmNfrvgOZ?=
 =?us-ascii?Q?+5mpwP2NAYBl7fCMxVZSQHN256eg6D28dZqb8O0rg2RqE2t5WIPe8g3W65ST?=
 =?us-ascii?Q?OQsqNeqDxYsrb15U39mJJvLQnAGYqOIcpfcQA0BCgbthGbulJ1/49HBkFZCQ?=
 =?us-ascii?Q?FBdSlU/OHGJj8DdoSwjECgaEhEu/Th1oFlSzO0KD29mUHEevbYMLYiviZBj7?=
 =?us-ascii?Q?cwHut0rW0mIIH+bOeqYAfIq1ZHpVIOD+G3qyZXUQAcyJwBdz1CWU10W/dZg7?=
 =?us-ascii?Q?FINpvSzWEz4pk1V6gJbphi1JGBN6D2DQ0NltN1qZ/goBBE2PaU9z6PIKf/YN?=
 =?us-ascii?Q?7thPf9v+pjA4be4eUxKNnZynW4jAze6Fu9AG1ypoGBlL/XTgQC5qmc8R/vuE?=
 =?us-ascii?Q?uhi4PrjaV9VBoDs603pPFFvTa1IrXeC5bUfus7vcJE4TK+5eyXSmXurxLf4t?=
 =?us-ascii?Q?U/BGuraMFOS7zYbOd0/ZBDSzNtZSZgHmqV4QYm7zNIKlNi27VaMMlhEgy4WE?=
 =?us-ascii?Q?C40n1x5ss7tas456h4EZYF/iYjZQlktaZpxsxI5xd5wucQL+gEXsAMuHawy8?=
 =?us-ascii?Q?wbq2h+n9eRXLgjY3sv/pZvVEksKzdby8tV1i3lvlVPcs1B5QaIznejPpRyx5?=
 =?us-ascii?Q?ucXYHEI0hX6Z4wbeaenqhjc0JgB38IJDlHxpFrVw4NAt9yGtEBcbrVlrFh4f?=
 =?us-ascii?Q?BnzkyyPQKHo2VSOzmkUB6kU2ISVnKUNpRmVya8Rl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d32cfa-4506-474a-f0a7-08db44de65cf
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:10:18.5746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3f78FUFyZ3GHATeZMw5xdXxJJa5/9edAF6jEW7BZ/q+g0ygj9eH6pDWsfy/uZW1oZNvEMdhFGJWouNCDpezSbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8218
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

See kernel merge commit 25c800b21058 ("Merge branch
'bridge-neigh-suppression'") for background and motivation.

Patch #1 adds support for a new "bridge vlan" option, "neigh_suppress".

Patch #2 adds support for a new "bridge link" option,
"neigh_vlan_suppress".

Ido Schimmel (2):
  bridge: vlan: Add support for neigh_suppress option
  bridge: link: Add support for neigh_vlan_suppress option

 bridge/link.c            | 19 +++++++++++++++++++
 bridge/vlan.c            | 18 ++++++++++++++++++
 ip/iplink_bridge_slave.c | 10 ++++++++++
 man/man8/bridge.8        | 19 ++++++++++++++++++-
 man/man8/ip-link.8.in    |  8 ++++++++
 5 files changed, 73 insertions(+), 1 deletion(-)

-- 
2.40.0

