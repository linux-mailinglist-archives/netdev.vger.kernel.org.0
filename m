Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214781E510C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgE0WNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 18:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgE0WNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 18:13:44 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F857C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 15:13:44 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w20so7429573pga.6
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 15:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5L31n6G+HPP9UVMb7LRpqeGMC0d+YoBfg78esCxkPLQ=;
        b=TkonPVS1Rloqbi1Lj/MKDN5UkQvdffNjyAvxoT4qiYUwqlOkmTTgfZHMHkffMOecl1
         TD9vvI3bbjqot2/lEt0GNvdmXmWD4j5HvprnF7pc/EPST4eLCws7ROHqpPo4HoDV4b26
         7kVB2KCK39Dz3cFktgl+VpdEM2V6TUKosmURSlP4F7bWZobiaEjA2dfgU+ZxFJ856RXM
         OybMXNGzPKQ/KDL6cK3wFIrQMG6HuGZE8ySMelrTiJOq37YRBlK8ZBvo5U57popyi3AB
         wApAiMfdLdPvSB0ketjAgtqJCresmLmxUXHijmAHgeXo+NmYQme3C9NHpXa4s9DJuFeo
         yMOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5L31n6G+HPP9UVMb7LRpqeGMC0d+YoBfg78esCxkPLQ=;
        b=oLSkbZQTLDcAUgTYNQ6CX6mKYSwL1QlIbXgxSFbaP1avGKk2X7zX9T5owwOKmxZrIH
         4JOfmdjRmM1N6LbGFAl/8zpiM72rRCqglG+FlU/rG0C8ofbVpZWPl8h6NCwsFRcp1pOA
         v0OrCdqaC9DhH7Jg8S3VTxaJEWf7qm/+wbFxmDvpFd9tGZpLAivY0BsOBmoXRX6IIHAS
         d16ys72v7YO03WQVDENuAwZo61diQLT7BkwHSwnbcLYJAmjLS0oAi5ZuuqVuv+Gx9hp3
         0TyJyTJ/qaVnhU9WIgxMH8QTVQWc39Wvu/uf00fB5Pv95Bz3xy8naRnm8b7qVWP6XQ4s
         Fm5w==
X-Gm-Message-State: AOAM530fuLKg0L5Qc+qrxM5NQCHX80hEgMeXGfH/mRtL79X8ScUxy/kg
        rqcbnkFpKXK3Hl4RcYXtcCFDUQ==
X-Google-Smtp-Source: ABdhPJwZf+8HOO6qQhuKq9rQTUqGjI6aG+jIpAvOMoQocLDDtFO/nrd/b5midKtZ9TOD+g3f6bVhCg==
X-Received: by 2002:a63:f242:: with SMTP id d2mr6281527pgk.212.1590617623722;
        Wed, 27 May 2020 15:13:43 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n19sm3196129pjo.5.2020.05.27.15.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 15:13:43 -0700 (PDT)
Date:   Wed, 27 May 2020 15:13:35 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jhs@mojatatu.com
Subject: Re: [iproute2 PATCH 0/2] Fix segfault in lib/bpf.c
Message-ID: <20200527151335.33ae7e9a@hermes.lan>
In-Reply-To: <cover.1590508215.git.aclaudi@redhat.com>
References: <cover.1590508215.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 18:04:09 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> Jamal reported a segfault in bpf_make_custom_path() when custom pinning is
> used. This is caused by commit c0325b06382cb ("bpf: replace snprintf with
> asprintf when dealing with long buffers").
> 
> As the only goal of that commit is to get rid of a truncation warning when
> compiling lib/bpf.c, revert it and fix the warning checking for snprintf
> return value
> 
> Andrea Claudi (2):
>   Revert "bpf: replace snprintf with asprintf when dealing with long
>     buffers"
>   bpf: Fixes a snprintf truncation warning
> 
>  lib/bpf.c | 155 +++++++++++++++---------------------------------------
>  1 file changed, 41 insertions(+), 114 deletions(-)
> 

ok merged
