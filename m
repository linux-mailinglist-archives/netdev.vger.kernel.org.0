Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6777CD1DD9
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 03:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbfJJBHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 21:07:07 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33223 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731155AbfJJBHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 21:07:07 -0400
Received: by mail-lj1-f195.google.com with SMTP id a22so4420735ljd.0;
        Wed, 09 Oct 2019 18:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mCmvnwfoIAUn0GbTA6M/IKFbFb+1cvSeHZw/IRcu1DA=;
        b=cbBkYk8v/ij5zX0qYP3zpTa3XjiVHNsOPMcvKp+UxIaabqI+Jfd2auAuxESqgfmC7P
         MvCi7UBKMVkGh1hCM7T+v4ysbpL2C/ZgAfAsG6A3aO0tOkPvT09TTuosX4EwlU1VQSnD
         3iQV9eTqsrtm38wQVGNfo0kaYiKRLnsJ6Km3s9AZp4kX+XAjMvLppcAMHR6pODGNADny
         M0Y684hgEbp8ecVnazFdbVcDKUX6RVfG2Hjp7oUHrpf/0SotiYd/KLwYjpRl5DBqzgLS
         NE3v/N7BOOeUV/dWWKeH2ZL6WK2ld9wD57vLSVLzqo/9FWYlTiuAFRolqzmUserM4f8f
         X2cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mCmvnwfoIAUn0GbTA6M/IKFbFb+1cvSeHZw/IRcu1DA=;
        b=cOB0eTtkVpBfhHyoP/XZd/dJpxqwejt6X6POD3z//MsRJhXuouPubdwXh3zZqV0gqy
         qACk++WQuTRoAhTkYQ1Kw56u5kQBvNTX4lvgBDPZaPNhrNLrrmMW7wV7LA5ZuFVEp9T5
         ap6UV+wfJdeByYtyuplURN80KCcWCXzP61n1vGPPUxUmTguA1bEDpAsbceS2G0Ty5EdS
         8MHVtYaJNCjpudHMxD7r2d8PUduLKNeUpSe3/4QfBuU8U7CctaggJvBRMPEk3WnwMkdX
         0zQTNhBxqzjzKFfr3+jEe8iuyfAYSCibYyetjVfbqT643mQ6D8kz5fpdAvH5CPzdmndx
         6PUQ==
X-Gm-Message-State: APjAAAWheTZbDLhplb0ftQD51SeyJZ582gBWtVfaexO9rtus6PmD2ras
        oV892dgRL8Kty1xuAb0GHHst0IsVKtVAXlSaIVQWZA==
X-Google-Smtp-Source: APXvYqxBerzT1ZqBOzBOAyNF3ApqIrdxasLtb/hADKeZCYK1xdi/dh8E32QNM/GxYXreQo6XUWYDsEzBBGld52ZpMsM=
X-Received: by 2002:a2e:6c15:: with SMTP id h21mr4030206ljc.10.1570669624673;
 Wed, 09 Oct 2019 18:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
 <CAADnVQ+XxmvY0cs8MYriMMd7=2TSEm4zCtB+fs2vkwdUY6UgAQ@mail.gmail.com>
 <3ED8E928C4210A4289A677D2FEB48235140134CE@fmsmsx111.amr.corp.intel.com>
 <2bc26acd-170d-634e-c066-71557b2b3e4f@intel.com> <CAADnVQ+qq6RLMjh5bB1ugXP5p7vYM2F1fLGFQ2pL=2vhCLiBdA@mail.gmail.com>
 <2032d58c-916f-d26a-db14-bd5ba6ad92b9@intel.com>
In-Reply-To: <2032d58c-916f-d26a-db14-bd5ba6ad92b9@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Oct 2019 18:06:53 -0700
Message-ID: <CAADnVQ+CH1YM52+LfybLS+NK16414Exrvk1QpYOF=HaT4KRaxg@mail.gmail.com>
Subject: Re: FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive
 packets directly from a queue
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 12:12 PM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
> >>     34.57%  xdpsock          xdpsock           [.] main
> >>     17.19%  ksoftirqd/1      [kernel.vmlinux]  [k] ___bpf_prog_run
> >>     13.12%  xdpsock          [kernel.vmlinux]  [k] ___bpf_prog_run
> >
> > That must be a bad joke.
> > The whole patch set is based on comparing native code to interpreter?!
> > It's pretty awesome that interpreter is only 1.5x slower than native x86.
> > Just turn the JIT on.
>
> Thanks Alexei for pointing out that i didn't have JIT on.
> When i turn it on, the performance improvement is a more modest 1.5x
> with rxdrop and 1.2x with l2fwd.

I want to see perf reports back to back with proper performance analysis.

> >
> > Obvious Nack to the patch set.
> >
>
> Will update the patchset with the right performance data and address
> feedback from Bjorn.
> Hope you are not totally against direct XDP approach as it does provide
> value when an AF_XDP socket is bound to a queue and a HW filter can
> direct packets targeted for that queue.

I used to be in favor of providing "prog bypass" for af_xdp,
because of anecdotal evidence that it will make af_xdp faster.
Now seeing the numbers and the way they were collected
I'm against such bypass.
I want to see hard proof that trivial bpf prog is actually slowing things down
before reviewing any new patch sets.
