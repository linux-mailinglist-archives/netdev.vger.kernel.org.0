Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9216A168C
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 07:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBXGSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 01:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBXGSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 01:18:12 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A665193FE;
        Thu, 23 Feb 2023 22:18:11 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u14so11763038ple.7;
        Thu, 23 Feb 2023 22:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uh1BADvsznN4RUsd8adGaJ+YT4nOwKm9q7+MoMWkhfI=;
        b=Oj0AlBw9nPBEAuYH6Zp9xfFdj/uDLd5h2JxXPJo2mkwmEIG+YIBnpcyxt6En3gsH4O
         69DiFDn7eqBmUjGsyGJ+tbLb9OMf8JvCHq93E0M02ZusY5I3xjUHxffFJHtlylcMCcar
         PZn4szmuL1yrMmpirUEgvqv+fzpSKF5bg0CkVjIPu9V37lATfYhxnb66Ro0DuLd2cxDu
         8RX4YXsYtA/9DV/h215G6abuUAhkM7Yazzrut3i+/M/c13LovmrfByW8UTSPcVMW5C5A
         0qk0bodOwO6FE0iC8m7JFegDYnW3sQLMdFF5yQnSAbIkGf8iT2mgP3hHCeAe2By4K630
         jmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uh1BADvsznN4RUsd8adGaJ+YT4nOwKm9q7+MoMWkhfI=;
        b=dwhZGpcOYQO7d+VC0A6BgCCIuBumc6sUJ8CjT6PYLYc8wVps5jqwE/NGPP44iDphkb
         A4ZjJSg/pgFXRm/P+ff7pmTWLPCVjC/tpzqVGWG6M/zVIiSa8MOoGfLLyQf3fSnHpVU5
         utdwPwGUjY1kEdf4ZXjI888gYbMQH0mDBDA3N/6NfIxN72sEk6j2GUJEXMp9HHGpBQad
         RgENdryrN0yPgSviNklLh7bd2nVVA9RMqUb4wouslFEXfEsTpRc172ptVCBIq/X0HNW1
         JFt39FHaWI/2iP/8tbim/NWpNS3m3S07/w6oseyT+I0DBATaRr1D2DjUAKXu9vr20Prv
         s2VA==
X-Gm-Message-State: AO0yUKXYi11ZSHcSMibL5EGYliGuA6lmyHPupPqWGWHQdz2DFImLfTQ4
        nHWpcFiFukM8pX24JwnZuSa6QTaIKArmMGC0f+Y=
X-Google-Smtp-Source: AK7set96miM1DpgomVE+BwBqIIsKAwTsrNHpt/NNqSc7T3qbIW6Ee7gq1OwKRDc/uu5yR8IcPxjLbpujFd6qBYJ+8eE=
X-Received: by 2002:a17:902:ef8a:b0:19a:8259:c754 with SMTP id
 iz10-20020a170902ef8a00b0019a8259c754mr2507373plb.0.1677219491018; Thu, 23
 Feb 2023 22:18:11 -0800 (PST)
MIME-Version: 1.0
References: <20230218075956.1563118-1-zyytlz.wz@163.com> <Y/U+w7aMc+BttZwl@google.com>
 <CAJedcCzmnZCR=XF+zKHiJ+8PNK88sXFDm5n=RnwcTnJfO0ihOw@mail.gmail.com>
 <Y/aHHSkUOsOsU+Kq@google.com> <CAJedcCykky7E_uyeU=Pj1HR0rcpUTF1tKJ-2UmmM33bweDg=yw@mail.gmail.com>
In-Reply-To: <CAJedcCykky7E_uyeU=Pj1HR0rcpUTF1tKJ-2UmmM33bweDg=yw@mail.gmail.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Fri, 24 Feb 2023 14:17:59 +0800
Message-ID: <CAJedcCztEkE=EB2GmH=BpTvD=r_bwGXk3RYDM2FU=f_SvEaJHA@mail.gmail.com>
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

This email is broken for the statement is too long, Here is the newest emai=
l.

Hello Brain,

Thanks for your detailed review. Sorry we missed something. As you say, We =
are
lacking some consideration, the pointed race path could not happen. But aft=
er
diving deep into the code, we found another path.

Here is the possible path. In summary, if the execution of CPU1 is
stuck by fw_done,
the cpu0 will continue executing and free the adapter gets into
error-path. The cpu1
did not notice that and UAF happened.

If there is something else we didn't know, please feel free to let us know.

        CPU0                                         CPU1
mwifiex_sdio_probe
mwifiex_add_card
mwifiex_init_hw_fw
request_firmware_nowait
  mwifiex_fw_dpc
    _mwifiex_fw_dpc
      mwifiex_init_fw
        mwifiex_main_process
          mwifiex_exec_next_cmd
            mwifiex_dnld_cmd_to_fw
              mod_timer(&adapter->cmd_timer,..)


                                              mwifiex_cmd_timeout_func
                                                if_ops.card_reset(adapter)
                                                  mwifiex_sdio_card_reset
                                                  [*] stuck in
mwifiex_shutdown_sw


              retn 0 in mwifiex_dnld_cmd_to_fw
              retn 0 in mwifiex_exec_next_cmd
              retn 0 in  mwifiex_main_process
              retn -EINPROGRESS in mwifiex_init_fw
              mwifiex_free_adapter when in error
              // free adapter
              complete_all(fw_done);


                                              [*]Go on
                                              Use adapter->fw_done

Best regards,
Zheng


Zheng Hacker <hackerzheng666@gmail.com> =E4=BA=8E2023=E5=B9=B42=E6=9C=8824=
=E6=97=A5=E5=91=A8=E4=BA=94 13:37=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello Brain,
>
> Thanks for your detailed review. Sorry we missed something. As you say, W=
e are
> lacking some consideration, the pointed race path could not happen. But a=
fter
> diving deep into the code, we found another path.
>
> Here is the possible path. In summary, if the execution of CPU1 is
> stuck by fw_done,
> the cpu0 will continue executing and free the adapter gets into
> error-path. The cpu1
> did not notice that and UAF happened.
>
> If there is something else we didn't know, please feel free to let us kno=
w.
>
>         CPU0                                                        CPU1
> mwifiex_sdio_probe
> mwifiex_add_card
> mwifiex_init_hw_fw
> request_firmware_nowait
>   mwifiex_fw_dpc
>     _mwifiex_fw_dpc
>       mwifiex_init_fw
>         mwifiex_main_process
>           mwifiex_exec_next_cmd
>             mwifiex_dnld_cmd_to_fw
>               mod_timer(&adapter->cmd_timer,..)
>                                                         mwifiex_cmd_timeo=
ut_func
>
> if_ops.card_reset(adapter)
>
> mwifiex_sdio_card_reset
>                                                             [*] stuck
> in mwifiex_shutdown_sw
>               return 0 in mwifiex_dnld_cmd_to_fw
>                 return 0 in mwifiex_exec_next_cmd
>                   return 0 in  mwifiex_main_process
>                     return -EINPROGRESS in mwifiex_init_fw
>                       get into error path, mwifiex_free_adapter
>                         // free adapter
>                         complete_all(fw_done);
>                                                               [*]Go on
>                                                               Use
> adapter->fw_done
>
>
> Best regards,
> Zheng
>
>
> Brian Norris <briannorris@chromium.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=882=
3=E6=97=A5=E5=91=A8=E5=9B=9B 05:20=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Wed, Feb 22, 2023 at 12:17:21PM +0800, Zheng Hacker wrote:
> > > Could you please provide some advice about the fix?
> >
> > This entire driver's locking patterns (or lack
> > thereof) need rewritten. This driver was probably written by someone
> > that doesn't really understand concurrent programming. It really only
> > works because the bulk of normal operation is sequentialized into the
> > main loop (mwifiex_main_process()). Any time you get outside that,
> > you're likely to find bugs.
> >
> > But now that I've looked a little further, I'm not confident you pointe=
d
> > out a real bug. How does mwifiex_sdio_card_reset_work() get past
> > mwifiex_shutdown_sw() -> wait_for_completion(adapter->fw_done) ? That
> > should ensure that _mwifiex_fw_dpc() is finished, and so we can't hit
> > the race you point out.
> >
> > Note to self: ignore most "static analysis" reports of race conditions,
> > unless they have thorough analysis or a runtime reproduction.
> >
> > Brian
