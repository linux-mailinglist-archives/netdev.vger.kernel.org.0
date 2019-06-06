Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C891F381FB
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfFFX5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:57:13 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35150 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfFFX5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:57:13 -0400
Received: by mail-lf1-f66.google.com with SMTP id a25so236814lfg.2;
        Thu, 06 Jun 2019 16:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OhBCLi5ITdlksNplm+/e76uqZauEz9CP+Gabd0yRIEQ=;
        b=InVIO6J0AKSWnOVli9xoBugj4FU3ag8ysLp+cAPyPucU2mKfdlK5c4yqA9G8SWkE55
         Mw426S4YqvUMKAV/ePXiLJa666R6CksfOVavbKJp2sXBNqm8oMnByoN5xtLUm7gUvn9x
         1ABAFzGE0pz+UMmMwsus2PGxPvWUJlutMOmZV4X01Dk6PXmcAuqXXzQFxyMeFs0BQ9DJ
         eX1NJ4QCS/CpmFW5RmvBJ2um9ma/OkaOKlsey2wY2HSDf4PJ5noxU7qeFTkWMVUjCVkY
         9zjF+3MhJoeX5O3DAIqNZyhcF1RJDC+t7TI8BoNnzaTO+0m4BtNCJ0HFWK1f0TVU8c0m
         eCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OhBCLi5ITdlksNplm+/e76uqZauEz9CP+Gabd0yRIEQ=;
        b=sXuXoe/nb/T4J3A3lnHN5RLZDH9aO55V6ppsZkPG0kqO4Gv0o74RM2oIlG86eCh6o8
         SihrNZA5OLehKC6bIq3LaCIYweMkOLWfXQLi1656ToZP9BxkASqDWgs4toT1+7r7YuXk
         RRQU+n8wz41blWxK1KrSJ+htCHCA1BhUi0/ZdJdmxlcsTZe8MbOh2MhWsGzwT+U+pZwY
         Z4naAPETgAFOupQt/8EnzdxvHXX+yMGeulA5zRFlubGPkaPnXYs2DU8M5/agHwDks7Z2
         EyC4BA/lXnxOeprVuiF3vhth55drsEwNA7zWUkX2MZ05s4PWg9PhrIaXGo0wQWPTCH98
         RK+g==
X-Gm-Message-State: APjAAAWi4jfmczX4uc5iki7dU0+HZp1qrjaPDop2B/8XwGjl7jwDn45b
        hNKvyBIXeTgKr8WGCLAf8zxb2WC9mLLOaANRvzk=
X-Google-Smtp-Source: APXvYqwSIFvJMXLyeDFJzvQY8BBn4Ae8bg2g1Kzy/3o6GpPGIIhtDKReRVDIldMTPKEXcWubRXwMYAQWL9+18G6Bwvg=
X-Received: by 2002:ac2:5337:: with SMTP id f23mr26023839lfh.15.1559865431431;
 Thu, 06 Jun 2019 16:57:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190606234902.4300-1-daniel@iogearbox.net>
In-Reply-To: <20190606234902.4300-1-daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jun 2019 16:56:59 -0700
Message-ID: <CAADnVQLcvq0r8JTBmk1Q903fwoW=FgcjqMhEL9xmXfTOQnD6OA@mail.gmail.com>
Subject: Re: [PATCH bpf v3 0/6] Fix unconnected bpf cgroup hooks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Martynas Pumputis <m@lambda.lt>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 4:49 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Please refer to the patch 1/6 as the main patch with the details
> on the current sendmsg hook API limitations and proposal to fix
> it in order to work with basic applications like DNS. Remaining
> patches are the usual uapi and tooling updates as well as test
> cases. Thanks a lot!
>
> v2 -> v3:
>   - Add attach types to test_section_names.c and libbpf (Andrey)
>   - Added given Acks, rest as-is
> v1 -> v2:
>   - Split off uapi header sync and bpftool bits (Martin, Alexei)
>   - Added missing bpftool doc and bash completion as well

Applied. Thanks
