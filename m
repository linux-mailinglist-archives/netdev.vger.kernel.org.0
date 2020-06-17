Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2531FCDE9
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 14:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgFQM4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 08:56:05 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:46289 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgFQM4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 08:56:01 -0400
Received: by mail-ej1-f67.google.com with SMTP id p20so2155867ejd.13;
        Wed, 17 Jun 2020 05:55:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fOVgSeVqTVqWvUfLoOdj4nt+48hh42lucWZp1VWswtg=;
        b=dH49tmuZwIi2AW45bvCm3iTsdIn3uF71ykSn9PsnXeadpR8w4CiekLmYpZM958HwJD
         ibgE+xf/ARAeXcjze6WrTSv5kWz7b8jTpIZP8lCgh3Ylunh3gjcMdzhvwrFj+vqHznwg
         rXWDmWvWLvm2e4k8WV0pN2mW4Bnb86WB17lGi1mJqvxtygd7za3zqTFaYjfZJY22Zxhx
         82tjvjiERWaV0Yt8ZqtypoDKflVAblaEOMwz6De3hPO1oN+J4thsHfe7IhMjPM4f9vzY
         7KAKmVbgfZKj2sH/BeUJ6fCaZrsjP79n5Sfl/vPFusfBPpcILYmSLk3eh1Dy43dOJL87
         2WTw==
X-Gm-Message-State: AOAM530bhtu6+RkmEZpogtJgUxdROzQTUK2XsEI7R0YXnSFuAtjx2e2X
        yl1V8OEEuJPvrEpbgOi6IDA=
X-Google-Smtp-Source: ABdhPJz5smjYQcDGdXsq8Ug+fgHwHPeIMnfqM9kX0E57nHrzErZZpyVOrifVPC/iAZURBZCGoIl/9Q==
X-Received: by 2002:a17:906:aad8:: with SMTP id kt24mr7265073ejb.527.1592398555771;
        Wed, 17 Jun 2020 05:55:55 -0700 (PDT)
Received: from localhost (ip-37-188-158-19.eurotel.cz. [37.188.158.19])
        by smtp.gmail.com with ESMTPSA id mh14sm13501385ejb.116.2020.06.17.05.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 05:55:54 -0700 (PDT)
Date:   Wed, 17 Jun 2020 14:55:53 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dsterba@suse.cz, Joe Perches <joe@perches.com>,
        Waiman Long <longman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-mm@kvack.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, wireguard@lists.zx2c4.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH v4 0/3] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-ID: <20200617125553.GO9499@dhcp22.suse.cz>
References: <20200616015718.7812-1-longman@redhat.com>
 <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
 <20200616230130.GJ27795@twin.jikos.cz>
 <20200617003711.GD8681@bombadil.infradead.org>
 <20200617071212.GJ9499@dhcp22.suse.cz>
 <20200617110820.GG8681@bombadil.infradead.org>
 <20200617113157.GM9499@dhcp22.suse.cz>
 <20200617122321.GJ8681@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617122321.GJ8681@bombadil.infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 17-06-20 05:23:21, Matthew Wilcox wrote:
> On Wed, Jun 17, 2020 at 01:31:57PM +0200, Michal Hocko wrote:
> > On Wed 17-06-20 04:08:20, Matthew Wilcox wrote:
> > > If you call vfree() under
> > > a spinlock, you're in trouble.  in_atomic() only knows if we hold a
> > > spinlock for CONFIG_PREEMPT, so it's not safe to check for in_atomic()
> > > in __vfree().  So we need the warning in order that preempt people can
> > > tell those without that there is a bug here.
> > 
> > ... Unless I am missing something in_interrupt depends on preempt_count() as
> > well so neither of the two is reliable without PREEMPT_COUNT configured.
> 
> preempt_count() always tracks whether we're in interrupt context,
> regardless of CONFIG_PREEMPT.  The difference is that CONFIG_PREEMPT
> will track spinlock acquisitions as well.

Right you are! Thanks for the clarification. I find the situation
around preempt_count quite confusing TBH. Looking at existing users
of in_atomic() (e.g. a random one zd_usb_iowrite16v_async which check
in_atomic and then does GFP_KERNEL allocation which would be obviously
broken on !PREEMPT if the function can be called from an atomic
context), I am wondering whether it would make sense to track atomic
context also for !PREEMPT. This check is just terribly error prone.

-- 
Michal Hocko
SUSE Labs
