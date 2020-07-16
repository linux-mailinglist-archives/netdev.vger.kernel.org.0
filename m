Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA57222963
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgGPRUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:20:53 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59319 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728837AbgGPRUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 13:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594920049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KDc7j0JVn5smks6Jq9rATjJhQBFG9NqOHYxidS5qCm8=;
        b=fgIXJLSvCKA3iPHh/rJi6B1Yi5W37VvQ1NfUFGRs2Uwl1xFdh4Fb+7oYDXkbywwOIDCgPv
        WkWR0Ktipb77Zfba+rQltyh+PUJonbLhD/XqpacNzjCy8KD7iXdQp9YQUD5nlMnFU7P9D+
        tbh0k1MVNAx2AUlkM5vFWgjnEwx3jY4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-c-jMSNgGO-qLMy3urcFNGA-1; Thu, 16 Jul 2020 13:20:47 -0400
X-MC-Unique: c-jMSNgGO-qLMy3urcFNGA-1
Received: by mail-wm1-f70.google.com with SMTP id g187so5489738wme.0
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 10:20:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KDc7j0JVn5smks6Jq9rATjJhQBFG9NqOHYxidS5qCm8=;
        b=Mi5GslSRDiTA3moR/AXF/KS7aMq1lj0uh9WMmG8h2ygEGbni2tQ+YZ6SFGN/0kc1il
         /z6ZGw2pDUDy5VfMwzlsKtgXxm6zMNGA/xG5N3EfFpiAql96pKefUqEjVmlHkPXHrKol
         2tg0W8n5sY3lYHDudC343KAGGyhW32ZcQZDqKABt50HMBIH8A6yyaD4M1GGNSEe8U9/H
         NwZBxceb3w2+faROxtHag8Y+S8+bCqmeMcsAHPgkoDuv/ezsNCkWZMm0qxdn9M7Nmy6j
         k9pd2D5lQXQEL0Z6SB3EBb/4++8h+xsF4DCqNEPDJTRsbQTO2/QodJVln9auy8PKllIs
         KN0w==
X-Gm-Message-State: AOAM532oWYjROb7e+fJTxD3IX1QVM3DNwXnBhNmrHBP0CkVUS6BMnA2O
        vyyt12E+Wj0J38PtQ4+SAU+w9dokEoP0WSKw8kuXEHUGwNbrP5R/J51oScJTRjAFh+QUBRsA2Wn
        N2ORhVSCobG1hqTEJ
X-Received: by 2002:adf:f452:: with SMTP id f18mr5969618wrp.78.1594920046461;
        Thu, 16 Jul 2020 10:20:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyt6oo5J50iJn37+AY3IiFwdN8EJQ4no5Oz92ha6NRWgIIPvXpUESXkAYLoQI3yDXmb6be2hQ==
X-Received: by 2002:adf:f452:: with SMTP id f18mr5969597wrp.78.1594920046216;
        Thu, 16 Jul 2020 10:20:46 -0700 (PDT)
Received: from pc-2.home (2a01cb058529bf0075b0798a7f5975cb.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:bf00:75b0:798a:7f59:75cb])
        by smtp.gmail.com with ESMTPSA id b23sm10346301wmd.37.2020.07.16.10.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 10:20:45 -0700 (PDT)
Date:   Thu, 16 Jul 2020 19:20:43 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martinvarghesenokia@gmail.com>
Subject: Re: [PATCH iproute2] ip link: initial support for bareudp devices
Message-ID: <20200716172043.GC30783@pc-2.home>
References: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
 <20200706111109.5039ed3f@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706111109.5039ed3f@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 11:11:09AM -0700, Stephen Hemminger wrote:
> On Wed, 1 Jul 2020 21:45:04 +0200
> Guillaume Nault <gnault@redhat.com> wrote:
> 
> > Bareudp devices provide a generic L3 encapsulation for tunnelling
> > different protocols like MPLS, IP, NSH, etc. inside a UDP tunnel.
> > 
> > This patch is based on original work from Martin Varghese:
> > https://lore.kernel.org/netdev/1570532361-15163-1-git-send-email-martinvarghesenokia@gmail.com/
> > 
> > Examples:
> > 
> >   - ip link add dev bareudp0 type bareudp dstport 6635 ethertype mpls_uc
> > 
> > This creates a bareudp tunnel device which tunnels L3 traffic with
> > ethertype 0x8847 (unicast MPLS traffic). The destination port of the
> > UDP header will be set to 6635. The device will listen on UDP port 6635
> > to receive traffic.
> > 
> >   - ip link add dev bareudp0 type bareudp dstport 6635 ethertype ipv4 multiproto
> > 
> > Same as the MPLS example, but for IPv4. The "multiproto" keyword allows
> > the device to also tunnel IPv6 traffic.
> > 
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> 
> Applied. 
> Would it be possible to add a test for this in the iproute2 testsuite?

No problem, I'm working on it.

