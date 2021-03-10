Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8E03334BF
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhCJFMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:12:21 -0500
Received: from mga04.intel.com ([192.55.52.120]:50789 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229643AbhCJFMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:12:09 -0500
IronPort-SDR: sa7zG4TnuHourP19nzQByBpNoDM0cpliU6hKYfN3C9QYtUwD1px9uKYwFaXeUI0EEH/5iNWVXR
 ev8sswzKzHOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="186007379"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="186007379"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 21:12:08 -0800
IronPort-SDR: RU17yMa7iRo6iftmGU5D+LB0IQfiNnFX88Ug327+KTulSpMdK935AvFUWObbwt/PfYTMoHZmzV
 T/uWkLptNVJA==
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="509539351"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.121.17])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 21:12:08 -0800
Date:   Tue, 9 Mar 2021 21:12:07 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, alice.michael@intel.com,
        alan.brady@intel.com
Subject: Re: [RFC net-next] iavf: refactor plan proposal
Message-ID: <20210309211207.000011df@intel.com>
In-Reply-To: <20210309141738.379feab3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210308162858.00004535@intel.com>
        <20210309141738.379feab3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:

> On Mon, 8 Mar 2021 16:28:58 -0800 Jesse Brandeburg wrote:
> > Hello,
> > 
> > We plan to refactor the iavf module and would appreciate community and
> > maintainer feedback on our plans.  We want to do this to realize the
> > usefulness of the common code module for multiple drivers.  This
> > proposal aims to avoid disrupting current users.
> > 
> > The steps we plan are something like:
> > 1) Continue upstreaming of the iecm module (common module) and
> >    the initial feature set for the idpf driver[1] utilizing iecm.
> 
> Oh, that's still going? there wasn't any revision for such a long time
> I deleted my notes :-o

Argh! sorry about the delay. These proposed driver changes impacted
progress on this patch series, we should have done a better job
communicating what was going on.

> > We are looking to make sure that the mode of our refactoring will meet
> > the community's expectations. Any advice or feedback is appreciated.
> 
> Sounds like a slow, drawn out process painful to everyone involved.
> 
> The driver is upstream. My humble preference is that Intel sends small
> logical changes we can review, and preserve a meaningful git history.

We are attempting to make it as painless and quick as possible. With
that said, I see your point and am driving some internal discussions to
see what we can do differently.

The primary reason for the plan proposed is the code reuse model we've
chosen. With the change to the common module, the new iavf is
significantly different and replacing the old avf base with the new
would take many unnecessary intermediate steps that would be thrown
away at the end. The end design will use the code from the common
module with hooks to get device specific implementation where
necessary.  After putting in place the new-avf code we can update the
iavf with new functionality which is already present in the common
module.

Thanks,
 Jesse
