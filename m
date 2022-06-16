Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519E154E8F4
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiFPR5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiFPR5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:57:48 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E435B2BC1
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:57:47 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id w6so3429107ybl.4
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JZMcsMF6xQ5Ew0merZ/5eUYUHPw10arolSepzbvx7nI=;
        b=RwLPM8L2++gJdBHafhjnJnTRdsEZ5mUtoHGqS6naUD8hX/x7SgCOLlhNxxh3fopgYj
         wY0idbpjDXGYXZ0yFg/+kqICwOaKZJh5Enewjo4/QijG7c5niibqG6z4ju7DrIIaPhHB
         9fbC1ggJR4GsUg2KWdzrMB2HlHWebS9rHcc9JtX3mX5lxkD9kl319gvMY1ChmOM6M9Eq
         /D7P2/GZnibwisJ/dbD0TTEAX6BI3vUN6czjIRqGkEk2QQhUsXW7kBrPrC7Xv2aC6cWG
         iCRWJ0UtUfpkpk0iUVrzHb81c+sH2x3HMsQ2ttvPHXo8JjvEK3KKPeNjGUSOYB4BdFtb
         LZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JZMcsMF6xQ5Ew0merZ/5eUYUHPw10arolSepzbvx7nI=;
        b=mZE/4L+y3G/DUcBUALqypKBSDERERiOaEYsJQmPrBYXcWrRH2iYPDDvkl/+zbFFgEC
         95voH19hOs0IqVuumKPT3WpcEM2y/9Mqxk/awjLlaZENgZQr84tBZ/fmLkieU/kLNGJQ
         1+IwIgMdinQtWgmrqwTtWvfxSQ6ey/wfbLWpFREJuf0Er3/SlC6hZZXdMHsDduA9VDOO
         gQLtLGZP/4raHgzLdxj5XHh+srz2heikub0ZT80rnEqWLC1NZtP3jWLX7+yUy+TeMYU3
         4xIn/EMF3CgHal5yr42rH+RylNBKQJkSDIvZKrPAJ7Fb1o0nBU4BsS2PS+T9AY+fEDsS
         PgmQ==
X-Gm-Message-State: AJIora+Evxu+iVjGgtRdU2qyoIvJp6XfhU4R7p4YhAe0eD8XgGRzG9hU
        sa1gXLlWgH/9CeguMetiefyDJfaCeoXRe/kfk5qchDl50U0ZVw==
X-Google-Smtp-Source: AGRyM1snNYqalBYtBajUoJr/L//H492nIOy1pvCCOcJXHQAYq//vcn6rYGFY8IvKMpb0pvyXTVUqZIHoRBxzR+BGaf0=
X-Received: by 2002:a25:5283:0:b0:663:98b0:4a23 with SMTP id
 g125-20020a255283000000b0066398b04a23mr6419358ybb.407.1655402266823; Thu, 16
 Jun 2022 10:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220615193213.2419568-1-joannelkoong@gmail.com>
 <CANn89i+Gf_xbz_df21QSM8ddjKkFfk1h4Y=p4vHroPRAz0ZYrw@mail.gmail.com>
 <2271ed3c6cbc3cd65680734107d773ee22ccfb3d.camel@redhat.com>
 <20220616101823.1a12e5d1@kernel.org> <CANn89iJeXRnb5VPMgFatfn8v8OPRh7riwkhg33XWCGg6tusenw@mail.gmail.com>
 <20220616104121.6d00ffb0@kernel.org>
In-Reply-To: <20220616104121.6d00ffb0@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 16 Jun 2022 19:57:35 +0200
Message-ID: <CANn89iKFOQJsUveQENMExBYziuweNoR--jBP30WbtW6iR=uJTg@mail.gmail.com>
Subject: Re: [PATCH net] Revert "net: Add a second bind table hashed by port
 and address"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 7:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 16 Jun 2022 19:28:49 +0200 Eric Dumazet wrote:
> > On Thu, Jun 16, 2022 at 7:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > Let me take the revert in for today's PR. Hope that's okay. We can
> > > revive the test in -next with the wrapper/setup issue addressed.
> > > I don't want more people to waste time bisecting the warnings this
> > > generates.
> >
> > Note we have missing Reported-... tags to please syzbot.
>
> Eish, thanks! These two only:
>
> Reported-by: syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com
> Reported-by: syzbot+98fd2d1422063b0f8c44@syzkaller.appspotmail.com
>
> or this one as well?
>
> Reported-by: syzbot+0a847a982613c6438fba@syzkaller.appspotmail.com
> https://syzkaller.appspot.com/bug?id=a63b46bf74a20d1a6b2893cedcda421620344479

All of them :)
It will allow syzbot to retry its logic and perhaps find other bugs
with similar signature.
