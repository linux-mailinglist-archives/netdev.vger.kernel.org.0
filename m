Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A639A1FDA41
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgFRAaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgFRAaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 20:30:21 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991B1C061755
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 17:30:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x6so4183587wrm.13
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 17:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xII6XSCz2jFDqpfIO13B3lnPOpUp01byjrtugdY/4Gs=;
        b=BW9NTClRieTX1SjiyLnWfp593dWQ65ulFE5NOfI5veDHJOYhEYEJ5mbR6Pg6jlRbef
         F/fP1I2g6v4pYxa1B6E6tLAVQTzkH1780kZmzcUADIHU0fr9ZE23KhZHfF2Vx8kSTDmA
         CdhtD4SX2DtPfRKRdtGXUp0OZ2yKEJoPyXwOyO6jD4N++C/PRtBEJyDV/Ndbr3MdPvbE
         0bFS4QP5jQaYMY4gw1TnXOnyNTH6z6bxHc3oFtHPYJjf0owr0S/CpbircOE9j5vKjlqt
         799OAhLyGHjSLyqtD271+4ldJhR/S0kks0mq2cibGs+aPIqJytVyXvIyLnf4QFj53qvF
         M4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xII6XSCz2jFDqpfIO13B3lnPOpUp01byjrtugdY/4Gs=;
        b=S6RC3df1H7Cs5P/vfQxRtxfTGeimvtUHCJLw+Dsy7QnS34gjYTmb3sitwrUeCQU2Ex
         DRuIIhFS/iUF98lKczEbUqKWwPl4nbbFARQNgfo3U9SrsuUDc6rKsWQs6i+Y6TSqamgW
         btyb96KwvCsNfggcBhJ9H8oWBnFHX0+X6i4pbok6Ho56qpJGSlDULkNsdhIh6LkRb7F+
         DN/eeUD52w3gfdMo1kWZYnNHlIzs9DFnnPeq3PmOsI79Pyi7d7BigwL7/FLqXcORF2or
         OfB3FdISMA8WQVpuBr2KhUuRKYPFzMsYGPG5SHIzBOsCJCdETxZYn5gshrROBi9GC27Y
         skIg==
X-Gm-Message-State: AOAM533/Y6V/uVlmXQi/iS0wIKTjL1ydmumMLZETb26U4sEWFChYhCNM
        FYXM84DNQBADV+uLTp/0yVF6Wg==
X-Google-Smtp-Source: ABdhPJx8CJSpPYImFopNEWop5ASAPeKZiJDIkGBCSwidxE9mrttMpYc5bjCZNj+0b9LxaQJA9TfLcA==
X-Received: by 2002:adf:c707:: with SMTP id k7mr1707060wrg.382.1592440219374;
        Wed, 17 Jun 2020 17:30:19 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.184.244])
        by smtp.gmail.com with ESMTPSA id g3sm1480699wrb.46.2020.06.17.17.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 17:30:19 -0700 (PDT)
Subject: Re: [PATCH bpf-next 5/9] tools/bpftool: minimize bootstrap bpftool
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>
References: <20200617161832.1438371-1-andriin@fb.com>
 <20200617161832.1438371-6-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <16c2fd4e-d05a-0860-262d-cd129ccac6d7@isovalent.com>
Date:   Thu, 18 Jun 2020 01:30:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200617161832.1438371-6-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-06-17 09:18 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Build minimal "bootstrap mode" bpftool to enable skeleton (and, later,
> vmlinux.h generation), instead of building almost complete, but slightly
> different (w/o skeletons, etc) bpftool to bootstrap complete bpftool build.
> 
> Current approach doesn't scale well (engineering-wise) when adding more BPF
> programs to bpftool and other complicated functionality, as it requires
> constant adjusting of the code to work in both bootstrapped mode and normal
> mode.
> 
> So it's better to build only minimal bpftool version that supports only BPF
> skeleton code generation and BTF-to-C conversion. Thankfully, this is quite
> easy to accomplish due to internal modularity of bpftool commands. This will
> also allow to keep adding new functionality to bpftool in general, without the
> need to care about bootstrap mode for those new parts of bpftool.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

