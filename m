Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B5A60F0F6
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 09:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiJ0HMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 03:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiJ0HMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 03:12:50 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3098C14EC64
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 00:12:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWeDan/iqyvGN02tu/jbMUhlBHbSWmjU4C3yEyf4gp+o7kaSW7IU/9ALPs87nXNJEFaKh/ZnQl2Zj0SvmelRcK07c2MH7h4dtoGZcBQU6gkG+PZcRDBIi+X6yJNkNJuaB4g855Ve3VWqt8Krov6Dzy7HZFN6jIzuA1ofneRq5ssaUvml5H6BYKquRn87fSOgkotgsWF1H1RzIjjpG8VKefoUJLtuCVkdsblPULlpX72f6jyEtc6ZRUrs/dHstegTCPqmdOcpvUsZ8nDp+CPvAoRmMLWnGuT/M5jjl1VDrq9kP/Tvyef9m/8BWfwPTm5HCZDtiQmQi6gNs2riL0GqLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvq+G2uBYSsVHM8bFNQPOYltNu1tFijn/EEhpx+ge9s=;
 b=Y9aMFu8hT2RmPjLaUBBrUfSTiVcCUYPnccYAtRkX0dmBeNjXER4+nUF1ayRKiofdvSpMhJ7aWUCUlVC89AuQIB5pCYYgegFrIokzY3o6loBMAlVgsjNNLDAMpmzHu41ISQH5ho5OQtvr3oE4gkmn0PT9XTqs5hs9o+Guq5Kb1MY7uZTJ/xzA2fB7Oqa9NXxwUTmJsCWlKn/Cu1cYnqd4FRd6XY6tTe0IJA8VHK8KqvRzwlj8OKnwVWoGtdtU9xumJ90g0NXkgpVpB0EcZMheemmlQ9ekcunF4I1OxYOjKk0cvJdBuDmNSgafatzNokUq6F2o/bZF0Gm4lvUkgi07Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvq+G2uBYSsVHM8bFNQPOYltNu1tFijn/EEhpx+ge9s=;
 b=oIjZn6S1069gOE6W3HA8omtUt+XHJBUsigzpy2qivaJFyIEMeNpYsOpwJcC6sbDfZFTaSeSxSMtR3/22QQ8qXGYugKsYRrgfAJpLRl+s/Zv23czz2tex9icfDQOGNjUIHi7Ny0S8JAJ3IGcVs9wAjF28Qgi8JzPaxlKEtP/2Pz4WfMb/6tpbqFS+kQEb4+hkeQWQA9AsHru16vyOPhD1tcq/3FIDfrkNU6EkWN+Nx5ZJpqeOdKWW6fmwLKqKRoI2sNI7fDRe8ZuImjbLA0qH9/5hoDYUoQtL0o6rvU9ZSKZMbfgHNDntRrigieU5bNtwRy8F8s4Qp2dQPqVTJipB1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by SN7PR12MB6888.namprd12.prod.outlook.com (2603:10b6:806:260::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 07:12:44 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::ede1:d11d:180e:4743]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::ede1:d11d:180e:4743%8]) with mapi id 15.20.5769.014; Thu, 27 Oct 2022
 07:12:44 +0000
Message-ID: <56977d26-5aca-1340-baba-5ba0cdbb9701@nvidia.com>
Date:   Thu, 27 Oct 2022 10:12:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [net-next PATCH v3 1/3] act_skbedit: skbedit queue mapping for
 receive queue
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, alexander.duyck@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        vinicius.gomes@intel.com, sridhar.samudrala@intel.com,
        Maor Dickman <maord@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
 <166633911976.52141.3907831602027668289.stgit@anambiarhost.jf.intel.com>
 <c04ab396-bea0-fcb2-7b5a-deafa3daffa5@nvidia.com>
 <20221026091738.57a72c85@kernel.org>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20221026091738.57a72c85@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0684.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::17) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|SN7PR12MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: ba68c5f3-3acd-49f5-1bec-08dab7eaa4b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vWnIo/UZIi8N6N0wr38b0Y7C+YG2wJvEIdYoxf9phB8YO0yZnPFYjlHRnipTWmSEE+kwtTRADxirlhVUv4RjzdOIu9/HsrkuAntK9LZjssQgreWH2a9HYBhsPrzrkdqwe8SfINDgWZQ3k0Kh26t5Clai3ZeZTU+I6+D8uwr9dkE0RdauLdHes5TvD2zZ9Qvc4tmZFFl1CGe91I907lZLv/U40mEaFQxeFPOg8rQ3WFYtWlaZm25terZK/h8vz7sAY26j3mZZXc05CHgL/GY6vsZfDGeZlv+S4ZxDZ4tzQYPm64rqTr6UmzxM6Fg2JyJ1qGc1OtlFEvegFK5OZ1LG4z0gv/VW4kOdEEVnBRQNh5sJxR0AUJseUvbzK0AwViCn5MOE3F7cBFeNDg4yA7FQLVCPsaRRdqzYvrvDvcnSKeG0eX7lmKOSBtmiWzdj464dW7g6J6HyKHKq1E9Ruq2KPgBAh7rqMmv3RoHVOWC1qFFdgdTs9jg83e0HMwtSVHtV+J5vbEq6L/jb0ixxHdMeBAitRcBBzh3cr2ehPi13/q9ks9inedFArAS1+HeRZv/0SCYjl+Ak6sa+W/QJPoLtEEF4wu8j8W5YRfzI7Ng2wjYOn9DVwa3Lb125q6dKSP5Npd8uGnvX0jU3OezyfWX7nCRW7NKU74OPflFMhhGs89ludTrqK8WS9WBUS/5eEbRSJIueJ7EtFVNXECYdw8mtOXC3jUht4KUCRbvRSmhJWelYzp0D0cjk0AENdGXuh3Eix3ArKxYE17mJSnoor2CK3O6UfmJDQ3pW4xGGYZ5A1NA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199015)(6486002)(8676002)(6666004)(6916009)(38100700002)(4326008)(8936002)(54906003)(41300700001)(66556008)(66946007)(2616005)(66476007)(186003)(5660300002)(7416002)(6506007)(26005)(6512007)(83380400001)(478600001)(53546011)(86362001)(31696002)(316002)(36756003)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVRyUi9PUzdqcHRmSjd5a1M4T1pzd25aZFJpd0NFeENBWXFNWHJMRUNhZUhD?=
 =?utf-8?B?d28yKzVHa1dhZzY5TFB5aUxQbzBGYVExeGdDSDhsZVI2ekRTbWs2aWpLanU0?=
 =?utf-8?B?WHhLUDFmTUlKNG9MclVtSlI2MUltbkN3YkdPWlhqV2RDT2VySWxCRlJmUGJu?=
 =?utf-8?B?WC9JRGNkU2hOTjZPZmljeUdmVmNSLzdzeDJPU09aRmFPNlpjOFpSNG5YQ2VI?=
 =?utf-8?B?YUJ6T2pDTWpEZHBDd1VnQUFyS0VJbnREeExTVWs5QlBwYUI4djNZVmFMbE9Q?=
 =?utf-8?B?Tk81ZHczcS9raFBBY1hnWUtBaVNYN2xuSG5RazZoSldOWlJuajJIMVkwOVVF?=
 =?utf-8?B?aWlBeW5NQUlQRmtjY2l1SDJUVUduaHhhQ1JBei9vQU5sYVJFMXJjamd4aEM0?=
 =?utf-8?B?ZnE4eHhkVDRBTnc3VUR6OENxNTd2Sms4ZWN0Yy9LcEdmTVBPamZLYnE5Nmxq?=
 =?utf-8?B?alptZ1BINWlHZ1JYRXlYdGl6aEtaOUxZZDNFclEyeHJVQW0xanpEN1AwYU1V?=
 =?utf-8?B?aStNYVN1UUhjQVJOcFlCd0VWNngxK3IxaUdmTVVJR3R6SUFISzh2SFlLM08r?=
 =?utf-8?B?V2tSYWw3eXZMOHFhcEtYcjFoRk1tckdDYmRDYXNqeDBaN203bG5SaS9DR0NU?=
 =?utf-8?B?a0pkNkpxVHM0a2laZlBKUTBFaUNDeDQ0R3RVTVE3NXF6YzEvZS9kc3cybUdO?=
 =?utf-8?B?bUJlb0VFVU00ZU53YW9VMmVZbTkvWldLbXRVdGcyNytWTFYxT3BVQ1pNTG1C?=
 =?utf-8?B?WXVzYlBicWtRTmZuK0czcGhwWWRIbTFURlpxeWFTWlZLdFRsQVZ2eWhqZlR2?=
 =?utf-8?B?bTZGUWtVMEZpWmxkemdsT2xpTnJ3cHk0OGM3VHlWMXhxR2NGTUZ4Vk5aaUtH?=
 =?utf-8?B?NCtQK1NWd0k0Y1ZURC8ycDVucDlQSFlaNnlzOWJJZ0JTWE9zd3plcnBFdGhX?=
 =?utf-8?B?Y29keGM4eStqMGwrWnNTcUFpTzFwdUVxc2NiMGhOY2FrMU45SWxEbC95UGgz?=
 =?utf-8?B?ZWJjN3BrcjlDQkNNMWJKWjg2N0lRTUJibVI4RGJFUXBwV1Z5NzFOakxBaytW?=
 =?utf-8?B?T3lSWnJsZkprL005am9FbE1CeFM4QWtRSUxUejZZU29rQURvMkFIZU9keVM1?=
 =?utf-8?B?dnRSTXYwTDFiUFc2RjZQL2hib2JQekVGNGdMU2h5dGtzOWtud1JXQ1ZRRVhD?=
 =?utf-8?B?ek9ERm8rNlVJdlJ0QkM4dWZBUGk4VllMZzgyNzZGazZSOStZeHB1dU1nTDR6?=
 =?utf-8?B?eWVyVDJrU21LbnFIbnJBaHgyZHljZVFKb0gvQkUxYW5oOFVmcGErcTFYbU5n?=
 =?utf-8?B?QjdabEM2SWtPVk82RGZVc2lPV3FUNkdjQVRjVTRxU2txS0dFSnVLUkdlaEN4?=
 =?utf-8?B?a2NLdmZHcmFhSnE3WFZPQW1RZFRlRUd3NGFqUnBXOHdjb1BHRGRiSk0rV0p5?=
 =?utf-8?B?STBsanVaU1Z6cFJRY3pYRGo3SFBQYUFVSGVQM2QrdzJXSW9ETHZWZEhLYUk5?=
 =?utf-8?B?OWlUREVtcHRBQVBOR2J5a3ZYOUU3M3ZRMzdxd3hnZTVkbzRlM2IyM0h2bGVq?=
 =?utf-8?B?cDJldVoyMEZFeHhBWUdvTHl4anV3YXd5L0NtTWdlSDVKQTVZVXBGbEppeFQx?=
 =?utf-8?B?NDNVcWFmdlp3azNPR2RDd2IvRlByT1hBdmI1Rk5QUVJ1MWFaVzA0TnZQN0ZF?=
 =?utf-8?B?UThVVCtzRDFzK1czcCtlMmoyQmkyanVMTStNckJWTk91dTVKMUVObWsrTDlr?=
 =?utf-8?B?cUk2SGNYa0prbllPYlZrRUllV0JSdGE0ZkdaTm1OY0ZZVGRFZm04dDBLT0p3?=
 =?utf-8?B?a0lqZzFzOVBOZTJsUEZwWDhPZWtsRXdreHE4M2xySEJZemx3bFRmUkd3ODVv?=
 =?utf-8?B?cnMyY2w2aDhOd1RKdks1dFJxcDhkTVljajVaRjFlcEYyQUdKU01qZmY4V1Fu?=
 =?utf-8?B?K3VvdXJZRzlPU3U4RHVPeWJuNm93UXdnSkZnNmxVaXV5bHN4cXU1cHRENlQ4?=
 =?utf-8?B?UWorb2puaWhvaFcveDdXMm1wVkJtMCsvbW81Z0RPR0p1QzBnVm03Ri80TVp0?=
 =?utf-8?B?bVVXUFlqNHo5QlBXeVY2ZnkwWWhoSkZBSE1CVmsrQWtNY01yYWVwUkdvN2c0?=
 =?utf-8?Q?Le1NKI0OhwQd3UeI92FwQN1V8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba68c5f3-3acd-49f5-1bec-08dab7eaa4b4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 07:12:44.3292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ZWRafoMPbYm0Og2pJK/seSACFyY2BGV4lhlRQQAOQohHfMGHbi11kkmjkiITejE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6888
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/10/2022 19:17, Jakub Kicinski wrote:
> On Wed, 26 Oct 2022 14:40:39 +0300 Roi Dayan wrote:
>> This patch broke mlx5_core TC offloads.
>> We have a generic code part going over the enum values and have a list
>> of action pointers to handle parsing each action without knowing the action.
>> The list of actions depends on being aligned with the values order of
>> the enum which I think usually new values should go to the end of the list.
>> I'm not sure if other code parts are broken from this change but at
>> least one part is.
>> New values were always inserted at the end.
>>
>> Can you make a fixup patch to move FLOW_ACTION_RX_QUEUE_MAPPING to
>> the end of the enum list?
>> i.e. right before NUM_FLOW_ACTIONS.
> 
> Odd, can you point us to the exact code that got broken?
> There are no guarantees on ordering of kernel-internal enum
> and I think it's a bad idea to make such precedent.


ok. I were in the thought order is kept.

You can see our usage in drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
in function parse_tc_actions().
we loop over the actions and get a struct with function pointers
that represent the flow action and we use those function pointers
to parse whats needed without parse_tc_actions() knowing the action.

the function pointers are in drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
see static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS].
each function handling code is in a different file under that sub folder.

if order is not important i guess i'll do a function to return the ops i need
per enum value.
please let me know if to continue this road.
thanks
