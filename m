Return-Path: <netdev+bounces-9495-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 900517296DA
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DF5D28165C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DA07490;
	Fri,  9 Jun 2023 10:30:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A6916407
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:30:09 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942184C3D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:30:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkyofSJXp5k55R53Yiukayi0QdXv4aHFK16cMUrtG2IkzOZLA9+zn/oc/ldkTw5Ah5g1vSlKkILpttsXSgcurdoTYrWwdFOzUALfUV9+kruEg6GwVE2w9tQqWnF3yK1wHcS/ZsK6eRP1+PLmXUjxfx/iTSqMQ5HsMMKcrBu5X0vKcS2QyOpwffBuFDY11Mra2+CExvqwnSOB1nec2kRJjzYUYxG64vSyBJbn609ClgR9iO/bBeaRtMGb5IXswE1NEYgdzNc1Bn3KbwsjycGQJ9wHewngx9hw8eN9bMto2Dq8C+pjfxfO6cRkcDI2x5ldmC+FzFOp+oquzxiA7MSJ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUpNIGU4IR4BtmpvjWfNvWis4JtmlLzW4r0lIehbTP0=;
 b=PkhDiuEYj2WwBfNp9WJfcOMyKcHpLbBQK74xoiAziobJwMioRkXx3uV72DZrDir6nMVQdwVTtg0fWU1LniO6IBIsdvZNXWmimsW8ShM0VsjZNzND0bhq1aEfiPFLlLH2X/c1LDAP4fAYsj4a2iFdoUYbOEfuF27EHQESP76h4tY8MIuL/6qkqrIPpOTtylryD3l4er+jIMkjaqHMzolm9xjfMF+yYuZspyLgXB6lZuf7PHCiqpPplxbB2L4BiEx+CXYhdQngalOIOn7cF8FsQfDTWcCAcso2qk9+DQks9zXWjCYw1CfQRNt9IFYvuJBS+FnBnXDZ3kuNxWCcrUtXaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUpNIGU4IR4BtmpvjWfNvWis4JtmlLzW4r0lIehbTP0=;
 b=uIYjAQ9iAAWdWLoXpck7zCsL5mliFcuVKU+KxGZbyX5j0wryR+Vev6oyLs6+FoEG/ccgZ0ejj4TjustuBia2pS/q64IMCxIGWI+WIR09GH5+A03LQ3b7yKyGZuEMc0jx7yroze/eIc70xPlbPGvZBS9eKqrAqISQA9s6OYN9sZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 MW4PR12MB7484.namprd12.prod.outlook.com (2603:10b6:303:212::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.42; Fri, 9 Jun
 2023 10:30:04 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54%6]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 10:30:04 +0000
Message-ID: <373f5371-ff06-bd47-63c9-1611d86ad9d5@amd.com>
Date: Fri, 9 Jun 2023 11:29:58 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH v2 net-next 6/6] sfc: generate encap headers for TC
 offload
To: edward.cree@amd.com, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc: Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
 <ac117b151d7a47b6083b166c75cb261369dd26e4.1686240142.git.ecree.xilinx@gmail.com>
Content-Language: en-US
In-Reply-To: <ac117b151d7a47b6083b166c75cb261369dd26e4.1686240142.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0187.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::31) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|MW4PR12MB7484:EE_
X-MS-Office365-Filtering-Correlation-Id: 79898d92-ba4e-4644-d00c-08db68d47d37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ruKvbtsrmnCwJQXMuYkuNI7j56jgEOfgI3hrVcFxgdvH9kqKLkDy/bFEep99gIc2xTnNz6QxFvmr2KMh6jGUe5RoGj39gPi+5lp4YrRnjchPmSe4ku9kA1Nh95XF2O74vFlxPB5qro7oocNxd76CASj6oGpSzp6pE0Dym2NBXfsIF5oTVbRWSvZcTFrIzxbbb4MsoO7xrWvhoj7302JGAQPkDbOaS9R8Lzv6Js8XA4p/jJMMjHbJfoGhWe+ZORKzBgSmD/1XdIhk5/2WoxAVvw/zLIU8KpMfJMxJqfGQF3krtM8vvL1Iteqr/jJEswL+PZWbrYvHAP5oAgaDcwskG+QOBxcQexwEeO8obAcuOZbtytBE0ae1b+NJkkTtC4fCF6jiKQupERQtkGpdwqscHTQ0klXzSwYZaAOBS+g5Lr+Oj1yiJKxULJqiQfWcq4R3c2kTGIMKBFcIf6dHYX/6NKcb0XKk77LmqoSje2S+SlqEDqqlAeGrTeIfXsOQVZnenwKVSe9tGmz0+CByro5HFbQxgTNPlqDgxKuD6b6qrGPVx6MJKCJHM5MPU25uGElIhaPUE/zXxzzlhevzRjH4bSCIUUH71Mx+ZBFITK9PEsOlBD5tlpA84TP5cNGLPkOEyPDOQzB6mOZXolCS7S/9cQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199021)(8936002)(66556008)(8676002)(5660300002)(6506007)(6512007)(53546011)(26005)(86362001)(2616005)(186003)(31696002)(38100700002)(478600001)(6486002)(6666004)(36756003)(316002)(4326008)(41300700001)(66946007)(2906002)(4744005)(31686004)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0IrSCt2Tm1EcU9sV3VRMjhIMUwvL0JaM3ZLdTd1eUIzZXM3bnNsenA4SkR5?=
 =?utf-8?B?VFRXYSsrby9vbTJWZVhCeEJPaXBiOXo2dlVPaSswUjU1a0FFY3NOc21kSDB6?=
 =?utf-8?B?SWVVVFA0TTZielh1Y0tWQzRBeHNxRXlqN2JkNFZJS0RNMVlWSEhOWVV1aXFi?=
 =?utf-8?B?ZkhySzZTTEttYTIzaUF3KzFjT042aDRldzJuWmxpRlIxbE1VZTVLcmR4eFRI?=
 =?utf-8?B?ZzE5bXdSUzFwTmMyUzdKWEVtYVFuZk84dUwvTGtQMkFvVzl6VjJjLy8xTnBV?=
 =?utf-8?B?bDV0SDBiZmZYUlVMOVFkQklGcHlTaEhxMXcvbXBYUmdxWDA3M3lXeU5RSk02?=
 =?utf-8?B?NmYveU16dS9ISENGczlIdkE2Y0E5KzMyRHhCRGpMVlFqQ1BnK1p0YVBWVkxr?=
 =?utf-8?B?aitjbzljL3RaazQxZ0NZOGZLaWFyenNxTmgrVk5vZVBHcXdBUUcybGF2OWZ0?=
 =?utf-8?B?SlBmVFFIUE5KL3I2cTE3bWpoMDZmVXo2YVFlTjBmci9IL0ZMZmpaLzRvSGNF?=
 =?utf-8?B?c2Z3V1AvQ3BrSVRCaG5aMUhkZ1FkWS9WMnJZTTdiL2F3L25mS3drNlJYdTVS?=
 =?utf-8?B?d3NUbWZuaHNGd1kzSURWTXVSeU03cUJQeXBmSGE0SnV1SDcrUFRZQ0IxampQ?=
 =?utf-8?B?aGVZaGtRd0JnTi9CQUo2K0Zoc0JJeUdzWU5BNk1YVGRUZDg0YU4vQUlRNGRw?=
 =?utf-8?B?OHJXMVJIeHJBMHpPNFVrczZSMlVJVVQyTHJjc1ZJZWpqV3ZpdXVQTlVHY21a?=
 =?utf-8?B?MGxPdlpqU2RpdGRYTXJDWGhPUTFDazR2NVU4Sk5qb0ZFa3FVeDUyZDB5WkdQ?=
 =?utf-8?B?NFlxS05sL3NtYm1PZVQwTHQrL2JJcURSSkZVNkt3NW9tQTJzeVhzTGUyc25n?=
 =?utf-8?B?L1k4NW8yczRRTWMxUnYvdDVZNHFacWdUS0xteVRxTndkRk55RmVTc3p1U1BL?=
 =?utf-8?B?ZysyUy9YaFRsQUNBVVFXMHBEejlBK1hKMjJjNndzc2dwUTdiZ3o2d1ZYTjBF?=
 =?utf-8?B?c3BVVGNZVFo1ZFlOUzFpVWRtSDQ5TmI2RmtkVW1kOGFOQWRBcmtEZUN1bzl1?=
 =?utf-8?B?d3RRc2s2Vng0QTRHNERwS2VBVm9yOUFta2xiT21ENUw0NkJXaTVEcWl5Kzk0?=
 =?utf-8?B?aU9FendPa2N5OW9pRHpDcjNNTVAzaFAvYkRORE5oWGp4bWRwem5FbXVFMWI2?=
 =?utf-8?B?N2FpUGE0cWJUZXp1dXlxUzlKRFZjdlBLZ21DK3JBL3hVOWdNS3NaUHJ2KzhF?=
 =?utf-8?B?R2ZVTUo1WDJ0Z0VucTZUWE9mcDdtVDBGcENNK2tXZWttV1RyMVZrZGhMVnVB?=
 =?utf-8?B?eWFGTC91cDRmTXNBMHV6ZU1jMDc3d0dGaGVrdU84bXVPYW95aDd2blhBazcr?=
 =?utf-8?B?NzNTRmlaclNwTXZWejdlMERqOUtxanZ4VWVyRkJ5cDlJeXQyNENacy9MTTBk?=
 =?utf-8?B?WndCQS9XZVZUNjhGN09kVGZNc09vWEdPL25TQWdnVDk1WHNrVFpoNkdNaFN2?=
 =?utf-8?B?RnlsVWpzelpvYkpHTlBEYjNYdVVqWXJZS0NiWDNmbDJKSjRBWUZVV0JpZ0tQ?=
 =?utf-8?B?aXgrNXZDUDZ6MmpQc2VHak1tZ01XRGR2UlBQSlA5eE9WMmozZGhpTExSaU9D?=
 =?utf-8?B?UktMUXEvM1lNSm1UNXpyMmhPcWlZdmdoK2dzVnMzeVljWCtmMmtKUlE3aHla?=
 =?utf-8?B?dUt2N0hPY2tkeExxTFMxa21SNk9pQUJwNDcxREdxVTZCcGZjQzFuSUNqeVlB?=
 =?utf-8?B?VDdmNzlqWXo3OG1EUFEvbHhBWDdKNnZuRW5rSlcxWHR2T0dTVFN0REJoK0VX?=
 =?utf-8?B?a0RxZFIwbnBWUUxmMkVFeHZ0TlBhSXVzRE45RWJDcTUwVjlGZEZyZkRLd293?=
 =?utf-8?B?OWJzY0cwc1V4TGZudEhpMVkxUlQrVDlQWkNqZjZVb2xXQVdheTR0QkNIR0FE?=
 =?utf-8?B?M1JzQlhDWFVITFFzNmhacnFCQklSZHZzU2pYaE9KenEyaHlwdysyQVN3cXVV?=
 =?utf-8?B?K25rWldCdnhhZGJ5Yms3TUdrRzVIeUJhRjdEdnBEeUNHVGd6alk1cURYT1c2?=
 =?utf-8?B?QVE4Tm5rUm5rV2JzQTlTSCthVEQrajd6SzIrb0RuaXRYU2xPSHRoZS9HakNn?=
 =?utf-8?Q?QE8o0gI12rp93Ic2DkWD01y5o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79898d92-ba4e-4644-d00c-08db68d47d37
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 10:30:04.8709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aUBiaprnUxGQuJ6zCRV3wd7J9tylGISFeFGFl58zh6E54/pCJbtmSNeczwAhZjnu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7484
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 08/06/2023 17:42, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Support constructing VxLAN and GENEVE headers, on either IPv4 or IPv6,
>  using the neighbouring information obtained in encap->neigh to
>  populate the Ethernet header.
> Note that the ef100 hardware does not insert UDP checksums when
>  performing encap, so for IPv6 the remote endpoint will need to be
>  configured with udp6zerocsumrx or equivalent.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

