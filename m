Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6641669FDD6
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjBVVoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbjBVVoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:44:04 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EA531E36
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 13:44:03 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b12so36089277edd.4
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 13:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8oYWKIc1S3uxITVpxd8tWdXuh6CEoVI7L8XjQ7W6G1A=;
        b=HhUHBtTjub8KdQHhqu1fxHUgmYd9w+ceHrZK9zRemdaggPWtv2iGPX6Cql9YcsRCzv
         ew7JVcXnoVO+4cDmGI33ch5+YbLrwqZNZFUyY25F96N4PowEGSsYLjkRYiFYdoihT7td
         zjBWY+nzFImFuPwTQP0fDvzUFTGKWAxaIS278=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8oYWKIc1S3uxITVpxd8tWdXuh6CEoVI7L8XjQ7W6G1A=;
        b=gIWTQHn7LBS8KUHoCwfrVHdtTmGZNGQWmr0kg5GIWxQENSeQc+UCtrcjT87edS8aPn
         f+VRmuA7zcrgXj474PhE6jASBTzmiNQkhOV8F87UObMAbREQkVqPLbErwOU0NO0WoV9V
         PwGYpv7T3hdBmeUbWNxXVfr9Cx7siZwqIqOqRn9ZX4vKhpjLIS1F51cjnkhin+WjTPRq
         rMCx+yFZ/jvsmW3d4OUy7iSX3HkQuqRXWVynTj0WttWt6xYMSkHa+Rbi1j/sheE5nsZU
         TtbHGvaCT1iS6y6sIg51GGzN37rFmNA/1k9IGRlruNBJ7WOlbl4Ts2/CvXflzjXQc0tq
         8d1w==
X-Gm-Message-State: AO0yUKURK3pqU4NYvKnWPZHWZMJo7lDz5tnDkyOBbelZOLgHM2iQBuvO
        z4sCylCrJ5erz6BwblsyGESgr2nW51gFhlD5x9s=
X-Google-Smtp-Source: AK7set/NqeisdmCksZzVyTuko/G4p11s8IhnCwxGKr7lqbUqyyhYAGjwhd2NN/s5ypJ8wk/UxnjvbA==
X-Received: by 2002:a17:906:730c:b0:878:79e6:4672 with SMTP id di12-20020a170906730c00b0087879e64672mr23934234ejc.42.1677102241747;
        Wed, 22 Feb 2023 13:44:01 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id b6-20020a170906490600b008eb89a435c9sm377629ejq.164.2023.02.22.13.44.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 13:44:01 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id ee7so21031823edb.2
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 13:44:01 -0800 (PST)
X-Received: by 2002:a50:f694:0:b0:4ad:6d57:4e16 with SMTP id
 d20-20020a50f694000000b004ad6d574e16mr4649056edn.5.1677102240934; Wed, 22 Feb
 2023 13:44:00 -0800 (PST)
MIME-Version: 1.0
References: <20230223083932.0272906f@canb.auug.org.au>
In-Reply-To: <20230223083932.0272906f@canb.auug.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 22 Feb 2023 13:43:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjXpth1kQRCeAXhxoAmsr8dnLLW9KJ0haMiXmdF6-hFfw@mail.gmail.com>
Message-ID: <CAHk-=wjXpth1kQRCeAXhxoAmsr8dnLLW9KJ0haMiXmdF6-hFfw@mail.gmail.com>
Subject: Re: linux-next: duplicate patch in the bpf tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Huacai Chen <chenhuacai@loongson.cn>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 1:39 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> The following commit is also in Linus Torvalds' tree as a different commit
> (but the same patch):

Yup, that was very intentional to keep the fallout of the problem on
random architectures minimal.

         Linus
