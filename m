Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264651CB6C1
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgEHSM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgEHSMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:12:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31749C061A0C;
        Fri,  8 May 2020 11:12:25 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k1so2965061wrx.4;
        Fri, 08 May 2020 11:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wEg6363KALMCBQBSLOKuoUfGPXNIfqB9uH8JLDVOLn8=;
        b=jiGw8gA/+KtDlxEler0Ln+sRm7LZ0ILtePjxlryhRiAgy+Hn1zPTOXFwwA455LXmq5
         thSrJhUKnJQBcAYl3wzWZn+6B8ok+d37y+CZbsV47VN3uzanc+KEwvaz9So+sDWrYyPJ
         z+FfYIzGvDOOQxGCx0O8u5hV1g/S7u0/kWQy/+m4wiGKcECubtCEdnHyzS947HDf+PYh
         URXcx5SCg1ypxIfGnKD0wHDvo60V6ks30VsZ1JExOfmMrd+nBzyt7lGTFgDLzUwfzfEm
         e8nkEJr1NgWM/VFqatr4n4e++zyDatXKOIRvVqIyvHCW5rUjWs9raS+lxg4TQm4b4O0G
         PqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wEg6363KALMCBQBSLOKuoUfGPXNIfqB9uH8JLDVOLn8=;
        b=tY8lEYGaTZKJ9jdUnkmWGKmS2uYzex9OQEfPceh+w7PlkLGuSD2L7GT1xN1LwQhZBH
         ZVytWxokukBC5VxVNvnc9SGoIeKIcfUx5475GxEBzcE59Fkj2h1ZmMeizkpUyGFSFVPG
         DcQDbHEbR22BQbCjE86kULIlp+jnMNADn2Hsbf42xmONxKG0D5pLssqZWWwoRnLZGhVU
         3wcLV/iGVih60e+aNlnuWdFDojd/D2uz+1NLmSgMpBpsrJtNiCI5PtppJjNqFO07GvEh
         Kzm5aFnfnreyV0jBkj95iX54Pn4lURHtU+E7S8aJK0A2hWlkb5k1j67hloR2u4xSeUCw
         qmrg==
X-Gm-Message-State: AGi0PubCZyd37fdGBBSIZZzdS7bgPhbk2jCCr953uiTltG+l0nO4RP8D
        Ow5CSbuDylUNjXtG9XXPambyVD1BOSv/jsGsAI8=
X-Google-Smtp-Source: APiQypJ1418d0usqdIDaEoMJ9S+Dht8dlCaR0LS0UZ1UTm9QxdH2D6YM5JrcYaXtjH+tKEvB0V0bS+J5tYCvdGie2SI=
X-Received: by 2002:adf:8401:: with SMTP id 1mr4356440wrf.241.1588961543855;
 Fri, 08 May 2020 11:12:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200507010504.26352-1-luke.r.nels@gmail.com> <20200507010504.26352-2-luke.r.nels@gmail.com>
 <20200507082934.GA28215@willie-the-truck> <20200507101224.33a44d71@why>
 <CAB-e3NRCJ_4+vkFPkMN67DwBBtO=sJwR-oL4-AozVw2bBJHOzg@mail.gmail.com> <20200508114709.GB16247@willie-the-truck>
In-Reply-To: <20200508114709.GB16247@willie-the-truck>
From:   Luke Nelson <luke.r.nels@gmail.com>
Date:   Fri, 8 May 2020 11:12:12 -0700
Message-ID: <CAB-e3NQLuaHLxNB3Zpgy8EqyiZBqEYGzh1TSzXQe++nqPu2oLg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/3] arm64: insn: Fix two bugs in encoding
 32-bit logical immediates
To:     Will Deacon <will@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Luke Nelson <lukenels@cs.washington.edu>,
        bpf <bpf@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

On Fri, May 8, 2020 at 4:47 AM Will Deacon <will@kernel.org> wrote:
>
> Yes, please! And please include Daniel's acks on the BPF changes too. It's a
> public holiday here in the UK today, but I can pick this up next week.

Thanks!

> Nice! Two things:
>
> (1) I really think you should give a talk on this at a Linux conference

That would be great, I'd be happy to give a talk on our verification
work some time in the future :)

> (2) Did you look at any instruction generation functions other than the
>     logical immediate encoding function?

Other instruction generation functions are on our todo list, but we
haven't got a chance to spend more time on them yet.

Thanks again,

- Luke
