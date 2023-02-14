Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B81169721F
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 00:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBNXwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 18:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjBNXwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 18:52:30 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C301A1
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 15:52:29 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-52f1b1d08c2so104280517b3.5
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 15:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qPP4S0pV1CwOTQskmSPPRG9e8lUDm4e0jDY94La2nfQ=;
        b=eixSXcCcU8sJoMqxrpQvpAOKaPV6A7fAOse5X0Vl1jC/ZNEhygI2J9LtE5hsleKQyd
         T52QYb8u2wnLt0cNhxEe4CkyKeUBalibgVy9sQLasua6WcJZbb9iaH9hIMNMpUfJe5fs
         2a5oDMFxvb6WrJBRWt5pYR4FtbOWRN5BR9/wqmTrOvz1v8GRD1ygzMrM9434xptRv4xI
         KYO4drVnmxFIBx9R4o8ISnGahaUuac56prYdqvPKptBfI1lSkVR17gnANKbX+p8XnOGT
         rx9S6QQZiQWP3LmoF/b8bnb5vJBo2II8ZIJ+C5j7ucoPYcXjTAijhXWe/eOkTgGSCEzK
         VdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qPP4S0pV1CwOTQskmSPPRG9e8lUDm4e0jDY94La2nfQ=;
        b=AYy7Ep5qe7sqpNMjJXmtE2k23fI+6b4R3J0G5ZscDKvjT+cMeGI+C3ZU098FAj6zTk
         TqaSUhRb+3W/ninKvQ+ed96PwTJknOMTI9z4OEAeN8Bm0XRkA2Y4UEbH2wRGj7x4h+WB
         +2bDuCWrJvEqdZC7a+E2ArBpy49410l1jVKdLmUoDJFS5Y7fOFckr6PVj4ANBny/xiLc
         NxGj69Vjsq/SSyZbZlHUiUKTodIi2DuOBJTgsbNWMl+8+WkDIOi/GfJ9jD4NJryTMRZy
         FWQsMf3X8+ptq4dfP/hojtm14Rq31KRJ39ubwk0+ALhSET7dtlQv3UZ26AgdmfNjMU/A
         +7OQ==
X-Gm-Message-State: AO0yUKUKtAI2N3NRnVwwjrW4COUizMd+YUvYxUo4Il6XzvtsveDhb4QW
        psVt224+PcSaNRKUzTuBVgZ6qJAn4slCOj/Y7InIROo4LKOJ3SC+
X-Google-Smtp-Source: AK7set9LNvjDI033u4ANNx9Wc5v2mJEBGvS09K9xEWvD6cEcbQaSBvp1ZZ4u/pKI4wL9h2Rgky/lo+0XHg9Ds//joBc=
X-Received: by 2002:a81:6cce:0:b0:52e:e3af:aaf7 with SMTP id
 h197-20020a816cce000000b0052ee3afaaf7mr35945ywc.270.1676418749090; Tue, 14
 Feb 2023 15:52:29 -0800 (PST)
MIME-Version: 1.0
References: <20230214134915.199004-1-jhs@mojatatu.com> <Y+uZ5LLX8HugO/5+@nanopsycho>
 <20230214134013.0ad390dd@kernel.org> <20230214134101.702e9cdf@kernel.org>
 <CAM0EoM=gOFgSufjrX=+Qwe6x9KN=PkBaDLBZqxeKDktCy=R=sw@mail.gmail.com> <20230214152203.6ba83960@kernel.org>
In-Reply-To: <20230214152203.6ba83960@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 14 Feb 2023 18:52:18 -0500
Message-ID: <CAM0EoMmcMWrLueyaEco6r+VDbgLDmLf7O=80a8Rd+AJo-ScQOQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and classifiers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, stephen@networkplumber.org, dsahern@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 6:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 14 Feb 2023 18:05:23 -0500 Jamal Hadi Salim wrote:
> > Looking at that code - the user is keeping their own copy of the uapi
> > and listening to generated events from the kernel.
>
> I searched the repo for TCA_TCINDEX_CLASSID - I don't see the local
> copy of the header. Can you point me?

Sorry, I was wrong, this tool's configure script pulls those headers
on the host from whatever kernel uapi path (eg on my debian machine :
/usr/src/linux/include ).
If it doesnt find the headers it wont generate the build in the
Makefile. So if at some point the uapi was deleted it just wont
compile code to listen to cbq, dsmark etc.
So it will work in either case (of deleting or keeping the uapi
around). It may be a bad sample space - but if we do keep the uapi,
how long would that be for?

cheers,
jamal
