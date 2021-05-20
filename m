Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AF3389BD4
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 05:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhETDYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 23:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhETDYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 23:24:41 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE494C061760
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 20:23:19 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id et19so15896853ejc.4
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 20:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tCF2of9sQthHgOclT2S/qLqJUXtV4c3vy0KdbBzEbuc=;
        b=m0XdNW513Upb+MvPpiula6KZLCIPjnVqUmo2Poj6eNwJ05smeaOtHYllYrAkMISWWG
         h3Nm1EvA5xaRzYk/FU6IQmOADyTrx99ahbO1y6/pStz4o8EJmzPZJ32qUunVs5HjDfV9
         b6GaEKbdDdRYwZvAGfOcHa9fyRbJZ8BXiSvbdoDqRMtzrwaKvaXzzLtzeJkn0G06lQVh
         v8OrBUAPvx15yyTLrMxwxyOvTbgmTLUcXzliPLlGlE34dP5xCQ4Z19OH0JnhoX+iHGH9
         iyEd5a7PmGop44sj2jSPtIN5z8RN8oNEmA2s/LVSUk31YahsE9Hu+kWp4cj3cep1LjI7
         /20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tCF2of9sQthHgOclT2S/qLqJUXtV4c3vy0KdbBzEbuc=;
        b=lmQkjlmiVqlwus7dtLxyTuEqqgA3o8uDYQqq2USa6KCtkKb5bshgnpim7kU1CilZg4
         MtN6at8rlEUS6+55M4mFaupqf4wSRQcPWqoYLuyHqb6LHJVNH3G0fBBJrjlAefojariG
         Vtn+sv95PXZ2ObWDQLehZ9SW39CsvOEl9XsQkb9pOnn3ytw0uD038VOa48gkOU49jaNr
         Yd9N/zyRWJiNPwh91hzEfYu8d7EXO7wWhsemJmjW/3MTdZljjLFSwTAgAnDKdA5PCb18
         8EnmmA4VWNcm+6Ox0htnHdruoddp4sM0t6d58I5UBpehQxMxADY7BIvimfGR0L+jdIof
         Vvhg==
X-Gm-Message-State: AOAM532BMfzIlZqyz+W+zuEYmKqao38hC3koXJFEY2yWks3JUu6Mr5J8
        U0vc6PLo9KTbG/XgDhhxA9exywJrCfSdhAq/gVFt8g==
X-Google-Smtp-Source: ABdhPJw/ed/k3szBOcbgIdWuEuWUOI0l73380mKIEyvkSM5Ss98uwAt20BkDyxKI+R91EfBgAlkyP7K9rTIukTZYaWY=
X-Received: by 2002:a17:906:1496:: with SMTP id x22mr2463605ejc.419.1621480998180;
 Wed, 19 May 2021 20:23:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210519102745.v1.1.I69e82377dd94ad7cba0cde75bcac2dce62fbc542@changeid>
 <73ED48AE-974A-476C-83AD-E6D09CDCBFC9@holtmann.org>
In-Reply-To: <73ED48AE-974A-476C-83AD-E6D09CDCBFC9@holtmann.org>
From:   Yun-hao Chung <howardchung@google.com>
Date:   Thu, 20 May 2021 11:23:07 +0800
Message-ID: <CAPHZWUe0nqia2oHuxe6QQ_=Rt1LAx6rAQAP9QYdaNxSHG2Bu=A@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: disable filter dup when scan for adv monitor
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Yun-Hao Chung <howardchung@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,
Thanks for the comments.

On Thu, May 20, 2021 at 4:47 AM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Howard,
>
> > Disable duplicates filter when scanning for advertisement monitor for
> > the following reasons. The scanning includes active scan and passive
> > scan.
> >
> > For HW pattern filtering (ex. MSFT), some controllers ignore
> > RSSI_Sampling_Period when the duplicates filter is enabled.
> >
> > For SW pattern filtering, when we're not doing interleaved scanning, it
> > is necessary to disable duplicates filter, otherwise hosts can only
> > receive one advertisement and it's impossible to know if a peer is stil=
l
> > in range.
>
> can we be a bit more specific on which controller does what. I am not inc=
lined to always disable duplicate filtering unless your controller doesn=E2=
=80=99t do what you want it to do.

Will update the commit message and submit again.

>
> I also disagree with the last statement. If the device moved out of range=
 (or comes back for that matter) you should get a HCI_VS_MSFT_LE_Monitor_De=
vice_Event event that tells you if a device is in range or not.

The last statement is about software filtering, which is used when
MSFT is not supported. Software filtering in the kernel is basically
doing an LE passive scan. When the duplicate filter is enabled, some
controllers consider packets with the same address but different RSSIs
as duplicate thus not reporting to the host, which makes userspace not
able to tell if a peer is in range or not.
>
> Device leaving:
>
> > HCI Event: LE Meta Event (0x3e) plen 43
>       LE Advertising Report (0x02)
>         Num reports: 1
>         Event type: Non connectable undirected - ADV_NONCONN_IND (0x03)
>         Address type: Random (0x01)
>         Address: 01:9A:1F:C0:30:15 (Non-Resolvable)
>         Data length: 31
>         Flags: 0x1a
>           LE General Discoverable Mode
>           Simultaneous LE and BR/EDR (Controller)
>           Simultaneous LE and BR/EDR (Host)
>         16-bit Service UUIDs (complete): 1 entry
>           Apple, Inc. (0xfd6f)
>         Service Data (UUID 0xfd6f): f47698ff9243617d917ac521b5fcfd436afdb=
285
>         RSSI: -86 dBm (0xaa)
> > HCI Event: Vendor (0xff) plen 18
>         23 79 54 33 77 88 97 68 02 01 15 30 c0 1f 9a 01  #yT3w..h...0....
>         00 00                                            ..
>
> Device coming back:
>
> > HCI Event: Vendor (0xff) plen 18
>         23 79 54 33 77 88 97 68 02 01 95 b9 0b 32 22 2a  #yT3w..h.....2"*
>         00 01                                            ..
> > HCI Event: LE Meta Event (0x3e) plen 43
>       LE Advertising Report (0x02)
>         Num reports: 1
>         Event type: Non connectable undirected - ADV_NONCONN_IND (0x03)
>         Address type: Random (0x01)
>         Address: 2A:22:32:0B:B9:95 (Non-Resolvable)
>         Data length: 31
>         Flags: 0x1a
>           LE General Discoverable Mode
>           Simultaneous LE and BR/EDR (Controller)
>           Simultaneous LE and BR/EDR (Host)
>         16-bit Service UUIDs (complete): 1 entry
>           Apple, Inc. (0xfd6f)
>         Service Data (UUID 0xfd6f): 0b861791a0fb7adcf8b45f951f7d4b7c7fc8e=
3fd
>         RSSI: -27 dBm (0xe5)
>
> Regards
>
> Marcel
>
