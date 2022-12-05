Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C615564399E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 00:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiLEXhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 18:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiLEXhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 18:37:32 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F105218B20
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 15:37:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBae2ZUhY/pS5yb24tGf0PaakkR2+RLNAiIgWy5zaQ7ST4u21O35opOAWJ5z68D1FtxvuQEuVHYcHghZBN54i2RFY8y82NQOKLZUsC7JVReiyriE/QO+LTR0Jp50I8D69NMyBu98CAnotC/uNhT/U6uz1khSmAbM4N3H+U6YlsnKUo3/rVnhP5Sb7ko+mvNrGHsKYVqFW2R6k/RBvUykzxtD5j1CR3apj3es/u6EFASmH9mygKoWVc0hUBWwykcVpjr1Wt87FDEcD0EHyzOlkiPdZlfvZMWPG7MB8KgTFVNvYrSmVv+2hrCit8bjMhPy1nawj/kDHIPjTOuPkRidcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hegD8nW1xZs/1okJ3MNxyovmZX/i1rEbgeeesVgJSj0=;
 b=TIGxRB9hW6DK95DzenV9trSMiqFVhDcIV9JbTL7UCVzXykn86sDlVM2uLdTJxTDfkSdogtNdsNUBmHo5R8U2acia1O5t6F2fBoZHhIr6kbcnWiQ6dJAEFJB3Exm9ZKLyfdQLNgdDXjuMmg4H59S9JXnTasxe5h1s9+Hpj92fkZ0aunzmwo02eOnCYOgG95JxAfgqiBO+wVya7bc4CTOl8LQKmZqqcHbCfEsmMit7r67gi+DKR2MLoTDNd9NNqqh37yV39d7tmD97MRRqpqqZ6ARKKc2BI59J7f+sX7+fKaLeRbSadB8GUr7wTn8AwMryupqUbXb+fGcn+d889sqbNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hegD8nW1xZs/1okJ3MNxyovmZX/i1rEbgeeesVgJSj0=;
 b=zEsMphqi4v0MHSIn/CnJNFftQTvO5or1qiOvgUZdBhkbgpNg0Ah8F8BnM54XDTXyZ4oJMpJD9gTsuBnT6MeIyNB2uE6m5uub8p1slbs+dIp0hPbN0GyFj20P0MtoTeLW5U7MK/2pDiAzqnH8Jplymy9Bvn5OR4jJ5Em+gtvxr/8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH0PR12MB8149.namprd12.prod.outlook.com (2603:10b6:510:297::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Mon, 5 Dec 2022 23:37:29 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 23:37:29 +0000
Message-ID: <34381666-a7b5-9507-211a-162827b86153@amd.com>
Date:   Mon, 5 Dec 2022 15:37:26 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next V3 4/8] devlink: Expose port function commands to
 control RoCE
Content-Language: en-US
To:     Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Cc:     danielj@nvidia.com, yishaih@nvidia.com, jiri@nvidia.com,
        saeedm@nvidia.com, parav@nvidia.com
References: <20221204141632.201932-1-shayd@nvidia.com>
 <20221204141632.201932-5-shayd@nvidia.com>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221204141632.201932-5-shayd@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0082.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::23) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH0PR12MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d9ebabe-ca5a-48fb-8bce-08dad719ac4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gJKJTGrrd6wpcsmdoYmA8tSR7+PmZBh5z38ltcjJBAcqIA4tmqeURG9HMLbREv4AKncNibb5ZK4SVYiD+CdBtr6m9luV8AD3x2fBH6bcNV+Drse3NuE8RjeCH6qfUet05ulTSTbyBbXvyS6gw3bIKo5qluQpJduXVc7frqk0ZOfTi5sd7TOC7LNKWQP5p55dtVGrCTv7eMop0ZLDHqdA27jtP2O03icEXKgyb7wv+NDEy7KmlVYOXPw0ab4rDYKiyeU1fhGVKul0eDz7T8lmnO3LT1Q5eK1Rr/pu5jkapC5s2uaAaTgBzEc6OAgfph/iS/kZiGJH4FJvURTxs9NhXgiM6RvOUnzuoyrR07OtMKXq9ZjQfTvvDbAlnRprL4tm1P2e7AREWCKFESkaKKuELWGjYiAfBMMrlOmxH6Zaq2cBCl7tKGTGNuWgnJp+/lLdhWiMxKF5M7wlat/24iMH5vi70MZz4kLp/D31zrkHD6RYPpSs5CJXQDWU+05tiWmqhy9lJs1Ar5gzMYMfmQ0kfnaXQdCxnlUp9MVSktV5oZEr3E664TH34mgdMOrhCq/L2fSvnJkcWBusuHoQGR/Xrwtafc8UZwhoEmtibL7A0bvKL+PC1rvcsqYTSn26bZnq0eh/b+3ux19r4xcHG1iJYEV0PXcpxYXk5zt2Uep1Up7MBh3OGFYPcPJkR0ZDzTOvVxe6gV90eZm81GELq+aqaDyW8sC4dgJmyLy8RuiwMmI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199015)(83380400001)(31686004)(186003)(2616005)(38100700002)(26005)(6506007)(6666004)(6512007)(53546011)(478600001)(8936002)(8676002)(4326008)(41300700001)(5660300002)(6486002)(316002)(2906002)(66556008)(66476007)(66946007)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tm9kZFpjamlIWFVlczVpRHBoVVJtYVRGSnhkcGxUcmdHYkFZLzN3RmtCYWdI?=
 =?utf-8?B?bFVEUWdXT3JrV2dPYVU1K3hTNUtjeTJFOW9hNEpCV1lESEZxYWpIeFFIdUZx?=
 =?utf-8?B?K3RKT3IvOENKWE9LTno2ZGV0NlZuZ2tvZkNYbitaemxpcEtwM01lYk9lK2NN?=
 =?utf-8?B?UHNjdmZCd051UVRwN1VJYU8zTzJYdlErUjZhSHdHZ0ZndXNVZDdEemc3MHhx?=
 =?utf-8?B?dDRxc1k3dEh2ZFFKY2VHdjl3bnZlek0vb2lUT1lsZUYrMWJ3QmNJdzVmTjdh?=
 =?utf-8?B?UGo4MFRWQ1VzR04reDR1MlBtd2ZxTU16c0pFelNuMzQweUVLQTBjcnVtQUJP?=
 =?utf-8?B?QWNaUDNLRmZ4LytnZHZvM2RybGp6S0gxaDRBQzZxUFBrNE91NXNXdjF1bEp1?=
 =?utf-8?B?ZHhtVVZmKzc5M09LTUdPQUxtckQxWWp5ZHBpenB0KzRMa2ZVNDVoV2tRNC9P?=
 =?utf-8?B?MlEvUEM4SGNOOFpPNnRQMXpCcVpZZGlRZ3RQVmNqUyt5RHYydzBQUG01WHJw?=
 =?utf-8?B?QVpiVkxWWVBPMm9EeHhjZnpBOHcvMVRHdHZ6a0N4aWU3eUg5N0pQU21HUm40?=
 =?utf-8?B?VmhRVFNsemhlOHVmRnAvVXJSbmNZMjZrRjY2WTl3ZEFWeEdIN3FCeFF1ZXRN?=
 =?utf-8?B?MW1BUDVQcFMrUEN5Q2ExNHU5dVdqQ2N6S2NCTUpLUGNqNGJqeXFhM0NXT2ZH?=
 =?utf-8?B?cUVPcjJyQkphMTljNERZRHFHY0dkVnpWdTJyNkxGcXR2VkRwczlZc2JpYkdR?=
 =?utf-8?B?QUkwdjVYR0lMMVREd0ZWSW0rbytyVHRmMk53bTRtQkVvSGtVSFh6N1ltMDdB?=
 =?utf-8?B?RW9aTzdodHd2R2hDTHUvWnVCN3EySXlid3ZNbXJrdVQ3MjdwUHMzdk53QVlE?=
 =?utf-8?B?T1poWUkvODRZU2ZpMEFsL29XYlA2dms5UTAyREpGbnU2ZCtXTGxRUlJhWkgv?=
 =?utf-8?B?OU10aTB6TklMUVN1NW1oS2NhQUNjd0RCcUhzbklXRGw1dURodUpRZWgxSG5j?=
 =?utf-8?B?NkxRWW8zRUJ1TzNkaHB0NDNPMWYwOHIxYUZxbDh6Nlk4d1JOZG5tZFZnTTZF?=
 =?utf-8?B?bEV6U2d3Ums3MmNnSjlSTEVFRk9ncUcyS3FIY0VyVEtJQ29XdzE4VW4rRTUw?=
 =?utf-8?B?ZWsxNzZrMjlhYy94cjlYQ1E1UzJodW16RGY3cFFQUFMrQ2sxc2JHLzkrNVZz?=
 =?utf-8?B?OXB4ZmsxZmE5bTNyeFdCSFZ4QTNQQnR3NVZuajRqdm5wLzd1cXFsQ0ZLOXRV?=
 =?utf-8?B?TjgwZEZPVjJ5SEJnMmgxTUdpRGh4TlVrREFWU3RIMVZTNjJiS0xYMDA0SkJl?=
 =?utf-8?B?d0VFTHdKdzEwb3B3enh2djdtTHlyRTFESWFMZm51eVRIOHhlc1lEMFV2eWls?=
 =?utf-8?B?SGY3VG9MaVR1K0RMK0pybHh3a21rWWRaUkZqVjFhRDlKSjEzaE1vVCt6K3Rm?=
 =?utf-8?B?VUxpZDhRWjFXa1A4Z3Q1bE1UcFpTVHpVOXBoQTkrZTZZbkdsbTFseWhhUlM0?=
 =?utf-8?B?QVV6eE4ya0Y5NUxmUk9MaURWV0dOTkZBV0hGRCtrVnh6YVB4MisrZ0h3bElR?=
 =?utf-8?B?UDZMcXNxcTM4cHphNWJiZ3hUU1UxSVlQUXE5aHB5NXFCR0FHbmtYWUkvc3lB?=
 =?utf-8?B?TkNyQ3laNHBiZzU0dC9uQUZUREdZNTI5aVBUdis0YmVpMFlvbS9wd2h4dkc2?=
 =?utf-8?B?UVlmTEtXYktFaVpYS1ZHMGlCaHdkM1loaVd4SWJCaDk5VWNacVBKOGNPNGxH?=
 =?utf-8?B?MC9xektVaDlCQkcvYkg0Qlo5Q2NDcVRWT3RWZzNjR1B5MHIvUCs4S01IOHc3?=
 =?utf-8?B?aHloQ1pGbGpnc0JPYmgrZ1ppV1RDeG9KZlVvTnkwV05yaVhJeVl2ZVp4bHFm?=
 =?utf-8?B?b0dPR2NrZlgzTURoeHhuYjdQdHRVb2xRT20wL1lZVFhsYjY0TDA5d1VDMTVn?=
 =?utf-8?B?QXkzTHd4Yi9iTFpTbjQ3RzhFUjY2YWVSdzRkUHplbTY4eDU4TFNXbzRuMktC?=
 =?utf-8?B?ckVwTnl1WmNQTHU4R1Y3NWdSYy9ZV3E2VEVscWVqRlNVUldUY2hFcUxmR29M?=
 =?utf-8?B?UGgvU2JyNXNDVGJuZ1JBWm1wSmR6ZUhJQ2dpWEFCa0RtdjB1NEdOVlF4T3lq?=
 =?utf-8?Q?2C0oD4HroWTaiSy2TZ9rAFqwc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d9ebabe-ca5a-48fb-8bce-08dad719ac4d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 23:37:29.2357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6pHO8L3ZKh7zwBguGCSPHo+9gqFo+2oCFDLjdKT9QqUk8WLfjRF7iYvHFYg0jMvRnlI6wVBAAvlKAvDO5CYf6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8149
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/22 6:16 AM, Shay Drory wrote:
> Expose port function commands to enable / disable RoCE, this is used to
> control the port RoCE device capabilities.
> 
> When RoCE is disabled for a function of the port, function cannot create
> any RoCE specific resources (e.g GID table).
> It also saves system memory utilization. For example disabling RoCE enable a
> VF/SF saves 1 Mbytes of system memory per function.
> 
> Example of a PCI VF port which supports function configuration:
> Set RoCE of the VF's port function.
> 
> $ devlink port show pci/0000:06:00.0/2
> pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
> vfnum 1
>      function:
>          hw_addr 00:00:00:00:00:00 roce enable
> 
> $ devlink port function set pci/0000:06:00.0/2 roce disable
> 
> $ devlink port show pci/0000:06:00.0/2
> pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
> vfnum 1
>      function:
>          hw_addr 00:00:00:00:00:00 roce disable
> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---



> +
> +#define DEVLINK_PORT_FN_CAP_ROCE _BITUL(DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT)
> +
>   enum devlink_port_function_attr {
>          DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
>          DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,     /* binary */
>          DEVLINK_PORT_FN_ATTR_STATE,     /* u8 */
>          DEVLINK_PORT_FN_ATTR_OPSTATE,   /* u8 */
> +       DEVLINK_PORT_FN_ATTR_CAPS,      /* bitfield32 */

Will 32 bits be enough, or should we start off with u64?  It will 
probably be fine, but since we're setting a uapi thing here we probably 
want to be sure we won't need to change it in the future.

sln
