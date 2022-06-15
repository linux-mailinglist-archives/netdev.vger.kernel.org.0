Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484E954CAD7
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 16:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356015AbiFOOF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 10:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355950AbiFOOFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 10:05:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250E6DF62
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 07:05:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6ROUUcCFJ84hHe8+zoI+cwErNhvhWw0nDkRLkTPJYtE6ttmBcxhjWM+lmnZ0vmAOfVxffjuU/0qClS5PBK/l9d4ImQJXaMd4ynh99uMo/ExnQXuRSeIpim/I1GQjk07GTq4gcSlEK0r4sZM4FVwPaoEALAORBst5hwja1HBGdzopbtmDiZjOR/ZxUtXF265/xlsyk/qCGvd7Y5v/KWn41kYnbUmyem2FHm6fowU5oN/FoOzAl62agk8VGOauJ2jSOVlPvs2e/8hHD5MhlLK/88MmR7lImUAOlNArSb4NzKSUPboAl30r5SUEtaIxS721i3jZuSrh+zFnESfUX82Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xg5vnwENVDyVjotVW0ZnRrFmTTs2j5Xa2QyAhzFCeA4=;
 b=WwXtKtAcyjx+gvmZWkqYUNblP5zvdMSzv4sMmBMPqfTU0DMpSpNdKYE0ePPyH5vfJpGKrJAQOgufsDTQdMN8KI9h2Ak6lWtoosWkoAn6r0ynu/G5AwqYuSKOSnf5UkNdfpg5JlYrCOca4J9IMrvcm+R00ehQYYLCfhzQFFpiWVtvmFjyTOXadsOkNFQVpFfAnSPOqcT6fnCo+iGmXQVsYvp3uWTJC+dTtr1OhK+HDYB3CTMYLH4JuYSjffimwN44cprpx9MQ4miSKdapN1d1rMjhdjjomc0KaQUhBfBETMcWWTJRtVV9VnZhjiNiOhgqx3jd8FeoP4gj9Nvf0IqMVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xg5vnwENVDyVjotVW0ZnRrFmTTs2j5Xa2QyAhzFCeA4=;
 b=GjawBO5mElBX61WockvbZTi+4rCJ6U1MGgw3n2w7JOGV3A5eyAcv9IdDvgttPym3PHVa1/7qtRlF63xnHjtWmk93Qead5IERhAoyt8dY2pZdbnYJrlOnJOOeRjVnxHvZ9Kn1NUnmkqca+IvBF+XjeaEuBjJdKD9q9ArlNGF+/a/hWKm4tFXnpqk2ibfA2jA6kPX9+BmHDeZgTc7WHYFTSMlmcbCF1zXzItJz01pP+zHRxfz9STKBAzSe7e6xRm1Zn/M/Uiffj+fxggRT0vv2u72b+g4SWGY0eYOfOXBz+huzHu7tKdcaqgxnu+OoTQkkUodGg2nS0aCCRlg32TNLcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MWHPR12MB1342.namprd12.prod.outlook.com (2603:10b6:300:e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.17; Wed, 15 Jun
 2022 14:05:19 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Wed, 15 Jun 2022
 14:05:19 +0000
Date:   Wed, 15 Jun 2022 17:05:13 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 01/11] devlink: introduce nested devlink entity
 for line card
Message-ID: <YqnnGR7mbB8RCDnH@shredder>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <20220614123326.69745-2-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614123326.69745-2-jiri@resnulli.us>
X-ClientProxiedBy: VI1P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b988997c-6a0d-4bdb-9080-08da4ed814a7
X-MS-TrafficTypeDiagnostic: MWHPR12MB1342:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1342C4336401A36275E174D8B2AD9@MWHPR12MB1342.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mEtXpi+BtoRFiEI4zCO6PgsVcRNeRbUAcKJuxL3L/g0JosQud87pECh/tGCKfRqp2PUgvlizTGc1KtQDaKIsXGa/Q+6gBBbbCEZADURbIZujJUOgnwoeKIdBQwwFhtVvAhTDwDV2XXZ+efhVnX/hMOBHOni4M9qPrwP26CQnI3G0ervPeFf6B/MnrRdYRw7BvTagrIvduXbubJehUONoLtiNB9iVvVZxYjquPs5K1dKTLHhB9dqbps9poeGzejZTjR45kDVeYcpuC3Nfm8InaKr3mtnauJrEjRnzl3aBEFK13quxjUso7qI242bmFlFXiZ6PmK6JtLGPiV962ms93IE7eHEBhtc9Gtw7QPahkuUXKwNyZA5hzkZhBX0Skh7QMS35uLYWXoexpTWikHzxk/Xp+RjuBP4tGOK9Kjw4BXLEkldEPPVm4n4+iLdTFcCG0DiyfjL6MjNTnbQBR43p3bJwUAlg5588Ln+Y8Ug4tgAy6+DQooy37H+u+MAEWJd5mzxHlfpsaEARsIChA6ArtBWpV0de3VUYknbIHe7UKom9+ErpV83Cw1flAGKUtae13q5slB9SMtE1fxUjRWNQHaiG+9iqlOaxuaGcaq2fYxgUFp0aH4Z1aLoB9D6dFH+JsC3hbThOnqOLrl3mudpGhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(107886003)(186003)(66556008)(38100700002)(66476007)(8936002)(66946007)(5660300002)(33716001)(83380400001)(8676002)(4326008)(2906002)(316002)(26005)(9686003)(508600001)(6512007)(6916009)(6486002)(6666004)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MRZEFsbbJxfbUGZ1PQU8UJBlREDoTGheSmLYU5x65YINBFpkhMTXt0E8xHNH?=
 =?us-ascii?Q?Z2gcmd2O8Y2jxOHutQp0mvpG58NXfav+apdp8dhEf56zs7X6Eo3ZwnJddrjr?=
 =?us-ascii?Q?UVxSM6Sv0theUUcX2QidQJ+feL0jegr1t+M8V9Q+Yh4fq8RmHna4fVIOmN+i?=
 =?us-ascii?Q?dujv0UbXBcUfBn1LK4zt5f4MS9b8yvzNv2mRTQ/MOyCy0QusFNN0NRAxgs7X?=
 =?us-ascii?Q?TGZ4RLoRp8mCZNeW22xgtSo5r5vmMC45duDMCq/SRuZTD6BX1mf8n1z/vqmm?=
 =?us-ascii?Q?Jw7IbIXhqWCaCX/Rm0+qh5IxKM9K9HnQ/cJ8WL0uCm6wV8MU5/KeVshVLh6b?=
 =?us-ascii?Q?qSGo1moAiQBgNSlvw/w+LZBHfNFfhX5AH3Vvimiqnyf3miqUNpOFIOXY/qN4?=
 =?us-ascii?Q?BmRp3qz07KUltk524pUDaU2R+qBxtjPZf1/n9jFVjsAF8Pad5b/GF5/WCurh?=
 =?us-ascii?Q?wldm3/AD1eAP0BCtZlpSXRePbZGs3hl/oGX3g4u2BFdcSlt4aDisfdAFB0Or?=
 =?us-ascii?Q?N5xR5w6DjXMs4Jjd3C7CF95u+9EqlLnaJISWXw/EMmuBp0PbZ65jdsdIOLo9?=
 =?us-ascii?Q?NT/7C7tYghBNe1w5Wqu1YvOVVQVafpGyZvHxHgRfLrSApgxTiJjML6StMCOZ?=
 =?us-ascii?Q?NzG7PsbrBDTrxSTRtqqF9MDvMGFPYNEfGKdyBxYRYPteiaaVKBjWFnxQ+W/H?=
 =?us-ascii?Q?+RfV9H932rQY7MrPIzygGFCpmjSWCU3mrAEDF4KRleS6lvdAU9Bj2wErr/nb?=
 =?us-ascii?Q?zx6UrDzY6TJybvdA704KOqeDrtFmMVWzIaztbwoX9ycTsgd38+Up3TBNhOMR?=
 =?us-ascii?Q?CY7sE5Hk0eCyL8VEyma/gjnDEopFXQ/QgFqIdxa0pYVRdQbGCG2cAWeYZI/X?=
 =?us-ascii?Q?Y9s0sBaJKQ5c6KEPpPZAg7rej/RrcYb4w98C78DEMn7UDe4NqVlkTskHUx2m?=
 =?us-ascii?Q?JpFgAohoz0uDIgtmpaZMBJFTdiQgUZGVTZ5MaypEYQeSEsGAbp0wEo3FpgTE?=
 =?us-ascii?Q?bemCsYUaW2goO31x+LWS2lO6hk6UmKXUhKIjI4C5c2ZPUEAiXXtVF1soCLv3?=
 =?us-ascii?Q?b1rD4RopuNJl09jEbr2EGnQxarVf/nk/GtzclLEdiaF5T+9zL10Cr/oMIZMy?=
 =?us-ascii?Q?AxTziY2aeT/8pEm/YsezhPlF9uO0JQgNzu/OKsPRTwf4TM2jWKEj8q8QXppy?=
 =?us-ascii?Q?HIAnRNtwIkLrUWOOBozQdQx1rRYwBP5lVsLKgBRdfJlh0W52X0mto/vo0RYS?=
 =?us-ascii?Q?b2pDeLcdXOB54tvqQSGYCiTU8Iz80G0Iug9HEvMeoqAB/qx1eTW06JSsLvFV?=
 =?us-ascii?Q?eY6om9kHKPx3R/53N/9XLnhTZf88RLhk/2XBmi6AXc97BUs0vk39PTMTt8PA?=
 =?us-ascii?Q?5DB9jBrg2oX9nFNqDn8CRzDg1/yCDrrtWhavCTmXepOADFKlTFGAWCoOjFYt?=
 =?us-ascii?Q?Z4MXLqr0swopDYLbfUy1MnirjLICGaMjNT+T8csQCHQg3dxROsCnXWtQvv8X?=
 =?us-ascii?Q?SistcPfBui2CHZFmfzXfzdzKJL7hBC8neD+7o9Z6CrnovgCX3gwape8zcCEX?=
 =?us-ascii?Q?LrUKG9IZiMisriAjNbDwxnfMlhuos9O7V/VT3AU7bGs1O5E81Ylg3jMplCN4?=
 =?us-ascii?Q?r2k3pTmUNinsA2pW9NtaJxGlG2IyqKTfwlvBGAP/FKTOLXNaAJOQJGNt6Vyx?=
 =?us-ascii?Q?kRTV9pTh7tzOVvgpSubj5uttHPzdF1xlTcuiKSyRIHaDRvDfqVVBVBvFTcIr?=
 =?us-ascii?Q?w8XzjWUb6w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b988997c-6a0d-4bdb-9080-08da4ed814a7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 14:05:19.4180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z0MlKH/VlnhMa3ZgLeg99KtszhiaAmrEVhFh2EkM6oeCQyW76YLBkl/AOPAkHVPnBKWW3CUx6Cn17MS58PhSEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1342
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 02:33:16PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> For the purpose of exposing device info and allow flash updated which is

s/updated/update/

> going to be implemented in follow-up patches, introduce a possibility
> for a line card to expose relation to nested devlink entity. The nested
> devlink entity represents the line card.
> 
> Example:
> 
> $ devlink lc show pci/0000:01:00.0 lc 1
> pci/0000:01:00.0:
>   lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
>     supported_types:
>        16x100G
> $ devlink dev show auxiliary/mlxsw_core.lc.0
> auxiliary/mlxsw_core.lc.0
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  include/net/devlink.h        |  2 ++
>  include/uapi/linux/devlink.h |  2 ++
>  net/core/devlink.c           | 42 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 46 insertions(+)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 2a2a2a0c93f7..83e62943e1d4 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1584,6 +1584,8 @@ void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
>  void devlink_linecard_provision_fail(struct devlink_linecard *linecard);
>  void devlink_linecard_activate(struct devlink_linecard *linecard);
>  void devlink_linecard_deactivate(struct devlink_linecard *linecard);
> +void devlink_linecard_nested_dl_set(struct devlink_linecard *linecard,
> +				    struct devlink *nested_devlink);
>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>  			u32 size, u16 ingress_pools_count,
>  			u16 egress_pools_count, u16 ingress_tc_count,
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index b3d40a5d72ff..541321695f52 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -576,6 +576,8 @@ enum devlink_attr {
>  	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
>  	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
>  
> +	DEVLINK_ATTR_NESTED_DEVLINK,		/* nested */
> +
>  	/* add new attributes above here, update the policy in devlink.c */
>  
>  	__DEVLINK_ATTR_MAX,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index db61f3a341cb..a5953cfe1baa 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -87,6 +87,7 @@ struct devlink_linecard {
>  	const char *type;
>  	struct devlink_linecard_type *types;
>  	unsigned int types_count;
> +	struct devlink *nested_devlink;
>  };
>  
>  /**
> @@ -796,6 +797,24 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
>  	return 0;
>  }
>  
> +static int devlink_nl_put_nested_handle(struct sk_buff *msg, struct devlink *devlink)
> +{
> +	struct nlattr *nested_attr;
> +
> +	nested_attr = nla_nest_start(msg, DEVLINK_ATTR_NESTED_DEVLINK);
> +	if (!nested_attr)
> +		return -EMSGSIZE;
> +	if (devlink_nl_put_handle(msg, devlink))
> +		goto nla_put_failure;
> +
> +	nla_nest_end(msg, nested_attr);
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(msg, nested_attr);
> +	return -EMSGSIZE;
> +}
> +
>  struct devlink_reload_combination {
>  	enum devlink_reload_action action;
>  	enum devlink_reload_limit limit;
> @@ -2100,6 +2119,10 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
>  		nla_nest_end(msg, attr);
>  	}
>  
> +	if (linecard->nested_devlink &&
> +	    devlink_nl_put_nested_handle(msg, linecard->nested_devlink))
> +		goto nla_put_failure;
> +
>  	genlmsg_end(msg, hdr);
>  	return 0;
>  
> @@ -10335,6 +10358,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
>  void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
>  {
>  	mutex_lock(&linecard->state_lock);
> +	WARN_ON(linecard->nested_devlink);
>  	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
>  	linecard->type = NULL;
>  	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
> @@ -10353,6 +10377,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_clear);
>  void devlink_linecard_provision_fail(struct devlink_linecard *linecard)
>  {
>  	mutex_lock(&linecard->state_lock);
> +	WARN_ON(linecard->nested_devlink);
>  	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING_FAILED;
>  	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>  	mutex_unlock(&linecard->state_lock);
> @@ -10400,6 +10425,23 @@ void devlink_linecard_deactivate(struct devlink_linecard *linecard)
>  }
>  EXPORT_SYMBOL_GPL(devlink_linecard_deactivate);
>  
> +/**
> + *	devlink_linecard_nested_dl_set - Attach/detach nested delink

s/delink/devlink/

> + *					 instance to linecard.
> + *
> + *	@linecard: devlink linecard
> + *      @nested_devlink: devlink instance to attach or NULL to detach

The alignment looks off

> + */
> +void devlink_linecard_nested_dl_set(struct devlink_linecard *linecard,
> +				    struct devlink *nested_devlink)
> +{
> +	mutex_lock(&linecard->state_lock);
> +	linecard->nested_devlink = nested_devlink;
> +	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
> +	mutex_unlock(&linecard->state_lock);
> +}
> +EXPORT_SYMBOL_GPL(devlink_linecard_nested_dl_set);
> +
>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>  			u32 size, u16 ingress_pools_count,
>  			u16 egress_pools_count, u16 ingress_tc_count,
> -- 
> 2.35.3
> 
