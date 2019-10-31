Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B344EA869
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfJaA7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:59:21 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36658 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfJaA7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:59:21 -0400
Received: by mail-lj1-f196.google.com with SMTP id v24so4787142ljj.3
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 17:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=R4ZjtEWohuuEm5uV3YNiL/qhADumIPRXKs94ecIrIF8=;
        b=1fH9LH7TyX2tzUW0kXSPmwEMzjqVTgabuNESvYjIrSXsEWi/75mAzUaTPpBy9iCu7V
         OiffTIJ7TqzaOapWHMC28HGf0JDXd7UnTL36MRX8vNv42zHh+5gbNZprXsV48joNz3sE
         ojl1Zh3tykfgLD9jtf8Y3+5O/KgdrzjQ/C5I/Hfw5LikguG4KVlE7588E7bfJH3iD8Rc
         EX3gquNdcyfa3d8+eA+CSakbpTcCf9XNA/J1KXSdQEBDr1aCxYL7ssw6qU7Din7pArZc
         95j6HIXAliZkzsL97l2vW+ZWrp3KdHVjUqk6K8rAXV90wevJzS7eRvsws/Sfj/i6nNs0
         GeNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=R4ZjtEWohuuEm5uV3YNiL/qhADumIPRXKs94ecIrIF8=;
        b=X5Xe+wOUa1G4d21TujCrn5Rg7t7Avf4CqZXE/gLfTbRc0IYl0pADUMjvP4hh3Y3H3i
         mdkW/nAXhbnu2gZa/TPViV9O0CSHccjXPQf6bLazgbd7wQk8OmkrHZqt9n86kiQg3ylG
         2xZi+Ut+G7qkJvBZNsGQyRsvUWdioV89ls3woCdfHWeBLb9ayv4QnnHuzPBMBKweimAz
         cp4+0ERnocEwkgp2SYV7ukFJVuY97EMOkZ6FLuZumQjso+nHTwSF0zZHXHf9aWSNmfVq
         b+qQzAqIFErP/xEwNY5pKqoM2Z3ZE5kv7MyilTHJN7pVOISkUzeMRnMrobwsNiwxcYJ9
         E+pg==
X-Gm-Message-State: APjAAAXWnGJCY0+nJ23kKzefoOrmRsg+WCfTZ90J9mSDOQIbmtSf9hT9
        hAh3DLYs/Oi0SuJmQrcMPEZypQ==
X-Google-Smtp-Source: APXvYqzLx4C4POsBKNg9pWtBErDDNWUXI0Hf07AR2pFQxnk9LX3UOcXi9B+oOb2w7DQ6oxstEwI1HQ==
X-Received: by 2002:a2e:b5d0:: with SMTP id g16mr1848377ljn.88.1572483558535;
        Wed, 30 Oct 2019 17:59:18 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d19sm673269lfc.12.2019.10.30.17.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 17:59:18 -0700 (PDT)
Date:   Wed, 30 Oct 2019 17:59:09 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Ariel Levkovich <lariel@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 2/3] net: Add SRIOV VGT+ support
Message-ID: <20191030175909.7ab24da6@cakuba.netronome.com>
In-Reply-To: <89b961d92baebe8a2a541d2eb9ff3e1d9e9ddb52.camel@mellanox.com>
References: <1572468274-30748-1-git-send-email-lariel@mellanox.com>
        <1572468274-30748-3-git-send-email-lariel@mellanox.com>
        <20191030143438.00b3ce1a@cakuba.netronome.com>
        <89b961d92baebe8a2a541d2eb9ff3e1d9e9ddb52.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 22:50:06 +0000, Saeed Mahameed wrote:
> On Wed, 2019-10-30 at 14:34 -0700, Jakub Kicinski wrote:
> > On Wed, 30 Oct 2019 20:44:44 +0000, Ariel Levkovich wrote:  
> > > Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index 3207e0b..da79976 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -1067,6 +1067,10 @@ struct netdev_name_node {
> > >   *      Hash Key. This is needed since on some devices VF share
> > > this information
> > >   *      with PF and querying it may introduce a theoretical
> > > security risk.
> > >   * int (*ndo_set_vf_rss_query_en)(struct net_device *dev, int vf,
> > > bool setting);
> > > + * int (*ndo_add_vf_vlan_trunk_range)(struct net_device *dev, int
> > > vf,
> > > + *				      u16 start_vid, u16 end_vid,
> > > __be16 proto);
> > > + * int (*ndo_del_vf_vlan_trunk_range)(struct net_device *dev, int
> > > vf,
> > > + *				      u16 start_vid, u16 end_vid,
> > > __be16 proto);
> > >   * int (*ndo_get_vf_port)(struct net_device *dev, int vf, struct
> > > sk_buff *skb);
> > >   * int (*ndo_setup_tc)(struct net_device *dev, enum tc_setup_type
> > > type,
> > >   *		       void *type_data);
> > > @@ -1332,6 +1336,14 @@ struct net_device_ops {
> > >  	int			(*ndo_set_vf_rss_query_en)(
> > >  						   struct net_device
> > > *dev,
> > >  						   int vf, bool
> > > setting);
> > > +	int			(*ndo_add_vf_vlan_trunk_range)(
> > > +						   struct net_device
> > > *dev,
> > > +						   int vf, u16
> > > start_vid,
> > > +						   u16 end_vid, __be16
> > > proto);
> > > +	int			(*ndo_del_vf_vlan_trunk_range)(
> > > +						   struct net_device
> > > *dev,
> > > +						   int vf, u16
> > > start_vid,
> > > +						   u16 end_vid, __be16
> > > proto);
> > >  	int			(*ndo_setup_tc)(struct net_device *dev,
> > >  						enum tc_setup_type
> > > type,
> > >  						void *type_data);  
> > 
> > Is this official Mellanox patch submission or do you guys need time
> > to
> > decide between each other if you like legacy VF ndos or not? ;-)  
> 
> It is official :), as much as we want to move away from legacy mode, we
> do still have two major customers that are not quite ready yet to move
> to switchdev mode. the silver-lining here is that they are welling to
> move to upstream kernel (advanced distros), but we need this feature in
> legacy mode.

So they are willing to update the kernel, just not willing to move the
orchestration to the new way of doing things? Sounds familiar :(

> The ability to configure per VF ACL tables vlan filters is a must.
> 
> I tried to think of an API where we can expose the whole VF ACL tables
> to users and let them configure it the way they want with TC flower
> maybe (sort of hybrid legacy-switchdev mode that can act only on VF ACL
> tables but not on the FDB). The problem with this is that it can easily
> conflict with VST/trust mode and other settings that can be done via
> legacy VF ndos... so i guess the complexity of such API is not worthy
> and a simple vlan list filter API is more natural for legacy sriov ?!

The "we don't want any more legacy VF ndos" policy which I think we
wanted to follow is much easier to stick to than "we don't want any
more legacy VF ndos, unless..".

There's nothing here that can't be done in switchdev mode (perhaps
bridge offload would actually be more suitable than just flower),
and the uAPI extension is not an insignificant one.

I don't think we should be growing both legacy and switchdev APIs, at
some point we got to pick one. The switchdev extension to set hwaddr
for which patches were posted recently had been implemented through
legacy API a while ago (by Chelsio IIRC) so it's not that we're looking
towards switchdev where legacy API is impossible to extend. It's purely
a policy decision to pick one and deprecate the other.

Only if we freeze the legacy API completely will the orchestration
layers have an incentive to support switchdev. And we can save the few
hundred lines of code per feature in every driver..
