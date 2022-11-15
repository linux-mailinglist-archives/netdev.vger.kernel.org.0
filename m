Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806F4629216
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiKOHAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiKOHAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:00:45 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EA365B0
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668495644; x=1700031644;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CHGIKomhVc9j2XHvy7ULB6e0SooPCWvnAIwmpNwi7+c=;
  b=H6n5ckFYYBnXldPGESAcLxLQpgA9T5gla5jHuOggDfSCnnGSj3mHTs25
   JoMu+R+5zvuJVhFEBvb2rlkj6ST0h2iflsYCalu/ilKV7X9Hp/joGqq2t
   ro1rKduMmjSUbOFRD74x3o+ouaheTYkgRSNFojWVcDQBIDUENXc263J3q
   sOvyaX4H/yppimd8SEzrbgiqVbaEwUguvMIpmsNPej1V6LGQDlDnFccZV
   XdVBPAbMwx9EtktdjbPuPhvLWJ2oIuz/eq2oebEkDrNAX51ZJ7bdKYfOs
   F9Rqa8eavAeTpMzB/6Om3BsqKmEsEa0fnH21WcjQY4gJe8jQ2802TfPGl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="398470920"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="398470920"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 23:00:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="707629281"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="707629281"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 23:00:31 -0800
Date:   Tue, 15 Nov 2022 08:00:28 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Drewek, Wojciech" <wojciech.drewek@intel.com>,
        "Czapnik, Lukasz" <lukasz.czapnik@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Kitszel, Przemyslaw" <przemyslaw.kitszel@intel.com>,
        "Raczynski, Piotr" <piotr.raczynski@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Kaliszczuk, Leszek" <leszek.kaliszczuk@intel.com>
Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
Message-ID: <Y3M5DOEhbAdbCtEC@localhost.localdomain>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
 <Y3JBaQ7+p5ncsjuW@unreal>
 <49e2792d-7580-e066-8d4e-183a9c826e68@intel.com>
 <CO1PR11MB5089C5B17D186C6FF17C5599D6059@CO1PR11MB5089.namprd11.prod.outlook.com>
 <Y3J2UEPHDKNL2n4O@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3J2UEPHDKNL2n4O@unreal>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 07:09:36PM +0200, Leon Romanovsky wrote:
> On Mon, Nov 14, 2022 at 04:58:57PM +0000, Keller, Jacob E wrote:
> > 
> > 
> > > -----Original Message-----
> > > From: Samudrala, Sridhar <sridhar.samudrala@intel.com>
> > > Sent: Monday, November 14, 2022 7:31 AM
> > > To: Leon Romanovsky <leon@kernel.org>; Michal Swiatkowski
> > > <michal.swiatkowski@linux.intel.com>
> > > Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org;
> > > pabeni@redhat.com; edumazet@google.com; intel-wired-lan@lists.osuosl.org;
> > > jiri@nvidia.com; Nguyen, Anthony L <anthony.l.nguyen@intel.com>; Lobakin,
> > > Alexandr <alexandr.lobakin@intel.com>; Drewek, Wojciech
> > > <wojciech.drewek@intel.com>; Czapnik, Lukasz <lukasz.czapnik@intel.com>;
> > > Saleem, Shiraz <shiraz.saleem@intel.com>; Brandeburg, Jesse
> > > <jesse.brandeburg@intel.com>; Ismail, Mustafa <mustafa.ismail@intel.com>;
> > > Kitszel, Przemyslaw <przemyslaw.kitszel@intel.com>; Raczynski, Piotr
> > > <piotr.raczynski@intel.com>; Keller, Jacob E <jacob.e.keller@intel.com>; Ertman,
> > > David M <david.m.ertman@intel.com>; Kaliszczuk, Leszek
> > > <leszek.kaliszczuk@intel.com>
> > > Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
> > > 
> > > On 11/14/2022 7:23 AM, Leon Romanovsky wrote:
> > > > On Mon, Nov 14, 2022 at 01:57:42PM +0100, Michal Swiatkowski wrote:
> > > >> Currently the default value for number of PF vectors is number of CPUs.
> > > >> Because of that there are cases when all vectors are used for PF
> > > >> and user can't create more VFs. It is hard to set default number of
> > > >> CPUs right for all different use cases. Instead allow user to choose
> > > >> how many vectors should be used for various features. After implementing
> > > >> subdevices this mechanism will be also used to set number of vectors
> > > >> for subfunctions.
> > > >>
> > > >> The idea is to set vectors for eth or VFs using devlink resource API.
> > > >> New value of vectors will be used after devlink reinit. Example
> > > >> commands:
> > > >> $ sudo devlink resource set pci/0000:31:00.0 path msix/msix_eth size 16
> > > >> $ sudo devlink dev reload pci/0000:31:00.0
> > > >> After reload driver will work with 16 vectors used for eth instead of
> > > >> num_cpus.
> > > > By saying "vectors", are you referring to MSI-X vectors?
> > > > If yes, you have specific interface for that.
> > > > https://lore.kernel.org/linux-pci/20210314124256.70253-1-leon@kernel.org/
> > > 
> > > This patch series is exposing a resources API to split the device level MSI-X vectors
> > > across the different functions supported by the device (PF, RDMA, SR-IOV VFs
> > > and
> > > in future subfunctions). Today this is all hidden in a policy implemented within
> > > the PF driver.
> > > 
> > > The patch you are referring to seems to be providing an interface to change the
> > > msix count for a particular VF. This patch is providing a interface to set the total
> > > msix count for all the possible VFs from the available device level pool of
> > > msix-vectors.
> > > 
> > 
> > It looks like we should implement both: resources to configure the "pool" of available vectors for each VF, and the sysfs VF Interface to allow configuring individual VFs.
> 
> Yes, to be aligned with PCI spec and see coherent lspci output for VFs.
> 
> Thanks
> 

Thanks, I will implement this sysf interface to configure individual
VFs.

> > 
> > Thanks,
> > Jake
