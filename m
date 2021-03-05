Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B59C32E007
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhCEDVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhCEDVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:21:39 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE35C061574;
        Thu,  4 Mar 2021 19:21:38 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id k12so970743ljg.9;
        Thu, 04 Mar 2021 19:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jHZGaSuRvWNRlYj1cD99LVUL2y+UfWrS85InZEE5Z8A=;
        b=C+pSkIidJjZb58h3SXunX5BKmAHeQuWcdieRerGuyQndqJC57jnDWV0/9HVuOK94zu
         Vfef7DiA/10MWIA09ATAkdDE/rHcdd6kzlT0RPVxL5nGI3HFDbJ3OQpiGTli0FQNbkjE
         z5laSrGbcAsY0PKJ7fqCR89RecyG5EmNywoqcflxrxsxIsuJg4gjLUuri9imdndfhn8i
         SQ/Q1mJ9PTZZpo4a9jzBiYdLbdERtPGVngCSqrPk9hvUJ+rVWfiMXgbOx/M+V1Qko6VU
         j6+P014j7XoVzXHeYXZac1MCokxztDIzeimIa+sKCvWzyz/x0OrBvH/P+9rciMJ6M0Yj
         eWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jHZGaSuRvWNRlYj1cD99LVUL2y+UfWrS85InZEE5Z8A=;
        b=oaxjnq/P4yi79/4beC2QIYjKGhv6NTK3Vc4pFND6Q+ve8M2FsibD5nUHnUICQ/E8HI
         KqJCxWzNqeYKVk5hQ0ZbQXCAjmuXyRNKJqToxxH8JbBivvbEoJ/H0e9w9Y3kzC2/LK6T
         VvGhsSxdywyJ12pU7grbOuc7Ddkgn8x1Hbm1Azo2jJEHREYf/Ks9glslhX0KPJi22lYN
         S6vUKHbxEGkH+eXY+Z19F2DE1c88AsNteIFurlxL4tQuD+ET6Ii2YPtDdmoIjiXssjPZ
         9oT5vbckr5gmN6AaOtfCc0CrnkfT2T+K+nTFpD6ZlOIIUPRfOGIcfJ60ucAw8zZRpZ6w
         fGzg==
X-Gm-Message-State: AOAM530fH44vbgcGW89ntOWv7T6iC0wZlMpHr4dFpGw5K9lY+2l55eee
        fRIGJFNclGdXpNCm518MIO1spR4NSALgxi6X7RA=
X-Google-Smtp-Source: ABdhPJweP6rB5Z510Tj76qkJMxl4XCGUw+I8aAhbyP/5PNbpqacBnA9VBtTamni+Ki047XZHrsGRaOdpsUwuhDDtNkQ=
X-Received: by 2002:a2e:b817:: with SMTP id u23mr3839910ljo.44.1614914497552;
 Thu, 04 Mar 2021 19:21:37 -0800 (PST)
MIME-Version: 1.0
References: <20210303101816.36774-1-lmb@cloudflare.com>
In-Reply-To: <20210303101816.36774-1-lmb@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 4 Mar 2021 19:21:26 -0800
Message-ID: <CAADnVQ+7YM0LoOMG5nhmP_dj=6krgK5m4=Latqg9Yo03z2AxeQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/5] PROG_TEST_RUN support for sk_lookup programs
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 3, 2021 at 2:18 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> We don't have PROG_TEST_RUN support for sk_lookup programs at the
> moment. So far this hasn't been a problem, since we can run our
> tests in a separate network namespace. For benchmarking it's nice
> to have PROG_TEST_RUN, so I've gone and implemented it.
>
> Based on discussion on the v1 I've dropped support for testing multiple
> programs at once.
>
> Changes since v3:
> - Use bpf_test_timer prefix (Andrii)

Applied. Thanks
