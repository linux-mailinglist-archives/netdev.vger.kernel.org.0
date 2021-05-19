Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFB2389418
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 18:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346886AbhESQwa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 May 2021 12:52:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:61256 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhESQw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 12:52:29 -0400
IronPort-SDR: T/xXcxwxCkuiEG8JRUR+S+wdYRvRPXtwmI9rakNAtGDGtyotu+q/IlykfaZ5IEoQA+CSlaysxa
 M1XsX8olfPgg==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="199069922"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="199069922"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 09:51:07 -0700
IronPort-SDR: 0HJIXBsY4mqJ83z83rg009k3Mepv13D5Zk/wxUloJvidVlSL0wQWTrdJmMhe/dzxRx9fcvObHU
 1Znrp/meHI0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="474705023"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 19 May 2021 09:51:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 19 May 2021 09:51:07 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 19 May 2021 09:51:06 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2242.008;
 Wed, 19 May 2021 09:51:06 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v5 04/22] ice: Register auxiliary device to provide RDMA
Thread-Topic: [PATCH v5 04/22] ice: Register auxiliary device to provide RDMA
Thread-Index: AQHXSMuMvoayh0T7Lk+ep81rwUQRcKrrKKeA///hnyA=
Date:   Wed, 19 May 2021 16:51:06 +0000
Message-ID: <27f0949d3dd64443bc992d433612b6c7@intel.com>
References: <20210514141214.2120-1-shiraz.saleem@intel.com>
 <20210514141214.2120-5-shiraz.saleem@intel.com> <YKT292HPpKRmzDC4@unreal>
In-Reply-To: <YKT292HPpKRmzDC4@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v5 04/22] ice: Register auxiliary device to provide RDMA
> 
> On Fri, May 14, 2021 at 09:11:56AM -0500, Shiraz Saleem wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > Register ice client auxiliary RDMA device on the auxiliary bus per
> > PCIe device function for the auxiliary driver (irdma) to attach to.
> > It allows to realize a single RDMA driver (irdma) capable of working
> > with multiple netdev drivers over multi-generation Intel HW supporting RDMA.
> > There is no load ordering dependencies between ice and irdma.
> >
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  drivers/net/ethernet/intel/Kconfig        |  1 +
> >  drivers/net/ethernet/intel/ice/ice.h      |  8 +++-
> >  drivers/net/ethernet/intel/ice/ice_idc.c  | 71
> > ++++++++++++++++++++++++++++++-
> > drivers/net/ethernet/intel/ice/ice_main.c | 11 ++++-
> >  4 files changed, 87 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/Kconfig
> > b/drivers/net/ethernet/intel/Kconfig
> > index c1d1556..d8a12da 100644
> > --- a/drivers/net/ethernet/intel/Kconfig
> > +++ b/drivers/net/ethernet/intel/Kconfig
> > @@ -294,6 +294,7 @@ config ICE
> >  	tristate "Intel(R) Ethernet Connection E800 Series Support"
> >  	default n
> >  	depends on PCI_MSI
> > +	select AUXILIARY_BUS
> >  	select DIMLIB
> >  	select NET_DEVLINK
> >  	select PLDMFW
> > diff --git a/drivers/net/ethernet/intel/ice/ice.h
> > b/drivers/net/ethernet/intel/ice/ice.h
> > index 225f8a5..228055e 100644
> > --- a/drivers/net/ethernet/intel/ice/ice.h
> > +++ b/drivers/net/ethernet/intel/ice/ice.h
> > @@ -34,6 +34,7 @@
> >  #include <linux/if_bridge.h>
> >  #include <linux/ctype.h>
> >  #include <linux/bpf.h>
> > +#include <linux/auxiliary_bus.h>
> >  #include <linux/avf/virtchnl.h>
> >  #include <linux/cpu_rmap.h>
> >  #include <linux/dim.h>
> > @@ -647,6 +648,8 @@ static inline void ice_clear_sriov_cap(struct
> > ice_pf *pf)  void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16
> > rss_size);  int ice_schedule_reset(struct ice_pf *pf, enum
> > ice_reset_req reset);  void ice_print_link_msg(struct ice_vsi *vsi,
> > bool isup);
> > +int ice_plug_aux_dev(struct ice_pf *pf); void
> > +ice_unplug_aux_dev(struct ice_pf *pf);
> >  int ice_init_rdma(struct ice_pf *pf);  const char *ice_stat_str(enum
> > ice_status stat_err);  const char *ice_aq_str(enum ice_aq_err aq_err);
> > @@ -678,8 +681,10 @@ int ice_aq_wait_for_event(struct ice_pf *pf, u16
> opcode, unsigned long timeout,
> >   */
> >  static inline void ice_set_rdma_cap(struct ice_pf *pf)  {
> > -	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix)
> > +	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix) {
> >  		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
> > +		ice_plug_aux_dev(pf);
> > +	}
> >  }
> >
> >  /**
> > @@ -688,6 +693,7 @@ static inline void ice_set_rdma_cap(struct ice_pf *pf)
> >   */
> >  static inline void ice_clear_rdma_cap(struct ice_pf *pf)  {
> > +	ice_unplug_aux_dev(pf);
> >  	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);  }  #endif /* _ICE_H_ */
> > diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c
> > b/drivers/net/ethernet/intel/ice/ice_idc.c
> > index ffca0d5..e7bb8f6 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_idc.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
> > @@ -255,6 +255,71 @@ static int ice_reserve_rdma_qvector(struct ice_pf
> > *pf)  }
> >
> >  /**
> > + * ice_adev_release - function to be mapped to AUX dev's release op
> > + * @dev: pointer to device to free
> > + */
> > +static void ice_adev_release(struct device *dev) {
> > +	struct iidc_auxiliary_dev *iadev;
> > +
> > +	iadev = container_of(dev, struct iidc_auxiliary_dev, adev.dev);
> > +	kfree(iadev);
> > +}
> > +
> > +/**
> > + * ice_plug_aux_dev - allocate and register AUX device
> > + * @pf: pointer to pf struct
> > + */
> > +int ice_plug_aux_dev(struct ice_pf *pf) {
> > +	struct iidc_auxiliary_dev *iadev;
> > +	struct auxiliary_device *adev;
> > +	int ret;
> > +
> > +	iadev = kzalloc(sizeof(*iadev), GFP_KERNEL);
> > +	if (!iadev)
> > +		return -ENOMEM;
> > +
> > +	adev = &iadev->adev;
> > +	pf->adev = adev;
> > +	iadev->pf = pf;
> > +
> > +	adev->id = pf->aux_idx;
> > +	adev->dev.release = ice_adev_release;
> > +	adev->dev.parent = &pf->pdev->dev;
> > +	adev->name = IIDC_RDMA_ROCE_NAME;
> 
> You declared IIDC_RDMA_ROCE_NAME as intel_rdma_roce, so it will create
> extremely awful device name, something like irdma.intel_rdma_roce.0

It is i40e.intel_rdma_iwarp.0 and ice.intel_rdma_roce.0.

> 
> I would say that "intel" and "rdma" can be probably dropped.
> 

I do not feel strongly about this and am ok with your request.

Shiraz
