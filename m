Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F90E355B1
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 06:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfFEEGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 00:06:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41916 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfFEEGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 00:06:01 -0400
Received: by mail-pg1-f195.google.com with SMTP id 83so4810500pgg.8
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 21:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vuklotqtTREnfLjgNk5K4hr4m38iubbX9+8kgegN2Ec=;
        b=a6bq5TCWT2qeORsD0MDBlubcheEKvVLaOLfNtsvdkhxaiMA+PaHcz/QVcFKAaLTr3w
         53U+ndirbvvZBVKj+RP6lai42Q4xt0Mu2O6o/ck2i4KKZUGtOfDPuKJqTVKcuioA3vlC
         X7O7WdXCHCyeF6T55E+eaF1qKISSKjznjGcXDP5ZMhFtXuikcVyTSOqlgu4EkQ3Z5Yor
         BPOl7gxtFLuOy+rw1GtZgqbg5Oz09J7tCJ9TYaA3kF0xm5/pePJ9GSHIe3nUkpzFvWr1
         HEyay7Ti5sA6rIR4ZLaYVNnPHZybQqC221kdFz6+FfI7g6K4VrQ55X/t7dJU/nLmJzWM
         Jtsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vuklotqtTREnfLjgNk5K4hr4m38iubbX9+8kgegN2Ec=;
        b=enAvrkdanbfvjCglNGwfI5Vx1g4srFL4bED6mdUuHubFHSAb0qD7sA1amiKRtUCEz6
         7++8EN/SJEctkla9McW74atJXoepqm+Cqn763AX1eDBpITrBKTXE/LggVZF53FhhOLMr
         C7rHsVT89/Cpvi51T+IT9GUH9LxJON3dUVgOGczJApykwLGhBVDdw6pn9XnN9DnDohZs
         UqW4eE5pA7xZko0fa5mhcM7GhPeNccFbqp4juI8rajjMpAaTotAiUu9iLghpze0a4eCZ
         gCAKaejm+FhSKLrT5PSMvokvgOjozt/hkK9uMnXmQCo2JGtdd+WXQOpO71/Qe1tSkaET
         Au/A==
X-Gm-Message-State: APjAAAVCvI06lZuM4VWQBxxhtloi/lcPodrCNRtQYFLcS2mJKNfgPvUz
        PzIxjVqA7cxoqMhlz/ATSS8=
X-Google-Smtp-Source: APXvYqxIGTQppFW4OYC+YX3LMuS+sZwK/2TDbJFd5YYDG/Osr37QC++hQkpCP2RvDXlvat2Q4O7qsQ==
X-Received: by 2002:a62:68c4:: with SMTP id d187mr43741869pfc.245.1559707560881;
        Tue, 04 Jun 2019 21:06:00 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g18sm8515200pfo.136.2019.06.04.21.05.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 21:06:00 -0700 (PDT)
Date:   Wed, 5 Jun 2019 12:05:49 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Alistair Strachan <astrachan@google.com>,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
Message-ID: <20190605040549.GB18865@dhcp-12-139.nay.redhat.com>
References: <20190507091118.24324-1-liuhangbin@gmail.com>
 <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
 <20190605014344.GY18865@dhcp-12-139.nay.redhat.com>
 <CAKD1Yr3px5vCAmmW7vgh4v6AX_gSRiGFcS0m+iKW9YEYZ2wG8w@mail.gmail.com>
 <20190605021533.GZ18865@dhcp-12-139.nay.redhat.com>
 <CAKD1Yr1UNV-rzM3tPgcsmTRok7fSb43cmb4bGktxNsU0Bx3Hzw@mail.gmail.com>
 <20190605032926.GA18865@dhcp-12-139.nay.redhat.com>
 <CAKD1Yr2a_GfRYyrotzb2j-hLdWjzDEU3fbwtTrLiU090R55h-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKD1Yr2a_GfRYyrotzb2j-hLdWjzDEU3fbwtTrLiU090R55h-g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 12:43:44PM +0900, Lorenzo Colitti wrote:
> On Wed, Jun 5, 2019 at 12:29 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > > We rely on being able to add a rule and either have a dup be created
> > > (in which case we'll remove it later) or have it fail with EEXIST (in
> > > which case we won't remove it later).
> >
> > With Maciej said, how about add NLM_F_EXCL flag when you add a new rule.
> > If it returned EEXIST, which means there is an dup rule, you just do not
> > remove it later.
> >
> > Would that fix your issue?
> 
> We can't do that without rewriting our code and making it more
> complex. The way the code is structured is that an update is "add all
> new rules; delete all old rules". To do what you suggest we would need
> to either change that to "for rule in rules; add newrule; delete
> oldrule" or we'd need to keep state on which rules already existed.

Hmm...Generally speaking we need to check the cmd's return value, or why it
exists.

> 
> The previous behaviour provided semantics that are useful to
> userspace, and this commit broke those semantics. Please revert.

Keep two exactally same rules in kernel looks strange and doesn't make
sense to me. But let's see what does David Ahern think, he is more
experienced in this part :)

Thanks
Hangbin
