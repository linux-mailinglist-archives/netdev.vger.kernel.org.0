Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF27C358843
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 17:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhDHPZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 11:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbhDHPZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 11:25:10 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97920C061763;
        Thu,  8 Apr 2021 08:24:58 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a7so3756051eju.1;
        Thu, 08 Apr 2021 08:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2DctV2bRWf9bByNN4jO+KZZov1aPn00QO4Vdegx2Cow=;
        b=WX/inlaeeRIbsG86uDWLNx7q9abVElPQlit8MiD/qADEh+BkApQz6ZTJFohiy78033
         h2rm8PaFTYBZr60Er0hM6LkGcCOTobwmLaZaQp96KarlKd4mBvwomsSSLeRozAvzZwy6
         INi/JbdycJcG3kjZ7cNA99vdxVe9z3Jfk4go68uQx5ujXaX81ZCmF0TqOANYvKip1kHp
         a4L5MqMnRQIJLQweJVwEw3SPMIvjuYwlP626MmsqqSeaW3oSDVYDq05UEmWGz77BC1aZ
         o/iBbvM8u89iteW2KMJAdo+Poa//SkEzFA3BaHmafDBE7PqVTY1gl8xdv/tPRWzi6S5Y
         9Kjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2DctV2bRWf9bByNN4jO+KZZov1aPn00QO4Vdegx2Cow=;
        b=tddlTZdgakqIv4wy7B+TQ5drUb59f65pdxbZjf+VuE4MLMExclvsAWAZxyHvzNJr7w
         6zD3uHpyZnGcwvFdQsxCZgV2eOxjI7wAl0tW+PIANGz3JuPiE5C16zdY6OaAmpzvTvGf
         kuSj42ellAY637Sc4LRxg/270RRPvlbu0nHOB8wm6SRpWlJEl/9EL6ziSh0zEjbbccgZ
         B7PRRu+HCXF7n+dW75HYW85wNImWCxLHawW0R6zt7/kCBRLFzoM5n2vlEj/qTbPsVab+
         ZPy8IutpibOk/HNBm83bRjBq82H2QbsrukUeI+Gac50VNNcM8NEVths1E/TOyL0ZvxFp
         6DnQ==
X-Gm-Message-State: AOAM532UJGN/cF0IUWoAKLkI4fEKKMw245qKduz68mh339gCN09ZZxQn
        7icT7sUIyEH9YHzkSw2MQTPOlkKZUlO5+Ku1R9o=
X-Google-Smtp-Source: ABdhPJxL8zi4DQYkjJuJ7486ivbwyswwR3YPdBXE8zctrhzn0c+SIv23BREveuykwcFjiMoPUBHx7HFc+kG/LvfLCO4=
X-Received: by 2002:a17:906:7194:: with SMTP id h20mr10309618ejk.432.1617895497312;
 Thu, 08 Apr 2021 08:24:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210407001658.2208535-1-pakki001@umn.edu> <c0de0985c0bf09a96efc538da2146f86e6fa7037.camel@hammerspace.com>
In-Reply-To: <c0de0985c0bf09a96efc538da2146f86e6fa7037.camel@hammerspace.com>
From:   Olga Kornievskaia <aglo@umich.edu>
Date:   Thu, 8 Apr 2021 11:24:45 -0400
Message-ID: <CAN-5tyETkDBVfYQrBOm1veAzMdo-9K37bfgL+QZTPW=d2OAP9A@mail.gmail.com>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "pakki001@umn.edu" <pakki001@umn.edu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "dwysocha@redhat.com" <dwysocha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 11:01 AM Trond Myklebust <trondmy@hammerspace.com> wrote:
>
> On Tue, 2021-04-06 at 19:16 -0500, Aditya Pakki wrote:
> > In gss_pipe_destroy_msg(), in case of error in msg, gss_release_msg
> > deletes gss_msg. The patch adds a check to avoid a potential double
> > free.
> >
> > Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> > ---
> >  net/sunrpc/auth_gss/auth_gss.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/sunrpc/auth_gss/auth_gss.c
> > b/net/sunrpc/auth_gss/auth_gss.c
> > index 5f42aa5fc612..eb52eebb3923 100644
> > --- a/net/sunrpc/auth_gss/auth_gss.c
> > +++ b/net/sunrpc/auth_gss/auth_gss.c
> > @@ -848,7 +848,8 @@ gss_pipe_destroy_msg(struct rpc_pipe_msg *msg)
> >                         warn_gssd();
> >                 gss_release_msg(gss_msg);
> >         }
> > -       gss_release_msg(gss_msg);
> > +       if (gss_msg)
> > +               gss_release_msg(gss_msg);
> >  }
> >
> >  static void gss_pipe_dentry_destroy(struct dentry *dir,
>
>
> NACK. There's no double free there.

I disagree that there is no double free, the wording of the commit
describes the problem in the error case is that we call
gss_release_msg() and then we call it again but the 1st one released
the gss_msg. However, I think the fix should probably be instead:
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 5f42aa5fc612..e8aae617e981 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -846,7 +846,7 @@ gss_pipe_destroy_msg(struct rpc_pipe_msg *msg)
                gss_unhash_msg(gss_msg);
                if (msg->errno == -ETIMEDOUT)
                        warn_gssd();
-               gss_release_msg(gss_msg);
+               return gss_release_msg(gss_msg);
        }
        gss_release_msg(gss_msg);
 }

>
> --
> Trond Myklebust
> Linux NFS client maintainer, Hammerspace
> trond.myklebust@hammerspace.com
>
>
