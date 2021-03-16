Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7EF33E1A5
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhCPWra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCPWrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 18:47:14 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3BFC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 15:47:13 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ox4so59192626ejb.11
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 15:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NZYYAo5vO0e5OLfBE6skWjpE3uwYmd+KnabfKeZysMM=;
        b=FYkn/d4JQgm8uXnC8fqyPPqccWywjMkKdGObPyiQ+5Y0/U7pRgSp9hid2k1rrSmhpl
         NPHlcG+KK00/SeV1YWx2DRyuCt1VbQbgauV88U9UWPXdF5PF6XxqIJhJdANyP9aZTssY
         gD6dUCuwPx3KRSVRGNQxPGepFBG9KBXO2Q6vrHlRdfisxFqfAaAOYgNzeb5DDOjNLVa6
         F1XJzaM60LKlKyyjIyHzYFDGo8BDf/iL3F/+QFtln+T/+ISqWVmLBdoVpiq626M+5B72
         KL65LTWm57uTqQKa2p4CLY0ws4mu01zmo3tHySxLQenLwM0zWfyBQhOFupvkBMkodZyL
         XYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NZYYAo5vO0e5OLfBE6skWjpE3uwYmd+KnabfKeZysMM=;
        b=OQl5YB4S0vtJHGSxTZipiQv7ltpQa5epWne9q2d0gQudg30GPioJ8xC09u5HZ3Fggh
         fQ1R7im2SmuMZmdxgdCHsdry8HULRGLdBtD392zOQQpxlH22hhvXSf6nTYPRPAnIiQdF
         I/6DiCfhUFgA+S5RWWgosthf8GeuHKer6w40hriYhfVgpJdz85Xy2zv+JtFdGoGEQleK
         Or9mWQWrkl2wqTCe1wMCMREhgR84+MTkXHNk/CrhU5sEgmpujenTYEFcUEWi8dQiQmVp
         YyUFuZQZmszUrEcKYrRGO7rjxp1+/6jlkMbBWNA6IlvTGm78ihviW/Ui/ZiL4DTJTgNE
         7uxQ==
X-Gm-Message-State: AOAM532WiqikP7essBsHBPcvxlc8U1uSC1/HzkRnCVEhIMyCcThJuPDI
        SjXoXehVD9rwuwmI2kRQyvE=
X-Google-Smtp-Source: ABdhPJzDJJuLOuYkBHi+Ow1+SRABPLux/mGIo6wPJCSw4rX6kQ6EMKSbu5AJ63ikdaNEdr6mvhvr9A==
X-Received: by 2002:a17:906:789:: with SMTP id l9mr31810418ejc.161.1615934832367;
        Tue, 16 Mar 2021 15:47:12 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t12sm11757393edy.56.2021.03.16.15.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 15:47:12 -0700 (PDT)
Date:   Wed, 17 Mar 2021 00:47:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: Centralize validation of VLAN configuration
Message-ID: <20210316224711.hu3dnyepxvu4m2l5@skbuf>
References: <20210315195413.2679929-1-tobias@waldekranz.com>
 <20210315234956.2yt4ypwzqaesw72b@skbuf>
 <878s6nozcz.fsf@waldekranz.com>
 <20210316214906.pt7io5qcje6g2snn@skbuf>
 <871rcepvsi.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rcepvsi.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 11:40:13PM +0100, Tobias Waldekranz wrote:
> > Actually, I think there is a bigger issue.
> > Sadly, I only put 2 and 2 together now, and I believe we are still not
> > dealing correctly with 8021q uppers of bridge ports with vlan_filtering 0.
> > The network stack's expectation is described here:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210221213355.1241450-12-olteanv@gmail.com/
> 
> So this is the setup Ido is describing, right?
> 
> br1
>   \
>  .100  br0
>     \  / \
>     swp0 swp1
> 
> > Basically the problem is in the way DSA drives the configuration of the
> > hardware port. When VLAN filtering is disabled, VLAN awareness is disabled,
> > too, and we make no effort to classify packets according to the VLAN ID,
> > and take a different forwarding decision in hardware based on that. So
> > the traffic corresponding to the 8021q upper gets forwarded, flooded to
> > ports it shouldn't go to.
> 
> I will try to put this in my own words to see if I understand: the
> problem with the setup above is the discrepancy between how the switch
> and how Linux would handle VID 100 tagged frames.
> 
> In a s/swp/eth/-scenario, br0 would never see those frames since they
> would be snooped by swp0.100, whereas the switch will gleefully forward
> them to swp1.

Yes, pretty much, you can see with bridged veth pairs that this is
exactly what happens, you can ping through their 8021q uppers even
though you cannot ping through the veth interfaces themselves (and of
course, you can ping through the bridge, but that is beside the point).

> $PROFANITY

+2
