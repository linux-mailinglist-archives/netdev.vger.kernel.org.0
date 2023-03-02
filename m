Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A49D6A7EA0
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 10:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjCBJti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 04:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCBJtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 04:49:14 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D60C3B67D;
        Thu,  2 Mar 2023 01:49:02 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id cp12so8959841pfb.5;
        Thu, 02 Mar 2023 01:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677750542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8k7xdMTs98SUbySINVMkdahCZ8tdQstE20TVY0Lg2SE=;
        b=Psw6N5ZoYgD6r3SZ2FHg2jRXnwle5uBbnLe72PF5nbFrpa8cy6650zBdr7+7zCF/nK
         gi3Ok1sZbWUHa0U4YYc5L+dzU+F3mba1ig/duuAyu3TdY4kFxb61lQV02p9SRWADVWHs
         veaeM+0bfnWfjV6enVE2qIwMfyAdMcA1OtvYsrNcpcRQKyLu839Fdb8w9vUaS5IVkzvr
         9oDLl6HZnASNsefCv/gLnHMq/4t0mTWSifa/GFzPyc2zQYuTYeJfTmlJ/Yt4CeWZY7+K
         J9zBcT4xVey6U8b9heDyP4RS6xqT/dZZu3toW6atJBZudEJAMMDMb6M8NbCbhZENUQSG
         pSvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677750542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8k7xdMTs98SUbySINVMkdahCZ8tdQstE20TVY0Lg2SE=;
        b=wEPNzuDQ34+57MS91uXjF2XSm32/V8B73MHW9Mb1p41SuDx9RA/2PqY7n+NpMIz/5v
         PXt1CDUwTdl2WHqcxWY07C+1o0dCVG6cHc/jP2EVU1mYlCCf7AZM4/DUNM/NJmRzUcAS
         q+7X5IV7jMdOpzUVoaQVSYMqM4OtxF93Vrct9DylPp+NM/AzgHlpsEO6gMRl5fC4ag1i
         JTMlUEfyMf7qbF0GMBhJWA/kiCMTIOB7NfqNLJuhY14lJbPuobP2fs1PvQR9Lb2d1bqs
         SUeGBjrxPgycpmyPUQ06rLhZIPn4HTigc4EaG+h8xSw1v99xSr5usnW6pZHLTvrbDdTc
         vl3Q==
X-Gm-Message-State: AO0yUKUsg+Yu1AQw2fp34BWJ3wYBtJoZMb8GEyWRF5apuSGTEO030LY4
        MRBx5xOxoRZzJ7o/axr6a9Zyi+eB7J6XS8rF16Y=
X-Google-Smtp-Source: AK7set91zvVgRNAOv1HOpXZ+ZgjU+mx/hJ2YE5tSxQR7zMThZ7eKqc1J2+TabA4i4a6fNFbjtrcEgHucXb81gt5mhvE=
X-Received: by 2002:a63:3388:0:b0:4f2:8281:8afb with SMTP id
 z130-20020a633388000000b004f282818afbmr3266580pgz.4.1677750541823; Thu, 02
 Mar 2023 01:49:01 -0800 (PST)
MIME-Version: 1.0
References: <20230218075956.1563118-1-zyytlz.wz@163.com> <Y/U+w7aMc+BttZwl@google.com>
 <CAJedcCzmnZCR=XF+zKHiJ+8PNK88sXFDm5n=RnwcTnJfO0ihOw@mail.gmail.com>
 <Y/aHHSkUOsOsU+Kq@google.com> <CAJedcCykky7E_uyeU=Pj1HR0rcpUTF1tKJ-2UmmM33bweDg=yw@mail.gmail.com>
 <CAJedcCztEkE=EB2GmH=BpTvD=r_bwGXk3RYDM2FU=f_SvEaJHA@mail.gmail.com> <Y/kupIIGBHQ2rQIZ@google.com>
In-Reply-To: <Y/kupIIGBHQ2rQIZ@google.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Thu, 2 Mar 2023 17:48:49 +0800
Message-ID: <CAJedcCzKi89D+CEwrwgwT_=eXYjt3dh-m10Q8bxE9ZRB04PK+Q@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: Fix use-after-free bug due to race condition
 between main thread thread and timer thread
To:     Brian Norris <briannorris@chromium.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, ganapathi017@gmail.com,
        alex000young@gmail.com, amitkarwar@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Norris <briannorris@chromium.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=8825=
=E6=97=A5=E5=91=A8=E5=85=AD 05:39=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Feb 24, 2023 at 02:17:59PM +0800, Zheng Hacker wrote:
> > This email is broken for the statement is too long, Here is the newest =
email.
>
> It still wraps a bit weird, but it's good enough I suppose.
>
> >               retn -EINPROGRESS in mwifiex_init_fw
> >               mwifiex_free_adapter when in error
>
> These two statements don't connect. _mwifiex_fw_dpc() only treats -1 as
> a true error; -EINPROGRESS is treated as success, such that we continue
> to wait for the command response. Now, we might hang here if that
> response doesn't come, but that's a different problem...
>

Hi Brain,

Sorry for my unclear description. As you say, they don't have any connectio=
n.
What I really want to express is after mwifiex_init_fw return -EINPROGRESS
to its invoker, which is _mwifiex_fw_dpc. It will pass the check of
return value,
as the following code.
```cpp
ret =3D mwifiex_init_fw(adapter);
  if (ret =3D=3D -1) {
    goto err_init_fw;
  } else if (!ret) {
    adapter->hw_status =3D MWIFIEX_HW_STATUS_READY;
    goto done;
  }
```

 it continues executing in _mwifiex_fw_dpc. Then in some unexpected situati=
on,,
it'll get into error path like mwifiex_init_channel_scan_gap return non-zer=
o
code if there is no more memory to use. It'll then get into err_init_chan_s=
can
label and call mwifiex_free_adapte finally.  The other thread may USE it
afterwards.

```cpp
if (mwifiex_init_channel_scan_gap(adapter)) {
    mwifiex_dbg(adapter, ERROR,
          "could not init channel stats table\n");
    goto err_init_chan_scan;
  }
```
> I'm sure there are true bugs in here somewhere, but I've spent enough
> time reading your incorrect reports and don't plan to spend more. (If
> you're lucky, maybe you can pique my curiosity again, but don't count on
> it.)
>

BUT after reviewing the code carefully, I found this might not happen
due to some  exclusive condition. So yes, I also think there is still some
problem here but I'm kind of busy nowadays. I promise to attach a clearer
report next time.

So sorry to bother you so many times. And appreciate for your precious
time spending on this report.

Best regards,
Zheng
