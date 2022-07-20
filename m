Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014D257B38F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 11:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiGTJOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 05:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGTJOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 05:14:51 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6D432057
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 02:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtX85kT/AdIcLRPAoBuf7xgcfoRCS33pBOK91xPdX/BBbogka0Dwk/raNThEXw4YosJso2oviTVvxXAtYvFB2Kgtk7a8OSgT3M85zI6Jxxl0ldaDV487Q/FG7VVH5c0CJqsJWWOLUTyfzTdTjlGHyQnYmMhDMqBjlfiJ8ZJEF9fC0w/GHBd+lx3q/B2nf+sM/tYb0wBJ56IBFsODT0wQG5dZklQ4BWiFG3oNQw43T20aiJiUcTy16awNPww6ZXHsdXxG6ZI0GJDlRe69DgqcYAjjAb/+E+a+eNB1U6RzKygsjfpicaRluahcp42jkccyaGr2RiEUTRXiF+zLWOI86Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A1a+HXwjnY9iOTYf482W+s2OqGxRUCPEZ4nv7LrpxCs=;
 b=WwSsRDk61UrwMb3AFmB2pyxetJNu7dU+EEGe53ezF4gvDxh/L8HpHtG2mZ0t1yg02H/U+iq7WHSXrBz6eBL6fiY0P6FVJnzOxdMWpaVbpaImoXqD/f8k1VBhDGjmaaA5Aelq/tNhguucqak/TtMtPJukSJl8gBPYO1dAzrs9fhC8C/Rj7BvoPRLG9KXzWPHR7sy6sofx2rr6++TOGyNi9fEWGv8sco5/O9BqrWuTpjiqNZuYxD6ZOZTmNL7nHVdbtgsGQJr4xakZAwsr12pVe1lqVs+17uFAt3HBSkIsH3lJtN5hcRXLpwHjZu94e0vdq5fVzRNRbuNynsx2WndcBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1a+HXwjnY9iOTYf482W+s2OqGxRUCPEZ4nv7LrpxCs=;
 b=AVUkxm9KdCIXUDjOUxnjYoPtVt7nd2jmJsF2AS8xxoWnsh57ke2T5fjHv1l9Yw89x5JLmId6n/SP3ih1cw0ApUzxn9ZAYa4V/BmeOJcDW+dLrYjiMIOn3axNChWQYMSesyIGIdkpIA8tFyYt6wsJi3GrnJ+B6GNJ4VZWQ5AqCpbo3F3ZFQdKj1R6AFQjir+nfSBG3fYoboc2tZqHAkw1jSkCGuuHPhyPTknx+aWGnZtOT+1lb7qdVrVhg66n1du4pyguP2i3kCpCcTXROl3ISlr0p+Os/coK7+MEEpg3yHCkPO8+zMPlGzdktvrnpUFWXcU7lqYJSD4LTdlJao/B+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BY5PR12MB4083.namprd12.prod.outlook.com (2603:10b6:a03:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 09:14:48 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 09:14:48 +0000
Date:   Wed, 20 Jul 2022 12:14:42 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 07/12] mlxsw: core_linecards: Probe
 provisioned line cards for devices and expose FW version
Message-ID: <YtfHgvf7ZRg3V2EA@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-8-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-8-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR08CA0182.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d88b27c-9a8f-4c75-e1fa-08da6a304b87
X-MS-TrafficTypeDiagnostic: BY5PR12MB4083:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ARJKR0Sep9wVyIwRSgbQbrYXsPPQwGrcBAcLBjvaOLEjw7TV6qQAHTCH5Fe9Nvrqakv9jraXRATpIeipIKDrxMwE3XRmJFoo7AtnNw9QlnUsQ8+4qOsc//bu0fE+bHthE4aV37QiHNd+e2HIigozPQe6ylzuM9nADwtvq2obv/Xtrk3F/F/sqwpySxmshL0iPJipe4Jvhya2tXDmi1Qd4UtTWkK4tdOfmbxgxR+tE7OpCdojawhAu0tigRYmlrZ0mkUUfjg/FBbR4rrUKIUxU9T4GitFfIVNrOihqx/zaaJnP1lm2fTwFbo0s5El+u1W3x9O4rhO2lD/43mfXmQP/zVx9OGrwZ4f3bap1pD8I66GBLH490iaw3RZmlFLC+1yDDC0i8hqM2UIg4fX6XYR/w/IKn63hSr2NCnllKREi8/+WaeH6tl1C0OP9TfY58OJoT09OXuSniLmJ7u6/kw5kIjFmakZV6kzwdOvpnJ3HLeav4leil1ZR+C2WM+rSMI+SC900nzuAft0UNTZBHPVliUjtLYVRDKm4UXYPAYUWXw5OKv8dONpBfFPQxwRU225/Kn9EIKGQBkP8p8pMu0cj+qaX4o/W1n9uyf4KRmHBmkla3h4MGqD4UvpfQT2jgxKRfX5uA4a+uY7AICI7rQofHJwYf6WirSqhYpQdvy6VDQrM8KdfUCDRiCv+IwqHQkz6mL/xG+HjyLGeNIQPRbPZ2u7ZYEratfWDDdIcGkx3XXU/Qmd49UVMx2jLsKCifJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(396003)(376002)(39860400002)(346002)(26005)(6512007)(9686003)(86362001)(41300700001)(6666004)(6506007)(6916009)(478600001)(316002)(6486002)(33716001)(38100700002)(186003)(66476007)(66556008)(66946007)(8676002)(2906002)(8936002)(4326008)(4744005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gUFOHgMPpQAIv/8DkT4HPwEy2JhDOFmodgyA7r9wEx8u0by3saic2zoQp/T/?=
 =?us-ascii?Q?BV5OdDsVAe2XMwu8fsq7yVp2l9FHW4VgpogrMKiqRdiLny6NWqvOcbFhTxOM?=
 =?us-ascii?Q?sXimOuokAhDoiSa6QnUbfnfF8HCrudVdGKsgluw513vDypZ5QG5hmtBzaxp/?=
 =?us-ascii?Q?U9byFcqykNIKYLnN61USuW1xkRPLyVpOq5TMhIYpZiO581BO3LG2BuVaZ19m?=
 =?us-ascii?Q?/6MLHCP0moQnPksRGfEmRWq/R8+BCAWBTQpsoKS8YntxcbJ6F08HJYPuJQWG?=
 =?us-ascii?Q?RHOlhxzWuK8KAhOfmFzvKdLlrGPrlXCKDBEkEzIMiRiKJt81j2Kf3kOYnTAe?=
 =?us-ascii?Q?5aOhhev0IqV+7sO8B8LrZYVXxvQxVTmtDT0HAWYZJeKf6XbgY1ZcMgllZ2t5?=
 =?us-ascii?Q?8psD97ErlU9S8vgpuzN18PvZf1yE6CWD6av0Gy8hB6AiTgn8RFr3R39FNVl1?=
 =?us-ascii?Q?NO8xsBfGkmYD32LF5q6W66J9n4vOLgoLNoum0P7koojLxH9HNiJiPvcL/dMr?=
 =?us-ascii?Q?AvvSogWlEHvOgQnizvOZGT+5ZlYMzfy8OoP84b3yv0OVbNpEUq1/SzkrTWNE?=
 =?us-ascii?Q?HJlDoj7JZsWg6VDFZLl3ks+l3HM3y4EoaEnvhP4XsPDFlqqtJ01Dw36bWdes?=
 =?us-ascii?Q?a4UNlY9htdnGqEW0JTMgO+ANmkhIPfL7dGVnB3HwYLdx6tUr7yxkM+dvm0MQ?=
 =?us-ascii?Q?zfEYoSaprrhXKs2hoicZS4Rk9zJle/dLdmVLAQBLMvlItPWsKaBc8iMrZem6?=
 =?us-ascii?Q?kUQqz+we+0znlpNlxEW5t0IiiV/s4gCQotaWjMqjGnbyjsJxQMA3RSvBSdZ/?=
 =?us-ascii?Q?LVupW20pilCEFhIewC9/nJEzR5dkFJsHoSZu40hO0nTjEPhgvmYELBf1CEe6?=
 =?us-ascii?Q?HyBxgXOGeSx50u2zUaIjHddMmqbwKy+OqUtaNT58tVYHSVAS3LgryfFzXDlM?=
 =?us-ascii?Q?GBuLvdtqDtyt9oKRrAGxeTuD8ofFYsHGDgIjoY4XKTQssIl+jO94IkALZUBX?=
 =?us-ascii?Q?63NVEulJHjS7szvgPyNJI0j3GgqXY4S92eKwJNyjx6rps0SHl/T15EsxJCRh?=
 =?us-ascii?Q?NaF6/sOg8qex7F4KQXYeyjP2O4WkWOkcvE+TioX+XKKZxBcwXiy209aDqzok?=
 =?us-ascii?Q?pHNySkM4/XSZh4phFix0ZgTcPJLHkIaCnv9WXfvd57R7vnTdtOV28nWdIDuA?=
 =?us-ascii?Q?vVVLNiU3rl4jtbhN84+oofFGx+/17DensZM/oAFX2xZ/RAAnIywMSdODjYOq?=
 =?us-ascii?Q?gykCvzZpZz3yk4xIyxrIAf6Z/vUuuCHJQfNGThjFNWnBitXEYN8KvyS3vjXZ?=
 =?us-ascii?Q?s6GdMYpYxRzZ6YSFw9Zah2PIjN43Apk7VXxRirEbh39oFHjnadxvTagLZ5dJ?=
 =?us-ascii?Q?9n8BxJtAfOaSM85KJ1d9urkUdVZv2abg6iKGZwpjSTE1tN3y/7PWQ9M2D8Mk?=
 =?us-ascii?Q?whQ2LZCqg7KErDll+jkhGWgRexr/DwjNb7vykdjiZspo5ie8A1usnJbCsSeo?=
 =?us-ascii?Q?NUnE2wb/y5rlKYnWbk6wY/JpBXRcRbfh3rY1xDdAJgXuvxINROSo9Ja2UxVa?=
 =?us-ascii?Q?o1JF4dSG33ikUr01g/UsSx+EPTLDggQYXUqLMe8H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d88b27c-9a8f-4c75-e1fa-08da6a304b87
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 09:14:48.5923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4gqfQb17bay/YiXSgXx8f3fxv9pAZRh9Yo/qPDSDU7UANp4tWGqxVEQH/EWGAvqUiaws1GBmO7msG6ZcU/qe8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4083
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:48:42AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> In case the line card is provisioned, go over all possible existing
> devices (gearboxes) on it and expose FW version of the flashable one.

I think this is a bit misleading. The FW version is only exposed for
line cards that are "ready", which is a temporary state between
"provisioned" and "active".

Any reason not to expose the FW version only when the line card is
"active"? At least this state is exposed to user space.
