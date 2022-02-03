Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940834A8594
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350808AbiBCN4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiBCN4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 08:56:10 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B02C061714;
        Thu,  3 Feb 2022 05:56:10 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id h7so9176996ejf.1;
        Thu, 03 Feb 2022 05:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s+N0cchWNDKHWOg0SvQ0GRlgi8ukyL5VHO/Wt96Fcbw=;
        b=ctWN5TdDLzuhnLizq+Ehvu4Nv9cwG2GzBTcbxtqeifXJi1Mpj3hq8ZgNIVkP6VoCaH
         FjhpU2EcAw0jlc5vSkdocFwsi4UQF/2964Yh834AkEaTBuOmzfk2ECznjNIGYSkAHiay
         Hqyqbw1sZXNThFWwPOM5XEh9LDmNinVJlJuUwYskOmEc3+qz85Yhp65JKcABjv4kZH9v
         im+58kAhKuIbI8os8+kqlUBLkLfBmNpKtjRJ+HzKhJBITkiaX7Wf8mpCsjD/m3r1hcyy
         n2LiFB988su1fcTSc99UMsk4cz2Lng3v68oV/wFW2KQ5oD0n2+UyZQAoKzclyc0whDRJ
         5Rjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s+N0cchWNDKHWOg0SvQ0GRlgi8ukyL5VHO/Wt96Fcbw=;
        b=R9RWuQ9aHLoqr0mRzfKxfRvZr4YrfaEiOb2PXkjro7WQhD931ilZp1dXAgYsCvVmBb
         8z4DWewYK18fDsXLLk+Rvnygr8F9+3ChraLs4E9wfbl2V0LJh9sq6O7YqM+iAdGJg3ax
         3NYLf9PMUgoYZJdsN41FSLaV3YBov6OG6sJqZ86Y4jjBN04c+/6CSPHUlXgx1sLFziuS
         +EmsoubPQNQoXvbW2rYX8jMsAzym/367UYxXFhYYarDwwWfGKfqmfPvnV27/6A2aJBNf
         5E6leW+OdBe3CqN9mJfhQBMGJzEdKFDcgVK5VnULrpRLyggCF4RE2V7pyDnu4CFfQ9Tu
         gbzg==
X-Gm-Message-State: AOAM531ozxwo3gvp1zInCeZeQ6X6fHUINAD4T8CZSccLLpbBfCdW1FXR
        8awKDU5dDN0K4lXdzTBW6fI=
X-Google-Smtp-Source: ABdhPJxp5S39GhjqcRplc42VQVlMi0FnpJ7CXoJQpHf5QDprdPYA1PNVrBOHycDgjKvkMCo4q01wyQ==
X-Received: by 2002:a17:907:1c97:: with SMTP id nb23mr29632884ejc.92.1643896568614;
        Thu, 03 Feb 2022 05:56:08 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id fn3sm16725339ejc.47.2022.02.03.05.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 05:56:07 -0800 (PST)
Date:   Thu, 3 Feb 2022 15:56:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Improve isolation of
 standalone ports
Message-ID: <20220203135606.z37vulus7rjimx5y@skbuf>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
 <20220131154655.1614770-2-tobias@waldekranz.com>
 <20220201170634.wnxy3s7f6jnmt737@skbuf>
 <87a6fabbtb.fsf@waldekranz.com>
 <20220201201141.u3qhhq75bo3xmpiq@skbuf>
 <8735l2b7ui.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735l2b7ui.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 10:22:13PM +0100, Tobias Waldekranz wrote:
> No worries. I have recently started using get_maintainers.pl to auto
> generate the recipient list, with the result that the cover is only sent
> to the list. Ideally I would like send-email to use the union of all
> recipients for the cover letter, but I haven't figured that one out yet.

Maybe auto-generating isn't the best solution? Wait until you need to
post a link to https://patchwork.kernel.org/project/netdevbpf/, and
get_maintainers.pl will draw in all the BPF maintainers for you...
The union appears when you run get_maintainer.pl on multiple patch
files. I typically run get_maintainer.pl on *.patch, and adjust the
git-send-email list from there.

> I actually gave up on getting my mailinglists from my email provider,
> now I just download it directly from lore. I hacked together a script
> that will scrape a public-inbox repo and convert it to a Maildir:
> 
> https://github.com/wkz/notmuch-lore
> 
> As you can tell from the name, it is tailored for plugging into notmuch,
> but the guts are pretty generic.

Thanks, I set that up, it's syncing right now, I'm also going to compare
the size of the git tree vs the maildir I currently have.
