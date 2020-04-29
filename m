Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E66B1BE412
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgD2QjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2QjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 12:39:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C0E20787;
        Wed, 29 Apr 2020 16:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588178365;
        bh=7txS/GqZpDY537RiDla39HnZtm4/CZzUk3DI+ehFO8M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZPe3xxEyp2utIcXEh5muenaOn5DXNt9KE0D/7V1EIpGDiHA1/9YNNNQ39PWxbRnSx
         P5HF2whnsxts/lbPU4i+L+XEs8v+E+UqhM/NUrIUcNgYzjsYNzsLUkqIEJ8Ah6M4C0
         +aUa9LQoxd0O1aCV8eqVL80KKQiR7NWxkoGxjLUk=
Date:   Wed, 29 Apr 2020 09:39:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH net-next] devlink: let kernel allocate region snapshot
 id
Message-ID: <20200429093923.394c7c1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <02874ECE860811409154E81DA85FBB58B6CF7AFF@FMSMSX102.amr.corp.intel.com>
References: <20200429014248.893731-1-kuba@kernel.org>
        <20200429054552.GB6581@nanopsycho.orion>
        <02874ECE860811409154E81DA85FBB58B6CF7AFF@FMSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Apr 2020 15:34:30 +0000 Keller, Jacob E wrote:
> > How the output is going to looks like it this or any of the follow-up
> > calls in this function are going to fail?
> > 
> > I guess it is going to be handled gracefully in the userspace app,
> > right?
>
> I'm wondering what the issue is with just waiting to send the
> snapshot id back until after this succeeds. Is it just easier to keep
> it near the allocation?

I just wasn't happy with the fact that the response send may fail.
So it just seems like better protocol from the start to expect user
space to pay attention to the error code at the end, before it takes
action on the response.
