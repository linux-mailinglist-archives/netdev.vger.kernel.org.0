Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD711D8AB2
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgERWXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgERWXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 18:23:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8610220674;
        Mon, 18 May 2020 22:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589840581;
        bh=oX/+VVCg382kthfze6L6wbfJgvB2RvT/y5oG/CZkNXY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s8Tq0lUEBa8G+/8vEJcL8+3Kbcsh2xrZ6R0SvCzz4XrzhUSQuH2o8YCOT21zMNSeE
         VVA0MZc5fBjZMD7jm9+jrnRNoq7qlVtKqmDhVWzuFmSVUqRr+ag9PW1zJB/wjb6XFO
         b0NX53cTKDiw0Mctxwrl+8iHH5wHcQtagpkh49YA=
Date:   Mon, 18 May 2020 15:22:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     David Miller <davem@davemloft.net>, olteanv@gmail.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com, po.liu@nxp.com,
        m-karicheri2@ti.com, Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
Message-ID: <20200518152259.29d2e3c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87h7wcq4nx.fsf@intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
        <20200516.133739.285740119627243211.davem@davemloft.net>
        <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com>
        <20200516.151932.575795129235955389.davem@davemloft.net>
        <87wo59oyhr.fsf@intel.com>
        <20200518135613.379f6a63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87h7wcq4nx.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 15:06:26 -0700 Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> >
> > Please take a look at the example from the cover letter:
> >
> > $ ethtool $ sudo ./ethtool --show-frame-preemption
> > enp3s0 Frame preemption settings for enp3s0:
> > 	support: supported
> > 	active: active
> > 	supported queues: 0xf
> > 	supported queues: 0xe
> > 	minimum fragment size: 68
> >
> > Reading this I have no idea what 0xe is. I have to go and query TC API
> > to see what priorities and queues that will be. Which IMHO is a strong
> > argument that this information belongs there in the first place.  
> 
> That was the (only?) strong argument in favor of having frame preemption
> in the TC side when this was last discussed.
> 
> We can have a hybrid solution, we can move the express/preemptible per
> queue map to mqprio/taprio/whatever. And have the more specific
> configuration knobs, minimum fragment size, etc, in ethtool.
> 
> What do you think?

Does the standard specify minimum fragment size as a global MAC setting?
