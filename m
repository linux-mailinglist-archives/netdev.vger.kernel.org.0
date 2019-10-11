Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D5AD3661
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfJKAkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:40:49 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42689 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfJKAkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:40:49 -0400
Received: by mail-lj1-f193.google.com with SMTP id y23so8015975lje.9
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H2FS1xOZd/52wDxpWUrAmpLbVkhqrk6X7y4KWQdphOQ=;
        b=excfJ/xPWZ2+jilbteJY4Vi+c9HHFbmh8FkB0VkVQqsRNzfaN29He3nWLonU+RXfhK
         3pXMA0TLVwHppNQr0AUdUG53U42HF+9GxxpGlj/4kcIRtN2pAGAhjypJkZNwf6iE4U2K
         QnDU6KwbkTBSAhWjCsQuxo6Yvo3mAnUXyeDgSEkA6Cy+jFD7qJ0JXa3ufc+Z8Ubil/UN
         0Cdjgen9Fv8pItZNyHwfvmTyOXAjZeb7m1pS8EB6mZ+mIjfO5jq4nE77VYMmJNXOtxB7
         kvPLp8grvYwauQ5k1eqQDdg2eooaCdMYqVLWUpqPOHk/o0cD7moYJjQphs+tsLLeny72
         W+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H2FS1xOZd/52wDxpWUrAmpLbVkhqrk6X7y4KWQdphOQ=;
        b=ubQhBGYLPsgen37FrMFfxFINEfu5AefRaRxx056hfybLqBFa6xyeyfpdAW5NPW1LM+
         vJC55gXdrUyfI+bGkTPHCFnotrG2KpsotM4qYa/A64GnJ/mBjN7XmOw4T22LgzyPH2xq
         3DPrq/ZeDf2uWkhl3IGKhiuHeNErJBSQAQDgHsmHP/gzC3qar/Dt6OCCyHO6hmWF9B6m
         jFenDJZDE2MsLY3ys/W1ZQdA+NN2zFCYN/Mn6B6zxzbIg8p6GSh7bW12XPFQpHZ/3Uhw
         C7YlK2Qb5F0rt2tjScFn5TTEeI2Ln/ClnhWXm5UWnr+bBqImAR83JKUiPydHVnF6PGt3
         OY/Q==
X-Gm-Message-State: APjAAAURWD4Xdlhjlud0eXQwwJCb0F6Qgf3wC0E5yKFxSbqglsCig5XX
        lGiL4NXE3SzmfglfS0MQivNSmzm5clznaNv+apCh
X-Google-Smtp-Source: APXvYqxJgQInWarY5/M7kUO7HpwvMg1Nlpj/lgKKRdJtv+USUKJpyXPsrOQoku+hafT+CZ2zq5wB40bIA3VRiBrUbu8=
X-Received: by 2002:a2e:8ec2:: with SMTP id e2mr7129095ljl.126.1570754447449;
 Thu, 10 Oct 2019 17:40:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <ea4e8352fd1671f91d1b015a15abee785ea17136.1568834525.git.rgb@redhat.com>
In-Reply-To: <ea4e8352fd1671f91d1b015a15abee785ea17136.1568834525.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 10 Oct 2019 20:40:36 -0400
Message-ID: <CAHC9VhRUmHiuRH6xYZo36hoV34ouNv4Ny0sWZYcz2dnEhx9nsA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 16/21] audit: add support for contid set/get by netlink
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 9:26 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add the ability to get and set the audit container identifier using an
> audit netlink message using message types AUDIT_SET_CONTID 1023 and
> AUDIT_GET_CONTID 1022 in addition to using the proc filesystem.  The
> message format includes the data structure:
>
> struct audit_contid_status {
>        pid_t   pid;
>        u64     id;
> };
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/uapi/linux/audit.h |  2 ++
>  kernel/audit.c             | 40 ++++++++++++++++++++++++++++++++++++++++
>  kernel/audit.h             |  5 +++++
>  3 files changed, 47 insertions(+)

I'm not a fan of having multiple interfaces to do one thing if it can
be avoided.  Presumably the argument for the netlink API is the
container folks don't want to have to mount /proc inside containers
which are going to host nested orchestrators?  Can you reasonably run
a fully fledged orchestrator without a valid /proc?

--
paul moore
www.paul-moore.com
