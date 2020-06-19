Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FD920023F
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 08:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgFSG4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 02:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgFSG4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 02:56:46 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3965DC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 23:56:46 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id f7so9026548ejq.6
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 23:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5TVB8AvoKed0IObqy3JORSCNfa52oRkEdOV2Y1HSGJc=;
        b=Z9NtIydUIsjtvirR7mfQd8Pg6WypabDP7ltsj3OXPZOeZvwm7vYHZkI3VRwBY90tnF
         5bL0FCFifW2Ev+Fl9Exl0qDEkyQJJeVFYYq0tiIlMWxSYXxgbA5fqTGCAVy+ZdEUEW4X
         /GwHnGGdCt0D9PO+lwr0mRwdfSJxkszQRI4yuLP0vkD6GoJ62cZQVU6mmXQQF0AU5eY7
         zGlGixYfUOqffOCvBuO9oEIDnjCGPdk4bDbKo2Cvke0Ckf42/wYLrDfmtG2FLx4FLvwP
         oNY+b3Wweu9LwMo+6xdbpGUlov9oW4FE9je1xJQ3Qr1X4QgV2orfk3yf9Ohne4hXf8B0
         PTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5TVB8AvoKed0IObqy3JORSCNfa52oRkEdOV2Y1HSGJc=;
        b=QfmfUtt871u8AHicP9PQjJLtP4SvK1sVWjRfkf7P+k3GdaeJmFeGxlH7uHLBd8dQhH
         o0vAOetF3uKo7aPEf9//RoT9+cLE/8O3HXo9jeuJ2bursjCAHtJgDOl7C5T/9CULlPII
         3umUgz3NvUGStFP1u38W3S4q4kOpC/B8leeUfZhVctiiStdD5tsEvDzRnPb2ogF23ZS4
         +EZlqEzzJP8JbYdETUPiJxbMVbZnA7O5Y4wIPbAk+k7qLqleQO32EiUH7prIv86b/+Dn
         Ck/uB4lIEdHkDaMxrVkxGgts0RHkLuu5YCuCw46+So/YvWF5PJgOnhFd8We9X9LWmQ/c
         aiRg==
X-Gm-Message-State: AOAM532ytP59VPIzsl0DupjgRdVSnvd+kUMVUs0xY7S0W+54Vc/4zvB1
        ZZlO0IPs+qTT+ZgGQ9tc+pqUug==
X-Google-Smtp-Source: ABdhPJz9u/KRGDpA5O9HHh81wWYY5r3vmuAE7IV865Nua0MIMzXTLkx3Y+ZIWLG/jIHVN/XAGinEmQ==
X-Received: by 2002:a17:906:c672:: with SMTP id ew18mr2377822ejb.404.1592549804971;
        Thu, 18 Jun 2020 23:56:44 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id ew9sm4102452ejb.121.2020.06.18.23.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 23:56:44 -0700 (PDT)
Date:   Fri, 19 Jun 2020 08:56:43 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        lucien.xin@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2] tc: m_tunnel_key: fix geneve opt output
Message-ID: <20200619065642.GC9312@netronome.com>
References: <20200618104420.499155-1-liuhangbin@gmail.com>
 <20200618105107.GB27897@netronome.com>
 <20200619022524.GX102436@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619022524.GX102436@dhcp-12-153.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 10:25:24AM +0800, Hangbin Liu wrote:
> On Thu, Jun 18, 2020 at 12:51:08PM +0200, Simon Horman wrote:
> > On Thu, Jun 18, 2020 at 06:44:20PM +0800, Hangbin Liu wrote:
> > > Commit f72c3ad00f3b changed the geneve option output from "geneve_opt"
> > > to "geneve_opts", which may break the program compatibility. Reset
> > > it back to geneve_opt.
> > > 
> > > Fixes: f72c3ad00f3b ("tc: m_tunnel_key: add options support for vxlan")
> > > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > 
> > Thanks Hangbin.
> > 
> > I agree that the patch in question did change the name of the option
> > as you describe, perhaps inadvertently. But I wonder if perhaps this fix
> > is too simple as the patch mentioned also:
> > 
> > 1. Documents the option as geneve_opts
> > 2. Adds vxlan_opts
> > 
> > So this patch invalidates the documentation and creates asymmetry between
> > the VXLAN and Geneve variants of this feature.
> 
> Not sure if I understand you comment correctly. This patch only fix the cmd
> output(revert to previous output format), The cmd option is not changed. e.g.
> 
> # tc actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 \
>      dst_port 6081 geneve_opts 0102:80:00880022 index 1
> # tc actions get action tunnel_key index 1
> total acts 0
> 
>         action order 1: tunnel_key  set
>         src_ip 1.1.1.1
>         dst_ip 2.2.2.2
>         key_id 42
>         dst_port 6081
>         geneve_opt 0102:80:00880022
>         csum pipe
>          index 1 ref 1 bind 0
> 
> But this do make a asymmetry for vxlan and geneve output. I prefer
> to let them consistent personally. Also it looks more reasonable
> to output "geneve_opts" when we have parameter geneve_opts.
> 
> So I'm not going to fix it in iproute, but do as Davide mentioned, make
> tdc test case accept both 'geneve_opts' and 'geneve_opt'.

Thanks. I agree this seems to be the best way forward.
