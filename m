Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4573D4D2471
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350802AbiCHWnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350808AbiCHWnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:43:43 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738DE24593
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 14:42:46 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id x200so715281ybe.6
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 14:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Kh32Ual640h2CnLXOYhYVRAACk5OudVIxthkvItKp0=;
        b=L0xMOX4eOBAX8KzLqeViHuwBDG6Pqh4FmfIq0V9YMOttBaCfKftWMBRBAnswSvVFh/
         FrVDgv0jUsCqPgtsEVJJE88yMM0VSatxB0L+1Hie27O6xnszrkowR6s0eOf/yxx9SZXu
         MKYOypt7vHfILzxA83fBwEuCGc4p3U2vY8SgZB90sNXiyMTklkrS8p8IlRTM7m19Kuo0
         mINnIBKul6wNFECut/+OpasMrm6rUXsNBCN94ukvzlzGj2Rd8KZm5MdNjzgWd1foz8/l
         Vczp6qyQhcbqAJK41tgFCwX6XpGkgUdz5XE6soFBRYrD+PMn63jGnil3BnjYJBOSCcHO
         Y/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Kh32Ual640h2CnLXOYhYVRAACk5OudVIxthkvItKp0=;
        b=cl+k3Dl/eYLI8vEAQZUKuyvZxSLMRuueQ4P7/u1gAsUqngfO5Kb9r1ckESSaeGS2Ze
         tD9dVi/kPyjsoZCKpWeNw1AWY0MIYA3tkD70VGzsngWEZFxa/sFxYm5fWCjzagsLviiQ
         wAwj/I2IKodI5o7ipunj1tSPmIH/6mlMP4qqMJWMl7kAYNeW8/vO3sds3ydS9iOqOIjT
         9gKvgypLo3aiqtrayH/M65B46ECglF5NjjyOR5spWL3XAT0bih4mefFdCCxzOjnr42hf
         Cd1I3D9gosF48sB9TO9qmiCpiP5mRP7vJKnufRp07j1zSN1LM78JFkM3TSuz2/Da8F2r
         T46g==
X-Gm-Message-State: AOAM531UGshOPv76ZfmSrbfOsHE0jU1lV8g+v9Dz2fzKC5WLU/HPhXsq
        bECVFI9SxoEj0DVtsaro7X6yse1+UOqn8ay4fWQsDA==
X-Google-Smtp-Source: ABdhPJxoYz7qJviFM0TMN10rQ3WtEx/02NdYWLEXBjt1hVUIwWjpsKqmdEbAPndOfnEYfr3a3cJ4PY0tRyC/a9j5swE=
X-Received: by 2002:a5b:7c6:0:b0:60b:a0ce:19b with SMTP id t6-20020a5b07c6000000b0060ba0ce019bmr14002194ybq.407.1646779365281;
 Tue, 08 Mar 2022 14:42:45 -0800 (PST)
MIME-Version: 1.0
References: <20220308030348.258934-1-kuba@kernel.org> <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
 <652afb8e99a34afc86bd4d850c1338e5@AcuMS.aculab.com> <CANn89iL0XWF8aavPFnTrRazV9T5fZtn3xJXrEb07HTdrM=rykw@mail.gmail.com>
 <218fd4946208411b90ac77cfcf7aa643@AcuMS.aculab.com> <CANn89iK9AoGsXDhoFKY5H_d-tZ7QGv4qjsyk6MZnd9=aZxHuog@mail.gmail.com>
In-Reply-To: <CANn89iK9AoGsXDhoFKY5H_d-tZ7QGv4qjsyk6MZnd9=aZxHuog@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Mar 2022 14:42:34 -0800
Message-ID: <CANn89iJUzrrJgriSWfbaPKZDoevBnzhshB-3YLpv8oWB+oMLug@mail.gmail.com>
Subject: Re: [RFC net-next] tcp: allow larger TSO to be built under overload
To:     David Laight <David.Laight@aculab.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 8, 2022 at 2:26 PM Eric Dumazet <edumazet@google.com> wrote:
>

>
> Thanks, I think I will make sure that we use the 32bit divide then,
> because compiler might not be smart enough to detect both operands are < ~0U

BTW, it seems the compiler (clang for me) is smart enough.

bytes = min_t(unsigned long, bytes, sk->sk_gso_max_size);
return max_t(u32, bytes / mss_now, min_tso_segs);

Compiler is using the divide by 32bit operation (div %ecx)

If you remove the min_t() clamping, and only keep:

return max_t(u32, bytes / mss_now, min_tso_segs);

Then clang makes a special case if bytes >= (1UL<<32)

    790d: 48 89 c2              mov    %rax,%rdx
    7910: 48 c1 ea 20          shr    $0x20,%rdx
    7914: 74 07                je     791d <tcp_tso_autosize+0x4d>
    7916: 31 d2                xor    %edx,%edx
    7918: 48 f7 f1              div    %rcx
  # More expensive divide
    791b: eb 04                jmp    7921 <tcp_tso_autosize+0x51>
    791d: 31 d2                xor    %edx,%edx
    791f: f7 f1                div    %ecx

    7921: 44 39 c0              cmp    %r8d,%eax
    7924: 44 0f 47 c0          cmova  %eax,%r8d
    7928: 44 89 c0              mov    %r8d,%eax
    792b: 5d                    pop    %rbp
    792c: c3                    ret
