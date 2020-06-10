Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADCC1F5C28
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 21:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgFJTph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 15:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729990AbgFJTpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 15:45:36 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5056C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 12:45:35 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 23so1547296pfw.10
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 12:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n0HyvUu4I8/Tk1QZlxgaik2t+t1oOltizttrT4rEXFQ=;
        b=T/bw5WnlXMhjbRkHFHu2+YA12ULZrzFF9wV+ez7jTxHqPfYHAmfIE6TnelBqB4jg30
         Jy+N0DSNfUbyG+VbQIy3OYzJhFzb6mRdLhRAQfgfhUo21aanTsUJ31Z6jJG0cIGs4uFo
         Y3a1qpTQ+syktszuJrAqIw3ZhZJsCh2qIPh0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n0HyvUu4I8/Tk1QZlxgaik2t+t1oOltizttrT4rEXFQ=;
        b=I43woShAG5BPkpNHHW3KqEK77VoSINcEQc9LNdXe09OWq1/0G2mFyMlPsNHJUZXZpy
         Tr/ARApQKgde0KS3FymPbJuf83gJqAI/P37pEh/hYQmwZoeq/zvhzGcsAXBdBXb31vPg
         RFEECZ6uR2ePiLQi+pJQ3Wnw44MIo1PDq3TEJt27yqCQ3z8rRDWTR7+bH0kO6qmtKv7Z
         WnVRUA+I5etmYVgr5pYZnsbB9VPV4wdeote+UQTi6/gFN7hFPiqOMQE5xQaY+waAonbz
         wQ7httRKiaae7+DGdCCaFhuMhXmfAyxGR+6lSxeG5AsmsRvrocjHZ2MyxqLdx4DOqcr1
         63Jw==
X-Gm-Message-State: AOAM5308QSA/qrkx8AyUe9cRH/mf3JlqVERWgSkL5/UgzaZaQTR4hEN0
        gKbay09rI6NgPubAE5HFWjSlow==
X-Google-Smtp-Source: ABdhPJxQazKAaDQdrS3kMhaPahisDHZnR720ERs2fv3PGWdFox4bysbcjyaTdO4nNWLofCje+hi9Cw==
X-Received: by 2002:a63:2216:: with SMTP id i22mr1705849pgi.31.1591818334976;
        Wed, 10 Jun 2020 12:45:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o20sm488717pjw.19.2020.06.10.12.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 12:45:34 -0700 (PDT)
Date:   Wed, 10 Jun 2020 12:45:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian@brauner.io>,
        Sargun Dhillon <sargun@sargun.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Use __scm_install_fd() more widely
Message-ID: <202006101245.DED83052@keescook>
References: <20200610045214.1175600-1-keescook@chromium.org>
 <20200610094735.7ewsvrfhhpioq5xe@wittgenstein>
 <202006101001.6738CA0@keescook>
 <20200610113800.5d7846ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610113800.5d7846ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 11:38:00AM -0700, Jakub Kicinski wrote:
> On Wed, 10 Jun 2020 10:03:03 -0700 Kees Cook wrote:
> > If 0-day doesn't kick anything back on this tree, I'll resend the
> > series...
> 
> Well, 0-day may find more, but I can already tell you that patch 1 has
> a checkpatch error:
> 
> ERROR: "(foo*)" should be "(foo *)"
> #149: FILE: net/core/scm.c:323:
> +		(__force struct cmsghdr __user*)msg->msg_control;
> 
> total: 1 errors, 0 warnings, 0 checks, 131 lines checked
> 
> And patch 2 makes W=1 builds unhappy:
> 
> net/core/scm.c:292: warning: Function parameter or member 'file' not described in '__scm_install_fd'
> net/core/scm.c:292: warning: Function parameter or member 'ufd' not described in '__scm_install_fd'
> net/core/scm.c:292: warning: Function parameter or member 'o_flags' not described in '__scm_install_fd'

Yeah, there are a few more problems too. I'll get it nailed down
hopefully this week and send a v2.

Thanks for looking at it!

-- 
Kees Cook
