Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDF8230861
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 13:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgG1LHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 07:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbgG1LHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 07:07:19 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C63C061794;
        Tue, 28 Jul 2020 04:07:19 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 11so18214467qkn.2;
        Tue, 28 Jul 2020 04:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wLRXskVaKu10kKah7+1ZWwTzJMplfGNwKsb4sfPQ7ak=;
        b=sgfX1eh6PjlazK3wgSHQ415H8m+UBPUU8R3tO4ZsSmhtZdu4jQ2SlzK4HgG1G0tLVE
         8tsuKH1q6TPaQ0PMrI6yt8WL1ek/r6OON4CbtPsXvG3ZfXcmoVUZ8XAliXnL14qphX2k
         fetgg6O4GWNMftHGuWYYAocPoHj+il/WpwHNlXoQnaXKumWPm+Lr0+s8e+qVOBJMYlsK
         t1Oc7wAlp/3ce4lc7aQaepamAIF/PN2KmGcLJJ8TPgiHnf+8ERMU1YNf/FeupwT3HHOO
         59kSCHtT3StU0YukVuenn6vZhohK4+0W/Gov1ibxaV8Fp9X8gJbNqApnjhjosIrZtUtj
         KxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wLRXskVaKu10kKah7+1ZWwTzJMplfGNwKsb4sfPQ7ak=;
        b=hJGeIrhXOdJF7OS091tqxZuxzD4bEv6YWf5X1gBSAwc5HtSCU72QcD1UxodOZ21ZBG
         FDa0Oh/b69gYISxYX77mpeZJZEfuJSnlp0odmB0LAwYC7ZAWo1rrASCqGnMUEFPhsXw8
         huBuJERDALz1iRzw5M7VQl9fvROmBhre2ft6Iqwk7lx3MvsyQOZInlBlYubfY77XNry+
         Q3RMekduYS6wrCxjHRyNd9iiK0eag6uj3S35UTFEN0m8NCS1zATAE0uDzdXFYJoTj+pN
         rC+SyDeKfaRwGcYIX4oi+c3YIMB6PHCLtRc/d9jmevbQwIAtvgVCmyUo12U4/IeqKqtX
         mdhQ==
X-Gm-Message-State: AOAM530rfQDCqSZ8V2tssj1DqGomnWzRGrfVLbW8SOSQPjCrwK2vuaAi
        Bb2hjXQP8KaCOzNqHPlx5g==
X-Google-Smtp-Source: ABdhPJz79jz26gc6l5wlMvRcfe2GL/jSAqrMl5vza+n4lcb8srjd1p60ZS+0Fyu2+CaVWeeLYpcouw==
X-Received: by 2002:a37:8a06:: with SMTP id m6mr27080177qkd.191.1595934438341;
        Tue, 28 Jul 2020 04:07:18 -0700 (PDT)
Received: from PWN (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id g21sm10634593qts.18.2020.07.28.04.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 04:07:17 -0700 (PDT)
Date:   Tue, 28 Jul 2020 07:07:15 -0400
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net v2] xdp: Prevent
 kernel-infoleak in xsk_getsockopt()
Message-ID: <20200728110715.GA407606@PWN>
References: <20200728022859.381819-1-yepeilin.cs@gmail.com>
 <20200728053604.404631-1-yepeilin.cs@gmail.com>
 <916dbfd3-e601-c4be-41f0-97efc4aaa456@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <916dbfd3-e601-c4be-41f0-97efc4aaa456@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 12:53:59PM +0200, Daniel Borkmann wrote:
> On 7/28/20 7:36 AM, Peilin Ye wrote:
> > xsk_getsockopt() is copying uninitialized stack memory to userspace when
> > `extra_stats` is `false`. Fix it.
> > 
> > Fixes: 8aa5a33578e9 ("xsk: Add new statistics")
> > Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > ---
> > Doing `= {};` is sufficient since currently `struct xdp_statistics` is
> > defined as follows:
> > 
> > struct xdp_statistics {
> > 	__u64 rx_dropped;
> > 	__u64 rx_invalid_descs;
> > 	__u64 tx_invalid_descs;
> > 	__u64 rx_ring_full;
> > 	__u64 rx_fill_ring_empty_descs;
> > 	__u64 tx_ring_empty_descs;
> > };
> > 
> > When being copied to the userspace, `stats` will not contain any
> > uninitialized "holes" between struct fields.
> 
> I've added above explanation to the commit log since it's useful reasoning for later
> on 'why' something has been done a certain way. Applied, thanks Peilin!

Ah, I see. Thank you for reviewing the patch!

Peilin Ye
