Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BCA6063DF
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiJTPKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiJTPKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:10:19 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD83DBE58
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 08:10:16 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id n130so3028946yba.10
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 08:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pxP+rdM/oYjqVi5iFPWwICgX+HbH0I69qg9sDr0K1LE=;
        b=KR6cpyzAxPl+7U3Py5QWHOEQQDLxxgZdiJldjiB0XC93zlWcM9n6YQOVPYPnw9oZ1Z
         GPPhCqBd+xNwTj3Ts+b8KiI8NuiklKCJcQXp4p0jocUfNLQ4dhAFNaFs940aUmZ3pt/T
         b3mEq4KGTdfqGAaA1Xa/BFKWKCA8siEtzt5CYoWkcPTEVtwffZr8qUJcRlRuXLlKqbul
         zd9H9aQg5UdGWrjZkBnnzw83O00AlZltUKaXbZBHJ6uLJlhprofGUMJfyR4UElLsDOcV
         I77+Nv5agtB+VHeOADIxrjy/vlBjcqbIvpGI2HXL1AOIB8l4//roECtSDFosB9T/I8L8
         JOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pxP+rdM/oYjqVi5iFPWwICgX+HbH0I69qg9sDr0K1LE=;
        b=ScY7e4yqi9sLNa4VM8Tb+yaSSY1dRuYXBjTFYrLRxj5DN5f22C6v1kjsysG7TEshAI
         qz1bnmnbX+GijKGlK3HlKaOJdZrhcDTvExcX+zpq2vmb+F9sghaPh9zHJKWuWZMiPx/y
         uKbFMo6DjCUEnRDDEFgv+bFLAz2D+CR3PT4eAVhw3j0CWZAtybV5f8SCr0v6435rDFjl
         VrLTPZaQp3Mw955IZf+wKVh8rIy/8vCCgTAE+f1/ntQjBkI+66ymcfMRHhi9iN9OUKTj
         Co6fHUcceLKvSCLoDX6b24fVnlML034KQ3z7t/z9JBl0vOh/Z6fpey4g122uazNuRYIL
         o12A==
X-Gm-Message-State: ACrzQf1EmrxkUifMnaNQ7NQq5O+3eGsojBDby5Y0b7g2PhTDi2FXP/0k
        ab6ujUxmoG6jhKJATUroD6D1SPhDsfal5h4/YD7z
X-Google-Smtp-Source: AMsMyM5Rs4oDq+vd5+gdAF1kNXM80oLU8Nh4dNPrK2chva8EHptH9aoAz5t5/3W+hZ2lZSpSV9E5RhiJ/YAMRGa1Bfk=
X-Received: by 2002:a05:6902:724:b0:6c0:1784:b6c7 with SMTP id
 l4-20020a056902072400b006c01784b6c7mr11826786ybt.15.1666278615883; Thu, 20
 Oct 2022 08:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <166543910984.474337.2779830480340611497.stgit@olly> <68decac7-f8f7-1569-be84-8419a0e78417@schaufler-ca.com>
In-Reply-To: <68decac7-f8f7-1569-be84-8419a0e78417@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 20 Oct 2022 11:10:03 -0400
Message-ID: <CAHC9VhQr_deuGRCien23zso+gi0VHUHK8ayYK6sBxmK3DyBOjg@mail.gmail.com>
Subject: Re: [PATCH] lsm: make security_socket_getpeersec_stream() sockptr_t safe
To:     Casey Schaufler <casey@schaufler-ca.com>,
        John Johansen <john.johansen@canonical.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 9:16 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 10/10/2022 2:58 PM, Paul Moore wrote:
> > Commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > sockptr_t argument") made it possible to call sk_getsockopt()
> > with both user and kernel address space buffers through the use of
> > the sockptr_t type.  Unfortunately at the time of conversion the
> > security_socket_getpeersec_stream() LSM hook was written to only
> > accept userspace buffers, and in a desire to avoid having to change
> > the LSM hook the commit author simply passed the sockptr_t's
> > userspace buffer pointer.  Since the only sk_getsockopt() callers
> > at the time of conversion which used kernel sockptr_t buffers did
> > not allow SO_PEERSEC, and hence the
> > security_socket_getpeersec_stream() hook, this was acceptable but
> > also very fragile as future changes presented the possibility of
> > silently passing kernel space pointers to the LSM hook.
> >
> > There are several ways to protect against this, including careful
> > code review of future commits, but since relying on code review to
> > catch bugs is a recipe for disaster and the upstream eBPF maintainer
> > is "strongly against defensive programming", this patch updates the
> > LSM hook, and all of the implementations to support sockptr_t and
> > safely handle both user and kernel space buffers.
> >
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
>
> Smack part looks ok, I haven't had the opportunity to test it.
> Will do so as I crunch through the backlog.
>
> Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Thanks Casey.

John, how do the AppArmor parts look?

> > ---
> >  include/linux/lsm_hook_defs.h |    2 +-
> >  include/linux/lsm_hooks.h     |    4 ++--
> >  include/linux/security.h      |   11 +++++++----
> >  net/core/sock.c               |    3 ++-
> >  security/apparmor/lsm.c       |   29 +++++++++++++----------------
> >  security/security.c           |    6 +++---
> >  security/selinux/hooks.c      |   13 ++++++-------
> >  security/smack/smack_lsm.c    |   19 ++++++++++---------
> >  8 files changed, 44 insertions(+), 43 deletions(-)

-- 
paul-moore.com
