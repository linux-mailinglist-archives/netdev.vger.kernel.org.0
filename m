Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1F823EFBC
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 17:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHGPDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 11:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgHGPDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 11:03:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82C5C061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 08:03:43 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d19so1014023pgl.10
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 08:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qR5hMo6nGGMQINCTQxm63tRZFYzEEptzzm9cFhtklBI=;
        b=eEEqYIF+iwv+VXv0uJMIc1FI7hPWUh7j042hW9kZdW28CY1emjrLA3CbP7HN9phQQ2
         rK0MtGQhTacAbUy45blfLZ00bhdU0UnHB4yXLplM5PphKkIFW9LLCe9VOtJbGO8mf0l9
         90V+/XLpdqThgVR4trthPswC15o/kXs9DXVj49Kvafj1fNprHsfiJmPVxyQoQq4Q54W6
         gkE15plDgk9+tKgBv4JsxoaUB7wsjqcqYaFkBqJBEPeQ06BVA5eiPh/aC7fMFdXLH3Tv
         dRhlTXQUF6Q3G0nMweSMHkTyQE5sO9gqPUnhdEQj4LwbXvHAOn3xzUyjGPIiHyxCaH3p
         FviQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qR5hMo6nGGMQINCTQxm63tRZFYzEEptzzm9cFhtklBI=;
        b=RUUu9QMXEJqazy1BCdxnh5fPGhUg9/AeTj1Qi43/x8pg9Uv1MeOXSnmuAoBXUFyzpx
         hkmNlaYG2JFJvrY71fM9CeDwXF9h1A8Kr0bg0KDegwdw+lCG3rX2r6kN/hsRXrDvPCrs
         QwXXHwYOj3MIWK6R0TP53yh4AmIiBdeYKwZNcu21bsv5hQp4WbTR9XDL62xRD/ozppmx
         LQ0mutlc64vCynLpFKDG7ScahAv1Dur8tLi4Nad6glOMN4rsj+HT5yzv0Pmi55UqLXyu
         Ohnhh8G46mNKRYCq8IauHom06bzLoRAvZ2oahSpgwplL9dnAvXQ2ZcJEryB0xVoHKk3k
         uS6A==
X-Gm-Message-State: AOAM531uHV5QQdlmtnIj8/ZdqFIncYN2vvtbkOy4Nhx0k+0RtFLDWjje
        6sV7p1alZO5vgLxNcJ41Z2y606hYPoE=
X-Google-Smtp-Source: ABdhPJyVajiuTpKS4Got3Wy4WZQFgHZban/OaotDRQULuLHsNbJoaeuG0IXUv7OjmYlmqOAyyIT3cw==
X-Received: by 2002:a65:6381:: with SMTP id h1mr12374547pgv.0.1596812620939;
        Fri, 07 Aug 2020 08:03:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g12sm12342946pfb.190.2020.08.07.08.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 08:03:40 -0700 (PDT)
Date:   Fri, 7 Aug 2020 08:03:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: rtnl_trylock() versus SCHED_FIFO lockup
Message-ID: <20200807080332.3d31231d@hermes.lan>
In-Reply-To: <29a82363-411c-6f2b-9f55-97482504e453@prevas.dk>
References: <b6eca125-351c-27c5-c34b-08c611ac2511@prevas.dk>
        <20200805163425.6c13ef11@hermes.lan>
        <191e0da8-178f-5f91-3d37-9b7cefb61352@prevas.dk>
        <2a6edf25-b12b-c500-ad33-c0ec9e60cde9@cumulusnetworks.com>
        <20200806203922.3d687bf2@hermes.lan>
        <29a82363-411c-6f2b-9f55-97482504e453@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Aug 2020 10:03:59 +0200
Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:

> On 07/08/2020 05.39, Stephen Hemminger wrote:
> > On Thu, 6 Aug 2020 12:46:43 +0300
> > Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> >   
> >> On 06/08/2020 12:17, Rasmus Villemoes wrote:  
> >>> On 06/08/2020 01.34, Stephen Hemminger wrote:    
> >>>> On Wed, 5 Aug 2020 16:25:23 +0200  
> 
> >>
> >> Hi Rasmus,
> >> I haven't tested anything but git history (and some grepping) points to deadlocks when
> >> sysfs entries are being changed under rtnl.
> >> For example check: af38f2989572704a846a5577b5ab3b1e2885cbfb and 336ca57c3b4e2b58ea3273e6d978ab3dfa387b4c
> >> This is a common usage pattern throughout net/, the bridge is not the only case and there are more
> >> commits which talk about deadlocks.
> >> Again I haven't verified anything but it seems on device delete (w/ rtnl held) -> sysfs delete
> >> would wait for current readers, but current readers might be stuck waiting on rtnl and we can deadlock.
> >>  
> > 
> > I was referring to AB BA lock inversion problems.  
> 
> Ah, so lock inversion, not priority inversion.
> 
> > 
> > Yes the trylock goes back to:
> > 
> > commit af38f2989572704a846a5577b5ab3b1e2885cbfb
> > Author: Eric W. Biederman <ebiederm@xmission.com>
> > Date:   Wed May 13 17:00:41 2009 +0000
> > 
> >     net: Fix bridgeing sysfs handling of rtnl_lock
> >     
> >     Holding rtnl_lock when we are unregistering the sysfs files can
> >     deadlock if we unconditionally take rtnl_lock in a sysfs file.  So fix
> >     it with the now familiar patter of: rtnl_trylock and syscall_restart()
> >     
> >     Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > 
> > The problem is that the unregister of netdevice happens under rtnl and
> > this unregister path has to remove sysfs and other objects.
> > So those objects have to have conditional locking.  
> I see. And the reason the "trylock, unwind all the way back to syscall
> entry and start over" works is that we then go through
> 
> kernfs_fop_write()
> 	mutex_lock(&of->mutex);
> 	if (!kernfs_get_active(of->kn)) {
> 		mutex_unlock(&of->mutex);
> 		len = -ENODEV;
> 		goto out_free;
> 	}
> 
> which makes the write fail with ENODEV if the sysfs node has already
> been marked for removal.
> 
> If I'm reading the code correctly, doing "ip link set dev foobar type
> bridge fdb_flush" is equivalent to writing to that sysfs file, except
> the former ends up doing an unconditional rtnl_lock() and thus won't
> have the livelocking issue.
> 
> Thanks,
> Rasmus

ip commands use netlink, and netlink doesn't have the problem because
it doesn't go through a filesystem API.
