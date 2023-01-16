Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B800266BD3A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjAPLxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjAPLxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:53:15 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1891F4BE
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:53:13 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id j17so1280173wms.0
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aDrC1xEu4/QiEti9zG/HWQlO7iw2abAFiSH/grktSW0=;
        b=ZaHiLfnBwTqxUG3c7wxl3yfHeSJobGv6sY/9cNKNLyLn9A2SM8gYFsKZSLfmED0VbY
         wMvn7I9Y9Cp39XRfO3FbMQ8XF2gCQMJHIHtgHROlqJvx/OxwYQOc2dYZ6mjQH6Qtdj9K
         denLgs1vpUoGLWgMwDWVNxIUo+/pnpKZP1bWtW9ndbLPKeyf4bgc/+bgqPkK2kLhcFBD
         E5+gAEK23GIWEINEOIi4TYf8YW+7LYFcJcQ3KlqK9yTKs3Ra5ExRzYTqokWt/WScBJMc
         ZJRmg3sE7XqsN2yswkznvBTqRJydCkaFsLk1ac+wkPcak76w0pq+KaXBKfHiu8TObvkk
         VkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDrC1xEu4/QiEti9zG/HWQlO7iw2abAFiSH/grktSW0=;
        b=vFNayZ3k2mAtb1A1Z/akWUVl9AmuOMoYSFWWVu7t9GOXXk0Tf2emKppfW/jOV1yUUl
         1rB+yoNKCPWv6EVmzWSx0wpJE65OEYrE4k33xh14HurHl6VrQTuWi7lp4iChT+PJBuvx
         3xNs9huoNGSHHsUebfvmmTmziQzfCPxuhOfwheEcYID6ZAhJbTurmtSVtml+g2rBFKMw
         Z8myzEwXlkDWBIGkBxX+y1Pfa/DKog+wDjSsTXnjXEMqzxvq4aa/UEFGa3dh2VqcmTQH
         XViSynObaWKedwJdUJVbDK0SlrZSS8BQlduiw4Nc7IGxBm8A/Th4xFhjsmF458aAwEjx
         8VNA==
X-Gm-Message-State: AFqh2ko//jSpyn4gwwMBFHTx2G4cYfj3W+oLs0GifBQCamelqvRD5vsw
        l9JKO0HLoI6CJGvqI+MQCKk=
X-Google-Smtp-Source: AMrXdXvN3+98vLOKHjimne/NAZlOHql3hg8wVhFkDE7T30nmT6wEMMveM8+6vpcjPn/H3V+G3JJEWg==
X-Received: by 2002:a05:600c:35c7:b0:3d3:5d0f:6dfc with SMTP id r7-20020a05600c35c700b003d35d0f6dfcmr66930655wmq.30.1673869992531;
        Mon, 16 Jan 2023 03:53:12 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k30-20020a05600c1c9e00b003d9b89a39b2sm37355701wms.10.2023.01.16.03.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 03:53:12 -0800 (PST)
Date:   Mon, 16 Jan 2023 14:53:09 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     oe-kbuild@lists.linux.dev, netdev@vger.kernel.org, lkp@intel.com,
        oe-kbuild-all@lists.linux.dev, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
Subject: Re: [PATCH bpf 1/3] bpf, sockmap: Check for any of tcp_bpf_prots
 when cloning a listener
Message-ID: <Y8U6pd6Ox8fDXZc0@kadam>
References: <20230113-sockmap-fix-v1-1-d3cad092ee10@cloudflare.com>
 <202301141018.w4fQc4gd-lkp@intel.com>
 <87sfgayeg9.fsf@cloudflare.com>
 <Y8UxRmxdqGv92Szw@kadam>
 <87h6wqyaq6.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6wqyaq6.fsf@cloudflare.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 12:31:11PM +0100, Jakub Sitnicki wrote:
> >> Clang can do pointer arithmetic on 2D arrays just fine :-)
> >
> > Heh.  I must have an older version of Clang.
> >
> >   CC      net/ipv4/tcp_bpf.o
> > net/ipv4/tcp_bpf.c:644:41: warning: array index 2 is past the end of the array (that has type 'struct proto[2][4]') [-Warray-bounds]
> >         if (tcp_bpf_prots[0] <= prot && prot < tcp_bpf_prots[ARRAY_SIZE(tcp_bpf_prots)])
> >                                                ^             ~~~~~~~~~~~~~~~~~~~~~~~~~
> > net/ipv4/tcp_bpf.c:544:1: note: array 'tcp_bpf_prots' declared here
> > static struct proto tcp_bpf_prots[TCP_BPF_NUM_PROTS][TCP_BPF_NUM_CFGS];
> > ^
> > 1 warning generated.
> 
> FWIW, I've checked against:
> 
> $ clang --version
> clang version 15.0.6 (Fedora 15.0.6-2.fc37)
> 
> Gotta keep it fresh to be able to build bpf selftests ;-)
> But I sure don't want to break builds with older Clangs.

I'm actually on a newer 16.x something version from git.

Btw, it made me outrageously happy that Clang was one for one bug
compatible with Smatch on this.

With this kind of warning you could either print a warning when there is
a read but that's not what either Smatch or Clang do.  Smatch looks at
the offset and then checks to see if the code is just doing pointer
math to find the &(array + 1) address.

So Smatch checks is the offset known to be exactly ARRAY_SIZE() and are
we taking the address of that.  I have updated that check.

regards,
dan carpenter
