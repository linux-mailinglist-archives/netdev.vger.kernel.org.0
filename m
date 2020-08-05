Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E151E23C805
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 10:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgHEIof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 04:44:35 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41863 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725868AbgHEIoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 04:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596617072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fhhymBT52dbtmC7E9vyh3NbHhcoDPj2MtP/Yl5ytDXw=;
        b=bwEb1wA2Q2qw5iNqvauIfJiIF7Wd4YZEuQyuy+o54Hd2foLKpYm+mTRKQ2KdzNqXC837T3
        qs+ezro57vheh4cGBhP5xb9nvqwRSSbm3AUS2WKfxLGuEfZCltKsMo4SBrEEDZKKl87joz
        /LdbVpV2CWCHas6vn/Dw4K9ZXYaxbqo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-7jqZldJqNZi9CeZAunDsWQ-1; Wed, 05 Aug 2020 04:44:31 -0400
X-MC-Unique: 7jqZldJqNZi9CeZAunDsWQ-1
Received: by mail-wr1-f72.google.com with SMTP id b13so10613408wrq.19
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 01:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fhhymBT52dbtmC7E9vyh3NbHhcoDPj2MtP/Yl5ytDXw=;
        b=GTDwsgGgNMZ9zp62PBtFJKq76jLnp0FRX3iQxN6ZyCukNM45EOG9df5sCD2mZOSZe7
         lDNsU3M1aIguQcbA9gkyOyxAkAMNqfU4IP1kRDFqroC5farJ5EEnNJp8rAKJlunmIRDM
         Zn1OBSvSI7FlKNr+CRhfv/5XPTEAHYvWkTOYzYbuHzutwP3zFWurp5qf+Cvz6AZEEq5N
         6ZHODHvpQUsZmNWSNYJNTkL3LRggPuAOF7BvJKVz4W2Iyb6uOQbA0s7HY1V9EtVYfapY
         n9SdztE15rbkRRrD2QTGeUWhn5lcmOaJCpeW+n4AkcK2ieaci+ZNVh6ezpT7zjK26Zbq
         RQYw==
X-Gm-Message-State: AOAM533aYWpG32bb7aAYft14JI/Y0oYL1S0RQugqAppWV9hMmFMX4XjH
        2tXuFV9s4AmNsZKqWmTMLgbmzUmz3CFcCIYm9yTIiP6hyqgZ+4oCElwGv3pDb+8wKRDa/Oz372v
        WAZhDpEDw0ZaPYR+M
X-Received: by 2002:a5d:6a8b:: with SMTP id s11mr1774621wru.222.1596617069795;
        Wed, 05 Aug 2020 01:44:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbhaEHT7XWY3F99iUCvr5nNuN4YlYWAkKqq9oNQJZhKhTSSlTdH9Gvv7nZcNTK6HH6ZWmqUA==
X-Received: by 2002:a5d:6a8b:: with SMTP id s11mr1774610wru.222.1596617069621;
        Wed, 05 Aug 2020 01:44:29 -0700 (PDT)
Received: from pc-2.home (2a01cb058d688e004215272ec6f01a3e.ipv6.abo.wanadoo.fr. [2a01:cb05:8d68:8e00:4215:272e:c6f0:1a3e])
        by smtp.gmail.com with ESMTPSA id t189sm1830512wmf.47.2020.08.05.01.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 01:44:28 -0700 (PDT)
Date:   Wed, 5 Aug 2020 10:44:27 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Andreas Karis <akaris@redhat.com>
Subject: Re: [PATCH net] Revert "vxlan: fix tos value before xmit"
Message-ID: <20200805084427.GC11547@pc-2.home>
References: <20200805024131.2091206-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805024131.2091206-1-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 10:41:31AM +0800, Hangbin Liu wrote:
> This reverts commit 71130f29979c7c7956b040673e6b9d5643003176.
> 
> In commit 71130f29979c ("vxlan: fix tos value before xmit") we want to
> make sure the tos value are filtered by RT_TOS() based on RFC1349.
> 
>        0     1     2     3     4     5     6     7
>     +-----+-----+-----+-----+-----+-----+-----+-----+
>     |   PRECEDENCE    |          TOS          | MBZ |
>     +-----+-----+-----+-----+-----+-----+-----+-----+
> 
> But RFC1349 has been obsoleted by RFC2474. The new DSCP field defined like
> 
>        0     1     2     3     4     5     6     7
>     +-----+-----+-----+-----+-----+-----+-----+-----+
>     |          DS FIELD, DSCP           | ECN FIELD |
>     +-----+-----+-----+-----+-----+-----+-----+-----+
> 
> So with
> 
> IPTOS_TOS_MASK          0x1E
> RT_TOS(tos)		((tos)&IPTOS_TOS_MASK)
> 
> the first 3 bits DSCP info will get lost.
> 
> To take all the DSCP info in xmit, we should revert the patch and just push
> all tos bits to ip_tunnel_ecn_encap(), which will handling ECN field later.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

I guess an explicit
Fixes: 71130f29979c ("vxlan: fix tos value before xmit").
tag would help the -stable maintainers.

Apart from that,
Acked-by: Guillaume Nault <gnault@redhat.com>

