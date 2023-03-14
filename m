Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2972D6B87E0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 02:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjCNBzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 21:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCNBzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 21:55:12 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686A12A15F;
        Mon, 13 Mar 2023 18:55:11 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id da10so56263306edb.3;
        Mon, 13 Mar 2023 18:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678758910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N28svmyIsAWGdrM27Nlai5erQJC9DbR4XhMb+34QWbw=;
        b=cJPsjEfT+rcle0IaupiHCAyk/0xW55N1WXloD4bwDa2nmJTt7MlcpkWsQicR/7fAN+
         lCTQJmYgkt6DnA3SPxqoTYWJ6qomxgvjN/o3Eyx9oZ/0/lHR9lLOemdVu5D+pzHVG0p7
         rkegnBri1uHAEVaNoaTFx/hv+cAlOzKt4Kg4pgAfAMxlfBWPn6zupE6b0yIKxFtbdDC2
         NkJ3YIDEJYL1gEMZOLmhFnDbGU08sBg7hioUuZ1Kw+JvRieUM8abMLNUEDkOYg0ornH7
         CcQJFe5XmEf9EyrQTuAMFiLkyeJ7IzPGHeVDrWmDl51Diaofjd/k3WrehSXyDl7Y2qCs
         rs1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678758910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N28svmyIsAWGdrM27Nlai5erQJC9DbR4XhMb+34QWbw=;
        b=Bg7fteNzlVn7ITBXLY7rc7LkxWnWl6TyTzQAyufeFioiOmMo25iZCeYdV6cisZe9O3
         vjw51eYwwkBBN5PxE2f4xcr6CEAc+qpbH+paE3yqMpyVEAsEZACLLk6l2B9u2pVJLtGu
         foNFhaT6zJhCDyjXLlVQuZomaNNiOgcNLHpnXF5DKpmiyTDEr5Hglzt+RSiZt167cvLX
         M43/WrMgpPoRkCXWEw5aK/wWhy9CgppUZiCab1LBMoAIyHvdT55AZsyDCr+vWZMobLle
         82NZUJFYX3+OC0LCT6eiaTcAkVaP8dMMUaartje42GoBJBvNFS7EY+C5bqtAxHtIHpYc
         jV0g==
X-Gm-Message-State: AO0yUKULGCEwc29HZoZxgPXCi2U0zE6i8KH3xqKGBrk6kzm4bHoQInkn
        xPftdKDGyqZTkcvbHINPh5P6AxuXxIUBv63gUUY=
X-Google-Smtp-Source: AK7set/RGyJl+Ybq1hy2nHkRv/VjeinySR49rJaPFOgpQx3uG/VxP7vJKHBiV39VqKHgiiosZxiG3NVFYL2HLB/+WjQ=
X-Received: by 2002:a50:9e25:0:b0:4fa:3c0b:748 with SMTP id
 z34-20020a509e25000000b004fa3c0b0748mr4913148ede.4.1678758909860; Mon, 13 Mar
 2023 18:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230311151756.83302-1-kerneljasonxing@gmail.com>
 <CANn89iKWewG7JZXQ=bmab9rSXUs_P5fX-BQ792QjYuH151DV-g@mail.gmail.com>
 <CAL+tcoAchbTk9ibrAVH-bZ-0KHJ8g3XnsQHFWiBosyNgYJtymA@mail.gmail.com>
 <CANn89i+uS7-mA227g6yJfTK4ugdA82z+PLV9_74f1dBMo_OhEg@mail.gmail.com>
 <CAL+tcoCsQ18ae+hUwqFigerJQfhrusuOOC63Wc+ZGyGWEvSFBQ@mail.gmail.com> <CANn89iLWTie6bZZR3fkuOPfVWgjmiV9er_6MPbbcM2AE13ZQLQ@mail.gmail.com>
In-Reply-To: <CANn89iLWTie6bZZR3fkuOPfVWgjmiV9er_6MPbbcM2AE13ZQLQ@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 14 Mar 2023 09:54:33 +0800
Message-ID: <CAL+tcoCbvGd_3Mn82vjyy4AXcJntZG2rL1bnJP81H0T+=j2+7w@mail.gmail.com>
Subject: Re: [PATCH net-next] net-sysfs: display two backlog queue len separately
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
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

On Tue, Mar 14, 2023 at 1:34=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Mon, Mar 13, 2023 at 10:16=E2=80=AFAM Jason Xing <kerneljasonxing@gmai=
l.com> wrote:
>
> >
> > Thanks for the guidance. Scaling is a good way to go really. But I
> > just would like to separate these two kinds of limits to watch them
> > closely. More often we cannot decide to adjust accurately which one
> > should be adjusted. Time squeeze may not be clear and we cannot
> > randomly write a larger number into both proc files which may do harm
> > to some external customers unless we can show some proof to them.
> >
> > Maybe I got something wrong. If adding some tracepoints for those
> > limits in softnet_data is not elegant, please enlighten me :)
> >
>
[...]
> I dunno, but it really looks like you are re-discovering things that
> we dealt with about 10 years ago.
>
> I wonder why new ways of tracing stuff are needed nowadays, while ~10
> years ago nothing
> officially put and maintained forever in the kernel was needed.

Well, that's not my original intention. All I want to do is show more
important members in softnet_data to help users know more about this
part and decide which one to tune.

I think what you said (which is "You can not pretend the sum is zero,
some user space tools out there
would be fooled.") is quite right, I can keep this
softnet_backlog_len() untouched as the old days.

Thanks,
Jason
