Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28416267D7
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 08:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbiKLHxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 02:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiKLHxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 02:53:50 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA70B55A4
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 23:53:47 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d9so4420563wrm.13
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 23:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VMzacoN6vjh7WbGaZ9Fu+CzW5whG2XJrlcSaFUOkTfs=;
        b=Vr/X3nBTBFZXGxJR2ZtOST8HBJJtfP3OPyKhLw0exZDW2rug0maAiNrRg17TDTZRlA
         6bo5RGjP28zcACvmwMCnGZTIdZhg+B23E/qNegsUmZDIbG/d1Uifq3I8GBGmLz0/ED79
         1uk3iqpkUWz2yZsq5eBDPVhHb2EMhnSUotK2Hvlc7QbJyjdeVNFlt1Ppl2vrbZUFoFXg
         dWNa/kMyE8VUDs8mg+9m2rL+r9r5xME1T9/8/0ZI5ayxYgzxT1cuH/Fej8+aWtDKM5d6
         Sn6azD91+xz1uLePkikzYjlb3QQU/sz3+y9wy8gv/a0rgz5SdwwBKCrgBauylEq04/GQ
         g71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VMzacoN6vjh7WbGaZ9Fu+CzW5whG2XJrlcSaFUOkTfs=;
        b=5EDxjxFZThmR7TUan05aa8iGkwbzBv4hJ54ioGlP+5gK7UxWsmiRl9Gez+MkfzzPFi
         sjmcQUS79GcVsudIGGj01P4G5p5vwNZA4tN7ZYwql4U22Bg4mM3cEvnT1FHybxE7cRRk
         2yu/vlDnJsg1A2U1y66NKZsHATL6vX+iefSI6rlTUfrWKUekuvrEhpmXK23a8exKu+5B
         GfNfDoHsb8eegMW5dNwB8Qm58fFF7OWoBP+jQnbQmH0lnuAicS6sjjzJvzKFXv/93vBp
         Uqmzz2O8k+iTHjCOF+oq3nIptSbddmc6nJ/XWrCfXvZ1Uv4Vvhe6ungaFCHoFQF3HaxW
         OKeQ==
X-Gm-Message-State: ANoB5pnlfmqNsgAI2fOYixsZZ27UmlpBfXU6HL736WTARdvfA5Hj82ki
        faOEt0PXJP+6cdXqrUaFzApPMi6ZMDTVt1VD
X-Google-Smtp-Source: AA0mqf7MrXsXbFVieHgTqIU9AI6pdfpA3c0rc2d08vYkrHMP99oFna8xtIv2rFs09XhjXaAGOPe+4A==
X-Received: by 2002:a5d:414d:0:b0:236:5e78:b1af with SMTP id c13-20020a5d414d000000b002365e78b1afmr2866755wrq.266.1668239626102;
        Fri, 11 Nov 2022 23:53:46 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c17-20020adffb11000000b002417f35767asm477783wrr.40.2022.11.11.23.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 23:53:45 -0800 (PST)
Date:   Sat, 12 Nov 2022 08:53:43 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     John Ousterhout <ouster@cs.stanford.edu>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: Upstream Homa?
Message-ID: <Y29RBxW69CtiML6I@nanopsycho>
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local>
 <Y22IDLhefwvjRnGX@lunn.ch>
 <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
 <Y26huGkf50zPPCmf@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y26huGkf50zPPCmf@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 11, 2022 at 08:25:44PM CET, andrew@lunn.ch wrote:
>On Fri, Nov 11, 2022 at 10:59:58AM -0800, John Ousterhout wrote:
>> The netlink and 32-bit kernel issues are new for me; I've done some digging to
>> learn more, but still have some questions.
>> 
>
>> * Is the intent that netlink replaces *all* uses of /proc and ioctl? Homa
>> currently uses ioctls on sockets for I/O (its APIs aren't sockets-compatible).

Why exactly it isn't sockets-comatible?


>> It looks like switching to netlink would double the number of system calls that
>> have to be invoked, which would be unfortunate given Homa's goal of getting the
>> lowest possible latency. It also looks like netlink might be awkward for
>> dumping large volumes of kernel data to user space (potential for buffer
>> overflow?).

Netlink is slow, you should use it for fast path. It is for
configuration and stats.


