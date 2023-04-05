Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CAB6D764C
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbjDEIHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbjDEIHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:07:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB991A2
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680682067; x=1712218067;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=hn8ofCOXzpOhMg0/zgl9Xv6F+fOGjDxKvfeB1GN4ENs=;
  b=aphDPVv1s+ZLdWKsiTxdsTDs4jvFfaYk7xjdmo/uEdYUabU0LCZVKpG9
   m24M8u61JmjzlGRJiGTZZg8M2Iu5fPwYozHpxNfv+ynEinE1BDu+76W6w
   yosbhfAQxSuV8OmLGd6Yh4D5vIdeBJszdLgddjlookL28vFdAVzv9jymb
   qcukqhv+CyrgYR3aIC8EuciJb84TiJt5csa3lUdKh40xWeYOo6zo51eHY
   hmB4VGhvPNsC0z2oUFdBYFkWgg29EwkBLZ/7GI3Llp2f/2lIQbdvYVhaP
   B/rQpcvhDeTZYacus+PJIenAY9l/kXhgkZEPTMw0O/AwrN0J/f4AzxEWx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="330996548"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="330996548"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:07:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="932748398"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="932748398"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:07:45 -0700
Date:   Wed, 5 Apr 2023 10:07:41 +0200
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 4/4] ice: use src VSI
 instead of src MAC in slow-path
Message-ID: <ZC0sTQiedWKWp3/y@localhost.localdomain>
References: <20230404072833.3676891-1-michal.swiatkowski@linux.intel.com>
 <20230404072833.3676891-5-michal.swiatkowski@linux.intel.com>
 <704d6afd-229a-064c-abfa-debdde6a73ad@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <704d6afd-229a-064c-abfa-debdde6a73ad@molgen.mpg.de>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 01:38:26PM +0200, Paul Menzel wrote:
> Dear Michal,
> 
> 
> Thank you for your patch.
> 
> Am 04.04.23 um 09:28 schrieb Michal Swiatkowski:
> > The use of a source  MAC to direct packets from the VF to the
> 
> One space before MAC.
> 
> > corresponding port representor is only ok if there is only one
> > MAC on a VF. To support this functionality when the number
> > of MACs on a VF is greater, it is necessary to match a source
> > VSI instead of a source MAC.
> 
> Please reflow for 72/75 characters per line. This paragraph fits in four
> lines.
> 
> > Let's use the new switch API that allows matching on metadata.
> > 
> > If MAC isn't used in match criteria there is no need to handle adding
> > rule after virtchnl command. Instead add new rule while port representor
> > is being configured.
> > 
> > Remove rule_added field, checking for sp_rule can be used instead.
> > Remove also checking for switchdev running in deleting rule as it can be
> > call from unroll context when running flag isn't set. Checking for
> 
> call*ed*
> 
> > sp_rule cover both context (with and without running flag).
> 
> cover*s*
> 

Thanks, fixed

> > Rules are added in eswitch configuration flow, so there is no need to
> > have replay function.
> > 
> > Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > @@ -13,9 +13,8 @@ struct ice_repr {

[...]

> >   	struct net_device *netdev;
> >   	struct metadata_dst *dst;
> >   #ifdef CONFIG_ICE_SWITCHDEV
> > -	/* info about slow path MAC rule  */
> > -	struct ice_rule_query_data *mac_rule;
> > -	u8 rule_added;
> > +	/* info about slow path rule  */
> > +	struct ice_rule_query_data sp_rule;
> 
> I’d not abbreviate slowpath in the names. No idea if it would be too long.
>

I think it will be too long. It also can be only rule, as there is only
one specific rule stored in representor struct.

> 
> Kind regards,
> 
> Paul
>

Thanks,
Michal

> 
> >   #endif
> >   };
> > diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
> > index 8c2bbfd2613f..76f5a817929a 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_switch.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_switch.c
> > @@ -6007,6 +6007,12 @@ void ice_rule_add_vlan_metadata(struct ice_adv_lkup_elem *lkup)
> >   		cpu_to_be16(ICE_PKT_VLAN_MASK);
> >   }
> > +void ice_rule_add_src_vsi_metadata(struct ice_adv_lkup_elem *lkup)
> > +{
> > +	lkup->type = ICE_HW_METADATA;
> > +	lkup->m_u.metadata.source_vsi = cpu_to_be16(ICE_MDID_SOURCE_VSI_MASK);
> > +}
> > +
> >   /**
> >    * ice_add_adv_rule - helper function to create an advanced switch rule
> >    * @hw: pointer to the hardware structure
> > diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
> > index 245d4ad4e9bc..fbd0936750af 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_switch.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_switch.h
> > @@ -344,6 +344,7 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
> >   /* Switch/bridge related commands */
> >   void ice_rule_add_tunnel_metadata(struct ice_adv_lkup_elem *lkup);
> >   void ice_rule_add_vlan_metadata(struct ice_adv_lkup_elem *lkup);
> > +void ice_rule_add_src_vsi_metadata(struct ice_adv_lkup_elem *lkup);
> >   int
> >   ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
> >   		 u16 lkups_cnt, struct ice_adv_rule_info *rinfo,
> > diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
> > index 68142facc85d..294e91c3453c 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
> > @@ -670,8 +670,6 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
> >   	 */
> >   	ice_vf_clear_all_promisc_modes(vf, vsi);
> > -	ice_eswitch_del_vf_mac_rule(vf);
> > -
> >   	ice_vf_fdir_exit(vf);
> >   	ice_vf_fdir_init(vf);
> >   	/* clean VF control VSI when resetting VF since it should be setup
> > @@ -697,7 +695,6 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
> >   	}
> >   	ice_eswitch_update_repr(vsi);
> > -	ice_eswitch_replay_vf_mac_rule(vf);
> >   	/* if the VF has been reset allow it to come up again */
> >   	ice_mbx_clear_malvf(&vf->mbx_info);
> > diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> > index 97243c616d5d..dcf628b1fccd 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> > @@ -3730,7 +3730,6 @@ static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
> >   	for (i = 0; i < al->num_elements; i++) {
> >   		u8 *mac_addr = al->list[i].addr;
> > -		int result;
> >   		if (!is_unicast_ether_addr(mac_addr) ||
> >   		    ether_addr_equal(mac_addr, vf->hw_lan_addr))
> > @@ -3742,13 +3741,6 @@ static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
> >   			goto handle_mac_exit;
> >   		}
> > -		result = ice_eswitch_add_vf_mac_rule(pf, vf, mac_addr);
> > -		if (result) {
> > -			dev_err(ice_pf_to_dev(pf), "Failed to add MAC %pM for VF %d\n, error %d\n",
> > -				mac_addr, vf->vf_id, result);
> > -			goto handle_mac_exit;
> > -		}
> > -
> >   		ice_vfhw_mac_add(vf, &al->list[i]);
> >   		vf->num_mac++;
> >   		break;
