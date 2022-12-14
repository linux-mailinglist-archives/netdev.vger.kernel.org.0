Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7652764D25D
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 23:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLNW1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 17:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLNW1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 17:27:37 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC86B1C
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 14:27:36 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d3so4882555plr.10
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 14:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4BQ/4GwqEZBGEGhHLETHkifTrLwEd8I7WctgoLQrTrE=;
        b=DW0wrc68N4WRqYiv8+/xvkIpVfMOLDc2jGmFVacD/Z6JatkTxxjSfgt11C+kpkkjKT
         vgkcE0B+v1oPqQyfwtQufwATyFmmIkLiIHnyzY610HefXRTSDbzSA6nFwJNHL4a+wbc7
         Ellj8MuHZenzQ8kx+t8D8vszOaLf0KugikTTK6DG2ehT7OBe11F1u65TndDfZ0XS21cB
         rP4nN4JPZ2hbX+b3Ml7ByBmCBfFPR1czrvKJqgl8lm/Ofx3HUmGovyaeb8ADhO3sbjLY
         rs5przvjp6uX1J/IaEcLQgz/u/wI08a9EDmGHc1bIxN+fK00w5tdPZSi0Me7O1UaC9GX
         6Ttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4BQ/4GwqEZBGEGhHLETHkifTrLwEd8I7WctgoLQrTrE=;
        b=0+NMaf42KOQ9sYkiX9JnjWeHzDQ6OBayr0d1UYCD5knYQ+4RJDc4yKFeHVI8ee7XC6
         AiQqd3MkTQ1gMrLFb8NbgIy7oo8rX2Xcv4QSQ5WzlD6WurldjHZJCavUgbk6H/ZFtTSQ
         Ytl6Syc9Oetutqe6SNugTWiIcXdavIXhBu06Xlo6qQtUnPhDJZFa6V3vIKvr3zlRR/Yw
         YgK6FRYTyrUOFDdg5lkc65gh7CJ6s2Ttj0+ndjB1L6M8tZsmg1DXRO7z/CbZj6hQSW9b
         oBUmbr7b3MXthpNJNiWTwtw39tw3ngJxbEIV7bktWaD5Z/hWUQ6rSQXD+SRppPwGQ0es
         Btaw==
X-Gm-Message-State: AFqh2kpRQkQkLeNnXwyGD2DpWpfVc9D9yXQqe63/8yeXrnZq/TP3bQ30
        D+GFWJowRucDnmc252sUh8/Qos46j+ltQjkx21P7Rx3Mp5s=
X-Google-Smtp-Source: AMrXdXvnBiyXMriWsUpe1twqErg3YOmyJOXLCzSU0HUJz1WAvoh3M5cNonJtkNu2CE5KM1XXVs1ICsMcTiaev8aI7Yk=
X-Received: by 2002:a17:90b:2288:b0:219:c8d5:27d7 with SMTP id
 kx8-20020a17090b228800b00219c8d527d7mr496483pjb.141.1671056855730; Wed, 14
 Dec 2022 14:27:35 -0800 (PST)
MIME-Version: 1.0
References: <20221214092008.47330-1-kuniyu@amazon.com> <83daafadbf10945692689aa9431e42c8e790d3b7.camel@gmail.com>
 <20221214130131.17555240@kernel.org>
In-Reply-To: <20221214130131.17555240@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 14 Dec 2022 14:27:23 -0800
Message-ID: <CAKgT0UcDsUOD_rhg9tzWVJkiL+ihwcuvZQ-_6ovRcwT79j6NKw@mail.gmail.com>
Subject: Re: [PATCH v1 net] af_unix: Add error handling in af_unix_init().
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller <davem@davemloft.net>, Eric Dumazet
        <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Denis V. Lunev
        <den@openvz.org>, Kuniyuki Iwashima <kuni1840@gmail.com>," 
        <netdev@vger.kernel.org>
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

On Wed, Dec 14, 2022 at 1:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 14 Dec 2022 11:18:05 -0800 Alexander H Duyck wrote:
> > So the "Fixes" tags for this are no good. The 2nd one is from the start
> > of using git for the kernel. As such I am suspecting that this isn't
> > fixing a patch that introduced an issue.
>
> We ask people to add the "start of history" tag when the issue goes all
> the way back.

The point I was getting at is that this issue doesn't really go all
the way back. Essentially sock_register could only fail if you were
registering a proto over 32 or one that was already registered. So
with 2.6.12-rc2 we should never see a failure without modifications to
the kernel as we only register PF_UNIX once and the other functions at
that time were void. This makes all the fixes tags suspect since the
patch doesn't resolve any issue with that code.

More likely candidates would have been:
Fixes: 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
Fixes: 097e66c57845 ("[NET]: Make AF_UNIX per network namespace safe [v2]")

> > Since it doesn't really seem like this is fixing an issue other than
> > adding some additional exception handling. I would suggest getting rid
> > of the "Fixes" tags and just submitting this for net-next once the
> > window opens.
> >
> > The code itself looks fine, but I don't think it is really fixing much
> > either.
>
> We don't do gradation of fixes in netdev, if a function can fail not
> handling the exception is a bug. I'm not saying that you're wrong
> calling this out as highly theoretical, all I'm saying is that I for
> one do not have the mental stamina to try to establish and use more
> complex heuristics. We haven't had material reasons to introduce any.

My concern was that this is more of a refactor/cleanup posing as a
fix. I know I have been guilty of that once or twice myself trying to
squeeze a patch in during the merge window.
