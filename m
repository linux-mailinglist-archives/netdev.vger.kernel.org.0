Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8873E571E2
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFZTjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:39:05 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46913 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZTjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 15:39:05 -0400
Received: by mail-lj1-f193.google.com with SMTP id v24so3400281ljg.13;
        Wed, 26 Jun 2019 12:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OwoNG4m2IYYirI4zXbKrZee7eUp1bry+PkusBaR3Dlo=;
        b=MNsjQlSgCbds+6S99N2n2hklQ7yir8++9bjKrVHcImHo6bMsr1Xq70HULt9e/Tpfev
         /YBvhWdWU+PaVd/dh/j38gIc19Xa/AqafHC9cgNRSSO287uXjuX4rZh4M4lzwyVSAVRk
         NVfp0T444rl0/ZQO66IPQxMO3uQhKRWCqxLpmzzpeV5/VQcDbBc/KG0Wnn/O6TQ6y1qN
         ARNrRwEmEKJg0cznYL8FCwhczdEC2EWEPur/9Nu7OaQTsTW/tkvCZKiH5KUe17hGXsYL
         n6KToTTNnwIEJWEx+nFcmx0+ep9sn4Sa5WdnYoyBYkU67SpDF9Q3Dl86S7r13Y0jitsy
         02xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OwoNG4m2IYYirI4zXbKrZee7eUp1bry+PkusBaR3Dlo=;
        b=G68sYAMEpnj5OuWQExyRizG2ZCh/6H+4jM0orGhTcce+wfdPaCjPLHnM22/QQgaGA9
         1Hsxh0N9z0z3DXv6C0nelB5h4fuIMYtLJpjnUr9BuLWA3w5lEoPuVa7xxTcLesv2JWaG
         G0kQk2z3ck7PVfhI0DWB0AhYUR7HsTX1arcA40xfZAbcMSX1scXcMPfJGZLHbZEQuhTn
         w3ox6dY49wLss6FHY3zYc85kWWo+4jCd3FWhFwqyqnIIc4uHkKRa6RJl2tZjylsEZ/px
         aqywrTjCHiFWWkK5QNZ+LiKWROAKBGyVW0ni//jQKe3wN/K0gmbnlTiXUsQdZXOgN6p8
         YCvA==
X-Gm-Message-State: APjAAAX7JH3//pF8FHWHAeAySxsCeDFm4uUxljDUpzKo77zC9H8zXQYR
        58PaJ050U89n2xMFCvSvwHFT8j0lspM2bZPdFrk=
X-Google-Smtp-Source: APXvYqyTgSuJ9l09zzVBv90eCkDdsdyNMDlOs1GtwSA+mEc9+my5ZocviC3yhybyQcr6TQZ/EAcpVyM117UzhUFti7M=
X-Received: by 2002:a2e:a311:: with SMTP id l17mr3917113lje.214.1561577938378;
 Wed, 26 Jun 2019 12:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <f0179a5f61ecd32efcea10ae05eb6aa3a151f791.camel@domdv.de>
 <CAADnVQLmrF579H6-TAdMK8wDM9eUz2rP3F6LmhkSW4yuVKJnPg@mail.gmail.com>
 <e9f7226d1066cb0e86b60ad3d84cf7908f12a1cc.camel@domdv.de> <CAADnVQKJr-=gZM2hAG-Zi3WA3oxSU_S6Nh54qG+z6Bi8m2e3PA@mail.gmail.com>
 <9917583f188315a5e6f961146c65b3d8371cc05e.camel@domdv.de> <CAADnVQKe7RYNJXRQYuu4O_rL0YpAHe-ZrWPDL9gq_mRa6dkxMg@mail.gmail.com>
 <CAADnVQ+wEdHKR2zR+E6vNQV_J8gfBmReYsLUQ2tegpX8ZFO=2A@mail.gmail.com> <20190618214028.y2qzbtonozr5cc7a@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190618214028.y2qzbtonozr5cc7a@ast-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 26 Jun 2019 12:38:46 -0700
Message-ID: <CAADnVQ+CPP+tFR_9fh-omxQoJXqkuz3OV-MDSqjEDsVGnMXi3A@mail.gmail.com>
Subject: Re: eBPF verifier slowness, more than 2 cpu seconds for about 600 instructions
To:     Andreas Steinmetz <ast@domdv.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Edward Cree <ecree@solarflare.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 2:40 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 17, 2019 at 11:26:28AM -0700, Alexei Starovoitov wrote:
> > On Sun, Jun 16, 2019 at 11:59 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, Jun 6, 2019 at 6:31 PM Andreas Steinmetz <ast@domdv.de> wrote:
> > > >
> > > > Below is the source in question. It may look a bit strange but I
> > > > had to extract it from the project and preset parameters to fixed
> > > > values.
> > > > It takes from 2.8 to 4.5 seconds to load, depending on the processor.
> > > > Just compile and run the code below.
> > >
> > > Thanks for the report.
> > > It's interesting one indeed.
> > > 600+ instructions consume
> > > processed 280464 insns (limit 1000000) max_states_per_insn 15
> > > total_states 87341 peak_states 580 mark_read 45
> > >
> > > The verifier finds a lot of different ways to go through branches
> > > in the program and majority of the states are not equivalent and
> > > do not help pruning, so it's doing full brute force walk of all possible
> > > combinations.
> > > We need to figure out whether there is a way to make it smarter.
> >
> > btw my pending backtracking logic helps it quite a bit:
> > processed 164110 insns (limit 1000000) max_states_per_insn 11
> > total_states 13398 peak_states 349 mark_read 10
> >
> > and it's 2x faster to verify, but 164k insns processed shows that
> > there is still room for improvement.
>
> Hi Andreas,
>
> Could you please create selftests/bpf/verifier/.c out of it?
> Currently we don't have a single test that exercises the verifier this way.
> Could you also annotate instructions with comments like you did
> at the top of your file?

Andreas, ping.

> The program logic is interesting.
> If my understanding of assembler is correct it has unrolled
> parsing of ipv6 extension headers. Then unrolled parsing of tcp options.
> The way the program is using packet pointers forces the verifier to try
> all possible combinations of extension headers and tcp options.
>
> The precise backtracking logic helps to reduce amount of walking.
> Also I think it's safe to reduce precision of variable part
> of packet pointers. The following patch on top of bounded loop
> series help to reduce it further.
>
> Original:
>   processed 280464 insns (limit 1000000) max_states_per_insn 15
>   total_states 87341 peak_states 580 mark_read 45
>
> Backtracking:
>   processed 164110 insns (limit 1000000) max_states_per_insn 11
>   total_states 13398 peak_states 349 mark_read 10
>
> Backtracking + pkt_ptr var precision:
>   processed 96739 insns (limit 1000000) max_states_per_insn 11
>   total_states 7891 peak_states 329 mark_read 10
>
> The patch helps w/o backtracking as well:
>   processed 165254 insns (limit 1000000) max_states_per_insn 15
>   total_states 51434 peak_states 572 mark_read 45
>
> Backtracking and bounded loop heuristics reduce total memory
> consumption quite a bit. Which was nice to see.
>
> Anyway would be great if you could create a test out of it.
> Would be even more awesome if you convert it to C code
> and try to use bounded loops to parse extension headers
> and tcp options. That would be a true test for both loops
> and 'reduce precision' features.
>
> Thanks!
>
> From 4681224057af73335de0fdd629a2149bad91d59d Mon Sep 17 00:00:00 2001
> From: Alexei Starovoitov <ast@kernel.org>
> Date: Tue, 18 Jun 2019 13:40:29 -0700
> Subject: [PATCH bpf-next] bpf: relax tracking of variable offset in packet pointers
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/verifier.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index d2c8a6677ac4..e37c69ad57b3 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3730,6 +3730,27 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
>                         dst_reg->id = ++env->id_gen;
>                         /* something was added to pkt_ptr, set range to zero */
>                         dst_reg->raw = 0;
> +                       if (bpf_prog_is_dev_bound(env->prog->aux))
> +                               /* nfp offload needs accurate max_pkt_offset */
> +                               break;
> +                       if (env->strict_alignment)
> +                               break;
> +                       /* scalar added to pkt pointer is within BPF_MAX_VAR_OFF bounds.
> +                        * 64-bit pkt_data pointer can be safely compared with pkt_data_end
> +                        * even on 32-bit architectures.
> +                        * In case this scalar was positive the verifier
> +                        * doesn't need to track it precisely.
> +                        */
> +                       if (dst_reg->smin_value >= 0)
> +                               /* clear variable part of pkt pointer */
> +                               __mark_reg_known_zero(dst_reg);
> +                               /* no need to clear dst_reg->off.
> +                                * It's a known part of the pointer.
> +                                * When this pkt_ptr compared with pkt_end
> +                                * the 'range' will be initialized from 'off' and
> +                                * *(u8*)(dst_reg - off) is still more than packet start,
> +                                * since unknown value was positive.
> +                                */
>                 }
>                 break;
>         case BPF_SUB:
> --
> 2.20.0
>
