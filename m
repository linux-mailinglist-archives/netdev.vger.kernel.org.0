Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7731B4BEACB
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiBUSTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:19:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiBUSSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:18:30 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100B31081
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:08:16 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id r20so15857369ljj.1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Hs6kJn9+mOIIZwDsnQIFcNqBIpimtFZQAKHVsCTwrY=;
        b=F9GqQ1yN68fTRSzJUF+6cFoxD/GJ4aEMJQM0idrGvH+aEu+5n70OrVWNUZXsyxFrfj
         kWhz7EitKMGt0/qI82LpmFIQjX/Q0J29BzsDlGFcSomRJ/AAcG9cvjF9yxvd9oLQPwuz
         DJ40EV4FqE3d2qsjo4LB8ULboh4BhsNrZ/3iQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Hs6kJn9+mOIIZwDsnQIFcNqBIpimtFZQAKHVsCTwrY=;
        b=qhGPHIf1TGLgltfyDQVao0kQDykLHLAYuFqHPOK+bsFitpaNuwKmtYkBMymZD1VhOt
         t4BN/k+jmnVU5OS7vzMXVuypZkZtzDxfoL7ZyMuBJtK12kW21riMgo+rY4298UghUl57
         q+D5D1tsfzFgszcf6Gf7wrTycBkrvZjLS39tadC5LmelQuzza9pWFEdc3XIQp3Y0G/Ex
         1krulLMHypdZDdodsqEc80JkTB2j0EdZGEd9dkq3qnmH9Hu8XFJzKQ2JBSMxQCaJSg7j
         bvQtXFfB2GffQcWBYRZotnDVgRMPZpF3LJjfuHix2pJrO+BRDhD8tRDfRJ2S0xHgCUb/
         WkJw==
X-Gm-Message-State: AOAM531GivSubpgFLVnl6eegx8lKZHdpmEgtKJKYRYk4gyR9erintCMs
        SPZ9pnOb7+V6wGgQUadzRTxBBob5T1Q8Xidy
X-Google-Smtp-Source: ABdhPJySAexBuxScu7Gvgo9UchGh5cBboApCgrIK2FCtBaDIt9vgApkEaxJDNr+30u8VhQp6bpXgdg==
X-Received: by 2002:a2e:8752:0:b0:23e:d951:4184 with SMTP id q18-20020a2e8752000000b0023ed9514184mr15664811ljj.410.1645466894151;
        Mon, 21 Feb 2022 10:08:14 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id e6sm1178053lfs.15.2022.02.21.10.08.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 10:08:13 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id j7so20145377lfu.6
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:08:13 -0800 (PST)
X-Received: by 2002:a05:6512:130b:b0:443:c2eb:399d with SMTP id
 x11-20020a056512130b00b00443c2eb399dmr10459971lfu.27.1645466893192; Mon, 21
 Feb 2022 10:08:13 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wgsMMuMP9_dWps7f25e6G628Hf7-B3hvSDvjhRXqVQvpg@mail.gmail.com>
 <8f331927-69d4-e4e7-22bc-c2a2a098dc1e@gmail.com> <CAHk-=wiAgNCLq2Lv4qu08P1SRv0D3mXLCqPq-XGJiTbGrP=omg@mail.gmail.com>
 <CANn89iJkTmDYb5h+ZwSyYEhEfr=jWmbPaVoLAnKkqW5VE47DXA@mail.gmail.com>
In-Reply-To: <CANn89iJkTmDYb5h+ZwSyYEhEfr=jWmbPaVoLAnKkqW5VE47DXA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Feb 2022 10:07:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wigDNpiLAAS8M=1BUt3FCjWNA8RJr1KRQ=Jm_Q8xWBn-g@mail.gmail.com>
Message-ID: <CAHk-=wigDNpiLAAS8M=1BUt3FCjWNA8RJr1KRQ=Jm_Q8xWBn-g@mail.gmail.com>
Subject: Re: Linux 5.17-rc5
To:     Eric Dumazet <edumazet@google.com>
Cc:     Woody Suwalski <wsuwalski@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 10:02 AM Eric Dumazet <edumazet@google.com> wrote:
>
> I am pretty sure Pablo fixed this one week ago.

.. looks about right. Apart from the "it was never sent to me, so -rc5
ended up showing the problem" part.

             Linus
