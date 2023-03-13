Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57016B7B64
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCMPCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjCMPCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:02:05 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0BE5982F;
        Mon, 13 Mar 2023 08:01:39 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id cy23so49816093edb.12;
        Mon, 13 Mar 2023 08:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678719698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=opk2j4mTiChxadvVvJSsh0ztBAk6zLEmYsL/2LoqTrE=;
        b=LQ/3bfI5AFdhqbQE8Ce851NO9smEguJCxeK+QenfI/YTuanFD+0Uq1WT1xRobEqfPO
         RlSIo0m2kGsIBwzqK/7CZQte0Ez2CEwSmyj6PYhhGtqUVvcdCGIQ6s5KAdXP/a1rKPlW
         f4HB3sZBPwJihtgwLTbrNGnX5b2bOw67cDED4FF3ZZ+N54lN7lA528kvdBZ6fVuo7c2D
         ktbBFHytmeu02Z4zEgy5YA4RDu5dhQZB9ZnAeazQhS95a7tWH7/k3LMcZAsQq7n7zzAp
         miQnf7FOgYc0PspQiiB0d5AkDxqVj65c1TNOSOrojAZ8sLD3TZfI+NrE+wjKWMQvrKVS
         cJVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678719698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opk2j4mTiChxadvVvJSsh0ztBAk6zLEmYsL/2LoqTrE=;
        b=7V1pfd9sMRr+S2tfwq4UUJK/G3arVbzVnnA+qkhdIdOX8FeXcTaoI1PL6fx0yzOdKG
         nxl4UfTVctknkVJdIRNNiyeWwT/EA7zvU8bu+JhKieVVarHvSUt0XvnqKBYQ0upEksOy
         lF+/6MzkrvhKtWNzj4MNvnvxsimemSJAlOOjAZrLXjyQ8j/+pAO7bNquf6hNnjacL8X3
         S7FgWFpUramZjnhUiCxhM1KXZ3A6owEKzgYmVpRg3S120uV+yq38MqGIlAtEFhdySKnc
         74lPOXQmMBfAt4LhRyWFmkOj3v8XIHlsSSbi+b7umbJ+TJeJ3ChqRCJvKD+Y0/WiPrAz
         XHYg==
X-Gm-Message-State: AO0yUKV4ozawEEohRHPslrdCWrpgT8CxuQipJzIi5xgKQeEtaETI5ses
        6U3b76VqpdkGh/r03Z29b8U=
X-Google-Smtp-Source: AK7set/o+ql8sCTwAkdpoUmDp4HM6QSBxKAM4wbd/fHpxjLYvrbnMwhfWHUMAHzJc5G97sFqGdGNYw==
X-Received: by 2002:a17:906:c9c2:b0:8a0:7158:15dc with SMTP id hk2-20020a170906c9c200b008a0715815dcmr32058065ejb.74.1678719697636;
        Mon, 13 Mar 2023 08:01:37 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id q21-20020a170906389500b008b907006d5dsm3557136ejd.173.2023.03.13.08.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 08:01:37 -0700 (PDT)
Date:   Mon, 13 Mar 2023 17:01:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <20230313150135.not6e3x2j4624tpg@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-2-lukma@denx.de>
 <20230310120235.2cjxauvqxyei45li@skbuf>
 <20230310141719.7f691b45@wsk>
 <20230310154511.yqf3ykknnwe22b77@skbuf>
 <20230312165550.6349a400@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312165550.6349a400@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 04:55:50PM +0100, Lukasz Majewski wrote:
> > What I was talking about is this:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20230309125421.3900962-2-lukma@denx.de/#25245979
> > and Russell now seems to agree with me that it should be addressed
> > separately,
> 
> Ok.
> 
> > and prior to the extra development work done here.
> 
> Why? Up till mine patch set was introduced the problem was unnoticed.
> Could this be fixed after it is applied?

I have already explained why, here:

| in principle no one has to solve it. It would be good to not move
| around broken code if we know it's broken, is what I'm saying. This is
| because eventually, someone who *is* affected *will* want to fix it, and
| that fix will conflict with the refactoring.

Translated/rephrased.

The 1492 max_mtu issue for MV88E6165, MV88E6191, MV88E6220, MV88E6250
and MV88E6290 was introduced, according to my code analysis, by commit
b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when setting MTU
for DSA and CPU ports").

That patch, having a Fixes: tag of 1baf0fac10fb ("net: dsa: mv88e6xxx:
Use chip-wide max frame size for MTU"), was backported to all stable
kernel trees which included commit 1baf0fac10fb.

Running "git tag --contains 1baf0fac10fb", I see that it was first
included in kernel tag v5.9. I deduce that commit b9c587fed61c ("dsa:
mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU
ports") was also backported to all stable branches more recent than the
v5.9 tag.

Consulting https://www.kernel.org/ and https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/,
I can see that the branches linux-6.2.y, linux-6.1.y, linux-5.15.y and
linux-5.10.y are still maintained by the linux-stable repository, and
contain commit b9c587fed61c (either directly or through backports).

As hinted at by Documentation/process/maintainer-netdev.rst but perhaps
insufficiently clarified, bug fixes to code maintained by netdev go to
the "main" branch of https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git,
a git tree which tracks the main branch of Linus Torvalds (which today
is in the v6.3 release candidates). From there, patches are
automatically backported by the linux-stable maintainers.

The problem with you making changes to code which was pointed out as
incorrect is that these changes will land in net-next.git, in kernel
v6.4 at the earliest.

Assuming somebody else will fix the 1492 MTU issue, there are 2 distinct
moments when that can occur, relative to when the net-next pull request
is sent to Linus Torvalds' main branch:

1. before the net-next pull request. In that case, one of the netdev
   maintainers will have to manually resolve the conflict between one of
   net.git or Linus Torvalds' git tree.

2. after the net-next pull request was accepted. What will happen is
   that net.git will merge with Linus Torvalds' changes, and it will no
   longer contain the same code as on branches 6.2, 6.1, 5.15 and 5.10,
   but rather, the code with your changes. But it is always net.git that
   someone has to develop against when submitting the 1492 MTU change.
   That fix cannot apply any further than the net-next pull request,
   which is the v6.4-rc1 tag at the earliest.

   So, for the bug fix for 1492 MTU to reach the stable branches which
   are still maintained by then, 2 strategies will be taken into
   consideration:

   - the conflicting changes (yours) are also backported along with the
     real bug fix. This is because linux-stable has a preference to not
     diverge from the code in the main branch, and would rather backport
     more than less, to achieve that. But your patch set is quite noisy.
     It touches the entire mv88e6xxx_table[] of switches. It is hard to
     predict how well this chain of dependencies will get backported all
     the way down to linux-5.10.y. If any switch family was added to
     this table since v5.10, then the backporting of your changes would
     also conflict with that addition.

   - if the linux-stable team gives up with the backporting, an email
     will be sent letting the people know, and a manually created series
     of backports can be submitted for direct inclusion into the stable
     trees.

As you can see, the complexity of fixing code in stable that has been
changed in mainline is quite a bit higher than fixing it before changing it.
Also, the result is not as clean, if you add third-party backports into
the equation. For example, someone takes a linux-6.1.y stable kernel
from the future (with the 1492 MTU issue solved) and wants to backport
v6.4 material, which includes your changes. It will conflict, because
there is no linear history. The only way to achieve linear history is to
fix the buggy code before changing it.

To your point that it's not you who chose the 1492 MTU bug but rather
that it chose you, I'm not trying to minimize that, except that I need
to point out that things like this are to be expected when you are
working on a project where you aren't the only contributor.

Since we are already so deep in process-related explanations, I don't
know how aware you are of what fixing the 1492 MTU bug entails.
One would have to prepare a patch that limits the max_mtu to ETH_DATA_LEN
for the switch families where MTU changing is not possible. Once that
gets reviewed and accepted, one would need to wait for no longer than
the next Thursday (when the net.git pull request is sent, and net.git is
merged back into net-next.git, for history linearization), then work on
net-next.git can resume.
