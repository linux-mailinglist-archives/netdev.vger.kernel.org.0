Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4722AD061
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 08:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgKJHXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 02:23:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgKJHXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 02:23:21 -0500
Received: from ogabbay-VM.habana-labs.com (unknown [213.57.90.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C0E7206B6;
        Tue, 10 Nov 2020 07:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604993000;
        bh=8Qz8LIUkTxY5/gc9OeAz1JzdfBTeCe2Bc+FW79CrHvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lxwipDA750+LxYCIEu3zmzw/pUVmCg7SnCXTV+tkp+uRd9HfS7hzKE6EWuqiSM04n
         JSYs2z775lphf/o41x7822LhK8kSvzL+ukiWXd7qO3bbsyTc3toL9GerxI+wnwO5Bn
         C0q4F0UuQnc+RBfkG6lgigyNFmnbFtw8EbA34xTQ=
Date:   Tue, 10 Nov 2020 09:23:10 +0200
From:   Oded Gabbay <ogabbay@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
Message-ID: <20201110072309.GA6508@ogabbay-VM.habana-labs.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <BY5PR12MB43228923300FDE8B087DC4E9DCEE0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAPcyv4h1LH+ojRGqvh_R6mfuBbsibGa8DNMG5M1sN5G1BgwiHw@mail.gmail.com>
 <BY5PR12MB43222D59CCCFCF368C357098DCEE0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201106193537.GH49612@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106193537.GH49612@sirena.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 07:35:37PM +0000, Mark Brown wrote:
> On Thu, Nov 05, 2020 at 08:37:14PM +0000, Parav Pandit wrote:
> 
> > > > This example describes the mlx5 PCI subfunction use case.
> > > > I didn't follow your question about 'explicit example'.
> > > > What part is missing to identify it as explicit example?
> 
> > > Specifically listing "mlx5" so if someone reading this document thinks to
> > > themselves "hey mlx5 sounds like my use case" they can go grep for that.
> 
> > Ah, I see.
> > "mlx5" is not listed explicitly, because it is not included in this patchset.
> > In various previous discussions in this thread, mlx5 subfunction use case is described that justifies the existence of the bus.
> > I will be happy to update this documentation once mlx5 subfunction will be part of kernel so that grep actually shows valid output.
> > (waiting to post them as it uses auxiliary bus :-)).
> 
> For ease of review if there's a new version it might be as well to just
> reference it anyway, hopefully the mlx5 code will be merged fairly
> quickly once the bus itself is merged.  It's probably easier all round
> than adding the reference later, it seems more likely that mlx5 will get
> merged than that it'll fall by the wayside.

Another use-case for this patch-set is going to be the habanalabs driver.
The GAUDI ASIC is a PCI H/W accelerator for deep-learning which also exposes 
network ports.We are going to use this auxiliary-bus feature to separate our 
monolithic driver into several parts that will reside in different subsystems 
and communicate between them through the bus.

Thanks,
Oded
