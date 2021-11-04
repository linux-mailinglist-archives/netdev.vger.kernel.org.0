Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E92E444DED
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 05:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhKDE37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 00:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhKDE36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 00:29:58 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A35AC061714;
        Wed,  3 Nov 2021 21:27:21 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s24so5281514plp.0;
        Wed, 03 Nov 2021 21:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xazu9T8/fXFMQx7kIFO5pn1oRXwl4mgPzYvoShItQvU=;
        b=Vdfon3zvDFBy676XiSF1fJDP4z4UJq0DC9nMrP4kq0khVZdVlIjXqWnT6e0aY38Qwz
         FicgbRBxyQHnv0pUIb1cwxKfVeCqE502Eg3JTaWHoeHG523LFbG6sE7aplkvMxFS9Nr3
         FKWQehtAHcDyuF76yEAN9TbwzKRiSSOQ5ut1EopypYbTYtbi2VWx/TQGmeWw3Ag1uQwn
         ZVTXmV8b6j+FpykQ3/23bVHzEu/J+02OyIUivVkBGp3H7RvErlvffiB2SBF/WdY4LzNB
         BQu5FsyPgS80z5khlnHAvCiKPNqe1Vf8bvz7EHaaZkhCBgiyLJOYZgdPjsh8pxqKmB2W
         YVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xazu9T8/fXFMQx7kIFO5pn1oRXwl4mgPzYvoShItQvU=;
        b=mPloU3U26R7lt3ZnQyfpKtbyxvY/PEPR9JbL7JqPtx0ZLijKTEFpF+eGf8eLNUMVcX
         t0jyQIh92DhB4rsicdqUN/53r3HhNFY5okxnAzShjFygznhj2GGClhUipEIuxjYmn5CO
         O7Cd+Tj6HSCyn6F0jcL02B3/5D5EcvsIbI9v4PaAVTEWDT40EDupHx2ppCC51+reWjFo
         9Vkf5h+G530i9oii5D94Fd0h+Wm1sCKXkHEQaG+O6pLF7nMeUgtYEm6ppv4flF53ZwLc
         4c2OezZO5isT9ehAAF61LDFIw6Rb/JdfA4RgC3mFPApbzeFx4BtNwO72Egu0JrVFP8CQ
         vhsQ==
X-Gm-Message-State: AOAM532eZS83Ptl00SbAoE9Y/TF3E+RYW2KVCpoYqu754RqIgfixwhIP
        2J/ynP/AhTlylIG73mh+JZUIY+koAdS1ENKS9j8=
X-Google-Smtp-Source: ABdhPJzL4j9WN4NkzD8uDrzHQJrIvo2ddgyv0tScDmdKS7hoQtvN9N7OQxAZi22WjAwLMP1Qg9trqnmJFDGsh8lTpdE=
X-Received: by 2002:a17:90a:17a5:: with SMTP id q34mr19378134pja.122.1636000040856;
 Wed, 03 Nov 2021 21:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
 <20211103001245.muyte7exph23tmco@ast-mbp.dhcp.thefacebook.com>
 <fcec81dd-3bb9-7dcf-139d-847538b6ad20@fb.com> <CAN22DihwJ7YDFSPk+8CCs0RcSWvZOpNV=D1u+42XabztS6hcKQ@mail.gmail.com>
 <CAADnVQJ_ger=Tjn=9SuUTES6Tt5k_G0M+6T_ELzFtw_cSVs83A@mail.gmail.com> <55c95c15-ccad-bb31-be87-ad17db7cb02a@fb.com>
In-Reply-To: <55c95c15-ccad-bb31-be87-ad17db7cb02a@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 3 Nov 2021 21:27:09 -0700
Message-ID: <CAADnVQ+62fOzO8nS_rbTqkFtfWGj06bT1XDUFhdAxY8Lx3OR4g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/3] Introduce BPF map tracing capability
To:     Yonghong Song <yhs@fb.com>
Cc:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 9:23 PM Yonghong Song <yhs@fb.com> wrote:
>
> I checked with a few llvm compiler engineers in Facebook.
> They mentioned there is nothing preventing compiler from doing
> optimization like poking inside the noinline function and doing
> some optimization based on that knowledge.

Interesting. Thanks for digging in.
Good to know!
