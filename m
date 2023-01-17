Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A08866DB15
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 11:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbjAQKas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 05:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbjAQKaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 05:30:19 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E308527984
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:29:35 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id qx13so15882621ejb.13
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4NC8zXGldvbdIh6PmZrhEYMwCpXo8NhAXbSwvOHtY4Y=;
        b=LU8rZjD9DXlMI6jJL398Ejc1d9zO/9TMm5dWNyxu5+RzzsR+9w6j5+RluLkjzon3sM
         nHcP0mwOSgwy83PKie2a7amIJn7BrHBrgXVK/CliDwsibCpVwMySt6UUozoeCsqOL5Cf
         bj3EQjJX0IGgwoBg2HnfZlxpYiUpnXONdM8JjBLfD0PUEywX422q/20WkutMcKR2ooQq
         q/Na0AzekBTvUj/BagfOQdQnn0fbprlbV8hgwkHJeYt66soDfBQs1UeGpKQycVs87YW+
         1GA8EfNR3TWqgsJTFAzAAuDtzI26gCQQXpLkGe6lLW5Jont3T0SM2X2oppOnff15xFQS
         6QSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4NC8zXGldvbdIh6PmZrhEYMwCpXo8NhAXbSwvOHtY4Y=;
        b=pAwoXOzwv7zMbQ1FG2zXo4yPC4rgGu4r8mKFL4LXEvnwro9Md7qw8dpHYZe1SiZMjI
         tmgZxYuhMzyXrASZQEecQfjl07NgcryQjxVsTMqs0EhZ/Mi9zdCY0Qj2y9lwL8cTFWVa
         1/kg2jFm+hy0zSsc2xxzCcqZXJKu9OVNBNs68DYGcWAc8FBgZS7w68FfFv6f+K3PNiBU
         lLNMApb02fy64detubVFpQprVc/8I3qi1IJDm1uXkNsGxoX9SMwh/nas41VEKxM3IOld
         DoZfWQ6GZFW8VRT1g9zd7uFc45DKrJiK34BPnQGkq8Lg1YLoiU1smAxpK0pwhYXne9QE
         NjZQ==
X-Gm-Message-State: AFqh2kpucZg/Gckwr2uA35QL2uKcCHpbZbAEAz0eWN63kX7ZEnwf5wOw
        dsqUZhL2u/5sqJ/IHvHTxZkVUf9JCLxar1bRuawHWNjOHbU=
X-Google-Smtp-Source: AMrXdXusKNuuuvsxcKK8Rr7LgdwQUUs+rwD4RSySHNsGfaUkucSBhRBo9s0N9r7/EXd9SBRwCNmViWytq4VxazaQEw8=
X-Received: by 2002:a17:907:80cc:b0:86f:8937:d92f with SMTP id
 io12-20020a17090780cc00b0086f8937d92fmr182479ejc.736.1673951374524; Tue, 17
 Jan 2023 02:29:34 -0800 (PST)
MIME-Version: 1.0
References: <20230114185243.3265491-1-gergely.risko@gmail.com> <20230116205320.155f58be@kernel.org>
In-Reply-To: <20230116205320.155f58be@kernel.org>
From:   =?UTF-8?Q?Gergely_Risk=C3=B3?= <gergely.risko@gmail.com>
Date:   Tue, 17 Jan 2023 11:29:23 +0100
Message-ID: <CAMhZOOx3fnS6VtU5iKcyN7jAULG5ghRmTJYu8FaOYfkjpo2-XQ@mail.gmail.com>
Subject: Re: [PATCH net-next] ipv6: fix reachability confirmation with proxy_ndp
To:     netdev@vger.kernel.org
Cc:     yoshfuji@linux-ipv6.org, edumazet@google.com, davem@davemloft.net,
        dsahern@kernel.org, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(resent to the mailing list too without stupid default Gmail HTML, sorry)

On Tue, Jan 17, 2023 at 5:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
> Is this a regression? Did it use to work at any point in time?

Yes, this is a regression.

Here is the proof from 2020: https://github.com/lxc/lxd/issues/6668

Here people discuss that the multicast part works after setting
/proc/sys/net/ipv6/conf/eth0/proxy_ndp, but the unicast part only
works if they set conf/all/proxy_ndp.

So there was a point in time when the unicast worked. :)

The inconsistency regarding all/eth0 with multicast/unicast, I plan to
address in a separate patch, but I still need to do my homework
regarding that (more code reading), to make sure that I'm
understanding the context and the original intention enough.

The regression was introduced by Kangmin Park, as kindly pointed out
by David Ahern.  In my opinion they ran into this regression, because
they were just looking for places, where finalization statements were
not properly replicated in front of return statements.  At least there
is no proper explanation in the regression introducing code.

That's why this time I added a big comment in the hopes of protecting
ourselves in the future.

> We need to decide whether it needs to be sent for 6.1 and stable.
> If not we should soften the language (specifically remove the "fix"
> from the subject) otherwise the always-eager stable team will pull
> it into stable anyway :|

I tried to read up on all the requirements as much as possible, but
yes, I'm a first time committer, and it shows :(

I was thinking that this is non-urgent, as it's been like this since
2021, and people although complain on the internet, but not enough to
actually do something about it, and it looked like that the logic is
"next is free", "6.1 needs to have reasons", so I decided to chicken
out and go for next.  If in the current form the patch can be sent for
6.1 and stable, I would prefer that, as I currently have to compile my
own kernel with this patch in my production system and it is a
regression after all... :)

> Also - you haven't CCed the mailing list, you need to do so for
> the patch to be applied.

Yes, another noob mistake, the first point where as a new person I
found out about this, is when I sent to the mailing list ONLY, and in
the CI/CD I got the error message that I should CC the maintainers.
The proper list of email addresses to copy-paste to the git send-email
command is not published before you make a mistake.  At that point if
I send the mailing list again, then the patch duplicates in patchwork,
so I decided to just mail the maintainers separately, probably I
should have came up with a better way...

My next patch will be all better.  Do you prefer to reject this and
then I can resend the whole thing the proper way (fixing typos/grammar
too in the comments and commit message)?

Cheers,
Gergely
