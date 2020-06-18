Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C131FDA3F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgFRAaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgFRAaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 20:30:13 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A105C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 17:30:12 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a6so2254541wrm.4
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 17:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X/K6YKPpB9keDq7TSfOmKjoiMD0gN58pTO8hkgyVil8=;
        b=sTqwp9o3JShqjkBxRFefmsbzfRwqPUtW1cOIm1w5ujdspbzh8H4ZvTUjWicrkJF2Dm
         yMrChSkgamNcLDL5RAGhic5a2Ddglcbeo/sSMutu8mE5CtYXoGpNMS4Q59puWFtPlqX/
         L/F71nyJNHDcBOgaxogQ6Hrj+RP/JPzn9edQ/b7wGDI/YEDUveniR31x0XXCoRhOPPah
         C0anOOJU3+o0V/ssszAEAGWqP8ykbcNmyqsPToQ9d40ErMI5Eomr54QOYXdOkm5BpNuV
         zvUFszqKpM23Ywm4olGW5ERnVpluD67CayExGvQqCKlVOHVWlnOAvAYV26zyug7ZHsp1
         jQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X/K6YKPpB9keDq7TSfOmKjoiMD0gN58pTO8hkgyVil8=;
        b=O2wBn/vlNtZpiZbAXvhmhUd0gtFvnGPqOrjDDnOz4ErAsLqhR4CH1eOIU6gGoUEuvO
         aJTHiL0MFiOiexKTRmal+WulOp6orrbEwYPewXgxLFqGGrGC54i2SHk+TeVuLZzUiJv2
         39sws1K6+gu9MjPRaxyJvElOxlDMWR3d7ktkaN6EBgsLQrh+hHUWzoctVJT2DkMYrX0z
         tfdQSywl/PnweeRBomq8Wg04Q+1WiyFauMIvgrJrOrS85Z1XpQN5v1yJLQ0iSHMqb4ta
         1VgfXkyobK+4zWaGndX8/4QV2bPu+M9TrArpUELrz+CsFQ0Va46kRRWcjkVZiD0pjkxD
         zLog==
X-Gm-Message-State: AOAM532T8/+XYHOIup4qRMG8cwCFOUFuI0uge+8uKhZ1VqPtCYdlnnFx
        g+Axp6uPKf9ePnL3vWFaNWJWqg==
X-Google-Smtp-Source: ABdhPJzEo2EtaZgY/d83mK9I0yus0DfHVeVlTZH4QCMFfts2fhdYZHrAPUOlmkrT0sl4xxnY2TAnfA==
X-Received: by 2002:adf:906e:: with SMTP id h101mr1736279wrh.221.1592440210890;
        Wed, 17 Jun 2020 17:30:10 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.184.244])
        by smtp.gmail.com with ESMTPSA id u74sm1429999wmu.31.2020.06.17.17.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 17:30:10 -0700 (PDT)
Subject: Re: [PATCH bpf-next 6/9] tools/bpftool: generalize BPF skeleton
 support and generate vmlinux.h
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>
References: <20200617161832.1438371-1-andriin@fb.com>
 <20200617161832.1438371-7-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <c4cf4555-3fbb-4346-a2d9-93d6345500f3@isovalent.com>
Date:   Thu, 18 Jun 2020 01:30:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200617161832.1438371-7-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-06-17 09:18 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Adapt Makefile to support BPF skeleton generation beyond single profiler.bpf.c
> case. Also add vmlinux.h generation and switch profiler.bpf.c to use it.
> 
> clang-bpf-global-var feature is extended and renamed to clang-bpf-co-re to
> check for support of preserve_access_index attribute, which, together with BTF
> for global variables, is the minimum requirement for modern BPF programs.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
