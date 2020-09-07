Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC3825F5A2
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgIGIts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbgIGItq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 04:49:46 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C97C061573;
        Mon,  7 Sep 2020 01:49:46 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id y5so11683957otg.5;
        Mon, 07 Sep 2020 01:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U3euzQ0Swe5yymHZPecrNgR6N5TksT5qVYOuQ4FkYtc=;
        b=ZAP2S7DZI5vT7BHFsnBBOKOhCb2zFyruwKgW++3sF+IVjBUKHUsOt8v+ufKBbv0qUD
         VJcKDlrSeabFQdul2azOOhbYEak24M9fdot4l16Mrwc43zlXQeutqm40FBGwnkxSSDDd
         3DT+6lUsm1FjeBhiEmT31WCRr7i9pShb6qH32osuTlSK+TPHVJUwqwQQ42h0MBRZyA4z
         g79/4VwkpQsRS/45RWtdAwZQZQOvMCOoe5vMfPjjX2c98IpSQ8eOEyamuA//6BGQdOmx
         Bj215qtZ6WjSmicwu3zLUH/v+UUf4rnK8dwwmmspBnYrzbgwkTVrjVm63Yc3F3NOLw9h
         c7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U3euzQ0Swe5yymHZPecrNgR6N5TksT5qVYOuQ4FkYtc=;
        b=bNreNQlqCKvrlPhvbd+qNUumI0vG6oRUFM9M7+71bi9eEn0kI++rzIs5dwxJ0NEJmU
         al3I5HZtaTTG0rfknVKorjzrwCQjaGizwNdj1ROfld9eT3zPvRGb50yT+GVPlgz4LQ6u
         fF3OpQoL6CGIePz5L1fchxuN+cNVxzx4rf7XCnqrR6QlLArIVHYpHS4TemFG++MPypDV
         O+HqJi43905+SpVGkY9uXgE9uowHgPz6P5oLZvTKNL3xPjruj2VEUibiTVifL6xV3UlW
         yV4QKVQ5Yq7SunFKWcA8mbv7cR2fjJRNOa2B9dBeX26dhGMxSTxO0Y5fzL73BSxv40NS
         mgDg==
X-Gm-Message-State: AOAM530qg6onmy7sEf0hK/EkrZYQZe/gfo5rX/hRi5KRZHNw47vaQgt6
        YfBfhauVSZbSxD2oOmvCRTp2e7mnuyobWogkdSg=
X-Google-Smtp-Source: ABdhPJzF+TwUsvyBcUC5Igw0RzmgIn/yJwLk/28MlDO8QiD1vOSkudFQXkePOwUmc5tMyeeVGBDajuygXy/aFVRP8Uk=
X-Received: by 2002:a9d:7745:: with SMTP id t5mr13692171otl.114.1599468584605;
 Mon, 07 Sep 2020 01:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <CA+4pmEueEiz0Act8X6t4y3+4LOaOh_-ZfzScH0CbOKT99x91NA@mail.gmail.com>
 <87wo7una02.fsf@miraculix.mork.no> <CAGRyCJE-VYRthco5=rZ_PX0hkzhXmQ45yGJe_Gm1UvYJBKYQvQ@mail.gmail.com>
 <CAKfDRXg2xRbLu=ZcQYdJUuYbfMQbav9pUDwcVMc-S+hwV3Johw@mail.gmail.com>
 <87v9gqghda.fsf@miraculix.mork.no> <CAGRyCJFcDZzfahSsexnVN0tA6DU=LYYL2erSHJaOXZWAr=Sn6A@mail.gmail.com>
In-Reply-To: <CAGRyCJFcDZzfahSsexnVN0tA6DU=LYYL2erSHJaOXZWAr=Sn6A@mail.gmail.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Mon, 7 Sep 2020 10:49:33 +0200
Message-ID: <CAKfDRXjLmT32sFB40OV8ywm9vwNkn3-n_a2zcC-3o2wJa-tvFg@mail.gmail.com>
Subject: Re: [PATCH] net: usb: qmi_wwan: Fix for packets being rejected in the
 ring buffer used by the xHCI controller.
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Paul Gildea <paul.gildea@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniele,

On Mon, Sep 7, 2020 at 10:35 AM Daniele Palmas <dnlplm@gmail.com> wrote:
> there was also another recent thread about this and the final plan was
> to simply increase the rx urb size setting to the highest value we are
> aware of (see https://www.spinics.net/lists/linux-usb/msg198858.html):
> this should solve the babble issue without breaking aggregation.
>
> The change should be simple, I was just waiting to perform some sanity
> tests with different models I have. Hope to have it done by this week.

Thanks for letting me know. Looking forward to the patch and dropping
my own work-around :)

Kristian
