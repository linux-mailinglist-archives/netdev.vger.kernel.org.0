Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D8F6381D2
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 00:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiKXXpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 18:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiKXXpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 18:45:44 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A7F898F0
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 15:45:42 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id d128so3274227ybf.10
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 15:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RWlUUt1MirV9iw9P9DZBfup71/SLf1KqqpJ+q15kP7U=;
        b=llTI5JNYsgbU7OZAaNGJfYixFWy1tP1/MW7/kp67M0WxjL36WZ2DlzKvtIzmVs2PrE
         3icHex2nwqHqLiXvSNtz6ruGyb2JAdW6ZA4Jc/RskVGRRtmXx0zHz0lUrFolalwVU9Ji
         Fh5OpDVDvCEU+Wy8y+SYgPot0zbQg53rBKBAV82u41AFsNZjypz0L8ZgdD+2S2Ls33Do
         evwvbDq4ctYQmQKQwuPrAR4sVNKKo194z3tMO/26geBdbZOpZ2sRLVuBcptJG+FrgVpy
         dOqFUCTbAceRx/eR2mMYOm69YldmUw/cTzo10In9WB/qeMbWDXVxa+HPRtIOY7tm8riG
         Erpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RWlUUt1MirV9iw9P9DZBfup71/SLf1KqqpJ+q15kP7U=;
        b=is1ENXi/mNROz/ZLwN+2TdKurgJd4Mk9mDCfI5egoIzDvWjaotSaaZqk4GQ8O6RXbW
         2ba5F2npxjht+NOd57A4qtWn0WNa/DAyfGFR/ptzc0up61vYFdd378Ypauy25mK1l4fM
         V6N5Mk4MT/KIHFdqKCcM8ItrgzLTbCPpe5U1cxWUQOU4vrsNcCTOu0kIUTflBOGkZurL
         5erLBspZunBPb79jBhNmpoU+z2u9OfRa8fHnA5iX0yMn7m/r7+HjO1MRDgHu7pwhONQA
         lf8hVYGnzvDI6Kex/VfzI44FHziwQkLGcHb8J612t8057arK5/ukdcCJQMuX632BQCjg
         BV5g==
X-Gm-Message-State: ANoB5pnZK4d3U89MV+MppSY3tzpHaxBnAnziKqUotGFgK++KBSObGb2p
        3l00zJej8sB72Mw4X0RRVHq2KXKqYG95LEHcj2V5yA==
X-Google-Smtp-Source: AA0mqf4wynwsmpkDdZCMZCEzsfTA+0USXNBo7UdbNu9iFapJ7iqPWagIIclPZGEY19+cHaUf/JYxSfkG0od5JcQHuKc=
X-Received: by 2002:a25:2591:0:b0:6ee:c506:7338 with SMTP id
 l139-20020a252591000000b006eec5067338mr13031116ybl.509.1669333541558; Thu, 24
 Nov 2022 15:45:41 -0800 (PST)
MIME-Version: 1.0
References: <20221122112020.922691-1-simon.horman@corigine.com>
In-Reply-To: <20221122112020.922691-1-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 24 Nov 2022 18:45:30 -0500
Message-ID: <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Marcelo Leitner <mleitner@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>, dev@openvswitch.org,
        oss-drivers@corigine.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am not sure if the mlx5 changes will work since  they both seem to be calling
mlx5e_tc_act_get() which expects the act->id to exist in tc_acts_xxx tables,
meaning mlx5e_tc_act_get() will always return you NULL  and that check
is hit before you check for ACT_PIPE.

Something not obvious to me:
Would all these drivers now be able to handle ACT_PIPE transparently as if no
action is specified? Cant see the obvious connection to POLICE by just
staring at
the patch - is there and ACT_PIPE first then a POLICE?
 Another question:
If the ACT_PIPE count is not being updated in s/w - is there a h/w
equivalent stat
being updated?

cheers,
jamal


On Tue, Nov 22, 2022 at 6:21 AM Simon Horman <simon.horman@corigine.com> wrote:
>
> From: Tianyu Yuan <tianyu.yuan@corigine.com>
>
> Support gact with PIPE action when setting up gact in TC.
> This PIPE gact could come first in each tc filter to update
> the filter(flow) stats.
>
> The stats for each actons in a filter are updated by the
> flower stats from HW(via netdev drivers) in kernel TC rather
> than drivers.
>
> In each netdev driver, we don't have to process this gact, but
> only to ignore it to make sure the whole rule can be offloaded.
>
> Background:
>
> This is a proposed solution to a problem with a miss-match between TC
> police action instances - which may be shared between flows - and OpenFlow
> meter actions - the action is per flow, while the underlying meter may be
> shared. The key problem being that the police action statistics are shared
> between flows, and this does not match the requirement of OpenFlow for
> per-flow statistics.
>
> Ref: [ovs-dev] [PATCH] tests: fix reference output for meter offload stats
>      https://mail.openvswitch.org/pipermail/ovs-dev/2022-October/398363.html
>
> Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c                     | 5 +++++
>  drivers/net/dsa/sja1105/sja1105_flower.c                   | 5 +++++
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c       | 5 +++++
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 6 ++++++
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c                | 5 +++++
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c       | 5 +++++
>  drivers/net/ethernet/marvell/prestera/prestera_flower.c    | 5 +++++
>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c            | 5 +++++
>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c        | 6 ++++++
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 5 +++++
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c      | 5 +++++
>  drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c   | 4 ++++
>  drivers/net/ethernet/mscc/ocelot_flower.c                  | 5 +++++
>  drivers/net/ethernet/netronome/nfp/flower/action.c         | 5 +++++
>  drivers/net/ethernet/qlogic/qede/qede_filter.c             | 5 +++++
>
                              | 5 +++++
>  drivers/net/ethernet/ti/cpsw_priv.c                        | 5 +++++
>  net/sched/act_gact.c                                       | 7 ++++---
>  18 files changed, 90 insertions(+), 3 deletions(-)
>
>
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index b0ae8d6156f6..e54eb8e28386 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -2217,6 +2217,11 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
>                         sfi.fmid = index;
>                         sfi.maxsdu = a->police.mtu;
>                         break;
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         mutex_unlock(&psfp->lock);
>                         return -EOPNOTSUPP;
> diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
> index fad5afe3819c..d3eeeeea152a 100644
> --- a/drivers/net/dsa/sja1105/sja1105_flower.c
> +++ b/drivers/net/dsa/sja1105/sja1105_flower.c
> @@ -426,6 +426,11 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
>                         if (rc)
>                                 goto out;
>                         break;
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         NL_SET_ERR_MSG_MOD(extack,
>                                            "Action not supported");
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> index dd9be229819a..443f405c0ed4 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> @@ -770,6 +770,11 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
>                 case FLOW_ACTION_QUEUE:
>                         /* Do nothing. cxgb4_set_filter will validate */
>                         break;
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         netdev_err(dev, "%s: Unsupported action\n", __func__);
>                         return -EOPNOTSUPP;
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> index cacd454ac696..cfbf2f76e83a 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> @@ -378,6 +378,11 @@ static int dpaa2_switch_tc_parse_action_acl(struct ethsw_core *ethsw,
>         case FLOW_ACTION_DROP:
>                 dpsw_act->action = DPSW_ACL_ACTION_DROP;
>                 break;
> +       /* Just ignore GACT with pipe action to let this action count the packets.
> +        * The NIC doesn't have to process this action
> +        */
> +       case FLOW_ACTION_PIPE:
> +               break;
>         default:
>                 NL_SET_ERR_MSG_MOD(extack,
>                                    "Action not supported");
> @@ -651,6 +656,7 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
>         case FLOW_ACTION_REDIRECT:
>         case FLOW_ACTION_TRAP:
>         case FLOW_ACTION_DROP:
> +       case FLOW_ACTION_PIPE:
>                 return dpaa2_switch_cls_flower_replace_acl(block, cls);
>         case FLOW_ACTION_MIRRED:
>                 return dpaa2_switch_cls_flower_replace_mirror(block, cls);
> diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> index faba0f857cd9..5908ad4d0170 100644
> --- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> @@ -642,6 +642,11 @@ ice_eswitch_tc_parse_action(struct ice_tc_flower_fltr *fltr,
>
>                 break;
>
> +       /* Just ignore GACT with pipe action to let this action count the packets.
> +        * The NIC doesn't have to process this action
> +        */
> +       case FLOW_ACTION_PIPE:
> +               break;
>         default:
>                 NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported action in switchdev mode");
>                 return -EINVAL;
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> index e64318c110fd..fc05897adb70 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> @@ -450,6 +450,11 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
>                 case FLOW_ACTION_MARK:
>                         mark = act->mark;
>                         break;
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         return -EOPNOTSUPP;
>                 }
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> index 91a478b75cbf..9686ed086e35 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> @@ -126,6 +126,11 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
>                         if (err)
>                                 return err;
>                         break;
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
>                         pr_err("Unsupported action\n");
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> index 81afd5ee3fbf..91e4d3fcc756 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> @@ -344,6 +344,11 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
>                         data.pppoe.sid = act->pppoe.sid;
>                         data.pppoe.num++;
>                         break;
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         return -EOPNOTSUPP;
>                 }
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> index b08339d986d5..231660cb1daf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> @@ -544,6 +544,12 @@ mlx5e_rep_indr_replace_act(struct mlx5e_rep_priv *rpriv,
>                 if (!act->offload_action)
>                         continue;
>
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               if (action->id == FLOW_ACTION_PIPE)
> +                       continue;
> +
>                 if (!act->offload_action(priv, fl_act, action))
>                         add = true;
>         }
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 3782f0097292..adac2ce9b24f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -3853,6 +3853,11 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
>
>         flow_action_for_each(i, _act, &flow_action_reorder) {
>                 act = *_act;
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               if (act->id == FLOW_ACTION_PIPE)
> +                       continue;
>                 tc_act = mlx5e_tc_act_get(act->id, ns_type);
>                 if (!tc_act) {
>                         NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> index e91fb205e0b4..9270bf9581c7 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> @@ -266,6 +266,11 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
>                                 return err;
>                         break;
>                         }
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
>                         dev_err(mlxsw_sp->bus_info->dev, "Unsupported action\n");
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> index bd6bd380ba34..e32f5b5d1e95 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> @@ -692,6 +692,10 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
>                         break;
>                 case FLOW_ACTION_GOTO:
>                         /* Links between VCAPs will be added later */
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
>                         break;
>                 default:
>                         NL_SET_ERR_MSG_MOD(fco->common.extack,
> diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
> index 7c0897e779dc..b8e01af0fb48 100644
> --- a/drivers/net/ethernet/mscc/ocelot_flower.c
> +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
> @@ -492,6 +492,11 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
>                         }
>                         filter->type = OCELOT_PSFP_FILTER_OFFLOAD;
>                         break;
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         NL_SET_ERR_MSG_MOD(extack, "Cannot offload action");
>                         return -EOPNOTSUPP;
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
> index 2b383d92d7f5..57fd83b8e54a 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/action.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
> @@ -1209,6 +1209,11 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
>                 if (err)
>                         return err;
>                 break;
> +       /* Just ignore GACT with pipe action to let this action count the packets.
> +        * The NIC doesn't have to process this action
> +        */
> +       case FLOW_ACTION_PIPE:
> +               break;
>         default:
>                 /* Currently we do not handle any other actions. */
>                 NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported action in action list");
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
> index 3010833ddde3..69110d5978d8 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
> @@ -1691,6 +1691,11 @@ static int qede_parse_actions(struct qede_dev *edev,
>                                 return -EINVAL;
>                         }
>                         break;
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         return -EINVAL;
>                 }
> diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
> index deeaab9ee761..7256bbcdcc59 100644
> --- a/drivers/net/ethernet/sfc/tc.c
> +++ b/drivers/net/ethernet/sfc/tc.c
> @@ -494,6 +494,11 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
>                         }
>                         *act = save;
>                         break;
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
>                                                fa->id);
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
> index 758295c898ac..c0ac58db64d4 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.c
> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> @@ -1492,6 +1492,11 @@ static int cpsw_qos_configure_clsflower(struct cpsw_priv *priv, struct flow_cls_
>
>                         return cpsw_qos_clsflower_add_policer(priv, extack, cls,
>                                                               act->police.rate_pkt_ps);
> +               /* Just ignore GACT with pipe action to let this action count the packets.
> +                * The NIC doesn't have to process this action
> +                */
> +               case FLOW_ACTION_PIPE:
> +                       break;
>                 default:
>                         NL_SET_ERR_MSG_MOD(extack, "Action not supported");
>                         return -EOPNOTSUPP;
> diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
> index 62d682b96b88..82d1371e251e 100644
> --- a/net/sched/act_gact.c
> +++ b/net/sched/act_gact.c
> @@ -250,15 +250,14 @@ static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
>                 } else if (is_tcf_gact_goto_chain(act)) {
>                         entry->id = FLOW_ACTION_GOTO;
>                         entry->chain_index = tcf_gact_goto_chain_index(act);
> +               } else if (is_tcf_gact_pipe(act)) {
> +                       entry->id = FLOW_ACTION_PIPE;
>                 } else if (is_tcf_gact_continue(act)) {
>                         NL_SET_ERR_MSG_MOD(extack, "Offload of \"continue\" action is not supported");
>                         return -EOPNOTSUPP;
>                 } else if (is_tcf_gact_reclassify(act)) {
>                         NL_SET_ERR_MSG_MOD(extack, "Offload of \"reclassify\" action is not supported");
>                         return -EOPNOTSUPP;
> -               } else if (is_tcf_gact_pipe(act)) {
> -                       NL_SET_ERR_MSG_MOD(extack, "Offload of \"pipe\" action is not supported");
> -                       return -EOPNOTSUPP;
>                 } else {
>                         NL_SET_ERR_MSG_MOD(extack, "Unsupported generic action offload");
>                         return -EOPNOTSUPP;
> @@ -275,6 +274,8 @@ static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
>                         fl_action->id = FLOW_ACTION_TRAP;
>                 else if (is_tcf_gact_goto_chain(act))
>                         fl_action->id = FLOW_ACTION_GOTO;
> +               else if (is_tcf_gact_pipe(act))
> +                       fl_action->id = FLOW_ACTION_PIPE;
>                 else
>                         return -EOPNOTSUPP;
>         }
> --
> 2.30.2
>
