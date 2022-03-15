Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21604D9814
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346834AbiCOJwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239448AbiCOJwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:52:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2784F45B
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:50:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmbn8RJck4y3q8c6AVUmhyxXCExp3dmbI3ojQACm/SOdZowdtEISwOlSACHVvPGgtql09sl6LipBbsO/sVchZpIlB+voAC7ygnUL4ZkF/5ESbs4MCFsJrwzenXbgLwgT3Q3O1YhCHPoKZHL9qT1kD94BbmXaLYeLTlPzkvA6sQSZafvJ3Wo0k0fj6ajyEs5nyiOIlBTC0d7sutV0Sbbq9Abgc3pS0CBvvVv5UAYhao6vMDhWbk6llNh8KHTLlWtb3h3I3ZnOJyPQZIuZECH9BiJ4TqEUizJhyyfe+E9Q0fhEU6Ox2e2oC0CoQkmxgOZx8mbQCmPCHaV4534I3WW39Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KhWPuyQNasMcncCyJ44KTBYVnu/B5D1ZQK1nz6Ocz94=;
 b=OqlvUScAs9af7eJfIC1QW83pwPZRPK0Ns5DNLIuHBcXVVhtzVPsA7JiE5b4LXNGogdNYeWZb2oEmBM86S8cRsU0TBBikz02kFLYJK9PgX3ZvpDvV7SMXRJhE9pa2VPvCVmOr5Vf+6pDilm1t0xqsLEcZ6FJSrTRPb904NZjDSaEIZlGv2uyst96eyl6/aOgbPahjORcd0wl3drcWRSkthtXkbqJiLP4+i9951x0lQl54Av72bH+bxJpFoKrnwKomE/fsO0xu3VpwfljJC5omxoGcZLunaZHRbHXS35lo7x89EL+HfErcSVzc8/7D3o6Ni4vhe4d7eGmWU7ow/WYdDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhWPuyQNasMcncCyJ44KTBYVnu/B5D1ZQK1nz6Ocz94=;
 b=WMNfC4PLI1ylfLy8z2nCzaPsXRb+EGWFVD3bHw3cRm+4QQ9W3uc1Rwg4ZKhEv47a4nPrf/CDIJBrASieaAVGFiWXMtgSXgh/iSCVmoPwvBLSXPPVzCTQ22dkm0nbN6I2Rrg5BZ1eBGhG3nzss6OrhLgDoLb2StcFQNuVXWjknk/gdvmi/GRNKUIQ1jY39qWDGjrTDLTfGokRs8wINkoLUSON96N07BrEXN56EtBUbfUM+SPFR2tN45WCfrYVnOWS/KH4f+JhbUEWryMw9FOA+7JiMd9C94PT2OOdU0FGdNm0FPipDjI24o5mlhzOhJCrdxOG0q9410IRwQKnpv4Xyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Tue, 15 Mar
 2022 09:50:53 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::d812:d321:525f:2852]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::d812:d321:525f:2852%9]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 09:50:53 +0000
Message-ID: <517bdd01-243e-3c32-1ec1-ebc7c5a12df4@nvidia.com>
Date:   Tue, 15 Mar 2022 11:50:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101
 Thunderbird/99.0
Subject: Re: [PATCH net-next 2/3] net/mlx5e: MPLSoUDP decap, use vlan push_eth
 instead of pedit
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@nvidia.com>
References: <20220309130256.1402040-1-roid@nvidia.com>
 <20220309130256.1402040-3-roid@nvidia.com>
 <20220314220244.5e8e3cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20220314220244.5e8e3cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::22) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9f56a39-4efc-4455-a187-08da06694b03
X-MS-TrafficTypeDiagnostic: DM6PR12MB4106:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB410679E6B00FBEB59B61C342B8109@DM6PR12MB4106.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BST2OXOtK4q5zKhIR7mnJlrKDdXbm3BmHnyRhTeQizs1fLmp/ITHB2mlX+yvBiFPIYu6BWlYWfbOV75CrzgmQJajkwvPfajwNmyI8eYMIZMoRh5/+vnA+lEWWkrLclhepmSmBFVIJl9V6XvTEFWik+KZ0rOBjPgU/ZtdU8C0QT7sVgr9EFWQZv28UzS5okBQLaP9hB11GRqtWZib3JlwD6hWdhk9fGoC5dBYloIjomWlxLF/qX56vMCs5K97BByXE1+m0YLPpy37sSwN24yazDorFjVGF/xjWZz+qZeGEpRQKJ83WGG/K1VHCSJv2LvvBy2zEPvPUI3hdckmrKhUerG8Lt3RtXoxs/uZkVykGHZPezJRnpvbTL12F6s0B4KS+Eo9xsyx2kNkkzMfXDo8fISTiXdOpXt6WyB7dsggNF23evwDzIISXrj8SFUbXJGygYhEGgIi+e4n9r0spfSVDfxEvwC8nFB4eyh7Uw1bbFriPOPv1B8A+NQxFQNArDTK9fbdaGvewzfCDkVvIFh1zStOaNjtLEfEU7jqVPkxR6SZgRtAryIng5eftbti7MLI4N9FWMH38jnjOcQeR5cpcrk1oUPP+DmawUiOVm4L91joO5P4Ry7F62e4dhAJK1/aby3+04FhzwRRlqBp8c0snsDD32sa/MM2KgacVg1j+BcQwegKBYuo5+n+RQRiitoHHFNpx7Y/jJCqW9RgokEUm2dC8nNb2d+poh52wYWfTU0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(31686004)(36756003)(316002)(66556008)(66946007)(66476007)(8676002)(4326008)(5660300002)(6916009)(54906003)(8936002)(83380400001)(107886003)(6666004)(186003)(26005)(508600001)(31696002)(6512007)(6486002)(86362001)(2906002)(53546011)(6506007)(38100700002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azV1ZFJMR0c3NHhDOWhFNXE3YUFRMXBxdzREbHhDZ3R2ai9WbTdib1ZiMWpZ?=
 =?utf-8?B?d215cDcvTWVtK2xLYkQwSTFWdzhYK21FTXZINGpJVmFhTndVUDNUVXZIM0xi?=
 =?utf-8?B?QWdRb3Q2clRZakJrcjhadDlWOTRhdGo2WFBXWkhMQ1h5a0RoVGlTUGdzRWlD?=
 =?utf-8?B?WTJYK2IwVitYN1UvSnJ1UnluSDhnOHZFWGZXYXJEdnBHbjRQeURWQnR0THow?=
 =?utf-8?B?WVpzT1Bma1pYYWRvenV5Q05BcVZqRjlQTU03WENXNlVHbUpSaG1SRFlzdUs2?=
 =?utf-8?B?a1Z2djNieklFNC81eENCZjU1aHF2N1VvWE42cUd4eFF0dkMwTDFNZmd6dlox?=
 =?utf-8?B?Qzk5YS8xeEowR1h3NU95NjNrNGxVVFlMVHlmMTIzdlBGMXZ2OFo2c2pXYjRn?=
 =?utf-8?B?RTVBTEsrM3I5WlVHeGh5anZMYzdJRkRhbGZneHVnb3gwa3VkTmp6N2ZiUnhX?=
 =?utf-8?B?VU1rS3hPZmJwVE5UV0hqYkM1TC9WNGcyUnpaOXhSbVdaZGJxWmxlYVArT3NB?=
 =?utf-8?B?cTZ3eHBWWVVzaHAzeFdrb2FWMzRKLzVYSXpaRktLOWJlZ2lpN1BoajNjKzZE?=
 =?utf-8?B?T3BOQlJ0VXJaUXNTWUtya3NaMWNaUVVRUXJ2dXAwRlJzb3JHVjcydVdsRlNm?=
 =?utf-8?B?UkJoa3F6WGVpRnF1OEJRTmRqaCtwdU9HNjB5RjZXT1BtbzFLY05tbnpIdnh4?=
 =?utf-8?B?SmdGSXpRMzdoMzJleHRvNVBpMGs0cjZKSWxtUzlHSHUvWHMremVUWUluVHBk?=
 =?utf-8?B?a0gxbkZuYnBPUDZHUnJnMjRVcUZ6OFRYcC90Q1V3RmUvc1Rua2NTT29QaDBZ?=
 =?utf-8?B?VDJaSjdzZ2xTdkljZzJhVFQ0SkluS3c3ZGNrZzBxQnoyakZpejRHZnVLOHNX?=
 =?utf-8?B?enVaYjhlbklzMFVZNXpZZE9EUTJqYUppcFQ1NVlYWlduWS9ZWDBaOG5NSTlh?=
 =?utf-8?B?RklKK21DeTJLZ3c4NnJXbFgzdGEzVTFMK0MxbXJhUytxbmxvdWUyK2I2QXg2?=
 =?utf-8?B?QU9XYmZxVGlEZ0VabkJad3pZUS9EbGVSOHk5T0ZaZC9MZGRuZ3RzT2hCR1N0?=
 =?utf-8?B?NnBra21ld3lTMlZIaC9abVM4Zkx3VHFYZkFEV3RhWHNCdzhhWXhyNjhMamhC?=
 =?utf-8?B?QldRdFJ2VG04S01vNTNlZXBNNThWNS9GeENYd2xnY0I3OWI3SWtmWkRvdzlY?=
 =?utf-8?B?cVpZRk10Y1Y5WmVXZDZtOVRGUGlpYWNBaStnemEvT01aZ0EzK3I1dnMzWkNr?=
 =?utf-8?B?TDFGeGFXdFJEcnBqSk53YnkyanV2WUpyTmsvQ3NOR1QrdmVjcU1Ib3ZUOXhT?=
 =?utf-8?B?WkZZQ0V6aDc3SEsySkp1ZnZtL243a2pUYmRrMUo2TnN4N1VJSEswT1dteXB2?=
 =?utf-8?B?anpTcTRHaGtVQVBlY2FZSWRob3B2aCtSVG5pRHE0ZmVldVpZV3Jab1lXSnhF?=
 =?utf-8?B?a0YyNEFlY0sybmovd3M3SFFIa3ZPRWpwWWJKRENjTVFURHhEZUJnVHIzNXYz?=
 =?utf-8?B?N0xDTHVCRXF0TUhudVJIUzlSRlB3MDVQditGaWJqNXoydmd2NTlYdmFKQUNO?=
 =?utf-8?B?M1k1NWhpTjFFMUhDOWhQcTdNME9VYlc3NTI5YjVDeDhoamVXU2tlN3RaczJR?=
 =?utf-8?B?L1FwWjRjcFpJbmVvUHUyV0NSK3V2OE5LZlFWSTV2WUZXUGRqVDVjZkFVcVpW?=
 =?utf-8?B?UEdtWldaSGZ5QzJrdHJveVROVmNhN0pKcFdSME1EcTdicHREZ2J4MFhhUTNW?=
 =?utf-8?B?OHhQVTBGRFFyVThGZFNMbVRPU2FUcFE2MGp1ZnlTTnRBUWhFWDZyWXV3Yyth?=
 =?utf-8?B?UDZ1WkY1OURMTFNVUm42Uk5haE1ZSGErZldWWEhsNmJ4RE5qYlZYWmVIVlNO?=
 =?utf-8?B?UVkxbWhtSFU2cm1mWSsxcVBSczhzTk1CZEhlUkYwRXI3VnR3SmJOdWE0R09F?=
 =?utf-8?Q?cWGqvw8DxCiS67s1Njq/a6JzpK5rq97P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f56a39-4efc-4455-a187-08da06694b03
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 09:50:53.2312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZElruufdCHNuQqCbL6hbnHRB8mInTiUd2jThTCZCYMN13A1FUyWPYeqxT0XFD1b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-03-15 7:02 AM, Jakub Kicinski wrote:
> On Wed, 9 Mar 2022 15:02:55 +0200 Roi Dayan wrote:
>> +	case FLOW_ACTION_VLAN_PUSH_ETH:
>> +		if (!flow_flag_test(parse_state->flow, L3_TO_L2_DECAP))
>> +			return -EOPNOTSUPP;
>> +		parse_state->eth_push = true;
>> +		memcpy(attr->eth.h_dest, act->vlan_push_eth_dst, ETH_ALEN);
>> +		memcpy(attr->eth.h_source, act->vlan_push_eth_src, ETH_ALEN);
>> +		break;
> 
> How does the device know the proto? I kind of expected this code will
> require some form of a match on proto.

Vlan push_eth doesn't handle the protocol, it only push src/dst mac.

 From tc-vlan man page:
        PUSH_ETH := push_eth dst_mac LLADDR src_mac LLADDR

In the case of MPLSoUDP the protocol is set by mpls pop action,
prior to the vlan push_eth action.

Example:
         action order 2: mpls  pop protocol ip pipe
          index 2 ref 1 bind 1
         used_hw_stats delayed

         action order 3: vlan  push_eth dst_mac de:a2:ec:d6:69:c8 
src_mac de:a2:ec:d6:69:c8 pipe
          index 2 ref 1 bind 1
         used_hw_stats delayed

