Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FEA53ACD2
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 20:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbiFASbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 14:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiFASbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 14:31:21 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA90ABF48;
        Wed,  1 Jun 2022 11:31:20 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id q14so2477598vsr.12;
        Wed, 01 Jun 2022 11:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OFvsxENADR9nRogVtYrcodU+LeiBGyV+qepeUinzWDE=;
        b=ettnCSZocYZcqVQEfvzuV4fO1803FG4NM6Bee7y+Bbnmke0Wu3wgZ4XWrAEdC7X3RT
         OyufiwExdccONw4dLvpl85DRE4PjSW2Qgo4C8joXXNc0CbpJvxoi82WgtxcksUmaYGQ3
         HJyrGzbdGqSiyOcwSc9TLgQlwbM5GBsbcBPI6GNEo4lo8OWfPTmyRqAmLZ9J43mh5nI3
         dSopi+vcjJTptzGcOLRa2d0UjAc7GtwnyyaXeROuGAJYTI9g247ivLjwLdToylCQ7ca8
         +VhpEbHvEBPYpMtZuQiNCbFSj83+swOspl5IttoC4TNChU7TCYdWJDCo00HYCQfMHKnq
         sUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OFvsxENADR9nRogVtYrcodU+LeiBGyV+qepeUinzWDE=;
        b=C69QEeHr2IMfNTHXtFTvxNG63HbjT9ePcqQClbfjycy7WhNpVgL0Sja+5Ij5WMRBC8
         ARowBD4CKKjpoYb7gzRszuqRXevwlb7T1sI3oLYIYrfGPD0ctQ3I6KDCDCrBSWapFfno
         GtzOQoMME5rN45chqIKktWanRtnorBUCDTpg4L0ff2dRJBUg8Ba3TaF917C0YsfCXmwl
         hBi5R+5daW4+Dmx0L/pnx0Hgp5eadbTB9uZkOM+nHdzahdM4F7JzrhHSrxswR9P8L9Cx
         HL8AleaM7swtSpd6UKHX+9Wibgur3NVzJTb7HPkULbke/L/p3AvrMYHbDOWAS51r/56x
         PKZw==
X-Gm-Message-State: AOAM532iQMrFt2AeAagWN0/iBLWXRl3ZoPmpOHXn6sbZtupr/GBVjfi5
        kZ85ORr6EDCJF/aBJ/WrYPUNupMNC7uc+lQssv4=
X-Google-Smtp-Source: ABdhPJx7fajL9rrU15sgVUAJsUHAOYFnWmV6W7+XgivDuS1jOdRXBC7zKlb0bYCdyrceDxrUcGtHL9k12EtoQHZa8Iw=
X-Received: by 2002:a05:6102:3f4b:b0:337:c02d:f5d7 with SMTP id
 l11-20020a0561023f4b00b00337c02df5d7mr697471vsv.50.1654108279594; Wed, 01 Jun
 2022 11:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220524230400.1509219-1-joannelkoong@gmail.com>
 <20220524230400.1509219-2-joannelkoong@gmail.com> <CANn89i+pg8guF+XeOngSMa4vUD81g=u-pCBpi0Yp2WB9PQZvdg@mail.gmail.com>
 <5e8ccf5fb949fb8bef822f379f7a410ccd6b6f41.camel@redhat.com>
In-Reply-To: <5e8ccf5fb949fb8bef822f379f7a410ccd6b6f41.camel@redhat.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 1 Jun 2022 11:31:08 -0700
Message-ID: <CAJnrk1bkLFwAmmQviJeeHKSHygUqG8LH81RYnx6+mJOLZF8tjw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/2] net: Update bhash2 when socket's rcv
 saddr changes
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        richard_siegfried@systemli.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, kuniyu@amazon.co.jp, dccp@vger.kernel.org,
        testing@vger.kernel.org,
        syzbot <syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 2:58 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Tue, 2022-05-31 at 15:04 -0700, Eric Dumazet wrote:
> > On Tue, May 24, 2022 at 4:20 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > >
> > > Commit d5a42de8bdbe ("net: Add a second bind table hashed by port and
> > > address") added a second bind table, bhash2, that hashes by a socket's port
> > > and rcv address.
> > >
> > > However, there are two cases where the socket's rcv saddr can change
> > > after it has been binded:
> > >
> > > 1) The case where there is a bind() call on "::" (IPADDR_ANY) and then
> > > a connect() call. The kernel will assign the socket an address when it
> > > handles the connect()
> > >
> > > 2) In inet_sk_reselect_saddr(), which is called when rerouting fails
> > > when rebuilding the sk header (invoked by inet_sk_rebuild_header)
> > >
> > > In these two cases, we need to update the bhash2 table by removing the
> > > entry for the old address, and adding a new entry reflecting the updated
> > > address.
> > >
> > > Reported-by: syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com
> > > Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> >
> > Reviewed-by: Eric Dumazet <edumzet@google.com>
> >
> Apparently this patch (and 2/2) did not reach the ML nor patchwork (let
> alone my inbox ;). I've no idea on the root cause, sorry.
>
> @Joanne: could you please re-post the series? (you can retain Eric's
> review tag)
>
For some reason, my patches recently haven't been getting through to
the netdev mailing list but they've been going through ok to the bpf
one; John, Jakub, and I are looking into it and doing some
investigations :)

I will resend this series again.

Thanks for taking a look at this patchset, Eric and Paolo.
> Thanks!
>
> Paolo
>
