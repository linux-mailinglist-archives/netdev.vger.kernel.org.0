Return-Path: <netdev+bounces-9844-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E19972AE17
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 20:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAF922815D2
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A54200CA;
	Sat, 10 Jun 2023 18:28:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A7B23C5
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 18:28:29 +0000 (UTC)
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FB730CD;
	Sat, 10 Jun 2023 11:28:27 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-bc492cb6475so413325276.2;
        Sat, 10 Jun 2023 11:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686421707; x=1689013707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VHAWJjlyJJkiqxSyII1vi5yzFtPXpOtnMaBNFDEAO5E=;
        b=lWiXt+cY+yfrdznX/8ayKp3jjqLadQcv2DTPp010F067o75MVVU1wpgh0JSfH++ZzP
         n4RiRdmcVtlPEEb/0iOdmpr5zh1kDfedxS1FRlOKJU2IrKgflBHTD1BJ9l4a7OFE+kNp
         UaXR4pgmxBzP7/QFXyXUh+ryIxSFyWcWzLti7zref9AK//zJw++/tFeO8uyXvIF7uesf
         QrEi1qLZ+TrhC+xs0DlWpplF13nX0Nwhmomemp2Vj2jx9yBUxH9E49ye3lr+3zVRVPqV
         U6E6XHKkOyHMppVRsV2vsyyOgBjOeYaq3j4bFQqZAjn6n5SDPZos8qSnPdKatO3dmNcm
         KhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686421707; x=1689013707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHAWJjlyJJkiqxSyII1vi5yzFtPXpOtnMaBNFDEAO5E=;
        b=Jp3q0zBaNypx/iv826tmFam2tBtMKK+PIAs4OmC0t/2xnNrWICazVSkgVAjkr/wAFP
         q0tFFiMss/YYl98okplqd+p14mTBIip08/dCuwZLayintjkWMT90KbJHU7mJ3P2elWlm
         hUHkGsAYCcFzouAoe5XV2+rC5Q7CKBHWe3RxwfrecrW8Y2iQF44vhC35i2W3LfPsyiAk
         1/SxIYQyGdGr/IZl7ixSJb8l34IwkWzZiClkkSbfa5PqqvjCh4JiPQVuhIKYcov2g0Z1
         me903Kdcty5wb60wUeP+OCb1OkSM4lVRBX5+Y2BmwqHutJKJw4K5U/dBM+GvQns3iUgD
         Z4wA==
X-Gm-Message-State: AC+VfDzGwzrUk5zpErwZIHbroLhrX19Uuef4eBHKZFrr9jCalrnh3agL
	kg8Ar3Xl5HpnqlswQHxg91mXYCiD7Xd2GQQ1Z+U=
X-Google-Smtp-Source: ACHHUZ4ycn8+h+Fm0lIiWoMFRAUM2pdP0YO3NBeKs5I5Ea4uWOwGzm7VUEBJ6IG//luRic2L9Movqd0Hv41kyQalR04=
X-Received: by 2002:a0d:dfc3:0:b0:561:8c78:bd14 with SMTP id
 i186-20020a0ddfc3000000b005618c78bd14mr3862807ywe.3.1686421706846; Sat, 10
 Jun 2023 11:28:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4629fee1-4c9f-4930-a210-beb7921fa5b3@moroto.mountain>
 <bfb9c077-b9a6-47f4-8cd8-a7a86b056a21@moroto.mountain> <CADvbK_f25PEaR1bSuyqeGQsoOp0v1Psaeu2zPhfEi8Zcu-J5Tw@mail.gmail.com>
 <7899ff13-ab06-4970-a306-85b218486571@kadam.mountain> <CADvbK_e2JwH3OqFSu89EvrtGbBbuCvD-C=Db_sExjvD1EcVLrw@mail.gmail.com>
 <a4eebbcc-a4a5-42f3-8db9-5d604ced6201@kadam.mountain>
In-Reply-To: <a4eebbcc-a4a5-42f3-8db9-5d604ced6201@kadam.mountain>
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 10 Jun 2023 14:27:39 -0400
Message-ID: <CADvbK_f4=pHJ2pftf2mqXO_-9BaZkBM0wSbqvA0iy93H4YFztg@mail.gmail.com>
Subject: Re: [PATCH 2/2 net] sctp: fix an error code in sctp_sf_eat_auth()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 10, 2023 at 2:28=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> On Fri, Jun 09, 2023 at 07:04:17PM -0400, Xin Long wrote:
> > On Fri, Jun 9, 2023 at 12:41=E2=80=AFPM Dan Carpenter <dan.carpenter@li=
naro.org> wrote:
> > >
> > > On Fri, Jun 09, 2023 at 11:13:03AM -0400, Xin Long wrote:
> > > It is a bug, sure.  And after my patch is applied it will still trigg=
er
> > > a stack trace.  But we should only call the actual BUG() function
> > > in order to prevent filesystem corruption or a privilege escalation o=
r
> > > something along those lines.
> > Hi, Dan,
> >
> > Sorry, I'm not sure about this.
> >
> > Look at the places where it's using  BUG(), it's not exactly the case, =
like
> > in ping_err() or ping_common_sendmsg(), BUG() are used more for
> > unexpected cases, which don't cause any filesystem corruption or a
> > privilege escalation.
> >
> > You may also check more others under net/*.
> >
>
> Linus has been very clear that the BUG() in ping_err() is wrong and
> should be removed.  But to me if you're very very sure a BUG() can't be
> triggered that's more like a style or philosophy debate than a real life
> issue.
>
> https://lore.kernel.org/all/CAHk-=3Dwg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gY=
zspRjYvw@mail.gmail.com/
I see, didn't know that there are so many BUG() uses that are historic
in the kernel, including net/*.

>
> When you look at ping_err() then it's like.  Ugh...  If we leave off the
> else statement then GCC and other static checkers will complain that the
> variables are uninitialized.  It we add a return then it communicates to
> the reader that this path is possible.  But the BUG() silences the
> static checker warning and communicates that the path is impossible.
>
> A different solution might be to do a WARN(); followed by a return.  Or
> unreachable();.  But the last time I proposed using unreachable() for
> annotating impossible paths it lead to link errors and I haven't had
> time to investigate.  Another idea is that we could create a WARN() that
> included an unreachable() annotation.
>
>         } else {
>                 IMPOSSIBLE("An impossible thing has occured");
>         }
>
> As a static analysis developer, I have made Smatch ignore WARN()
> information because warnings happen regularly and the information they
> provide is not useful.  Smatch does consider unreachable() annotations
> as accurate.
Got it, thanks for the extra information.
A WARN() with unreachable() annotation sounds like a good idea.

>
> Anyway, in this patch the situation is completely different.  Returning
> wrong error codes is a very common bug.  It's already happened once and
> it will likely happen again.
>
> My main worry with this patch is that the networking maintainers will
> say, "Thanks, but please delete all the calls to BUG() in this function".
> I just selected this one because it was particularly bad and it needs to
> be handled a bit specially.  Deleting all the other calls to BUG() isn't
> something that I want to take on.
>
Yeah, we should gradually replace these bogus BUG()s.

Anyway, for these two patches:
Acked-by: Xin Long <lucien.xin@gmail.com>

Thanks.

