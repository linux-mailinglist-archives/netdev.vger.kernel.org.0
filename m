Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC51D2B28ED
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgKMW7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgKMW7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 17:59:36 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20461C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 14:59:36 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id h6so6288852ilj.8
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 14:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=63ahXhPQ3ZOWWaOM7xaq20ESp2DGHIm/BRPlNBEwQsU=;
        b=hvQT20sT5fYSum4Inqoz3+mw2BUKoxc2G9E1ow1lC+ICelnjaLz1co57O46JK9H36t
         T2VgIrpzAdoxC9FESiIlZweOotbb2YUlp4s96kNwvUlk8ooSaz3yc0qUivKpIC337HaS
         4krZdZTzpBrYeNqn3p+67kWJWShPtquuEKU+0C/nIhxEYiPbsANJ2Mg363I0Wh2wkmBD
         Y0KPOLm/HHTBmA3ecfzy9Zb6wzSVst3MgQ1cPixbC6w8N4CJEtcT3Jm/RQF0xpOJIK4p
         bUGDl+tgDDc/uCqMMCmnh/uoczky6tX/IsIqUm20MlK0kjBRtYj8C2aCC76ef23ffKSB
         CRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=63ahXhPQ3ZOWWaOM7xaq20ESp2DGHIm/BRPlNBEwQsU=;
        b=oJLLMrVogs/l0e/UfnxhozuF2h/URbaH0Vc35bqYu/HNNJ/PdfaK/8UcjzLdIj2GfH
         qq+YFdFgxKguZJpP8K+byOHJ9QSNsZS0HUkhbfRQVr4BvVL1jd1xv28AYl1gNikjCOqN
         4cKuC+u2CcSZKEgoI1kAc5MMuDI4qqTab3g3Dkgiv9LQe5pQM2YOc9C+mjqfrmVV+oNR
         IvbZeQCX1SYIiEsvzb7SmwkKBSBWgsoGWz1hYm3aRCwoy3NI+tC6MJK9RsEa2W3Ayvh2
         vsKOLU5H/5pEYd759Cwcs+D1FVWdD9eFgZBib70kc+dZZpvBrbbDIzFn1R5zypVd1xb0
         Yicg==
X-Gm-Message-State: AOAM531VkgcikNsgAy6KXOKeH6bKCwpRnqQh7+1Cttdekiix8tg2mVrb
        q5qFQcu6HvIMc4EKX/LGUcg/Yn9OB+vUFsfSjp4=
X-Google-Smtp-Source: ABdhPJyRAB7az+MLEipDaxYnqwjOnlshBhek90WiVsZ2tLZp+UXuYgi305MyCpwfdHF1ILcAjtrz6h3rK/vF3tDDXtA=
X-Received: by 2002:a92:ca86:: with SMTP id t6mr1529632ilo.95.1605308375364;
 Fri, 13 Nov 2020 14:59:35 -0800 (PST)
MIME-Version: 1.0
References: <20201113213407.2131340-1-anthony.l.nguyen@intel.com> <20201113213407.2131340-4-anthony.l.nguyen@intel.com>
In-Reply-To: <20201113213407.2131340-4-anthony.l.nguyen@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 13 Nov 2020 14:59:24 -0800
Message-ID: <CAKgT0UcEd4BmyMxBmy2D2vVCWKu3Q=0iYKZ2UTdAPg0gitSiCQ@mail.gmail.com>
Subject: Re: [net-next v2 03/15] ice: initialize ACL table
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.neti, Jakub Kicinski <kuba@kernel.org>,
        Real Valiquette <real.valiquette@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Stefan Assmann <sassmann@redhat.com>,
        Chinh Cao <chinh.t.cao@intel.com>,
        Harikumar Bokkena <harikumarx.bokkena@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 1:36 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> From: Real Valiquette <real.valiquette@intel.com>
>
> ACL filtering can be utilized to expand support of ntuple rules by allowing
> mask values to be specified for redirect to queue or drop.
>
> Implement support for specifying the 'm' value of ethtool ntuple command
> for currently supported fields (src-ip, dst-ip, src-port, and dst-port).
>
> For example:
>
> ethtool -N eth0 flow-type tcp4 dst-port 8880 m 0x00ff action 10
> or
> ethtool -N eth0 flow-type tcp4 src-ip 192.168.0.55 m 0.0.0.255 action -1
>
> At this time the following flow-types support mask values: tcp4, udp4,
> sctp4, and ip4.

So you spend all of the patch description describing how this might be
used in the future. However there is nothing specific to the ethtool
interface as far as I can tell anywhere in this patch. With this patch
the actual command called out above cannot be performed, correct?

> Begin implementation of ACL filters by setting up structures, AdminQ
> commands, and allocation of the ACL table in the hardware.

This seems to be what this patch is actually doing. You may want to
rewrite this patch description to focus on this and explain that you
are enabling future support for ethtool ntuple masks. However save
this feature description for the patch that actually enables the
functionality.

> Co-developed-by: Chinh Cao <chinh.t.cao@intel.com>
> Signed-off-by: Chinh Cao <chinh.t.cao@intel.com>
> Signed-off-by: Real Valiquette <real.valiquette@intel.com>
> Co-developed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Tested-by: Harikumar Bokkena  <harikumarx.bokkena@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/Makefile       |   2 +
>  drivers/net/ethernet/intel/ice/ice.h          |   4 +
>  drivers/net/ethernet/intel/ice/ice_acl.c      | 153 +++++++++
>  drivers/net/ethernet/intel/ice/ice_acl.h      | 125 +++++++
>  drivers/net/ethernet/intel/ice/ice_acl_ctrl.c | 311 ++++++++++++++++++
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 215 +++++++++++-
>  drivers/net/ethernet/intel/ice/ice_flow.h     |   2 +
>  drivers/net/ethernet/intel/ice/ice_main.c     |  50 +++
>  drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
>  9 files changed, 863 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_acl.c
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_acl.h
>  create mode 100644 drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
>

<snip>

> +/**
> + * ice_acl_destroy_tbl - Destroy a previously created LEM table for ACL
> + * @hw: pointer to the HW struct
> + */
> +enum ice_status ice_acl_destroy_tbl(struct ice_hw *hw)
> +{
> +       struct ice_aqc_acl_generic resp_buf;
> +       enum ice_status status;
> +
> +       if (!hw->acl_tbl)
> +               return ICE_ERR_DOES_NOT_EXIST;
> +
> +       /* call the AQ command to destroy the ACL table */
> +       status = ice_aq_dealloc_acl_tbl(hw, hw->acl_tbl->id, &resp_buf, NULL);
> +       if (status) {
> +               ice_debug(hw, ICE_DBG_ACL, "AQ de-allocation of ACL failed. status: %d\n",
> +                         status);
> +               return status;
> +       }
> +
> +       devm_kfree(ice_hw_to_dev(hw), hw->acl_tbl);
> +       hw->acl_tbl = NULL;

What are the scenarios where you might see the dealloc_acl_tbl fail?
I'm just wondering if it makes sense to keep the table just because
the hardware is refusing to give it up.

> +
> +       return 0;
> +}
> diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> index b06fbe99d8e9..688a2069482d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> +++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
> @@ -327,6 +327,7 @@ struct ice_aqc_vsi_props {
>  #define ICE_AQ_VSI_PROP_RXQ_MAP_VALID          BIT(6)
>  #define ICE_AQ_VSI_PROP_Q_OPT_VALID            BIT(7)
>  #define ICE_AQ_VSI_PROP_OUTER_UP_VALID         BIT(8)
> +#define ICE_AQ_VSI_PROP_ACL_VALID              BIT(10)
>  #define ICE_AQ_VSI_PROP_FLOW_DIR_VALID         BIT(11)
>  #define ICE_AQ_VSI_PROP_PASID_VALID            BIT(12)
>         /* switch section */
> @@ -442,8 +443,12 @@ struct ice_aqc_vsi_props {
>         u8 q_opt_reserved[3];
>         /* outer up section */
>         __le32 outer_up_table; /* same structure and defines as ingress tbl */
> -       /* section 10 */
> -       __le16 sect_10_reserved;
> +       /* ACL section */
> +       __le16 acl_def_act;
> +#define ICE_AQ_VSI_ACL_DEF_RX_PROF_S   0
> +#define ICE_AQ_VSI_ACL_DEF_RX_PROF_M   (0xF << ICE_AQ_VSI_ACL_DEF_RX_PROF_S)
> +#define ICE_AQ_VSI_ACL_DEF_RX_TABLE_S  4
> +#define ICE_AQ_VSI_ACL_DEF_RX_TABLE_M  (0xF << ICE_AQ_VSI_ACL_DEF_RX_TABLE_S)
>         /* flow director section */
>         __le16 fd_options;
>  #define ICE_AQ_VSI_FD_ENABLE           BIT(0)
> @@ -1612,6 +1617,200 @@ struct ice_aqc_get_set_rss_lut {
>         __le32 addr_low;
>  };
>
> +/* Allocate ACL table (indirect 0x0C10) */
> +#define ICE_AQC_ACL_KEY_WIDTH_BYTES    5
> +#define ICE_AQC_ACL_TCAM_DEPTH         512
> +#define ICE_ACL_ENTRY_ALLOC_UNIT       64
> +#define ICE_AQC_MAX_CONCURRENT_ACL_TBL 15
> +#define ICE_AQC_MAX_ACTION_MEMORIES    20
> +#define ICE_AQC_ACL_SLICES             16
> +#define ICE_AQC_ALLOC_ID_LESS_THAN_4K  0x1000
> +/* The ACL block supports up to 8 actions per a single output. */
> +#define ICE_AQC_TBL_MAX_ACTION_PAIRS   4
> +
> +#define ICE_AQC_MAX_TCAM_ALLOC_UNITS   (ICE_AQC_ACL_TCAM_DEPTH / \
> +                                        ICE_ACL_ENTRY_ALLOC_UNIT)
> +#define ICE_AQC_ACL_ALLOC_UNITS                (ICE_AQC_ACL_SLICES * \
> +                                        ICE_AQC_MAX_TCAM_ALLOC_UNITS)
> +
> +struct ice_aqc_acl_alloc_table {
> +       __le16 table_width;
> +       __le16 table_depth;
> +       u8 act_pairs_per_entry;
> +       u8 table_type;
> +       __le16 reserved;
> +       __le32 addr_high;
> +       __le32 addr_low;
> +};
> +
> +/* Allocate ACL table command buffer format */
> +struct ice_aqc_acl_alloc_table_data {
> +       /* Dependent table AllocIDs. Each word in this 15 word array specifies
> +        * a dependent table AllocID according to the amount specified in the
> +        * "table_type" field. All unused words shall be set to 0xFFFF
> +        */
> +#define ICE_AQC_CONCURR_ID_INVALID     0xffff
> +       __le16 alloc_ids[ICE_AQC_MAX_CONCURRENT_ACL_TBL];
> +};
> +
> +/* Deallocate ACL table (indirect 0x0C11) */
> +
> +/* Following structure is common and used in case of deallocation
> + * of ACL table and action-pair
> + */
> +struct ice_aqc_acl_tbl_actpair {
> +       /* Alloc ID of the table being released */
> +       __le16 alloc_id;
> +       u8 reserved[6];
> +       __le32 addr_high;
> +       __le32 addr_low;
> +};
> +
> +/* This response structure is same in case of alloc/dealloc table,
> + * alloc/dealloc action-pair
> + */
> +struct ice_aqc_acl_generic {
> +       /* if alloc_id is below 0x1000 then allocation failed due to
> +        * unavailable resources, else this is set by FW to identify
> +        * table allocation
> +        */
> +       __le16 alloc_id;
> +
> +       union {
> +               /* to be used only in case of alloc/dealloc table */
> +               struct {
> +                       /* Index of the first TCAM block, otherwise set to 0xFF
> +                        * for a failed allocation
> +                        */
> +                       u8 first_tcam;
> +                       /* Index of the last TCAM block. This index shall be
> +                        * set to the value of first_tcam for single TCAM block
> +                        * allocation, otherwise set to 0xFF for a failed
> +                        * allocation
> +                        */
> +                       u8 last_tcam;
> +               } table;
> +               /* reserved in case of alloc/dealloc action-pair */
> +               struct {
> +                       __le16 reserved;
> +               } act_pair;

Is there really any need to call out the reserved value? It seems like
you could just leave the struct table in place and not bother with the
union since you would likely just be memsetting the entire ops struct
to 0 anyway.

> +       } ops;
> +
> +       /* index of first entry (in both TCAM and action memories),
> +        * otherwise set to 0xFF for a failed allocation
> +        */
> +       __le16 first_entry;
> +       /* index of last entry (in both TCAM and action memories),
> +        * otherwise set to 0xFF for a failed allocation
> +        */
> +       __le16 last_entry;
> +
> +       /* Each act_mem element specifies the order of the memory
> +        * otherwise 0xFF
> +        */
> +       u8 act_mem[ICE_AQC_MAX_ACTION_MEMORIES];
> +};
> +

<snip>

> +/**
> + * ice_deinit_acl - Unroll the initialization of the ACL block
> + * @pf: ptr to PF device
> + */
> +static void ice_deinit_acl(struct ice_pf *pf)
> +{
> +       ice_acl_destroy_tbl(&pf->hw);

Why have the ice_acl_destroy_tbl function return a value if it is just
going to be ignored?

> +}
> +
>  /**
>   * ice_init_fdir - Initialize flow director VSI and configuration
>   * @pf: pointer to the PF instance
> @@ -4231,6 +4273,12 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
>         /* Note: Flow director init failure is non-fatal to load */
>         if (ice_init_fdir(pf))
>                 dev_err(dev, "could not initialize flow director\n");
> +       if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
> +               /* Note: ACL init failure is non-fatal to load */
> +               err = ice_init_acl(pf);
> +               if (err)
> +                       dev_err(dev, "Failed to initialize ACL: %d\n", err);
> +       }
>
>         /* Note: DCB init failure is non-fatal to load */
>         if (ice_init_pf_dcb(pf, false)) {
> @@ -4361,6 +4409,8 @@ static void ice_remove(struct pci_dev *pdev)
>
>         ice_aq_cancel_waiting_tasks(pf);
>
> +       if (test_bit(ICE_FLAG_FD_ENA, pf->flags))
> +               ice_deinit_acl(pf);

Looking over the code is there any reason why you need to bother with
checking the flag? It seems like if ACL is not enabled ice_deinit_acl
won't do anything. So why bother checking the flag? Also is it really
okay to just ignore if deallocating the table fails? What are the side
effects?


>         mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
>         if (!ice_is_safe_mode(pf))
>                 ice_remove_arfs(pf);
> diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
> index 2226a291a394..a1600c7e8b17 100644
> --- a/drivers/net/ethernet/intel/ice/ice_type.h
> +++ b/drivers/net/ethernet/intel/ice/ice_type.h
> @@ -47,6 +47,7 @@ static inline u32 ice_round_to_num(u32 N, u32 R)
>  #define ICE_DBG_SCHED          BIT_ULL(14)
>  #define ICE_DBG_PKG            BIT_ULL(16)
>  #define ICE_DBG_RES            BIT_ULL(17)
> +#define ICE_DBG_ACL            BIT_ULL(18)
>  #define ICE_DBG_AQ_MSG         BIT_ULL(24)
>  #define ICE_DBG_AQ_DESC                BIT_ULL(25)
>  #define ICE_DBG_AQ_DESC_BUF    BIT_ULL(26)
> @@ -679,6 +680,8 @@ struct ice_hw {
>         struct udp_tunnel_nic_shared udp_tunnel_shared;
>         struct udp_tunnel_nic_info udp_tunnel_nic;
>
> +       struct ice_acl_tbl *acl_tbl;
> +
>         /* HW block tables */
>         struct ice_blk_info blk[ICE_BLK_COUNT];
>         struct mutex fl_profs_locks[ICE_BLK_COUNT];     /* lock fltr profiles */
> --
> 2.26.2
>
