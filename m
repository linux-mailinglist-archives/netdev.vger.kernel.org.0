Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60961686C27
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBAQyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBAQyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:54:46 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2127.outbound.protection.outlook.com [40.107.92.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B164137561;
        Wed,  1 Feb 2023 08:54:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIE8xTSLiHTwTbD6wMRYAkxIQvS5j2Jh6b1F13cRWLeLKo90oJ1UvSMxwxZNgXzkq0EgzYuyiCEi9tE8Cvmn9O7FISDExIDZ3DigY3H1ch6Qn8yI2cF8uEcjnAo0bE1KfwuMOYbD8irTA4Elx/V3PULGAa8Nn4gGirRj9F5f6R5A3LyJ40icmsPtSKxm4gKqd1rwfZhZZSV+XSoFEcpO8wloDF+Y5qpLY0OKLja5haMl3U7bIBB2jcCjFAOl+BUKpfPQ51TAO46Ll1jESxNImzXt4lGnm/cqrpEcubNvU4o29DW9r4NqbseTCpeT8fPG+4L4dtt/yLBnm57qEswBsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8jXb6MgmRuH1oWc6zIzyXh3/RA1wsVzRWD/qilfY5s=;
 b=WRHrqVt3p3WKmv7PZXINfuuRA6hAxG7fISdFnM/oIuwJFgwJh8RUox7NbycsYhP1vTjplhjyTdxnI5Cgoacf0ZsDtOb9d+01TWXpJXQoEfijOgmdgWL5rXLSDT0KWe7oFDRZ27Tl/lhA/+nbtBKvoY0jDv3/cUM73XOyXbYHrXldiHiAxuAxSPjQwmVc7Iez5JeGBz8UbBqcW58lSwU7+kqT8D8fWgyHS8bP+z1r6vKm9kXKb3N50yF0Dvmei6wx5OWtPOt6j1792PcnoUDKVMSoNNrzkmYJTfRqjPbT0leGQcbsJ8nWnZKOv5h4y15XctJvWgLrPuMWVy5dghAhTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8jXb6MgmRuH1oWc6zIzyXh3/RA1wsVzRWD/qilfY5s=;
 b=CI07EWvewYbH66JAPUi6qW355DBhenk1vQMSVkqzjPhLifecmZtA1JPq4iT0K4KPpDVVV/6FlWp+tf6vujYfdBuDLYBzCUi+f/eebN6OL+obXW4ztNDJfU2UOhI6QYNm/5ObU9VNmjwH+Zdf8wShl49o8sRzUy3P5+DErRVyv1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5719.namprd13.prod.outlook.com (2603:10b6:303:171::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 16:54:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 16:54:36 +0000
Date:   Wed, 1 Feb 2023 17:54:28 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: openvswitch: fix flow memory leak in
 ovs_flow_cmd_new
Message-ID: <Y9qZRCn7CLhYr5h3@corigine.com>
References: <20230131191939.901288-1-pchelkin@ispras.ru>
 <Y9qI/vBRPlDFwkAh@corigine.com>
 <a0be13d0-22d5-b92b-9fed-4faeed30fdce@ispras.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0be13d0-22d5-b92b-9fed-4faeed30fdce@ispras.ru>
X-ClientProxiedBy: AS4P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5719:EE_
X-MS-Office365-Filtering-Correlation-Id: fbf79719-ec3b-4ab9-41b1-08db0474fff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BuFcoh05m1AhIXpTe89nuMhsyv1Hdp/D0/iP3mMS72LHwFAILNdLU4ai3EKqdjPu5SxIX+ILShnQY9t5HbRA9gbRoM2KwIBCgNevJPgsfYBJaiTTQoFvzHSRjiUmM9WSE87MqdczEgRv+yoY3LEYWkjeQwyOYvHeOur+wbqZIc2Q6BHYgPH0yPMB2l7QJe84/4jyrgR0JwO+rLGIzQO0tnU9r18DytcDIU0HSnn6zjV7kG4VtDrD6i+G3UchgO9UJfP8KSCF35/H4YCczCvvrXoYf1mRmue+fZ1n65jzugcdE0n/6qjHmZR56AYMXFhE+88rYClrpprPnq4c7JRr/qeVMttKJjlGxzvg39kO+f2vO0XIJr6Ra9B9Ien5FbScmo9DEIuDnuEUqzDlFbB4wIaQMKcEL6CxJiBXw8EHTT63o23NcX3lzzoPi2u4uP6R7+x5uYwLoP/a4Soubw86KEBpxLjQxeKhtutUMisdUbLv/D6PKEf5b/wUxEeeNw3uPcoKp5VQ3LJO/S8VxFbG8JN40joenBaqmXFMbJel97VrYU2uxcMX+WFY/JFdV1AIpi49ExRNDbmkHmKCNtVnuJL6rLd6L9kbOMnU3k+k0IhHsoBycaKfIWu2rwrFB8fQ7Mdi1+4PWJ9fQiJa/AYJmmDGo07fiHt4ar8MnKAx6X9hnkLNPnHsK5SmvS0tVMO1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(346002)(366004)(396003)(376002)(451199018)(478600001)(316002)(66946007)(8676002)(4326008)(6916009)(8936002)(66476007)(41300700001)(66556008)(83380400001)(6666004)(6506007)(53546011)(6512007)(86362001)(6486002)(186003)(54906003)(2616005)(44832011)(5660300002)(7416002)(4744005)(38100700002)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3VTd7WGPyLFW9CU8g7XThHmNHgEC14mgZsyD3Ug50IMTiQAERoynhYmb6Hrp?=
 =?us-ascii?Q?jzYLMXGBDK7qt4Kf6UO84vfjIs52YMCC5yjpyGUV0O8QmujC6YwszVDhcK0K?=
 =?us-ascii?Q?OpWIZjN6omKJpxBVtudp1VgLGrS032XYXeFE3pKTgKkCAs2EEiXiwzrPTDtd?=
 =?us-ascii?Q?jEgIFCAOLBZwmO+vjnvKh+oXmxcgjmcBNmPTz4Xj8wt5T1O8hJrIYwRn3YM5?=
 =?us-ascii?Q?8wS19bGctPWJvcZvXjbmaJtkNRHTi49GFZybcjN+GHmLPCdVK7EXCgSBo92b?=
 =?us-ascii?Q?wtL7S8PDtFXtQg4uhzDklAR7nWNvNETTpzkTU3TQFvMyCMqJA7e8Np0ZMjEu?=
 =?us-ascii?Q?PWOCWfaKOgQLTw7gCw9RJzw6QtrCYIMVHnIUOcJLbLmXRHJiieUd0YeO+S1J?=
 =?us-ascii?Q?9j1XkXvipG8i7ern237ArZ1BQ0LIOELBLj//eCkjMw2d68IqvwsxZm4t4jxT?=
 =?us-ascii?Q?2x2HFAl3H3A6tiaLIMK0Ida792li3R2lLBZmQu6BqiNMznx50393XGnhnFGU?=
 =?us-ascii?Q?Hf/IXJX6aRLmOT1NtnkHLSOTQw5szu/jKwkJiIiIK0i0S8AvfL5DIl+lNMxf?=
 =?us-ascii?Q?7J2lX9x7UJn2otZ7NaO82tGGgHfajyhWjZopDIn3Z3ShBVtreoRTH4wzrrgZ?=
 =?us-ascii?Q?DZ0xZRPxAaK9OZYImx0m8dbsJiXW1oIIcJGXtXcgJrg6Qgja6SLR9ve4lpj6?=
 =?us-ascii?Q?5V0DMhBss7nhg07fdLC/JBJm4dFR9mDFM8z4Cc4/5Hepj3/D4viKl+zo5nQ4?=
 =?us-ascii?Q?ZeTa9IopIcTNPJJL8JpiECRsEZ0tCIGvQII2xC8i7fyyWBtIt+G/xYOlAhCk?=
 =?us-ascii?Q?aLLUUMJg2Z6SYuRoQ06Cax9pWazX+6IYlxZiI4t8J/fXTfC0O9dYyGBHQMud?=
 =?us-ascii?Q?OiQ5lhPGzCSUx0LgSmjNAVuGdeBkFPedtheJLiRZx9oWBHy/JotoXlIBw6Of?=
 =?us-ascii?Q?t8paOMPAd1I/9bX+thkGGqzhYyc9t7QkZ7Kwi5CVd8DV+th8XJRcv1HZwVYX?=
 =?us-ascii?Q?gWlD9AIbRUIMHwbnosA8ptbxOm8Jmj4IQdEMvk/LbaaFJ6R8RbLNjDvbR0T5?=
 =?us-ascii?Q?KxHyJ8HwSl/PZmBONIEVxVgqPlIRO6r4QwP5q8vFVf/FXvqf5Plh95Ak00vl?=
 =?us-ascii?Q?VhJOtC+ir05VY5OSb1/qCU2r8KRgLaIx38ER7nD17zphB1yK1lfGJwemq15J?=
 =?us-ascii?Q?Y+xpYxU+cqE2akN5UlfXnwG6XijLdG9d+83ZeQQkH/na858/FHvZ/ELo9G96?=
 =?us-ascii?Q?x8F8KoIwX+CUzWAn3ixaqgSQ8YIdQZeyLvzLhAcl8CpYc/j+rFAw+VUljIIv?=
 =?us-ascii?Q?mLHU2HY6pXp3on5/XpHFlVgUmX1mCVl19vU+/ZsxmAA/5YX1t50cxC8XU756?=
 =?us-ascii?Q?p6L6mMq4TDFjFweNkqep0VWFW3bns1gU0h2uzj20Bgj0pdZFvJAu6msrDIU+?=
 =?us-ascii?Q?vCZq/OAjzUCoJw0VaUGJ9Bq3lskEIw0BhRCQvj023Wn8xfj9Wjr6NtBjrGOo?=
 =?us-ascii?Q?kz7T2afippEMzpay88ApKenejdXasAMzTdEoWvAr6hmZ6x7LkO5BsLC/hhA0?=
 =?us-ascii?Q?1v2yt4QDT6jW6Zk2+L4j0xmZrs8Y2wd03Ych7CuN4CQYUu9aMlvzRFir0ZBu?=
 =?us-ascii?Q?As5iVBnKVvxcheplP3hFjuAFnpj5w2S1rkHMCz0OjxYmkdNvaNKeuXWjzmfv?=
 =?us-ascii?Q?YFWBvw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf79719-ec3b-4ab9-41b1-08db0474fff1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:54:36.3056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vU/CbsRrdAZ8YVwWIaYT8e2/SMN6tBFDzStzadnu+20w1Vovf64N8qMfmHAVmtaQo84dqTQCipCJye00l0gDiGpP+014wz8oBKM/9qDGU0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5719
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 07:28:09PM +0300, Fedor Pchelkin wrote:
> On 2/1/23 6:45 PM, Simon Horman wrote:
> > I see this would work by virtue of kfree(key) doing nothing
> > of key is NULL, the error case in question. And that otherwise key is
> > non-NULL if this path is hit.
> > 
> > However, the idiomatic approach to error handling is for the error path
> > to unwind resource allocations in the reverse order that they were made.
> > And for goto labels to control how far to unwind.
> > 
> 
> You are right, thanks. Have to keep 'goto' structured, otherwise there
> would be a 'goto' mess.
> 
> > So I think the following would be more in keeping with the intention of the
> > code. Even if it is a somewhat more verbose change.
> > 
> > *compile tested only!*
> 
> I'll test this on error paths and resend the patch.

Thanks, much appreciated.
