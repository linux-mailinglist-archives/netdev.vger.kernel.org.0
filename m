Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3D06E9B78
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjDTSU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjDTSU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:20:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3714218
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 11:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52F7261143
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399B7C433D2;
        Thu, 20 Apr 2023 18:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682014822;
        bh=/nTndpJPM0yhE1yF/A5Q9XjpDyvDelW6bgesKMV/klA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fCryIz0Mg46LzLpzSUX+UYi4RJOVoBhWAG7i72Y5jCiEhMVUND1s8S0bSv8R6VEmM
         u57PWUAofzstyj3FW4xRFPoUfJlC+LbF/Kn33HhcfFHzbmm6E1obMrYgcq9xz1iXb4
         i1AtQ2z8zPJQ3js7Pi8AzRm4CyyPn+SgD2MlFWRkRMPUM84sHduFKwYRCWwN4t3FrA
         ka6Top+HICdMRlMD+k/tle/IyUrWG3ADa1yD8rkc6+13olwlp3BvxCrnSJwpsG/DEt
         e5ZA7RzDd2B6yo+0jYWB+6EB9958rxnuMQ9YouDJWRjyPAVZ6mHU3Jdth7PQH8ROy+
         DWxxfTnboAvbg==
Date:   Thu, 20 Apr 2023 21:20:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Tantilov, Emil S" <emil.s.tantilov@intel.com>
Cc:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        willemb@google.com, pabeni@redhat.com,
        Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        kuba@kernel.org, edumazet@google.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org,
        Phani Burra <phani.r.burra@intel.com>, decot@google.com,
        davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 02/15] idpf: add module
 register and probe functionality
Message-ID: <20230420182018.GF4423@unreal>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <20230411011354.2619359-3-pavan.kumar.linga@intel.com>
 <20230411123653.GW182481@unreal>
 <b6ed7b0b-9262-3578-1d88-4c848d1aea82@intel.com>
 <4640cb7c-faac-d548-b0dd-4519396e9f25@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4640cb7c-faac-d548-b0dd-4519396e9f25@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 11:13:09AM -0700, Tantilov, Emil S wrote:
> 
> 
> On 4/12/2023 4:10 PM, Tantilov, Emil S wrote:
> > 
> > 
> > On 4/11/2023 5:36 AM, Leon Romanovsky wrote:
> > > On Mon, Apr 10, 2023 at 06:13:41PM -0700, Pavan Kumar Linga wrote:
> > > > From: Phani Burra <phani.r.burra@intel.com>
> > > > 
> > > > Add the required support to register IDPF PCI driver, as well as
> > > > probe and remove call backs. Enable the PCI device and request
> > > > the kernel to reserve the memory resources that will be used by the
> > > > driver. Finally map the BAR0 address space.
> > > > 
> > > > PCI IDs table is intentionally left blank to prevent the kernel from
> > > > probing the device with the incomplete driver. It will be added
> > > > in the last patch of the series.
> > > > 
> > > > Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> > > > Co-developed-by: Alan Brady <alan.brady@intel.com>
> > > > Signed-off-by: Alan Brady <alan.brady@intel.com>
> > > > Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> > > > Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> > > > Co-developed-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> > > > Signed-off-by: Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
> > > > Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> > > > Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> > > > Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> > > > Reviewed-by: Willem de Bruijn <willemb@google.com>
> > > > ---
> > > >   drivers/net/ethernet/intel/Kconfig            | 11 +++
> > > >   drivers/net/ethernet/intel/Makefile           |  1 +
> > > >   drivers/net/ethernet/intel/idpf/Makefile      | 10 ++
> > > >   drivers/net/ethernet/intel/idpf/idpf.h        | 27 ++++++
> > > >   .../net/ethernet/intel/idpf/idpf_controlq.h   | 14 +++
> > > >   drivers/net/ethernet/intel/idpf/idpf_lib.c    | 96 +++++++++++++++++++
> > > >   drivers/net/ethernet/intel/idpf/idpf_main.c   | 70 ++++++++++++++
> > > >   7 files changed, 229 insertions(+)
> > > >   create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
> > > >   create mode 100644 drivers/net/ethernet/intel/idpf/idpf.h
> > > >   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.h
> > > >   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lib.c
> > > >   create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c
> > > 
> > > <...>
> > > > +}
> > > > +
> > > > +/* idpf_pci_tbl - PCI Dev idpf ID Table
> > > > + */
> > > > +static const struct pci_device_id idpf_pci_tbl[] = {
> > > > +    { /* Sentinel */ }
> > > 
> > > What does it mean empty pci_device_id table?
> > 
> > Device ID's are added later, but it does make sense to be in this patch
> > instead. Will fix in v3.
> 
> On second look, the reason PCI ids are added in the last patch is because
> none of the modules from the previous patches would result in a functional
> driver.

And yet patches should be split to meaningful and logical chunks. If
you add pci_device_id, please add relevant device at the same patch.

Thanks

> 
> Thanks,
> Emil
