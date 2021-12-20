Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7636A47B5F0
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 23:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhLTWoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 17:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhLTWoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 17:44:03 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F42C06173E
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 14:44:03 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id p8so18328239ljo.5
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 14:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3kR+qvwhjwzMmvLc/c/Ou18ItA0mdmPOVRKF9Xy7hrQ=;
        b=a3o4omkImHfnYWh7lwfTnFj/o9LUuUReOayYjaj7l+7XirvTb7o4INrI3dGYxKHeSn
         F71T/6Rg4bNkrODaevJM0nobKvCpoXM4lKoYV9pKqiSgdyoQy6w5rAvxqzGfAxXpUDid
         9ccUlivZd8dz4Eo5/6AiNy2yeVNVNSrrcSrvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3kR+qvwhjwzMmvLc/c/Ou18ItA0mdmPOVRKF9Xy7hrQ=;
        b=4BET2jJLRnPrYktXmxZk6tMLRygnyxcSHEihjZEYII3DRZKBY0opYeh47Ru7KiXnym
         mpi21NTtt7/c1tPCZd9dgyrZmvO56VIEK3thraT9cOKBpUjRGJFQi+P6EjyxGOKXGTNW
         EmyfkIBP6ZtXjFeT/LIepVrYScn3P7BrXiHVhWJXwuqero6wUIIXPUQitlERfoURvPqg
         xyYwtCbsFFPGjm/UjzVCPc5yoM1pJc0RQmOvfIN6TrQiCFTkBLjzbN6oSq+99iwH612w
         DqrkjYZ7MJe4fE1xOQXmNMMD7ivrh76kUPR9NALS5MZierq1qdOVOpqUgN6VzdEK+N5F
         1oDg==
X-Gm-Message-State: AOAM531d5ORXCgswg0fx7R17tO7pMW0p2jOD3Kjd3ucq2ZM/rcmXlu8f
        s9siqyxKvIcpl5FgP6zY+GqaN/DeKght/RsOSQLrQw==
X-Google-Smtp-Source: ABdhPJxv8FTSTFsBr8KFw4Suqja18ICOlpL8oO6p9uSeaW7ndB7hfAb/Rfg+/jCPTesicGO2ZnIWgUsDcc/6rbbBW18=
X-Received: by 2002:a2e:994a:: with SMTP id r10mr168437ljj.301.1640040241358;
 Mon, 20 Dec 2021 14:44:01 -0800 (PST)
MIME-Version: 1.0
References: <20211217185654.311609-1-mauricio@kinvolk.io> <7a628aaf-852a-2118-85f4-f49bb0d35944@iogearbox.net>
In-Reply-To: <7a628aaf-852a-2118-85f4-f49bb0d35944@iogearbox.net>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Mon, 20 Dec 2021 17:43:50 -0500
Message-ID: <CAHap4zv=EC6dL7VP76pfLYJo5VxW2s5oW37XsfF8Uqrg_XhyRg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/3] libbpf: Implement BTFGen
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [...]
> > Changelog:
> >
> > v2 > v3:
> > - expose internal libbpf APIs to bpftool instead
> > - implement btfgen in bpftool
> > - drop btf__raw_data() from libbpf
>
> Looks like this breaks bpf-next CI, please take a look:
>
> https://github.com/kernel-patches/bpf/runs/4565944884?check_suite_focus=true
>

Thanks Daniel for checking this up. I have spotted a potential issue:
the instruction is also patched when prog->obj->gen_loader is set.
I'll fix it in the next iteration but I'm not sure it's causing those
test failures. I tried to reproduce them in my fork but they pass
fine: https://github.com/mauriciovasquezbernal/linux/runs/4586966124?check_suite_focus=true.
Could it be a false positive?
