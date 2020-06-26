Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAE620BBCB
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgFZVoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZVoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:44:32 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D274C03E979;
        Fri, 26 Jun 2020 14:44:32 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c30so6304751qka.10;
        Fri, 26 Jun 2020 14:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E6Mk7T325wOMSMol/Gso1twgpqfsyNC/slLo6j90OTM=;
        b=ryp1vsMXcnIBKvmWyhfQpXbxVNCffhKhc3yKrWOBNsg7hkK8iGAVqPN4VioQ3+tOJS
         anYZJYw3xeHr+Zwyoi/zI9vvMHDeTklFZgx3J86qYKeJjP8REhWbQp9w7giwZHAcGyFx
         kzPRyhxL8SKJgJB/eNL83I2FuMsxWTccuDUkHTwxLhZsDPGCzIM2NyeQbxb6xlNIA3+P
         n1xluNd4BNyxacslrfBVT72TEA0rhNqcy2My6L28f8hEG5uICrICg63qo5gVg+hiW2Ik
         HL9KghK+Bj3MP7CmqLoCPVhUadCg3fgnLcpLfzsnU4HlKwbTgg46314M4tPlWzhxkVQr
         6mwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E6Mk7T325wOMSMol/Gso1twgpqfsyNC/slLo6j90OTM=;
        b=Hgi2r/FNR9889SMtu+2HCzGgyTq6Nh0zPpWQL2K/UvTbOiW7FvWmGre9SW4E763Twm
         PbRywLtE7DpYTqIHQgHxZ2bwmye8aaQD0lRdjVLjVIXwcL+qq3gRQxnEPKms24Cd3Glg
         PMGBBGdlozuZKvmM2CnQ1ilzlhTNJmMbxBf0/G+dbrlajZbw6Khic6mJPMUIzGhOL0Iu
         GvD0ki4OKx9HYw4LMXzBS6mzxMZmL9Wav8I+QlVR/FbKwl8pSDwIMI/fkYUoxaIw83gV
         Ks+h0hVnWy1kX1uRrps4U+bI+a679MA147C5PalDMtN70M1FILguJX7eC3OJf3hFahGT
         HZMQ==
X-Gm-Message-State: AOAM532yMdeVeetGgpJZo+TlKkNUgnZP3GB+m/lrG+Frw6QYRa5+iRol
        wDMIMnwEdZ4KWTw9YhnLxiIrEvtF8SzdeO/bJsE=
X-Google-Smtp-Source: ABdhPJwNYevgBmi/UAM3wkiyjp/rDjqsGRfYlMlBY5UuzJYtlWB87F1HmV9rhZYh/EI3hUTppnRiU4KyHPVitFO8co4=
X-Received: by 2002:a05:620a:1666:: with SMTP id d6mr4152257qko.449.1593207871635;
 Fri, 26 Jun 2020 14:44:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-7-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 14:44:20 -0700
Message-ID: <CAEf4Bzag3L=BhOacqMekubOg0aeJg=2i32O0VQuQACsu35geXA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 06/14] bpf: Use BTF_ID to resolve
 bpf_ctx_convert struct
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 4:47 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> This way the ID is resolved during compile time,
> and we can remove the runtime name search.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

This is a good improvement, but I was thinking about actually
simplifying btf_get_prog_ctx_type() logic itself (it also does all
this BTF ID resolution). But this is a nice first step, so:

Acked-by: Andrii Nakryiko <andriin@fb.com>


[...]
