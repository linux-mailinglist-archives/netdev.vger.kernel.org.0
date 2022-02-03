Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04E14A88B5
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352282AbiBCQkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238360AbiBCQkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:40:11 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659C5C061714;
        Thu,  3 Feb 2022 08:40:11 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id jx6so10742965ejb.0;
        Thu, 03 Feb 2022 08:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=P+k76d9mntDtvQ5ykXCopjCMascZgXwQkHaeBDTB718=;
        b=IaYmrqUyvOkYDcKoPaS1ykOstS1qbI7zl14cC0zM1ZIHK23VrsWuwph6TEGSDpDkJ/
         fThTdncde8bFWYMVXE6Ih5Wqk01/1mB5cQfsP2kN8m60HDVBYgo2rHixof1Oy/1EeNxc
         N173yUdGAlkqGpzwbmXpRkm/QCfh5p6QccSxNUUrLd9ziUeJ4a6Oi+pj673ZxDcIWs9K
         vIc19VKoZwOOb4px7X7P2bonUnbPzt0FVSAlFEWjfXrTGN9CClmycYZ9HlTK8Kv5Hb+e
         /2l0f7DMSBXe6LbFSXXEYTOnAXumHXFzylvac0ZVfvaf2soN90O5OhVh//JaKmYU9ooB
         TcVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=P+k76d9mntDtvQ5ykXCopjCMascZgXwQkHaeBDTB718=;
        b=yCHoLYtVA5sd4mhZnfkf85ugCMvGqTZR/NtXMqwhLUvGBWHqIZwyPMCxdkpCyrOksJ
         uMnC9oe+0me4MBGP7j43eXZ2dqMhgDUeHYjq5o8O5wxN1qXzyz6g9yd04nGoH/rtKcI1
         1JHHk5JAA22b/T82DcdQJsBwwOo/1tUvqjY03XfmFvsFxSvoWGfWekHJx/V7mtjoacOD
         SIXsmwJQfXG4BlhkrOd7Ibvs9NozlY5Gvq5N0/D7evT76NTvmncLngdnmp6N7et/Vj2w
         vwMBMP6WFOZB8jFm77HTSHXIxdVoOtzgqRBRD9txadRhAnZO+vLB/ngcDmAHVBK4VCqe
         KR+A==
X-Gm-Message-State: AOAM531tDc2ZREkY3wpY9uSapVZzAuzM6NI4jHkbKaDJfuxW65RwdF0z
        O8xgkjFFx4xJd/sqXZ3X+/c=
X-Google-Smtp-Source: ABdhPJyHG8ZPumAxoJ6CThiSAo1Dkxrv/gxaWt3f/7CwA+j8WMPyQl67AgjPh4M5TyJa/seqLVQ/Wg==
X-Received: by 2002:a17:906:3d72:: with SMTP id r18mr29952408ejf.111.1643906409762;
        Thu, 03 Feb 2022 08:40:09 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id rv9sm16734935ejb.216.2022.02.03.08.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 08:40:08 -0800 (PST)
Date:   Thu, 3 Feb 2022 18:40:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Improve isolation of
 standalone ports
Message-ID: <20220203164007.ynzmkchlrlw3yrii@skbuf>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
 <20220131154655.1614770-2-tobias@waldekranz.com>
 <20220201170634.wnxy3s7f6jnmt737@skbuf>
 <87a6fabbtb.fsf@waldekranz.com>
 <20220201201141.u3qhhq75bo3xmpiq@skbuf>
 <8735l2b7ui.fsf@waldekranz.com>
 <20220203135606.z37vulus7rjimx5y@skbuf>
 <20220203170104.1cca571d@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220203170104.1cca571d@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 05:01:04PM +0100, Marek Behún wrote:
> On Thu, 3 Feb 2022 15:56:06 +0200
> Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > On Tue, Feb 01, 2022 at 10:22:13PM +0100, Tobias Waldekranz wrote:
> > > No worries. I have recently started using get_maintainers.pl to auto
> > > generate the recipient list, with the result that the cover is only sent
> > > to the list. Ideally I would like send-email to use the union of all
> > > recipients for the cover letter, but I haven't figured that one out yet.  
> > 
> > Maybe auto-generating isn't the best solution? Wait until you need to
> > post a link to https://patchwork.kernel.org/project/netdevbpf/, and
> > get_maintainers.pl will draw in all the BPF maintainers for you...
> > The union appears when you run get_maintainer.pl on multiple patch
> > files. I typically run get_maintainer.pl on *.patch, and adjust the
> > git-send-email list from there.
> > 
> > > I actually gave up on getting my mailinglists from my email provider,
> > > now I just download it directly from lore. I hacked together a script
> > > that will scrape a public-inbox repo and convert it to a Maildir:
> > > 
> > > https://github.com/wkz/notmuch-lore
> > > 
> > > As you can tell from the name, it is tailored for plugging into notmuch,
> > > but the guts are pretty generic.  
> > 
> > Thanks, I set that up, it's syncing right now, I'm also going to compare
> > the size of the git tree vs the maildir I currently have.
> 
> Hi Vladimir, please let me know the results.
> Marek

Sure, it's still syncing, at 19GB currently. Please remind me next week
if I forget to check on it.
