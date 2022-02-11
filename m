Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25BD4B20B5
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 09:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbiBKIyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:54:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbiBKIyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:54:49 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18022E7F;
        Fri, 11 Feb 2022 00:54:48 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id a8so21346774ejc.8;
        Fri, 11 Feb 2022 00:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=puoZXfWx2DTZk4F00wSFE37CTpFITbctZ1aAVvE89vI=;
        b=X4Gg1UAhzor8SsWPhDCtxTM/nM7nUCuAI9eD4KFWeeqrF7VRHtLINQhxv/1LOU8zPC
         HgNr7pbl8ZAtBgOgZ5DXV5+cHW28IvQOw0dbTfOLcJPqVTgN5iJp2zgx7L4oDjQQmabv
         Drx95HJJ6LUCTOH4ZXXvHoGZZqwgB10k+HrBxSvph+aHplhj/I9jnVRgDneIl+qQMraa
         pSVRttcWGc/5tyv5dOdz/njJux5AnWO0cC9xEeaYHjCtF6bgXvrQVPZo8A/ek6GdV5mz
         EnRazfUZeimdnmbGHpDA8sPyxf13W16nF1mj0YIJwK7bf7n/I18p1wAfonVfESMAzYXi
         obdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=puoZXfWx2DTZk4F00wSFE37CTpFITbctZ1aAVvE89vI=;
        b=lfy3W59dONol6dyL609KwV5u1MBtuNXvOzkMfsPkBAjyB+W8Q0a02oKw8o1VSbx2KK
         HyPEP26IJLP8kllG+Stm92PuZD8TWnvjUEPCUBeRQoq93tD9iXL0++sp5h0k5cBXiM1R
         sCjGHJuOjCEvdrf/tAVHdk+b+WZwrPTgePu5+O0I1Ytn2AEwaVaAks8fpbKFzGk6JNZX
         MIg6f1bl0v4aNtNPXoBcC5RttRPD1wlkdf/TSnObJNKWVPQPuKXBjTkHK4jGE6IgOh7U
         dVSV/uiNpEvCf00Gg7J08TBO89ipwESwgIyNG8SFsKAPkmLWVr67ilmuDGr2rxOSMiUG
         9RQA==
X-Gm-Message-State: AOAM533CeSjHxs9HLrbnz+FKjhZlRZKUvZS8/cSusdCAzVfLs/3mD2FL
        UoOmjj4t8drQUeaokT/2LNe3RrCYW+hCxpw22ik=
X-Google-Smtp-Source: ABdhPJxgs6s2LbMQhDJ87YLKj7uqQY+ce9jhiEVY4StztvWPplSwzOi9SgtbdmhW4Up2me4QRjzDTYSTdMHArB8qeRQ=
X-Received: by 2002:a17:907:1689:: with SMTP id hc9mr536327ejc.348.1644569686553;
 Fri, 11 Feb 2022 00:54:46 -0800 (PST)
MIME-Version: 1.0
References: <20220128073319.1017084-1-imagedong@tencent.com>
 <20220128073319.1017084-2-imagedong@tencent.com> <0029e650-3f38-989b-74a3-58c512d63f6b@gmail.com>
 <CADxym3akuxC_Cr07Vzvv+BD55XgMEx7nqU4qW8WHowGR0jeoOQ@mail.gmail.com>
 <20220209211202.7cddd337@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADxym3ZajjCV2EHF6+2xa5ewZuVqxwk6bSqF0KuA+J6sGnShbQ@mail.gmail.com> <20220210081322.566488f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220210081322.566488f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 11 Feb 2022 16:49:50 +0800
Message-ID: <CADxym3b-D-08P_YzQSSP-YdrTcw981MRyAmxNcXrdorWYcJniQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/7] net: skb_drop_reason: add document for
 drop reasons
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        pablo@netfilter.org, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Kees Cook <keescook@chromium.org>,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
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

On Fri, Feb 11, 2022 at 12:13 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Feb 2022 21:42:14 +0800 Menglong Dong wrote:
> > How about introducing a field to 'struct sock' for drop reasons? As sk is
> > locked during the packet process in tcp_v4_do_rcv(), this seems to work.
>
> I find adding temporary storage to persistent data structures awkward.
> You can put a structure on the stack and pass it thru the call chain,
> that's just my subjective preference, tho, others may have better ideas.

Yes, I also feel it is awkward. I'll try to do this job by passing drop reasons
through the call chain. Thanks for your help :)
