Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8686261C1
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 20:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbiKKTKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 14:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiKKTKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 14:10:09 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936EF20F7A
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 11:10:08 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q71so5077269pgq.8
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 11:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WxW+88pap/KDAQ4oSQCUnoIRPKuK1fofMTupKZpmWNA=;
        b=ZDigcrLWd5YoWA1z48zOJx614KZu/U/36vrcZFZS/H7h5DpswcOh0abHQeWaGTXV4s
         vvOA+3f9nBxaHFrN30jtXQvBf5js9YFhP3FTB1X26j2sOh6/BPku7y0MMegQ8Y9P47rG
         dzlMx4HKcNvnktOkSc1gDtsKGYLhwnkyAgdrGOW8CeOoPfDGoXM1e5ybsX+sI2ku30wq
         eCjMjaB3/Ow2Uw8Zw4GuMqddkmmOUShBgNnuPEd2zgPYEh2j1XQ2UGsAeNS5yYicu3Zm
         +QP1ddRGAGJhFunR25AMAINCZelU3IQGqQV9dvGUbR/6Qn3jzqQEsKvIglhOU0/gbmzX
         6swg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WxW+88pap/KDAQ4oSQCUnoIRPKuK1fofMTupKZpmWNA=;
        b=59Zwh70S/5t1/0nmx1+0pfV0s8oI/udiV7i9BFlsUq+ZSz23zBXhgFRqGcAlNyi5/z
         WsfbYF18C4wmtEOmfLydA/+cMtUfoHSq1bSiWsnTs8sFzgw2R+f7yiE2yjMlni961o+c
         Fk2KRGbYhiualuOqTDfN8lTqfsfiUqXNY5DQZNVNGDhqz4aDZF80h3Tqc5RAPK6N5JNz
         3zI5S4QIAZs1PC64nrUY9a0hmeImolW8qPD+vrS0oL3EGN+Imhg5052YtlkX6Z1wVExG
         UtKMiUSsRXfJxSnUkhwbasTEXdQtG2HsrPSePi9lqotdDUo6nGjDq0D7hxyr1lRSQEnW
         rV2g==
X-Gm-Message-State: ANoB5pnP+9OoRMkFn066pB++NxHaWuXP6TdwNDAVSGjeotzXTNhMV5S2
        Cwp9Q5Punhnh6tQpQqjN3gunz9FLM6Vrmw==
X-Google-Smtp-Source: AA0mqf4Ro45GA5Z6JUNznptM7hh1iBIAZ9YI8UiWs9p1/Mt/TXvhLC3WxAajAMpDLd59Dcy4iaUb1A==
X-Received: by 2002:a63:510b:0:b0:46f:9c0c:8674 with SMTP id f11-20020a63510b000000b0046f9c0c8674mr2850405pgb.26.1668193808033;
        Fri, 11 Nov 2022 11:10:08 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id s11-20020a170902ea0b00b00178b77b7e71sm2065973plg.188.2022.11.11.11.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 11:10:07 -0800 (PST)
Date:   Fri, 11 Nov 2022 11:10:04 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     John Ousterhout <ouster@cs.stanford.edu>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: Upstream Homa?
Message-ID: <20221111111005.2f6b2117@hermes.local>
In-Reply-To: <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
        <20221110132540.44c9463c@hermes.local>
        <Y22IDLhefwvjRnGX@lunn.ch>
        <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Nov 2022 10:59:58 -0800
John Ousterhout <ouster@cs.stanford.edu> wrote:

> The netlink and 32-bit kernel issues are new for me; I've done some digging
> to learn more, but still have some questions.
> 
> * Is the intent that netlink replaces *all* uses of /proc and ioctl? Homa
> currently uses ioctls on sockets for I/O (its APIs aren't
> sockets-compatible). It looks like switching to netlink would double the
> number of system calls that have to be invoked, which would be unfortunate
> given Homa's goal of getting the lowest possible latency. It also looks
> like netlink might be awkward for dumping large volumes of kernel data to
> user space (potential for buffer overflow?).
> 
> * By "32 bit kernel problems" are you referring to the lack of atomic
> 64-bit operations and using the facilities of u64_stats_sync.h, or is there
> a more general issue with 64-bit operations?
> 
> -John-

I admit, haven't looked at Hama code. Are you using ioctl as a generic
way into kernel for operations?

Ioctl's on sockets are awkward API and have lots of issues.
The support of 32 bit app on 64 bit OS is one of them.
For that reason they are strongly discouraged.

Netlink allows multiple TLV options in single request and they should
be processed as transaction.  Netlink is intended for control operations.

If you need a new normal path operation, then either use an existing
system call (sendmsg/recvmsg) with new flags; or introduce a new system
call. Don't abuse ioctl as a way to avoid introducing new system call.
New system calls do add additional complexity to security modules, so
SELinux etc may need to know.

PS: please don't top post in replys to Linux mailing lists.
