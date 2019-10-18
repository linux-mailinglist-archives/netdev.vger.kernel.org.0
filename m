Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5642DD55A
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbfJRX3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:29:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbfJRX3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 19:29:31 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B71C6C0568FA
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 23:29:30 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id o10so3400155wrm.22
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:29:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hcIxm9jv0UI0SlMn3IcgXaZqhKiM4MiyXkrM9/zy9BE=;
        b=H6cbrQ4/G5SLbF8f8FYGUdIWll1RB6VunthlOaZvscFBGfFFuxfuuRX59LMPaTSqbv
         miNkkXsSqXie4DELzGBE13e+tDuoLm/BlcPjir7Iw9LWu3rKA1b8n8fBDW5OyDJKLEhn
         zb9PL294FXa6q9AEM+X7B72b+KdA4M+BR11mRQFPFd0v21OZK9fqP24azL/shZX3MGYJ
         4hiJ9EjXhS9k+7QD3BkT/1hJtbLUXTJETKWV6eTx2rruTDh0lAGLqTzfh/SuidDc7I0K
         vWWsk/mqNo1+chGxy2aM3Zu65a4yeLMRhH0lX6MUgkWGItzNYwZtotzvGZH6DUa2V7oj
         htqw==
X-Gm-Message-State: APjAAAVdF1gegwNdppjF4v/DVP0lo8Q44OyxEknt/7TkszrBhcgEhHdJ
        7FBh8yoeLWwNQsjjAheCG6sCwMb8+6WrF2JgPoeZLEdMSM9Hfq++7ijXNv5K6xA9/j17DAddl91
        eaqJ/Bhww2wKaXDkz
X-Received: by 2002:a5d:4885:: with SMTP id g5mr10670640wrq.219.1571441369466;
        Fri, 18 Oct 2019 16:29:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx89YcwEfLloFBGLu0vLfO7ARMurFlF84W2UgTkE7UbpLeVX4ihEQDS/4sQoMT4A6bcKjIcrg==
X-Received: by 2002:a5d:4885:: with SMTP id g5mr10670628wrq.219.1571441369253;
        Fri, 18 Oct 2019 16:29:29 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id f18sm6138383wmh.43.2019.10.18.16.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 16:29:28 -0700 (PDT)
Date:   Sat, 19 Oct 2019 01:29:26 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Jesse Gross <jesse@nicira.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        Jiri Benc <jbenc@redhat.com>
Subject: Re: [RFC PATCH net] netns: fix GFP flags in rtnl_net_notifyid()
Message-ID: <20191018232926.GA31917@linux.home>
References: <41b3fbfe3aac5ca03f4af0f1c4e146ae67c20570.1570734410.git.gnault@redhat.com>
 <CAOrHB_Dfoy3hiVVWu7+4fgm_U+rcB_CPuRV58XqB7kKOBcGb1w@mail.gmail.com>
 <20191013222231.GA4647@linux.home>
 <CAOrHB_DrnQ4NX=SkE_gwBL_LnamRCGqY_YB-_8VZNscPKiELcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_DrnQ4NX=SkE_gwBL_LnamRCGqY_YB-_8VZNscPKiELcw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 01:55:46PM -0700, Pravin Shelar wrote:
> On Sun, Oct 13, 2019 at 3:22 PM Guillaume Nault <gnault@redhat.com> wrote:
> > The point of my RFC is to know if it's possible to avoid all these
> > gfp_t flags, by allowing ovs_vport_cmd_fill_info() to sleep (at least
> > I'd like to figure out if it's worth spending time investigating this
> > path).
> >
> > To do so, we'd requires moving the ovs_vport_cmd_fill_info() call of
> > ovs_vport_cmd_{get,dump}() out of RCU critical section. Since we have
> > no reference counter, I believe we'd have to protect these calls with
> > ovs_lock() instead of RCU. Is that acceptable? If not, is there any
> > other way?
> 
> I do not see point of added complexity and serialized OVS flow dumps
> just to avoid GFP_ATOMIC allocations in some code path. What is issue
> passing the parameter as you have done in this patch?
> 
Adding the gfp_t parameter certainly isn't complex, but that's still
code churn for the affected functions. And since only very few call
paths actually needed GFP_ATOMIC, I wanted to investigate the
possibility of converting them.

But I'm fine with keeping the patch as is. I'll repost it formally.

Thanks for your review.

Guillaume
