Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC711DE91C
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 16:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbgEVOg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 10:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729879AbgEVOg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 10:36:28 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D72C061A0E;
        Fri, 22 May 2020 07:36:28 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id m64so8438332qtd.4;
        Fri, 22 May 2020 07:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y7e3HusqoAMf8lrG+OWAU7meO/T/O/pS1B2DGDxN+tM=;
        b=tGRwbxQcyInDydtbs4YCi4xcrfAyqdO8VNBMCjG0a914AyfY28umFhgCHaMcjpALjG
         LIxMiS+Yo/iLfLLBXWbHHxYRTX+xbKlsOTNe+2J1hIq7DYjMUOFi4c9TattD0igcVXr+
         Y44aif1ErDtpQgAS52445nS/2whHRuLRsGprPYCleQYl9lic5l/Mlxe4JGzSf9clEdqU
         3HwzFYiXw77k16U76BgO/s5z6w+Nez7v368xLdvQEn3hJmjhBIr+kDaOgpBO6qGX64pi
         wMr6JWXEX9OtcUTktQOKWf0VE0/jWWMzZ7qm7niH5Duc47G5Ouek2g+dbqvWmIc4kVzR
         N6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y7e3HusqoAMf8lrG+OWAU7meO/T/O/pS1B2DGDxN+tM=;
        b=FTpfwHzIkfuxSi59r5chA+b75W26IVuYt3kYP667HvIlvF81kRrW7w9qJzg0qHtPrA
         xVLhvEFG9iuAzS62q6XQKYUoTup6IoWjOJgRmA23jUEPc0rOAhrh4eMfNHepV+nSM5N3
         ow1owz7LMQbl0ZCpnLamxYpLbj3IG/shnKzGLnocPC0N+RRl8Bafl2ZvP2mlssHKhJyZ
         gA5oyuthdHTvCnsk9EXNF85W1SxxL9pooUC9EWx5cKYf09929/lBFb8ucKQSMEMOz+9h
         qfO3rajBFVQA9jiB9dA5Py0r7B90w0470FCBZp0z0dmHVL7p/Us/rSt7WZ6VLPhhWHtC
         hCXg==
X-Gm-Message-State: AOAM532sfBcczoBpXC5N+tAwdUpAGVd0IdozfeW3frNBPu2LhMmCO+Um
        DlP6n8d71DcvcX4SyU/tqutFIyMTD6LcRA==
X-Google-Smtp-Source: ABdhPJyTTb/E3Fm2eZEeT+PsW9pox2hFsCVYYM1Ady3D2qXwwKwzTSSb3YPP3kXsOCUp97BGVzh8rw==
X-Received: by 2002:aed:2ac5:: with SMTP id t63mr16496991qtd.245.1590158187578;
        Fri, 22 May 2020 07:36:27 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:b7f5:289f:a703:e466:2a27])
        by smtp.gmail.com with ESMTPSA id q54sm8227922qtj.38.2020.05.22.07.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 07:36:26 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 0AF7AC163B; Fri, 22 May 2020 11:36:24 -0300 (-03)
Date:   Fri, 22 May 2020 11:36:23 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Christoph Hellwig' <hch@lst.de>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: do a single memdup_user in sctp_setsockopt
Message-ID: <20200522143623.GA386664@localhost.localdomain>
References: <20200521174724.2635475-1-hch@lst.de>
 <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 08:02:09AM +0000, David Laight wrote:
> From: Christoph Hellwig
> > Sent: 21 May 2020 18:47
> > based on the review of Davids patch to do something similar I dusted off
> > the series I had started a few days ago to move the memdup_user or
> > copy_from_user from the inidividual sockopts into sctp_setsockopt,
> > which is done with one patch per option, so it might suit Marcelo's
> > taste a bit better.  I did not start any work on getsockopt.
> 
> I'm not sure that 49 patches is actually any easier to review.
> Most of the patches are just repetitions of the same change.
> If they were in different files it might be different.

It's subjective, yes, but we hardly have patches over 5k lines.
In the case here, as changing the functions also requires changing
their call later on the file, it helps to be able to check that is was
properly updated. Ditto for chained functions.

For example, I can spot things like this easier (from
[PATCH 26/49] sctp: pass a kernel pointer to sctp_setsockopt_auth_key)

@@ -3646,7 +3641,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
        }

 out:
-       kzfree(authkey);
        return ret;
 }
...
@@ -4771,7 +4765,10 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
        }

        release_sock(sk);
-       kfree(kopt);
+       if (optname == SCTP_AUTH_KEY)
+               kzfree(kopt);
+       else
+               kfree(kopt);

 out_nounlock:
        return retval;

these are 1k lines apart.

Yet, your implementation around this is better:

@@ -3733,7 +3624,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
        }

 out:
-       kzfree(authkey);
+       memset(authkey, 0, optlen);
        return ret;
 }

so that sctp_setsockopt() doesn't have to handle it specially.

What if you two work on a joint patchset for this? The proposals are
quite close. The differences around the setsockopt handling are
minimal already. It is basically variable naming, indentation and one
or another small change like:

From Christoph's to David's:
@@ -2249,11 +2248,11 @@ static int sctp_setsockopt_autoclose(struct sock *sk, u32 *autoclose,
                return -EOPNOTSUPP;
        if (optlen != sizeof(int))
                return -EINVAL;
-
-       if (*autoclose > net->sctp.max_autoclose)
+
+       sp->autoclose = *optval;
+
+       if (sp->autoclose > net->sctp.max_autoclose)
                sp->autoclose = net->sctp.max_autoclose;
-       else
-               sp->autoclose = *autoclose;

        return 0;
 }

> 
> If you try to do getsockopt() the same way it will be much
> more complicated - you have to know whether the called function
> did the copy_to_user() and then suppress it.

If it is not possible, then the setsockopt one already splited half of
the lines of the patch. :-)
