Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7173A3A0585
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhFHVI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:08:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234052AbhFHVI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623186394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7qikh23JQj0rOROM36I+xJmZ0dRjFa9wyjTVsnQCQJc=;
        b=byYmKj0X7alJivGY5vHlB2skm5r5wWMHdkA3Xx2SBuPsXMy5Iue0gg6QdqMvuJ/gkBCMxw
        C1t4QuuWvrT/M17btZXFlO7gb4XolmK+AtFZLuf/e2IVaRCHn3D0rASHsKwdCRI9eg9CYD
        IFOVLr5eUHpVZ5+pKk12qa4iblCHDCE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-swR7tjqlOzqoJr05_Rf_Qg-1; Tue, 08 Jun 2021 17:06:32 -0400
X-MC-Unique: swR7tjqlOzqoJr05_Rf_Qg-1
Received: by mail-il1-f198.google.com with SMTP id y6-20020a92d0c60000b02901e82edc2af9so9272929ila.13
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 14:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7qikh23JQj0rOROM36I+xJmZ0dRjFa9wyjTVsnQCQJc=;
        b=Se2lGbnmITMtVFIN3uOzGDbssyb1Ej6JksYGeRYfYfetSwaMRFTJfiYYUJVtHcyJVM
         R5HfPNQwRP9apu4d+kAION9i699PzqF+CGqKOSKMWvkctipK4psR1mhpCp5zABircW9p
         UAMoQ+Qjvz+80UuBtW6vqF/24Ri0gIk/V0rKk55EnJRnPwBcYbasq0026lx0GzwR9lXh
         NIyT9oSSzgV0G++WH1E4LMlyw0ZHopoAy/OI5qFphnxBW6UnHZ9ahY+5+zknRVhYYwRB
         NeP1wpLub5teI7RIIN7OA8q2KfM3KtA+OeT+TApKnUd5b8VpyuTqvkAjVwji/2XoIhyX
         a6ng==
X-Gm-Message-State: AOAM533KWlNdetEgrnik0BXfXmlpoIS8hZwmj60Ec+YZ1yXdy7SMIY1i
        Aso5pYLYit8WXnDlCh8dTcOWoQJAcqmUw3JpwucTK3OZIeuYhPQEe41wsXsgvanzqh3PPqyf7O6
        U8T9csGcpLvRwFKqQ9/xLSQP4jidLl1lN
X-Received: by 2002:a92:c705:: with SMTP id a5mr20822430ilp.36.1623186391213;
        Tue, 08 Jun 2021 14:06:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPlJ3clujIQ13+n5JELKQhbjZ0YSViAsoCnIB1CIWy/ekJ0Gr0mf1G/mdwsIQlBaMZ/VjAhfKUDPJenEOXaXU=
X-Received: by 2002:a92:c705:: with SMTP id a5mr20822396ilp.36.1623186390733;
 Tue, 08 Jun 2021 14:06:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
 <6b4027c4-7c25-fa98-42bc-f5b3a55e1d5a@novek.ru>
In-Reply-To: <6b4027c4-7c25-fa98-42bc-f5b3a55e1d5a@novek.ru>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 8 Jun 2021 17:06:19 -0400
Message-ID: <CAK-6q+gm0C2t50myG=qNJMOOBnM7-UjfNMHK_cyPdWY5nSudHQ@mail.gmail.com>
Subject: Re: quic in-kernel implementation?
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, smfrench@gmail.com,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

On Tue, Jun 8, 2021 at 4:59 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> On 07.06.2021 16:25, Alexander Ahring Oder Aring wrote:
> > Hi,
> >
> > as I notice there exists several quic user space implementations, is
> > there any interest or process of doing an in-kernel implementation? I
> > am asking because I would like to try out quic with an in-kernel
> > application protocol like DLM. Besides DLM I've heard that the SMB
> > community is also interested into such implementation.
> >
> > - Alex
> >
>
> Hi!
> I'm working on test in-kernel implementation of quic. It's based on the
> kernel-tls work and uses the same ULP approach to setup connection
> configuration. It's mostly about offload crypto operations of short header
> to kernel and use user-space implementation to deal with any other types
> of packets. Hope to test it till the end of June with some help from
> Jakub.

Thanks, sounds interesting. Does this allow the kernel to create a quic socket?

- Alex

