Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A793C6A9E29
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 19:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjCCSIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 13:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjCCSIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 13:08:41 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EF9DBFB;
        Fri,  3 Mar 2023 10:08:40 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id b10so3271643ljr.0;
        Fri, 03 Mar 2023 10:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y779fsdPllk73iFSKFWEUZhysRcnGSThIiUqv0kC8lg=;
        b=KQ5ad3dwukBu7s19Alqt1gcWpRvIarYj1lmtuc3GkDaEjFb03/azs9cd1TngN9K23v
         vmu+W0tn6okdHwBgFxr+aGF/VaT2R3FJKnW1Zwk9SFCjgW5c2Hb/Nd5m5yAr+RYI3cZG
         20mdAb1LEgNzwaaymymgH6i82VQjTJZgyEV6mALXSl4Ki8VgbLfFcN4NrKH9TcAz24un
         5pEEm23LBnxAXe/Ie7kF8kaEcJx4Grv9HyBh8wwZAmCH6SV9vWuC4evMRp/cIiX2qPXG
         IpETl8ca+Iq1LQTADtDCvb7JGliTo2n/sHIXI3KlyU6Jz3ylD/LWLBxSFslSH1Q4DPJl
         6D9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y779fsdPllk73iFSKFWEUZhysRcnGSThIiUqv0kC8lg=;
        b=FfVFDmTCe4HrXJUaEpJpcQGgGiF2QTCuKL8VrV0UFG9A7nVIoBQR0eYNo0/gBD1qpp
         UoL+/a8wn8tXDypqB3v/FIkHI5KGrgxYkGhivKBd+E/D7Rbx5C4XlHXcJHQYx6xY6v1h
         85VSj2DFEagq02vypGect4lGdmGULyos9WMRKf4YD9fluMZVKnFNdsWCrIcN20ixiloA
         w7YZJRW2MSf6cyxLhzKtGH/aAoY0Jz01xnFG1BYNdpNqTb1+fSRi1iCfPKSvKamk3OKL
         Tavi9/+rOW0Sjo6XLZW6gqhDf5yySdUsBvH48S+5UPYPXaKoasoqbgrJ508cigAZ+eaE
         0dwQ==
X-Gm-Message-State: AO0yUKVMwbsV9tX8KqVeTgYrXSW+LG7lGFVfwWIxeyFrnhqRJJ9jkYZ2
        aWI65siVxwUt/wH0OdJtNC+8UK5UEVAJk7nNPi3f22GD
X-Google-Smtp-Source: AK7set8imPN+V4oquFW31wvcp3uzwidOpMD/0dQQTK7/71jiXTpkZumCeQBM1P6XlCIYcfpHL2Okzyh1ue+X7mRpDpM=
X-Received: by 2002:a2e:b4ae:0:b0:295:a3a8:b2a2 with SMTP id
 q14-20020a2eb4ae000000b00295a3a8b2a2mr836976ljm.9.1677866918365; Fri, 03 Mar
 2023 10:08:38 -0800 (PST)
MIME-Version: 1.0
References: <CAAgLYK7pm06588j+W7F0+2mgfVs1Sr7ioL4x+Bd-TZfV-Zw9Pg@mail.gmail.com>
In-Reply-To: <CAAgLYK7pm06588j+W7F0+2mgfVs1Sr7ioL4x+Bd-TZfV-Zw9Pg@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 3 Mar 2023 10:08:27 -0800
Message-ID: <CABBYNZL2RPLFfjs=EaS4khqLSXjwN2d=1FqY3Z-feX-j_QmOnw@mail.gmail.com>
Subject: Re: [PATCH 1/1] Bluetooth: fix race condition in hidp_session_thread
To:     lm0963 <lm0963hack@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, security@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
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

Hi Tedd,

On Wed, Mar 1, 2023 at 10:18=E2=80=AFPM lm0963 <lm0963hack@gmail.com> wrote=
:
>
> There is a potential race condition in hidp_session_thread that may
> lead to use-after-free. For instance, the timer is active while
> hidp_del_timer is called in hidp_session_thread(). After hidp_session_put=
,
> then 'session' will be freed, causing kernel panic when hidp_idle_timeout
> is running.
>
> The solution is to use del_timer_sync instead of del_timer.
>
> Here is the call trace:
>
> ? hidp_session_probe+0x780/0x780
> call_timer_fn+0x2d/0x1e0
> __run_timers.part.0+0x569/0x940
> hidp_session_probe+0x780/0x780
> call_timer_fn+0x1e0/0x1e0
> ktime_get+0x5c/0xf0
> lapic_next_deadline+0x2c/0x40
> clockevents_program_event+0x205/0x320
> run_timer_softirq+0xa9/0x1b0
> __do_softirq+0x1b9/0x641
> __irq_exit_rcu+0xdc/0x190
> irq_exit_rcu+0xe/0x20
> sysvec_apic_timer_interrupt+0xa1/0xc0
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Min Li <lm0963hack@gmail.com>
> ---
>  net/bluetooth/hidp/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index bed1a7b9205c..707f229f896a 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -433,7 +433,7 @@ static void hidp_set_timer(struct hidp_session *sessi=
on)
>  static void hidp_del_timer(struct hidp_session *session)
>  {
>         if (session->idle_to > 0)
> -               del_timer(&session->timer);
> +               del_timer_sync(&session->timer);
>  }
>
>  static void hidp_process_report(struct hidp_session *session, int type,
> --
> 2.25.1

Looks like CI didn't pick up this one.

--=20
Luiz Augusto von Dentz
