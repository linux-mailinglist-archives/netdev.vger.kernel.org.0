Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA41F173D7F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 17:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgB1Qtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 11:49:55 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37499 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgB1Qty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 11:49:54 -0500
Received: by mail-qk1-f194.google.com with SMTP id m9so3574213qke.4
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 08:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hgWgrZvCEmu6uRu0ctlC2UMyMXZuVubNemvY+msKWUs=;
        b=T0253mjwOlZLR6gL/ZmNlcSwlPXiIpvXHAT/pU9Wem5isQGcGMYN0TVWxpDnDgzKwo
         Sn8KgAnX3Dqr2DHvQq7giIwC7f3lhi+kcRoL/8LehEI/rffUn3WrBJZ7PUzr+K0fk+LF
         3sgy2ohuaE4/5OXLE3ypBhTI791f8U2Yxi2cNcpkYjLJ+jMGpbnsZAXbtuyL9H8KRcfT
         BfxnGK6fVn/MukkAjQWVbvxmHBPv6KoT4qc0ZfOHIgCmyE6ku5nUPwwVwsgSAkbnx1be
         mvULDO+PA8uoEmjtRBlYiJAhSW4J27kO1AW0UWMQe7a4B/5qoElH2N2hDnuEjD1gutqO
         8rYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hgWgrZvCEmu6uRu0ctlC2UMyMXZuVubNemvY+msKWUs=;
        b=tZ9KVlMFhKyg7dDtuPJqIBd15X6VqWQL5AY83kthOMiLNE4EYlZUFA8TAHkuDGthEP
         O478uGq6Ys5stMjUqgn2Q0Kz8g3cNwBVagUCAWf7CwePBNl0KmEnfflnqwutXqeNOSU+
         gC9bsmCmvQ1JS00J6fQfzcKWK5kUu1XKX7ozEkCvN7ocz6yeBax1kVC3T0jUzwAajVg1
         FDTxH7SASPiSZUkTvfHPr3cpk/3irHJ6iuFUXj4COIAOjHRSOjzEOUTqQD1pHBq5/ZBv
         bwFLxhIdhIRJqxA9ndu/kZr+vxRqmwVLOOphy8Jq+Yc9cSayY58MfdwCIWh8MEgS4Wng
         lYBQ==
X-Gm-Message-State: APjAAAWhE42ktsmMuYM68oSGFmcWXMhBot7AYyyJNTcxRWFexH/LFxMW
        Nwvmucm8qiyXYTE7i6WzmnGnIe7a3vC07Q==
X-Google-Smtp-Source: APXvYqzGZgnxMtHXNFEV+xiae1mjPrVibLyz3T4sadssLs+sePG/fQ6rtalBuu5BNt6s/9y1NMGKOg==
X-Received: by 2002:a37:6e42:: with SMTP id j63mr5250429qkc.400.1582908593217;
        Fri, 28 Feb 2020 08:49:53 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id l184sm5323474qkc.107.2020.02.28.08.49.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Feb 2020 08:49:52 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j7ipk-0003JN-Bl; Fri, 28 Feb 2020 12:49:52 -0400
Date:   Fri, 28 Feb 2020 12:49:52 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bernard Metzler <BMT@zurich.ibm.com>
Cc:     syzbot <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
        chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Subject: Re: Re: Re: possible deadlock in cma_netdev_callback
Message-ID: <20200228164952.GV31668@ziepe.ca>
References: <20200228133500.GN31668@ziepe.ca>
 <20200227164622.GJ31668@ziepe.ca>
 <20200227155335.GI31668@ziepe.ca>
 <20200226204238.GC31668@ziepe.ca>
 <000000000000153fac059f740693@google.com>
 <OF0B62EDE7.E13D40E8-ON0025851B.0037F560-0025851B.0037F56C@notes.na.collabserv.com>
 <OF0C6D63D8.F1817050-ON0025851B.0059D878-0025851B.0059D887@notes.na.collabserv.com>
 <OFF9E6CFC6.7E79459D-ON0025851C.00472582-0025851C.0047F357@notes.na.collabserv.com>
 <OFE6F5FD43.5CAFDF8A-ON0025851C.005AC3E0-0025851C.005BBD83@notes.na.collabserv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFE6F5FD43.5CAFDF8A-ON0025851C.005AC3E0-0025851C.005BBD83@notes.na.collabserv.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 04:42:02PM +0000, Bernard Metzler wrote:

> Well, right, marking a socket via setsockopt SO_BINDTODEVICE
> does not work - I get -EPERM. Maybe works only from user land
> since the ifname gets copied in from there.
> 
> What I tested as working is nailing the scope of wildcard
> listen via:
> s->sk->sk_bound_dev_if = netdev->ifindex;

That sounds potentially right
 
> I am not sure what is the right way of limiting the scope
> of a socket to one interface in kernel mode. Is above line
> the way to go, or do I miss an interface to do such things?
> Anybody could help?

I didn't find an alternative, but not a lot of places touching this
outside the implementators of a socket type.
 
Jason
