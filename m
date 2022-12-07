Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CE56450B6
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiLGBHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLGBHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:07:02 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3F6DFC7
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 17:07:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUvi+bX3LnozNaadJecjMItGEDRsR0TfsbViXBSuvPkoQtGWdYk7Gy2Fz/2u4w3dmWoIG2osZsAPTCL0Gxgy4KR320MrWo5o7jqgwa+yMo9exC4lCRwg+vMYXrQsnPIxOyruRCy5nCpr0i52XlV823kb7hgWii6gmq/gSXKBmFKu0VNl8JjkYMETH7db4oO5GrNq/wvHknsgzphcyRMFMGoUuSiF1twKJaebDe7wXN7+SOulE2v/oGo3Ftrgy2aEQbxKMYaoc5rRtG6CqMitKjM+ABj+AsR0T5KrppZ1bieLgfNC0E3Q6IZ+MGPCz2EhWwmJ3u/rl+lu0I+5maCYzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smtha1ziYxfqQ3WexZb4KRFq5cp976reEH30WybhPCA=;
 b=EV5zFZ9G+/QqhgmDHBWrVsovf3WmwK4vSAMlDOhplNXIkSOQvSRZcM9cnOsRjbUC/xJqeNCmwgmWiZS8U76BJYzTZ8DQIgrYMmCbhLE/iEaWTIulO1SobPX7uIGeX4Ncc4jP+2TB7qYq2J6BbDtJs7Tlu8DvhE2elqToMwUiG/vHL9RPRYPUKEV5GVg3gAqOk+fdJr1T1sqGymfDhiGSGkoqS9in/6OwKWk8a2u8wQ8vmGTXHQYLGE6m0rpMpJ1/WJKLt1dEgsx4dGp3Rqil+gIRSwpmYIlXPHWmaZ9787suySsXtbeI3Me19Hmaakm/ujkeWtaadeSJe78Tj2qkxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smtha1ziYxfqQ3WexZb4KRFq5cp976reEH30WybhPCA=;
 b=vRJKvEJlauH8SiUxUEiWhLyqeTNn2Q2jS6W0DGm8As0KY0KxkZgWv052KC75x4LJb3Vz3BoaXT86rNAaosPwOzLqoiq6TPdsm+dtpkdnzzvEqvqPEmZ3xafjhwWRbnbX8kStT8RmjIOLKMYOyLzTcNOnVudxHq2mrYFCX0KaLQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM4PR12MB7693.namprd12.prod.outlook.com (2603:10b6:8:103::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 01:06:56 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 01:06:56 +0000
Message-ID: <9369f524-4368-92ca-5342-b9bb62b70559@amd.com>
Date:   Tue, 6 Dec 2022 17:06:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next V4 7/8] devlink: Expose port function commands to
 control migratable
Content-Language: en-US
To:     Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Cc:     danielj@nvidia.com, yishaih@nvidia.com, jiri@nvidia.com,
        saeedm@nvidia.com, parav@nvidia.com,
        Shannon Nelson <snelson@pensando.io>
References: <20221206185119.380138-1-shayd@nvidia.com>
 <20221206185119.380138-8-shayd@nvidia.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20221206185119.380138-8-shayd@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0062.prod.exchangelabs.com (2603:10b6:a03:94::39)
 To DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM4PR12MB7693:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c71523-e0ce-4bc0-736c-08dad7ef559e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LCQ43ggsIMzXPJKawEcUYaFNxsqYAnb2aLLkdKyv3IErpUxfBOE/aPYjcsrCxNpS0mTDa2JIrMo5iQZxNMi82uxylEUYldFLWkF0z0Qf0lQwk4N/DXPrZvoi9lXS8HhtFXeNIAJPMRpP/mudNVxGcVs0sF5ugFzDaEqQJvs9OzVO6JXiDyC2uQrdxVLKBVH9MwK2zNbGEj4htYv3IqAW2R2y8KMVkBGSetFWy4Xj3sIKpPlO6RAG0jdgnvyW9DYSmzhbZ8YdNK7EXfm27G7UFtPHbKN6e+z1B78XwGAQmQTa5ye6kQcwOhyVJPwh8hVz6OBFrQVvr3kZoRxIva9orRk4T/PaA/yrNRTAa/uYcHS0SFIcL+yOBKwJVOWyGs0WbzvFb7n0knN6IjpE8Ln/UT0nk8EyIRciaFpDSsdBP+7QHjJ6gyZ8qFfv9WZp89KqZpcrzUnlghmVFKjCAdpqlHeoXc74xQzLPlBvZcFAvkrlxi33DXvkfLJQmjKN5boACoRIrngPAM4wHhsc7b6SPsQzsZIjQhCRE9oVyc1Q3Z+GDyHZyi00p5uVGulCQr3go1nuOkTfJ1+3dlz70IdfYK5gDoLNgho2uLb17HgGjBnuGmLGo4MZYZBICfJmt07HwmVwRU/dw3YchY6jzCWsOK2+5TdOUelnWqry60g4kYxgbBGAsDVBPAiA5LfD4y+Vu2FJ7+rZ381WBpAXYH4FUBGVjPChSjWjyhjhdNkK1K4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199015)(2906002)(31686004)(86362001)(31696002)(7416002)(5660300002)(44832011)(6506007)(6666004)(8936002)(41300700001)(36756003)(66946007)(66556008)(4326008)(8676002)(66476007)(316002)(6486002)(38100700002)(53546011)(478600001)(2616005)(26005)(186003)(6512007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXJkMUxyeTUybFJPcHpCWU4zU3IzQmdYNFVub2xFY0FZSkVuamdtTFVNUlgy?=
 =?utf-8?B?QVZ0OTdCTVJRSFNwc3FaL0FTNmVwbzg1MDQ5ODV4YkhzVUJ6UDluU0lycTdk?=
 =?utf-8?B?aUtOWFhpU285eVNRbUZsQ1JpRG5OR2hFUWw4V2JQbURzM05mV0E4a3R6akdk?=
 =?utf-8?B?RldOQkZ5VTRTQ0liVk45eUYwTFpSdXg3Y09YekxscHpZR01mazgzclUyMEU3?=
 =?utf-8?B?dk1rVVBUcC9sZzQ5QUF6cU83NjVWQkk4N29FZk5nU0dTai96Q3lwdy9ZK3U3?=
 =?utf-8?B?KzBrVk0wWDd0RUNxRGJEUWxiMnU4ZnlyRUxPZE1XaEZlS2daZGpuSzFMampU?=
 =?utf-8?B?MWEwdGVuRUFORFp4Y3RLZkVuTFVqbFZVUjNaU2RVeWZIWmFJVThTSVlnS05V?=
 =?utf-8?B?NU5jY2lxQXJnaDIvZjg3REoyOHhlRzN3RlRvR21kS1MvOWVLeks0OW5IUGlK?=
 =?utf-8?B?dVp6cmJtby9Sb3grbmNBWVRkMDZkTzZPeS93amxRT1ZYOFhORHREckx2RUpp?=
 =?utf-8?B?Y2lDaTFBOWw5VS84OHpZd0xydVlzc0ZsMU5QaStOV2ZCSnJmdnNCdEVVNGU2?=
 =?utf-8?B?T1hQOFF1aVEvTWtORlNYcHNyTHZVdDIxSU44RHNLTnRwQkkwY0tWeFdQazZE?=
 =?utf-8?B?dnpvQmltbnUvSVZwcEtnQ05DNS9xVjREWFVMQm9KQUo1ZStCd3ZyWWpuVTlr?=
 =?utf-8?B?ODRScE1EczE2L2Zlc0prengwTlRLZUtXbnhqbmtSaG82N1RQTUY1WU91WWdV?=
 =?utf-8?B?SVprdHpvREI0bzYxOFpXcEI1WVd6Y1k5SWV1WG1qTDBoeU9PbGJERGh3T05Z?=
 =?utf-8?B?eGhJbzNBa3BxektDNEJibUd1L2xCcW5GRkZjNWVEaENCYmRTNHBzVGlGdERh?=
 =?utf-8?B?Mkg3VjNtc2VySVA1aGhLZG4wOTFZczlodklrcmxWWFNyNGlid2lrSVQyM3NO?=
 =?utf-8?B?akJPOUlmN2lhR3FOV2xqNHl2YzV3WWo2K2N3TnhqaFNiQXlGMEpZWFJWbW9x?=
 =?utf-8?B?ak9kZTVScWp5cHRWek5JL2tTbGZlWXkvTGhpbUpDZE1mNkI3QUdsZHBWRU5E?=
 =?utf-8?B?ZlBjT2ExY0R5K0ErR2FRcXAvaUxOUkZFbnBRNzg2OHRIeGtCNEpPYWVjQ2lM?=
 =?utf-8?B?aVN2RWJYSkVhZXVjL1N4RnlZRkNEb05XeFNzMmtqMnFiNHhadWV3UXBPL1g4?=
 =?utf-8?B?c2RhQXlPd0lCaHlrTG8xM3RGVURUSnBWRjNocWZ2K1grb0l2bDd0MDdCODJV?=
 =?utf-8?B?amJ4ZHRBMGs3RmFUd3lIR2FZUTQ2dWxBTzVoaUxsM3hHWUhUNzNqVzZoNkFi?=
 =?utf-8?B?WTRtRjhmd2xsSG9rY051K3FtZFNQeTQ5NnYzTHhJZGNyQVZZdTMrcWYyMEVo?=
 =?utf-8?B?UVBTVVN5bytGZUdPakEzdWR0RXNZWFNrTDZTUmxpSFRBMmcxbXdKZTVyd3lW?=
 =?utf-8?B?S1hYVTRQbnJjL1lRTFdNcGhTczg4VGh6QTZGOGNTWHVyV2ExbkVsZkVvaHUr?=
 =?utf-8?B?UUMvTXNUMkdoSGsyZnZrMWVmZFNGcVJBeWRXZ1F2c0pEWCthNnVyRkhER1Rp?=
 =?utf-8?B?TnpYcnFJYklyeGI3dXVVKzZLay9lWXRBZTV5L1dFZWFydUNyUVd2MGVqelRE?=
 =?utf-8?B?S1puQkgzUVJHN3JlOXNlOVg0Nk5VaVhNWm91L3ZOZ1NWTzQvNVpUODRYdXMz?=
 =?utf-8?B?REZYVlpVa25URlM4VXF0eXdobHdQR3dZM3VVNHBNbUJVZUhmbG85bld6OXF6?=
 =?utf-8?B?TkZQWjVwcXZZTEdhaldvek9tUnhzSzdldXpRUEt5YVNRTlhiWjZ2SW5Kakcr?=
 =?utf-8?B?QlZuTlpkZFJSWHlXVWxYNDNuSTV2OTEwcHpMRzJxWlRickdLM2xtbjFBZW15?=
 =?utf-8?B?SW84cWJJTG1NdU05Z0ZiU0xQQWx6QUtkeCtVcml1N3NPVXlKOHRrUW8xK0pD?=
 =?utf-8?B?MURJMVpsMnFXbjZsbm9zMmhoQzN0dC8wem1VSFpSNzgrMXBWaHV3d3JIY2lL?=
 =?utf-8?B?aFY4cTl0WFFBYnl3NzhRVlhBME83b0N0aEdSSVBhVXdjV3ZyR3RPSnUveUZT?=
 =?utf-8?B?SXZKMkk3ZjBlR01kMTlRSHgyZ1JhaTJlR2dueEFSU3kwTWhMb1NBSk9XR3lM?=
 =?utf-8?Q?DCx/48Lfx0nNCc40ZW3OPQBJu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c71523-e0ce-4bc0-736c-08dad7ef559e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 01:06:56.1355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5tYz3MYvhfS44vRnNzQbq6EzRi6JLJ1z4AKRuGu73J37JUHYyGxU7+KdJ/8AG0aycXGd7fh+mvlTcaB9IZi1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7693
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/22 10:51 AM, Shay Drory wrote:
> Expose port function commands to enable / disable migratable
> capability, this is used to set the port function as migratable.
> 
> Live migration is the process of transferring a live virtual machine
> from one physical host to another without disrupting its normal
> operation.
> 
> In order for a VM to be able to perform LM, all the VM components must
> be able to perform migration. e.g.: to be migratable.
> In order for VF to be migratable, VF must be bound to VFIO driver with
> migration support.
> 
> When migratable capability is enabled for a function of the port, the
> device is making the necessary preparations for the function to be
> migratable, which might include disabling features which cannot be
> migrated.
> 
> Example of LM with migratable function configuration:
> Set migratable of the VF's port function.
> 
> $ devlink port show pci/0000:06:00.0/2
> pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
> vfnum 1
>      function:
>          hw_addr 00:00:00:00:00:00 migratable disable
> 
> $ devlink port function set pci/0000:06:00.0/2 migratable enable
> 
> $ devlink port show pci/0000:06:00.0/2
> pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
> vfnum 1
>      function:
>          hw_addr 00:00:00:00:00:00 migratable enable
> 
> Bind VF to VFIO driver with migration support:
> $ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/unbind
> $ echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:08:00.0/driver_override
> $ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/bind
> 
> Attach VF to the VM.
> Start the VM.
> Perform LM.
> 
> Cc: Shannon Nelson <snelson@pensando.io>

Acked-by: Shannon Nelson <shannon.nelson@amd.com>
(yes, my primary email has recently changed)

> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
> v3->v4:
>   - change port_function_mig to port_fn_migratable
> v2->v3:
>   - fix documentation warning
>   - introduce DEVLINK_PORT_FN_CAP_MIGRATABLE
> v1->v2:
>   - fix documentation warning
> ---
>   .../networking/devlink/devlink-port.rst       | 46 ++++++++++++++++
>   include/net/devlink.h                         | 21 +++++++
>   include/uapi/linux/devlink.h                  |  3 +
>   net/core/devlink.c                            | 55 +++++++++++++++++++
>   4 files changed, 125 insertions(+)
> 
> diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
> index c3302d23e480..3da590953ce8 100644
> --- a/Documentation/networking/devlink/devlink-port.rst
> +++ b/Documentation/networking/devlink/devlink-port.rst
> @@ -125,6 +125,9 @@ this means a MAC address.
>   Users may also set the RoCE capability of the function using
>   `devlink port function set roce` command.
> 
> +Users may also set the function as migratable using
> +'devlink port function set migratable' command.
> +
>   Function attributes
>   ===================
> 
> @@ -194,6 +197,49 @@ VF/SF driver cannot override it.
>           function:
>               hw_addr 00:00:00:00:00:00 roce disable
> 
> +migratable capability setup
> +---------------------------
> +Live migration is the process of transferring a live virtual machine
> +from one physical host to another without disrupting its normal
> +operation.
> +
> +User who want PCI VFs to be able to perform live migration need to
> +explicitly enable the VF migratable capability.
> +
> +When user enables migratable capability for a VF, and the HV binds the VF to VFIO driver
> +with migration support, the user can migrate the VM with this VF from one HV to a
> +different one.
> +
> +However, when migratable capability is enable, device will disable features which cannot
> +be migrated. Thus migratable cap can impose limitations on a VF so let the user decide.
> +
> +Example of LM with migratable function configuration:
> +- Get migratable capability of the VF device::
> +
> +    $ devlink port show pci/0000:06:00.0/2
> +    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
> +        function:
> +            hw_addr 00:00:00:00:00:00 migratable disable
> +
> +- Set migratable capability of the VF device::
> +
> +    $ devlink port function set pci/0000:06:00.0/2 migratable enable
> +
> +    $ devlink port show pci/0000:06:00.0/2
> +    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
> +        function:
> +            hw_addr 00:00:00:00:00:00 migratable enable
> +
> +- Bind VF to VFIO driver with migration support::
> +
> +    $ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/unbind
> +    $ echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:08:00.0/driver_override
> +    $ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/bind
> +
> +Attach VF to the VM.
> +Start the VM.
> +Perform live migration.
> +
>   Subfunction
>   ============
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index ce4c65d2f2e7..0f376a28b9c4 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1469,6 +1469,27 @@ struct devlink_ops {
>           */
>          int (*port_fn_roce_set)(struct devlink_port *devlink_port,
>                                  bool enable, struct netlink_ext_ack *extack);
> +       /**
> +        * @port_fn_migratable_get: Port function's migratable get function.
> +        *
> +        * Query migratable state of a function managed by the devlink port.
> +        * Return -EOPNOTSUPP if port function migratable handling is not
> +        * supported.
> +        */
> +       int (*port_fn_migratable_get)(struct devlink_port *devlink_port,
> +                                     bool *is_enable,
> +                                     struct netlink_ext_ack *extack);
> +       /**
> +        * @port_fn_migratable_set: Port function's migratable set function.
> +        *
> +        * Enable/Disable migratable state of a function managed by the devlink
> +        * port.
> +        * Return -EOPNOTSUPP if port function migratable handling is not
> +        * supported.
> +        */
> +       int (*port_fn_migratable_set)(struct devlink_port *devlink_port,
> +                                     bool enable,
> +                                     struct netlink_ext_ack *extack);
>          /**
>           * port_new() - Add a new port function of a specified flavor
>           * @devlink: Devlink instance
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 6cc2925bd478..3782d4219ac9 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -660,12 +660,15 @@ enum devlink_resource_unit {
> 
>   enum devlink_port_fn_attr_cap {
>          DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT,
> +       DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT,
> 
>          /* Add new caps above */
>          __DEVLINK_PORT_FN_ATTR_CAPS_MAX,
>   };
> 
>   #define DEVLINK_PORT_FN_CAP_ROCE _BITUL(DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT)
> +#define DEVLINK_PORT_FN_CAP_MIGRATABLE \
> +       _BITUL(DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT)
> 
>   enum devlink_port_function_attr {
>          DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 8c0ad52431c5..ab40ebcb4aea 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -715,6 +715,29 @@ static int devlink_port_fn_roce_fill(const struct devlink_ops *ops,
>          return 0;
>   }
> 
> +static int devlink_port_fn_migratable_fill(const struct devlink_ops *ops,
> +                                          struct devlink_port *devlink_port,
> +                                          struct nla_bitfield32 *caps,
> +                                          struct netlink_ext_ack *extack)
> +{
> +       bool is_enable;
> +       int err;
> +
> +       if (!ops->port_fn_migratable_get ||
> +           devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PCI_VF)
> +               return 0;
> +
> +       err = ops->port_fn_migratable_get(devlink_port, &is_enable, extack);
> +       if (err) {
> +               if (err == -EOPNOTSUPP)
> +                       return 0;
> +               return err;
> +       }
> +
> +       devlink_port_fn_cap_fill(caps, DEVLINK_PORT_FN_CAP_MIGRATABLE, is_enable);
> +       return 0;
> +}
> +
>   static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
>                                       struct devlink_port *devlink_port,
>                                       struct sk_buff *msg,
> @@ -728,6 +751,10 @@ static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
>          if (err)
>                  return err;
> 
> +       err = devlink_port_fn_migratable_fill(ops, devlink_port, &caps, extack);
> +       if (err)
> +               return err;
> +
>          if (!caps.selector)
>                  return 0;
>          err = nla_put_bitfield32(msg, DEVLINK_PORT_FN_ATTR_CAPS, caps.value,
> @@ -1322,6 +1349,15 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
>          return 0;
>   }
> 
> +static int
> +devlink_port_fn_mig_set(struct devlink_port *devlink_port, bool enable,
> +                       struct netlink_ext_ack *extack)
> +{
> +       const struct devlink_ops *ops = devlink_port->devlink->ops;
> +
> +       return ops->port_fn_migratable_set(devlink_port, enable, extack);
> +}
> +
>   static int
>   devlink_port_fn_roce_set(struct devlink_port *devlink_port, bool enable,
>                           struct netlink_ext_ack *extack)
> @@ -1348,6 +1384,13 @@ static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
>                  if (err)
>                          return err;
>          }
> +       if (caps.selector & DEVLINK_PORT_FN_CAP_MIGRATABLE) {
> +               err = devlink_port_fn_mig_set(devlink_port, caps_value &
> +                                             DEVLINK_PORT_FN_CAP_MIGRATABLE,
> +                                             extack);
> +               if (err)
> +                       return err;
> +       }
>          return 0;
>   }
> 
> @@ -1769,6 +1812,18 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
>                                              "Port doesn't support RoCE function attribute");
>                          return -EOPNOTSUPP;
>                  }
> +               if (caps.selector & DEVLINK_PORT_FN_CAP_MIGRATABLE) {
> +                       if (!ops->port_fn_migratable_set) {
> +                               NL_SET_ERR_MSG_ATTR(extack, attr,
> +                                                   "Port doesn't support migratable function attribute");
> +                               return -EOPNOTSUPP;
> +                       }
> +                       if (devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PCI_VF) {
> +                               NL_SET_ERR_MSG_ATTR(extack, attr,
> +                                                   "migratable function attribute supported for VFs only");
> +                               return -EOPNOTSUPP;
> +                       }
> +               }
>          }
>          return 0;
>   }
> --
> 2.38.1
> 
