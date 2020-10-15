Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA0B28EC40
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 06:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgJOE10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 00:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOE10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 00:27:26 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3DDC061755;
        Wed, 14 Oct 2020 21:27:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id m17so2701703ioo.1;
        Wed, 14 Oct 2020 21:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=LCERxGqejh903CR7cZgKEZSOiAf3PIdgaWA3aew0Kec=;
        b=kFffPhdY2L9eRXkNAhbCQY/LYjU0KqsRRgXyk31EwAMYPtmza96lp5KHII63E2HNxM
         9iG6lRvNCxgnJQjcwPiMiW/UBpC3BXVxgnW2VBB7a8Y1Dt4XTxX4NgobdEI0AmZG2Zmo
         nZ0vmmFsQ69G/lB/CeQW2yjW679MJNZuA+lnw/TvJnDSCYhkbqJUdTpUNgEWGQUcYgv4
         NezrioNaF0BAS7envo0Jks+KvMY/a4uTQwxxeZpdBp/vKNsJIA9AZZtA8q5YXK50pyep
         jlF9lSd0HYFUkZ4YSuopOn2q1oCK04Sta/xSbBCKqExYn0Sefusn0BLQKw1BzckeZbbO
         WT+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=LCERxGqejh903CR7cZgKEZSOiAf3PIdgaWA3aew0Kec=;
        b=Y9jzXm05jmJYxwHpD5XqZTDLVn6f1wrXhkUCoMcJVrgHTIGw4uvhkx+klFRWAf9/dt
         uMboBxUMNCglBNU0tT3Q2JoAiUuSYsFv1Te321BtOmwACU4q42eMMQ6mfYWNFuUlOee5
         YuD9qfl0TK+22inh38fFmXkaMS6GA8M+v5CD8Fdmd3c/hjDyMY62Tw9V8hoETffay9Yk
         UAFAGH2c6nuHk7JoV++nXnVm1FrAc77VrtQAJ/EKAIwRxuRbWc1bqp1U2QNavZEmWl01
         8IhmA3VsbiJ/3peM0FXa0b7Ic4+OvHxr2LTaTzCY2IHG7RxdNWA7n4eui42PjBxHRE+q
         LGpQ==
X-Gm-Message-State: AOAM5324Rs7asmqa9JhqiHFOH3FxwRv73A4cDYm42dO4XfrJP7CJndpD
        xijVpN+Q4kcZDUjPw46JMri5jhohGgw=
X-Google-Smtp-Source: ABdhPJzjDXDL1g9h0rUocXMi2MAg/sOKL5JU2wqNq3mTWmz0HTnBWeC1ro9JQTK5mbx+LyX18X/KjQ==
X-Received: by 2002:a6b:b7cc:: with SMTP id h195mr1881715iof.122.1602736045354;
        Wed, 14 Oct 2020 21:27:25 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 18sm1406903ilg.3.2020.10.14.21.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:27:24 -0700 (PDT)
Date:   Wed, 14 Oct 2020 21:27:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <5f87cfa5b1a77_b7602087e@john-XPS-13-9370.notmuch>
In-Reply-To: <20201015041952.n3crk6kvtbgev6rw@ast-mbp.dhcp.thefacebook.com>
References: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
 <CAEf4BzaF2fDWoRg8h3dUKftvcastYqzEhGS2TG6MoV462fd_8Q@mail.gmail.com>
 <5f87ca47436f3_b7602088f@john-XPS-13-9370.notmuch>
 <20201015041952.n3crk6kvtbgev6rw@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next] bpf: Fix register equivalence tracking.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Wed, Oct 14, 2020 at 09:04:23PM -0700, John Fastabend wrote:
> > Andrii Nakryiko wrote:
> > > On Wed, Oct 14, 2020 at 10:59 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > From: Alexei Starovoitov <ast@kernel.org>
> > > >
> > > > The 64-bit JEQ/JNE handling in reg_set_min_max() was clearing reg->id in either
> > > > true or false branch. In the case 'if (reg->id)' check was done on the other
> > > > branch the counter part register would have reg->id == 0 when called into
> > > > find_equal_scalars(). In such case the helper would incorrectly identify other
> > > > registers with id == 0 as equivalent and propagate the state incorrectly.
> > 
> > One thought. It seems we should never have reg->id=0 in find_equal_scalars()
> > would it be worthwhile to add an additional check here? Something like,
> > 
> >   if (known_reg->id == 0)
> > 	return
> >
> > Or even a WARN_ON_ONCE() there? Not sold either way, but maybe worth thinking
> > about.
> 
> That cannot happen anymore due to
> if (dst_reg->id && !WARN_ON_ONCE(dst_reg->id != other_branch_regs[insn->dst_reg].id))
> check in the caller.
> I prefer not to repeat the same check twice. Also I really don't like defensive programming.
> if (known_reg->id == 0)
>        return;
> is exactly that.
> If we had that already, as Andrii argued in the original thread, we would have
> never noticed this issue. <, >, <= ops would have worked, but == would be
> sort-of working. It would mark one branch instead of both, and sometimes
> neither of the branches. I'd rather have bugs like this one hurting and caught
> quickly instead of warm feeling of being safe and sailing into unknown.

Agree. Although a WARN_ON_ONCE would have also been caught.
