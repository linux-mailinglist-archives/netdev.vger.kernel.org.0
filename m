Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1F61FC6D1
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 09:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgFQHMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 03:12:21 -0400
Received: from mail-ej1-f65.google.com ([209.85.218.65]:34229 "EHLO
        mail-ej1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgFQHMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 03:12:19 -0400
Received: by mail-ej1-f65.google.com with SMTP id l27so1176601ejc.1;
        Wed, 17 Jun 2020 00:12:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E5EcWVbc+7tsS+GAmjqiwsU8zuC9ZQ4KDsXaJSfWulo=;
        b=hpp62K4a8CwZm2UreL6e+o7U64jJN0cGZO64x4/KaxFcj3JVTRwtGgvvphlWOGIwmB
         mKDjFk36BUKL84X0A9sBPYLln2swyjTrxBpOKfntaidgraTsEqWSInVYjR+f229KLn86
         JQgPgDrHQKjlcGt4G5FRUs/LnXp6LNLqNd3mRfMJQtEv721UDpyA2floMIWMSRRU63gC
         qmC2URd5guep9hGNbmRJS4tl3WdSME9dwc9fVWomUGjNxDBIdLQAdimTtHyDG+qL4Z/x
         N3yZtL4KoRdctI+kyJccwtPMuNdYqp+mPDxIX3roHMzcx6zoabwiEq+N3FeX8asH5wbJ
         BPbw==
X-Gm-Message-State: AOAM532QhxsCV6VV0nmw55nyn7fUqk+2MaOyho+lUa6ubnTkcAd2T2f0
        jAq+dwgSw/eEUQy0iHHJ2nc=
X-Google-Smtp-Source: ABdhPJzxXEZ/32Vk1uutSgWgDm/2Kml+FRFv6q/oUOzaHXvM3d9a7wcEm5DrSyb0iZ8v3ZPtZ+pKKg==
X-Received: by 2002:a17:906:2581:: with SMTP id m1mr6681797ejb.89.1592377934427;
        Wed, 17 Jun 2020 00:12:14 -0700 (PDT)
Received: from localhost (ip-37-188-158-19.eurotel.cz. [37.188.158.19])
        by smtp.gmail.com with ESMTPSA id g22sm12516138ejo.1.2020.06.17.00.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 00:12:13 -0700 (PDT)
Date:   Wed, 17 Jun 2020 09:12:12 +0200
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
Message-ID: <20200617071212.GJ9499@dhcp22.suse.cz>
References: <20200616015718.7812-1-longman@redhat.com>
 <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
 <20200616230130.GJ27795@twin.jikos.cz>
 <20200617003711.GD8681@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617003711.GD8681@bombadil.infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 16-06-20 17:37:11, Matthew Wilcox wrote:
> On Wed, Jun 17, 2020 at 01:01:30AM +0200, David Sterba wrote:
> > On Tue, Jun 16, 2020 at 11:53:50AM -0700, Joe Perches wrote:
> > > On Mon, 2020-06-15 at 21:57 -0400, Waiman Long wrote:
> > > >  v4:
> > > >   - Break out the memzero_explicit() change as suggested by Dan Carpenter
> > > >     so that it can be backported to stable.
> > > >   - Drop the "crypto: Remove unnecessary memzero_explicit()" patch for
> > > >     now as there can be a bit more discussion on what is best. It will be
> > > >     introduced as a separate patch later on after this one is merged.
> > > 
> > > To this larger audience and last week without reply:
> > > https://lore.kernel.org/lkml/573b3fbd5927c643920e1364230c296b23e7584d.camel@perches.com/
> > > 
> > > Are there _any_ fastpath uses of kfree or vfree?
> > 
> > I'd consider kfree performance critical for cases where it is called
> > under locks. If possible the kfree is moved outside of the critical
> > section, but we have rbtrees or lists that get deleted under locks and
> > restructuring the code to do eg. splice and free it outside of the lock
> > is not always possible.
> 
> Not just performance critical, but correctness critical.  Since kvfree()
> may allocate from the vmalloc allocator, I really think that kvfree()
> should assert that it's !in_atomic().  Otherwise we can get into trouble
> if we end up calling vfree() and have to take the mutex.

FWIW __vfree already checks for atomic context and put the work into a
deferred context. So this should be safe. It should be used as a last
resort, though.

-- 
Michal Hocko
SUSE Labs
