Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD37FD343
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 04:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKODXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 22:23:50 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46010 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfKODXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 22:23:50 -0500
Received: by mail-pf1-f196.google.com with SMTP id z4so5657915pfn.12;
        Thu, 14 Nov 2019 19:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mc9ObuKZI129W8OSfy3VEYUS0DDz4uy5r2u0ZDpAVtk=;
        b=bVfxmkS1boVUkiynerVs4TW6Da1TBNqMIDoN0ev79uPhJvX08WefcrNTMpXSvxkd5B
         rJqRPvIzeeiU+I5TTqrLVOvtyaTphrPdiFHfsC6FSUgmaTJCwbWBicc5mINq3SbF/2m4
         ABd53qScBP8AM3WfeFKtQIQ2WDrSl10PyyvPo9Gy7W9RrnATEHXXyDprutAtlxhhs2xG
         qqrz/27pnEfGIkqC0wkoB43/LVYmOtbrLpApnLbOPzSM2LV/MeptsM2Xo2mlqT27Fmil
         jcyXgnAIX4gYmVFKO20GWgEGr18w76Qm2+SfMmRgPRz/9aFrCnBtqJzXBvYdZZ98T8M6
         anug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mc9ObuKZI129W8OSfy3VEYUS0DDz4uy5r2u0ZDpAVtk=;
        b=i+Zrp5/6IvH5HvkCUtIiDD4poyhTqN0QzotiKr//ESftTkMA+26VyrAjSyc1s7eLsY
         7kDwsPXYfZ6jDTUyWUozzfFR8W1HbZOx+YelnCSl05oDNHT5GAfDRmYQRiM6E7tGpuFB
         62UAtaUcmVZulzSGOQJCI2iremPtYvGyVBXmiZ+ZuWcwo6O9T14FSHmSRTV7X8nQggos
         9lEzd4MI+Yoo46mHLQ31fP2VrNmSwdRCZLeiu7RHc6bDr9Bsdsa01WagI2PRzv0asgqo
         JxNXSK/y86G4G1RDrIZb5P7kNn+YLr/nLrxAHPB6rcZaHhAiX4l3BibP8DsOXFvwMOMs
         iKcA==
X-Gm-Message-State: APjAAAU3U2VgUBoV4wDvNwuX0rulOi0x/JAs+sOTdimE2mvnmniHYg9n
        G3MLQ4dOL/EafUPHpcNdUDE=
X-Google-Smtp-Source: APXvYqyuAf6dvTW+dhuK2J1TbuNaJ/JMPCB6e+aHJU8fAN5/JOIxhGx5+AzZfIqItKPtiB90IZAClA==
X-Received: by 2002:a63:115c:: with SMTP id 28mr13765973pgr.6.1573788229212;
        Thu, 14 Nov 2019 19:23:49 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::6ab4])
        by smtp.gmail.com with ESMTPSA id k32sm8165332pje.10.2019.11.14.19.23.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 19:23:48 -0800 (PST)
Date:   Thu, 14 Nov 2019 19:23:46 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH rfc bpf-next 7/8] bpf, x86: emit patchable direct jump as
 tail call
Message-ID: <20191115032345.loei6qqgyo4tdbuq@ast-mbp.dhcp.thefacebook.com>
References: <cover.1573779287.git.daniel@iogearbox.net>
 <78a8cbc4887d00b3dc4705347f05572630650cbf.1573779287.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78a8cbc4887d00b3dc4705347f05572630650cbf.1573779287.git.daniel@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 02:04:01AM +0100, Daniel Borkmann wrote:
> for later modifications. In ii) fixup_bpf_tail_call_direct() walks
> over the progs poke_tab, locks the tail call maps poke_mutex to
> prevent from parallel updates and patches in the right locations via
...
> @@ -1610,6 +1671,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  		prog->bpf_func = (void *)image;
>  		prog->jited = 1;
>  		prog->jited_len = proglen;
> +		fixup_bpf_tail_call_direct(prog);

Why not to move fixup_bpf_tail_call_direct() just before
bpf_jit_binary_lock_ro() and use simple memcpy instead of text_poke ?

imo this logic in patch 7:
case BPF_JMP | BPF_TAIL_CALL:
+   if (imm32)
+            emit_bpf_tail_call_direct(&bpf_prog->aux->poke_tab[imm32 - 1],
would have been easier to understand if patch 7 and 8 were swapped.

