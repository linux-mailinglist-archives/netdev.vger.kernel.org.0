Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2ACB5F33
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 10:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbfIRI3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 04:29:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21595 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728649AbfIRI3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 04:29:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568795351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=LJ9x17++JlMAzSbihcUye9RvbBXaphj4wbKaTaSMCiA=;
        b=giHdDCOttEo+F+GVdxwAbVPfmLyhfnxvvw5obFR+Gb+nRNMT79HttAzJvcF35UkJwob0x6
        7bfXq+nIpAiAxWmapBI+/eLQEhjJI8ZzM1WKJDJXp39ugo5hW59BRWMMN75guFkA7G6izs
        6GWb46wUKGl8ECcGNLlaqBq6e0dpHrM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-wVqPvBP7PRChSbYFIjkAyw-1; Wed, 18 Sep 2019 04:29:10 -0400
Received: by mail-wr1-f69.google.com with SMTP id a15so1390050wrq.4
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 01:29:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IrWbIprHqWMlOEd3b8M/gmFgeShWjRa194btm7DSbPI=;
        b=mDEDk/kdrPucNDMsc1XMaBELMVWspYmLZi+SfgaY0oV4DI28Pz00OVhqTNBm9/r6da
         pJC1QNjA688+RhsSAn8e1UHRAWCbz1RVDohXC8+D/KnODxTWghQoGqg1bRO5nBAIj6tg
         IAcmkuEXgHqcdaM/JCx8hfopPVDPrVjYprDm0pMFeAQX/MuykMOm/L/CuimI48kzegdb
         /1BOD0xd/sLm424UFvYDbphOVJdCvowKODktpLP/XqreSeLpVmDvx3Kg5909I8yoREe9
         Y8XBjKKxSQypoZDhON52Y5dZEOmb5zv1sUI+Mkdnk1QxseKr4MqArKhGZCOOpEnVodjp
         ew8w==
X-Gm-Message-State: APjAAAXluye00ytJAD/3QfR70sik0wJhNebWNjBITt/9yDQ3fwqzS58D
        ouR7iFTzQQuw151cnkBjc53Ol+tvZZRk7ierruaTrw0ePf2s1yngLmeTMcS0Eg9zZZMzqNqZrBy
        0Dh2XJdcJWaqqYzDe
X-Received: by 2002:a5d:5381:: with SMTP id d1mr1854482wrv.315.1568795347876;
        Wed, 18 Sep 2019 01:29:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyonIjdT3rqMK/eFGzZQnLolYQxc5RAG8w8enPADilIGLfzNNbF2gDa1S1gTXGi5dhHblr98w==
X-Received: by 2002:a5d:5381:: with SMTP id d1mr1854455wrv.315.1568795347599;
        Wed, 18 Sep 2019 01:29:07 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id u22sm8125812wru.72.2019.09.18.01.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 01:29:07 -0700 (PDT)
Subject: Re: [RFC PATCH v3 3/6] timekeeping: Expose API allowing retrival of
 current clocksource and counter value
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com, linux-arm-kernel@lists.infradead.org
References: <20190918080716.64242-1-jianyong.wu@arm.com>
 <20190918080716.64242-4-jianyong.wu@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <aecdffc5-7d15-6183-f8ea-ed557631cf75@redhat.com>
Date:   Wed, 18 Sep 2019 10:29:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918080716.64242-4-jianyong.wu@arm.com>
Content-Language: en-US
X-MC-Unique: wVqPvBP7PRChSbYFIjkAyw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/19 10:07, Jianyong Wu wrote:
> From Marc Zyngier <maz@kernel.org>
> A number of PTP drivers (such as ptp-kvm) are assuming what the
> current clock source is, which could lead to interesting effects on
> systems where the clocksource can change depending on external events.
>=20
> For this purpose, add a new API that retrives both the current
> monotonic clock as well as its counter value.
>=20
> From Jianyong Wu: export this API then modules can use it.

See review of patch 4.  ktime_get_snapshot is even better for your
needs, if I'm not mistaken.

Paolo

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  include/linux/timekeeping.h |  3 +++
>  kernel/time/timekeeping.c   | 13 +++++++++++++
>  2 files changed, 16 insertions(+)
>=20
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> index a8ab0f143ac4..a5389adaa8bc 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -247,6 +247,9 @@ extern int get_device_system_crosststamp(
>  =09=09=09struct system_time_snapshot *history,
>  =09=09=09struct system_device_crosststamp *xtstamp);
> =20
> +/* Obtain current monotonic clock and its counter value  */
> +extern void get_current_counterval(struct system_counterval_t *sc);
> +
>  /*
>   * Simultaneously snapshot realtime and monotonic raw clocks
>   */
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 44b726bab4bd..07a0969625b1 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1098,6 +1098,19 @@ static bool cycle_between(u64 before, u64 test, u6=
4 after)
>  =09return false;
>  }
> =20
> +/**
> + * get_current_counterval - Snapshot the current clocksource and counter=
 value
> + * @sc:=09Pointer to a struct containing the current clocksource and its=
 value
> + */
> +void get_current_counterval(struct system_counterval_t *sc)
> +{
> +=09struct timekeeper *tk =3D &tk_core.timekeeper;
> +
> +=09sc->cs =3D READ_ONCE(tk->tkr_mono.clock);
> +=09sc->cycles =3D sc->cs->read(sc->cs);
> +}
> +EXPORT_SYMBOL_GPL(get_current_counterval);
> +
>  /**
>   * get_device_system_crosststamp - Synchronously capture system/device t=
imestamp
>   * @get_time_fn:=09Callback to get simultaneous device time and
>=20

