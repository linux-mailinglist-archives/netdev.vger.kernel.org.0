Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BA7306BA2
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhA1D20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhA1D2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 22:28:20 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA5DC061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:27:40 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b8so2544568plh.12
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PiWPUkYWirALNH3srwHMZyB8M+2z39u4PPSrRrniMj0=;
        b=X9Cz6XO/3EAt6MSawZAW8HJBYaEM3CpAF7LwXY/bUY7Xq5iE5bCtpKvVE81jnuRH6M
         YmF5wPFW0p3/cAq0kieYeXBKrHtHbWKU0VTuR8d1Ao39E4XAWb6defdNh7J81/3kuhdG
         lK8Lor1+q+VO4qcGqmPMVTbEOSj8lXw+t1ueLMTbkt3XWgmCVKSpjxLZS/x4fgccUokQ
         9qLVfvH+SlkxIU7EeJX0u0UvUVVZPMgVK6/pG0DhwOu0VryYdKhJE+dKl61nknpqywQm
         lTh8cBJm5bnEvfwAVQm92rwQjjxs3ObZD6n8sQpzQ+/VhovFNLwA0hJLkZ2itcWv7Hm1
         UpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PiWPUkYWirALNH3srwHMZyB8M+2z39u4PPSrRrniMj0=;
        b=K/1wsCqyXrFX1bdN4/36aqaANR2+sP3klp0mT36SC571kWttr6cId+NwTOjk/QTp1q
         MZyC63TkyYcGy6yl2oGSvosphr+SPzz5g4CjS03Do3G4q2hLwSoSvVdoZJ5ahKcHmKQw
         sFV9NQEt6/jiO+QR/cCyG2/TGehsSb6V9K1vPSm5iVY350Ogf88vt5vq/qxo+PLw+76Z
         cWPyOMNZFA7zxudJjpGDu4u8v1NZlwHEBxiV5s2c7Y69ZxZBW+mFJYUCNeQ/WV9ZOejn
         V8fQV573UIGPtu2dA5h/6yWfLDoX5rqxtDHGNB5xiGAwYr54q6E1ZMtRvRA3AoZ5p2S7
         DOLw==
X-Gm-Message-State: AOAM5306alzDQRnLCICPJ+kFaJx1c2tS/imV0IF8hCSqac4ngOu45zAG
        rT2JK4o1uqvo4dUUhf/Xj/U=
X-Google-Smtp-Source: ABdhPJw/2W00ba/U40TWiTwq5ieSy7TnZb5SweiEtrwYu2If1gLuoX+oapeK0QxA+1JjGtn3QPUicw==
X-Received: by 2002:a17:902:12c:b029:e1:aac:e6f4 with SMTP id 41-20020a170902012cb02900e10aace6f4mr4312055plb.26.1611804459784;
        Wed, 27 Jan 2021 19:27:39 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s21sm3329751pjz.13.2021.01.27.19.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 19:27:38 -0800 (PST)
Date:   Thu, 28 Jan 2021 11:27:26 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, Jarod Wilson <jarod@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net-next] bridge: Propagate NETDEV_NOTIFY_PEERS notifier
Message-ID: <20210128032726.GP1421720@Leo-laptop-t470s>
References: <20210126040949.3130937-1-liuhangbin@gmail.com>
 <8a34f089-204f-aeb1-afc7-26ccc06419eb@nvidia.com>
 <20210126132448.GN1421720@Leo-laptop-t470s>
 <90df4fe6-fcc5-f59a-c89c-6f596443af4d@nvidia.com>
 <0b5741b6-48c0-0c34-aed8-257f3e203ac5@nvidia.com>
 <20210127041521.GO1421720@Leo-laptop-t470s>
 <e22d0eea-4236-5916-cc42-532a3dfcc9dd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e22d0eea-4236-5916-cc42-532a3dfcc9dd@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 11:43:30AM +0200, Nikolay Aleksandrov wrote:
> > For IGMP, although you said they are different. In my understanding, when
> > bridge mac changed, we need to re-join multicast group, while a gratuitous
> > ARP is also needed. I couldn't find a reason why IGMP message is OK but GARP
> > is not.
> > 
> 
> I think that's needed more because of port changing rather than mac changing.
> Switches need to be updated if the port has changed, all of that is already handled
> correctly by the bond. And I also meant that mcast is handled very differently in
> the bridge, usually you'd have snooping enabled.
> 
> The patch below isn't correct and will actually break some cases when bonding
> flaps ports and propagates NETDEV_RESEND_IGMP with a bridge on top.

Hi Nikolay,

I'm little curious. bond/team device will resend IGMP as their MAC address changed.

- bond_resend_igmp_join_requests_delayed()
  - call_netdevice_notifiers(NETDEV_RESEND_IGMP, bond->dev);
- team_mcast_rejoin_work()
  - call_netdevice_notifiers(NETDEV_RESEND_IGMP, team->dev);

What's the purpose that bridge resend IGMP if it's mac address not changed?

I mean, when there is a bridge on top of bond/team, when bond/team flap ports,
bond/team will re-send IGMP and bridge just need to forward it. bridge doesn't
need to re-send the IGMP itself if it's MAC address not changed.

Thanks
Hangbin
