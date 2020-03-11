Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E4D180D07
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 01:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgCKA4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 20:56:19 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35681 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbgCKA4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 20:56:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id 7so232262pgr.2
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 17:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8FHp59b3omKF6p5Tt9JFHZVvL33TyNUZDUt7qzfIzmM=;
        b=lcGiKdysHznQPh5Dlpux797KqMtrLsfkWyA8Ao+kR3LjBu+xSYg+M92hsQWOmWza3m
         vNOSP1E4gflguovNFSjnwd/YMmYIkw/Grn0OjzI4yObYaHooVsvk2uJceKjljxGviC6c
         NgS9RGwjKr2dMlfZ+jT32DNz2nA4ELoE1QqB1QfGxTouDw6k/efk+0zM/nmbVTxxh0qk
         CGY3uEzLWu+tYO+H3yBjREzlB0bd2vtFcFqbe/mrLq3NqWMt/D96hZkYfyp2FDRyGV0u
         SEjE5Hty+BOcHoCc0YLQGFgdpqIJjAiFjO+5DrVl1x0JGfYCjHZcIgjIv5erHrLyYJyx
         IbBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8FHp59b3omKF6p5Tt9JFHZVvL33TyNUZDUt7qzfIzmM=;
        b=Cms8+nwHb7ufNbIWh56M9knP88KyG7LbbhfeDYsowr1SoqtmCyU78A45CTyZh6ei0f
         A6Xszw+WpXLDWuWLHAqXJolGYEN7kUNvShGM7ye7iBv2cpm6VMzL6Gj4q7HyajuphrpY
         imyrf6ElJ1WuY48EGESV/90tVDg5UUVOdbSf8pWa+m9lhqli4NAnP+g/PA7lBZKd2LdC
         mpNRfGcPPOVboIGLkcF/M/vf5inOxXABDMaS6YR+O7F+fE9h8em8JGvDn3N2japjpSjV
         h0SGGOSKSEk/MLwAwe+TZtykB9TZvPQGXoMtZH5pvfeIaa/lXUqIGj6Db07J4Szy3scd
         /+KQ==
X-Gm-Message-State: ANhLgQ1QM3McFshLE0dVnhk8xpfFNOTv4mQn0v22pofrALGwQU+D9BPF
        AjI8Ere6PpfGfZCIm3L+YoI=
X-Google-Smtp-Source: ADFU+vuHVn91FgEOnLHgjvjfJGOrJmS7CmfJDIJbn39a2I4K2ElDXUDYAa9/Jcxj9QkgnoDDVi96ig==
X-Received: by 2002:aa7:92da:: with SMTP id k26mr255546pfa.139.1583888178480;
        Tue, 10 Mar 2020 17:56:18 -0700 (PDT)
Received: from martin-VirtualBox ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id k67sm47694052pga.91.2020.03.10.17.56.17
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 17:56:18 -0700 (PDT)
Date:   Wed, 11 Mar 2020 06:26:13 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        martin.varghese@nokia.com, Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH net-next] bareudp: Fixed bareudp receive handling
Message-ID: <20200311005613.GA18516@martin-VirtualBox>
References: <1583859760-18364-1-git-send-email-martinvarghesenokia@gmail.com>
 <89faace0-7c11-b338-282b-b9e409677ba4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89faace0-7c11-b338-282b-b9e409677ba4@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 10:28:40AM -0700, Eric Dumazet wrote:
> 
> 
> On 3/10/20 10:02 AM, Martin Varghese wrote:
> > From: Martin Varghese <martin.varghese@nokia.com>
> > 
> > Reverted commit "2baecda bareudp: remove unnecessary udp_encap_enable() in
> > bareudp_socket_create()"
> > 
> > An explicit call to udp_encap_enable is needed as the setup_udp_tunnel_sock
> > does not call udp_encap_enable if the if the socket is of type v6.
> > 
> > Bareudp device uses v6 socket to receive v4 & v6 traffic
> > 
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > Fixes: 2baecda37f4e ("bareudp: remove unnecessary udp_encap_enable() in bareudp_socket_create()")
> 
> Please CC the author of recent patches, do not hide,
> and to be clear, it is not about blaming, just information.
> 

You mean the author of 2baecda37f4e ("bareudp: remove unnecessary udp_encap_enable() in bareudp_socket_create()") ?
yes i will do.

> > ---
> >  drivers/net/bareudp.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> > index 71a2f48..c9d0d68 100644
> > --- a/drivers/net/bareudp.c
> > +++ b/drivers/net/bareudp.c
> > @@ -250,6 +250,9 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
> >  	tunnel_cfg.encap_destroy = NULL;
> >  	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
> >  
> 
> This might need a comment. 
> 
> Can this condition be false ?
> 
If the IPv6 is disabled the socket type will be v4 and there is no need of explicit  call to
udp_encap_enable


> According to your changelog, it seems not.
> 
> Give to reviewers more chance to avoid future mistakes.
> 
You mean add a comment?
> Thanks.
> 
> > +	if (sock->sk->sk_family == AF_INET6)
> > +		udp_encap_enable();
> > +
> >  	rcu_assign_pointer(bareudp->sock, sock);
> >  	return 0;
> >  }
> > 
