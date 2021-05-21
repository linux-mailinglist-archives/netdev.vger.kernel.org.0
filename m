Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61C838C7BD
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhEUNXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhEUNX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:23:28 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995DEC0613CE;
        Fri, 21 May 2021 06:22:03 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id j10so29633062lfb.12;
        Fri, 21 May 2021 06:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=0WTXjqqI6/3XYB5f7OSVBrbUrmfyFc72tk8Wysn7tiU=;
        b=S+Fg/ZLAH5ej8UkfVme7QUO/mhAVM3yYAE7UasT+wWJEyy/6FfqydSgYDs9MSeCZ+b
         V9ANLSuYMd6QDqV60o74BnEMjP+8E3P+8F5kukYzSkvA58+VFmY0sZ7meMTZwh5sI8Bs
         cA3WjQGF5fkB1woMgzEH9lAAUO7sYUcwEibfNqUVS/wpkxQrQYdAJoYiSsFdD1HNsUvr
         l4taCZAsnhIzulZTmeC1TSpSZheYeDsAe5C8DmVmp0zCSsAHrlB4ZfDhNVnwhFgxLBko
         C1uu4rrbvpF3SxgrKBUSvNtnN+TblZOhQucHQPsbd5R6sgIXBUlKmPp6S7g0D8USQFLB
         ITtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=0WTXjqqI6/3XYB5f7OSVBrbUrmfyFc72tk8Wysn7tiU=;
        b=Sfi48vkieNXvdPBanLz3dDzSrJwHJFhYgPioTtR0Hv1vVQm9mcJkaXVEaLKjOfb0fh
         23OahaUqEx8Ir+mL0lWAfqrlJ2NXZqbhdVGsjBffrkyMDlfZXlniYP2te0Il8Z04x4N3
         Vw+ggtt5hrHKeqgPx3QWD2YIHYjUGns/uEAV06elvUdylooURrTGuuMqXNM/iDOj6yNo
         H2Eq6D044GNnr+AaKsnixB3joQ0LUd162IfX/9WQ5mn0DFk8W5ETsOanapErKpkEtjlD
         cnDpqhltqPNfqdFgu2VXIX4hsEF9ZQ2ScSTi3ylIwxuP7k1aJ06fO/mPHvx6eICcfkO/
         yzTw==
X-Gm-Message-State: AOAM5305Oy5tdOUU2TOI4RzkJxCYqZtAth3+cR1yJdmFCyaUXNGBl6c2
        anzRxdY1oeEA5yVsBPC99MifxQ3/6+5lSA==
X-Google-Smtp-Source: ABdhPJwg/6iRs3GWmvRucNSI8L51wG+XCllORh1FL8jmf5aSn8gv92LkAdRqJCFpVhM4s0yCyyH43A==
X-Received: by 2002:ac2:414e:: with SMTP id c14mr2295214lfi.155.1621603321843;
        Fri, 21 May 2021 06:22:01 -0700 (PDT)
Received: from razdolb ([85.249.38.117])
        by smtp.gmail.com with ESMTPSA id c9sm686476lji.18.2021.05.21.06.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 06:22:01 -0700 (PDT)
References: <20210509233010.2477973-1-mike.rudenko@gmail.com>
 <d1bac6c3-aa52-5d76-1f2a-4af9edef71c5@broadcom.com>
 <87a6oxpsn8.fsf@gmail.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Dmitry Osipenko" <digetx@gmail.com>,
        Double Lo <double.lo@cypress.com>,
        "Remi Depommier" <rde@setrix.com>, Amar Shankar <amsr@cypress.com>,
        "Saravanan Shanmugham" <saravanan.shanmugham@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: use separate firmware for 43430 revision 2
In-reply-to: <87a6oxpsn8.fsf@gmail.com>
Date:   Fri, 21 May 2021 16:22:00 +0300
Message-ID: <87k0nsz0g7.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-05-14 at 12:41 MSK, Mikhail Rudenko <mike.rudenko@gmail.com> wrote:
> On 2021-05-10 at 11:06 MSK, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
>> On 5/10/2021 1:30 AM, Mikhail Rudenko wrote:
>>> A separate firmware is needed for Broadcom 43430 revision 2.  This
>>> chip can be found in e.g. certain revisions of Ampak AP6212 wireless
>>> IC. Original firmware file from IC vendor is named
>>> 'fw_bcm43436b0.bin', but brcmfmac and also btbcm drivers report chip
>>
>> That is bad naming. There already is a 43436 USB device.
>>
>>> id 43430, so requested firmware file name is
>>> 'brcmfmac43430b0-sdio.bin' in line with other 43430 revisions.
>>
>> As always there is the question about who will be publishing this
>> particular firmware file to linux-firmware.
>
> The above mentioned file can be easily found by web search. Also, the
> corresponding patch for the bluetooth part has just been accepted
> [1]. Is it strictly necessary to have firmware file in linux-firmware in
> order to have this patch accepted?

Ping. Is this definitely no-go?

--
Regards,
Mikhail
