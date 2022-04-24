Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED4550D07D
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 10:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbiDXIgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 04:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238611AbiDXIga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 04:36:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBCD289B0
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 01:33:30 -0700 (PDT)
Date:   Sun, 24 Apr 2022 10:33:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650789207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/5MieZDkZ8rawPln03hLo7U8+3a6+Po77m5e67NId2k=;
        b=utccX4QApFmSC6S4lCSUgRojI8bOaVSDWQ662gCK209YYfErNqWE2Ner8GtlGkOcamcfLn
        T0DTGa5fExST92WPZ19/Zn+vGPt1+/LEWtrU3FpHDUgkAYkSEvyjilDVDBgSDteOTHKdIw
        1ZzhFkVvpxCBLUDD1ke8IUc07j+4cLKcrZhwL368ihNpgPmbUprRYWn0VkhGMuGXsiStUC
        npszDN2ERFElgyo/UipNSeNeL/IxsSqO45NYeemg5vQbsDRE5hf7jfOv95g61v7e65rYLZ
        Ss1FPXW/BBmCkKvVVd/tGM5PKM6zIuUQDkMUH7GJCSPIfJ8uTrJEpGM8DU67Jg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650789207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/5MieZDkZ8rawPln03hLo7U8+3a6+Po77m5e67NId2k=;
        b=hByTjZ4cJyRH58dsWtd1IjhxpqoZYBkuk8miNRqbLSfa3grXE2vTS2U36S9hoXzh99mj2y
        8QlHwdgRRl6aa3Bg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net] net: Use this_cpu_inc() to increment net->core_stats
Message-ID: <YmULVVNRLrvW38zT@linutronix.de>
References: <YmFjdOp+R5gVGZ7p@linutronix.de>
 <CANn89iKjSmnTSzzHdnP-HEYMajrz+MOrjFooaMFop4Vo43kLdg@mail.gmail.com>
 <YmGLkz+dIBb5JjFF@linutronix.de>
 <20220423092439.GY2731@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220423092439.GY2731@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-23 11:24:39 [+0200], Peter Zijlstra wrote:
> Eric is right. READ_ONCE() is 'required' to ensure the compiler doesn't
> split the load and KCSAN konws about these things.

So we should update the documentation and make sure that is done
tree-wide with the remote per-CPU access.
I will update that patch accordingly and add the other thing to my todo
list.

Sebastian
