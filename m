Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929AB5F5F79
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiJFDVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiJFDUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:20:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967D6E088;
        Wed,  5 Oct 2022 20:19:45 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id nb11so1716629ejc.5;
        Wed, 05 Oct 2022 20:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iDHLLKlSypqD+J8PK0P5L1xfKl16x6IAUcLIzCJif/8=;
        b=NfJK2XgxsyZGQUZ6qSRCNfpCFxEYdmZ0qYHRvJFh8/GYKypZGNsxGhYRViE2F0QoXy
         FfcArknFk9kJ2obMcH1y+BPv/TirAONv592mZtTCiarSekBfyOSPXCb5q+EyTZeSxQTO
         yvCvhNQsPoMvKs4LPXAnrtlvPA7mE5zVpzgmYdKbFLUkN+xqDPIWsLQ3EFQS0WWlBAvj
         UOeAczymh74Sn9xkk0ZOPF8yGCEkfisL9FDA1Byy8w5wyRkpHgg+bpFYuFAkgBCNTReO
         OOJ121VN1/XJUpoBwNpRWG0zlVMIlF0644xb07IeX9B2Sq9lQCIqXOa7SUtWTQeHdg/p
         ppFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iDHLLKlSypqD+J8PK0P5L1xfKl16x6IAUcLIzCJif/8=;
        b=RMpkF8LejWVkQ7D/ftfB18qTHYZ/VfnLIqYzxYVR6hZVycJtCFRYnAbxbRUCz1iFHE
         gkIHEcoFokOvsExuFZ6BPaFCWmTa+Fjj5wRScr+n8YSG5o39gbSzoHF2noCO194idRVl
         nQPKGe1uwA/GSI30AEs+vB2BXa+qvCef8SqYQy7iXpxuNLMFklBP1MrEYk6nlzKz/X9U
         m4rzRecug99X0cvzqo24MdDX/cT0qO1FqmUh45f6oDnOIY6HeKcuvpj+YPiKldkkhJJ8
         CSC7jsqPbLLAVkTt2mtZAusUNRdfKqMOBRndLwbVamuuf0Vl9OzMtU+fhLNYEzwbGgyD
         XjoQ==
X-Gm-Message-State: ACrzQf2sCTum0QNyThWc+COHc8U1GicQvwvk90q6xCp1hYEhqjMAZzPi
        fq65znN5nUs3SHsabMkMp7Ua4xvNyCxhqWwhol0=
X-Google-Smtp-Source: AMsMyM4kVyPzZulOd3JIdcRgIr33fJH3yGueYIK1L+x8mx+i4UjxpHZ7k4w5FrJHhD54irPcOADopFE6AaA28DrvE+k=
X-Received: by 2002:a17:906:5a4c:b0:78c:c893:74e6 with SMTP id
 my12-20020a1709065a4c00b0078cc89374e6mr2216382ejc.545.1665026383497; Wed, 05
 Oct 2022 20:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-5-daniel@iogearbox.net>
In-Reply-To: <20221004231143.19190-5-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Oct 2022 20:19:30 -0700
Message-ID: <CAEf4Bzbq=p=yqW1nqCT2mA-jRHvNBh=Gd9sci4=LsfS25XXQqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 04/10] bpf: Implement link introspection for tc
 BPF link programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 4, 2022 at 4:12 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Implement tc BPF link specific show_fdinfo and link_info to emit ifindex,
> attach location and priority.
>
> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

LGTM

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/uapi/linux/bpf.h       |  5 +++++
>  kernel/bpf/net.c               | 36 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  5 +++++
>  3 files changed, 46 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c006f561648e..f1b089170b78 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6309,6 +6309,11 @@ struct bpf_link_info {
>                 struct {
>                         __u32 ifindex;
>                 } xdp;
> +               struct {
> +                       __u32 ifindex;
> +                       __u32 attach_type;
> +                       __u32 priority;
> +               } tc;
>         };
>  } __attribute__((aligned(8)));
>

[...]
