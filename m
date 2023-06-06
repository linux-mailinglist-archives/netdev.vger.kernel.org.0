Return-Path: <netdev+bounces-8423-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B925723FF4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D6AA1C20E72
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DAD12B67;
	Tue,  6 Jun 2023 10:44:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923B76129
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:44:23 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2042.outbound.protection.outlook.com [40.107.100.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70439C7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:44:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PE1kR8up7KfKihFTXt0LSW8R4ZCfoj9avnKRUKQU/HDY7dfI3bAIMuyYQ1iZYcTjNYsSLaYKyjaHl9wEg13MSd7zTvumlZ/iZt+4eoiTh9naRNLzfMGM1IFZgyE5JweBbZm1Oz27wEw68YimE4UAoiefkfUDGMRbKe7N8sxo/3WIMbJE2Z3JLAkqJfhxfFKPFPj+G8bx5wH5tJVfwHNwve8kO+x8nJfQbnX+VnuAO4ElMeR0u0NmB2iLV8tDWMZfV12BmXmojZzAxtRsq74P0yQChid2ys+//pECbIq8vKAutGGtLBK6xuDdIt/+AkH3KCbaMzeU+Gk14bCwYVXgpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TrcDtc6RgLn2CD9poqR4SHfjwr8DYik90/5QCEaxB60=;
 b=MtpJJ4KD6yKGyr8hJVQwW0P7v6YblHHcKPCtSCRhf7DjncbmB8yMtIWBQgbBDtqssI/+9ZV6YWkt2kBBWjBCJ0goSXDnOiGWdeq/BE+UPFsI/GaSPT0vrVACS3g4uk3pXERrhVEEJOgGh2ujUdrtv5i/DQ3esqNtrylBlRZaB+8SZXR8eLxdSIuBmycbTpif4wWP6vRKNcSp32mxciK2IrIc9PR3eK0xZnSSy1klB4ml+V0658En2n2br5fRzk85D5yGuvFPejBs8IK+etVx1eRJsuiZifnhDUu5+4pp/O+iPy/mFbj1wVDUpyoQ4IX3pRm0/B8FgO2iLSEwQO8Itg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrcDtc6RgLn2CD9poqR4SHfjwr8DYik90/5QCEaxB60=;
 b=BI7slmPbfUw68ipaASIfwlrtcZqZch4Fd3Omo18hd7b36Y1rpEWoux9Q0mkYE96pcUOoAOhQj00074/E4AHjxPPUmpG3KKgenYSyNchHjzHLs9qgVl7l7gQ3bmcgFa1T3t/7PrXOIcxVF++CX8PalflGnSIg/rEyJYUe0oFboSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 IA1PR12MB6387.namprd12.prod.outlook.com (2603:10b6:208:389::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.31; Tue, 6 Jun 2023 10:44:17 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 10:44:17 +0000
Message-ID: <c1b012c8-fa92-99d3-bbcb-314c8bb9e7c9@amd.com>
Date: Tue, 6 Jun 2023 11:44:10 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH net-next 4/6] sfc: MAE functions to create/update/delete
 encap headers
To: edward.cree@amd.com, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc: Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <ec28374eb94989fba657207c6373126bc25cc5b7.1685992503.git.ecree.xilinx@gmail.com>
Content-Language: en-US
In-Reply-To: <ec28374eb94989fba657207c6373126bc25cc5b7.1685992503.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0038.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::26) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|IA1PR12MB6387:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eaf4491-4d96-4420-bfef-08db667af9f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Cok2abxsBGjTbJkMMnmjxud2ExgXkwxF+jGrdt+s/QQXJesAo78wjJs5HiGQpSFwV93eAfUg8yN5ZwScwD91k7YqvuxIbcmZvPZnkUkoZvqJ3t82kJXDrcUQM5q0LxyLwY9W717BU79T62zesDV1Rm7OiR7Tv1jZWz6+NxzUj3e1lDUx+sHDU3X2RIYjShMiDxfzFm0aiBLr18J2XMkCzU6TDeiRDr7nJ0hJwZy//qz4kLDv8rAj+Y0M2Ys5cmSgYWZRg0RdrZJPPyx6/qb3mwEoQsvDxw9rSu71F9KxDKlUcrdUcVV76UGLeqiw3s2PllLskHeXDOhSdVXuntsmk8Kqo8deHH2u7ymnJuB9ZRCcUohCVH8GPy2xqbRbk1/nLWOk2Kh+rhogHhWwSeFpy6Jdm5nG9v5kX9uzCJQUeCG9+Fahjx3ZMpTpJVsZv1V/AtXLQswN2qksb2tvr4/CgN3zRm+eQPBJVOSWxc2D038CdqFYeF0FWFw9ZMhtJ22iWhzTIuG5vrPqSl9E73Ab/81zhphCrVqHntoHaY3IAfOIj/VikX8oVIxM0P+2J2HtSDGyFJZDOzkYSENe8m/+KvUOkhHFpcRJAu0mWIPJiqWlSTR23u4BZdg5Dq+wSPiMtGo+kl30+Kfi590+iIsQ9A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199021)(6506007)(6512007)(53546011)(26005)(36756003)(83380400001)(31696002)(86362001)(38100700002)(186003)(2616005)(8676002)(41300700001)(4744005)(15650500001)(4326008)(66946007)(478600001)(66476007)(2906002)(316002)(8936002)(31686004)(5660300002)(6486002)(66556008)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TThMUytnN3ZaWkdqR0lDbDRUTUc0ZmhxN2Nsd3QzTE1QK3NOdGg4OUplWi8y?=
 =?utf-8?B?eG5pSmFxU1EwcENyd2lEcjc2clYycVZVNC9JejE3NXVjY3lsMkdENTFyRHNh?=
 =?utf-8?B?QmxLejFHRW5LUDhsci9KUlI2cWNRVzh6ZTArQW5nUlpIWi9Cc3BBNU9yQXUy?=
 =?utf-8?B?L2ZoYitGQnRRQVk4ZlFTL0o0cEdTb0Fkam44bkJMUFA5VFdwbGl3Nm5ZeUFS?=
 =?utf-8?B?aGFWY1gzK2FaRmdZc1NBcGUvZWZZR2JtZHRTWkEyN3NvSjR6K0ZFTWlaVWNt?=
 =?utf-8?B?VG9YYTZpZi9SMm01ZFVkT1hraDVZOTRlT0hSMmx2ZDdRdG1MclhIYWtzRGZw?=
 =?utf-8?B?UXhmTXEwbTNsQXRHcXVuaVZRcHZickNwZVltbHZ4b3QrTHM1REwxbll1QUNx?=
 =?utf-8?B?eTRzWFQyOEJjZjhPRmZsZE4zZlZEVm9mUzk2TWF0UU5vTW9xQW8vd1hXMGky?=
 =?utf-8?B?VURIMDBJYktYUzFqaC9VUEp3MGpMcUp3cmIvdGhKc0tXTnZkNWpyWit6S0cz?=
 =?utf-8?B?Q2ZNR3lXZXluQVZTc25GK1J2ZW4yNjd3WFYvQ1dqYTFRbmRyYnlTbzNFL1FQ?=
 =?utf-8?B?aTljczdxQU1JWjRIU293VE1OY1plWVVLZ0RFdCs2OHhvZXVJM2tHQTJxZW5Y?=
 =?utf-8?B?YnBtUXNia1ptcUUzWlBOeGE4OE5aZXpQQWV5R0cwckp1Tm52YkJsa3VIblAy?=
 =?utf-8?B?S1c1Y0hRYlpESlFIWEtOYnV2bmdMZFpVbkJ2Uld4aDhhWWVNeE1WWTl6cm9v?=
 =?utf-8?B?VU91THdLdEZTR1Vqenh4R3ZoYTI2cXlTeDVOVVJDMjNaS2tZU05IYVl3NWNm?=
 =?utf-8?B?OVRKQTZpWkxnY25CeklvVk9Tanh4Tk9Jb1BoRnorU25CWkh1UEhHV296RC93?=
 =?utf-8?B?OHNKbXVTQ0diN1BGSDZCeGhwTmFTZmE3UlZ5ckxXa1l1RTZhditubzUzeU0y?=
 =?utf-8?B?c2ViR2ZqcDZlNmsrd1lubzRIUEtKS1p4UjRicFBta2RQZ1F0UWFkZmdyOXRY?=
 =?utf-8?B?czVQR3pGcUluSEI2NXcyZ3dRRk42ODZnUitVNkRDOFVPZUFGeXdMeHhPa1gr?=
 =?utf-8?B?d1JaaXhQS1RpSEtER0xvMEhtbUFPYjNQRVN1RzNzRHdLWXd3aHBiV2k1ZzlV?=
 =?utf-8?B?d3JDdHFEMGQzNTBRT0NWUzdzUjRUTk5JMWdGcjFkejhnVUg5amI1VXMwVzNK?=
 =?utf-8?B?a1Z0dldYWnd6eitSbUNRQXVKdytSM0N1S0RYeTA1anhUa3hEbGNiOVdjY1Vu?=
 =?utf-8?B?NlNUYWZJN2w2Qy9qRXlMUm51b2ptTm1lSWcreEh0YUNDUmRXcFNSRng0U1Az?=
 =?utf-8?B?dHhvQkd4NEZ3U3dSRFpqSFExLzJMQkdud3dLVzVqTjB0bHhJajBNbUpELzRU?=
 =?utf-8?B?anJoUzJkcFpPQUxoTGVDTWRsZEFBbnZoQk1hMExhUm5tVGFxWWxwbkU3elFK?=
 =?utf-8?B?dVRkZjNOak5kQUYwZyt3V1VwY083bEczaGttbHQzWDA1Y2NwUkhsNHVRRXZH?=
 =?utf-8?B?b1dOaGZwWkpOOEx2M1FRRWxkRHBqTW9ncGNOdWp1NCsyNUZLejArUE9COFRY?=
 =?utf-8?B?STVNQzZnOWhtOC85NTVPL2hGSVpCWGp3d3FRaXlDWjRObU9kVmRqVVc4M1Vw?=
 =?utf-8?B?NEFsZ3ZqcWpwRnh6cGJ5VlJKZVduaVJmM3k0VzlyVit6b3ZrM2ZxdVRUUDA5?=
 =?utf-8?B?K3g4TkFPc2kzb1VSRTBwbGtGV2IxUm9yY1hrSEgweU1iWHZ1RVVZMG5kNlZY?=
 =?utf-8?B?R0Juc0pHMjR6eC9EaTZxcEpNYmhqRHlCb1ZyOWp2UGpLelhIbUE0WXFIUWNW?=
 =?utf-8?B?T1htNGNrUjB2Yk1kQjRDa1dxcVFwMTVmb1pYdVBHY2RoeXcyZktvdFVremM0?=
 =?utf-8?B?WWR2QjErOTBNYTJ5SUovZzFIZlJGbWZoLzZuSDZnUkJpSEQ4WHhUMDBEei94?=
 =?utf-8?B?V0ZjWG1OZHlUcE0rbkhlZ09jUGF5YkxuTzMvVjU2TngwR095N040TXRzTnJ3?=
 =?utf-8?B?U09OblY0dWxHSkh0WEtSOXhSdVZ0NFBvMmowTmZkTWdwL2VUUnJOMHJDdTRa?=
 =?utf-8?B?SUUzaWFlSXc4bWxCdkdTMzVBK1psbmFnWVZMR0lPVW9rVWUrUVhCUWlUMDd5?=
 =?utf-8?Q?A1bOTNB4/agk3e8nFMhKX/XEp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eaf4491-4d96-4420-bfef-08db667af9f8
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 10:44:17.0976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qoUeq0jL0YQbxN/bzTYOlfpDeTN8eojGYylVlDnKrCWkfyX27pGpF+Bo/sblkWkI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6387
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 05/06/2023 20:17, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Besides the raw header data, also pass the tunnel type, so that the
>  hardware knows it needs to update the IP Total Length and UDP Length
>  fields (and corresponding checksums) for each packet.
> Also, populate the ENCAP_HEADER_ID field in efx_mae_alloc_action_set()
>  with the fw_id returned from efx_mae_allocate_encap_md().
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

