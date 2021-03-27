Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD0534B97F
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 22:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhC0VZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 17:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhC0VZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 17:25:16 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC28C0613B1;
        Sat, 27 Mar 2021 14:25:16 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so5891474pjh.1;
        Sat, 27 Mar 2021 14:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bCeAT8h/DoX+EbZUsej2NunQqIkNP84lRZ/jaCTjPZs=;
        b=MbXl6+xaA0zCy6L+sc1vtmTZuh1PsNPj91m769ph7oSSkX2LS+gmk1VzB62EiIWty7
         4k/ldj8lOUp2NFUmQSYZC17Na9tn9hcOqjrDrk0CCXDHOkEt7RBuAVKWVOTmlQQdu1NQ
         7+wXQWnQ9pwHPbgL8i+60nKuS0LqCQIJLpmZsdeOxlhw/S8OtWhdogcDsHqSUm/GgMQN
         FQhM8CI7X0ZNCsCTxM16rNeuc/yvh8sm2/0yv0BN1Q2HGO1PXDI709f6sJBeBgXV8kBo
         vFpWTk8l1LvOsFesUXL7RbH8/YIYlMuUEkrx7ezN/oY182EJSSqhMu23Uktylvt2RV9q
         YQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bCeAT8h/DoX+EbZUsej2NunQqIkNP84lRZ/jaCTjPZs=;
        b=cpo8g2NXnUzvjqGFNhHd1Yrtkj59IGCW7a8vD6gH1fLcbNoYLVyke5HdmUCYA8QSOO
         YPL0tNvJTTcQ531QGyINmnDR2NACMgjuoVffL1ccbW/fYn0T6sPjjrEIMm/wrQhDqOpt
         ySN+YWnNJadfmyQyLPsGTzn0hQUO/ZJ+i1Pw+rM50D/Iddl/NCjXnbS062v2g9JzTINQ
         1GEbcpaT7RX7BKVGMBTPqwx19sRThDvm9s/wFEM7mB9mCrilvUlfnAF3NMrq1pT3owZg
         vB/V3HbPciq3FdewdIwNd2a3rjNrybVS+4IoBVuwdYqkcMFGbzyVf5ylAHD1WMCe/rUK
         BDVg==
X-Gm-Message-State: AOAM531rvvvsTTJmaCmJ2RK3YCBslXb5LViAnWepl5tOjBEjbCfKG7u/
        pZCkhLqhaUZ1REX7NMzbliLLkoxs4gjpdLNPEP8=
X-Google-Smtp-Source: ABdhPJzmZO5x0com3T7dinIG9Omdc1lNU/hr1X+91F2Zignwy4Ma2ljYh1x7ZLBjody5ggONBsQ3eIIpaDJGJjjTiZQ=
X-Received: by 2002:a17:90b:514:: with SMTP id r20mr19799477pjz.145.1616880315648;
 Sat, 27 Mar 2021 14:25:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com>
In-Reply-To: <20210325015124.1543397-1-kafai@fb.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 27 Mar 2021 14:25:04 -0700
Message-ID: <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Mar 24, 2021 at 8:40 PM Martin KaFai Lau <kafai@fb.com> wrote:
> Martin KaFai Lau (14):
>   bpf: Simplify freeing logic in linfo and jited_linfo
>   bpf: Refactor btf_check_func_arg_match
>   bpf: Support bpf program calling kernel function
>   bpf: Support kernel function call in x86-32
>   tcp: Rename bictcp function prefix to cubictcp
>   bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc

I got the following link error which is likely caused by one of your
patches in this series.

FAILED unresolved symbol cubictcp_state
make: *** [Makefile:1199: vmlinux] Error 255


Thanks.
