Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD946DECA5
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 09:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjDLHh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 03:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjDLHh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 03:37:27 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479DA1BDA
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 00:37:26 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id v10so9597682vsf.6
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 00:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681285045; x=1683877045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZgV7mLYYfabq5SngD7+7YmHntm4dL0EOu2XmAvb6WeM=;
        b=CJEPNpIG+JJu+arUHwyO6SYyeX7P+O/0pwWXrPQ7o8ILjlPO7lyUNnXHr5CqH7Oawn
         uqMpkH1WvE2GKkAcUMx9+GcT2gHaYfy7C7EUYH/6OX8mQ9lyeawLnbumsswSr2yxfO6V
         /HvlgWUvIq8ndOnMDc7Xe+A5FBovsPX3rCsdrauGujhPwvDdxJfHBEeAugf32rtjQkAQ
         DVO3iRjxQPUX1/hEC+eE5Uz+5Gw/TSUze1RqKGOSC7WlaT7R/rxRO4YX1tdVUZ3BXoTm
         jxphEVVJfmgKHsdcd/6TouDlmMJjw1LXT3gQvYuMZb2hkTSlzcEREEHILKTSY+fNoQwV
         aCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681285045; x=1683877045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZgV7mLYYfabq5SngD7+7YmHntm4dL0EOu2XmAvb6WeM=;
        b=WJic07qBuFOWasDqd6uqNWdLopGdB4tU6vxzrnpr2r9WIL4RXTKC+OJ06ySHIUUwqT
         PtqsnjuD5dndaL1mGLPEu6+v+iiH9W3HX3UhmAJQ/Hq8oCEIMAmLps1hLgroCEpkliFf
         edVzs6NnNljD2/+TeZkZLCrwxPb9rRIz/1dBunuzmHqLmUTRilk8uGCwom4pC9Fr6S4V
         jLT9lEVr9EjlXA78aRMFe/eSXD8bmSYuZtbSt7hrQTKHX6WWFNVBQREaKvTxP8YxpemX
         UtUA7tWhJxMZn+zBjjyOwT9PuIo+wnEe8j5fs7EvUmrCaJ3ZnCUGz/WEjWl9BaLDrROZ
         mglQ==
X-Gm-Message-State: AAQBX9c242SNbAi3bZa3+BgGgAG0kBTEKewX8hvGWAFVtgxnyR0A2Jjh
        qIWehtQNBRL6NcYeguOfyGjKZG4g8b+Pw9d6snzO6A==
X-Google-Smtp-Source: AKy350Y7d95c7K1/2E5QLZTreMqU4hF07BLnaGfLZtIHDI8GzgaOc2+fcggGwRaK/v4/G1YN1JgaYiADXhDYQSWi2wQ=
X-Received: by 2002:a67:b74c:0:b0:425:d255:dd38 with SMTP id
 l12-20020a67b74c000000b00425d255dd38mr10252865vsh.1.1681285045193; Wed, 12
 Apr 2023 00:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuogkamdKf9+uwsvKh67NGTjZru3feRVyHhEQPhpqipVg@mail.gmail.com>
 <CADvbK_cZwoGEmMXZ2p18MzcAkLo3PcMw8Uym2Fa3Za6-5JiA=A@mail.gmail.com>
In-Reply-To: <CADvbK_cZwoGEmMXZ2p18MzcAkLo3PcMw8Uym2Fa3Za6-5JiA=A@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 12 Apr 2023 13:07:13 +0530
Message-ID: <CA+G9fYuuZQv1Ode6pCR3ZuUKADuYy+vmuoaqeT-S-L46jMwP_Q@mail.gmail.com>
Subject: Re: selftests: net: sctp_vrf.sh: # sysctl: error: 'net.sctp/l3mdev_accept'
 is an unknown key
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 at 03:16, Xin Long <lucien.xin@gmail.com> wrote:
>
>
>
> On Tue, Apr 11, 2023 at 1:00=E2=80=AFPM Naresh Kamboju <naresh.kamboju@li=
naro.org> wrote:
>>
>> The selftests net sctp_vrf.sh test case failed due to following errors.
>> Do you see these errors / warnings at your end ?
>>
>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>
>> # selftests: net: sctp_vrf.sh
>> # modprobe: FATAL: Module sctp not found in directory /lib/modules/6.3.0=
-rc6
>> # modprobe: FATAL: Module sctp_diag not found in directory
>
> # CONFIG_IP_SCTP is not set
> This is a test for SCTP module, you should enable it before running this =
test.
> I will add it in tools/testing/selftests/net/config

That would be the right place to add pre required configs.

>
> Thanks for reporting.

I am happy to test your next / upcoming patches.
Please share your development repo / branch or CC me on patches .

- Naresh
