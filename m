Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BD16439B0
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 00:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiLEXzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 18:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiLEXzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 18:55:40 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272511D308
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 15:55:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUaIOsGfagHoQvmXIrZZ9P/12+PVma+y4XDBMzgFPAqXaDRoy+9o/z/WEeLR5SiwisUm5JzPAI5lBZHg7yeKF8xL6bMr8+QlWMi3TQh8QLODZDvLXWhRovQAo1sVU+Aiags1fZyIvnzDFpp4cfZhFNDUmxAF1AEFP/UJ3R8dOU6L+EAtEBe7o4FKSDD7YjfndCytBQJv4s4MY1gCSvmQjWnb8oWI4IMyEFqIJdW96Saf9bonzhZt/HtAynj3nW7nwR0LPgQED6lss0GCmnDBqpBC14uYjA5Lb5ZqW9tumGeHb6IvsvXlflnJhhMbbCbUhSNcg8BdnmHY1seq8nYjlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tvHgpv0MANGfJP5nogZEsMB6082fq2putjaTk5M0Kw=;
 b=UIChyash6UF7a7j+jUBS849gAAK9SQmkAAldQxYHbKWLjmt6dgGgzYvd309d/TQUSj09zUX+TivKVcguY06ABch8S7HNbiM3cWOph22nUQdO7TYw4d0oi93/M6vOiMYzOHr/y3mLUzFF1GOx3eEz5a/fEH1TUItUe7WXkZ5+5/1nq19I+A3tsbmd832JGzfBnleRFh9fwmjrkFF18xfQTeunE6xbRkdCmUHem8wTZKr3Kpuwyj/3tBMHeMs2CoxzsQzr3/dMuDy97O5oRONGP0/NwAiiniJTQE7JTMHbdIpM41aKMFX9SOUN01+5sMmxc1kmTp6zXAyfqTomnaJSHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tvHgpv0MANGfJP5nogZEsMB6082fq2putjaTk5M0Kw=;
 b=Z1nt+ZfL//HOcY3PVORwBRcEXNHEdQdm3JuUOIqUie3PX7/F8A1EXYE2ZgbqI8+9hEKmvuUMUWPXonoRzGEYgFuUTkgI+fKpCAuaZvpJFo/U/z3EEGITNLks7au/bn6c4aoBz5L2swqweu5j3CvqjTXN0KDqPxNF9S/TzV2stiM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 MN0PR12MB6078.namprd12.prod.outlook.com (2603:10b6:208:3ca::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13; Mon, 5 Dec 2022 23:55:36 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 23:55:36 +0000
Message-ID: <5e97d5b5-3df4-c9b5-bca4-c82c75d353e8@amd.com>
Date:   Mon, 5 Dec 2022 15:55:32 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [patch net-next 1/8] devlink: call
 devlink_port_register/unregister() on registered instance
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
References: <20221205152257.454610-1-jiri@resnulli.us>
 <20221205152257.454610-2-jiri@resnulli.us>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221205152257.454610-2-jiri@resnulli.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0050.namprd02.prod.outlook.com
 (2603:10b6:a03:54::27) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|MN0PR12MB6078:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c0e45e1-a9d8-4257-e320-08dad71c3447
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 77+olzdrOA5O/fx9wUmZ8Y7bdCRjeAkmTQZHNuAtcnlbgHwtNxz46CdsTSqNoNvjcGmILr9aPmVzIEw84CWegF7HOXmJSvS7TtJOWG7Aaj7qqd3nNre+Wm2k1Bw47HrFMsza/0UY2F/HavoOwJUvFW9BwVkAjw8wQJD4JxLzH1gyKhye2R3i6ph23DfNHrondoQP14PvmkXPA4+bF0ZgJKpDLDVp3q265GwU7izJRsjHFTYnaJpFC3omFGeEMrWColaq7z17bc6lLmabo4f7X5+O1xaz1xsx07MqM6anF3p4/6A/kTfPJBElduYiPhtZlWoaYWZTy2geAur517A+45BmmFEP7ZkLnpwfxxstAY4L1ngyIPFHlgex0l3ANpemjAdDS2jazBwTOiI4BQvPm8F1tdnPvRn9ZZEU9bklc+2dPl2VUB0UQtwUuSnmn3uOQKYpvdsGCWHf2+rRVy8n2TGYG5VRMzM1Co6Wp/QXDVoK4stdE4Sy/VIAK0Gar/LEU5GRhPSwAtDJ0jSsZREmh4uv3JSmTTVK5WRFknXjG5+Fid1v1MqnrWfumRSgo2poeigvwHuOTNkbAdjUdrP60ooWfUHVT4+u9HS0cB5ldf01dx1iXG20RokVvZoWAdSEUcucT4cGneajKY12Yyt5lm/BMAf01sW9ed/vM4WA6p/2WPERMQUoZOef9dyMo7BMPM8oDU8uP4FZoD45OrHS/DJWfpUzrIF6mPS4LS1hCmaz41vghD2dAHfNRv09T89i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199015)(38100700002)(7416002)(5660300002)(8936002)(8676002)(4326008)(41300700001)(31686004)(26005)(31696002)(6506007)(53546011)(316002)(36756003)(2906002)(66476007)(6486002)(83380400001)(66946007)(966005)(66556008)(6512007)(6666004)(478600001)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bS9hdzY4bmlzM0dRK1o1YlIvRElOM1J2bmlIakVHSWpQWHY0d3NoRW1CcGpv?=
 =?utf-8?B?OThra2tmbGQvVllZM0lxNWViU3RBdTZCbmpYZEo4ZTg1a3VLTkdHcWJYd01z?=
 =?utf-8?B?NzRIMnkrUjA5cUtVZHRvN0RWMUhPVkJ5Mk9SL1V5T0g4Vnc3Q3k1ejZ0amdR?=
 =?utf-8?B?WmJ0V3hraVJBdjB0Tkg5alo0TXFQVk5ydU9zWFNlK3k5clk3bEhRK2hKdkx5?=
 =?utf-8?B?R0VscmNZaU05eHZiSnpvTU1LK2l4TlUwNnhINEw0alMyckNpa2s2ck9QR2ly?=
 =?utf-8?B?Z2ZraWlFQTkvekdnalpiWTNPdUM3dk93VG1ZYTRPbEp6d2p2TGZUbmdhZ2Fl?=
 =?utf-8?B?UVFGMGxvR0VtbHIyNjlML3dGc29nWkZCTWtCNUFuR2l0NEp0WVd5NStETmFs?=
 =?utf-8?B?Qnl0QjVETnQxdjE2YVNOZEJvTE1oTmt0cTFLNzhrVmxNK2wvZkhFS2RHTXY0?=
 =?utf-8?B?UDRBbzZIQjJkT1FRQWhlSXRXeGtkYXNac053YW1TcU1JSTVjVUxQWThUYkp5?=
 =?utf-8?B?Y0ZQYm85b1VkR3lDQlduZXcvRVVyYkExZEtYQ29qaC9pVGgvRHliTVlzcFVF?=
 =?utf-8?B?ajY1R2dwTUtJcXNUd3pDbll2d292RTBzVDJmdFBra0oydjBXbUxsaGJLSGtm?=
 =?utf-8?B?TDhMaGEyRmJMK3dXNUVqUjhTQktIVjNUMmxDQkJPMHV0SWtaemd0K004bDVC?=
 =?utf-8?B?OE9rdnBCeWlWUjBkYTNoRlU0NFY4M0c5b1RTVWJ4VlUzTmdLVFlENW1WNm9B?=
 =?utf-8?B?a1NRQ2NCR01pdmJ3NG9rcmdheWZmNU5CaC9NdmptR1VwU04yM3J5V0ltU3pZ?=
 =?utf-8?B?QUxyYnZYdEIvMkphbmVCd3BtUmFidnlEa0ZlNFFHWk9sdEdwL3JBR3QxakNJ?=
 =?utf-8?B?bXhlTnZ3SGVhT0lyWll0Z1M4eHV0WDNMcTVmODNUbkhZSkhGbEYyRDZJLytK?=
 =?utf-8?B?N3J5bk0vWHllZUw5ZTdtK3Rjcm50dXR2cSt6QTBJL0d4aWFkL2t0ZWdtQlkv?=
 =?utf-8?B?bHNDSE5iSnlhTG9UeTRXT2ZXc212YnFzQzVEbnpqQ0hxcE91RmZYZ084OWRV?=
 =?utf-8?B?dDR3dHIwRmVvWkxKdlpBK0NkcTJjcnJoVVFEMjdzR0lzZzVGTXJ6akVWYTRp?=
 =?utf-8?B?bjhqdituNjZKMTVtRDhHVCtuazArYy9tYitURGY2UDN2TjV1YnFPQUZMRnBk?=
 =?utf-8?B?SWxFUGpXSzBzeHJ4aGMraFQ4YkdEMVhLbmNzVXlySFB3cXg4cFE2VG9MQ05R?=
 =?utf-8?B?ekZvSVFJZ1dydUZMNjc3ZHBoZkdwM3R3SW1GY0syR0s1U08rRmx3a2NKQkd0?=
 =?utf-8?B?Q0Z4VytnSmptaTNQMWFwRXR1OWQvSU43R2xJY0VqNFZnQUxueG4rYU5HdHNx?=
 =?utf-8?B?YWh3ZVNnWC9pL2xaY3lTTmVxM0V2TU9VM1JYNkVuTkpsV0g2K21nYVo0MFpk?=
 =?utf-8?B?WE83azg4NTRFdzJKMU53VHhkemVxU29aWWdKa0lmaVRIV3IzREtVbUFseU9J?=
 =?utf-8?B?RDlKMGtaK3hiNEFweEJnLzRjWnI2ODB2VTBYV0xKQTZoNlRuN2F4azVvK0Jz?=
 =?utf-8?B?Z3JXTTcvbGoxWm1IdXowbVpPOWUwM1k1eDI5VTY3a05hNmR1akkyS3VlUFpp?=
 =?utf-8?B?N2lCUVlidTUzYlYxL21qNlRBeWRuOExYcmthOENTYU56UU9meTcxSW1kWDc5?=
 =?utf-8?B?UFlmdjI3Y3hVYzMyK0NxSTBGbSttY1lLSlQ1a2xJNE04bjdneE5iQ1gzbFZp?=
 =?utf-8?B?T1dFdElRNUtjYm85UlZZa3hWUjY1K1FFNVRDcmJrZDVUQVVZaXZqL1F5RElP?=
 =?utf-8?B?NjJuL3VMOXEwYm9JVTlLemU4ajdBNjR1dzFza0xIRVBqaTN4QlRRdnczYTN0?=
 =?utf-8?B?dnp2cmpUWVpuK0ljY09UZkJPODV6Wkc5bDVrYlNEcjNEOWRvR1NzS3lEeXpr?=
 =?utf-8?B?TWxBK0p2dFAzaWU5OGJpMnZKQnFMbEV6ejd1ek84em9vYkx0elR4aUp2bS9I?=
 =?utf-8?B?NlFXYjNSTDJVUy9NMXYzdjJPZjBiYmZmYUliUU9ySFJrblJhNlFFYnFnT1k2?=
 =?utf-8?B?RTM4WW84NXpuQVprTU1Lb2dxQU1ZM0ZZWnEyTzZzWXJYYVdha1BGdHM2anpl?=
 =?utf-8?Q?hdvFHy1zO0eRmWrNR8ITqVFAq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0e45e1-a9d8-4257-e320-08dad71c3447
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 23:55:36.4091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oN41sSEHjgPMnRxpsPDjDn8pslHifJV5V6mOVLLdfP3myF817Ho0eQMQslh/X3cnQxnV/9qttDiXWXdJBs9Azw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6078
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/22 7:22 AM, Jiri Pirko wrote:
> 
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Change the drivers that use devlink_port_register/unregister() to call
> these functions only in case devlink is registered.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
> RFC->v1:
> - shortened patch subject
> ---
>   .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 29 ++++++++++---------
>   .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  7 +++--
>   .../ethernet/fungible/funeth/funeth_main.c    | 17 +++++++----
>   drivers/net/ethernet/intel/ice/ice_main.c     | 21 ++++++++------
>   .../ethernet/marvell/prestera/prestera_main.c |  6 ++--
>   drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 10 +++----
>   .../ethernet/pensando/ionic/ionic_devlink.c   |  6 ++--
>   drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  7 +++--
>   8 files changed, 60 insertions(+), 43 deletions(-)
> 



> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> index e6ff757895ab..06670343f90b 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> @@ -78,16 +78,18 @@ int ionic_devlink_register(struct ionic *ionic)
>          struct devlink_port_attrs attrs = {};
>          int err;
> 
> +       devlink_register(dl);
> +
>          attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
>          devlink_port_attrs_set(&ionic->dl_port, &attrs);
>          err = devlink_port_register(dl, &ionic->dl_port, 0);
>          if (err) {
>                  dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
> +               devlink_unregister(dl);
>                  return err;
>          }
> 
>          SET_NETDEV_DEVLINK_PORT(ionic->lif->netdev, &ionic->dl_port);
> -       devlink_register(dl);
>          return 0;
>   }
> 
> @@ -95,6 +97,6 @@ void ionic_devlink_unregister(struct ionic *ionic)
>   {
>          struct devlink *dl = priv_to_devlink(ionic);
> 
> -       devlink_unregister(dl);
>          devlink_port_unregister(&ionic->dl_port);
> +       devlink_unregister(dl);
>   }

I don't know about the rest of the drivers, but this seems to be the 
exact opposite of what Leon did in this patch over a year ago:
https://lore.kernel.org/netdev/cover.1632565508.git.leonro@nvidia.com/

I haven't kept up on all the discussion about this, but is there no 
longer a worry about registering the devlink object before all the 
related configuration bits are in place?

Does this open any potential issues with userland programs seeing the 
devlink device and trying to access port before they get registered?

sln


