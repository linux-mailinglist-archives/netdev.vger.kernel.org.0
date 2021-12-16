Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8387477B7C
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 19:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbhLPSZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 13:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236282AbhLPSZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 13:25:34 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1554C06173E
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 10:25:33 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a9so45762887wrr.8
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 10:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NmplNo6LGZjxjChzzqohfGooZObrNddOpc+RBE6l51Y=;
        b=IBOqitDrVRs50lMpGiLZbn0AZg3wKo2VpvWmmQ6eohtZpA5gO+UeKHKUWbwJ7Wv7XB
         +G2T+Z7fSObRRm0JiMQPZw5I3YPbiuTpSIzhv1ZVptCjo3Gp7bKto1g1KzISsUjB9z9E
         18KgrEzVvdU1ZX73vQYQq3ryP5jtFy+6fG1Tfw0t5z28wFPgqfCKwnCwW9I69hcXtDEn
         hUYRqaKOlDgwLkh3cm3kI4stMJdWfjuILwjf02xwSE3RlrkIubdF5a50e+K7IzMD0/qJ
         CfGZ6KYA8EPBev57h56nekW1aloG19jX97Pb/tCqM+vcsig2E0tXAh/HoXtdVAb3iGGQ
         wiJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NmplNo6LGZjxjChzzqohfGooZObrNddOpc+RBE6l51Y=;
        b=V1IS5bwJkF99RcQ3h6oEbx+BRAkwBafnh4Oy8jjjK6RAU2eV503YJTmLQSXY4Aqr5/
         xe62VbB2ELv49By/ZMX7s7rg5SNrNTj2Zx7cHu+Y6w1uO31619w0jQ1vrdg0gtByAAY9
         I0LfRGgOI3OF0ImjSx8hSNuhLUVniKqHksoombJV4UoMxUodWipIsjcjEgD9oQhg/+mB
         v0eWQ6b/y+mD/FWwI3SIcBftGFqb4L38rXZd9Kk+2Q0m6fCeAeeelOIR+ce+p9XLea6g
         6fSas/aadaEYDSl7tf1j89+9HW8YOQ23eQlEuTf8Tv3SW2J6LDyv1Vk5Ad+omjvyRi2P
         uNLA==
X-Gm-Message-State: AOAM531st1VZcEdzU6g8jnLwAe/Jf91lE4AEM2XFbLiUoHtl3lTSQvzp
        n2exLxKMjMLlvNI3QpICC/VtoA==
X-Google-Smtp-Source: ABdhPJzZm8f0ZLiFn8xcClDEDYbpgwTFx+be3UAmNhJgcXB75SceojuFd1f/pPYEgHPfdgb5W6Q4Cg==
X-Received: by 2002:adf:cf05:: with SMTP id o5mr10190078wrj.325.1639679132112;
        Thu, 16 Dec 2021 10:25:32 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id g3sm2392058wrd.112.2021.12.16.10.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 10:25:31 -0800 (PST)
Date:   Thu, 16 Dec 2021 18:25:23 +0000
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
Message-ID: <YbuEk7Xc2hzek2jx@google.com>
References: <20211214215732.1507504-1-lee.jones@linaro.org>
 <20211214215732.1507504-2-lee.jones@linaro.org>
 <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
 <Ybtrs56tSBbmyt5c@google.com>
 <CADvbK_cBBDkGt8XLJo6N5TX2YQATS+udVWm8_=8f96=0B9tnTA@mail.gmail.com>
 <Ybtzr5ZmD/IKjycz@google.com>
 <Ybtz/0gflbkG5Q/0@google.com>
 <CADvbK_cexKiVATn=dPrWqoS0qM-bM0UcSkx8Xqz5ibEKQizDVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADvbK_cexKiVATn=dPrWqoS0qM-bM0UcSkx8Xqz5ibEKQizDVg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021, Xin Long wrote:

> On Thu, Dec 16, 2021 at 12:14 PM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > On Thu, 16 Dec 2021, Lee Jones wrote:
> >
> > > On Thu, 16 Dec 2021, Xin Long wrote:
> > >
> > > > On Thu, Dec 16, 2021 at 11:39 AM Lee Jones <lee.jones@linaro.org> wrote:
> > > > >
> > > > > On Thu, 16 Dec 2021, Xin Long wrote:
> > > > >
> > > > > > On Wed, Dec 15, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > > >
> > > > > > > On Tue, 14 Dec 2021 21:57:32 +0000 Lee Jones wrote:
> > > > > > > > The cause of the resultant dump_stack() reported below is a
> > > > > > > > dereference of a freed pointer to 'struct sctp_endpoint' in
> > > > > > > > sctp_sock_dump().
> > > > > > > >
> > > > > > > > This race condition occurs when a transport is cached into its
> > > > > > > > associated hash table followed by an endpoint/sock migration to a new
> > > > > > > > association in sctp_assoc_migrate() prior to their subsequent use in
> > > > > > > > sctp_diag_dump() which uses sctp_for_each_transport() to walk the hash
> > > > > > > > table calling into sctp_sock_dump() where the dereference occurs.
> > > > >
> > > > > > in sctp_sock_dump():
> > > > > >         struct sock *sk = ep->base.sk;
> > > > > >         ... <--[1]
> > > > > >         lock_sock(sk);
> > > > > >
> > > > > > Do you mean in [1], the sk is peeled off and gets freed elsewhere?
> > > > >
> > > > > 'ep' and 'sk' are both switched out for new ones in sctp_sock_migrate().
> > > > >
> > > > > > if that's true, it's still late to do sock_hold(sk) in your this patch.
> > > > >
> > > > > No, that's not right.
> > > > >
> > > > > The schedule happens *inside* the lock_sock() call.
> > > > Sorry, I don't follow this.
> > > > We can't expect when the schedule happens, why do you think this
> > > > can never be scheduled before the lock_sock() call?
> > >
> > > True, but I've had this running for hours and it hasn't reproduced.
> I understand, but it's a crash, we shouldn't take any risk that it
> will never happen.
> you may try to add a usleep() before the lock_sock call to reproduce it.
> 
> > >
> > > Without this patch, I can reproduce this in around 2 seconds.
> > >
> > > The C-repro for this is pretty intense!
> > >
> > > If you want to be *sure* that a schedule will never happen, we can
> > > take a reference directly with:
> > >
> > >      ep = sctp_endpoint_hold(tsp->asoc->ep);
> > >      sk = sock_hold(ep->base.sk);
> > >
> > > Which was my original plan before I soak tested this submitted patch
> > > for hours without any sign of reproducing the issue.
> we tried to not export sctp_obj_hold/put(), that's why we had
> sctp_for_each_transport().
> 
> ep itself holds a reference of sk when it's alive, so it's weird to do
> these 2 together.
> 
> > >
> > > > If the sock is peeled off or is being freed, we shouldn't dump this sock,
> > > > and it's better to skip it.
> > >
> > > I guess we can do that too.
> > >
> > > Are you suggesting sctp_sock_migrate() as the call site?
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 85ac2e901ffc..56ea7a0e2add 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9868,6 +9868,7 @@ static int sctp_sock_migrate(struct sock *oldsk,
> struct sock *newsk,
>                 inet_sk_set_state(newsk, SCTP_SS_ESTABLISHED);
>         }
> 
> +       sock_set_flag(oldsk, SOCK_RCU_FREE);
>         release_sock(newsk);
> 
>         return 0;
> 
> SOCK_RCU_FREE is set to the previous sk, so that this sk will not
> be freed between rcu_read_lock() and rcu_read_unlock().
> 
> >
> > Also, when are you planning on testing the flag?
> SOCK_RCU_FREE flag is used when freeing sk in sk_destruct(),
> and if it's set, it will be freed in the next grace period of RCU.
> 
> >
> > Won't that suffer with the same issue(s)?
> diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> index 7970d786c4a2..b4c4acd9e67e 100644
> --- a/net/sctp/diag.c
> +++ b/net/sctp/diag.c
> @@ -309,16 +309,21 @@ static int sctp_tsp_dump_one(struct
> sctp_transport *tsp, void *p)
> 
>  static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
>  {
> -       struct sctp_endpoint *ep = tsp->asoc->ep;
>         struct sctp_comm_param *commp = p;
> -       struct sock *sk = ep->base.sk;
>         struct sk_buff *skb = commp->skb;
>         struct netlink_callback *cb = commp->cb;
>         const struct inet_diag_req_v2 *r = commp->r;
>         struct sctp_association *assoc;
> +       struct sctp_endpoint *ep;
> +       struct sock *sk;
>         int err = 0;
> 
> +       rcu_read_lock();
> +       ep = tsp->asoc->ep;
> +       sk = ep->base.sk;
>         lock_sock(sk);
> +       if (tsp->asoc->ep != ep)
> +               goto release;
>         list_for_each_entry(assoc, &ep->asocs, asocs) {
>                 if (cb->args[4] < cb->args[1])
>                         goto next;
> @@ -358,6 +363,7 @@ static int sctp_sock_dump(struct sctp_transport
> *tsp, void *p)
>         cb->args[4] = 0;
>  release:
>         release_sock(sk);
> +       rcu_read_unlock();
>         return err;
>  }
> 
> rcu_read_lock() will make sure sk from tsp->asoc->ep->base.sk will not
> be freed until rcu_read_unlock().
> 
> That's all I have. Do you see any other way to fix this?

No, that sounds reasonable enough.

Do you want me to hack this up and test it, or are you planning on
submitting a this?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
