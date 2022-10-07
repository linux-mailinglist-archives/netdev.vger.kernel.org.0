Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130695F7E78
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 22:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJGUGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 16:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJGUGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 16:06:38 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBC212C888
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 13:06:37 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id t79so6790027oie.0
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 13:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+dI2GSeqJYUU8VZ2aKJL6k9zynx9se5XfKL22XwWowQ=;
        b=al0ABjNWkFFZAh7iQ4L27x4qGsHRY0vNnMx0RJ0qN7QLOJrjICk5plnwFDzomAenib
         w2NoC7ztKpZTt6kVy+SPD089/391rVSLfXEsP95Gol5Mii4jBcV0rIpdzzvcHUpMYkuF
         Cj8be0CrNRimDCNuBnxiHidP6QvyDEoBzCHjDGvGWaqiViNmgoIIiJiB/fnWplZckxd1
         NvKfMOG2rYmjQCvsb1WZvl9R+hIifk+jf7BDbnrDNh6ZjCJG01aDoaMFA8+Lsl3c4s5W
         8+JJGay00lsQpb99mzWFTNQ/j20fR0ZH2eFPZaC6xx5TZjBI9qSh1Dmrh6Lw56GPP0Nr
         WlAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+dI2GSeqJYUU8VZ2aKJL6k9zynx9se5XfKL22XwWowQ=;
        b=mFrrjDbKuEchFUs/C0ukz8nZVFRKDMNYe5feUa8IIU4kX6KSy6VUVxIrJbS/hi0Xv1
         EWWbBNuBUcw301SX0QIJdHqGNFlT7Cp7swLpoIpQanqU1KOywegvDatJK5J7qix/kdSG
         3YWQDqjX5YzJICqnkcKQlBJNeCodEY+v42hoBXVTD+5g0QPfzIFyjVexE3+/XE05/h9K
         cUmAKUwv+PNxdYMo5PtzulYKJY9dw3zOjy0CHnOYXUqm7watvduvzhkqDISS6lZJqsLj
         jk6pcKLGZtxM8HhmPN7fvoku2ePM0fSmOqZTQTq8HmApJk71KsaeSwm0lefrGY6Sa9LR
         S2AQ==
X-Gm-Message-State: ACrzQf3XF96+Vukfa3/+NBo9Eu5LsA1rJJ5kLs6KZYOjWeYjGtpcze/K
        hdowv+9RTqaAKcUMac4fIU/7HQHmSY4FE8uq4REz5UbZitf4
X-Google-Smtp-Source: AMsMyM5+hZXoD89CtXWSq9MM4P/HTzsoEJT6rYk6E9rOboipkwS81po7VkITOIbCVyDQtYZ3TPTfsffkeQ7NIK83yYM=
X-Received: by 2002:a05:6808:144b:b0:350:a06a:f8cb with SMTP id
 x11-20020a056808144b00b00350a06af8cbmr8631307oiv.51.1665173196437; Fri, 07
 Oct 2022 13:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
 <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com> <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com>
In-Reply-To: <CAADnVQ+kRCfKn6MCvfYGhpHF0fUWBU-qJqvM=1YPfj02jM9zKw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 7 Oct 2022 16:06:25 -0400
Message-ID: <CAHC9VhRcr03ZCURFi=EJyPvB3sgi44_aC5ixazC43Zs2bNJiDw@mail.gmail.com>
Subject: Re: SO_PEERSEC protections in sk_getsockopt()?
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 7, 2022 at 3:13 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Fri, Oct 7, 2022 at 10:43 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Wed, Oct 5, 2022 at 4:44 PM Paul Moore <paul@paul-moore.com> wrote:
> > >
> > > Hi Martin,
> > >
> > > In commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> > > sockptr_t argument") I see you wrapped the getsockopt value/len
> > > pointers with sockptr_t and in the SO_PEERSEC case you pass the
> > > sockptr_t:user field to avoid having to update the LSM hook and
> > > implementations.  I think that's fine, especially as you note that
> > > eBPF does not support fetching the SO_PEERSEC information, but I think
> > > it would be good to harden this case to prevent someone from calling
> > > sk_getsockopt(SO_PEERSEC) with kernel pointers.  What do you think of
> > > something like this?
> > >
> > >   static int sk_getsockopt(...)
> > >   {
> > >     /* ... */
> > >     case SO_PEERSEC:
> > >       if (optval.is_kernel || optlen.is_kernel)
> > >         return -EINVAL;
> > >       return security_socket_getpeersec_stream(...);
> > >     /* ... */
> > >   }
> >
> > Any thoughts on this Martin, Alexei?  It would be nice to see this
> > fixed soon ...
>
> 'fixed' ?
> I don't see any bug.
> Maybe WARN_ON_ONCE can be added as a precaution, but also dubious value.

Prior to the change it was impossible to call
sock_getsockopt(SO_PEERSEC) with a kernel address space pointer, now
with 4ff09db1b79b is it possible to call sk_getsockopt(SO_PEERSEC)
with a kernel address space pointer and cause problems.  Perhaps there
are no callers in the kernel that do such a thing at the moment, but
it seems like an easy mistake for someone to make, and the code to
catch it is both trivial and out of any critical path.

This is one of those cases where preventing a future problem is easy,
I think it would be foolish of us to ignore it.

--
paul-moore.com
