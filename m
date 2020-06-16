Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8311FB527
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgFPO4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbgFPO4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:56:24 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F729C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:56:23 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d66so9624247pfd.6
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZnCI6Qv7+IJER3rGrCY9+2jrUGOKDGHwsURMSAUBf30=;
        b=2Nn79lSquFwICQJRqIMMK+xr/58INWQsjDmqryVedp1mYDiDc5HMvY4jcTvmMSb3F/
         qriu6QU67kEmAXX53ohM6mhtQonmUooyBbM/TamrrXJn8uXJggIukIfC9Fx3l9UjeHx/
         5p+IY9jdpnzEIE+PpYo6KzoHjY7Fmm4jcuuxkUF+8G+WDCnb1F0UC1jEuT+BML8EUdOs
         CXB0FqQQ4h9OEVrKvPxMBL0ewEc7aYAmeaJ6H7v7WE6jEUteFdgqnUuTV3UltIb+PzuD
         hE9afK0Xl6dGiYTI6af2ZTo5u3Ty4QZJP9dDTEPYlFDAwKTL/zKpxX9sd4k4W+M1zML+
         DcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZnCI6Qv7+IJER3rGrCY9+2jrUGOKDGHwsURMSAUBf30=;
        b=ETVOrrBVBXM/FmeslidQ1uSJuoUCIC8c+DuKPxFb6+4V2H8ENVBdoZqdwXLSPrCHSS
         kY4a6GoSCqcEJacJeCBaTvRVBQ86AZexeR/YXr2FY1b8wl2YFyhRvtiZI1l9ZYySt3wH
         XLuRNObvUKOS5hArIA0McKJAfnn+geC3A+/+ubxFlgcBJhJehvAL7S6QrsCrQg42BiLN
         pQiMcA5V2afXpbVP69eOXatf/4K6JWS08rLpFuK4+er6vqlQX/XF2p3Dh4+EDyh3iYUm
         N8TvESOc6E0H/AafNdy0rmvmfHMQGHcLKO4W+nQgYG7QjKx+DI6mtWZa168oj/L4+svp
         tLZA==
X-Gm-Message-State: AOAM5300H7pd1dojxaJNUJ1CgDgU90fhPlfuOxBzMBrWCIEcL3XasSDo
        YwvVg7EpMOIyFoL0nlSqLKu9UQ==
X-Google-Smtp-Source: ABdhPJzwtMfg9WuanFes0lWc4seh4QKWDBNW6g8QcQTednFNS4EGBck4rz2WMETIblhdcQl0IKQHaQ==
X-Received: by 2002:a63:1e60:: with SMTP id p32mr2352269pgm.172.1592319382567;
        Tue, 16 Jun 2020 07:56:22 -0700 (PDT)
Received: from cisco ([2001:420:c0c8:1007::16e])
        by smtp.gmail.com with ESMTPSA id p16sm14674640pgj.53.2020.06.16.07.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 07:56:21 -0700 (PDT)
Date:   Tue, 16 Jun 2020 08:56:14 -0600
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
Subject: Re: [PATCH v4 09/11] selftests/seccomp: Rename user_trap_syscall()
 to user_notif_syscall()
Message-ID: <20200616145614.GI2893648@cisco>
References: <20200616032524.460144-1-keescook@chromium.org>
 <20200616032524.460144-10-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616032524.460144-10-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 08:25:22PM -0700, Kees Cook wrote:
> The user_trap_syscall() helper creates a filter with
> SECCOMP_RET_USER_NOTIF. To avoid confusion with SECCOMP_RET_TRAP, rename
> the helper to user_notif_syscall().
> 
> Additionally fix a redundant "return" after XFAIL.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Tycho Andersen <tycho@tycho.ws>
