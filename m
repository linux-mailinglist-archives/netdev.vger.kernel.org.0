Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EC16AC84B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjCFQir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCFQhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:37:08 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE412884B;
        Mon,  6 Mar 2023 08:36:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ux+46gmyeDdNZ03qwBBixbnjHtZFxWYQdNTUaWHCYlm2bjwMUoPbkP2SNC1dJviYxLe940n9YhIUrZudntjJZG/GEBi7kHScIgscXv3gP68g+6NJNMtfRk+ieRHu/xT+bniPapO2ArgznFbFNO0NyZZI1UHgYiNX+g+DPo4jjvS/T1Xfq0XULz4ddWoVwkS/egLHjQlGast7Bdm9ECIy1vYBN7wGu6VvT3vkxPDIoglcKp5Dzs1O9bWg8xnSLkBgekIpFowsm6M2pM70K0CFN3s+9RkfiO0E3JPZKjkIpR6vrUgoYO4OqWKOJ4S/urhcwrNYzSa+8jXhwls9j3ibsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5S8dHE++qJF/FYBqm5sZOSv6oMElvMrReAiKvhLVFI=;
 b=P1xoEcAfVBDkW/mUXW6CXZgiDXcjE8z+3z0l6I94mPJhV7xvvmyV+L3kcZizgVK7ckPLbrSzaZZuSOz6zkHK1R1U2MxXOo8HM4udql/rzWyJb5H+K8WZxFy5QKsuN/t9igYwJZwHnNytjnMPwH6PoQVu65mcFR/742FppUoi1OiRq1sjBKh70Br8WKpKyVkFtqQNP9lplE5HBJktSX2pZRZR3khaMzK68p9SaK4o5OuRQGN0H2u/lTTqJAbQy31xNmdkT0TFGfXZnQBIIlaK/Wrm45UzRK5ST6bMJmOfi/TZsm7BvjvYw3OrvBeBX7aB5QbIcOnZSk78Uz9aKO8fjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5S8dHE++qJF/FYBqm5sZOSv6oMElvMrReAiKvhLVFI=;
 b=gZE3gU9r2ySfm0pf/w3nrcG4CRF2+VTqcPOzt+Bn73iaK603sTaKK66xrikAmse/e2zIXgDPSH3LUjYHm1xSsvj4Rkqv1kNBefX6EwS99weg5JZFbZ8VaNwQdJZAqML7AGszlXGP/+2Dvgtt1kSdSvOmK/tvbfgdEO+nIR/TVhI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5368.namprd13.prod.outlook.com (2603:10b6:a03:3d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 16:35:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 16:35:44 +0000
Date:   Mon, 6 Mar 2023 17:35:37 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH nf-next 4/6] netfilter: move br_nf_check_hbh_len to utils
Message-ID: <ZAYWWV/Cd/lspsHA@corigine.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
 <84b12a8d761ac804794f6a0e08011eff4c2c0a3a.1677888566.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84b12a8d761ac804794f6a0e08011eff4c2c0a3a.1677888566.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AS4P251CA0003.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: e557110a-e413-458b-ba1b-08db1e60d4c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xmrDA0EDQmO6zLyH88E0VMqylSki4JRJwNo1KS103jeowbei7Ve+PSY5NxO4JAlifIGK7yootCks/NGgzVY2WiY/2A/uQz/a1BIrB41W4dyP6MiQp9N6a4q0sgr0i4kMP9G5IO6fYUygQDIKnIJSARJ3oVJBTtqigeCfDsbt+xx88MfU+7t1H89GMyscTAimgvdqDsTWXELUic8JnyJv2sY9JAeMWHAX1vqMAUWWVD0YVJYjuILqOf3LRj+n56VkNJX3wJ/7VAKkik33Kb9CVcmYy7nL/y8hDbJxeZl6XKh/Dgq1sauKKPu6/Jl6vQ4zfQr5ahZ1wLUZRNvYPkdBObPovXoB85QVwiv75/51IY3MFr2cLhnHtaLhU5qBOKf/tJV74gep3qjkO0ldhKcPOX3vtGGqZmRQybbWH5qahvOQ//K/BMPec5L8hS4XhGuZUBW48UZk5Ii2+oGFNMqGnmmbQmRYzwIrUkC2WIhsZ7/p15CCc0Swi94iEK45oKBTB3sd/tveD+wIlwcq7Xcdu6uRaBSQvU5qDGXEfBC8g3GNoS8LSyIFyBD2+mU0lYP8qE58oW5yR6q0P2OcORFeXvEzFh2d3qMINVFxLVq4Nw1ZxSR1GzDX+Yu1VflZQmtZtHZV66R2CCSoDe3FFsf13NWiQtFMTN9069ToaMDjq1gMdUCPPpcXcGKHgeCgDxG3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(136003)(346002)(376002)(366004)(451199018)(36756003)(478600001)(54906003)(316002)(38100700002)(2616005)(5660300002)(6486002)(6666004)(6512007)(6506007)(186003)(41300700001)(44832011)(7416002)(66476007)(4744005)(66946007)(8936002)(66556008)(2906002)(6916009)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w0ancpBy1ID3L2LaWg7iAOeHtPdRAL+s/Vs+ZzJuZY/m2DKz+3b+J/GMt6+C?=
 =?us-ascii?Q?cv9fAcCJYK7kK3+mZQ4194bBGv2DUcYuff4j6b9C2hjr67Qwj0kOcG9q3eaf?=
 =?us-ascii?Q?1J+lx0FBEyc6uEEkru2yFu1A92xUgm6Qnz9+L8iRm7Vn+I0W+3wSu2/PZEMm?=
 =?us-ascii?Q?UJMjJwhRzkd2f9fUJKne0Ksh7jq6qsvLfM0dTz3Ug+vszeQeI1od2yJRYegZ?=
 =?us-ascii?Q?cmCJdKjLri7cF+VSmpKWTvCfcZJdZxc35ob3nrp76cRfOvosvMk65vVso/0t?=
 =?us-ascii?Q?BJYVAGrNvGQCB34Vd/5XPbuCCBivE3sh7ITqYQm7CKWF+2GdQVmBK1ecJjbb?=
 =?us-ascii?Q?oA072qYJiG3t0RUcj+LTbhjtxoAAJl53OhcZ6J5YDBACmKnJ34k/K0DvzwiE?=
 =?us-ascii?Q?J+yqrvfziCBey+5KpPgJd9LvTTWObjzqNpRd2vq5ytTRbv0Y5Dpp5mN895c5?=
 =?us-ascii?Q?5/ukw3hUXKBcXFY1a5uFa3arrM2VyFPBBFM9ZvTMmdzG/0FwbZt2HfoY342P?=
 =?us-ascii?Q?hlrUPiJFjZrnwBX5zl17IPcXrtcUrebHyJ60+pMRRSMHFti/MaCbKyb3QD8o?=
 =?us-ascii?Q?+mNGBht3Ry/GW5Yle4rTBKIpvwMfBU+Qe4SqTWCupFuEKw8TNIZ2NN4FIJlP?=
 =?us-ascii?Q?oocXaKzHuLo7MrUfHZnDykG/sB5fjqXDXJ0Qj44wM5JW9Go+Wh3qxncvmqV6?=
 =?us-ascii?Q?yxPa5RRhbQJu9OfULlIhDTInfZzz/+UfoZcGFttGQ0FVmYJPNzjLmgjPGO5X?=
 =?us-ascii?Q?NyYwb1X8VKdayj3fkERZufuFVAIckvsv6blX30LWQ74t25fazQkhb2guyhSV?=
 =?us-ascii?Q?SWRXl6A0tlQMtWgpFWcKPY+QP+AFY4zX0rXk/1VEbRRCAu5p0SLg5SQG7fUP?=
 =?us-ascii?Q?Hb0uzZtp/GRg29Jy1NkwFlhu3dOn5Q7/3imw3WS7FWF3EiTLH55rTuqyDUeH?=
 =?us-ascii?Q?3cYylRKLt5vPBLWo8m1Gtun5iTgYdJpx6YLPrfQkCqk39MZ/biTmc6V14Wjw?=
 =?us-ascii?Q?Q7Gcv/A5RLU/xHm35SDghEHPLcRVRe/dO0sSy9oBi8fcyK6Y2byI4+am8qSP?=
 =?us-ascii?Q?Ftk4Kiz940y2zUatQcvFKUYEUu/HAl1TCLM7UcxRZL+6ptGmrHq4Tt0smkCS?=
 =?us-ascii?Q?9JmGsc0HwmuwOyTzZzLn75WllmJmBGNG6NClyfYehRO1lPfyWr7snUgpYHLB?=
 =?us-ascii?Q?Conz65SKKI3DLq1pXbVRAWVE3EYRBr3EKBNxQMntgk4c1HYqz4aDebZ3ATt5?=
 =?us-ascii?Q?2/3KaJax9xA4QCBotKn2lTIfWUQyDxN28Vgq22YJnd1kwqiKLiH/l76aMO+k?=
 =?us-ascii?Q?nuVA3Wm+loZPhhE9p1e8zA2CXtOhynx+BHhDZb9E54kq5Og5OYwt05P/GvjY?=
 =?us-ascii?Q?Kozur50RBdJbCx3TCEe7NlSxZjtvxStyj8kNlPbc3v17jysZivFTYVZgRqeW?=
 =?us-ascii?Q?ETm5XSFkdcSeQ5xRgT1bZjMfc7Lt1Gtr8DqZbHzeD+qig6IdrMlGk2qXembr?=
 =?us-ascii?Q?QjwKEgzJiRQs6YbqdsYJcBvb9lVJQKGIxkEmEDpMDlfqa2KNjCpsoYwxqKT3?=
 =?us-ascii?Q?0lYYNpLCguKo3itemfF6Pu+brMw40Xb15xRXOopcZ6mQWhtlDtqz1AN4X/ah?=
 =?us-ascii?Q?aSSb9I5CZa/abzT5Iw0xakszfMLHEf4hDsgX3nPZSEoZcRonE3h/dhmaqR3/?=
 =?us-ascii?Q?jkWg2w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e557110a-e413-458b-ba1b-08db1e60d4c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 16:35:44.0560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ucNyUR6EdY7l1xqKT4L3+mcebginZwB9E2pxWhq3QHIUx+fhfoXthZkXDdZ8snrUdhhpKuXbM66mAe+JidmrXsj6lSsYQOThPt0bH+0Z+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5368
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 07:12:40PM -0500, Xin Long wrote:
> Rename br_nf_check_hbh_len() to nf_ip6_check_hbh_len() and move it
> to netfilter utils, so that it can be used by other modules, like
> ovs and tc.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

