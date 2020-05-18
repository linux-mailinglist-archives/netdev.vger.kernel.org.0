Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BD21D8B7A
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgERXJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgERXJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 19:09:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 599CF2067D;
        Mon, 18 May 2020 23:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589843348;
        bh=3j68PdDORD9YdAbdIH/wOvS4Z7wO8SbbhsU3OnBBgEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ojMswvruxf2Akvl2VqhCySOKmSK21bnI5qo4iJrCf7BTvyXFiznj5wmcZy2wTvoog
         YVHUeTkpZAFB9aNldoWY36uGMOlsOz7hRSz0HHzRYClrvhMropHK8DFGVVtbKDnT6z
         v4aVIj3j5PN2O4pYGkrfqRH0mUImm/1z+QtgMYNA=
Date:   Mon, 18 May 2020 16:09:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     David Miller <davem@davemloft.net>, olteanv@gmail.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com, po.liu@nxp.com,
        m-karicheri2@ti.com, Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
Message-ID: <20200518160906.40e9d8bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87blmkq1y3.fsf@intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
        <20200516.133739.285740119627243211.davem@davemloft.net>
        <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com>
        <20200516.151932.575795129235955389.davem@davemloft.net>
        <87wo59oyhr.fsf@intel.com>
        <20200518135613.379f6a63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87h7wcq4nx.fsf@intel.com>
        <20200518152259.29d2e3c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87blmkq1y3.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 16:05:08 -0700 Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> >> That was the (only?) strong argument in favor of having frame preemption
> >> in the TC side when this was last discussed.
> >> 
> >> We can have a hybrid solution, we can move the express/preemptible per
> >> queue map to mqprio/taprio/whatever. And have the more specific
> >> configuration knobs, minimum fragment size, etc, in ethtool.
> >> 
> >> What do you think?  
> >
> > Does the standard specify minimum fragment size as a global MAC setting?  
> 
> Yes, it's a per-MAC setting, not per-queue. 

If standard defines it as per-MAC and we can reasonably expect vendors
won't try to "add value" and make it per queue (unlikely here AFAIU),
then for this part ethtool configuration seems okay to me.
