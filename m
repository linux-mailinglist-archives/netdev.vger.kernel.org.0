Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A19D30E403
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhBCU0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbhBCU02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 15:26:28 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33C0C0613D6;
        Wed,  3 Feb 2021 12:25:47 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id a1so762823wrq.6;
        Wed, 03 Feb 2021 12:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OszwGHR9YVgXRKyj0WuKAiIm2cG9poLYxkLgCKY3pEM=;
        b=kLBxvfyz0v2PJIZ8rLM27NBrwa9tG4W1oOupWKMrQmp6XdMfUJiNEibNDSxGc6zyPC
         hfYO9HLptqURk6WdK+ir+I9ctl+++NzVi0OwzXJCUERyjOARNRFUxVnKKikuPbBOV74z
         W/i/Y1U981504tgrlFHHKFLMKjWG7ttZK3vslXWTPHqLMZFO2EWtpXN5Ch2QV3HAXmAL
         lan9I+DB6ttR0INgbKc4BtY967KxmpEm8aEG3iy6BLiFuE2ZH0eEOcHerUPii80DSQ3A
         voWadZvu2kiD2kS3JQam05dvDnfHCWS0yLFvZKwb+gk2UILAQTdtk54lap6pZbwCpm2u
         8k+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OszwGHR9YVgXRKyj0WuKAiIm2cG9poLYxkLgCKY3pEM=;
        b=NaARkkk0Wml7q0FjGBVlu4fdhH04AOowyWcH5gXzmc8EBrJ+AoBVkGhUMxHlnVrPig
         TQKQtOyitqdYBnWf/HjpXJudHT16mw1kQiaZPm2bEH1DTmVtqHsfyAnMfANDq3B7V4nx
         /vObBWS/9YTCDXgnkrC3tKmala8PcBX4HK83U8FBzKmJp9tR4gS4HbagdptmTCBjDyuh
         Py9Xn71QvwxEXB/Hh2u9CRB37kXlhGvZWtTVe81l+1irbUiyQ1E7gfX3XXJd0xibnxcL
         Rm7+fO7fOyH9XoR1ZAROE/qOder41ytYgIbrK5UhkOtEBWQW+Qytiuc+Y0/dmO72VHun
         On1g==
X-Gm-Message-State: AOAM5319x/+Q69wbgEJj5p3jrWh5F/RLBry3ZT2fhPrr5YhIoF4y0UfE
        oSoQGZV6inJWc4WdwX/G40S1QMjHr4Iy5WxQ+yQ=
X-Google-Smtp-Source: ABdhPJz7POjJ+PDdHRJoYSvhJrK11e1GZqiLEiwa5yb/WNAKHQdGS0Qq7ot6z2jrA4LUaP375ZXgjNNU9v0l7TIe0YA=
X-Received: by 2002:a5d:65ca:: with SMTP id e10mr5617915wrw.166.1612383946414;
 Wed, 03 Feb 2021 12:25:46 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-3-TheSven73@gmail.com>
 <MN2PR11MB3662C081B6CDB8BC1143380FFAB79@MN2PR11MB3662.namprd11.prod.outlook.com>
 <CAGngYiVvuNYC4WPCRfPOfjr98S_BGBNGjPze11AiHY9Pq1eJsA@mail.gmail.com>
 <MN2PR11MB3662E5A8E190F8F43F348E72FAB69@MN2PR11MB3662.namprd11.prod.outlook.com>
 <CAGngYiVK5=vggym5LiqvjiRVTSWscc=CgX6UPOBkZpknuLC62Q@mail.gmail.com> <MN2PR11MB366281CC0DE98F16FE1F1D62FAB49@MN2PR11MB3662.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB366281CC0DE98F16FE1F1D62FAB49@MN2PR11MB3662.namprd11.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 3 Feb 2021 15:25:35 -0500
Message-ID: <CAGngYiX1+hkygO3+Z9gsbzVY5b1ahFTG3QH7C1YNEjy6rgox-w@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 3:14 PM <Bryan.Whitehead@microchip.com> wrote:
>
> We can test on x86 PC. We will just need about a week after you release your next version.
>

That's great. If you have any suggestions on how I can improve testing
on my end, feel free to reach out.
