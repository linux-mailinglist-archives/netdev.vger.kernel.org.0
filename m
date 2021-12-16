Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA1A477C25
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 20:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236487AbhLPTDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 14:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbhLPTDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 14:03:10 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D460C06173E
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 11:03:10 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id i12so100875wmq.4
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 11:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=HXI05E/6oOg8+zg3Xq8L/JMKsTmaYdkr5+qDutJzX9A=;
        b=EYeWtODbLiOL5AupEALW8HJ4Y03vVeyYo/Js74DLkEbhWjU4XZyXlZpdvaKk9Sks7N
         OB/hfxuZ56LN+bSUw0vK4JMzNx9gPKwh774wcO2ZOm6MRzrgnIXrq+13dIXSNC7SzpT1
         PE+sf16p+qpjItyeNdvs5DnjcPePZjWS/E9Jo3bpllb5LQLJouXM/wV3PeTGm2H/sewZ
         MdvS3wCJJSwGb3BmrCOsAUweTA+tqpd35jiX/ioWhl7LQ0vTbOcL4bPKf69oyk/1DECO
         S36VZHWRigowZv+qYEhCTMgiLgZjQK8hJcOcNuRYiVsn3QV5aO0u576OWbqfJsV18dKG
         Uvdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HXI05E/6oOg8+zg3Xq8L/JMKsTmaYdkr5+qDutJzX9A=;
        b=f7dGjm63TzD5Ag0OciZno9FfjBBG2nGylGo5ZU+87Gfp5i9iRZVuNeqXRdylrG3T6n
         gM8a/TfhSdTjRlS4Cff26K3y8DekIq0t9AG9kw16TKxZytXn1lXw3hoprGjK316Ryx1p
         vL2jnPPqWhzhM2+5pPiMpKNsbObCnHLbJd13C/i+HOw7OSq+QnYEkw44RijQ+trqXse+
         GkjGUSttOmfLKMYwhmBP+MAYRCVTB5VPBtwUMbJV8+mxeaB/dpT7Sra9Hsud61HyIRjq
         Y1zz2iuGdDNZ5k8k3MswjP/Qh5hLDROuR6sQtFCkWE9nc9Yb/3mGneZhl4Y3hwaTv/sk
         cxsg==
X-Gm-Message-State: AOAM531rCrqy240Ow9qWU8Q+H0GD5k/KvdnqZqB4rpZZMiNKHP4h0qJd
        Zcn44MFmA7Aa2B+YjrnwXdxuWw==
X-Google-Smtp-Source: ABdhPJwA5U0MGzpPuGgwV+mDNNPBbqJPJbvSTOkd0ZSRVhraJiiWQ6boXP4LJfkzRnRKugRYEbnplw==
X-Received: by 2002:a05:600c:4153:: with SMTP id h19mr6471922wmm.142.1639681388621;
        Thu, 16 Dec 2021 11:03:08 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id g13sm7475908wrd.57.2021.12.16.11.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 11:03:08 -0800 (PST)
Date:   Thu, 16 Dec 2021 19:03:02 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>,
        network dev <netdev@vger.kernel.org>
Subject: Re: [RESEND 2/2] sctp: hold cached endpoints to prevent possible UAF
Message-ID: <YbuNZtV/pjDszTad@google.com>
References: <20211214215732.1507504-1-lee.jones@linaro.org>
 <20211214215732.1507504-2-lee.jones@linaro.org>
 <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
 <Ybtrs56tSBbmyt5c@google.com>
 <CADvbK_cBBDkGt8XLJo6N5TX2YQATS+udVWm8_=8f96=0B9tnTA@mail.gmail.com>
 <Ybtzr5ZmD/IKjycz@google.com>
 <Ybtz/0gflbkG5Q/0@google.com>
 <CADvbK_cexKiVATn=dPrWqoS0qM-bM0UcSkx8Xqz5ibEKQizDVg@mail.gmail.com>
 <CADvbK_cxMbYwkuN_ZUvHY-7ahc9ff+jbuPkKn6CA=yqMk=SKVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADvbK_cxMbYwkuN_ZUvHY-7ahc9ff+jbuPkKn6CA=yqMk=SKVw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021, Xin Long wrote:

> (
> 
> On Thu, Dec 16, 2021 at 1:12 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Thu, Dec 16, 2021 at 12:14 PM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > On Thu, 16 Dec 2021, Lee Jones wrote:
> > >
> > > > On Thu, 16 Dec 2021, Xin Long wrote:
> > > >
> > > > > On Thu, Dec 16, 2021 at 11:39 AM Lee Jones <lee.jones@linaro.org> wrote:
> > > > > >
> > > > > > On Thu, 16 Dec 2021, Xin Long wrote:
> > > > > >
> > > > > > > On Wed, Dec 15, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > > > >
> > > > > > > > On Tue, 14 Dec 2021 21:57:32 +0000 Lee Jones wrote:
> > > > > > > > > The cause of the resultant dump_stack() reported below is a
> > > > > > > > > dereference of a freed pointer to 'struct sctp_endpoint' in
> > > > > > > > > sctp_sock_dump().
> > > > > > > > >
> > > > > > > > > This race condition occurs when a transport is cached into its
> > > > > > > > > associated hash table followed by an endpoint/sock migration to a new
> > > > > > > > > association in sctp_assoc_migrate() prior to their subsequent use in
> > > > > > > > > sctp_diag_dump() which uses sctp_for_each_transport() to walk the hash
> > > > > > > > > table calling into sctp_sock_dump() where the dereference occurs.
> > > > > >
> > > > > > > in sctp_sock_dump():
> > > > > > >         struct sock *sk = ep->base.sk;
> > > > > > >         ... <--[1]
> > > > > > >         lock_sock(sk);
> > > > > > >
> > > > > > > Do you mean in [1], the sk is peeled off and gets freed elsewhere?
> > > > > >
> > > > > > 'ep' and 'sk' are both switched out for new ones in sctp_sock_migrate().
> > > > > >
> > > > > > > if that's true, it's still late to do sock_hold(sk) in your this patch.
> > > > > >
> > > > > > No, that's not right.
> > > > > >
> > > > > > The schedule happens *inside* the lock_sock() call.
> > > > > Sorry, I don't follow this.
> > > > > We can't expect when the schedule happens, why do you think this
> > > > > can never be scheduled before the lock_sock() call?
> > > >
> > > > True, but I've had this running for hours and it hasn't reproduced.
> > I understand, but it's a crash, we shouldn't take any risk that it
> > will never happen.
> > you may try to add a usleep() before the lock_sock call to reproduce it.
> >
> > > >
> > > > Without this patch, I can reproduce this in around 2 seconds.
> > > >
> > > > The C-repro for this is pretty intense!
> > > >
> > > > If you want to be *sure* that a schedule will never happen, we can
> > > > take a reference directly with:
> > > >
> > > >      ep = sctp_endpoint_hold(tsp->asoc->ep);
> > > >      sk = sock_hold(ep->base.sk);
> > > >
> > > > Which was my original plan before I soak tested this submitted patch
> > > > for hours without any sign of reproducing the issue.
> > we tried to not export sctp_obj_hold/put(), that's why we had
> > sctp_for_each_transport().
> >
> > ep itself holds a reference of sk when it's alive, so it's weird to do
> > these 2 together.
> >
> > > >
> > > > > If the sock is peeled off or is being freed, we shouldn't dump this sock,
> > > > > and it's better to skip it.
> > > >
> > > > I guess we can do that too.
> > > >
> > > > Are you suggesting sctp_sock_migrate() as the call site?
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 85ac2e901ffc..56ea7a0e2add 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -9868,6 +9868,7 @@ static int sctp_sock_migrate(struct sock *oldsk,
> > struct sock *newsk,
> >                 inet_sk_set_state(newsk, SCTP_SS_ESTABLISHED);
> >         }
> >
> > +       sock_set_flag(oldsk, SOCK_RCU_FREE);
> >         release_sock(newsk);
> >
> >         return 0;
> >
> > SOCK_RCU_FREE is set to the previous sk, so that this sk will not
> > be freed between rcu_read_lock() and rcu_read_unlock().
> >
> > >
> > > Also, when are you planning on testing the flag?
> > SOCK_RCU_FREE flag is used when freeing sk in sk_destruct(),
> > and if it's set, it will be freed in the next grace period of RCU.
> >
> > >
> > > Won't that suffer with the same issue(s)?
> > diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> > index 7970d786c4a2..b4c4acd9e67e 100644
> > --- a/net/sctp/diag.c
> > +++ b/net/sctp/diag.c
> > @@ -309,16 +309,21 @@ static int sctp_tsp_dump_one(struct
> > sctp_transport *tsp, void *p)
> >
> >  static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
> >  {
> > -       struct sctp_endpoint *ep = tsp->asoc->ep;
> >         struct sctp_comm_param *commp = p;
> > -       struct sock *sk = ep->base.sk;
> >         struct sk_buff *skb = commp->skb;
> >         struct netlink_callback *cb = commp->cb;
> >         const struct inet_diag_req_v2 *r = commp->r;
> >         struct sctp_association *assoc;
> > +       struct sctp_endpoint *ep;
> > +       struct sock *sk;
> >         int err = 0;
> >
> > +       rcu_read_lock();
> > +       ep = tsp->asoc->ep;
> > +       sk = ep->base.sk;
> >         lock_sock(sk);
> Unfortunately, this isn't going to work, as lock_sock() may sleep,
> and is not allowed to be called understand rcu_read_lock() :(

Ah!

How about my original solution of taking:

  tsp->asoc->ep

... directly?

If it already holds the sk, we should be golden?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
