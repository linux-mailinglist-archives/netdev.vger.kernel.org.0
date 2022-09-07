Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB4A5AFD33
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiIGHM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiIGHMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:12:55 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753D3876BB;
        Wed,  7 Sep 2022 00:12:54 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f124so4476571pgc.0;
        Wed, 07 Sep 2022 00:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=EYU7m8YaVQO9eARHSafYWEvWrS+hrk6aRWpjnoUv4Rk=;
        b=leaUS1ZqnrU1O7tawO83FWh2m/8RuYGDLPVilBIzxT0RJmX3Ik4cxZSFKq5QZGqA0G
         7K9e6HvLQw6aOdaS25AYQF+JVTA3rhnAwGB3MWydCdsZknQPYxaSdBu8EFhIZiPKn1Os
         iJu3oLVljBBpWPiBN73KtT2l9EY3zPOAOPL3ibqFZaAjQ/k98GPn+lRVqzPINRDEHfdV
         UcVKATvow70JOrg1jyLBCCtqmWpHHiCurOq7QkK+t8pIffrxy7vXKd6WUvcFJIIBDcsQ
         +NaflUBsLQckgf2RFCqRAhm4KowyYDG/SR2mDTM/6TnIzlmtL3LDA6VInxbpemmQdM+0
         99fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=EYU7m8YaVQO9eARHSafYWEvWrS+hrk6aRWpjnoUv4Rk=;
        b=DwyW+bYXcpaj+ObD5A7wxwZD57ybq6xH1ExXqJLvHZKWU8SKWMLKBWWaGleOsdIyfJ
         /Ap/kgT0SYxK+OsO7KM9lgbtZZIYPX/vn2A8FEdE17rvPR6rzQUsakMhx21VVbMwlUnf
         ihatMs6JWd//qJieLVOwAy4JNpeJRzzYCxpp9CEHHiTjyCIIyMsfSaz1yaKnpX7QnM7u
         u6lsFQYTdQ+jz4LzI08B8oMV3FZCjv6s1Ev88Ps3GpKx+wVOr2Q8XCbP/0/XRtpkaiU7
         SVLgLQ4Yga5q3a6QujoBaeDZWQi1uuFh9mrpB2xeXAacenqcq7J75S+RzzCl7xM+U8no
         xAmA==
X-Gm-Message-State: ACgBeo1sXrokaz9/zBMd74ot7YdWwHqJYAfFKHtMEwDFBmy+fgnWFBnp
        fB5N72y+XodpRvHihf97gQNoldpYJo+NdDWEcrZHO4IGXUM=
X-Google-Smtp-Source: AA6agR5yMTUbTLEeICLJISRBS4nWwh+hNMdNJ5dR9yJL+fl6L+X9vHKmvkwLCG8LWmeuezj4p3S0a0grLk/Z78fLApI=
X-Received: by 2002:a05:6a00:a05:b0:534:b1ad:cfac with SMTP id
 p5-20020a056a000a0500b00534b1adcfacmr2349409pfh.35.1662534773856; Wed, 07 Sep
 2022 00:12:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220905050400.1136241-1-imagedong@tencent.com>
 <da8998cba112cbdea9d403052732c794f3882bd2.camel@redhat.com>
 <CADxym3agY5PmVOgCKpxO8mwrCTGnJ6BNvYZUcgu0jwRJEiawHw@mail.gmail.com> <1bfe80691f6d7c1cf427e5fb979d5dd6f841a4f0.camel@redhat.com>
In-Reply-To: <1bfe80691f6d7c1cf427e5fb979d5dd6f841a4f0.camel@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 7 Sep 2022 15:12:42 +0800
Message-ID: <CADxym3bM8eph7UkKF7HLk2CybU=FDmxTzJ+=W9pH4HFgm-5UsQ@mail.gmail.com>
Subject: Re: [PATCH net] net: mptcp: fix unreleased socket in accept queue
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
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

On Tue, Sep 6, 2022 at 3:02 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2022-09-05 at 17:03 +0800, Menglong Dong wrote:
> > On Mon, Sep 5, 2022 at 4:26 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > >
> > > Hello,
> > >
> > > On Mon, 2022-09-05 at 13:04 +0800, menglong8.dong@gmail.com wrote:
> > > > From: Menglong Dong <imagedong@tencent.com>
> > > >
> > > > The mptcp socket and its subflow sockets in accept queue can't be
> > > > released after the process exit.
> > > >
> > > > While the release of a mptcp socket in listening state, the
> > > > corresponding tcp socket will be released too. Meanwhile, the tcp
> > > > socket in the unaccept queue will be released too. However, only init
> > > > subflow is in the unaccept queue, and the joined subflow is not in the
> > > > unaccept queue, which makes the joined subflow won't be released, and
> > > > therefore the corresponding unaccepted mptcp socket will not be released
> > > > to.
> > > >
> > > > This can be reproduced easily with following steps:
> > > >
> > > > 1. create 2 namespace and veth:
> > > >    $ ip netns add mptcp-client
> > > >    $ ip netns add mptcp-server
> > > >    $ sysctl -w net.ipv4.conf.all.rp_filter=0
> > > >    $ ip netns exec mptcp-client sysctl -w net.mptcp.enabled=1
> > > >    $ ip netns exec mptcp-server sysctl -w net.mptcp.enabled=1
> > > >    $ ip link add red-client netns mptcp-client type veth peer red-server \
> > > >      netns mptcp-server
> > > >    $ ip -n mptcp-server address add 10.0.0.1/24 dev red-server
> > > >    $ ip -n mptcp-server address add 192.168.0.1/24 dev red-server
> > > >    $ ip -n mptcp-client address add 10.0.0.2/24 dev red-client
> > > >    $ ip -n mptcp-client address add 192.168.0.2/24 dev red-client
> > > >    $ ip -n mptcp-server link set red-server up
> > > >    $ ip -n mptcp-client link set red-client up
> > > >
> > > > 2. configure the endpoint and limit for client and server:
> > > >    $ ip -n mptcp-server mptcp endpoint flush
> > > >    $ ip -n mptcp-server mptcp limits set subflow 2 add_addr_accepted 2
> > > >    $ ip -n mptcp-client mptcp endpoint flush
> > > >    $ ip -n mptcp-client mptcp limits set subflow 2 add_addr_accepted 2
> > > >    $ ip -n mptcp-client mptcp endpoint add 192.168.0.2 dev red-client id \
> > > >      1 subflow
> > > >
> > > > 3. listen and accept on a port, such as 9999. The nc command we used
> > > >    here is modified, which makes it uses mptcp protocol by default.
> > > >    And the default backlog is 1:
> > > >    ip netns exec mptcp-server nc -l -k -p 9999
> > > >
> > > > 4. open another *two* terminal and connect to the server with the
> > > >    following command:
> > > >    $ ip netns exec mptcp-client nc 10.0.0.1 9999
> > > >    input something after connect, to triger the connection of the second
> > > >    subflow
> > > >
> > > > 5. exit all the nc command, and check the tcp socket in server namespace.
> > > >    And you will find that there is one tcp socket in CLOSE_WAIT state
> > > >    and can't release forever.
> > >
> > > Thank you for the report!
> > >
> > > I have a doubt WRT the above scenario: AFAICS 'nc' will accept the
> > > incoming sockets ASAP, so the unaccepted queue should be empty at
> > > shutdown, but that does not fit with your description?!?
> > >
> >
> > By default, as far as in my case, nc won't accept the new connection
> > until the first connection closes with the '-k' set. Therefor, the second
> > connection will stay in the unaccepted queue.
>
> I missed the fact you opened 2 connections. I guess that is point 4
> above. Please rephrase that sentence with something alike:
>
> ---
> 4. open another *two* terminal and use each of them to connect to the
> server with the following command:
> ...
> So that there are two established mptcp connections, with the second
> one still unaccepted.
> ---

Sounds nice! Thanks~

> >
> > > > There are some solutions that I thought:
> > > >
> > > > 1. release all unaccepted mptcp socket with mptcp_close() while the
> > > >    listening tcp socket release in mptcp_subflow_queue_clean(). This is
> > > >    what we do in this commit.
> > > > 2. release the mptcp socket with mptcp_close() in subflow_ulp_release().
> > > > 3. etc
> > > >
> > >
> > > Can you please point to a commit introducing the issue?
> > >
> >
> > In fact, I'm not sure. In my case, I found this issue in kernel 5.10.
> > And I wanted to find the solution in the upstream, but find that
> > upstream has this issue too.
> >
> > Hmm...I am curious if this issue exists in the beginning? I
> > can't find the opportunity that the joined subflow which are
> > unaccepted can be released.
>
> It looks like the problem is there since MPJ support, commit
> f296234c98a8fcec94eec80304a873f635d350ea
>

Yeah, I'll add a Fixes tag for this commit.

> >
> > > > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > > > ---
> > > >  net/mptcp/subflow.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> > > > index c7d49fb6e7bd..e39dff5d5d84 100644
> > > > --- a/net/mptcp/subflow.c
> > > > +++ b/net/mptcp/subflow.c
> > > > @@ -1770,6 +1770,10 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
> > > >               msk->first = NULL;
> > > >               msk->dl_next = NULL;
> > > >               unlock_sock_fast(sk, slow);
> > > > +
> > > > +             /*  */
> > > > +             sock_hold(sk);
> > > > +             sk->sk_prot->close(sk);
> > >
> > > You can call mptcp_close() directly here.
> > >
> > > Perhaps we could as well drop the mptcp_sock_destruct() hack?
> >
> > Do you mean to call mptcp_sock_destruct() directly here?
>
> I suspect that with this change setting msk->sk_destruct to
> mptcp_sock_destruct in subflow_syn_recv_sock() is not needed anymore,
> and the relevant intialization (and callback definition) could be
> removed.

Your suspect should be right. The mptcp_subflow_queue_clean()
should always be called before unaccepted tcp socket and the
corresponding mptcp socket release.
Therefore this change can ensure that the mptcp socket will be
CLOSE state when it is released. I'll remove
mptcp_sock_destruct(), BTW.

Thanks!
Menglong Dong

>
> >
> Cheers,
>
> Paolo
>
