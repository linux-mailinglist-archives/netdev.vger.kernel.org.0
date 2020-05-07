Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D29B1C88AD
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgEGLoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:44:05 -0400
Received: from correo.us.es ([193.147.175.20]:36972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgEGLoE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 07:44:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2BE384FFE14
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 13:44:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 186C21158F3
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 13:44:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0CC7811541A; Thu,  7 May 2020 13:44:03 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A61121158F4;
        Thu,  7 May 2020 13:44:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 May 2020 13:44:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7E54842EF4E2;
        Thu,  7 May 2020 13:44:00 +0200 (CEST)
Date:   Thu, 7 May 2020 13:44:00 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, kuba@kernel.org
Subject: Re: [PATCH net,v4] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200507114400.GA2179@salvia>
References: <20200506183450.4125-1-pablo@netfilter.org>
 <828ef810-9768-5b5c-7847-0edeb666af9b@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <828ef810-9768-5b5c-7847-0edeb666af9b@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 11:38:24AM +0100, Edward Cree wrote:
> On 06/05/2020 19:34, Pablo Neira Ayuso wrote> -	} else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED) {
> > +	} else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED &&
> > +		   act->hw_stats != FLOW_ACTION_HW_STATS_DONT_CARE) {
> >  		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
> >  		return -EOPNOTSUPP;
> >  	}
> FWIW my whole reason for suggesting DONT_CARE==0 in the first place
>  was so that drivers could just use it as a boolean, e.g.
>     if (act->hw_stats && !(act->hw_stats & FLOW_ACTION_HW_STATS_BLAH))
>         error("driver only supports BLAH stats");
>
> If you're not even doing that then the case for DONT_CARE == ~0 is
>  even stronger.

Could you point to what driver might have any problem with this update?

Thank you.
