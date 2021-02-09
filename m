Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90C4314914
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBIGrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:47:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhBIGrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 01:47:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D2A064E10;
        Tue,  9 Feb 2021 06:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612853226;
        bh=oKVovTKhvczU4tEQW9qNHoEeYMW424OaQMx5Tm6UnEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ClWO5PpuPiVLlKHZxmGpkUe+TlGwzWYGvfJQ/CfYtbK2UzsPUBeuMvVIWJ0bPvWcN
         D3FSFZ3Qc7iWUDuIwtIcTL2j2x9Cw3F/A9cbZsRSRXCctf3tJygl0likDzVLBxldM/
         jWw3YSxrT+Fw+/rb9s/nfX7A56b+x0wfpfeKcRycRHLEMYei0LEbAbhRpeKUX+JVGr
         s6AC2qnh0UTBP/ONyxzbpCqsgFutFembjHWPn9/x3rA2wHNYjJFbxJMEBC7R0B616w
         s1W9X8WfLcQ47zq8ZslNnDK/W0EsJSeLAqWDqdkGsfVwrPQTwi56tSBAoIJkVcJth6
         7++dGkGfKzGKw==
Date:   Tue, 9 Feb 2021 08:47:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Chris Mi <cmi@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210209064702.GB139298@unreal>
References: <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
 <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
 <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130144231.GA3329243@shredder.lan>
 <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
 <20210201180837.GB3456040@shredder.lan>
 <20210208070350.GB4656@unreal>
 <20210208085746.GA179437@shredder.lan>
 <20210208090702.GB20265@unreal>
 <20210208170735.GA207830@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210208170735.GA207830@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 07:07:35PM +0200, Ido Schimmel wrote:
> On Mon, Feb 08, 2021 at 11:07:02AM +0200, Leon Romanovsky wrote:
> > On Mon, Feb 08, 2021 at 10:57:46AM +0200, Ido Schimmel wrote:
> > > On Mon, Feb 08, 2021 at 09:03:50AM +0200, Leon Romanovsky wrote:
> > > > On Mon, Feb 01, 2021 at 08:08:37PM +0200, Ido Schimmel wrote:
> > > > > On Mon, Feb 01, 2021 at 09:37:11AM +0800, Chris Mi wrote:
> > > > > > Hi Ido,
> > > > > >
> > > > > > On 1/30/2021 10:42 PM, Ido Schimmel wrote:
> > > > > > > On Fri, Jan 29, 2021 at 12:30:09PM -0800, Jakub Kicinski wrote:
> > > > > > > > On Fri, 29 Jan 2021 14:08:39 +0800 Chris Mi wrote:
> > > > > > > > > Instead of discussing it several days, maybe it's better to review
> > > > > > > > > current patch, so that we can move forward :)
> > > > > > > > It took you 4 revisions to post a patch which builds cleanly and now
> > > > > > > > you want to hasten the review? My favorite kind of submission.
> > > > > > > >
> > > > > > > > The mlxsw core + spectrum drivers are 65 times the size of psample
> > > > > > > > on my system. Why is the dependency a problem?
> > > > > > > mlxsw has been using psample for ~4 years and I don't remember seeing a
> > > > > > > single complaint about the dependency. I don't understand why this patch
> > > > > > > is needed.
> > > > > > Please see Saeed's comment in previous email:
> > > > > >
> > > > > > "
> > > > > >
> > > > > > The issue is with distros who ship modules independently.. having a
> > > > > > hard dependency will make it impossible for basic mlx5_core.ko users to
> > > > > > load the driver when psample is not installed/loaded.
> > > > > >
> > > > > > I prefer to have 0 dependency on external modules in a HW driver.
> > > > > > "
> > > > >
> > > > > I saw it, but it basically comes down to personal preferences.
> > > >
> > > > It is more than personal preferences. In opposite to the mlxsw which is
> > > > used for netdev only, the mlx5_core is used by other subsystems, e.g. RDMA,
> > > > so Saeed's request to avoid extra dependencies makes sense.
> > > >
> > > > We don't need psample dependency to run RDMA traffic.
> > >
> > > Right, you don't need it. The dependency is "PSAMPLE || PSAMPLE=n". You
> > > can compile out psample and RDMA will work.
> >
> > So do you suggest to all our HPC users recompile their distribution kernel
> > just to make sure that psample is not called?
>
> I don't know. What are they complaining about? That psample needs to be
> installed for mlx5_core to be loaded? How come the rest of the
> dependencies are installed?

The psample module was first dependency that caught our attention. It is
here as an example of such not-needed dependency. Like Saeed said, we are
interested in more general solution that will allow us to use external
modules in fully dynamic mode.

Internally, as a preparation to the submission of mlx5 code that used nf_conntrack,
we found that restart of firewald service will bring down our mlx5_core driver, because
of such dependency.

So to answer on your question, HPC didn't complain yet, but we don't have any plans
to wait till they complain.

>
> Or are they complaining about the size / memory footprint of psample?
> Because then they should first check mlx5_core when all of its options
> are blindly enabled as part of a distribution config.

You are too focused on psample, while Saeed and I are saying more
general statement "I prefer to have 0 dependency on external modules in a HW driver."

>
> AFAICS, mlx5 still does not have any code that uses psample. You can
> wrap it in a config option and keep the weak dependency on psample.
> Something like:
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> index ad45d20f9d44..d17d03d8cc8b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> @@ -104,6 +104,15 @@ config MLX5_TC_CT
>
>           If unsure, set to Y
>
> +config MLX5_TC_SAMPLE
> +       bool "MLX5 TC sample offload support"
> +       depends on MLX5_CLS_ACT
> +       depends on PSAMPLE || PSAMPLE=n
> +       default n
> +       help
> +         Say Y here if you want to support offloading tc rules that use sample
> +          action.
> +

This is another problem with mlx5 - complete madness with config options
that are not possible to test.
➜  kernel git:(rdma-next) grep -h "config MLX" drivers/net/ethernet/mellanox/mlx5/core/Kconfig | awk '{ print $2}' | sort |uniq |wc -l
19

And it is not weak dependency, but still hard dependency because you
need to recompile your kernel/module to disable/enable it. Any service
that will need to reload psample module for some reason will remove
mlx5_core.

Thanks
