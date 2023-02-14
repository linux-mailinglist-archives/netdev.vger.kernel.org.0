Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DFB696A69
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjBNQ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjBNQ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:56:50 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38654EE3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676393809; x=1707929809;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5H6OR43QPkIPpvtJkenPSIdFq0kx+bK8LUBoJTCqIfc=;
  b=RQq3x1AheHwdYDV/OmviKQGVqs3gaNKxjzttLibDcjlhC6+EPUisfMGz
   e9ZpZ2cWbfz5eIOw3UPwY2A4v180uZ8f9M4OJPaUQbbrgcN58UEIGgXfe
   ZIdXE5YtaoLq0quwQ/9QvumyR2lOwouRNcB5xA+E4ukXn/STqdxGcZ9gP
   r5FAzKM0kevl0/yoBvzDtCBuxp+qC0RfFXhCDKZLLxR23L6fMHuGNkHJA
   4w9OSFeHNMsPkuQW6Gi+EwIdp7MsOXB4aL+dEVWFUhFJ6Fn0kF9oPPQjO
   7q6HVYQ4QXJSF/FKlkz7kBRix3r9i+ZkQ4FyQLFHn5GRcyoxEEylAHukX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417426353"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="417426353"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 08:56:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="778417645"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="778417645"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 14 Feb 2023 08:56:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 08:56:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 08:56:48 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 08:56:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7MUFUKS2BhHVdQO9DzPZ6Pu77GNcD5WSij7gxGwHooSawKjMsOyVkbPQDZKM1sark3ASuH/0pY+8TKz3E7gTxl9/awmcrDAKtjs5RjLIpOFhV8gjn838emQnvb1lW6ejvbc+UA9Z9hH81RlC/TmM2MJE67lck8yvGLXYJWsk/Vpi+APWz2nHHGuJft5o2eW8UlMN5OLygE/ab2dTFEMbVvuibvn4bLQOt77DdTQbwiI/av80dtI4cx65YHTtpAaTsZwAxf+o68phQvHem0FSvzvA+ne9K0EbMXcqvrVOXI2nHR/7rD4Alca4tyAuvRyv9BaxbA+FAo9I0QApmQqIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHsjMFI8431rsqKPgY1uzvc/dUFxwS8IwYv+F5s9PW8=;
 b=hAlAIhRH77DdlZYbGnlGYeZ5KgW4hhOztU8Od/4SpbW57RpsduxYahdcpRUMXi4dG6Q0zVVoumEXdgZkDlSMhlQoKqx7A3ggzLOTps7RVAu7y3p9cOCJ/gEQBVj9wWOItJfMlsv/L0E8zIZbB9bBi9Jrlo+tSdxiGyjGfxkovm6Ol3Xq60sP8u6nxYzxcUW9qEXihnZOlGLPTVtbRK0JSEnBPz8ZGFFS7l/7fHgTBsu3czqh0O7VumwjvbwxP0DAQSgD09syWzZWwjNYtAOQnWtl7fn5Zc5n9uif0OJ+5qr8UbI+uCeHtaAQWV86B8YrmTahPd9kTV2h3xPCjjR2ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CY8PR11MB7244.namprd11.prod.outlook.com (2603:10b6:930:97::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Tue, 14 Feb 2023 16:56:47 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Tue, 14 Feb 2023
 16:56:47 +0000
Date:   Tue, 14 Feb 2023 17:56:40 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <jesse.brandeburg@intel.com>, <edumazet@google.com>,
        <anthony.l.nguyen@intel.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH v2 net-next] ice: update xdp_features
 with xdp multi-buff
Message-ID: <Y+u9SCz2oGrtGZtw@boxer>
References: <8a4781511ab6e3cd280e944eef69158954f1a15f.1676385351.git.lorenzo@kernel.org>
 <Y+u6jkfVo4oZWn42@boxer>
 <Y+u7n4gRNy+F3fkx@lore-desk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y+u7n4gRNy+F3fkx@lore-desk>
X-ClientProxiedBy: FR3P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CY8PR11MB7244:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e926bec-2705-4609-0fa8-08db0eac7543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bEC5LKkKQo9xInyqM+YDSemIm3Gx28W0XZooX72n6ltfYGTnHsZ3Y35yMEAw8up2s0MZJahC+R962F6+hXGlQ06P4diPAAz1E9hb6QKx9tVin5x5oDJ4dsZFrySjw3PZzkwY3Ns2ECfJ6a18nM9BleuXNAC9kT0sxMdqxxYfeJEeUaJqdqcw5clvlRr/AzO/4KCFacuKrgZw+MIto0OUiq8YhZUoi5ydeJOM+CJtJ+kOxdOy7b7XPCyLKeZZr3FbtvvyLznI6pDyUmCYIOJxNAqmcMM0pvrE7bNonkAICqaaV1mtaY0md9/HEO6yUbtZPBLwOQiIltX/ytPs+SSD9u9d/gySFkrVjJHr0FymcsO09osQuP/oyhQS35jc0hVKdhrKQB8WnIlSbkE0IldmHCd5/9T7IyX3il3bHSUjfIXvGg+/X5oKl2/bFiRLm9+ktTn9T+3LpZq1EYKjvaKMEbNNj3lzorMh4jGV5yYLytDDjuOWc+RfH+9dape3OKmKbe1yQBPjMgBKYaLtS9WLSORB4cGxny4W3lA5Inbz9f48kShX0mDXduCqvIWqEqlhO0kDaDifUi96zk5le00nVQ0z3V7KEOsKDRZvO+FdsBtQCszEsDpSI4H0dRAadLKwRAT8kuB2j1zLJhRpidGAw28/hy6FLkpxnusLx2ctweE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199018)(6486002)(966005)(6506007)(6512007)(186003)(26005)(6666004)(9686003)(478600001)(82960400001)(38100700002)(86362001)(83380400001)(2906002)(33716001)(41300700001)(5660300002)(66476007)(66946007)(66556008)(6916009)(4326008)(8676002)(8936002)(316002)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fmwAlokNG9i+cfznVbqyPYt93YVZ/OPc0UR+FCeAj2mWX02urGtodgjUs7Bg?=
 =?us-ascii?Q?W27oZOhYxoFo7sa2dJy0oM5zQ3cxh7iTiltGS/PmV89cMWsRo1YEoJO1sQ5/?=
 =?us-ascii?Q?rpSsuxIYJNrIBszh0/feKtPWSZ+eHiaNSxkHcKpG/XJ2pZY6BThZB6qfwb8o?=
 =?us-ascii?Q?fpbIkcdXIM7OB2vgNe8LjAvPEiqlE/PfT8eqL6y0eZ4CuSWF1qrmni3/NE/e?=
 =?us-ascii?Q?TlYvAqeyY/P8/tMDObS3ZxnZxn7TLEdh/CeKPRyzL0kUtEj/p7MZmUJsGN59?=
 =?us-ascii?Q?yrU/JY1SDpH6O/fMrMA2yrfMgi7QVrRsPT6OG4v9pk6BvxCXXpXkyuLXU686?=
 =?us-ascii?Q?MEnn193KuQQklOFkXeFVynegrwxLI/GM5xSk02z+wxYAHSQWQOlvFrEItb7T?=
 =?us-ascii?Q?Lbz45sRv+9Oq0lOGlXrzyuDetpSFocEkqOtnJqopQztiBhLkphhDU1Gw6X3W?=
 =?us-ascii?Q?dYvCV6efQcK/PC0gMXU1Robqex2TKk09Rx3Yp/4ShCGwv+fYg+dq1JwNn/3F?=
 =?us-ascii?Q?zvQy9EgAEqMraG6MpgE/kjJWBjK4hpXjIgxcoRo2J/GL6p1wh/kcmufOtgWQ?=
 =?us-ascii?Q?pLDDo+fV5um5VUNCgo3QL57cHAyVp4C7Q5A3y7JKXMVdsQQtjJDiWC/KGyWx?=
 =?us-ascii?Q?DdCxlRHyVdNESfeTd8HC6L19UJr87qXD6zAQLAO/bmAEMp5EUQM55NOS8Z9U?=
 =?us-ascii?Q?W4yhyaAPeoxUhrppR5hRVxT0CFwhadUy3vZ3tQtOyqiHXzaeGr6sb21ZIgy4?=
 =?us-ascii?Q?UAe/RdCfh5YoZvoHbikLitCLbQqbWyJDcsrzghqFnFB38Z6CJZuwhlflRNWA?=
 =?us-ascii?Q?H5myc2/zNdZTFDgqb5MB3nfAlRI2tBt11h7HqJ5dNkn7DxCnKZrYOfzqYwTd?=
 =?us-ascii?Q?/k16SaEOvGUFgCY3A80573f0BZd87P8zHiJlflxlWEpEL7eFVnlRS2wPEFmd?=
 =?us-ascii?Q?OEjYC/TLES0x155UbxmkgqU4MwYnsNgqWkOajMiXJFA/XYlsAIqf/DB2SCZB?=
 =?us-ascii?Q?ORP0C/s5MoSyZcJl0ISyBFcLJLGZt+Bp+enfFG3geT+bwton28F83QktyyQX?=
 =?us-ascii?Q?7ppkcPD7jjXWPJa8igOu/swE6O54Z9+ToSStyPwm4N+1KGDSU/1UZrG1w+T5?=
 =?us-ascii?Q?IXe6F83Qu+7QXaJR1Lwcr5lBxb5YExQtBcBDYSZPfMak50qL5rouCn5jHd1L?=
 =?us-ascii?Q?ItG733m3u2QIOLzaYODTd7KFAdHqKd0/JgIuYKO8hMN5x/1CIG0q6M9i9e/B?=
 =?us-ascii?Q?4NYvNaL+GUYDZeIUs638YVPffT5FmzvhOhsnqDGCxJSeT+VIwcoxVtCTFMv0?=
 =?us-ascii?Q?3suE3xF1OM3BmsEnLyqFodQsSpX9uBkW+bG3dEUdWoqx8FMRlz4ft1RyZVhw?=
 =?us-ascii?Q?3pMSzGIT4TpLQag91l7pmtqI3GgXCpJoIMdrN84SGu9AltzBLL5r5YnNzU33?=
 =?us-ascii?Q?sTUTJYKUc2WQoJGgnLQFPV3tiK2p+JIAbzYW6IJH6DtTxUi55DPMZX19ZqO8?=
 =?us-ascii?Q?9WJSuWa7QxqloDVY9FR2tozIQ1j/0+BS6sqwmkOLTRbb2xHMec49Feyz7Sw/?=
 =?us-ascii?Q?GchsOnJ4S7lziqJ9JKCGbrQS19b+8v4kCTNVnML5/zCzvw4F4t2oLrG4XaAA?=
 =?us-ascii?Q?mfyHS9bNYnmjbMcqQuCjMZ0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e926bec-2705-4609-0fa8-08db0eac7543
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:56:46.8956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gzdjsVJj32lWYzUyx1ICaiO17Y7lYsiGYBDwDrjZoLV/WZLzKRHWKIdTQ8WztiTdO3/8/E4xa7Bw362KSwdNfuUYS+GU0ZPcHMi47jdwOXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7244
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 05:49:35PM +0100, Lorenzo Bianconi wrote:
> > On Tue, Feb 14, 2023 at 03:39:27PM +0100, Lorenzo Bianconi wrote:
> > > Now ice driver supports xdp multi-buffer so add it to xdp_features.
> > > Check vsi type before setting xdp_features flag.
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > > Changes since v1:
> > > - rebase on top of net-next
> > > - check vsi type before setting xdp_features flag
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice_main.c | 18 ++++++++++++------
> > >  1 file changed, 12 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> > > index 0712c1055aea..4994a0e5a668 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > > @@ -2912,7 +2912,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
> > >  			if (xdp_ring_err)
> > >  				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
> > >  		}
> > > -		xdp_features_set_redirect_target(vsi->netdev, false);
> > > +		xdp_features_set_redirect_target(vsi->netdev, true);
> > >  		/* reallocate Rx queues that are used for zero-copy */
> > >  		xdp_ring_err = ice_realloc_zc_buf(vsi, true);
> > >  		if (xdp_ring_err)
> > > @@ -3333,10 +3333,11 @@ static void ice_napi_add(struct ice_vsi *vsi)
> > >  
> > >  /**
> > >   * ice_set_ops - set netdev and ethtools ops for the given netdev
> > > - * @netdev: netdev instance
> > > + * @vsi: the VSI associated with the new netdev
> > >   */
> > > -static void ice_set_ops(struct net_device *netdev)
> > > +static void ice_set_ops(struct ice_vsi *vsi)
> > >  {
> > > +	struct net_device *netdev = vsi->netdev;
> > >  	struct ice_pf *pf = ice_netdev_to_pf(netdev);
> > >  
> > >  	if (ice_is_safe_mode(pf)) {
> > > @@ -3348,6 +3349,13 @@ static void ice_set_ops(struct net_device *netdev)
> > >  	netdev->netdev_ops = &ice_netdev_ops;
> > >  	netdev->udp_tunnel_nic_info = &pf->hw.udp_tunnel_nic;
> > >  	ice_set_ethtool_ops(netdev);
> > > +
> > > +	if (vsi->type != ICE_VSI_PF)
> > > +		return;
> > > +
> > > +	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> > > +			       NETDEV_XDP_ACT_XSK_ZEROCOPY |
> > > +			       NETDEV_XDP_ACT_RX_SG;
> > 
> > FWIW we do support frags in ndo_xdp_xmit() now so
> > NETDEV_XDP_ACT_NDO_XMIT_SG should be set.
> 
> yep, I have enabled them in ice_xdp_setup_prog() setting support_sg to true in
> xdp_features_set_redirect_target().

oops missed this part, sorry:)

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Regards,
> Lorenzo
> 
> > 
> > >  }
> > >  
> > >  /**
> > > @@ -4568,9 +4576,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
> > >  	np->vsi = vsi;
> > >  
> > >  	ice_set_netdev_features(netdev);
> > > -	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> > > -			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
> > > -	ice_set_ops(netdev);
> > > +	ice_set_ops(vsi);
> > >  
> > >  	if (vsi->type == ICE_VSI_PF) {
> > >  		SET_NETDEV_DEV(netdev, ice_pf_to_dev(vsi->back));
> > > -- 
> > > 2.39.1
> > > 
> > > _______________________________________________
> > > Intel-wired-lan mailing list
> > > Intel-wired-lan@osuosl.org
> > > https://lists.osuosl.org/mailman/listinfo/intel-wired-lan


