Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01D9241F8C
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 20:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgHKSOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 14:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgHKSOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 14:14:06 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7656C061787
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 11:14:05 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id c4so10198276qvq.15
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 11:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ijGiSh9Wmr1/sro0pf1RkDdHdjZ6SNjuoQkEgOgEweQ=;
        b=MJ9OXyaYeU+D9d77fwmB30OZUklLwdiQSbT2tBGCShmFfrs+H//CgEAVSuvY4ZHVUj
         s66/hZpVZQ2hvYxlP6zRGpOj3aJZycsCn7zcPz7tzlq9Fma0rGmyOmTX6ae/6+yaTY3J
         teqGvHRvaNHe4lh4QiSQzOthOv8m0W8YCRE52YF4G5CnsKuJvHomJSLaTGWkQOZIDJNM
         PiugnSEykoZcuiHRR+t3MPou7tFD/RfrxPysGa01HW4D8nrX666gbNJfU/Wt92DUt3kG
         OFiiEXX7V+na9SKBU5xX7UHVbvq/3AussDDyhgXshpJYYEMjo/VyuEIPhI+6n+CFSu38
         TguA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ijGiSh9Wmr1/sro0pf1RkDdHdjZ6SNjuoQkEgOgEweQ=;
        b=jdvBKt024U/SgZGX3nTLaSguXzLF5vONDM7zveSXJB8qp+S0VbKrhNHSrZABZz7IjG
         4BuLa0WVvwrdQWztJxPUVXudZ5/x3yxKJQwjKG948/CVpuZyrHQ8wvkkpdokOfSv+Qw7
         d1i+ZVw8WGAIKLc0e+O1JKXNAooE+3VVAvNxp5PQyELgAvGMZjw1sAMh19bOxozZd+nL
         k4w7K7oXdB2mItY+zm3RoFIxa3Lgw4GSvq5TkN7FjkQ2WUNJI9DcrLmZNsQCVI+GivUY
         Oxr6KJBUEKIdwA667nCFd3sL4cUApMLkp+07ccPWIKaSXiUyeTupcCvZPZYamXtEtl5p
         nQjA==
X-Gm-Message-State: AOAM531Xw880rV3z5eEKxjHK7v0OBpJSBR3qJ/bjvUQAzUaZYemYtONb
        N/ujlsF2nS2I3dx96xMqXyyYvb0=
X-Google-Smtp-Source: ABdhPJyOVpxF1YNWr3W01L1nr9AI8RztJtBQKMeNubpv6bT1v7IDkHEzig3EHxuPHCp5RT0JrQPPs6g=
X-Received: by 2002:a0c:b591:: with SMTP id g17mr2704700qve.1.1597169644851;
 Tue, 11 Aug 2020 11:14:04 -0700 (PDT)
Date:   Tue, 11 Aug 2020 11:14:03 -0700
In-Reply-To: <20200722064603.3350758-4-andriin@fb.com>
Message-Id: <20200811181403.GH184844@google.com>
Mime-Version: 1.0
References: <20200722064603.3350758-1-andriin@fb.com> <20200722064603.3350758-4-andriin@fb.com>
Subject: Re: [PATCH v4 bpf-next 3/9] bpf, xdp: extract common XDP program
 attachment logic
From:   sdf@google.com
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, dsahern@gmail.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/21, Andrii Nakryiko wrote:
> Further refactor XDP attachment code. dev_change_xdp_fd() is split into  
> two
> parts: getting bpf_progs from FDs and attachment logic, working with
> bpf_progs. This makes attachment  logic a bit more straightforward and
> prepares code for bpf_xdp_link inclusion, which will share the common  
> logic.
It looks like this patch breaks xdp tests for me:
* test_xdping.sh
* test_xdp_vlan.sh

Can you please verify on your side?

Looking at tools/testing/selftests/bpf/xdping.c I see it has:
static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;

And it attaches program two times in the same net namespace,
so I don't see how it could've worked before the change :-/
(unless, of coarse, the previous code was buggy).
