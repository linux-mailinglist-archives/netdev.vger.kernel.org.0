Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7663ABF27
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhFQXFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:05:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36359 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhFQXFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 19:05:43 -0400
Received: from mail-oo1-f71.google.com ([209.85.161.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <seth.forshee@canonical.com>)
        id 1lu12q-00076z-5Q
        for netdev@vger.kernel.org; Thu, 17 Jun 2021 23:03:32 +0000
Received: by mail-oo1-f71.google.com with SMTP id l13-20020a4aa78d0000b0290245c8f11ac2so4718724oom.11
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 16:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OkOjqJxD0z2koDXpHJI7UZUHHI+CEV8nA90EeoMOpKs=;
        b=qyhLVGSEc+NMTmoJ0+vGdi93wh5WL7I2X5nV0hNTRl0UkBuPXrV1Lh/aglfAZ+FVd/
         u1KjPzbwii24iK5bb9WV+mnjp0qZJOac8B/7kwbals8OMUIHH8bcfq4c3thlLOOstIXV
         9LGe8ED+mTv6j1bvfj1R0E6vmV0O2sbxQ2Em/zdHscv1gbqQq8oQ/u5LjEWlvoznWXe7
         iLOMbzs6pHPuII9dlurrdCV4w+tPtUW2NBrX6oExyJbc2/PLk329YWrIpKpdbHNy50/+
         h6e64qGWhFn+dUX76Yxpta9V3eo6+/mVrWwN9Xb/AJNB6+RGPwF+ncuNlZ30JUEINoTB
         Pd1w==
X-Gm-Message-State: AOAM530Y5CKmnlqyto8JAkTr4WIjsU8OUW3hsSSCQcktxoQuy4GWZ8y2
        OKKey5jOaLY3uWGJFraJWULlW3Ythx7SrZkeUBCR5mcRqA5apKBsF83P+RcSr1O7GNNEVUJaWdh
        etbRaYsJHOOC0sqQM+Xwl0CWJXNfiywdRhA==
X-Received: by 2002:aca:af42:: with SMTP id y63mr12370933oie.119.1623971011202;
        Thu, 17 Jun 2021 16:03:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDiTg+Y4j0hQ3bdU6IkDKIwKk8ZbqFkka3mLb3akP9nl6lPOsoFHzTgBPK77GK8cl7ZiURTQ==
X-Received: by 2002:aca:af42:: with SMTP id y63mr12370920oie.119.1623971010978;
        Thu, 17 Jun 2021 16:03:30 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:8210:d9c3:c7eb:5ca4])
        by smtp.gmail.com with ESMTPSA id w22sm1231956oou.36.2021.06.17.16.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 16:03:30 -0700 (PDT)
Date:   Thu, 17 Jun 2021 18:03:29 -0500
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Josh Tway <josh.tway@stackpath.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: Hangs during tls multi_chunk_sendfile selftest
Message-ID: <YMvUwVcOSkuBDxdg@ubuntu-x1>
References: <YMumgy19CXCk5rZD@ubuntu-x1>
 <20210617142234.272cc686@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617142234.272cc686@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 02:22:34PM -0700, Jakub Kicinski wrote:
> On Thu, 17 Jun 2021 14:46:11 -0500 Seth Forshee wrote:
> > I've observed that the tls multi_chunk_sendfile selftest hangs during
> > recv() and ultimately times out, and it seems to have done so even when
> > the test was first introduced. 
> 
> It hangs yet it passes? I lost track of this issue because the test
> does pass on my system:
> 
> # PASSED: 183 / 183 tests passed.
> # Totals: pass:183 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> $ uname -r
> 5.12.9-300.fc34.x86_64

It doesn't pass with Ubuntu kernels:

 #  RUN           tls.12_gcm.multi_chunk_sendfile ...
 # multi_chunk_sendfile: Test terminated by timeout
 #          FAIL  tls.12_gcm.multi_chunk_sendfile
 not ok 6 tls.12_gcm.multi_chunk_sendfile
 ...
 #  RUN           tls.13_gcm.multi_chunk_sendfile ...
 # multi_chunk_sendfile: Test terminated by timeout
 #          FAIL  tls.13_gcm.multi_chunk_sendfile
 not ok 51 tls.13_gcm.multi_chunk_sendfile
 ...
 #  RUN           tls.12_chacha.multi_chunk_sendfile ...
 # multi_chunk_sendfile: Test terminated by timeout
 #          FAIL  tls.12_chacha.multi_chunk_sendfile
 not ok 96 tls.12_chacha.multi_chunk_sendfile
 ...
 #  RUN           tls.13_chacha.multi_chunk_sendfile ...
 # multi_chunk_sendfile: Test terminated by timeout
 #          FAIL  tls.13_chacha.multi_chunk_sendfile
 not ok 141 tls.13_chacha.multi_chunk_sendfile
 ...
 # FAILED: 177 / 183 tests passed.
 # Totals: pass:177 fail:6 xfail:0 xpass:0 skip:0 error:0

 $ uname -r
 5.13.0-7-generic

The results are the same with 5.12, etc. Maybe some difference in
configs.

> > Reading through the commit message when
> > it was added (0e6fbe39bdf7 "net/tls(TLS_SW): Add selftest for 'chunked'
> > sendfile test") I get the impression that the test is meant to
> > demonstrate a problem with ktls, but there's no indication that the
> > problem has been fixed.
> 
> Yeah, the fix was discussed here:
> 
> https://lore.kernel.org/netdev/1591392508-14592-1-git-send-email-pooja.trivedi@stackpath.com/
> 
> IDK why it stalled to be honest :S

Hopefully it can make some progress now.

Thanks,
Seth
