Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C333550B
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 03:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfFEBn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 21:43:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44712 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfFEBn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 21:43:57 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so5013462pfe.11
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 18:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=+WdLUP9YIiQ/rXvTg+ZoWYsvSaRCqNtiQA+EPZf1FZQ=;
        b=Ee3G1+yO1fWDhOdNWRwSDCHmnJKVnpPQltuYZDzxBzcqfjokBkjSTAgmshseffz7Ik
         wpObD8/PAMnvzkqwRsI35bUeI+pPoa2ZqI4rNCvbpzboWg6XnWlIr9WEiGFCwZUlHeXJ
         PfPXEdm92iBf+hpSnrKdJF0mE+x4td1Ty0gukGQCgWk/uyV8ahcvKxNQJDZ/Hli1neUp
         iGJG4mYeF7p34fajAdZFCRGbH8+lluXRJ6hs8Na+ZKox9CXUs1jO6Xjbo4yz6WKr9/X7
         5cmf1H0q3VD0JYnQoFQm4pj6V4FiqOBZ/At/lJhsRDgjcfNBDc3u5SfcF/gJmzrYZN6i
         jrOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+WdLUP9YIiQ/rXvTg+ZoWYsvSaRCqNtiQA+EPZf1FZQ=;
        b=RlWro1jMpBP8TpLk9pevThWlNcfORPJc64bQWwS7R0X/AaukydnXqMqn6BmO3yFzB/
         0W9KsJwVq5viDRrcHUmg0O7mRQsCRAKZxZb+1slla2TcwcTk0r8brG40ijSNFcWueCa9
         TObUFHJ0UKBuQC38f6x7BvDiMetZdM17q0R4udEYX8D8jo/Wxq2jeXWpQjT0wnMt7M6j
         pvildOqWA5Tup3PyK7brh8ivO687JGaJHWmKTfZPEz1GZum/lfoSs4KKQTXYSir4Xpr8
         iq6q6D+S4p702z789RMqlhjgsg8Si231ygZgSRSka+/mTvLuIICK7TEMGGSANRdFVGXg
         xBeA==
X-Gm-Message-State: APjAAAXn3nMkR3U7M6qX7u9U/Cq8CIQ772C9ip5ewTV5xDeG2Ihc3kvm
        GdVpu1ezvzvapwghr4i/Z50=
X-Google-Smtp-Source: APXvYqxNreX8i25XTpg02t0zET2lO137sCXu2aFwFmWccNMiubaD83MS8afPModJrl99/+zfv0/xDA==
X-Received: by 2002:a62:29c3:: with SMTP id p186mr8966597pfp.237.1559699036919;
        Tue, 04 Jun 2019 18:43:56 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i5sm13371058pfk.49.2019.06.04.18.43.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 18:43:56 -0700 (PDT)
Date:   Wed, 5 Jun 2019 09:43:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>, astrachan@google.com,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        mateusz.bajorski@nokia.com, dsa@cumulusnetworks.com,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
Message-ID: <20190605014344.GY18865@dhcp-12-139.nay.redhat.com>
References: <20190507091118.24324-1-liuhangbin@gmail.com>
 <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David Ahern,

On Fri, May 31, 2019 at 06:43:42PM -0700, Maciej Żenczykowski wrote:
> FYI, this userspace visible change in behaviour breaks Android.
> 
> We rely on being able to add a rule and either have a dup be created
> (in which case we'll remove it later) or have it fail with EEXIST (in
> which case we won't remove it later).
> 
> Returning 0 makes atomically changing a rule difficult.
> 
> Please revert.

What do you think? Should I rever this commit?

Although I'm still not clear what's the difference between

a) adding a dup rule and remove it later
and
b) return 0 directly if the rule exactally the same.

Thanks
Hangbin

> 
> On Wed, May 8, 2019 at 9:39 AM David Miller <davem@davemloft.net> wrote:
> >
> > From: Hangbin Liu <liuhangbin@gmail.com>
> > Date: Tue,  7 May 2019 17:11:18 +0800
> >
> > > With commit 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to
> > > fib_nl_newrule") we now able to check if a rule already exists. But this
> > > only works with iproute2. For other tools like libnl, NetworkManager,
> > > it still could add duplicate rules with only NLM_F_CREATE flag, like
> > >
> > > [localhost ~ ]# ip rule
> > > 0:      from all lookup local
> > > 32766:  from all lookup main
> > > 32767:  from all lookup default
> > > 100000: from 192.168.7.5 lookup 5
> > > 100000: from 192.168.7.5 lookup 5
> > >
> > > As it doesn't make sense to create two duplicate rules, let's just return
> > > 0 if the rule exists.
> > >
> > > Fixes: 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to fib_nl_newrule")
> > > Reported-by: Thomas Haller <thaller@redhat.com>
> > > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> >
> > Applied and queued up for -stable, thanks.
