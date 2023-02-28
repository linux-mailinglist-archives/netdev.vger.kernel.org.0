Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6916A5B7E
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjB1PQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjB1PQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:16:32 -0500
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB372ED79;
        Tue, 28 Feb 2023 07:16:31 -0800 (PST)
Received: by mail-qt1-f176.google.com with SMTP id h19so10754469qtk.7;
        Tue, 28 Feb 2023 07:16:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RPo/RiCcotu5llivQRx04vO6x7keCmQo8aszi+pK/Mg=;
        b=ofLqhYkDr8wfes7ThJ5ZkksqXdLaIUmMKXbpRrB9THU/F7BQ+0aGyXmtM3RT5+gxqO
         +Xt5yNIHMAOXjyecN40HqWskbYuj8wBVf9ynrGpYf73vYQ5P7U8cnem5HKNMQOKABLxp
         spiFO13pP2PVzxANXBrIbo67Rh3m1eiOW9GoDIoJuLm0ePJv2OJuzyJHIl27b6GtpaRW
         okrgA/6ZF8yszn2soD4nmVNaxZbo3xLbh60nHz3EHtBKv0YsByXKlGyzykLUk5FDoyOJ
         6wwIiHqi5A2oMgqAqoULumeVSMMr3S8C4c2foEVtLGZHditKCvwookSHiB2SM02nYNjs
         oPgA==
X-Gm-Message-State: AO0yUKXrLFD6WWOdUCYMKJmHPIEPe899Vr49y3aj4Cf3vF0tonMwrjND
        myjMgCbSxLlCVTzfsOgX9MA=
X-Google-Smtp-Source: AK7set+mfSO1i5CwmeerG+592lIRurSup5MSfH0YpKclZmIcBDebTNjSTPRBsMt8TwMqeCeKeVbIsw==
X-Received: by 2002:a05:622a:1889:b0:3b8:6ae7:1757 with SMTP id v9-20020a05622a188900b003b86ae71757mr5559647qtc.38.1677597390523;
        Tue, 28 Feb 2023 07:16:30 -0800 (PST)
Received: from maniforge ([2620:10d:c091:480::1:f172])
        by smtp.gmail.com with ESMTPSA id n15-20020ac81e0f000000b003b691385327sm5024444qtl.6.2023.02.28.07.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 07:16:30 -0800 (PST)
Date:   Tue, 28 Feb 2023 09:16:27 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 1/5] bpf: Rename __kptr_ref -> __kptr and
 __kptr -> __kptr_untrusted.
Message-ID: <Y/4ay2APLyfPAMvD@maniforge>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
 <20230228040121.94253-2-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228040121.94253-2-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 08:01:17PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> __kptr meant to store PTR_UNTRUSTED kernel pointers inside bpf maps.
> The concept felt useful, but didn't get much traction,
> since bpf_rdonly_cast() was added soon after and bpf programs received
> a simpler way to access PTR_UNTRUSTED kernel pointers
> without going through restrictive __kptr usage.
> 
> Rename __kptr_ref -> __kptr and __kptr -> __kptr_untrusted to indicate
> its intended usage.
> The main goal of __kptr_untrusted was to read/write such pointers
> directly while bpf_kptr_xchg was a mechanism to access refcnted
> kernel pointers. The next patch will allow RCU protected __kptr access
> with direct read. At that point __kptr_untrusted will be deprecated.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: David Vernet <void@manifault.com>
