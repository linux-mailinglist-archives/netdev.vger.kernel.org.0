Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918506C5024
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjCVQJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCVQJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:09:32 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B7610407;
        Wed, 22 Mar 2023 09:09:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id cy23so74969307edb.12;
        Wed, 22 Mar 2023 09:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679501356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c+t+iJE4CLPR5AX4Mmj+oQLcilezTSlPs5QGLaEKjPg=;
        b=maaJ1R0tVCWai7p0zz0N16SBmHDyT3mInEhc6OhwwhFqXUK2XbbQXvAkjEarOXoZQZ
         tLTx1WLClV7jWVtS+tbsmBdkXdVoA/sVCEwz7lvyWf9N4ByG6tNpEb0p2vfxyuP5z+oB
         QZPlDkuOU4BTjAPJiWuhvqCMKev7ubWgeLrcBnw58s+ce4cvHFNt1CFtd+4guTtyrAIY
         7mz8a8eOT4CBu3+eU5G7KVGrmvbGnq8l37ic1ImLN9PTJ+zQIDs3SA5DVPazqA5b+JN1
         FZykZ92xXPKI6onLP4XA0uECFwQQ97JClYBYxqRh3vZLOsV+sf4ZHq7tPavGtyxlRusn
         DVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679501356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c+t+iJE4CLPR5AX4Mmj+oQLcilezTSlPs5QGLaEKjPg=;
        b=KKVaFlORM9W56WCQiqlDJIEJgWfJ/UQNmmTJuJQpBJxhZOTcyFdRSxPbuEDfQORDoI
         WwNOMw+IsgvPYwsblvMpxlzrTvM7Xe2J9kqTYNfvahka44eAIn72F55+Z8u0VxOrpjwM
         NXoCZPsnJFHylsrWEhTTELr6WqSVl0Cr+mRVcLUR7So6brC2RbC6V0fqTBqsPo3HYieo
         qT/pgF+bvN5TCLyq52+VpM+a+dRqxt6TRAIOONRKiMTH9QUmqGw+FPZgnXITaF95OJMi
         NCGd5GdGsVQu4hkW8nAWc9XQRYI8Iww0whiPHjP2PlZfaRtdEyyYxZZ8gCsp/d2LXllk
         nLJw==
X-Gm-Message-State: AO0yUKUkh/H8brRCTIFjTUMf8nbhXYFI49bE2xKHQ4BSZzUqMjB9vgOO
        BIg795Fsg78rJ5JCV5E3UeiPDDhKqHQ1ydr3SE8=
X-Google-Smtp-Source: AK7set+6hRWgM2r2QyXMC1iDOqd2nc9ihJLVqRYieEQSLsk32fQ3GJjZeRO4TV3s4vCcCHl3SVMTpdaFn/inIkkzUys=
X-Received: by 2002:a17:906:69d3:b0:88d:ba79:4317 with SMTP id
 g19-20020a17090669d300b0088dba794317mr1543087ejs.7.1679501356297; Wed, 22 Mar
 2023 09:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <167950085059.2796265.16405349421776056766.stgit@firesoul> <167950088752.2796265.16037961017301094426.stgit@firesoul>
In-Reply-To: <167950088752.2796265.16037961017301094426.stgit@firesoul>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Mar 2023 09:09:05 -0700
Message-ID: <CAADnVQJz+E9s1wcR-0t7AeuZMaCKBHezQc54mFCqqQ=7KK1D+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 3/6] selftests/bpf: xdp_hw_metadata RX hash
 return code info
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 9:01=E2=80=AFAM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> When driver developers add XDP-hints kfuncs for RX hash it is
> practical to print the return code in bpf_printk trace pipe log.
>
> Print hash value as a hex value, both AF_XDP userspace and bpf_prog,
> as this makes it easier to spot poor quality hashes.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++++---
>  tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/=
testing/selftests/bpf/progs/xdp_hw_metadata.c
> index 40c17adbf483..ce07010e4d48 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> @@ -77,10 +77,13 @@ int rx(struct xdp_md *ctx)
>                 meta->rx_timestamp =3D 0; /* Used by AF_XDP as not avail =
signal */
>         }
>
> -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
> -               bpf_printk("populated rx_hash with %u", meta->rx_hash);
> -       else
> +       ret =3D bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash);
> +       if (ret >=3D 0) {
> +               bpf_printk("populated rx_hash with 0x%08X", meta->rx_hash=
);
> +       } else {
> +               bpf_printk("rx_hash not-avail errno:%d", ret);
>                 meta->rx_hash =3D 0; /* Used by AF_XDP as not avail signa=
l */
> +       }

Just noticed this mess of printks.
Please remove them all. selftests should not have them.
