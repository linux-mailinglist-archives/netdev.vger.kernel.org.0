Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFFC52C8F4
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiESAwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiESAw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:52:26 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3121144D
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 17:52:24 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id k2so3874264qtp.1
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 17:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S0+jmwEOWiKOTo/k5OEQthbmqv/hkgrZFNjiclaFXi0=;
        b=eiRPbDJCWqtOno4GgFN1JeVpxSXvX1Qts3tC+TSSXFfcJ+EFDxHrQUzh3iEvbL8dlX
         ZMmPFoHbU5T8JQbL8EnpGUG7SRlwV7qPIFG/aPTmA/7giQ4LYrjgIqusAVYxM5kGI6mt
         A1UMOOaw1B3HQPmTRaFvjl2A+EwOkMf5UelU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S0+jmwEOWiKOTo/k5OEQthbmqv/hkgrZFNjiclaFXi0=;
        b=5GA9s+fRhqsFUM9EnLzIp1rID4FKBP94KfW4OrbuP2+tanSyw0n/AhLCbbWk88riT9
         4AuweXU0qFo+R6PEPtEGqpzbl/e7nmKnU30YKLH4mgWDT+XJhXqa0F5T/WqDSmKEuKP4
         /M3mpr10horrVUiC0m50p2q362zfC50K1i8tWf4KVbn15Anz4MW3YdOtmVgO479a3Fr2
         Bdz8uQsxgJLZNQjOGFqxs5/xkRHbR/DoabbpNvLOPwSSuLvAyqYVUm+cR4SA/P8qx6pg
         8+57aHWN2epnjSu3g5rtZojG6dlXvAPRAEERAv5LBSDb6vIA6Pj9cSKHNU0E2Tk3FucU
         AfiA==
X-Gm-Message-State: AOAM530EF4li/PzTpjdMfXC2ZY3wPcbDGKoNqCwIUYsxQUYdJfMAhwH5
        NJZAlqegAUWqnoMsp8asQDHllbzPEICxSxaHZcRMwQ==
X-Google-Smtp-Source: ABdhPJxBpTGudz6PD0R70aPCdSct7ZP9XfQyxTj+HKqfZOZiVu6UvtZoRhU1BLFiZKVzOr62JVTHx7Krkzo+VH4ZN6U=
X-Received: by 2002:a05:622a:1012:b0:2f3:ce26:9f93 with SMTP id
 d18-20020a05622a101200b002f3ce269f93mr2131597qte.175.1652921543953; Wed, 18
 May 2022 17:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
 <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com> <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
In-Reply-To: <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 18 May 2022 17:52:13 -0700
Message-ID: <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
Subject: Re: tg3 dropping packets at high packet rates
To:     David Laight <David.Laight@aculab.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 2:31 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Paolo Abeni
> > Sent: 18 May 2022 18:27
> ....
> > > If I read /sys/class/net/em2/statistics/rx_packets every second
> > > delaying with:
> > >   syscall(SYS_clock_nanosleep, CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
> > > about every 43 seconds I get a zero increment.
> > > This really doesn't help!
> >
> > It looks like the tg3 driver fetches the H/W stats once per second. I
> > guess that if you fetch them with the same period and you are unlucky
> > you can read the same sample 2 consecutive time.
>
> Actually I think the hardware is writing them to kernel memory
> every second.

On your BCM95720 chip, statistics are gathered by tg3_timer() once a
second.  Older chips will use DMA.

Please show a snapshot of all the counters.  In particular,
rxbds_empty, rx_discards, etc will show whether the driver is keeping
up with incoming RX packets or not.
