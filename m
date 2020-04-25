Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484231B8593
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 12:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgDYKTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 06:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726053AbgDYKTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 06:19:30 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F02C09B04A
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 03:19:30 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k12so10141317qtm.4
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 03:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yhgkDblJ6kuS2NzyTpV0otXE+gL6DJiipid5BbTEBrM=;
        b=NVqodb/xL3rXX892FRNxzgXwtT0FCUR1c5K2pylnT0Qt6fplduqWr4PHf32pT7NNFU
         OlwOjR5Zf7Cs6mBNdiha7a+oYCLDn8W0cRA8N/spPvk+beknj6l/VsHLTzrwr9iNd3cz
         7iRf+TQ76EnWFS+CxVhhVNI0by09ZJJxqCNEaZ5cKy7kFh+JqevUsJ0kU44hY1VCJbgR
         2IfXVCRAxtbuXft6N0741GJ5Hj3K3fmMjPCcLREi4YYzputdskpM4rQ97DXfu7HEoGOf
         F3fn2Fhp5eiIZ075AKrrPEl/0auuORf5Ud9raEMMp6LsxDZFwb6YMdhaDqjE75N0cwE3
         5Gtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yhgkDblJ6kuS2NzyTpV0otXE+gL6DJiipid5BbTEBrM=;
        b=MpnyhF4ft5kK7OX/l3wpoTIhN9a5Qg5Ro0kTWmSBAsxxtoWWBDmKNMgH41tg8quEkP
         RRuhadj/41fVtUv7n44YvMImzGTSAFNryB1QgRVQBTE9vxLNIokyXyY2gYb4+SkO8qTT
         m0CbdVO2qFNYYD7ffaugMYWETCkUM1ZCCYscO38ZHG09AXjqE6yXT72d9v9X/PEa/UX7
         5bWvenhRFpDVb7OYjRjgVMVXV3UZIg2CVHj8blpXqUdoJV8FscJFPlKUmHT6o4wwMC0+
         NjOw+hb+TCBkY2jh6oVA/nkopgX1zLes5yk4a+rzQDOdzqSxxSj05G+46JnC7JY1Tt06
         C6aA==
X-Gm-Message-State: AGi0PuZTBxvk3GXV0V1vzSgtKqRV9MpT870ITqXgXrl82tMYEYweptTt
        XGLLZhdhfZrxTiqFBa+zZ53td3RMHjN5G+zKRGthDQ==
X-Google-Smtp-Source: APiQypJg2EH+UxMCJiIlw7/oyCETvUIny+wa/DNI7c+EGj7nX4finA4EmWHhD/msYJh6Q9hUx7dfDsiwnQYsa9RcXzQ=
X-Received: by 2002:aed:3e22:: with SMTP id l31mr13842848qtf.290.1587809969734;
 Sat, 25 Apr 2020 03:19:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200424053505.4111226-1-andriin@fb.com> <20200424053505.4111226-8-andriin@fb.com>
 <34110254-6384-153f-af39-d5f9f3a50acb@isovalent.com> <CAEf4BzY9tjQm1f8eTyjYjthTF9n6tZ59r1mpUsYWL4+bFuch2Q@mail.gmail.com>
 <5404b784-2173-210d-6319-fa5f0156701e@isovalent.com> <CAEf4BzYZD2=XV+86DFfGvtfBEGkdHAEhxe7WebU2bm=okGJEcA@mail.gmail.com>
In-Reply-To: <CAEf4BzYZD2=XV+86DFfGvtfBEGkdHAEhxe7WebU2bm=okGJEcA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Sat, 25 Apr 2020 11:19:18 +0100
Message-ID: <CACdoK4+h6SjPe9XGbC5WWLcAhZoq9C3zcPEOe4PQ0TVzrDxiCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/10] bpftool: expose attach_type-to-string
 array to non-cgroup code
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Apr 2020 at 01:12, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

>
> Ah, I see what you are saying... I can just declare array as
>
> const char *attach_type_strings[__MAX_BPF_ATTACH_TYPE] = { ... }
>

That would address my concern, thanks!

> to prevent this. There is still this issue of potentially getting back
> NULL pointer. But that warrants separate "audit" of the code usage and
> fixing appropriately, I don't think it belongs in this patch set.

Agreed, we can keep that for later. My main concern for this review
was the other point above anyway.

Thank you,
Quentin
