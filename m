Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3E9A283A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 22:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfH2UmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 16:42:06 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44757 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2UmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 16:42:06 -0400
Received: by mail-qt1-f196.google.com with SMTP id 44so5219101qtg.11
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 13:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w0WV+mVGw5U2S0E5NXEe8DjTfwOHjNS1mq+UGD8f7yo=;
        b=pu6TMhET1vLeeTDUPRNhhmItYfJ439J46lc8/43MZ8ENvMBx2sqN/LPkks7AMQZIPn
         e+MoeqInMbXv6MVErVEfX2kTXyrXsaKn/L19dBDT4TGdhLq+KaLs3RvxgqDN3ZoPRMCc
         q20Mj8nd5Ko29rGoUYZVIi70Ocnff98rn5li2dags1hdOj5Kqe2APr9IwF6mnteFUwGk
         qX7ec5GLFRe1KuD8oNiHE1bOvOXFZhmxY5N3p3cJ3sVs1Ruu1FyuTpMaUAAavLmDGGW+
         C4s92sUUqT6/jACaFEMP0zmsdOwklf6IFgW/LdeWo6vGE6TuhyK1M6CuyJ3zTIic/cT8
         fiOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w0WV+mVGw5U2S0E5NXEe8DjTfwOHjNS1mq+UGD8f7yo=;
        b=n2tMycUnbVj1W/UY4EL41rDKfJvJtoxvrfqVpoxvgTJHsRQcIrXxciWR+11S/JcI0a
         5Pk+W7/WByrbOBVdLJ6B45UZfl8cSGXxkZQvpK/jCbjxXkq7YCC4Q/eEgw9El9NXEuWf
         W2RSCTJjiCZco/JluDTDccpjtKFMmzpJCUpbbQIe5mhDnQtJxPOfRqNJKQzCP8c7CN+y
         6Ikc0LPVRxrMUfvLZHQ1SVXQpwzDfDlWH4ODOFDsBK2KcRewGNaMI++S6G2TiZUDyVHw
         Z7Jt/7oufkHder0Cuh+ZkVLHk4TPLLe0mdm9MHLL9m+GZEc0dP+GNNzAUUns09N0+2bk
         y/1g==
X-Gm-Message-State: APjAAAUbQmllWOazMVDLdYHHIUcaMvMKrwct13iv+Y8A7bhTk+XPL0Nj
        uM/YD/o256bjTOzxZNkWivgeUJ4Frc3QBqK6Nxw=
X-Google-Smtp-Source: APXvYqzNJcLf/SaVKefpS4yp1PhOeQmfL8BmtCGNsf51lN/vzqeIlWNzDn2Aisn/tbiMjEICp69QjqzWQQKgfiRmFDk=
X-Received: by 2002:ac8:3021:: with SMTP id f30mr6000448qte.193.1567111325334;
 Thu, 29 Aug 2019 13:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190826162517.8082-1-danieltimlee@gmail.com>
In-Reply-To: <20190826162517.8082-1-danieltimlee@gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 29 Aug 2019 13:41:54 -0700
Message-ID: <CAPhsuW6dnbwtCxf5AO6gJe07qu4ewvO1NQ+ZiQVBR8jUVfQ9uQ@mail.gmail.com>
Subject: Re: [bpf-next, v2] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 9:52 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> to 600. To make this size flexible, a new map 'pcktsz' is added.
>
> By updating new packet size to this map from the userland,
> xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.
>
> If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> will be 600 as a default.

Please also cc bpf@vger.kernel.org for bpf patches.

>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

With a nit below.

[...]

> diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
> index a3596b617c4c..29ade7caf841 100644
> --- a/samples/bpf/xdp_adjust_tail_user.c
> +++ b/samples/bpf/xdp_adjust_tail_user.c
> @@ -72,6 +72,7 @@ static void usage(const char *cmd)
>         printf("Usage: %s [...]\n", cmd);
>         printf("    -i <ifname|ifindex> Interface\n");
>         printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
> +       printf("    -P <MAX_PCKT_SIZE> Default: 600\n");

nit: printf("    -P <MAX_PCKT_SIZE> Default: %u\n", MAX_PCKT_SIZE);
