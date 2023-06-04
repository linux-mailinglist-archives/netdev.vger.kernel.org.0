Return-Path: <netdev+bounces-7796-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C629A7218B0
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 18:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2176B1C20A15
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 16:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45D87495;
	Sun,  4 Jun 2023 16:37:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E7A23A5
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 16:37:40 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2091.outbound.protection.outlook.com [40.107.220.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73B6BC
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 09:37:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ft0hclQO7IuHYpiZGE051PP38c326QbwSMYZc1zlSZZEYHlrNmrfGlKBCOkrMUF7hAjAbqx1hrF/wNlsLxO2ft0pgtkp8zAxWFB+DV4HciNkbpZi1pI/LK+ILrBxXyEjibHa4pVG6iRbzOHVX99n+ipPIYO1pdtrM/zk04v3RUByelF6fPCVkAnAZwpGB9zvzYlNETiWlTfH3ODtByuY/wkkus+m4+hr+8i4g9TDY+QjC7j0FpfHW1uMndVT65M3nAi47tMT9AjYJRsVIXYuL4foOTsiGO3oINvdYmjRerwg5F/23RjdPOQXfylW8ks2E8Pbt5kdG7AhRTPrbCyRFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xQEa/92F5erTQumq6zWCeEXDVE9BGmKT+zQUnaIYwI=;
 b=SRVbTK9wJwGAbWPEoMOcCmF9jJbqDxFIGj4DVvo9TP9Z08rKQQE56yMuyozMkXNiMAgmGwxf8xikf26igxxgarlpH+TVYJPzSSxsCj0mLsYzTlSJUGiC0x3FU2kSh7BHYLAvfaP0YQ0KIMP/QnTbOs4PQX2cgIdCTb6jLTiVaIQ/PWar3ctSfSHuzYZTT3tn/x8XSyihTdCOdAmtTVoNkLuOtr1VyqWbBKTzqrQPfzEptLFeI1fcUBs0P3Y3qzCaDAtHbbNwsIi460DRQx+XIGMBd0VdGv2fLdup93O82kcqCcQN7guzFSfECHP7xAbMkx8K98EWjvibsxfsibMRkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xQEa/92F5erTQumq6zWCeEXDVE9BGmKT+zQUnaIYwI=;
 b=H4H6OKYX96jAuR64svUFEKL5ol5vX9txBBsGx4QwSiz3Ldw7YyLwAa7UVf6nhONpo+KS6K2fvMVgjRflgsA03QMIN9P+t0Pk8rsrXpaKL4gMCjgJZQQ4XF4vXsyIvt6SMXlyJiwnVRd5BsAURCR3CELpZ4XFcU27GzfnO3DPEqI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4693.namprd13.prod.outlook.com (2603:10b6:408:12e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Sun, 4 Jun
 2023 16:37:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 16:37:35 +0000
Date: Sun, 4 Jun 2023 18:37:28 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wojciech Drewek <wojciech.drewek@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	alexandr.lobakin@intel.com, david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com, sridhar.samudrala@intel.com,
	pmenzel@molgen.mpg.de, dan.carpenter@linaro.org
Subject: Re: [PATCH iwl-next v4 10/13] ice: Add VLAN FDB support in switchdev
 mode
Message-ID: <ZHy9yNtc5GMr6UbR@corigine.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-11-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524122121.15012-11-wojciech.drewek@intel.com>
X-ClientProxiedBy: AM4PR07CA0016.eurprd07.prod.outlook.com
 (2603:10a6:205:1::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4693:EE_
X-MS-Office365-Filtering-Correlation-Id: 285d1a4e-bd72-4cdc-a1fd-08db651a003c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lyox0P7xYoScEd3cIB6GWxXUUN08HOoi3r5O4w85Am4515R9YmxmAdi1udiDg8RfLLs+pGPX2hXRMS73pt5Npnup5u9uq/DCLFpC0uzvqL1m2hucgKtzXnGYqE9VwxNl/77Zxyp/sOJPaey92v5zuoJZCmHKf8kKrJV/jPr9h8k37o4KFsH2VrTZ4DQklSjyn6m/E7AlWOssQ9tK9cs2AKMR9SC6FBbRX2bAVuqh0t36rGlBFvYHOZk3zGWTW1e8J4gAYVw8Q0EYIdJGWjc9e0qhYUUoyWHYjmFk6gWglx83k2+ClDLFn80bIw84AOLpBsvBe2x5qw+LfbRAdIKGV6yhTdqawUhhqWWxUR56g7aF6g9NDdBLxTuiY4gdttp2/0qEV5edbJ3iYlz4ycxy8uXxiDux0GbqmRDalkEkaxx2uvNsXK0TBlvtOz7m2z1fwxUPFFCpYRcMN8G/hcErdqCR5IQUfgl2BXoFmGIQnpcp2E1qIuRDhbQA4rDzb+kJzjFvK1j9XCCgyLyArLgTGn4JZuQVnX7ND6dZ+V3xi7FFcBUnmXUj76fI/FFtoaga
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(366004)(39830400003)(451199021)(478600001)(2616005)(186003)(6486002)(6506007)(6512007)(6666004)(86362001)(36756003)(2906002)(83380400001)(38100700002)(66946007)(5660300002)(8936002)(8676002)(66476007)(66556008)(4326008)(6916009)(316002)(44832011)(41300700001)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lvacYVJyBz1K1u/D+G0BjJSn02dSjHWOsCiHt6Ed9nrcNhTQL0FZtfhsxePJ?=
 =?us-ascii?Q?mtYe+uhtFjWJEGB5gYen0URDdpniJweuUGwtWyjwl28IyDOn0u2joX55F4Pu?=
 =?us-ascii?Q?grKcz0Svjd7cROicsjyZEygtz5lnod09qxfejvE3e/0aCMDc0SCqFZPC3jq6?=
 =?us-ascii?Q?NfnJdE8kIbY11RHWvo8h75ckNkv8S1re5VaSCW9kMN87byDJodvAy6StmOPX?=
 =?us-ascii?Q?o3Ux7Ry2LEwDxHaseCQrnDZhueVqRbKGIUKsUiy+jBGOfPWVbwNjvBYezWGV?=
 =?us-ascii?Q?b5QEAJu4TqDXrFYO4T9d89rhiJ2+C/H38sOqeStz3ZTsrouH4nJrzCnZu1jL?=
 =?us-ascii?Q?ne/DgUvdi/7DyBJK9N82FHFKR7PBBYhPZZJZpP3WhwiHjT3KEXJlYqsu47Zb?=
 =?us-ascii?Q?mSWPZXYTqCJk6SbcyVzQETCLnstKXpn+vdA5iUHq/cBzHKOaG3bq5mIo9xIZ?=
 =?us-ascii?Q?tJXDRzxL/Sc16EJX1xy/fdYtBKkXZ7d/m63VqphCjcOQKdcoZ9tDeAOE7rqK?=
 =?us-ascii?Q?IWdB2urtJRC5hbZQCRynhweGaynyoErF19IicNvjjsSoYQHAEAAEvQpVLLJa?=
 =?us-ascii?Q?2bFAmpMZOjbk7st87WzcU9C8PS59kjTqSzxUbC+3JnP2IBlKJk27OXAEU3pl?=
 =?us-ascii?Q?qMEddysKP5dvlrW3lMuw30UbJxIgAmw0dpxmtHXOMytQtoTSF7jN1I380tmR?=
 =?us-ascii?Q?0rbRRpdyQGWx+0hWQH2JrmiBWCyDyzDnzhboOjaxcgJbz6zaLHnWKNnvQM4X?=
 =?us-ascii?Q?hXbUHn3xGnePT7VpXrMhbPGS/9fAVbOO0Pk1zK+0NC04BAO68ywJbHjGk/hA?=
 =?us-ascii?Q?q+/tGIsqZOC08ey8Gvn7AoZJ2YQOSkwpx8v2LSeUcjE17VwYS6IukwX2DcEo?=
 =?us-ascii?Q?qtcKBK512kqzbysbzL2SPTZ1HBJs88pvV7mS+/PKq+Vd0vGUJmVW3DGmezpR?=
 =?us-ascii?Q?lUVcm9uW6wxUGSNiNfE09Y3ofdbn5sq38qiZErlsYX5C8Pl0HszdfK8vvqDQ?=
 =?us-ascii?Q?RLfBn3ai1iaMuXaxmCSEi+VDo8J6HHrJGc4f/KLDu/fnQsIc4qx5ywwagWeq?=
 =?us-ascii?Q?EWguaUX2nJQj8izXADcf/sJv6zJ0HZRnhJzs6+JMo1XZTm3i21eNxJmKCdhk?=
 =?us-ascii?Q?Vp3kxZ+PI+ZYOygNmfp5h75yf24GR3qMUJWCSCB/8/Kqwt3BxSv9/sG85N6H?=
 =?us-ascii?Q?GdEnfGh6uaGiVW1p8Tt7cwP24JreGVRwePRrIQkX+qTJc2bVP5jKkrriC6ZK?=
 =?us-ascii?Q?crbC2ZQu+hAMCoAyCQCP4aoWjv8wCq35F99yJINO06ghjgivEMQM+XLxLaEr?=
 =?us-ascii?Q?/0kSTTJ2mtCMxdvcVb4Cnj7KGj02dRbI/zA82nuGHPz8IigFu/ZN5CbG/eI4?=
 =?us-ascii?Q?V72CyuDR1fQ0EZCCceGkZtHcUCU47LRxwXod/CW/eGncleGivOZVgF5JuU0f?=
 =?us-ascii?Q?RLMdTg1mSSH/LsFYWGsRtNq553ohHXT4IAif2coxOvpLYuPT57MALuYJAnpl?=
 =?us-ascii?Q?L1RNLbj8MFr+6x6U13VXqQANwO1RyVyJz5IxkFJrtgtlT33gNgSUpFZUiuM4?=
 =?us-ascii?Q?Pe0OKJEcbNjtBdvwNSk8McdJZ7Yq3pCHbNK7q0FEX1nDiGQRgbotzP9zHmD8?=
 =?us-ascii?Q?O3vaCC0t5gjfWjGBWTkgN5h2vqKwdl7vvZg281byA2zSJCwfbs+UrN/UrrjB?=
 =?us-ascii?Q?qbVpwg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285d1a4e-bd72-4cdc-a1fd-08db651a003c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 16:37:35.1803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Jt4nYXRzBI29NgS/kvEztAZRHNpW6tMgTQpim+6/nmagavNEaa/i569E1toETG76f1KkTtDGnpnWmrNzXXbmrmXRwzl+4kJM17kTiA7v4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4693
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:21:18PM +0200, Wojciech Drewek wrote:
> From: Marcin Szycik <marcin.szycik@intel.com>
> 
> Add support for matching on VLAN tag in bridge offloads.
> Currently only trunk mode is supported.
> 
> To enable VLAN filtering (existing FDB entries will be deleted):
> ip link set $BR type bridge vlan_filtering 1
> 
> To add VLANs to bridge in trunk mode:
> bridge vlan add dev $PF1 vid 110-111
> bridge vlan add dev $VF1_PR vid 110-111
> 
> Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>

Hi Wojciech,

some minor feedback on this one from my side.

...

> diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
> index 19481decffe4..820b3296da60 100644
> --- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
> +++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
> @@ -64,13 +64,19 @@ ice_eswitch_br_netdev_to_port(struct net_device *dev)
>  static void
>  ice_eswitch_br_ingress_rule_setup(struct ice_adv_lkup_elem *list,
>  				  struct ice_adv_rule_info *rule_info,
> -				  const unsigned char *mac,
> +				  const unsigned char *mac, u16 vid,
>  				  u8 pf_id, u16 vf_vsi_idx)
>  {
>  	list[0].type = ICE_MAC_OFOS;
>  	ether_addr_copy(list[0].h_u.eth_hdr.dst_addr, mac);
>  	eth_broadcast_addr(list[0].m_u.eth_hdr.dst_addr);
>  
> +	if (ice_eswitch_is_vid_valid(vid)) {
> +		list[1].type = ICE_VLAN_OFOS;
> +		list[1].h_u.vlan_hdr.vlan = cpu_to_be16(vid & VLAN_VID_MASK);
> +		list[1].m_u.vlan_hdr.vlan = cpu_to_be16(0xFFFF);
> +	}

nit: the above code seems to be (largely) duplicated in (at least)
     ice_eswitch_br_egress_rule_setup(). Perhaps a helper function
     would be appropriate.

> +
>  	rule_info->sw_act.vsi_handle = vf_vsi_idx;
>  	rule_info->sw_act.flag |= ICE_FLTR_RX;
>  	rule_info->sw_act.src = pf_id;
> @@ -80,13 +86,19 @@ ice_eswitch_br_ingress_rule_setup(struct ice_adv_lkup_elem *list,
>  static void
>  ice_eswitch_br_egress_rule_setup(struct ice_adv_lkup_elem *list,
>  				 struct ice_adv_rule_info *rule_info,
> -				 const unsigned char *mac,
> +				 const unsigned char *mac, u16 vid,
>  				 u16 pf_vsi_idx)
>  {
>  	list[0].type = ICE_MAC_OFOS;
>  	ether_addr_copy(list[0].h_u.eth_hdr.dst_addr, mac);
>  	eth_broadcast_addr(list[0].m_u.eth_hdr.dst_addr);
>  
> +	if (ice_eswitch_is_vid_valid(vid)) {
> +		list[1].type = ICE_VLAN_OFOS;
> +		list[1].h_u.vlan_hdr.vlan = cpu_to_be16(vid & VLAN_VID_MASK);
> +		list[1].m_u.vlan_hdr.vlan = cpu_to_be16(0xFFFF);
> +	}
> +
>  	rule_info->sw_act.vsi_handle = pf_vsi_idx;
>  	rule_info->sw_act.flag |= ICE_FLTR_TX;
>  	rule_info->flags_info.act = ICE_SINGLE_ACT_LAN_ENABLE;
> @@ -110,14 +122,19 @@ ice_eswitch_br_rule_delete(struct ice_hw *hw, struct ice_rule_query_data *rule)
>  
>  static struct ice_rule_query_data *
>  ice_eswitch_br_fwd_rule_create(struct ice_hw *hw, int vsi_idx, int port_type,
> -			       const unsigned char *mac)
> +			       const unsigned char *mac, u16 vid)
>  {
>  	struct ice_adv_rule_info rule_info = { 0 };
>  	struct ice_rule_query_data *rule;
>  	struct ice_adv_lkup_elem *list;
> -	u16 lkups_cnt = 1;
> +	u16 lkups_cnt;
>  	int err;
>  
> +	if (ice_eswitch_is_vid_valid(vid))
> +		lkups_cnt = 2;
> +	else
> +		lkups_cnt = 1;

nit: The above condition could be more succinctly expressed as
     (completely untested):

	lkups_cnt = ice_eswitch_is_vid_valid(vid) ? 2 : 1;

     Also, the above condition appears elsewhere in this patch.
     Perhaps a helper is appropriate.

> +
>  	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
>  	if (!rule)
>  		return ERR_PTR(-ENOMEM);
> @@ -131,11 +148,11 @@ ice_eswitch_br_fwd_rule_create(struct ice_hw *hw, int vsi_idx, int port_type,
>  	switch (port_type) {
>  	case ICE_ESWITCH_BR_UPLINK_PORT:
>  		ice_eswitch_br_egress_rule_setup(list, &rule_info, mac,
> -						 vsi_idx);
> +						 vid, vsi_idx);
>  		break;
>  	case ICE_ESWITCH_BR_VF_REPR_PORT:
>  		ice_eswitch_br_ingress_rule_setup(list, &rule_info, mac,
> -						  hw->pf_id, vsi_idx);
> +						  vid, hw->pf_id, vsi_idx);
>  		break;
>  	default:
>  		err = -EINVAL;
> @@ -164,13 +181,18 @@ ice_eswitch_br_fwd_rule_create(struct ice_hw *hw, int vsi_idx, int port_type,
>  
>  static struct ice_rule_query_data *
>  ice_eswitch_br_guard_rule_create(struct ice_hw *hw, u16 vsi_idx,
> -				 const unsigned char *mac)
> +				 const unsigned char *mac, u16 vid)
>  {
>  	struct ice_adv_rule_info rule_info = { 0 };
>  	struct ice_rule_query_data *rule;
>  	struct ice_adv_lkup_elem *list;
> -	const u16 lkups_cnt = 1;
>  	int err = -ENOMEM;
> +	u16 lkups_cnt;
> +
> +	if (ice_eswitch_is_vid_valid(vid))
> +		lkups_cnt = 2;
> +	else
> +		lkups_cnt = 1;
>  
>  	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
>  	if (!rule)
> @@ -184,6 +206,12 @@ ice_eswitch_br_guard_rule_create(struct ice_hw *hw, u16 vsi_idx,
>  	ether_addr_copy(list[0].h_u.eth_hdr.src_addr, mac);
>  	eth_broadcast_addr(list[0].m_u.eth_hdr.src_addr);
>  
> +	if (ice_eswitch_is_vid_valid(vid)) {
> +		list[1].type = ICE_VLAN_OFOS;
> +		list[1].h_u.vlan_hdr.vlan = cpu_to_be16(vid & VLAN_VID_MASK);
> +		list[1].m_u.vlan_hdr.vlan = cpu_to_be16(0xFFFF);
> +	}
> +
>  	rule_info.allow_pass_l2 = true;
>  	rule_info.sw_act.vsi_handle = vsi_idx;
>  	rule_info.sw_act.fltr_act = ICE_NOP;

...

