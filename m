Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDA5D4B6E
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 02:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfJLAiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 20:38:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38896 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfJLAiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 20:38:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so7016992pfe.5
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 17:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/Tqm/e7mxkRNSmON4GxKZnAfI5rLUsZwZqsc4IgAN6k=;
        b=UqSlRortm0GTpTjgTmDLvUL8JslFHyWctkYRi/z9gopozj1yjzlmRkpCvSsg2h5spK
         pEsLrivSezHV9nsnxEkBL9kSQvzjWqlQumS3SghWpD1iGVTHHWUGSrPgMjk4vOFATgj6
         2lVCQnhCEJTR306wYQAj+msLypbTd0e+RZs25GqDoB1S/8CP52Peo+7CYJjB3mxBBPB0
         KPaFMbpI9eJrZFk+rnfFnCRgItOhvX1+LcvssK8gx88AY7oP0jsPLRaYpXL59Geu01pK
         H+5EFPwvv/x1ik6jjI4WiQmO62iMljfKDVxuAXI8aPipf0qJhhXXZoeMq485TTEHXc/U
         SvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/Tqm/e7mxkRNSmON4GxKZnAfI5rLUsZwZqsc4IgAN6k=;
        b=iuDQgZnxhXgB9SWZwQl4bvk+6Cm/Wu167NmeALIf8+GkPpG/UYwtHfYZ21lPkAzAnN
         +X6Odftts9ua0ujBMptk+YyLRmFKgQJ7EbZeCfHxiYuyKXYdooLwj8+5r/bwbfsnrRfR
         Ez0rChotAO3NgFpzcHdcFoXigHfL0L1MoT/GuhZjnaZyQPNhjZWRLmqryFQ/J20MtvXS
         55o9ounPznkSLIMuDKoFX3ttF+sMcsQC8uwAFq/gGB2e5aQLZqVkhYE24g9nz25hlF+g
         aU1+XvEOK3iLObx9cJZOQZwtxB2VNBEVd+LEZ0I3tyj3OnBi1/JrICprK+nQAkNdgW/t
         um0g==
X-Gm-Message-State: APjAAAXzEYNIZs1bEYFdKtE11jvOhbYIAJ/LR36Alz33Audr1zPc4fgR
        yD78Eqx+MedWTNHhzQ61t4+KeQ==
X-Google-Smtp-Source: APXvYqyAtuE4AtgXtU8eNUYWS/WQTdhO8qVWcFBz5qicSmjY8Kq91MVhv3qa6kxbcbnm/Lze6bgC1w==
X-Received: by 2002:a65:50c5:: with SMTP id s5mr17598122pgp.52.1570840700847;
        Fri, 11 Oct 2019 17:38:20 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id g12sm16204783pfb.97.2019.10.11.17.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 17:38:20 -0700 (PDT)
Date:   Fri, 11 Oct 2019 17:38:19 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/3] bpf: preserve command of the process that
 loaded the program
Message-ID: <20191012003819.GK2096@mini-arch>
References: <20191011162124.52982-1-sdf@google.com>
 <CAADnVQLKPLXej_v7ymv3yJakoFLGeQwdZOJ5cZmp7xqOxfebqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLKPLXej_v7ymv3yJakoFLGeQwdZOJ5cZmp7xqOxfebqg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11, Alexei Starovoitov wrote:
> On Fri, Oct 11, 2019 at 9:21 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Even though we have the pointer to user_struct and can recover
> > uid of the user who has created the program, it usually contains
> > 0 (root) which is not very informative. Let's store the comm of the
> > calling process and export it via bpf_prog_info. This should help
> > answer the question "which process loaded this particular program".
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/bpf.h      | 1 +
> >  include/uapi/linux/bpf.h | 2 ++
> >  kernel/bpf/syscall.c     | 4 ++++
> >  3 files changed, 7 insertions(+)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 5b9d22338606..b03ea396afe5 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -421,6 +421,7 @@ struct bpf_prog_aux {
> >                 struct work_struct work;
> >                 struct rcu_head rcu;
> >         };
> > +       char created_by_comm[BPF_CREATED_COMM_LEN];
> >  };
> >
> >  struct bpf_array {
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index a65c3b0c6935..4e883ecbba1e 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -326,6 +326,7 @@ enum bpf_attach_type {
> >  #define BPF_F_NUMA_NODE                (1U << 2)
> >
> >  #define BPF_OBJ_NAME_LEN 16U
> > +#define BPF_CREATED_COMM_LEN   16U
> 
> Nack.
> 16 bytes is going to be useless.
> We found it the hard way with prog_name.
> If you want to embed additional debug information
> please use BTF for that.
BTF was my natural choice initially, but then I saw created_by_uid and
thought created_by_comm might have a chance :-)

To clarify, by BTF you mean creating some unused global variable
and use its name as the debugging info? Or there is some better way?
