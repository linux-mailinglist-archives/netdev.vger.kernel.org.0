Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA37442F02
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 14:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhKBNXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 09:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhKBNX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 09:23:29 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC05C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 06:20:54 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id y8so6294386ljm.4
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 06:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dczPTm8CRjx864gDRFl5nDvDcvUiz4NUX5XbHa7J7F8=;
        b=FnOFGHiBYqf/NDURwonj7/pC9oiLvv8KGyNv2yNwfP5oNaEoAXJU+erU4/kyUgP6Kx
         o0QLj+xXSbbIst6XD0CcRqIQ8JVkc4OmYc1DQn/8iiS8OlqKpCOy3H9aWv/ilu1zjUn9
         IPOLik9lPCovbFI6AHdjC/nXMx/YvHJ84O9tA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dczPTm8CRjx864gDRFl5nDvDcvUiz4NUX5XbHa7J7F8=;
        b=A6VmCOlWs6gygIhicDeqVL5dc0Jp9aGQtUMl3i/9awjzXowomsDtV6nzrAU/2QN8l0
         lZFa4NSLX7VCbHi7Ee1ePlAOHWfjy/P1KyBWRSInbhHFii1BmuihcL1+P7f3zLxyQ4pC
         fwJIjV+BQeH513k6P6Op9YUFBPncI4U2S+/O+D8a07W6R/D7JL3rkFRhlr+ixREZoMjC
         42s1g5TACRcm2ekzD1LUAmJLZogMrkHzHBddliuZmjBmQ0G68V7BAqwHc/EccnVITkpa
         3TnjApVNWewTaIgWllrw+UzuwWc3WulWP+E1/E0JVvdJno80qLTgI5UULKRseHhyqzwe
         U43w==
X-Gm-Message-State: AOAM532GFEyvYM9d7dlW14gSfsguLQsiFPD70Uuee6VTLMqQ/rE+5XeO
        p+1Q1t2wtk/fwMvsPQOCs17GUkoqbiZDh4XZ
X-Google-Smtp-Source: ABdhPJxhB4XsZiv2Cbf37dYqwm5srTMLD9aG8Jd4Buvrvt1I8JwptV8QTAxaJlftVIZEsCJsOvOPew==
X-Received: by 2002:a2e:9310:: with SMTP id e16mr2297087ljh.442.1635859252361;
        Tue, 02 Nov 2021 06:20:52 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id s14sm153615lji.22.2021.11.02.06.20.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 06:20:51 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id bi35so42877372lfb.9
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 06:20:51 -0700 (PDT)
X-Received: by 2002:ac2:4e15:: with SMTP id e21mr35940936lfr.655.1635859251039;
 Tue, 02 Nov 2021 06:20:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211102054237.3307077-1-kuba@kernel.org>
In-Reply-To: <20211102054237.3307077-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 2 Nov 2021 06:20:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgdE6=ob5nF60GvRYAG24MKaJBGJf3jPufMe1k_UPBQTA@mail.gmail.com>
Message-ID: <CAHk-=wgdE6=ob5nF60GvRYAG24MKaJBGJf3jPufMe1k_UPBQTA@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.16
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        keescook@chromium.org, kvalo@codeaurora.org,
        miriam.rachel.korenblit@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 10:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-for-5.16

I get quite a lot of

    ./scripts/pahole-flags.sh: line 7: return: can only `return' from
a function or sourced script

with this. Why didn't anybopdy else notice? It seems entirely bogus
and presumably happens everywhere else too.

It's shell script. You don't "return" from it. You "exit" from it.

Grr.

                 Linus
