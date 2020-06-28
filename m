Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD3420C925
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 19:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgF1RPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 13:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgF1RPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 13:15:44 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED5CC03E979;
        Sun, 28 Jun 2020 10:15:43 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id b25so11938348ljp.6;
        Sun, 28 Jun 2020 10:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HQ2RjhuVKKUDNgqtcSsfkIbE3XmuXBJBGNDy0dFEg+M=;
        b=p6Iw25gD7v44lVIWuQM9oSSev9wv/F/+ZCV+rjeJKHoSg/qL7ItU5Osiqs5oM2CpCv
         FqZXJBdLOyazYZdRK9PfZBCXCwr0HWjEqOGm9n4Bv0WFxxX6PKU/JAlHFF+8hR977H6j
         YYLmBTBotBLfwEx7+3STg6tzehahHe6nWYO4A3EW+BUlwDviusGqPfvShoHe2LCT2YZv
         rM14sFhhIKtkfULP9cjT2Y+qYyg/HQFuvLQsNUv+f2gKGhwoCPoB993M2cY2+9d2xEhA
         70xfALkmiI7WFPJr6tMD09F7cPSG6zQ/+BzSFroHlXqiJjKeSozDGy6wp2dp1JAcoGb1
         3gdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQ2RjhuVKKUDNgqtcSsfkIbE3XmuXBJBGNDy0dFEg+M=;
        b=H+2ai4xfYZr5a36ahGEhbW3bO6M22TyaLf3sxtixgxE+h80LarowcxxzhUphgEnH2b
         y4jjwR7VXf3FUAZprEWzE4ZF9437/vNUXghq6M9UJBWAZHL7wMrjcXw/btLlgNj+wQ0E
         IUyoPn3yVAZumbOZ1ITnJUXOoNnr1/mVDrAUIxY6rRoSnL6QiRCAk4YU9zaMel14T8ft
         YLH6o4IM6vTju3VNrKyDkqUNXHQVOl4cmUnj3nKKLAGtKbcDrfqmJKbFTxIWgNw9OlRX
         FiImLphKKLcbL35xw3x0+AJHupSBxkinmX5qLulZMF/PCVgdGibpxoS7SLjtFUdqOjVg
         6GFA==
X-Gm-Message-State: AOAM531TPiTql3REw5CPY9CW3hUsr/26pKNOdrpncuCMtPyI13YZKxrQ
        Px3Qevu/5WDUWnbgv6+BejebS3mpe5IiZ0leolk=
X-Google-Smtp-Source: ABdhPJwUWfJH29SjGv+sYepnCk+u4L93htGk4C8+wBLPU1CNCz88/UzhFx8AJSCbhjMqbKK1J58ReDBchEWjXHqJQjM=
X-Received: by 2002:a2e:9a0f:: with SMTP id o15mr6436666lji.450.1593364542025;
 Sun, 28 Jun 2020 10:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200625232629.3444003-1-andriin@fb.com> <20200626201113.vzkhhqov4zzdrrnn@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200626201113.vzkhhqov4zzdrrnn@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 28 Jun 2020 10:15:30 -0700
Message-ID: <CAADnVQLveT1_KOYAp40VPv8AiRfUPYXd5xr1yoNJv6MPt1bcMg@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 0/2] Support disabling
 auto-loading of BPF programs
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 1:16 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Jun 25, 2020 at 04:26:27PM -0700, Andrii Nakryiko wrote:
> > Add ability to turn off default auto-loading of each BPF program by libbpf on
> > BPF object load. This is the feature that allows BPF applications to have
> > optional functionality, which is only excercised on kernel that support
> > necessary features, while falling back to reduced/less performant
> > functionality, if kernel is outdated.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
