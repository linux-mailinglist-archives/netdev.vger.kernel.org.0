Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0611CE988
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgELAMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728357AbgELAMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:12:14 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA7EC061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:12:13 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id o11so4360233qve.21
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eMaf4xc8D2BTATY0do2dFv+4nFGdf/qS8KpJ23BpHA0=;
        b=WTnl9KRJI4BwzNnZvPbjEij1Gyw+15IRSe+l0FJ4S+5s+XJIWK78bOeswKixQoY+ns
         O6wXSLSIxB78mJmAfk7OuyqntA8WQVWnDj2DUWd5wKLRjvEbSVGmOvrSrjFYiE/BV1uk
         voa+EQAClkeYRlTT4viM5mPtGg7uU8SpXdrpmHxRrveN0lCyXXwqN23t+tHOQWl+cXeE
         DYAXRSmZSGzklhJAM997GHYslerGdc0Pv1dSqQbuXqXnlHN4OY+p65gusAJKVS8R+ugv
         nJNKo1ZA3/w/p5z2H1P6Z3Ip8+dzTSaCYdym+DAsT0gpcZNkn0m+c5/NqCFVLlZeQztC
         ac5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eMaf4xc8D2BTATY0do2dFv+4nFGdf/qS8KpJ23BpHA0=;
        b=TWitJHzCPyRwY7y/sCqmy5EhlwEAWo+D72BQjxXpKwAxwTSDt+EbaYZDQBlWRv8wIq
         QcUqvjzv9KYSky3fOisqvw12mI42Zjo8Apz5BFoqLjghrGoIIcryYCTko0x9eriHtx14
         hrnXQp9q4XgOdTidZ0t3LZFiQSiErO8NneZh6L3fOVwkMZXl/6fDMrMSd1Q2CnKpDidb
         dSSbekmYAQ1QXGwouWBS2XSb3N69+3lRhFHBAx7HE70IgR1Q8ijH3Ue3GgyKOMfx484E
         v9fA1t3sENcOfhJvlF5G6vYmJcPv6DaGNiQk0T3zobx6jsGfuazYePcs1yyhpF4RPeCi
         fwnQ==
X-Gm-Message-State: AGi0PuY1Eh0FCh5jJMj8x4jHLbQnDDf5rAKbCTgetSg0OvclDRFJx6Bn
        3FBjexCuV4myHoUmr/cYAOEFAOc=
X-Google-Smtp-Source: APiQypIOM3v0IvzYlBLoCseN6fNtA0BGMXPAe7n/8UDiFV3tUxZn65Tq/kITIfPvNITpZRmCY34ZI/U=
X-Received: by 2002:ad4:42c7:: with SMTP id f7mr18867291qvr.127.1589242332555;
 Mon, 11 May 2020 17:12:12 -0700 (PDT)
Date:   Mon, 11 May 2020 17:12:10 -0700
In-Reply-To: <20200508215340.41921-3-alexei.starovoitov@gmail.com>
Message-Id: <20200512001210.GA235661@google.com>
Mime-Version: 1.0
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com> <20200508215340.41921-3-alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
From:   sdf@google.com
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com,
        linux-security-module@vger.kernel.org, acme@redhat.com,
        jamorris@linux.microsoft.com, jannh@google.com, kpsingh@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/08, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
[..]
> @@ -3932,7 +3977,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr  
> __user *, uattr, unsigned int, siz
>   	union bpf_attr attr;
>   	int err;

> -	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
> +	if (sysctl_unprivileged_bpf_disabled && !bpf_capable())
>   		return -EPERM;
This is awesome, thanks for reviving the effort!

One question I have about this particular snippet:
Does it make sense to drop bpf_capable checks for the operations
that work on a provided fd?

The use-case I have in mind is as follows:
* privileged (CAP_BPF) process loads the programs/maps and pins
   them at some known location
* unprivileged process opens up those pins and does the following:
   * prepares the maps (and will later on read them)
   * does SO_ATTACH_BPF/SO_ATTACH_REUSEPORT_EBPF which afaik don't
     require any capabilities

This essentially pushes some of the permission checks into a fs layer. So
whoever has a file descriptor (via unix sock or open) can do BPF operations
on the object that represents it.

Thoughts? Am I missing something important?
