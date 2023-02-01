Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C40E686EC0
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 20:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjBATSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 14:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBATSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 14:18:51 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB3779F37
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 11:18:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrXTFKzfEAUjdqUqIWeMx1L19CgD5yJyWjWQKz8EcNi8ASIaUiVmJGuX5rS18H1K+VENHadrAk+oOFeJA1l6s+WPS6kEXXXhoWp2XdP6AVoFkot7FarTaBqm8K/Sduo1kZ5oCtcfWzAkBUoANWBEzw05rHjdA+DFsgHM/HcP5ElsDsIh8ANvpQn8oiOFMyvtBYwwRzQC9iMImiRpFcv7F8nZSA4qCbqXB5YJu2nPhkYH8iCfiSBaiO1QlidwfVr9P/kKJ8CVoEvNO74iB2Q5bGjIinOVy9cNyNaWxNrvs08v7QaxnX6HqwIX4c8isXamxqXbKF+I1/DxvcPI2jggpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nw7ZrJUAOrSgMqyLKLJSwGMdstpDOb5HmmutNZZzTuU=;
 b=Qef1QnphN2vA4/5D8BQNX06/5vDCoXZHwYE2ypCIClYirAuaUVOTVHjCuyQWhufdKu9agJhFds1qVzIoXbB9QGFU/WuE4Uyq0iO2aZK8Erj9kTYF9Z1q04tIVt50SVGnjZYhPpohD/jyVoPoIPaUnjXO0KExGMeF2SXa5P457/n36oejsv+4oKKJr7THlbMVK/EsFiUiLN6l7WCyZTNXkKYlgrZQHA8ZIIjaNUyINrV9tEZggy7QT9FKiC5z3YR8SPGHXwucatuli9wGN/aXQ6Jw0uuSnustlMpH6S7rB6FVkrSZ+m5pQWpoAjT7BhoROvOBaruXqT0/2a2yL/PwvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nw7ZrJUAOrSgMqyLKLJSwGMdstpDOb5HmmutNZZzTuU=;
 b=OLMOxe0+Gs4FZG54QMZUde/NCMzLHmix6f7e5ZjxOkVpahs06p3TvNtmH6B+47EbkKO2PqBYLHXZbqdo9KRlU7FuYfbUgcS8UWastAjnO9/85CoKTBrXbQ2R/bY/kdDusyF4w05y5CRjSwl/HNelIFA63HYbXmfnqHXHM8NBRiDAFY1FLM1gd35rFJGRI8F6I2pXT71kAha1KIbnnwLwmvz2gdJzBVETDpxZtsRBNsjSMkhR1miFZSOzbygzT13EQIfr+3BT9w8K0vZAjC7/spKo9PERnZdjL6IGZXLHihMoLBErctcL0toQXTadDjgx4XoVnSEXsK6s9HHbracKJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB6555.namprd12.prod.outlook.com (2603:10b6:208:3a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Wed, 1 Feb
 2023 19:18:48 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6043.036; Wed, 1 Feb 2023
 19:18:48 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v10 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
In-Reply-To: <20230131205327.67adfc1f@kernel.org>
References: <20230126162136.13003-1-aaptel@nvidia.com>
 <20230126162136.13003-4-aaptel@nvidia.com>
 <20230131205327.67adfc1f@kernel.org>
Date:   Wed, 01 Feb 2023 21:18:42 +0200
Message-ID: <253k011urcd.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0106.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::22) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c193fdb-210d-4df1-8d45-08db048924d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8AqNu9w1+Wz5m0aSy8q5xNgEabu2YFuWK8gfWVNWAzuCM2jRhsWz+jed4GbaGGLxYkQKG2ewIunU/+aTESsuOaud/GKK3s41akQGICYZjAILRWPT7a/aPZEnBeCKVSgbBPKJ10BSw2U1au2A9frhFdxoJLw86zibpLz0AfH/oKzPijkkrfyviUgp6UzusdSHbplCF/l31gj/LS6b4P5M44mxQL5An0CCHZ2U5nwFR48XQKx6V6HNfTSwZ8vNVm47aiL9nysr7bgV1alVbw5k6AHNGhMKQvLgAZ/c3UjFZ9BZ1wlkxG3XDXLcSCgpxjy1epxfQvJtaJk3ICmk1Q5ords089fZyl1fsgvmPlP0oM9p6XDsMTDdIXZjg/OP4d6Vc+Dq+ZJWhX8//eN0HvwPqGyyvTTQPZhse600COdrwcs33q6RHuR/oJB28LwfbGSKVXHGWmO2miDAKuqvy6F5pUwJj6CevvnpMQhSdCTvlAiH3zVpO4r1/kZ/9RsgsmaJKFdA6L59h+p6rDRJp3Zefnphl621j+1/eD+AkUCLIoJhUOUkfL387pjrQZ9XOhZvCEF+BH8NMIwCrevXth+/sSROY5hc6e5D/0q2rPwAoKxmbdMdhbU77GA7TWp3pHQEs9EhvhZvK6Lj1nQhz4EnW2bic+OcIIWrytythsaqilzUnAX39YcKWmAsGGJYJ+tFqvpzYu1T7z0gMhZPzFr7eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199018)(38100700002)(8936002)(6666004)(2906002)(7416002)(6486002)(316002)(186003)(41300700001)(478600001)(66476007)(6512007)(107886003)(86362001)(6506007)(26005)(8676002)(5660300002)(4326008)(66946007)(66556008)(9686003)(6916009)(83380400001)(120234004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mMzt/A0ZLYcQG7t+CVhWSAXqOnh79ignHKSKGegYrpFGWl3fJNu4OJZhkWLX?=
 =?us-ascii?Q?mCKsPd1a7US9XVBhZfXwCHQPZ23GjXFE3ZQFH/cct6hp9Vjr/nIrIiXmyt+O?=
 =?us-ascii?Q?4Rw21ShZx6/lsQU86jkt5Fi924d2f6vjZ+M7a8pYxnmnmsZutsmwpRqAu0um?=
 =?us-ascii?Q?ZTd0mhcMF6cyq6an/9RPS7WhvdyU7CGh6a6Ab8O+mdl9McIJX9QCvpWvViPI?=
 =?us-ascii?Q?TZNu4EIwIC5LJ8lIx5lOSy/xFD8Sd8GDA2qne0ljv6wj7BdTixvXpnIJBpYy?=
 =?us-ascii?Q?4N/OBPVQITnDxIqhLry+h2ltLk7N0Oy34iBETzhbr1KaalOlDp9j+tyoHGez?=
 =?us-ascii?Q?/3XPRZ1He4UJ+AwtvD65+Lvp9zCZGysjhGeklAXY7niRrb/vUfpf3KIcHbfW?=
 =?us-ascii?Q?R6U87eHIgm5IZS/3YiSyzKxIe6xqw6FjGACv1luvJ0m0d0l52+TSY3MXhMqi?=
 =?us-ascii?Q?HlDFqKHfta4gOU4ALqvlse3fLVf0uCcHrrjYq2kXsvI4JhnZg0gS4LK9nGpT?=
 =?us-ascii?Q?kdzkpevACakXZCJHq4bjdlGZxvWrs3FZDZ+53C2t96IMLlxlXatt3ru73n44?=
 =?us-ascii?Q?H7xdR108T/MYvEj+nqmMvA+Dx81Xso7G2hrYm3Q8YuvfB1BaNI+vzOYxFn4L?=
 =?us-ascii?Q?5st8PMTDPwgDbp5jNCrl2LDPqnUmciO0aQhhEM1XpYqIC1dw9SCDkTWVT9t0?=
 =?us-ascii?Q?DE7plUp1GQUzIJlgD6kSpWNvCucK0L1hRqdgdxamWYHlCD3HsilqRNf442Cs?=
 =?us-ascii?Q?pZn+XsTWPzSq8R103hRpDRR/q84rzjF03t5Xz5MjgjQaF441srVXIbQ3rnKU?=
 =?us-ascii?Q?1vqetU1y6YMOn4IlvKgFJpaoiMPVVaj6h6YG4KoCPG83PAXvPopUyDBe90Ip?=
 =?us-ascii?Q?E8ySwz7sPkcOwsjfeMXo0VaHKOHb74TjuYEWH9iT5qZa17LnUPsPM7mMllzc?=
 =?us-ascii?Q?/+rBi28w0CVwqCEqjA+cRi5VeNiaBBE7vMIQO/iezX6NxdukeL5wNgDQl7RO?=
 =?us-ascii?Q?O9wia9QDeYcleA4aM4uF8zGoucqnTz0AP+SBreTMWMvk6KFkPb5cUfwmRW8F?=
 =?us-ascii?Q?/87wrPyb7aaqZthJUuW3kQOODMzrijFjcJ9V8/vo5W+e8B6LpTkcorLMXFBJ?=
 =?us-ascii?Q?TpAy42P9YYPK5S+5IVz+oNYxpvrxqpHBQwK8pcMlSZrTEx+XCtSGIet/ED72?=
 =?us-ascii?Q?5jjg29nxb06h+YRMEz8IleYGtD09ZK/5dRWM7iywspOYxdFXtIGlSWT7r1rP?=
 =?us-ascii?Q?Gov60GKpfP36xGRx1DNxQtCMZzeQIcEGQEHisHGyX4gqPxO6WkS2qn6wlgvv?=
 =?us-ascii?Q?UOQq6iUBZdUO2RKSPese3zbP2g3gOvZC6FjLDWRjjfdZ/5HVtAVqZkA+7Qhi?=
 =?us-ascii?Q?SMoica7LntIl3Qqx/tR8t/Rxs6nXyAMC58l5HL1TKMOO7LlAsAa0cGhw8T0w?=
 =?us-ascii?Q?co/kLYWvF64rV2DfCGt/8FDRu+VMpB85CqlXXje5KQ0OQvnP9C8oq9LeuzyO?=
 =?us-ascii?Q?E5cNbcCoPrIpbn85Vaj/krzshbB+ODN7G1/+l7MAmMObc45pdW6RZiR13gvY?=
 =?us-ascii?Q?scwyWhJdwzQW8Q5EvmPWWUVhYqyvG3imk+xEfd6i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c193fdb-210d-4df1-8d45-08db048924d5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 19:18:48.1187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ot5smt7zmNyMicUJBP7Bb+XQ+1sOFNHgZsqzFys3nZW9Tv0WtDKHw9tApoGhsg4e2wGMUxjJFbsMoQgGeredbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6555
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We noticed your recent changes and we will adapt the patch to use them.

Jakub Kicinski <kuba@kernel.org> writes:
>>       ETHTOOL_MSG_MM_SET,
>> +     ETHTOOL_MSG_ULP_DDP_GET,
>> +     ETHTOOL_MSG_ULP_DDP_SET,
>
> Please add the definition of the command to
> Documentation/netlink/specs/ethtool.yaml

Ok.

>>       /* add new constants above here */
>>       __ETHTOOL_MSG_USER_CNT,
>> @@ -109,6 +111,8 @@ enum {
>>       ETHTOOL_MSG_PLCA_NTF,
>>       ETHTOOL_MSG_MM_GET_REPLY,
>>       ETHTOOL_MSG_MM_NTF,
>> +     ETHTOOL_MSG_ULP_DDP_GET_REPLY,
>> +     ETHTOOL_MSG_ULP_DDP_SET_REPLY,
>
> What about notifications?

Ok. We will add it and use the return value introduced in your latest
refactor commits.

>> +#include "netlink.h"
>> +#include "common.h"
>> +#include "bitset.h"
>
> alphabetic order?

bitset.h depends on netlink.h but it doesn't include it: it doesn't
compile if you change the include order. We will keep it as is.

>> +static int ulp_ddp_stats64_size(unsigned int count)
>> +{
>> +     unsigned int len = 0;
>> +     unsigned int i;
>> +
>> +     for (i = 0; i < count; i++)
>> +             len += nla_total_size(sizeof(u64));
>
> len = nla_total_size(sizeof(u64)) * count
> ?
> but it's not correct. You need nla_total_size_64bit() here

Ok

>> +     /* outermost nest */
>> +     return nla_total_size(len);
>
> nla_total_size(0) is more common for nests.

Ok

>> +             if (nla_put_64bit(skb, i+1, sizeof(u64), &val[i], 0))
>
> nla_put_u64_64bit()
> And you'll need to add an attr for padding.

Ok

>> +const struct nla_policy ethnl_ulp_ddp_set_policy[] = {
>> +     [ETHTOOL_A_ULP_DDP_HEADER]      =
>> +             NLA_POLICY_NESTED(ethnl_header_policy),
>> +     [ETHTOOL_A_ULP_DDP_WANTED]      = { .type = NLA_NESTED },
>> +};
>
> Let's link the policy here: NLA_POLICY_NESTED(bitset_policy).

bitset_policy is not exported by bitset.c (static).
We will rename it ethnl_bitset_policy and export it.

>> +nla_put_failure:
>> +     nlmsg_free(rskb);
>> +     WARN_ONCE(1, "calculated message payload length (%d) not sufficient\n",
>> +               reply_len);
>> +err:
>> +     GENL_SET_ERR_MSG(info, "failed to send reply message");
>
> Don't overwrite the message, the message should be set close to
> the error, if needed.

Ok.

>> +     if (!tb[ETHTOOL_A_ULP_DDP_WANTED])
>
> GENL_REQ_ATTR_CHECK()

Ok. We will use this macro and move it to a .set_validate() callback.

> We should pass extack to the driver, so that the driver can report a
> meaningful error

Ok.

>> +             if (ret)
>> +                     netdev_err(dev, "set_ulp_ddp_capabilities() returned error %d\n", ret);
>
> and drop this

Ok.

Thanks.
