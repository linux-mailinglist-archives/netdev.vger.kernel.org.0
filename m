Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA3E1D0528
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 03:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbfJIBU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 21:20:29 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36517 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbfJIBU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 21:20:29 -0400
Received: by mail-lf1-f65.google.com with SMTP id x80so317251lff.3;
        Tue, 08 Oct 2019 18:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KRbyZ0tnPi87vldaS6TRo3OVlH9+jJXwmzcjg+fajFI=;
        b=RLDbT01Soq8xaedkXvqavUy2kovalgrmYNgNt6lgdg0CeGi1kQC7Q6+QIdBFiQ01IV
         WurQol67uJqGzy6NVny/BCglnu97QKP8EHa8lrKwEYx5Kz2C8n9PisJ1c8wX7pZdx0m+
         Z3wgtwESsdssOkuoZtZoKsDoGJjRZ3lzdar4LgX3bZBTX/DQZMMdc0qGUrzQrnl6STma
         aW/i3idyR+J2cbwhQvT2wYZdLdtWA7XDj/SQxYnLissnoLmgAKB9GfL0g+8fqs/XNHSc
         nLlO7ggByTu3lx/nCNxuCwCbXESU6N1IH7B+Mf2ZtDRsZz/CaljXFRsNSgJS1Taopt6T
         FmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KRbyZ0tnPi87vldaS6TRo3OVlH9+jJXwmzcjg+fajFI=;
        b=r1kThZUi1h1hehdZb22Dx9LvEhsWrhVHZamXl/kYsMSgvacIQIpDbQEsPksnGGBPuw
         9FHjnoY3oIQjgP9lpNPUE5odts7j3LPIeA+aPJngFy+YnAfoXTOSislqrzGoKXv4DSbF
         Qoxq9KCxtEp110+TNPtxNpBOnLikOkSfMEzATfDVzYuduJfrFxgCuy+MsdHD5VolIL4g
         3TRvc++hanYY/o9Dx47Pb0E5oYjTSRhKWlbL+2EmCe9ofPYPJL4hsWaNbFmbg59gnE1Q
         l1FL2+FxvXOm2HHXmbPr8d1d5a/YqV5sBTsS14XG3UmSgrlBQ6UGZtGNfju+Wyj059Ji
         Kw8A==
X-Gm-Message-State: APjAAAUa+JYDOiJdZVVGoYfp6HiHcPPsHBRx/sacRTOR3Kn0xvxTNTMM
        o9ul/XGPLvfg0OlQhEW4btzZNKRRAD/Ev9dWww5Z8x0V
X-Google-Smtp-Source: APXvYqxBsM4HbtSkY3oBR7IDs8AZltgg36Y+uP4V36t+qJoTZS0sIl2f0CXoFqpKButEOZ8ZtyQktJhIXHUWDth1H9o=
X-Received: by 2002:a19:4f06:: with SMTP id d6mr358251lfb.15.1570584026847;
 Tue, 08 Oct 2019 18:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com> <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
In-Reply-To: <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 8 Oct 2019 18:20:15 -0700
Message-ID: <CAADnVQ+XxmvY0cs8MYriMMd7=2TSEm4zCtB+fs2vkwdUY6UgAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive packets
 directly from a queue
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 11:18 PM Sridhar Samudrala
<sridhar.samudrala@intel.com> wrote:
> +
> +u32 bpf_direct_xsk(const struct bpf_prog *prog, struct xdp_buff *xdp)
> +{
> +       struct xdp_sock *xsk;
> +
> +       xsk = xdp_get_xsk_from_qid(xdp->rxq->dev, xdp->rxq->queue_index);
> +       if (xsk) {
> +               struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> +
> +               ri->xsk = xsk;
> +               return XDP_REDIRECT;
> +       }
> +
> +       return XDP_PASS;
> +}
> +EXPORT_SYMBOL(bpf_direct_xsk);

So you're saying there is a:
"""
xdpsock rxdrop 1 core (both app and queue's irq pinned to the same core)
   default : taskset -c 1 ./xdpsock -i enp66s0f0 -r -q 1
   direct-xsk :taskset -c 1 ./xdpsock -i enp66s0f0 -r -q 1
6.1x improvement in drop rate
"""

6.1x gain running above C code vs exactly equivalent BPF code?
How is that possible?
