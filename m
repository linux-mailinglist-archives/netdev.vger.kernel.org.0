Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3161C6A164E
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 06:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBXFhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 00:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBXFhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 00:37:39 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA8418166;
        Thu, 23 Feb 2023 21:37:38 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id il18-20020a17090b165200b0023127b2d602so1588233pjb.2;
        Thu, 23 Feb 2023 21:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3CviGV7t33SNeYpDjbt8w9RDuPB9SsJDazDQkC60W8=;
        b=jffT47FeYhMfzu7dDp16u/Vry66wSVVTsGmjCNxa4dgsIGUjAp3pk34DBqRUDvIzEa
         k1dAcoNlTbLKlMAvLTGbP7n4ZIbDzaZofFutiFWxz0EJtawVbWqmYmHDo7O9vq9qUKRl
         0pBR1eqJxMQ2BD/99aS7ACXOs5RkDZodBEDlWgkVktbWZbQG6yFr7UwB+WzmBEEaCLMv
         EryezaMrPOBCD5+CE7b7R1XhGnwjHX4TE6az00MyfSTlYtqEMbcLkpo41KHEEiYDWZL8
         BmUYGARVFIqAme2YSJebip4pUb3qa7J3jCtSkE5omTsq97mCnS2mKhk6yvAm094ZdWaU
         CkmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v3CviGV7t33SNeYpDjbt8w9RDuPB9SsJDazDQkC60W8=;
        b=b7AtENyjvfQmkEFiXZyjTKxv0u7uNdhco6CTTqmK85Q5sFwIGJJ8Y9963sjL93c4aV
         AQ9cpRPZFJm+9Qzz9HwDqohSaitWAK0nNgMJJxZKVQjDYqVxgJcHnAq0Pe8jwlfkMe5e
         f2HWgtHq+WCkxqO3jd/EhYvf3SrNK/YtkHNrZwPebKxumK+0Ett35miwvYtadw3/FZpu
         E25AwxICCY/dqS/8+04L0uCvRbOw33ys4vGPRErBkGJ52oEX/ydTIXW6m2gpCswlbu5A
         /gjTOmspgy7aco6J7Hh5AKOBislpvEOet3QGv5EeYi2HX8FO20wYhflzwvDSALDKkN48
         wpcg==
X-Gm-Message-State: AO0yUKUBbdG5uCRPyn4hS8rYNa0jUHloJcNWVzM8KP87pAA38VL12x/g
        ZC52yu0k9lSQzzodEFzDx9JnQZX9oLChHbw36dk=
X-Google-Smtp-Source: AK7set/uq7hBk7H8CoI6VdRiUPsZCA05AQSUugYgQalOd+kV8eA9+S0ODLtc+3HpUtupDQsksTYBnKW6DcicBe5u0QY=
X-Received: by 2002:a17:903:428a:b0:19a:ac0b:9d93 with SMTP id
 ju10-20020a170903428a00b0019aac0b9d93mr2616680plb.0.1677217057684; Thu, 23
 Feb 2023 21:37:37 -0800 (PST)
MIME-Version: 1.0
References: <20230218075956.1563118-1-zyytlz.wz@163.com> <Y/U+w7aMc+BttZwl@google.com>
 <CAJedcCzmnZCR=XF+zKHiJ+8PNK88sXFDm5n=RnwcTnJfO0ihOw@mail.gmail.com> <Y/aHHSkUOsOsU+Kq@google.com>
In-Reply-To: <Y/aHHSkUOsOsU+Kq@google.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Fri, 24 Feb 2023 13:37:26 +0800
Message-ID: <CAJedcCykky7E_uyeU=Pj1HR0rcpUTF1tKJ-2UmmM33bweDg=yw@mail.gmail.com>
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

        CPU0                                                        CPU1
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
                                                        mwifiex_cmd_timeout=
_func

if_ops.card_reset(adapter)

mwifiex_sdio_card_reset
                                                            [*] stuck
in mwifiex_shutdown_sw
              return 0 in mwifiex_dnld_cmd_to_fw
                return 0 in mwifiex_exec_next_cmd
                  return 0 in  mwifiex_main_process
                    return -EINPROGRESS in mwifiex_init_fw
                      get into error path, mwifiex_free_adapter
                        // free adapter
                        complete_all(fw_done);
                                                              [*]Go on
                                                              Use
adapter->fw_done


Best regards,
Zheng


Brian Norris <briannorris@chromium.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=8823=
=E6=97=A5=E5=91=A8=E5=9B=9B 05:20=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Feb 22, 2023 at 12:17:21PM +0800, Zheng Hacker wrote:
> > Could you please provide some advice about the fix?
>
> This entire driver's locking patterns (or lack
> thereof) need rewritten. This driver was probably written by someone
> that doesn't really understand concurrent programming. It really only
> works because the bulk of normal operation is sequentialized into the
> main loop (mwifiex_main_process()). Any time you get outside that,
> you're likely to find bugs.
>
> But now that I've looked a little further, I'm not confident you pointed
> out a real bug. How does mwifiex_sdio_card_reset_work() get past
> mwifiex_shutdown_sw() -> wait_for_completion(adapter->fw_done) ? That
> should ensure that _mwifiex_fw_dpc() is finished, and so we can't hit
> the race you point out.
>
> Note to self: ignore most "static analysis" reports of race conditions,
> unless they have thorough analysis or a runtime reproduction.
>
> Brian
