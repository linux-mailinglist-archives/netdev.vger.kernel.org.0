Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105EE645335
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiLGEwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiLGEwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:52:45 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D680723161
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:52:44 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso2729151pjb.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 20:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z1MllrK9qt7IPbxn8SLx0NFrqMVmB40d8EFuAkil31U=;
        b=m1VXeLq0luzQBQFRff9sX/js+wkR2gT50ESiyRrYq1E0mGU3fT3V+dffda1H9tPB9g
         L96pq0H9bodoeeM8K83cVN1LIQOfjUznPOMBezyeoufHH/gYEEOTA8yyqiQvE9nGze0x
         hKWqNSWzj84d2mpv5WqnhIYmpU5SHOTartUb9GLYuD5a16/yDWX7/oHGb53WtECo9a8/
         vnisxdL4aXQY4vDxnzL94zdf7ZYK/cR1wYjO+K+SEir4nSVZfdnZXTarrY4nrzNecXcV
         k9QKmvROrb/DpUWyTlQA/xmuKl+GAtRy+jrXWoarZZvT0pQTy5V9osa4fU7dMKAv0rSx
         sSZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z1MllrK9qt7IPbxn8SLx0NFrqMVmB40d8EFuAkil31U=;
        b=ueTy351yr6/XvINYK3OOWivx0cQki8OSGH6FXVk1sfN62GaI3LkkTnoA4CyjR208cJ
         OYOdCYVOSXaiCkAT3t3gj27IZvw03o2Y1g28jZ1yp+ogYnujr9xe92T72diNlYZv32q/
         xL674Z+e7FhQzyLYtqafnAeOKRHqc7cA3LRnOJXTOA2GyvoH/Gvz2GBfdylZ1t9U9Tdw
         eknm0OoCxMvwQ41oDRyM3SohkQSi9fIeT70cwQdG0zz5DBwFDOh1MvR9fgfTDyw4YFnI
         zn5d9RkzKZIpw7jz9uV1D8y43gWDYa/ty56oWacXTZEFMF9cCOlf72qSpt+9xbNzKyar
         TdLQ==
X-Gm-Message-State: ANoB5plpdp60iswip0IdiGlp3zYkdIP9/ZmjTMTCw30OQHz2rePR00n1
        zdVRdnT9XYTb/UFwB9PTYWKM4nKZU0q8Fcm2/B/iRQ==
X-Google-Smtp-Source: AA0mqf7jk6PKiimI2vjKH1e7HtJUBi0CkAsLinCRYQ3x4Sk0onLox4st2IRjcm8+NhsUA/9pMHGYqOUQjJaSFW/M/AA=
X-Received: by 2002:a17:903:244c:b0:189:e426:463e with SMTP id
 l12-20020a170903244c00b00189e426463emr8905233pls.134.1670388764191; Tue, 06
 Dec 2022 20:52:44 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-4-sdf@google.com>
 <Y5AWkAYVEBqi5jy3@macbook-pro-6.dhcp.thefacebook.com>
In-Reply-To: <Y5AWkAYVEBqi5jy3@macbook-pro-6.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 6 Dec 2022 20:52:32 -0800
Message-ID: <CAKH8qBuzJsmOGroS+wfb3vY_y1jksishztsiU2nV7Ts2TJ37bg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 8:29 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Dec 05, 2022 at 06:45:45PM -0800, Stanislav Fomichev wrote:
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index fc4e313a4d2e..00951a59ee26 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -15323,6 +15323,24 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
> >               return -EINVAL;
> >       }
> >
> > +     *cnt = 0;
> > +
> > +     if (resolve_prog_type(env->prog) == BPF_PROG_TYPE_XDP) {
> > +             if (bpf_prog_is_offloaded(env->prog->aux)) {
> > +                     verbose(env, "no metadata kfuncs offload\n");
> > +                     return -EINVAL;
> > +             }
>
> If I'm reading this correctly than this error will trigger
> for any XDP prog trying to use a kfunc?

bpf_prog_is_offloaded() should return true only when the program is
fully offloaded to the device (like nfp). So here the intent is to
reject kfunc programs because nft should somehow implement them first.
Unless I'm not setting offload_requested somewhere, not sure I see the
problem. LMK if I missed something.

> I was hoping that BPF CI can prove my point, but it failed to
> build your newly added xdp_hw_metadata.c test.

Ugh, will take a look, thank you!
