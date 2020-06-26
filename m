Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673C920BD11
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgFZXL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:11:58 -0400
Received: from smtprelay0238.hostedemail.com ([216.40.44.238]:50542 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725883AbgFZXL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:11:58 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 2C117180A7FCB;
        Fri, 26 Jun 2020 23:11:57 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2551:2553:2559:2562:2828:2914:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3872:3873:4321:4605:5007:6742:7576:7903:7904:9545:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12048:12050:12296:12297:12438:12663:12740:12760:12895:13095:13163:13229:13436:13439:13846:14181:14659:14721:21080:21433:21451:21627:21660:21990:30012:30029:30046:30054:30055:30063:30064:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: coach32_3c1533f26e59
X-Filterd-Recvd-Size: 3891
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jun 2020 23:11:54 +0000 (UTC)
Message-ID: <484b69ec3d9269ec830453d7c3c3b2c60b15ab40.camel@perches.com>
Subject: Re: [net-next v3 06/15] iecm: Implement mailbox functionality
From:   Joe Perches <joe@perches.com>
To:     "Brady, Alan" <alan.brady@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Date:   Fri, 26 Jun 2020 16:11:53 -0700
In-Reply-To: <MW3PR11MB4522E5B119C25872368CE7048F930@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-7-jeffrey.t.kirsher@intel.com>
         <b2305a5aaefdd64630a6b99c7b46397ccb029fd9.camel@perches.com>
         <MW3PR11MB4522E5B119C25872368CE7048F930@MW3PR11MB4522.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-06-26 at 17:44 +0000, Brady, Alan wrote:
> > -----Original Message-----
> > From: Joe Perches <joe@perches.com>
> > Sent: Thursday, June 25, 2020 7:58 PM
> > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> > Cc: Michael, Alice <alice.michael@intel.com>; netdev@vger.kernel.org;
> > nhorman@redhat.com; sassmann@redhat.com; Brady, Alan
> > <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> > Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> > <madhu.chittim@intel.com>; Linga, Pavan Kumar
> > <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> > <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> > <sridhar.samudrala@intel.com>
> > Subject: Re: [net-next v3 06/15] iecm: Implement mailbox functionality
> > 
> > On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> > > From: Alice Michael <alice.michael@intel.com>
> > > 
> > > Implement mailbox setup, take down, and commands.
> > []
> > > diff --git a/drivers/net/ethernet/intel/iecm/iecm_controlq.c
> > > b/drivers/net/ethernet/intel/iecm/iecm_controlq.c
> > []
> > > @@ -73,7 +142,74 @@ enum iecm_status iecm_ctlq_add(struct iecm_hw
> > *hw,
> > >  			       struct iecm_ctlq_create_info *qinfo,
> > >  			       struct iecm_ctlq_info **cq)
> > 
> > Multiple functions using **cp and *cp can be error prone.
> > 
> 
> We can see how this can be confusing.  Would it be acceptable/sufficient to change function parameter name to **cq_arr or **cq_list?

Your code, your choice.
	
> > >  {
> > > -	/* stub */
> > > +	enum iecm_status status = 0;
> > > +	bool is_rxq = false;
> > > +
> > > +	if (!qinfo->len || !qinfo->buf_size ||
> > > +	    qinfo->len > IECM_CTLQ_MAX_RING_SIZE ||
> > > +	    qinfo->buf_size > IECM_CTLQ_MAX_BUF_LEN)
> > > +		return IECM_ERR_CFG;
> > > +
> > > +	*cq = kcalloc(1, sizeof(struct iecm_ctlq_info), GFP_KERNEL);
> > > +	if (!(*cq))
> > > +		return IECM_ERR_NO_MEMORY;

You might use a temporary here after the alloc

	struct iecm_ctlq_info *cq;

	[...]

	*cq_arr = kcalloc(1, sizeof(struct iecm_ctlq_info), GFP_KERNEL);
	if (!*cq_arr)
		return IECM_ERR_NO_MEMORY;

	cq = *cq_arr;

so all uses of cq are consistent.


