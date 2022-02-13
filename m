Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B0B4B3B21
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 12:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbiBML3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 06:29:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiBML3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 06:29:11 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4C05B3FD;
        Sun, 13 Feb 2022 03:29:06 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id b35so12193228qkp.6;
        Sun, 13 Feb 2022 03:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nA6dswK3YIP8flB00lSD686rSzXNLnaVDw4nKHumt3o=;
        b=b8lDPbsFDA6vIfzpMAHoWu7bnTx1SnjGGh7tWGKfw8ar0hR0+tQ31PFAa7vu3+Ee98
         2u1qJvRn1PZlpF1X/BQMtBSwj1vsp7y744P1AfU/H3/kKPE0mdhl3+187uOZX57Cz5hq
         wy7LznOu84X/PtTDp/Nqq5ZmXwJzueWWqMkn9xRdp+T0i5b+feeNaO8ZysYLd/9Mb6/M
         l4DKZOUh0JO9YjUN0Kle1qKzKR5wqEG+mL7a7BgnsikobzL/uSHX+wLyMhtyiTgQdYWA
         qjZGELJ9sZDj1GGAB7P8lCtKFr8C737rufeGKfJklWfCcJuTAaeNLtgeIpzrZmuUZpHL
         fPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nA6dswK3YIP8flB00lSD686rSzXNLnaVDw4nKHumt3o=;
        b=xSBvRtBGCGzn/xEkSRfQhIaicp1VBpi4+Cp8w8coXZuG3V0WtS7yTW210Iji/MvGmU
         1Weg/emY8dWPIdrrZRJOJpmz7vJhBykjp0riIfMQP+viY/yGKOBcmf1xFf7PLNk2wQYP
         b3FrgpRNghExOBOYDa9OBnt2SL0NgPassNpgM3m22rijmVOEJNhO1BI5kJ/sQ1w9AbSj
         q12rtS8HCmKSvezkDoihGUcNdu5MI5ONJrMZCVz+ukoH3FBXlhAtjx4flDMPkfTptVFM
         c0D40MpUAQ0brf98GDpeopcFuw3EZjr1ArixMRthb9fG4szaX3au6JCSPK3NTc3XOvHr
         pKAg==
X-Gm-Message-State: AOAM5327O5QDL7xq7RUQ1s++CSgV/n1BfG9Go4a6ydZEtS5AtiZykIx7
        /9WVob5bOuATtdtBsj709M+MJQ1/xDMi29sEZfs=
X-Google-Smtp-Source: ABdhPJw29cF39TNCYP7gwvMrVaDjSBomHRGrt/Z7uwwFi16mPmO08d6TrD2n14eUebUfepadvNlCmQbXmCYKIbTqIQA=
X-Received: by 2002:a37:a3d2:: with SMTP id m201mr4646971qke.207.1644751745170;
 Sun, 13 Feb 2022 03:29:05 -0800 (PST)
MIME-Version: 1.0
References: <20220211121145.35237-1-laoar.shao@gmail.com> <20220211121145.35237-2-laoar.shao@gmail.com>
 <9db9fcb9-69de-5fb5-c80a-ade5f36ea039@iogearbox.net> <f0578614-a27a-53f5-0450-a4dd5775edee@iogearbox.net>
In-Reply-To: <f0578614-a27a-53f5-0450-a4dd5775edee@iogearbox.net>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sun, 13 Feb 2022 19:28:29 +0800
Message-ID: <CALOAHbCMz2cCS6Pv4vH60u-ZWeZzfpzW_suc-gsSVK9hfndgkw@mail.gmail.com>
Subject: Re: [PATCH 1/4] bpf: Add pin_name into struct bpf_prog_aux
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 8:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 2/11/22 1:43 PM, Daniel Borkmann wrote:
> > On 2/11/22 1:11 PM, Yafang Shao wrote:
> >> A new member pin_name is added into struct bpf_prog_aux, which will be
> >> set when the prog is set and cleared when the pinned file is removed.
> >>
> >> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> >> ---
> >>   include/linux/bpf.h      |  2 ++
> >>   include/uapi/linux/bpf.h |  1 +
> >>   kernel/bpf/inode.c       | 20 +++++++++++++++++++-
> >>   3 files changed, 22 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >> index 0ceb25b..9cf8055 100644
> >> --- a/include/linux/bpf.h
> >> +++ b/include/linux/bpf.h
> >> @@ -933,6 +933,8 @@ struct bpf_prog_aux {
> >>           struct work_struct work;
> >>           struct rcu_head    rcu;
> >>       };
> >> +
> >> +    char pin_name[BPF_PIN_NAME_LEN];
> >>   };
> >
> > I'm afraid this is not possible. You are assuming a 1:1 relationship between prog
> > and pin location, but it's really a 1:n (prog can be pinned in multiple locations
> > and also across multiple mount instances). Also, you can create hard links of pins
> > which are not handled via bpf_obj_do_pin().
>
> (Same is also true for BPF maps wrt patch 2.)

Thanks again for the reminder.

-- 
Thanks
Yafang
