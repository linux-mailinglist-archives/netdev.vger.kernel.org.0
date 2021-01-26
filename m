Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B5D303ED6
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404755AbhAZNgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392486AbhAZN07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:26:59 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB33C0611BD
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 05:26:14 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id p18so11421946pgm.11
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 05:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X8M8LJ/VjAQ/QapUe2kEh2T61Txfu0mjI6Ncwvji/q0=;
        b=NAd9v4IEaNHvQGiKMzECVbgNGDt+yNVjxAhFfBUcd9K6egu+MaCLgVRO9ZquBsNd1A
         fgNWeruQa4oD5LhHnTfK/GR2qICzvBkHyQ6cuhknYnu5lWRYWWWRlC/2Yqy5zxSIyuQk
         t7ujVIgCCANOYikVPH/gOCPuabbQlDFsoU1Fg8b/73Vt675HvSyp2qctB05vCmIYxQ3l
         /ctguYfJg4oXdHdTN0MelJxCXRyz5EC1sEpVMYIg49I8DMEwP+gfK1abMfbTQNUfExA2
         pgtHxupCpltSSSbF2IwHRVvoWdF/uzQbnNO+FEnV/RNjUaQOy+9TsJBQb9Ano5NF4S7U
         JaCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X8M8LJ/VjAQ/QapUe2kEh2T61Txfu0mjI6Ncwvji/q0=;
        b=XUeh2IzkXVcQL7EC3c7HlOFjfyqAfnhU2irhmE/19mE9vFtu1wK/RkA3j4gTmIQHQH
         RCZrqL7ZBNtyvG0Rk5ZpOnaIYEclnlEi+Fk7ny+YzriCIi4S0H/TFmBYErxqu5ZiUgfY
         0r9sC+rEvWyc4/lnnnpFCO6v1AKreC5XuC869BcLyNarUjmigd7WN3hS1ub3IZmWyfCL
         7aMSSMuQdcuAZDVlUWCUiEwVlyvGAU/Flhf4/0h82ty9PyN3TEiG1LP0/A5wNt01yTPz
         Z50tateR3dzHxHgaqHh2M4MrxSV/GcXSLRr9UfAWurznS9yb8nivDKdrvR2l9Ckl3rID
         cqug==
X-Gm-Message-State: AOAM532oJ7kh2qFezyTYmC4sO9Mqy3HUWoHYDF499WuDSmd73LeTrnYF
        9oldRTLYUFmuZapyFhCDb/DZmzYY7C32YQ==
X-Google-Smtp-Source: ABdhPJw1+E/WjUvVREAAdiEFP+LHxnbmvflWdTyQmmC8C01ZBnscYvCpovXfCuG3JROrnXN3p8BT9w==
X-Received: by 2002:a62:1b47:0:b029:1ba:7a85:cdff with SMTP id b68-20020a621b470000b02901ba7a85cdffmr5240910pfb.22.1611667574078;
        Tue, 26 Jan 2021 05:26:14 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x26sm12870575pfi.176.2021.01.26.05.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 05:26:13 -0800 (PST)
Date:   Tue, 26 Jan 2021 21:25:26 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, Jarod Wilson <jarod@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next] bridge: Propagate NETDEV_NOTIFY_PEERS notifier
Message-ID: <20210126132448.GN1421720@Leo-laptop-t470s>
References: <20210126040949.3130937-1-liuhangbin@gmail.com>
 <8a34f089-204f-aeb1-afc7-26ccc06419eb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a34f089-204f-aeb1-afc7-26ccc06419eb@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 09:40:13AM +0200, Nikolay Aleksandrov wrote:
> On 26/01/2021 06:09, Hangbin Liu wrote:
> > After adding bridge as upper layer of bond/team, we usually clean up the
> > IP address on bond/team and set it on bridge. When there is a failover,
> > bond/team will not send gratuitous ARP since it has no IP address.
> > Then the down layer(e.g. VM tap dev) of bridge will not able to receive
> > this notification.
> > 
> > Make bridge to be able to handle NETDEV_NOTIFY_PEERS notifier.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  net/bridge/br.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/bridge/br.c b/net/bridge/br.c
> > index ef743f94254d..b6a0921bb498 100644
> > --- a/net/bridge/br.c
> > +++ b/net/bridge/br.c
> > @@ -125,6 +125,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
> >  		/* Forbid underlying device to change its type. */
> >  		return NOTIFY_BAD;
> >  
> > +	case NETDEV_NOTIFY_PEERS:
> >  	case NETDEV_RESEND_IGMP:
> >  		/* Propagate to master device */
> >  		call_netdevice_notifiers(event, br->dev);
> > 
> 
> I'm not convinced this should be done by the bridge, setups usually have multiple ports
> which may have link change events and these events are unrelated, i.e. we shouldn't generate
> a gratuitous arp for all every time, there might be many different devices present. We have
> setups with hundreds of ports which are mixed types of devices.
> That seems inefficient, redundant and can potentially cause problems.

Hi Nikolay,

Thanks for the reply. There are a few reasons I think the bridge should
handle NETDEV_NOTIFY_PEERS:

1. Only a few devices will call NETDEV_NOTIFY_PEERS notifier: bond, team,
   virtio, xen, 6lowpan. There should have no much notification message.
2. When set bond/team's upper layer to bridge. The bridge's mac will be the
   same with bond/team. So when the bond/team's mac changed, the bridge's mac
   will also change. So bridge should send a GARP to notify other's that it's
   mac has changed.
3. There already has NETDEV_RESEND_IGMP handling in bridge, which is also
   generated by bond/team and netdev_notify_peers(). So why there is IGMP
   but no ARP?
4. If bridge doesn't have IP address, it will omit GARP sending. So having
   or not having IP address on bridge doesn't matters.
4. I don't see why how many ports affect the bridge sending GARP.

Please correct me if I missed something.

> Also it seems this was proposed few years back: https://lkml.org/lkml/2018/1/6/135

Thanks for this link, cc Stephen for this discuss.

Hangbin
