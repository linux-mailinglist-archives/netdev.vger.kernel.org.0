Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B95610E85
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiJ1Kcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJ1Kcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:32:52 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D414186D46
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:32:51 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id i7so5721889oif.4
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zB8BAjJNdwvTu1TcMbykSWmAi2sqHFEWOgWMfTdEcWA=;
        b=X2HCkC5CyaP5zbFrnTUERJo1tEWaZ4MLjrQp0taS9/rdmg/YsFWLiyOAPew2nGhfDI
         s9sLyh3ULpYF466ZA8mqHo0zVQhVBfDHUn1zAyZE/EGtq4BGJ5GNvX9L0izYpb0IXINO
         TYhsL1LQwH4/0hELQdWp8kP22s/Pm3MYphUQbrewNoRi2MTc5zquau2aj22wy0keqW8t
         jddFSDk89D+WrTTZAgE/c9+gEyQhY3gFuABNa6gg24NRAt3dr9FHpUhOhSrMxf52rTlB
         ZyNpjfs+XCE5hZys2GS18YVW2k6XtdhGb9AH2YbUrr5jdegxD8qZJybe0zB8satz0/a5
         M9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zB8BAjJNdwvTu1TcMbykSWmAi2sqHFEWOgWMfTdEcWA=;
        b=uuQns2AR4NnUUQtlvwgC5blXXlY/rYPsB9bLqK7n0tpaXFkcliLEHeFu36nuTwAjRJ
         fuqfxwit7U47WD5RZ9ts3nckp2WwyqAt+jr8YcPCuUHw+okWGL3VHX83UhiIdmhcBXXW
         GiHX2nERoXZHWlFAqKMDY9mzevDj5lhmOyW18eLvepocYZ/JiFZzw1C0NgXT1ZDVyV/Y
         6sDBnFYcX8P5EoTF7FgwuwdIEPcpM0GyIEd9CCIUpGV9kwbQepbNLbKraz/BSNyaVjRd
         uD3Q0jHjsYPA0jRH6RlpADll6IdkZWJUpM+8yFGH/G+pwf6DJ7DA0bvIEc89TbQsE8xf
         QECw==
X-Gm-Message-State: ACrzQf0wTqfsXQEyyHKgCjACVHhCP2cmpjAgXpHxmsyKoZgmo6Ta7HKt
        eFGrX5rJc+RFwNy+GOT9Hb0oWy2thzsQUsX2UfFW
X-Google-Smtp-Source: AMsMyM6V45ZpBGZWipqqDVudaxbgprbN3/vC+HFmh83dfK84+Th7N8dB4dGTrIsHS1LoKX99fGVcxnfTQy83ANQ81k8=
X-Received: by 2002:aca:2404:0:b0:355:53ab:16d5 with SMTP id
 n4-20020aca2404000000b0035553ab16d5mr7874980oic.51.1666953170654; Fri, 28 Oct
 2022 03:32:50 -0700 (PDT)
MIME-Version: 1.0
References: <166543910984.474337.2779830480340611497.stgit@olly>
 <68decac7-f8f7-1569-be84-8419a0e78417@schaufler-ca.com> <CAHC9VhQr_deuGRCien23zso+gi0VHUHK8ayYK6sBxmK3DyBOjg@mail.gmail.com>
In-Reply-To: <CAHC9VhQr_deuGRCien23zso+gi0VHUHK8ayYK6sBxmK3DyBOjg@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 28 Oct 2022 06:32:39 -0400
Message-ID: <CAHC9VhQfEX_cADrLC_gV5EhndtrANvbNpTfGVzkq7uqr7XReWw@mail.gmail.com>
Subject: Re: [PATCH] lsm: make security_socket_getpeersec_stream() sockptr_t safe
To:     John Johansen <john.johansen@canonical.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 11:10 AM Paul Moore <paul@paul-moore.com> wrote:
> On Thu, Oct 20, 2022 at 9:16 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
> > On 10/10/2022 2:58 PM, Paul Moore wrote:
> > > Commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > > sockptr_t argument") made it possible to call sk_getsockopt()
> > > with both user and kernel address space buffers through the use of
> > > the sockptr_t type.  Unfortunately at the time of conversion the
> > > security_socket_getpeersec_stream() LSM hook was written to only
> > > accept userspace buffers, and in a desire to avoid having to change
> > > the LSM hook the commit author simply passed the sockptr_t's
> > > userspace buffer pointer.  Since the only sk_getsockopt() callers
> > > at the time of conversion which used kernel sockptr_t buffers did
> > > not allow SO_PEERSEC, and hence the
> > > security_socket_getpeersec_stream() hook, this was acceptable but
> > > also very fragile as future changes presented the possibility of
> > > silently passing kernel space pointers to the LSM hook.
> > >
> > > There are several ways to protect against this, including careful
> > > code review of future commits, but since relying on code review to
> > > catch bugs is a recipe for disaster and the upstream eBPF maintainer
> > > is "strongly against defensive programming", this patch updates the
> > > LSM hook, and all of the implementations to support sockptr_t and
> > > safely handle both user and kernel space buffers.
> > >
> > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> >
> > Smack part looks ok, I haven't had the opportunity to test it.
> > Will do so as I crunch through the backlog.
> >
> > Acked-by: Casey Schaufler <casey@schaufler-ca.com>
>
> Thanks Casey.
>
> John, how do the AppArmor parts look?

Hey John - can you weigh in on the AppArmor bits?

> > > ---
> > >  include/linux/lsm_hook_defs.h |    2 +-
> > >  include/linux/lsm_hooks.h     |    4 ++--
> > >  include/linux/security.h      |   11 +++++++----
> > >  net/core/sock.c               |    3 ++-
> > >  security/apparmor/lsm.c       |   29 +++++++++++++----------------
> > >  security/security.c           |    6 +++---
> > >  security/selinux/hooks.c      |   13 ++++++-------
> > >  security/smack/smack_lsm.c    |   19 ++++++++++---------
> > >  8 files changed, 44 insertions(+), 43 deletions(-)

-- 
paul-moore.com
