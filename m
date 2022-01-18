Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA5249317A
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 00:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349504AbiARXyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 18:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344932AbiARXx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 18:53:58 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4198FC061574;
        Tue, 18 Jan 2022 15:53:58 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id g2so656894pgo.9;
        Tue, 18 Jan 2022 15:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2VYJaO2f2+oyJmGbk1m7upZoK/g8R4QgH1WZUP2CD74=;
        b=Lu9xfHkDMBBStlM53OHLPoTJaTj+sWOHJNCoaJsgr4muaooeAbpP2Cw9iOUP00muTv
         FHXc1qyyMuDcT7MkAJbZCuJX8/+dM7z6v4PZJdy1Xm6PfQUI1shqQC66uSNdiyAgn2vc
         G2J2l4DD1djIaTHZlUFhal8FGZ6WYXC8hfLYcqEo2OxCqp/2qEZkncKf1Xkk05IqDuQC
         +mDKU1AQvqar0mbJHhiUm2aHA0S1gEe8/3CYznM8yXpMVQguuKY0BFBYX5Cr6hf5/0Qb
         Di0eqhxJL+DsySrqTSdCUk2q5ZfwGYJq8ogxq8+llo6D3QKtgxx0QPa3lTq6GGMkQp6r
         jx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2VYJaO2f2+oyJmGbk1m7upZoK/g8R4QgH1WZUP2CD74=;
        b=PTOlIIPUKntr5qJIirWE3AjINLCf2FcbBX77vXIQDCrsKh26Drhd9I2mO7VpBYQcrM
         vU32o9VZf1CDclJTF/Yt3mYqmH7cy9OHcatPMdkvTCY5l6Ak/PRigiXT03PxdcVKclm2
         BKy+jatLirKlKVSX06uHmmuDePa+Oo+vokCuAegDf72ILvL3GNae9DlymtwMdH8LkNUT
         McsTkRo/e2wWU6ljJsHOFTy2z6W5Qqo3aqSamVTwVGQ6DOXTGeZBsdxo/7xQ7DAYx15s
         cjXUvXapn64hz5TbVYHXRi/AqInmgp69OzbYpqqEJS9RYM0ogYdL82nqmHm7FyWdT3XW
         4uxw==
X-Gm-Message-State: AOAM53066PdrmyGWXC9+tPorP2+Y72Mvvkxv9HNOvsNLhi3dPjkkQJzg
        nDE+wfVM8x7mAtMabmuZMxrQM3kskTMkZlD9++I=
X-Google-Smtp-Source: ABdhPJyIODfFujZGkv17/eb0qpafbNipM/F80U5IYRCxISAh9UP//MFXbMpFkUDA1n4ehozEkd0YQ8qSVWRWG+VZmVk=
X-Received: by 2002:a62:6342:0:b0:4bc:c4f1:2abf with SMTP id
 x63-20020a626342000000b004bcc4f12abfmr28163781pfb.77.1642550037743; Tue, 18
 Jan 2022 15:53:57 -0800 (PST)
MIME-Version: 1.0
References: <20220113002849.4384-1-kuniyu@amazon.co.jp>
In-Reply-To: <20220113002849.4384-1-kuniyu@amazon.co.jp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Jan 2022 15:53:46 -0800
Message-ID: <CAADnVQLf+HCOTyK3=ur34Lb1GWKAvbgDvvC4AGAYBGvF=BL+BQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/5] bpf: Batching iter for AF_UNIX sockets.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 4:29 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> Last year the commit afd20b9290e1 ("af_unix: Replace the big lock with
> small locks.") landed on bpf-next.  Now we can use a batching algorithm
> for AF_UNIX bpf iter as TCP bpf iter.
>
>
> Changelog:
> - Add the 1st patch.
> - Call unix_get_first() in .start()/.next() to always acquire a lock in
>   each iteration in the 2nd patch.

Applied. Thanks
