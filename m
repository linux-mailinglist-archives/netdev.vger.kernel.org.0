Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF59444A94
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 23:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhKCWEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 18:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhKCWEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 18:04:21 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E2DC06127A
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 15:01:44 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z20so14289639edc.13
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 15:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TE+3cwTaC6K5rO3Q3MpOjAlohLPzRsp1yxXkdsv0VUw=;
        b=erZguU4z0nrKa/oX4nBkvy8iX3GwLs9eWARWEhH5PrLeePPnkGdhdW2+NzQEsXXGWn
         4N1UlvYJ/dVTQ763BHT/DYUhuDVR7t/GAYnj8lIls7Wm1WIr/IjBTYfRil6NI3vvR2+R
         OomE41AGwGwHd0BfNv6GbiEvoCsa8SgIIp21IS3ZtiTPZGZ70PRh1n0/9Ewg9wQGwJJ9
         x4dLjIGHC1MDIRycI3qhH2wxbkXW1a2QenNnB79539JwJqYHopkMk3K5PJY3AFUiTOnb
         om9Dg2qAwG9u1aB0AbDlcnLMWafFbePLZslvMb7ENI0QSBHZ/tRu4GdV9M8lsNnb3M88
         y6wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TE+3cwTaC6K5rO3Q3MpOjAlohLPzRsp1yxXkdsv0VUw=;
        b=fDFGSe4ObsRoI5p5S5CYQUCPLtCWXFpRXptQ6Y7HK7dgkkmTh7OVdxJsf/BFWsGS9E
         N+M4GqPV0WWwNsOnhIUN4OrjGDGBXFip445SqHcTnRZsfqVDAJ0Nfz14U/SRzMYXnsET
         8EEO8f7tEcBAg+S26mrMT1eravJSqx9iTSgbdWy0VcQrJBBgu29nLxDym8ghZ+bSQv2I
         qcGxilliJrc0adDesjT5d/fpqnfFGS6y7+7Spey9zsENeG7V4BMQZ4x743QIYfKtvxvd
         eOz2VAO/Pi6It5Fc6F8vkO0rY/HlnMxn88c7iFVAEQ04Syt/Er2LAUjRSyYOKmBe7jIn
         3Ekg==
X-Gm-Message-State: AOAM530HkM33Ct/3qYoblaByd5Kv3qDtLlwLaVbIdhQtV432pFkuzOL3
        PqqKkRsnN8y1nxAbr4c3Zd10VeHbMF43+eA4fX42Ob22zJO/
X-Google-Smtp-Source: ABdhPJzgb7DlErXb6KNErPXw1SygqoEVFkn2NpqV4M0ehMHW7InlRoMya1mGPXdJ5Wg/d5nXri0sKDLy1Jzb+oc+MqM=
X-Received: by 2002:a17:907:2d12:: with SMTP id gs18mr38398502ejc.126.1635976902513;
 Wed, 03 Nov 2021 15:01:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1635854268.git.lucien.xin@gmail.com> <cdca8eaca8a0ec5fe4aa58412a6096bb08c3c9bc.1635854268.git.lucien.xin@gmail.com>
 <CAFqZXNtJNnk+iwLnGq6mpdTKuWFmZ4W0PCTj4ira7G2HHPU1tA@mail.gmail.com>
 <CADvbK_cDSKJ+eWeOdvURV_mDXEgEE+B3ZG3ASiKOm501NO9CqQ@mail.gmail.com> <CADvbK_ddKB_N=Bj8vtTF_aufmgkqmoQGz+-t7e2nZgoBrDWk8Q@mail.gmail.com>
In-Reply-To: <CADvbK_ddKB_N=Bj8vtTF_aufmgkqmoQGz+-t7e2nZgoBrDWk8Q@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 3 Nov 2021 18:01:31 -0400
Message-ID: <CAHC9VhRQ3wGRTL1UXEnnhATGA_zKASVJJ6y4cbWYoA19CZyLbA@mail.gmail.com>
Subject: Re: [PATCHv2 net 4/4] security: implement sctp_assoc_established hook
 in selinux
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        network dev <netdev@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Richard Haines <richard_c_haines@btinternet.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 1:36 PM Xin Long <lucien.xin@gmail.com> wrote:
> On Wed, Nov 3, 2021 at 1:33 PM Xin Long <lucien.xin@gmail.com> wrote:
> > On Wed, Nov 3, 2021 at 12:40 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > > On Tue, Nov 2, 2021 at 1:03 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > Different from selinux_inet_conn_established(), it also gives the
> > > > secid to asoc->peer_secid in selinux_sctp_assoc_established(),
> > > > as one UDP-type socket may have more than one asocs.
> > > >
> > > > Note that peer_secid in asoc will save the peer secid for this
> > > > asoc connection, and peer_sid in sksec will just keep the peer
> > > > secid for the latest connection. So the right use should be do
> > > > peeloff for UDP-type socket if there will be multiple asocs in
> > > > one socket, so that the peeloff socket has the right label for
> > > > its asoc.
> > > >
> > > > v1->v2:
> > > >   - call selinux_inet_conn_established() to reduce some code
> > > >     duplication in selinux_sctp_assoc_established(), as Ondrej
> > > >     suggested.
> > > >   - when doing peeloff, it calls sock_create() where it actually
> > > >     gets secid for socket from socket_sockcreate_sid(). So reuse
> > > >     SECSID_WILD to ensure the peeloff socket keeps using that
> > > >     secid after calling selinux_sctp_sk_clone() for client side.
> > >
> > > Interesting... I find strange that SCTP creates the peeloff socket
> > > using sock_create() rather than allocating it directly via
> > > sock_alloc() like the other callers of sctp_copy_sock() (which calls
> > > security_sctp_sk_clone()) do. Wouldn't it make more sense to avoid the
> > > sock_create() call and just rely on the security_sctp_sk_clone()
> > > semantic to set up the labels? Would anything break if
> > > sctp_do_peeloff() switched to plain sock_alloc()?
> > >
> > > I'd rather we avoid this SECSID_WILD hack to support the weird
> > > created-but-also-cloned socket hybrid and just make the peeloff socket
> > > behave the same as an accept()-ed socket (i.e. no
> > > security_socket_[post_]create() hook calls, just
> > > security_sctp_sk_clone()).

I believe the important part is that sctp_do_peeloff() eventually
calls security_sctp_sk_clone() via way of sctp_copy_sock().  Assuming
we have security_sctp_sk_clone() working properly I would expect that
the new socket would be setup properly when sctp_do_peeloff() returns
on success.

... and yes, that SECSID_WILD approach is *not* something we want to do.

In my mind, selinux_sctp_sk_clone() should end up looking like this.

  void selinux_sctp_sk_clone(asoc, sk, newsk)
  {
    struct sk_security_struct sksec = sk->sk_security;
    struct sk_security_struct newsksec = newsk->sk_security;

    if (!selinux_policycap_extsockclass())
        return selinux_sk_clone_security(sk, newsk);

    newsksec->sid = sksec->secid;
    newsksec->peer_sid = asoc->peer_secid;
    newsksec->sclass = sksec->sclass;
    selinux_netlbl_sctp_sk_clone(sk, newsk);
  }

Also, to be clear, the "assoc->secid = SECSID_WILD;" line should be
removed from selinux_sctp_assoc_established().  If we are treating
SCTP associations similarly to TCP connections, the association's
label/secid should be set once and not changed during the life of the
association.

> > > > Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> > > > Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> > > > Reviewed-by: Richard Haines <richard_c_haines@btinternet.com>
> > > > Tested-by: Richard Haines <richard_c_haines@btinternet.com>
> > >
> > > You made non-trivial changes since the last revision in this patch, so
> > > you should have also dropped the Reviewed-by and Tested-by here. Now
> > > David has merged the patches probably under the impression that they
> > > have been reviewed/approved from the SELinux side, which isn't
> > > completely true.
> >
> > Oh, that's a mistake, I thought I didn't add it.
> > Will he be able to test this new patchset?

While I tend to try to avoid reverts as much as possible, I think the
right thing to do is to get these patches reverted out of DaveM's tree
while we continue to sort this out and do all of the necessary testing
and verification.

Xin Long, please work with the netdev folks to get your patchset
reverted and then respin this patchset using the feedback provided.

-- 
paul moore
www.paul-moore.com
