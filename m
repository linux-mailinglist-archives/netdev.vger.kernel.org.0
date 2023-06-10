Return-Path: <netdev+bounces-9786-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0B5872A961
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 08:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7F18281AB2
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 06:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ECA56FC8;
	Sat, 10 Jun 2023 06:29:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFAC1FCA
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 06:29:01 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A036E3AB4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 23:28:58 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f732d37d7cso24611865e9.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 23:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686378537; x=1688970537;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z4tPBmLxbgqH6kRcASvaW6A5pQpwvBDn158bXOcNA0I=;
        b=Q5RmxHP+gg7pbWn2D5hFQpNyX1ss8jh5NWLurox0v9DwuuvNtEyIxtMmRGVEr7Njkl
         9hW5tnfCN6Y/18k6joqKEnxVFwme3Ea2LxQDzHcZK6NtLA+wP/OmRwrKGKVbdDmO8J8d
         R7PVSHSi2is1kO1xdBWiwE5dXJKklEkVlINx3ggJFv0SUPXmst5Yv754kn8wvcgusJ6O
         yVFszCwQElFtZDbYAAuZm20VOfM5TY+3Aujel7lxlb8+MCz1S7FQ75MhhRbCSweKCO/P
         0lzLfufRLBKRYJNat4l3CswqSTYyk+GB+zowgyznz5PZEVMtqkvkYNW7Mnrja5WcSz4s
         OQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686378537; x=1688970537;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4tPBmLxbgqH6kRcASvaW6A5pQpwvBDn158bXOcNA0I=;
        b=VHbIEMI9zabJARLEKeRiF48DWhYn4F1owBFCHyVbwgInSDQToOzarzOnb2Mh3iBIej
         dDwhuDVfcZ5woNpFhVxhCxm+LGsd7h2JDfiv80BQFw/TuCCR4b+Hr0CyM/8mAtlVEvDc
         ebQghcYdq3GAtmiyKYn7jARN/M0gwr/WR2mX0V7J5y86o6lwxtp7tUZoDpYG8ibgRqNb
         PWja6f+P+k6cpmvQUiUQb4rKhUiPY36r6deWEt03pq9tE8lXD1Q0qtwXp2dKACapX+z8
         SB8X52K1opJgjwKB3bpDZqpjiYIPz2PzPimQIHM+RK21CdDwqpNcvhGWzg9/A8QYZrJD
         M5Qg==
X-Gm-Message-State: AC+VfDy9U90ND3akA6456XK8twwxSCdjLPz/ZZdMrYK1uT42g6QMwzPd
	vbTfoHX1c/NipxNe3aO5p6RwqQ==
X-Google-Smtp-Source: ACHHUZ6+ar2K/agrBFiY981/9KcoVl6RN5cGk1+iH+PBYjdvQfrQis9Y2cHw+dGdMD1EZ+1x+h4jZw==
X-Received: by 2002:a05:600c:3793:b0:3f6:683:627d with SMTP id o19-20020a05600c379300b003f60683627dmr2773647wmr.18.1686378537038;
        Fri, 09 Jun 2023 23:28:57 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l8-20020a1c7908000000b003f7f4dc6d14sm4635503wme.14.2023.06.09.23.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 23:28:55 -0700 (PDT)
Date: Sat, 10 Jun 2023 09:28:51 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2 net] sctp: fix an error code in sctp_sf_eat_auth()
Message-ID: <a4eebbcc-a4a5-42f3-8db9-5d604ced6201@kadam.mountain>
References: <4629fee1-4c9f-4930-a210-beb7921fa5b3@moroto.mountain>
 <bfb9c077-b9a6-47f4-8cd8-a7a86b056a21@moroto.mountain>
 <CADvbK_f25PEaR1bSuyqeGQsoOp0v1Psaeu2zPhfEi8Zcu-J5Tw@mail.gmail.com>
 <7899ff13-ab06-4970-a306-85b218486571@kadam.mountain>
 <CADvbK_e2JwH3OqFSu89EvrtGbBbuCvD-C=Db_sExjvD1EcVLrw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADvbK_e2JwH3OqFSu89EvrtGbBbuCvD-C=Db_sExjvD1EcVLrw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 07:04:17PM -0400, Xin Long wrote:
> On Fri, Jun 9, 2023 at 12:41 PM Dan Carpenter <dan.carpenter@linaro.org> wrote:
> >
> > On Fri, Jun 09, 2023 at 11:13:03AM -0400, Xin Long wrote:
> > It is a bug, sure.  And after my patch is applied it will still trigger
> > a stack trace.  But we should only call the actual BUG() function
> > in order to prevent filesystem corruption or a privilege escalation or
> > something along those lines.
> Hi, Dan,
> 
> Sorry, I'm not sure about this.
> 
> Look at the places where it's using  BUG(), it's not exactly the case, like
> in ping_err() or ping_common_sendmsg(), BUG() are used more for
> unexpected cases, which don't cause any filesystem corruption or a
> privilege escalation.
> 
> You may also check more others under net/*.
> 

Linus has been very clear that the BUG() in ping_err() is wrong and
should be removed.  But to me if you're very very sure a BUG() can't be
triggered that's more like a style or philosophy debate than a real life
issue.

https://lore.kernel.org/all/CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com/

When you look at ping_err() then it's like.  Ugh...  If we leave off the
else statement then GCC and other static checkers will complain that the
variables are uninitialized.  It we add a return then it communicates to
the reader that this path is possible.  But the BUG() silences the
static checker warning and communicates that the path is impossible.

A different solution might be to do a WARN(); followed by a return.  Or
unreachable();.  But the last time I proposed using unreachable() for
annotating impossible paths it lead to link errors and I haven't had
time to investigate.  Another idea is that we could create a WARN() that
included an unreachable() annotation.

	} else {
		IMPOSSIBLE("An impossible thing has occured");
	}

As a static analysis developer, I have made Smatch ignore WARN()
information because warnings happen regularly and the information they
provide is not useful.  Smatch does consider unreachable() annotations
as accurate.

Anyway, in this patch the situation is completely different.  Returning
wrong error codes is a very common bug.  It's already happened once and
it will likely happen again.

My main worry with this patch is that the networking maintainers will
say, "Thanks, but please delete all the calls to BUG() in this function".
I just selected this one because it was particularly bad and it needs to
be handled a bit specially.  Deleting all the other calls to BUG() isn't
something that I want to take on.

regards,
dan carpenter


