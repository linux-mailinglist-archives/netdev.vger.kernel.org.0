Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C045168AA02
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbjBDN2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjBDN2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:28:32 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2128.outbound.protection.outlook.com [40.107.92.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE24C7;
        Sat,  4 Feb 2023 05:28:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfVrVyeT9swDGDmW0eU/YrJPhZEYNWznPz0MPVqxgbh/HefdLSsupsSp2PF64FpvKBV6ByDVF5LGVvMZ6cb6sq1vgo2GT7fb8z1CRybMBJ6sj1Ts4sN735KdUlX5DuqpetWyyyohL+y/vn3uxAaLVzKQOHJt/w1kaUSbVxK2BR/LrGXTC67rS5f8E6VEk5wunkMVQ4fR5Exxd/uVgiBNXzcBrK+Qq//Fvt90+zafdGcPBX3OEjVUf1LZhMe2t7AOipL4/CGcuvc7/YM0B+pcz/Tuihu55QnKTadzvqH4WGCU4pRV1Fa4/vX/Ry5e/Hpyi1rW3F0+mf0WyYPulBOJag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqWBOggluHBbzDgs3j1m9YVPnMJVuKpnZNQP5kOgxRA=;
 b=iUckkpgUwWva2cRAi8qVlr6MPiMdmCX53MrwW3bDSn1py+l1Cda4fT0cM1bHI1Sh3ht5RtvVdddG00kZUbV9Hs6B/j3OB3JVZf0sEobdNqhLiR0LOKdlSjWkxgMacxW7y2MFVwxv+ZjoanHI7GLxtAMNbFinnB81TXgPH0qu+0x2aIynohqG1uYky0VSavknk75IkdVA9N9hBTfow9n7D+LpMuEgRqORfXkqxkm35lsigwkCPWpAdYKtH+f5fPm5bJGhTxC4GH7GyhIW+5h08GKnpX0gXpGPFyfUvU73ld4L7S1Yu6qjEqDrFyqM3thb5UhXxdHm39r8oIzb+7Pgsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqWBOggluHBbzDgs3j1m9YVPnMJVuKpnZNQP5kOgxRA=;
 b=eYd54mfpa1b0+KrDkqkQxlpTHxqm89scIAp6h6LuRnEqNf2/0adkjBi4Y1GUQGKvUtKfHM0jevbaKJftCPzI4g0uR9yx2RU3hB2ca0YkPOQkydyARZQbogz1tyrQeWXjSNoQf50WTmpbuUhm2cpkdWuxC+gJsYwl09HhLLfPcmU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3675.namprd13.prod.outlook.com (2603:10b6:5:1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.24; Sat, 4 Feb 2023 13:28:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:28:28 +0000
Date:   Sat, 4 Feb 2023 14:28:21 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eddy Tao <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 1/1] net:openvswitch:reduce cpu_used_mask
 memory
Message-ID: <Y95ddddYhqkR7b1o@corigine.com>
References: <OS3P286MB22957550350801F37FB56DFFF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3P286MB22957550350801F37FB56DFFF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-ClientProxiedBy: AM4PR0501CA0049.eurprd05.prod.outlook.com
 (2603:10a6:200:68::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3675:EE_
X-MS-Office365-Filtering-Correlation-Id: 8100967a-c728-43f6-7bd3-08db06b3b32c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lH+6d7JCBHz64rECB4YGb/2gkhIPvQc3G6zgl94Ibas+HoyV5zJAEWvhTfCfbxOmPk4qMNwbmZ9NqTjT0nnx2yhkHawbyg/YZfLJsjCfqgrmzMlHSkBMrZZIPLmMJrJD0/4bA0LoMsBKHU8986nseVwYzaut2yPmmvmEVmsWfqJcfsRYwPeFdhqi2QKqiuaqoMn0gUyhGQBvF0iUry7t9yLSiguNU5xbvoOopnyZZoJ6rH9pU2d7LNWolbWayM2EJd4gfmx/XkuX6IpMLAFqwnT19lCVwvb/7UIfztuCbglxLh3uAN/j1Wk7dMdlfcP3BxIFEHPojAjrn/BGARJg3hAA7WRPjfuL+tDJj0oi2afDZQNCvuG2o9EG/Aeco4YqAQMbaJxW2wX64YKxAjwd+uHqfDyeikMl2oHFkyvebcXskDvQJQIymhhjf8uxggZbuNzQWixJ/RgYgAb1PrEelGSSqBjX8J/y4qcxf5w4aJpHjSada9wdURhaWG3pbVrx5Cona7VGmTmQQvosfzbHkY3LRJgmhyYNCd4CU8jwPmnGMuMbn0xcrbCK11RwvYl80tv3ypj6/0j0ro5nePSAT17r/+DG+uMb0lZNsKBkvoHp4viSSoqTN8DrbkJMY4NbHjaRwR+/Vg8LPpCOfunlIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(39840400004)(396003)(376002)(451199018)(83380400001)(45080400002)(86362001)(36756003)(6512007)(6486002)(2616005)(38100700002)(478600001)(186003)(41300700001)(6506007)(54906003)(4744005)(316002)(6666004)(44832011)(4326008)(66946007)(2906002)(8936002)(66556008)(5660300002)(8676002)(6916009)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sr4wasDoIBGdJTemOAM5rYjl+QnrNIp+poitxGAGK44S0ZuhLUoecs7bLncU?=
 =?us-ascii?Q?wTYZzexk4Vbn2+qt25f+LrNvI+6JrryfrBQSjTIFiHYAu23HUTdIuUZHn2by?=
 =?us-ascii?Q?MLkfITZbyGemF1YHjZTZUdOEMPYpO5i4DQVzG+i0fCNVOKYekNbHTVXY0jVR?=
 =?us-ascii?Q?GVfBYAlDj/x2NPT3NVmonC5rZfzFNDzzy32EBcYIczDBnHeE2TlUa72ZylqH?=
 =?us-ascii?Q?+ets6LxeZTJ3dRkBW8VCQTNMGe31suV9IEbjEPnYAP9MH7H9rKI4qndf9ej1?=
 =?us-ascii?Q?LQpPu5Z5YSzQwthDmPRfmXOxfVZp+Cns9FVqnvX5jgIR5/j+4YhS+2w7drzU?=
 =?us-ascii?Q?NGPvjaVD+D70j4qU8A+eryTNZZiVoHrYYji3WXeMVH6GpGE/uIwxj/lmu1oJ?=
 =?us-ascii?Q?suJqV280sy6cF3C91Bt/SHXU6COjoKPanTbHOVJoQqgW4v0fSuggQQReuQiJ?=
 =?us-ascii?Q?Q8Ayjz1lwk+cq052EIETk+QaYvWCc/wkSbnEywIEPNhWd6H7Y5xGcil8F4wX?=
 =?us-ascii?Q?EEU8+ks7GchAzpENEIYejqqKBI6z7YzRxOgwCNlQn82CfoVDExo0/lN5uFux?=
 =?us-ascii?Q?dZkaDCsDjGy9afh+VmhQ15WeMwXUUh8O0ZI9R0R9Yayf7mDprQHc5i3cqbvp?=
 =?us-ascii?Q?5zG1ZbSG5DbhYQfIcYYfm9PpRZbmGzwVQrXmPFxEuMWxu4FCM/Qj4zjRkHre?=
 =?us-ascii?Q?hkzBtWSdhfuXtdZIT97v2Rq3O+rE5n4Sw/2p3H2rYCgTOXeAeRcEDpK8oRfz?=
 =?us-ascii?Q?LMBWRwUp7xjImRjBDQGeTB2KX7O5MzH7GciH4+l5t573DKgUfOH1svUWn53i?=
 =?us-ascii?Q?rX/aUrQ3TKmfMtqe2IP8X+871CO4xmvYlVRhS6GOCB4ETSH+RrGoHj1SEcS8?=
 =?us-ascii?Q?CN4rATt8Fd6DV9GJUVVvkz/j9ZPMav/94t7Peo1kK2quPVIGQjpdRgJRVNQ0?=
 =?us-ascii?Q?W29hPjDkfTh+f1TBbvCKlixrwhg+4A17cmpOnHOdR4cFUoNdpOPSh1gBtFi0?=
 =?us-ascii?Q?Tk1XUKKv02cFfI8B8UxcieZ2KxF8N7UOzQMXAJSG+11W00/PyeBtOgINVdoK?=
 =?us-ascii?Q?qceWddxbG7LI3b8/5XrzyPKNtmwyJPILhNR2k2B9PSj7zXRoHuMFQXNAys40?=
 =?us-ascii?Q?exCQhSmWvobh4ZPwdXvljb1vjNlVtyWaE9exon8KA9vVTidxFls36kZNoJOi?=
 =?us-ascii?Q?QRoU9vYs3Gv29BYDEGyQw9qt74G1nWBqQaVhhIvx0om/hRtj2RXI2g9Hi4br?=
 =?us-ascii?Q?RpRkv+zAsZi1U43ZG0euMp1J82C6n3BhNwKYttm6mACx4V2AQNDpvmLFUJYV?=
 =?us-ascii?Q?rOw3uvUiv8DDDCKyOC0fuY5L7wsq+4BmbguhmKAvdCnPJOKPJmNiGu7zdqZv?=
 =?us-ascii?Q?ckyVbcEgaaTZnI8H5lUL5+g6cuyEgj1Ga2jq2HWivzfG5RuJAr6mMRg/saPO?=
 =?us-ascii?Q?p+7VvB+IOtzTe+jZY7yEIGcW9m/ZhK9oXNu9t/m7WQso06DSB5APAYf6N5Wb?=
 =?us-ascii?Q?TRpoEXdgM/bkxw+CfLiURiiO4mT4gBN/M0hhSun6keKr3FwZptEGoIxnxaAd?=
 =?us-ascii?Q?tytdRC88utDSZiM762YBn2QqERY3UNRHpB/vKPXBlT/j9mltrTpNOJ06E+1o?=
 =?us-ascii?Q?Tk0nNCaMmK0eqwex/AG3gCX1aoSskVUkfz/OiCOQmrcEClqlPqBgm+zqs90r?=
 =?us-ascii?Q?KHZwww=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8100967a-c728-43f6-7bd3-08db06b3b32c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:28:27.9725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rN+zno3FSEoB4oxa/ikIrOIzSrSySxCkbD5YmGjDWpwwEG7qQBZiRVK0i4JX6JdwlI2bd37Q69RnUAeXQYCUDzKsCYMMpAZjxxyBdNh6b4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 11:42:45PM +0800, Eddy Tao wrote:
> Use actual CPU number instead of hardcoded value to decide the size
> of 'cpu_used_mask' in 'struct sw_flow'. Below is the reason.
> 
> 'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
> Its size is hardcoded to CONFIG_NR_CPUS bits, which can be
> 8192 by default, it costs memory and slows down ovs_flow_alloc
> 
> To address this:
>  Redefine cpu_used_mask to pointer.
>  Append cpumask_size() bytes after 'stat' to hold cpumask.
>  Initialization cpu_used_mask right after stats_last_writer.
> 
> APIs like cpumask_next and cpumask_set_cpu never access bits
> beyond cpu count, cpumask_size() bytes of memory is enough
> 
> Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>

nit: I think the correct prefix for the patch subject is 'openvswitch:'
     And there should be a space after the prefix.

[PATCH net-next v8 1/1] openvswitch: reduce cpu_used_mask
