Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465454C5917
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 04:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiB0DJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 22:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiB0DJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 22:09:33 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18462067DA;
        Sat, 26 Feb 2022 19:08:58 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v4so8156989pjh.2;
        Sat, 26 Feb 2022 19:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=giHWKE8EoWJJI1S11W7iOOUvnVnZvXZu5hWofARFx2Y=;
        b=j6cT5EnZe/7B6jMRmWcxOE2JWOvjuZt+gEBQf814P9BAGv9WMXpAeYl5I4Wy/qCqF8
         7dl3Kw1TfGbnRpU3y9uVaLcxvrJoaNXBOuC997NBJj9bdaqqqWNA/OmD3EdJfAquXz7v
         T4MLgZRfomCEX6vuowCWQqS/zb3Xj+TTnY/nbWB1cBS4LMaFr2D+V5xviTdexUN3rvjx
         Pv0TRbVQxijF1wlvwjlEPu9ip1CUbifXz3uaSAefeFBLYwHygZmUZ/zsuEfeecQhc5e5
         WJMdbNdzwaqxTn346ivdTvz2oTml8IIN9iNPf0y8RRw8ftIQZDC3mDXESW+xkIxbAnxH
         OWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=giHWKE8EoWJJI1S11W7iOOUvnVnZvXZu5hWofARFx2Y=;
        b=GRe7QDgF5Hu+PY72NHYG+rC5CA5HXR3wnNbZOe87FZgkGitjiZtuLu+XTXoEC1eR3Y
         S9lbIMUYvY/8XH6jBtPtr1zp0SFwcbuw7M5YQuzEJ9uEp96Y0WBYIwvUyC6EFMS6uo7S
         D7rKtde/iQIa6Ml9ZNebrPE1+bP19LljlrAe0UArq9VaYZmbe6w+gwrEmM5nz9Kd6Z5G
         hEXBJDpIRxqFeyhQ/rQMCyfYW4blowwNo2ghvGliSM9dffQBHBwwYcO3lCHTQvCE7/0j
         FE79AThNBnLKT+wrtLjlV2LVGN+fhJhjqSJJb0ZWsv58Ma+by8aJNgjKZhZVuK7QHViH
         VhHw==
X-Gm-Message-State: AOAM5325FIR1FM0XXg/wIOQSrksQZPHxO11NiwvONLA8byVi9CG1O0KI
        FYTXRq4rB4+p1LZ+C+CdvGF74ntm8AVRyBKiURs=
X-Google-Smtp-Source: ABdhPJykP3VSUiwfYWVT7Lr+E/M8eGbSawuOMKCkxunCtEhAHbAxbDIRC8/gydxyzU33n6N/McxnBRi0WW7xbK2Zcgs=
X-Received: by 2002:a17:903:32c1:b0:14f:8ba2:2326 with SMTP id
 i1-20020a17090332c100b0014f8ba22326mr14487381plr.34.1645931338097; Sat, 26
 Feb 2022 19:08:58 -0800 (PST)
MIME-Version: 1.0
References: <20220214111337.3539-1-houtao1@huawei.com> <20220217035041.axk46atz7j4svi2k@ast-mbp.dhcp.thefacebook.com>
 <3b968224-c086-a8b6-159a-55db7ec46011@huawei.com> <CAADnVQ+z75P0sryoGhgUwrHRMr2Jw=eFO4eCRe0Ume554si9Zg@mail.gmail.com>
 <ecc04a70-0b57-62ef-ab52-e7169845d789@huawei.com>
In-Reply-To: <ecc04a70-0b57-62ef-ab52-e7169845d789@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 26 Feb 2022 19:08:47 -0800
Message-ID: <CAADnVQJUJp3YBcpESwR3Q1U6GS1mBM=Vp-qYuQX7eZOaoLjdUA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v2 0/3] bpf: support string key in htab
To:     Hou Tao <houtao1@huawei.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Joanne Koong <joannekoong@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 26, 2022 at 4:16 AM Hou Tao <houtao1@huawei.com> wrote:
>
> For now, our case is a write-once case, so only lookup is considered.
> When data set is bigger than 128KB, hash table has better lookup performance as
> show below:
>
> | lookup all elem (ms) | 4K  | 16K  | 64K  | 128K  | 256K  | 512K  | 1M     | 2M     | 4M      | 7M      |
> | -------------------- | --- | ---- | ---- | ----- | ----- | ----- | ------ | ------ | ------- | ------- |
> | hash                 | 3.3 | 12.7 | 47   | 90.6  | 185.9 | 382.3 | 788.5  | 1622.4 | 3296    | 6248.7  |
> | tries                | 2   | 10   | 45.9 | 111.6 | 274.6 | 688.9 | 1747.2 | 4394.5 | 11229.8 | 27148.8 |
> | tst                  | 3.8 | 16.4 | 61.3 | 139.1 | 313.9 | 707.3 | 1641.3 | 3856.1 | 9002.3  | 19793.8 |

Yeah. It's hard to beat hash lookup when it's hitting a good case of O(1),
but what are the chances that it stays this way?
Are you saying you can size up the table and populate to good % just once?

If so it's probably better to replace all strings with something
like a good hash.
7M elements is not a lot. A hash producing 8 or 16 bytes will have close
to zero false positives.
And in case of "populate the table once" the hash seed can be
precomputed and adjusted, so you can guarantee zero collisions
for 7M strings. While lookup part can still have 0.001% chance
of a false positive there could be a way to deal with it after lookup.

> Ternary search tree always has better memory usage:
>
> | memory usage (MB) | 4K  | 16K | 64K  | 128K | 256K | 512K | 1M   | 2M    | 4M    | 7M     |
> | ----------------- | --- | --- | ---- | ---- | ---- | ---- | ---- | ----- | ----- | ------ |
> | hash              | 2.2 | 8.9 | 35.5 | 71   | 142  | 284  | 568  | 1136  | 2272  | 4302.5 |
> | tries             | 2.1 | 8.5 | 34   | 68   | 136  | 272  | 544  | 1088  | 2176  | 4106.9 |
> | tst               | 0.5 | 1.6 | 5.6  | 10.6 | 20.3 | 38.6 | 73.1 | 138.6 | 264.6 | 479.5  |
>

Ternary search tree looks amazing.
Since you have a prototype can you wrap it into a new type of bpf map
and post the patches?
I wonder what data structures look like to achieve such memory efficiency.
