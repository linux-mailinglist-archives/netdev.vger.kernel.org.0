Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C417EB06
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 06:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbfHBEOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 00:14:10 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43432 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbfHBEOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 00:14:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id r22so7771779pgk.10
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 21:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S4ejoil/sB2rCOsYCSoaXxX2ikq5nqsgY+Wo0pzSAdw=;
        b=kqJM5/UhrkbVm0NUvC6DiUxR49fP1bEy1vCsUXkRiSm9T1RsvAAUxHybIWNoTzjxfE
         i34/Z5F5vqCGWlXS+4utUBJaDyFvApBJq9sfW+F35xsskUsNFmY9xTjR4ellmU/sBQqp
         6UcdxCxm4Jw+bbi8pvRvtceLoKHqERi7bw8tZAzrmhF8DMQ/QHx/7BrlqCQHl0lX1P3s
         yXA+kjVH6CGIGoOdUaEoyeMx2iNTUdjTSnstacEOUaP2ykTDB4/vufGX7ISC957V1tk5
         tbMDHg8OBfLE0uO58Dvsje7O/PlK2Bx+kuhukYkdJ3/6rDd1+EWi56qzmYWtb6xeLfPC
         Xjww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=S4ejoil/sB2rCOsYCSoaXxX2ikq5nqsgY+Wo0pzSAdw=;
        b=dPPWtv590UOde1tKAZ5I9IGveUDwUOvqGow+/k9KrHOOj3CAFIx5xrvhQQPiCrd43a
         CI65d7Yimftyu4XJFP/mL2y0r/dCppGECEJzJJuM4fZjAyNDbA4KybkXfxWzydNoMW5O
         f5J3VV3PjCzceDM4OLeYRwQc732/AjkpgvpSVE1AqgPO5mzGFg69HuAunLfbXqB9WuuA
         1pdXCeIxuRzP3ICg4FkKrMZ/HER+QT9o8+zpkvJt8aPMTBAHhwQNZ1qK0JQJCrfst+cX
         viTckvkBNKeB48akePuL7GhcUE8Xe+GbGMZtqt+d/PPZtw2Yp++gP8uLv1gZSvaW/pwD
         03Eg==
X-Gm-Message-State: APjAAAUgOQ1545sAiSLxcv1IAhhvNIknyhZNTylG3nWN799TBcf1HpSm
        /VbQPoPDiA7dOWiwWCFye4w=
X-Google-Smtp-Source: APXvYqyImToqCnIAbeCHzxaHTUF3ZaDnONpH/Ko7LTRiUPB1hHoL+pGPq5/EJa6p6KTYftYQbUoyWw==
X-Received: by 2002:a63:b64:: with SMTP id a36mr113456913pgl.215.1564719249398;
        Thu, 01 Aug 2019 21:14:09 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 185sm73763740pfd.125.2019.08.01.21.14.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 21:14:08 -0700 (PDT)
Date:   Fri, 2 Aug 2019 12:13:58 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] ipv4/route: do not check saddr dev if iif is
 LOOPBACK_IFINDEX
Message-ID: <20190802041358.GT18865@dhcp-12-139.nay.redhat.com>
References: <20190801082900.27216-1-liuhangbin@gmail.com>
 <f44d9f26-046d-38a2-13aa-d25b92419d11@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f44d9f26-046d-38a2-13aa-d25b92419d11@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 01:51:25PM -0600, David Ahern wrote:
> On 8/1/19 2:29 AM, Hangbin Liu wrote:
> > Jianlin reported a bug that for IPv4, ip route get from src_addr would fail
> > if src_addr is not an address on local system.
> > 
> > \# ip route get 1.1.1.1 from 2.2.2.2
> > RTNETLINK answers: Invalid argument
> 
> so this is a forwarding lookup in which case iif should be set. Based on

with out setting iif in userspace, the kernel set iif to lo by default.

> the above 'route get' inet_rtm_getroute is doing a lookup as if it is
> locally generated traffic.

yeah... but what about the IPv6 part. That cause a different behavior in
userspace.

Thanks
Hangbin
