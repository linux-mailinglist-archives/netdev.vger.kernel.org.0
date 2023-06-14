Return-Path: <netdev+bounces-10839-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE427307DB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FDFF2814E0
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777AC111A0;
	Wed, 14 Jun 2023 19:12:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E6C2EC16
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:12:16 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2050.outbound.protection.outlook.com [40.107.95.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D830B1BFD
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:12:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8YzeVTlxPvgCIDa/aAvaTxLRnHQQeWZfYcEv9gXGapqWk89gjiCf66RF900FkjhMdlo127zL8V1md3mVTc+ETOqemA5nU8a4FiIOv4SI9vRKqkt88U2bWS4ImR88t5AUB0OJnKyNsZCEcwj6ei/+G49FVwK7OTq1Q4J5f/4PkOjK+SpzGhiw5+w1+Vw6Xa8k4m7piR3PTE7/fyna+QlZ81d/6VglSbkwv8qMaLw2JNikR+LCDOIbulxtaN3aWvaGKMYMdo2OOoSnWq6etdeZmaP1ivPyzWkHiJPjJm6ipPh+1Q8H4Bfq3ndfG0PNC35tGoSMTPDNGYo79AIFQb0tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4kKHFW4IVjh36Mq5CXgxdFSz6+KUCDphgx+CY9L9BDk=;
 b=YZ6gUZPKnfFF9bjvlrRptRw2AnuBAAbEawzpYkmjHd1f8SpyBho2Wk9OdFZ/5Lx/ZZBOz+b0WErMxLfJab1+/11+htfzvV26Ol20QwS/YyJAZhDLJnzt3DNQSqHooWyUPRyJnlJECtlTqajbILbbyz80/zlUR+B4vIIdX55k+LZmZXCPogO6hNG7RwdopHdxnOzfaIDaH6VAJ+7HoVZWoXohNHLlmuCXZYQRGDXAwuVyxxmeFW+jMk4bJiErSao1wr9aqMvC9gsbMjX8iwjyb4A//O9zpOmSJMonc2UbJC0PO70fg33+0m2FPFVUgVProysp2H6waUC+2yQ2WKeQcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kKHFW4IVjh36Mq5CXgxdFSz6+KUCDphgx+CY9L9BDk=;
 b=CbsPFzvslQQx/32mHkfwb9O8hc07pvvmgQwalS5EFIjBDXTMnvcDdnho6Y0eE7jLKHcWy84w/NZGYQMsSfC80FD7JnW6grXfqTPV9cWZlpbFCDkTi/ecMlUujfTRv3xx5Wz4AOQpO6ybPmDHHK3+Ox0/m9OhtCJZDYt3nsIp7Cw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by MW4PR12MB7263.namprd12.prod.outlook.com (2603:10b6:303:226::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Wed, 14 Jun
 2023 19:12:11 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::d065:bf1f:880e:543e%3]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 19:12:11 +0000
Message-ID: <98a94275-8351-33c6-50b9-dc3cc3f51f53@amd.com>
Date: Wed, 14 Jun 2023 12:12:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH iwl-next] ixgbe: allow toggling loopback mode via
 ndo_set_features callback
To: Magnus Karlsson <magnus.karlsson@gmail.com>, magnus.karlsson@intel.com,
 intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
 maciej.fijalkowski@intel.com, hao.ma@intel.com
Cc: netdev@vger.kernel.org
References: <20230601074621.14755-1-magnus.karlsson@gmail.com>
Content-Language: en-US
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230601074621.14755-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::11) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|MW4PR12MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: db005a65-aebc-4f94-7b99-08db6d0b41a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Vk2mHrPFIo0ouw5aJDwtcH1WgKLf4wmfrd0OnlrSyPsBrtzRiRbwoujDOySnSL86AuBGncb6cnwr1lMH0o8FrQKkdGACje1j3d3zpKxmpaZulCLwJydQZxaXlebsIYxPkK5QDohXnQRhiX7ez8c4qblERbVeC5quwG4C/EScni1ZHNiBSSDKjZwDfizA+3iIUaVWnEGODZN/nxHrk79A+q0SdlZ7upU+WYp2g17S3YllgWSGVu/9QEfMYtLNfilEDINqRm9QtFd88SBqPGdtlDCJoJ5hp0jO2W4z3+D83J8djGulyKfz0dko/hY9yrc99Jzr5/T3eqLCXrBuqDFEb0B677gwgnzgnu+8wCOYo7oAl/GULh7+00EjaMNGg+iSNwQwkrIqP5cgM1R4niuKXCc1HMhyv/B9evSynj774vIAccP/sglD8+us+4T3B5pktLk7sW64Jpne+7gwroWhyptFF1c6n5nxfkwtQcTLHRTHozxNtoLj1UdEta6VgCE5jqKYHMB2QmK79q8I6V5UQ7n9hGheNLYBWYpvmHIOy2RJ2UtKY3IypQAZeMcpevmJQgoerKFRXqmqRLFtj1dSk3bF3bVXNS657rjQCANDXQozoKNE0PD4ihfJOT44wPjl8dd3yziZ5eguXUMftkineg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199021)(6506007)(26005)(53546011)(186003)(31686004)(2616005)(6512007)(83380400001)(2906002)(6486002)(8676002)(8936002)(36756003)(478600001)(31696002)(4326008)(38100700002)(5660300002)(41300700001)(66946007)(66476007)(66556008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGFhNVptSHBNZzV1U29BUmFvczQ4ZUlrd1RNSTVIVHJWZU1LY2lxUFM5L09W?=
 =?utf-8?B?YnV1VjVsYkZZanZ3YVpCdm5nV0xpR0hlU2lSSDI4aTI1d1RjQXpUK3VEczYr?=
 =?utf-8?B?RzVxU2ZWaVZHclM5TS9LTFZvZFpWWlZrT3FNWUlkYjlWNjhxVzhSdXI3UmZX?=
 =?utf-8?B?YkliNHZjMHRDU0V1cDJScmpWTjlqV0xpVFg3RXl2TVkxVUI0L1JUZjB5NVg4?=
 =?utf-8?B?ZjA4a3ljZXlmZng4Z0FZNktZTGpESkF5MTlNOGc4OUdaa2swRUV2R3hkajND?=
 =?utf-8?B?cEcxaVZXL1ZJWmdvanBPOCt2TmVLd0QxT3JQN1B0M1J2ZzNvT29WWjQ3U2gy?=
 =?utf-8?B?dUNVbTExbDdrbmo1amt2S1hVVFoyVTNHQThsc3p1ZUNrVjhBdWVRUXBNKzZS?=
 =?utf-8?B?SnZQa014Y1IxK0tGMHBZTWk2THZqUVBOdEMzaU1UMGJpcGdZSlB2V3dlanRC?=
 =?utf-8?B?YWx4NzkwS2dNOWlhMnRnUkxHZS85ZHk1MFAwQTJJTzh5a2RMZG8rczZtK2JN?=
 =?utf-8?B?SUFGK2Y3czNkWUZhL1JrZ3pFZnRPM2RFOTJ5REZUcG5tNTV3UUlrdUJuSVJB?=
 =?utf-8?B?eitwWVNCRkVtUUtvSVQyVDJkcHVLR3Uzc2VIbW1CcTQ5S0w3dGsyL2pXR3hQ?=
 =?utf-8?B?NnVDZDFNZCtsWVJiWmZKVSs3THFrRTk0M2MwRmZHT0RmbEU0bFB4QWZkVjBQ?=
 =?utf-8?B?SVQrTGlXcWhqVytoZ1dySDRpVGdYSkc0dndnWTRYQmUyUC9adkZwOVZ6dmVW?=
 =?utf-8?B?cnBPd0R0V2R5djJyMmVCQUhDOWs1L0FZNXp0eVRKb2VEQ0EvdkNmNTRwN3RT?=
 =?utf-8?B?L29QTTN1R2VONnBpYlJJT0x5SzFKbHRiaWpPU28yWHE4NXg2dzBBZUI5cG1s?=
 =?utf-8?B?a1pvT3MvUHhCemtEbllJdURFQ01mbW5SNmIwMDJVYWFXbTdFVWhwdXkrWW4y?=
 =?utf-8?B?STd6SDNSQXl6amNlcnpIc25zT2RPOU40Sm5oWDlaQ25KT2pJTXBsVHUvNlBm?=
 =?utf-8?B?ck5jMlFpZlpVcTZOUmZlVDFVTnQxcnJKck5TcDZzK1c2THhLNnJ1NlpFeXcx?=
 =?utf-8?B?UERRK2VtVXpUTTFOSGlEeTV3NWhLdWlCVnVIVU13dExlRkdPMWhlYm9sQzdy?=
 =?utf-8?B?V2hud0l2dVl6R1V1YnYzTmpvRG5kMjNpZTZnQUFjdURuemNsNTlQR2hZZnNs?=
 =?utf-8?B?dG4vZEpyaHJQNzNlT2lxKzUxenhmdUhtb0dpSkp2R0J1Z1Z3OU5nWUtQOVNw?=
 =?utf-8?B?bnZsZ016VlFVTEZIMHJEZUsxbnE1YnpWdTY4YnlzbEFsVWd4RklFUzdHNGNo?=
 =?utf-8?B?RUZ3ekdIeSt2NjR2czZhM0kzajhYOEhMSDJSUXJheENyc3JWZHhLS0hDbzgz?=
 =?utf-8?B?UXgrWWpPVTVLUndrZDNtMVgyVjVodkgvMm1yQU5pTmYxd1NKYS9Jd0tKTWw3?=
 =?utf-8?B?V3MydjE5OStPRE9NSVNJVTc4NlBQZlJrdUtOeXdPd083Q2dQaFVKVVdOQnha?=
 =?utf-8?B?bTUwN3hERGtsWTFoL25mM3VnK21xMHJYc2tTaFZvZ2E1VDJDaVV5OTZxUmox?=
 =?utf-8?B?UmgySHNjaGpGQm1kOXVNZ3prNHFGclVaSlFETlFRcDU0MUJXeUF5eGdIczdH?=
 =?utf-8?B?RlFtL2liZ2c0REQwK09WSDF2WU05L1VDSGx2ZkRZbVhPamtVWEltcEhGWXNE?=
 =?utf-8?B?dlU1cjJFQTdFYUlBTmdQTExxb1c1aDIrS1R5d2pORks1QjBmaWFBaldkSmJk?=
 =?utf-8?B?emw4RDNDTGU4VjlLeXVZVzZXSk1BWm0wMSt1aGRvcUR4OGg5UnkvZGdaT2Vt?=
 =?utf-8?B?eHpKUFVxM1hCaDJlSE54SVVvVkovWlJYbHJibW5DNWJLcTkydlZuU29OZWVB?=
 =?utf-8?B?QlhpQzlHSDRMVDRkdVI0SHF0L3BNbGZDWVA1Y09TK1l5ZFBhU2xlOElNVlJV?=
 =?utf-8?B?VDVqc0wzVFZUZjBBdmtJNkRNT0piQjZVdUtsSUR6bUhSNm1wc2ZoUzhWR3Fv?=
 =?utf-8?B?UUNldjFsdjI0MjRPZGJ4MkVQUWxKbGpPU2syTGpxMEhJQXZNUkZ5ay9oQjNV?=
 =?utf-8?B?UFNDd0ZsWCsySk5DUERTcnk5QTc0dVBRRHR0aGNBRlBWcGNQSjE3RkZuWWFY?=
 =?utf-8?Q?5pgQvDGT6XZEld2TXghPMswEI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db005a65-aebc-4f94-7b99-08db6d0b41a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 19:12:11.7506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B7Gf9X9suNanWFIMCD6XLclVYTwU6U/nhtDXS3tPhIL/NnoQJDBdffWuwMr54AUoVmPU7GDZB6qd45T9TNynHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7263
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/1/2023 12:46 AM, Magnus Karlsson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> From: Hao Ma <hao.ma@intel.com>
> 
> Add support for NETIF_F_LOOPBACK. This feature can be set via: $
> ethtool -K eth0 loopback <on|off>. This sets the MAC Tx->Rx loopback
> used by selftests/bpf/xskxceiver.
> 
> Signed-off-by: Hao Ma <hao.ma@intel.com>
> ---
>   .../net/ethernet/intel/ixgbe/ixgbe_common.c   |  4 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 73 +++++++++++++++++++
>   drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  1 +
>   3 files changed, 76 insertions(+), 2 deletions(-)
> 

[...]

> @@ -10969,6 +11040,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>          if (hw->mac.type >= ixgbe_mac_82599EB)
>                  netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
> 
> +       netdev->features |= NETIF_F_LOOPBACK;

This means NETIF_F_LOOPBACK is enabled by default. Was that the 
intention? It seems like NETIF_F_LOOPBACK should only be set for 
netdev->hw_features on probe. I didn't test this, so it would be worth 
double this patch functions as expected with this change.

> +
>   #ifdef CONFIG_IXGBE_IPSEC
>   #define IXGBE_ESP_FEATURES     (NETIF_F_HW_ESP | \
>                                   NETIF_F_HW_ESP_TX_CSUM | \
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> index 2b00db92b08f..ca50ccd59b50 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> @@ -3652,6 +3652,7 @@ struct ixgbe_hw {
>          bool                            allow_unsupported_sfp;
>          bool                            wol_enabled;
>          bool                            need_crosstalk_fix;
> +       bool                            loopback_on;
>   };
> 
>   struct ixgbe_info {
> 
> base-commit: 735c9ee9a374769b78c716de3c19a6c9440ede85
> --
> 2.34.1
> 
> 

