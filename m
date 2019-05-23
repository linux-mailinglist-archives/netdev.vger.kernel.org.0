Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB0F28BB3
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388288AbfEWUmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:42:49 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42479 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388256AbfEWUmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:42:46 -0400
Received: by mail-pg1-f193.google.com with SMTP id 33so766481pgv.9;
        Thu, 23 May 2019 13:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xDSImwvg9ldfjYdR+/w2XlZgxjHNwdCvvVsI912LKls=;
        b=NPodfj35SL4Vjcp0LFsuY22e1p6dgmX/gWhOwNAvjwWDelpdeg0qL5krgzWdMY+HdK
         W85cipvVZ3AiphSLvjC1bY4pFImN1PWUS0/yGaB3Vf3WgaSNijQw01wSC0X4xK3yrbOS
         QMwklU8GP+2O1CCAHPblv70qopR29huGK6Ui3KTuZyZDbSW/W+CROvjJzrWQbCd4Tbhp
         KLTzUI+MT+nATn1UV1Bzeu0at91vdqiKzpOCFHx7fOAMCETg3gMj8a72Z9bYpn48saW7
         CSHCXHg8PVXYLFiEb5kcDSUZS+rJbpYSJr/ArmHyC4Ng4sK7aRQeByz68lTpbt+sYJSR
         55AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xDSImwvg9ldfjYdR+/w2XlZgxjHNwdCvvVsI912LKls=;
        b=oHFy3VteamScAqNX3nHjWSylFILkPUTg7N7vF36JSzEjs3ni3HglVdyBn6vnDYATfK
         pFyDeMbvHyS344/V5kGu+6qFamSW7+DthqbQTJGCpzC6m9cPJiuWKyLgh2foTFlvpHZI
         C3d4VPzy4EhQ3U4QtlqGyGwxwnofZ6gqAan/hyrIplxUacnFVggYIcaKIHjfU7nW0/FM
         bwI4fP12dWU8cAy33SezOOkPcR/vTYjYMdtUBFkUcayRJ6o4HLH/GE2SWg8nr8//hURt
         9HjiwEZEEt8e26UGzuT2tXBMOUGLIw4d8WGKkvi98HxVZQZld15p5K8nu2ddODVWUJfM
         7f+w==
X-Gm-Message-State: APjAAAV8cqnCTImUwjf49eh8bkDxOguFeIDmFCcrg/wI5FpCXmH0DlJb
        qil29x95wHcSLbKL6njTBuk=
X-Google-Smtp-Source: APXvYqySLj3uOg01XkiNbxnBt6a/vg3kd/r9XeAat/OPlpUP8SQyyKDl/hgby621y0OTmGuOLYdU1g==
X-Received: by 2002:aa7:8acb:: with SMTP id b11mr106573588pfd.115.1558644165653;
        Thu, 23 May 2019 13:42:45 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:d5a9])
        by smtp.gmail.com with ESMTPSA id j64sm349783pfb.126.2019.05.23.13.42.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 13:42:44 -0700 (PDT)
Date:   Thu, 23 May 2019 13:42:43 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        davem@davemloft.net, paul.burton@mips.com, udknight@gmail.com,
        zlim.lnx@gmail.com, illusionist.neo@gmail.com,
        naveen.n.rao@linux.ibm.com, sandipan@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH v7 bpf-next 01/16] bpf: verifier: mark verified-insn with
 sub-register zext flag
Message-ID: <20190523204241.b5m2j5ff7gethkhc@ast-mbp.dhcp.thefacebook.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
 <1558551312-17081-2-git-send-email-jiong.wang@netronome.com>
 <20190523020757.mwbux72pqjbvpqkh@ast-mbp.dhcp.thefacebook.com>
 <B9C052B7-DFB9-461A-B334-1607A94833D3@netronome.com>
 <20190523161601.mqvkzwjegon2cqku@ast-mbp.dhcp.thefacebook.com>
 <87h89kkjnk.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h89kkjnk.fsf@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 09:20:15PM +0100, Jiong Wang wrote:
> 
> Alexei Starovoitov writes:
> 
> <snip>
> 
> > well, it made me realize that we're probably doing it wrong,
> > since after calling check_reg_arg() we need to re-parse insn encoding.
> > How about we change check_reg_arg()'s enum reg_arg_type instead?
> 
> This is exactly what I had implemented in my initial internal version.

it was long ago :) shrinkers purged it.

> > The caller has much more context and no need to parse insn opcode again.
> 
> And I had exactly the same thoughts, is_reg64 is duplicating what has been
> done.
> 
> The code evolved into the current shape mostly because I agreed if we
> re-centre all checks inside check_reg_arg, then we don't need to touch
> quite a few call sites of check_reg_arg, the change/patch looks simpler,
> and I was thinking is_reg64 is a quick check, so the overhead is not big.
> 
> > Something like:
> > enum reg_arg_type {
> >         SRC_OP64,        
> >         DST_OP64,       
> >         DST_OP_NO_MARK, // probably no need to split this one ?
> >         SRC_OP32,      
> >         DST_OP32,      
> > };
> >
> 
> Yeah, no need to split DST_OP_NO_MARK, my split was
> 
> enum reg_arg_type {
>    SRC_OP,
> +  SRC32_OP,
>    DST_OP,
> +  DST32_OP,
>    DST_OP_NO_MARK 
> }
> 
> No renaming on existing SRC/DST_OP, they mean 64-bit, the changes are
> smaller, looks better?
> 
> But, we also need to know whether one patch-insn define sub-register, if it
> is, we then conservatively mark it as needing zero extension. patch-insn
> doesn't go through check_reg_arg analysis, so still need separate insn
> parsing.

Good point.
Then let's stick with your last is_reg64().
Re-parsing is annoying, but looks like there is already use case for it
and more can appear in the future.

