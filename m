Return-Path: <netdev+bounces-2925-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5387048FB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 248972813A9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DADE5156F4;
	Tue, 16 May 2023 09:20:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FC32C726
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:20:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420C346A0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684228718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mcbTxJI/+TAXLUUngQWKSIBa3adWDQR1Ogvv/W18c2c=;
	b=C19HttBwlwjy7SeFE9B7U2JlFCYOpAPtZ+vBt2qudGQl/v+uEcEBEhXPHgrsuoIWjF2DgU
	enCHmIp/TP/KDMWBRYaD6dmFQ48wPYoTmFfCC43mgr60BiyMGBXamwSi8q1l2k9yyg9l4I
	yLHU94qPbsKhwwpQs68CgBwOBjJ0mpw=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-AaaO0FE1ORSympCMepxGmg-1; Tue, 16 May 2023 05:18:37 -0400
X-MC-Unique: AaaO0FE1ORSympCMepxGmg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4f2732c09feso3042804e87.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684228714; x=1686820714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mcbTxJI/+TAXLUUngQWKSIBa3adWDQR1Ogvv/W18c2c=;
        b=XoQrqgiPilL3U5ZVTd5vxL/DiclQpaVWrqwdmGTCTq2RcAi7vBkptC75Bs0ZGzySyU
         fxBNXjhjMKRSfiJTVcXmyTuJHkCS0XwICxnfBH6uuUfryi5sCP+TxZiKjfcokQlVUxlm
         olgSVgZfy21xwAWPz08CS9ZrbV9n1ArxDSTomh5e5oTxsOvBjcybQQx0kAA0aOTRcxu1
         jX4TB6ZMGu35BUlzpNtpLFvng3//KRPakEgXgG789fwlA/EfEKGXHn1oX3aJmB58ViIZ
         wka/ciakY0pJZTNhgqngb0vqnUBTsAp1KG6qnrHnAYloOgwCKbvQ+mfKyGdjimERRg3m
         Qspg==
X-Gm-Message-State: AC+VfDxlYoRNdTNcEM+GSnBPfC/917xia9Am+/f/jEPwsra7RWZaWLf9
	zObNk8ihe34UltsTRPVv5r92iTy6USpoNxzPLLvILh0OAAqA553dKvXlIANvZpRTDgi3/g7um8q
	Mq/Ru9hLNw/yAi0EhXgu9f3TMKDU/omrq
X-Received: by 2002:a19:a40f:0:b0:4f1:3b59:44cc with SMTP id q15-20020a19a40f000000b004f13b5944ccmr7214680lfc.57.1684228714033;
        Tue, 16 May 2023 02:18:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ssXBhOVIBc95sNG6A9APVoanrVBJQfDvonmQ3S0MaOLfxX6yicuHlBDrHa0f0nC5rolj5degOoss5CUcsJCk=
X-Received: by 2002:a19:a40f:0:b0:4f1:3b59:44cc with SMTP id
 q15-20020a19a40f000000b004f13b5944ccmr7214674lfc.57.1684228713617; Tue, 16
 May 2023 02:18:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230512090652.190058-1-wojciech.drewek@intel.com>
In-Reply-To: <20230512090652.190058-1-wojciech.drewek@intel.com>
From: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date: Tue, 16 May 2023 11:18:22 +0200
Message-ID: <CACT4oueyxJT2Xb5uojaKFAQ-R4nBQr5o457g2nfNsKDQPYEXvw@mail.gmail.com>
Subject: Re: [PATCH iwl-next] ice: Remove LAG+SRIOV mutual exclusion
To: Wojciech Drewek <wojciech.drewek@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org, 
	david.m.ertman@intel.com, mschmidt@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 11:08=E2=80=AFAM Wojciech Drewek
<wojciech.drewek@intel.com> wrote:
>
> From: Dave Ertman <david.m.ertman@intel.com>
>
> There was a change previously to stop SR-IOV and LAG from existing on the
> same interface.  This was to prevent the violation of LACP (Link
> Aggregation Control Protocol).  The method to achieve this was to add a
> no-op Rx handler onto the netdev when SR-IOV VFs were present, thus
> blocking bonding, bridging, etc from claiming the interface by adding
> its own Rx handler.  Also, when an interface was added into a aggregate,
> then the SR-IOV capability was set to false.
>
> There are some users that have in house solutions using both SR-IOV and
> bridging/bonding that this method interferes with (e.g. creating duplicat=
e
> VFs on the bonded interfaces and failing between them when the interface
> fails over).
>
> It makes more sense to provide the most functionality
> possible, the restriction on co-existence of these features will be
> removed.  No additional functionality is currently being provided beyond
> what existed before the co-existence restriction was put into place.  It =
is
> up to the end user to not implement a solution that would interfere with
> existing network protocols.
>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
>  .../device_drivers/ethernet/intel/ice.rst     | 18 -------
>  drivers/net/ethernet/intel/ice/ice.h          | 19 -------
>  drivers/net/ethernet/intel/ice/ice_lag.c      | 12 -----
>  drivers/net/ethernet/intel/ice/ice_lag.h      | 53 -------------------
>  drivers/net/ethernet/intel/ice/ice_lib.c      |  2 -
>  drivers/net/ethernet/intel/ice/ice_sriov.c    |  4 --
>  6 files changed, 108 deletions(-)
>
> diff --git a/Documentation/networking/device_drivers/ethernet/intel/ice.r=
st b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
> index 69695e5511f4..e4d065c55ea8 100644
> --- a/Documentation/networking/device_drivers/ethernet/intel/ice.rst
> +++ b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
> @@ -84,24 +84,6 @@ Once the VM shuts down, or otherwise releases the VF, =
the command will
>  complete.
>
>
> -Important notes for SR-IOV and Link Aggregation
> ------------------------------------------------
> -Link Aggregation is mutually exclusive with SR-IOV.
> -
> -- If Link Aggregation is active, SR-IOV VFs cannot be created on the PF.
> -- If SR-IOV is active, you cannot set up Link Aggregation on the interfa=
ce.
> -
> -Bridging and MACVLAN are also affected by this. If you wish to use bridg=
ing or
> -MACVLAN with SR-IOV, you must set up bridging or MACVLAN before enabling
> -SR-IOV. If you are using bridging or MACVLAN in conjunction with SR-IOV,=
 and
> -you want to remove the interface from the bridge or MACVLAN, you must fo=
llow
> -these steps:
> -
> -1. Destroy SR-IOV VFs if they exist
> -2. Remove the interface from the bridge or MACVLAN
> -3. Recreate SRIOV VFs as needed
> -
> -
>  Additional Features and Configurations
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/=
intel/ice/ice.h
> index 8b016511561f..b4bca1d964a9 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -814,25 +814,6 @@ static inline bool ice_is_switchdev_running(struct i=
ce_pf *pf)
>         return pf->switchdev.is_running;
>  }
>
> -/**
> - * ice_set_sriov_cap - enable SRIOV in PF flags
> - * @pf: PF struct
> - */
> -static inline void ice_set_sriov_cap(struct ice_pf *pf)
> -{
> -       if (pf->hw.func_caps.common_cap.sr_iov_1_1)
> -               set_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
> -}
> -
> -/**
> - * ice_clear_sriov_cap - disable SRIOV in PF flags
> - * @pf: PF struct
> - */
> -static inline void ice_clear_sriov_cap(struct ice_pf *pf)
> -{
> -       clear_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
> -}
> -
>  #define ICE_FD_STAT_CTR_BLOCK_COUNT    256
>  #define ICE_FD_STAT_PF_IDX(base_idx) \
>                         ((base_idx) * ICE_FD_STAT_CTR_BLOCK_COUNT)
> diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ether=
net/intel/ice/ice_lag.c
> index ee5b36941ba3..5a7753bda324 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lag.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lag.c
> @@ -6,15 +6,6 @@
>  #include "ice.h"
>  #include "ice_lag.h"
>
> -/**
> - * ice_lag_nop_handler - no-op Rx handler to disable LAG
> - * @pskb: pointer to skb pointer
> - */
> -rx_handler_result_t ice_lag_nop_handler(struct sk_buff __always_unused *=
*pskb)
> -{
> -       return RX_HANDLER_PASS;
> -}
> -
>  /**
>   * ice_lag_set_primary - set PF LAG state as Primary
>   * @lag: LAG info struct
> @@ -158,7 +149,6 @@ ice_lag_link(struct ice_lag *lag, struct netdev_notif=
ier_changeupper_info *info)
>                 lag->upper_netdev =3D upper;
>         }
>
> -       ice_clear_sriov_cap(pf);
>         ice_clear_rdma_cap(pf);
>
>         lag->bonded =3D true;
> @@ -205,7 +195,6 @@ ice_lag_unlink(struct ice_lag *lag,
>         }
>
>         lag->peer_netdev =3D NULL;
> -       ice_set_sriov_cap(pf);
>         ice_set_rdma_cap(pf);
>         lag->bonded =3D false;
>         lag->role =3D ICE_LAG_NONE;
> @@ -229,7 +218,6 @@ static void ice_lag_unregister(struct ice_lag *lag, s=
truct net_device *netdev)
>         if (lag->upper_netdev) {
>                 dev_put(lag->upper_netdev);
>                 lag->upper_netdev =3D NULL;
> -               ice_set_sriov_cap(pf);
>                 ice_set_rdma_cap(pf);
>         }
>         /* perform some cleanup in case we come back */
> diff --git a/drivers/net/ethernet/intel/ice/ice_lag.h b/drivers/net/ether=
net/intel/ice/ice_lag.h
> index 51b5cf467ce2..54d6663fe586 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lag.h
> +++ b/drivers/net/ethernet/intel/ice/ice_lag.h
> @@ -26,62 +26,9 @@ struct ice_lag {
>         u8 bonded:1; /* currently bonded */
>         u8 primary:1; /* this is primary */
>         u8 handler:1; /* did we register a rx_netdev_handler */

"handler" field seems unused now, shouldn't it be removed?

> -       /* each thing blocking bonding will increment this value by one.
> -        * If this value is zero, then bonding is allowed.
> -        */
> -       u16 dis_lag;
>         u8 role;
>  };
>
>  int ice_init_lag(struct ice_pf *pf);
>  void ice_deinit_lag(struct ice_pf *pf);
> -rx_handler_result_t ice_lag_nop_handler(struct sk_buff **pskb);
> -
> -/**
> - * ice_disable_lag - increment LAG disable count
> - * @lag: LAG struct
> - */
> -static inline void ice_disable_lag(struct ice_lag *lag)
> -{
> -       /* If LAG this PF is not already disabled, disable it */
> -       rtnl_lock();
> -       if (!netdev_is_rx_handler_busy(lag->netdev)) {
> -               if (!netdev_rx_handler_register(lag->netdev,
> -                                               ice_lag_nop_handler,
> -                                               NULL))
> -                       lag->handler =3D true;
> -       }
> -       rtnl_unlock();
> -       lag->dis_lag++;
> -}
> -
> -/**
> - * ice_enable_lag - decrement disable count for a PF
> - * @lag: LAG struct
> - *
> - * Decrement the disable counter for a port, and if that count reaches
> - * zero, then remove the no-op Rx handler from that netdev
> - */
> -static inline void ice_enable_lag(struct ice_lag *lag)
> -{
> -       if (lag->dis_lag)
> -               lag->dis_lag--;
> -       if (!lag->dis_lag && lag->handler) {
> -               rtnl_lock();
> -               netdev_rx_handler_unregister(lag->netdev);
> -               rtnl_unlock();
> -               lag->handler =3D false;
> -       }
> -}
> -
> -/**
> - * ice_is_lag_dis - is LAG disabled
> - * @lag: LAG struct
> - *
> - * Return true if bonding is disabled
> - */
> -static inline bool ice_is_lag_dis(struct ice_lag *lag)
> -{
> -       return !!(lag->dis_lag);
> -}
>  #endif /* _ICE_LAG_H_ */
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ether=
net/intel/ice/ice_lib.c
> index d9731476cd7f..5ddb95d1073a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -2712,8 +2712,6 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_vsi_cfg=
_params *params)
>         return vsi;
>
>  err_vsi_cfg:
> -       if (params->type =3D=3D ICE_VSI_VF)
> -               ice_enable_lag(pf->lag);
>         ice_vsi_free(vsi);
>
>         return NULL;
> diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/eth=
ernet/intel/ice/ice_sriov.c
> index 9788f363e9dc..a222cd702fd5 100644
> --- a/drivers/net/ethernet/intel/ice/ice_sriov.c
> +++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
> @@ -960,8 +960,6 @@ int ice_sriov_configure(struct pci_dev *pdev, int num=
_vfs)
>         if (!num_vfs) {
>                 if (!pci_vfs_assigned(pdev)) {
>                         ice_free_vfs(pf);
> -                       if (pf->lag)
> -                               ice_enable_lag(pf->lag);
>                         return 0;
>                 }
>
> @@ -973,8 +971,6 @@ int ice_sriov_configure(struct pci_dev *pdev, int num=
_vfs)
>         if (err)
>                 return err;
>
> -       if (pf->lag)
> -               ice_disable_lag(pf->lag);
>         return num_vfs;
>  }
>
> --
> 2.39.2
>
>


--=20
=C3=8D=C3=B1igo Huguet


