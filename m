Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5D21FB537
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgFPO5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729005AbgFPO5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:57:34 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F324C06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:57:34 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id b5so8373632pgm.8
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yyBDmoMJVCXVgLjKdOMGSUnOzeYRsY+K7W79k+Q31OU=;
        b=nIM3/IuiUKoFugU/l8Ba4esFLefiqTfBP651OEc9hms/rvYeU1qfGFF1kElz8uQe73
         btGGtVNjLiDhNMb7zEFCQLFxb9OPOVYIYKYW0DRe1furc2JFYn9tihuMN4IMj1d+Ka7l
         qB/b8ooTRMqgRtct2H67YtBcQPpNc2FNAyKwtAfKjQEPyNhIjh/VfVjwIHCwUYGpyuK3
         8I4OnQnJKp2BvAN4IThih3qCQCy8onYBAmI0+v/MyhJD1956KsG7pGa35AAxNjidA/Uz
         l5vEcerzy3hx1Xxk1EwOFM8VW54IEQUm28kJR6qnTpaqnQ8qsR7lwjjWo2JjSOxb30+4
         j7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yyBDmoMJVCXVgLjKdOMGSUnOzeYRsY+K7W79k+Q31OU=;
        b=o9nO6UIQ9n7CTZjefV+EOF/NT2vOPV1sew6QNAaKkpbW98rmtdpMS/RFmp2ERcukzf
         vL1h3xn9EjCtVKHUXW3aGB9IWTfzFQBnxIZspGSYdYKSt9SgbeB2IPtGeit+W8Hdb39r
         uaGiegsr4v46EZ1eFISfq/W1UYGb2tjUlwr+seGRdvV/bSpYnZnS36wKZVHbxJzwNB7t
         obEIhNxvWvSUmkfge7XQ1HFBWz+km3JD4/XcbLDdcGgz2cwHtX3r7haIpJ1Y59br7BO0
         JVvqn7onAodhRmXAuOB0O6Pof2k4FP+RxX5OsSsOYs955c51DwsCn3fV/5g4kIWU3ITO
         VUAA==
X-Gm-Message-State: AOAM532/s0AGQlziqeYxUDpxC4tswLk49wW/WTgCFojiPnqW9zm3Nz7m
        XnU3N1JOVTBWMFq+7y0/+xmkMw==
X-Google-Smtp-Source: ABdhPJyE8JhFShIC0P56tbNPmidfh2M1XS9DwI25mItrIXnidVWIBUOx6dRBg1QaUnua2nPobiBVoQ==
X-Received: by 2002:a63:e008:: with SMTP id e8mr2348053pgh.451.1592319453558;
        Tue, 16 Jun 2020 07:57:33 -0700 (PDT)
Received: from cisco ([2001:420:c0c8:1007::16e])
        by smtp.gmail.com with ESMTPSA id x17sm2893286pjr.29.2020.06.16.07.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 07:57:32 -0700 (PDT)
Date:   Tue, 16 Jun 2020 08:57:25 -0600
From:   Tycho Andersen <tycho@tycho.ws>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 08/11] selftests/seccomp: Make kcmp() less required
Message-ID: <20200616145725.GJ2893648@cisco>
References: <20200616032524.460144-1-keescook@chromium.org>
 <20200616032524.460144-9-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616032524.460144-9-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 08:25:21PM -0700, Kees Cook wrote:
> The seccomp tests are a bit noisy without CONFIG_CHECKPOINT_RESTORE (due
> to missing the kcmp() syscall). The seccomp tests are more accurate with
> kcmp(), but it's not strictly required. Refactor the tests to use
> alternatives (comparing fd numbers), and provide a central test for
> kcmp() so there is a single XFAIL instead of many. Continue to produce
> warnings for the other tests, though.
> 
> Additionally adds some more bad flag EINVAL tests to the addfd selftest.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

This looks fine, but I wonder if this is enough motivation for taking
kcmp() out of CONFIG_CHECKPOINT_RESTORE guards?

Tycho
