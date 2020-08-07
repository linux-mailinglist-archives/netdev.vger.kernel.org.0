Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C655E23E4F0
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 02:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgHGAGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 20:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHGAGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 20:06:04 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2FBC061574;
        Thu,  6 Aug 2020 17:06:03 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 185so265122ljj.7;
        Thu, 06 Aug 2020 17:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8MCFUFZgGwGAZQzC9WBuVuzz9UQTE9/5HZUMhynMshw=;
        b=uYx/IsSBrVkQXQ93EekBgXtiEr46FePoCQutYbVpPluHFg6qvgSpye+blLRp7/UQU8
         PDGXV8MLOVO9SaRU1ikfejlDZjvBAJZBk+5mLd2wWsU9GD3HWsE6j6DPSM3lnmdwELaB
         XJ1dJqR5vwjDJwefYUBVDdunFkeuwyyWdRgqZnYyn5MRSADRNzTXfj5wQxumHjKcDiN5
         WQTCxyE0zfL/zejQn0XWQ2tJAuXwnz66OMtFpmjr5A99+zONzbJtQv/hB1H9DXE8yyYT
         PU1DzLgmT1zxxkdGGloyuFPkbW98d2gzgr6ZxM7Q52RFJVMn2hd3euxxDGajlZ2BYO3B
         RxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8MCFUFZgGwGAZQzC9WBuVuzz9UQTE9/5HZUMhynMshw=;
        b=L+x+TflFqkKbNNK9gWwbXXWnxX9FbP9meik9Bhj7kc0FrmMieIj6VoIn+5xFPCLTsE
         2M/c7uPpHeMrC20wFrhjgoKbFA38q2EQJPqiKj0iCHbGMpD+mVeNP/Reotx9bBwl5y18
         c3lRn2NrVKhp0vkABKWYkEFjgSdz65V1vXYRu83MuzJ77yuJKLx+r0rFHVau+IyX30DJ
         AtvPI/4Y2zc4yh0CWZHPADZ3bBTOZE84ebplTsa4LAO75q3a0CzrDddchHfI7ZNnFyly
         K1iGTgHEYI+v7BNS5Npn7WVP927EpKzgEzmb4jTtcxy4YGvrV2GJDar4LCjotOtK9Bsh
         sAPw==
X-Gm-Message-State: AOAM5322qNQWeu7zXwaTgFoPBfTzgMz4ek3LCMbqxMSAk5GavaoK1XTg
        3kRZtuLITiaBXOl70E4nfu0qY8nKnOscgHH7weA=
X-Google-Smtp-Source: ABdhPJwFW4ikORvqMwQZ9PR5SBKUYZJA7RGV8+Fe+mbN4lC/V5Zq3PSdrsdDtlhxRPLwZ4ul7Qdxcj/6Zi1htx9FpWw=
X-Received: by 2002:a2e:a17b:: with SMTP id u27mr5070801ljl.2.1596758762004;
 Thu, 06 Aug 2020 17:06:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200731061600.18344-1-Jianlin.Lv@arm.com> <20200806104224.95306-1-Jianlin.Lv@arm.com>
In-Reply-To: <20200806104224.95306-1-Jianlin.Lv@arm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Aug 2020 17:05:50 -0700
Message-ID: <CAADnVQLaxmftiSH6dk+NVv5FGvnB+C=rC978cCiL83d+M_zZ+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: fix compilation warning of selftests
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Song.Zhu@arm.com,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 3:46 AM Jianlin Lv <Jianlin.Lv@arm.com> wrote:
>
> Clang compiler version: 12.0.0
> The following warning appears during the selftests/bpf compilation:
>
> prog_tests/send_signal.c:51:3: warning: ignoring return value of =E2=80=
=98write=E2=80=99,
> declared with attribute warn_unused_result [-Wunused-result]
>    51 |   write(pipe_c2p[1], buf, 1);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~
> prog_tests/send_signal.c:54:3: warning: ignoring return value of =E2=80=
=98read=E2=80=99,
> declared with attribute warn_unused_result [-Wunused-result]
>    54 |   read(pipe_p2c[0], buf, 1);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~
> ......
>
> prog_tests/stacktrace_build_id_nmi.c:13:2: warning: ignoring return value
> of =E2=80=98fscanf=E2=80=99,declared with attribute warn_unused_result [-=
Wunused-resul]
>    13 |  fscanf(f, "%llu", &sample_freq);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> test_tcpnotify_user.c:133:2: warning:ignoring return value of =E2=80=98sy=
stem=E2=80=99,
> declared with attribute warn_unused_result [-Wunused-result]
>   133 |  system(test_script);
>       |  ^~~~~~~~~~~~~~~~~~~
> test_tcpnotify_user.c:138:2: warning:ignoring return value of =E2=80=98sy=
stem=E2=80=99,
> declared with attribute warn_unused_result [-Wunused-result]
>   138 |  system(test_script);
>       |  ^~~~~~~~~~~~~~~~~~~
> test_tcpnotify_user.c:143:2: warning:ignoring return value of =E2=80=98sy=
stem=E2=80=99,
> declared with attribute warn_unused_result [-Wunused-result]
>   143 |  system(test_script);
>       |  ^~~~~~~~~~~~~~~~~~~
>
> Add code that fix compilation warning about ignoring return value and
> handles any errors; Check return value of library`s API make the code
> more secure.
>
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> ---
> v2:
> - replease CHECK_FAIL by CHECK
> - fix test_tcpnotify_user failed issue

Applied. Thanks
