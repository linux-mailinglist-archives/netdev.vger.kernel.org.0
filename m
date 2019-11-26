Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6ACB109AF9
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 10:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfKZJRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 04:17:38 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43999 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfKZJRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 04:17:38 -0500
Received: by mail-pg1-f193.google.com with SMTP id b1so8657716pgq.10
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 01:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V9XUIwz++HJpbH5PeBeA2nBtDaJbHS9Zer0DSjOuq+A=;
        b=KCx2mjjw5f/7GUlJTWu30XeUUJdXExDBwtbRAxmROAz4oAuwsuV58ggHm5R+v8wIeH
         cD/ZC5PmZlbYdBnzUl0IQpCUiZkU81nI8sSrfVvKDfFxCVYDsCd3qsHgbCLnucBeAe5W
         3kABPcxoX82K8t699n9xgf8oRfVR/rI61w1AT0t8qoN+esFvDylT/7ir/OtWIVlYT7WW
         txcE8TskLDy3fAkVhN61YC+P84ISby1VH6rTCT8z0rGQfx3GAQy+rsXW58vxO9W9JSKV
         X4zRm0F+YiEBKZPWxoBxqf4vX15LexljY04SlQeRjK6b9Th88L4/Da1IY3Saj8QprbjP
         gFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V9XUIwz++HJpbH5PeBeA2nBtDaJbHS9Zer0DSjOuq+A=;
        b=hVA7mws9qi9K4GPieauNI3MjFM7xswNZazYnlD0Kd3Hxg4I05VcFqWXDgBuPKU5V+v
         2xbf9cyarKWrcYSmbY/n13WR76MGWJQZSO51PUStDpTK7VCrHrvPojvQDuN7O3x2KjW0
         MQ2uHR5IQAIlWY0mklh+nKmxrX1etRcmiOlvXPnIXUY8qy7k4rOGLGwQXh7T/fdMii8Z
         qaYl2qSC3XI9aUW5fP7T3QOWOxSoyUqWEMaAhLCl3IdDebO9wDwuRfVJiiFZlox3CQTh
         MRAPC3T9LZKSD2PDqxpglYGXmbvzlk6NW5q6676AiTDBXyChWkfP5T+T8myBl8Clv4Kq
         Ax8A==
X-Gm-Message-State: APjAAAU5tfFmg+zm0/gWtVS8xb8YgKI1vQNk1W8x1WAdHFgr2/h7kuBN
        d02XC69PN4oAxLQF8VR9KGo=
X-Google-Smtp-Source: APXvYqxgNRse/o5LV8z25QzLz3out0kJfxiQYpGAxYE+ncEHUgDCMLuevDpD2mETviiCua6eTF+HBg==
X-Received: by 2002:aa7:9804:: with SMTP id e4mr40018453pfl.21.1574759857369;
        Tue, 26 Nov 2019 01:17:37 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p16sm12052246pfn.171.2019.11.26.01.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 01:17:36 -0800 (PST)
Date:   Tue, 26 Nov 2019 17:17:27 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, ja@ssi.bg, marcelo.leitner@gmail.com,
        dsahern@gmail.com, edumazet@google.com
Subject: Re: [PATCH net] ipv6/route: only update neigh confirm time if pmtu
 changed
Message-ID: <20191126091726.GH18865@dhcp-12-139.nay.redhat.com>
References: <20191122061919.26157-1-liuhangbin@gmail.com>
 <20191122.100438.416583996458136747.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122.100438.416583996458136747.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Sorry for the late reply. I'm not sure why your reply went to spam list and
I didn't receive it timely.
On Fri, Nov 22, 2019 at 10:04:38AM -0800, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Fri, 22 Nov 2019 14:19:19 +0800
> 
> > The reason is when we ping6 remote via gretap, we will call like
> > 
> > gre_tap_xmit()
> >  - ip_tunnel_xmit()
> >    - tnl_update_pmtu()
> >      - skb_dst_update_pmtu()
> >        - ip6_rt_update_pmtu()
> >          - __ip6_rt_update_pmtu()
> >            - dst_confirm_neigh()
> >              - ip6_confirm_neigh()
> >                - __ipv6_confirm_neigh()
> >                  - n->confirmed = now
> 
> This whole callchain violates the assumptions of the MTU update
> machinery.
> 
> In this case it's just the tunneling code accounting for the
> encapsulation it is creating, and checking the MTU just in case.
> 
> But the MTU update code is supposed to be invoked in response to real
> networking events that update the PMTU.
> 
> So for this ip_tunnel_xmit() case, _EVEN_ if the MTU is changed, we
> should not be invoking dst_confirm_neigh() as we have no evidence
> of successful two-way communication at this point.

Thanks for the explanation. When I fixed the code, I was also wondering
if we need this neighbor confirmation. So I just moved the dst_confirm_neigh()
a little down to make sure pmtu changed. Your explanation make me clear that
we should not have this neighbor confirmation as PMTU is not a two-way
communication.
> 
> We have to stop papering over the tunneling code's abuse of the PMTU
> update framework and do this properly.

Should I do other works than just remove dst_confirm_neigh() in
__ip6_rt_update_pmtu().

Thanks
Hangbin
> 
> Sorry, I'm not applying this.
