Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70A321948E
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgGHXsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgGHXsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 19:48:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49F3D20720;
        Wed,  8 Jul 2020 23:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594252094;
        bh=19UO96FB6A26kj4urfzwCUGYyyXLV9ts4L5kQP4qUs0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MATxVHoguBUq7R9Yd80Ooopp/CjcJuQi3hIYsAVTONFysanJd4UX0sDhlRYVjajIR
         yrESSW7ZxisbtgUFc12Xadhmdg0uRvzWKygtop+71XWer6XRg+7+bOitaJJRj2N43G
         TSLmayAE7B4IBG5872/B/dpTmLX8N80NWjj6Weo0=
Date:   Wed, 8 Jul 2020 16:48:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Wang, Haiyue" <haiyue.wang@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Zhang, Xiao" <xiao.zhang@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Xing, Beilei" <beilei.xing@intel.com>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
Subject: Re: [Intel-wired-lan] [net-next, v7 5/5] ice: add switch rule
 management for DCF
Message-ID: <20200708164812.384ae8ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <eca3253391dd34a267e607dbd847d6878bc3a6fe.camel@intel.com>
References: <20200619045711.16055-1-haiyue.wang@intel.com>
        <20200701012557.40234-1-haiyue.wang@intel.com>
        <20200701012557.40234-6-haiyue.wang@intel.com>
        <eca3253391dd34a267e607dbd847d6878bc3a6fe.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jul 2020 22:55:21 +0000 Nguyen, Anthony L wrote:
> > @@ -490,7 +476,7 @@ ice_aq_alloc_free_vsi_list(struct ice_hw *hw, u16
> > *vsi_list_id,
> >   *
> >   * Add(0x02a0)/Update(0x02a1)/Remove(0x02a2) switch rules commands
> > to firmware
> >   */
> > -static enum ice_status
> > +enum ice_status
> >  ice_aq_sw_rules(struct ice_hw *hw, void *rule_list, u16
> > rule_list_sz,
> >  		u8 num_rules, enum ice_adminq_opc opc, struct ice_sq_cd
> > *cd)
> >  {  
> 
> Hi Dave, Jakub,
> 
> This feature is only built when CONFIG_PCI_IOV is set. We end up with
> this namespace issue using defconfig when checked against namespace.pl
> since CONFIG_PCI_IOV is not enabled.
> 	Externally defined symbols with no external references
>           ice_switch.o
>             ice_aq_sw_rules
> 
> From a previous patch, neither of you liked the use of CONFIG_ to
> control static-ness. I wanted to check that you are ok with the
> namespace issue or if you have a preferred method to resolve this
> issue. I appreciate your feedback.

IMHO that should be fine. I'd only trust namespace.pl on a all*config
kernel, if at all.
