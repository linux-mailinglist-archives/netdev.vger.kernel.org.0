Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C099211046
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732231AbgGAQI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731894AbgGAQI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:08:57 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F644C08C5C1;
        Wed,  1 Jul 2020 09:08:57 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id z63so22646444qkb.8;
        Wed, 01 Jul 2020 09:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfNFt+1NYRpTdNsdjDpp8UbitSQNTJTzpWaLtRB9mUw=;
        b=h9t4FMvMdPuO26JCldinVZqqOLIE+W9hXp3+BB8L5pktqgEq/W5zPaxgY8NM6WLFuG
         oGSVty2n546bpKaE3EKoHtb1BJxL9JlVr87CLLaS1J/uC23D4K8tMDTdQxYlZudc45Tm
         vUP9s3kDf1P7TjUZg9ufzRLN9rUMTCR2L6spgUfGqZaU3jVW0w0jOqrhmH7kofVuKzeC
         HRFFrxWIBxLIeh2yAlxl4G0T/18jHCLgdFWI8Hw2IIK+qfJGEYCn5jlk/J1QsNRx/ndl
         4BC3/vFcdXpKa/qrYTjL7Lef5e3kwRALeRKl4b+cYpxFRi867eh3HrkGrww034meLWjo
         zAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yfNFt+1NYRpTdNsdjDpp8UbitSQNTJTzpWaLtRB9mUw=;
        b=ZS/Q6v1yFQPArnJs0rZxNFnvmFVb4VVEa8uqVGe6VplaOYyyHqQmHG8y5YlS8e90hc
         BmRy1lwtdo+YWGfYqSftnShdIxmcWMOyVtrYZReuW+dUvg6MR3agA6VTAlW+j0Pt5k11
         uypj8x4GEAxBYTwezT9NzHef9IqPR0fUJXB3tlHV8XPrYfLlWY0/2Wl6s33V2bovP20V
         VHE1/S9swVqH66Zh7cZWRXzt+mD5k+D1eQtN+GIQV1/k19MpL8nOWqonwjLoOhdnsJwJ
         Hsx6D1u3y9Yn2Wy5JsJNLEAdGdUonzSeXTirDnfQ5le7ihHu9nJuTOOcL5fJAh16kGD+
         VsHQ==
X-Gm-Message-State: AOAM531ExDGcHepvlVW1Nq07ACvIuSEGXv0XGsO4CzUtbv7NrLkC3fFe
        isySHOb81C4VTx5wGnJXPEpz5tHBp4Dl5Q+k+Zg=
X-Google-Smtp-Source: ABdhPJxFvmbu4B0LVCrCFTFmDgKU0FPzLNKZ/OSuDrfDgjNLSqBSxkXcJfUe48VftsidadEgxLJ8FM0aMpxuR/A0sOA=
X-Received: by 2002:a05:620a:1666:: with SMTP id d6mr26197071qko.449.1593619736343;
 Wed, 01 Jul 2020 09:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200701064527.3158178-1-andriin@fb.com> <CAADnVQLGQB9MeOpT0vGpbwV4Ye7j1A9bJVQzF-krWQY_gNfcpA@mail.gmail.com>
In-Reply-To: <CAADnVQLGQB9MeOpT0vGpbwV4Ye7j1A9bJVQzF-krWQY_gNfcpA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Jul 2020 09:08:45 -0700
Message-ID: <CAEf4BzbtPBLXU9OKCxeqOKr2WkUHz3P8zO6hD-602htLr21RvQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Strip away modifiers from BPF skeleton
 global variables
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 8:02 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jun 30, 2020 at 11:46 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Fix bpftool logic of stripping away const/volatile modifiers for all global
> > variables during BPF skeleton generation. See patch #1 for details on when
> > existing logic breaks and why it's important. Support special .strip_mods=true
> > mode in btf_dump. Add selftests validating that everything works as expected.
>
> Why bother with the flag?

You mean btf_dump should do this always? That's a bit too invasive a
change, I don't like it.

> It looks like bugfix to me.

It can be considered a bug fix for bpftool's skeleton generation, but
it depends on non-trivial changes in libbpf, which are not bug fix per
se, so should probably better go through bpf-next.
