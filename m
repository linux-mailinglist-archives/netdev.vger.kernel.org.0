Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0923A06EF
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 00:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFHWgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 18:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhFHWgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 18:36:09 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3A6C061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 15:33:58 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c13so11515844plz.0
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 15:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mxRqjs0kWAV8d5/8DGxZ+Wcw0XYiesjOQ1RKA/CGQGw=;
        b=RVeVFXZ/7X8SIagOorHGY0ZqE9VqdwQjcTdONY5B6RgOYMf26cSPv6RRcVku68hND1
         e/Q9uc+lCR6p6mUkEnkvJerjatKgImUB39lpoLvChPaq8N4mttvR/SxnG8abL/nQrLJL
         wvTenLHHSlQdV+1CaH0r9CxJ9onWNrd4/K5wPhNVevZZ+HnYWlXdQTMwaG/8+Kh49qCG
         o7xjmrOUfm0qitkRy4V6BhsDKZEiI9msIi26LB4GL0kwNVQjiQu/sMzcVNtgekP/HIBI
         YLVMxqMoLrnqbpzMSYL5KCpZCaTP3K2CrVO89f0koEvAlukBgGM615X5HjGHj8kaiTCT
         Wy0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mxRqjs0kWAV8d5/8DGxZ+Wcw0XYiesjOQ1RKA/CGQGw=;
        b=hCbCP7MaqEWxoTflBneAT/3h71McAjukXIYO7v9+BNoS7qido8+5o+XaoBRKbh4raO
         iMnH/TbYnAaILSSqPAvHdzIFZyPZYpaHywU9nwq6X6npByo29pPz315fKh3ABY8aUyLf
         /sni+4avXrL9sbnsE2xJL6E6FQpBTh8GZy0KlfK8SONxXmwz0hJzpw0xErCOYhEumW4m
         TAEYe5U3u9osubEcfgN//WLJcvFTRwyV1quovZ4Ne+2QzYTsFAintThHrtyqN5EdJQh4
         GafAAowxbKIS3HYzjCdNKekdEJmdWTyYWnxURtoIig1iBf8bDXElhQCESLJY9Mv0Z5Yf
         j8nw==
X-Gm-Message-State: AOAM531fc4ThyqvV3ZQxjEm7UWoORO5Ewv+CeGjy4rmuj4hSnsByVI8H
        c1xeRfVQ1NEat1FOEFucAD+7Qw==
X-Google-Smtp-Source: ABdhPJwqBL12sg0BApJh90/sdHc4bkJNdticyc6nbP9qs3SX6TgBSnUG3+xZMiFMeR/KKj6xWxUp3g==
X-Received: by 2002:a17:90a:8581:: with SMTP id m1mr28547951pjn.47.1623191637974;
        Tue, 08 Jun 2021 15:33:57 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id fy16sm3130338pjb.49.2021.06.08.15.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 15:33:57 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:33:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: quic in-kernel implementation?
Message-ID: <20210608153349.0f02ba71@hermes.local>
In-Reply-To: <CAK-6q+g3_9g++wQGbhzBhk2cp=0fb3aVL9GoAoYNPq6M4QnCdQ@mail.gmail.com>
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
        <87pmwxsjxm.fsf@suse.com>
        <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
        <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
        <CAK-6q+g3_9g++wQGbhzBhk2cp=0fb3aVL9GoAoYNPq6M4QnCdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Jun 2021 17:03:16 -0400
Alexander Aring <aahringo@redhat.com> wrote:

> Hi,
> 
> On Tue, Jun 8, 2021 at 3:36 AM Stefan Metzmacher <metze@samba.org> wrote:
> ...
> >  
> > > 2) then switch focus to porting a smaller C userspace implementation of
> > > QUIC to Linux (probably not msquic since it is larger and doesn't
> > > follow kernel style)
> > > to kernel in fs/cifs  (since currently SMB3.1.1 is the only protocol
> > > that uses QUIC,
> > > and the Windows server target is quite stable and can be used to test against)> 3) use the userspace upcall example from step 1 for
> > > comparison/testing/debugging etc.
> > > since we know the userspace version is stable  
> >
> > With having the fuse-like socket before it should be trivial to switch
> > between the implementations.  
> 
> So a good starting point would be to have such a "fuse-like socket"
> component? What about having a simple example for that at first
> without having quic involved. The kernel calls some POSIX-like socket
> interface which triggers a communication to a user space application.
> This user space application will then map everything to a user space
> generated socket. This would be a map from socket struct
> "proto/proto_ops" to user space and vice versa. The kernel application
> probably can use the kernel_FOO() (e.g. kernel_recvmsg()) socket api
> directly then. Exactly like "fuse" as you mentioned just for sockets.
> 
> I think two veth interfaces can help to test something like that,
> either with a "fuse-like socket" on the other end or an user space
> application. Just doing a ping-pong example.
> 
> Afterwards we can look at how to replace the user generated socket
> application with any $LIBQUIC e.g. msquic implementation as second
> step.
> 
> - Alex
> 

Socket state management is complex and timers etc in userspace are hard.
