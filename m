Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B88A50EFFB
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 06:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243529AbiDZEig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 00:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbiDZEib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 00:38:31 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDB46831A;
        Mon, 25 Apr 2022 21:35:24 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id c125so18122129iof.9;
        Mon, 25 Apr 2022 21:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=frgqbBmEnlLOFkP5YQ4kOPLeHQM9VGrk+Z9lDLuwteY=;
        b=fuTPWvdIbbSrrzCFmPB61LaqlpMmWCsBW+Cf6tVztqhkjWbmHtHWh4YGNFpvI0KN34
         wMYjp2l8kUJocGct62qVYItbLFTQu8I6nPuG6MX+PIhwzrjc4STlMVYVFxOzO0Iteh/A
         7VmkgIM+whoQZUjfyLYLhCmPii+tQE6RyVD1nfIa/H/gTde0jvwfav5G4iB+92Jrduhi
         4DqwmfTTktTwD0txUHLKIpR5GS13pXR1QtyhEgxVHiSPmsgDftVbvcu6lVYc6KMVmRtX
         wmuW6kId0zUTMKMZlIHYMzfa1y4qUHcqBTG8tOQ2he+DYzHQr2OD77aXkqtXIQrgugWZ
         VNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=frgqbBmEnlLOFkP5YQ4kOPLeHQM9VGrk+Z9lDLuwteY=;
        b=v1BiyliNqx1Zmn+1nsPj+0CEzrzjhzdrRCHyErw4xcrDtMijJMKR28gs1S7krJOzij
         HdSpY+RbYMLp8SHOVrTlNIoswYQ9lZncW5LC8jmjQMLy78WSGPiDR3J/prKRZKk44Gvx
         jS6mwebKbHsMMNxBD1yUuXmM+TaGSBjT/tDZPdE8acuhZCg2X4Wx+VODMdd5VNuky7fV
         5stzEzM4T2VaWBiMOBokDVzmzQXy9doFJkcq22Hz7h5oqbLlMgWFvYfdRaYNX9P+O2In
         R43McAzwRYDq6ysUTFP//CDil7/iX4nM8cuHxlKatPrDx1PnKXrFQpPcYQ2erIh5x0JM
         L1hQ==
X-Gm-Message-State: AOAM530QonFaBW3JNfypgKvRzSf5R7sYrT0KBP9hxqXqjSUm1/ABBPmN
        jRGOhKlQeOmB+l0k3t7Z55QJiZrHz2P0nkdZOGk=
X-Google-Smtp-Source: ABdhPJwI43GdLiN5OgE0tsEwSFiZuSsR4oCVXkxjdQsO9ddZcNUD4npdTkeiSjKpGxZ5IIlNeb0ri3TiIaOTH2wlsFo=
X-Received: by 2002:a5d:9f4e:0:b0:652:2323:2eb8 with SMTP id
 u14-20020a5d9f4e000000b0065223232eb8mr8494566iot.79.1650947724372; Mon, 25
 Apr 2022 21:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220421120925.330160-1-shaozhengchao@huawei.com>
In-Reply-To: <20220421120925.330160-1-shaozhengchao@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Apr 2022 21:35:13 -0700
Message-ID: <CAEf4BzY=VajaEH_09FX0-wuPFCJ6te=shZa0jj2Jc7ukL-WzMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: detach xdp prog when program exits
 unexpectedly in xdp_rxq_info_user
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 5:07 AM Zhengchao Shao <shaozhengchao@huawei.com> w=
rote:
>
> When xdp_rxq_info_user program exits unexpectedly, it doesn't detach xdp
> prog of device, and other xdp prog can't be attached to the device. So
> call init_exit() to detach xdp prog when program exits unexpectedly.
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  samples/bpf/xdp_rxq_info_user.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>

you are introducing a new compilation warning, please fix it


/data/users/andriin/linux/samples/bpf/xdp_rxq_info_user.c: In function
=E2=80=98options2str=E2=80=99:
/data/users/andriin/linux/samples/bpf/xdp_rxq_info_user.c:153:1:
warning: control reaches end of non-void function [-Wreturn-type]
  153 | }
      | ^

It also would be good to instead use bpf_link-based XDP attachment
that would be auto-detached automatically on process crash
(bpf_link_create() FTW). Please consider also converting this sample
to skeleton (and then bpf_program__attach_xdp() as high-level
alternative to bpf_link_create()).

> diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_u=
ser.c
> index f2d90cba5164..6378007e085a 100644
> --- a/samples/bpf/xdp_rxq_info_user.c
> +++ b/samples/bpf/xdp_rxq_info_user.c
> @@ -18,7 +18,7 @@ static const char *__doc__ =3D " XDP RX-queue info extr=
act example\n\n"
>  #include <getopt.h>
>  #include <net/if.h>
>  #include <time.h>

[...]
