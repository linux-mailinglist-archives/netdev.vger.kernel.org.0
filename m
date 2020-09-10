Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DC2264A1C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgIJQno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgIJQms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:42:48 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF88C061757;
        Thu, 10 Sep 2020 09:42:48 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id r7so4494754ybl.6;
        Thu, 10 Sep 2020 09:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ycqkFWOVlnIfs3VmekUMOaWZto+2dCay2MOdIsZx1iw=;
        b=QI0I1PxmSkONdonU6hSamdL3LIBCzXTloqLUCEDMcEBDtD55z8kTSCa4lNzJMC93wp
         IbWAnelGNkbfRQ02g3EUSMzdl7t1K2MfS700yqpnTG2pyAPMyCwWB7tDay6OT0sPJpQ6
         ik5xH2ASvXSHnID9AE+dUgyQ3z+ey0c/sBQmaqYblN+ykbgfcHAV/n9QMdciD5O6JBkJ
         dEbdaUMyyp9E+eS7ffRsWs5YNs54WJoRtvNCxqDsh2emthgSyeY0v13IL3UWrzTg6azR
         4/6cVbFaaEHTfsFfYMm+mIUO8Dzus6ctxpNDhdNFUYdPsOyFieC/Gz5stdz/ETN5u7i2
         HZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ycqkFWOVlnIfs3VmekUMOaWZto+2dCay2MOdIsZx1iw=;
        b=eBCoVm+mCGrZRH4OLpHsFClhrH15LrmPYKNWBvEFxDsW7QZ2BfN9fFVYSMywfmB+QO
         6uTDNrq7Nh8i556l8xk8G4ypmX8UWAXkRhWdCO4G7eckfor1zxGhUhcgKxg348EA7CVq
         fg3dxd+7bH4kU149QpCMNBW3yQn02Dd/HWo+tclIfA/jO5CdC1wK8MySko60vSpVziC7
         526kMPNGsccth2LnxSNSwW1ficmkjavAwIQrIPMoaY0RX1sKO5GojM+9kKZ3u4TNkcwe
         I8TmRYnbY9qSVv56s+M9s5Puyc30PfscRH0V+4u9qZ/tHyM/Ubz2eVXTVKvUwt266ByJ
         bYig==
X-Gm-Message-State: AOAM532KSj4VbNBJhYOvO2cOpKIhIxWTHJ7i1jbrd2K85bv9sbNf/1rN
        Q/HTj6VOx6zAkXQ9nM/q3GpEKtm0gZZ9gxBoOdc=
X-Google-Smtp-Source: ABdhPJy/2m/8Y9xSVgol1LFHnXk3pixrhwlgb4eVx7KYmGDaRWNtPIArxdlcupl+ku0AM+9O0s1TFE+v8+3CJF7oC+s=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr13903853ybg.425.1599756167642;
 Thu, 10 Sep 2020 09:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200910102652.10509-1-quentin@isovalent.com> <20200910102652.10509-3-quentin@isovalent.com>
In-Reply-To: <20200910102652.10509-3-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 09:42:36 -0700
Message-ID: <CAEf4BzZpp7Rfg5N-1G570NQ1FqKjthpeiuWkNUn-uXQv9Gx8Vg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] tools: bpftool: keep errors for
 map-of-map dumps if distinct from ENOENT
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 3:27 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> When dumping outer maps or prog_array maps, and on lookup failure,
> bpftool simply skips the entry with no error message. This is because
> the kernel returns non-zero when no value is found for the provided key,
> which frequently happen for those maps if they have not been filled.
>
> When such a case occurs, errno is set to ENOENT. It seems unlikely we
> could receive other error codes at this stage (we successfully retrieved
> map info just before), but to be on the safe side, let's skip the entry
> only if errno was ENOENT, and not for the other errors.
>
> v3: New patch
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/map.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index c8159cb4fb1e..d8581d5e98a1 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -240,8 +240,8 @@ print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
>          * means there is no entry for that key. Do not print an error message
>          * in that case.
>          */
> -       if (map_is_map_of_maps(map_info->type) ||
> -           map_is_map_of_progs(map_info->type))
> +       if ((map_is_map_of_maps(map_info->type) ||
> +            map_is_map_of_progs(map_info->type)) && lookup_errno == ENOENT)
>                 return;


Ah, ok, you decided to split it out into a separate patch. Ok.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
>         if (json_output) {
> --
> 2.25.1
>
