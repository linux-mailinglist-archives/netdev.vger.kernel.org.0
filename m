Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5A87B5E4
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 00:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfG3WxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 18:53:15 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38262 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfG3WxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 18:53:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id f5so21986873pgu.5
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 15:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=Mbw35l3hwyzssjYJZu7LPgAiIjC7aRstk3PDvISyYMA=;
        b=053NzhWLR20RgJImxyPdXaTb13lAqWKXWl49AqAAMq6zgSrGLWhk8g47M2mW7YgNCf
         Be/fg2cKXKEhmTO9WNTcSOLYdr+kt13R3x5UPKv0+ILpCwVsFvfM1SI28DsmeWnCn/kY
         cQDQ37fQBEcS1LY5p3vw+9heJU22KhAU3rzgUDYVEDRf0TVdwyYbbfhz2PXpZHZMReKH
         gXZq8H9FaCtNFcvAkmG102y5Uo5H5dLd5Vp5CXXCQbSFVwGHDj97J/39sHDBSoTQvKR9
         XmEkLixJC1rdJ98fAKeVpOkNsC6idhTl0cU7H7V+Jiw/bBLqrZqcsLwknT5G/Zw9ib31
         oxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Mbw35l3hwyzssjYJZu7LPgAiIjC7aRstk3PDvISyYMA=;
        b=qE/LFPZf3daW+Uzo6LJhB8wVUEHKzmHENI+ET2OV5E/R17AYrx/dlp3HRcw1ZA1teF
         hgcXkxuGwfDgRL/TffKYdC2o0qhEQgnHdbk0p9gJxYG5mLs+eSx7yayOjVpx0HUWgRWd
         r7k1g/Hm9XbzQfGvynDo7LQP7pazRgKQ+AUSwy73rH7fRCoyQx9CKYP2GH7O3QrSKoJF
         Dgje0qoxRF/Y2KdjM1zaCBolQERmZnmabhRXnn5sIsEY3CuVd8+FVWAFDUDuYEswiXTm
         NixFuyiJ7xomK0ETPWWjBY5NzsU4pg/vGhDicnhgOC6BUaT+P6EwXM37J55Fjlr0R1dw
         aKKg==
X-Gm-Message-State: APjAAAUnR9go3NNF4b+xXpV+AKyXhZGTJ5ZnBubL8yrQolsk3CE5h5eh
        EWY4t2ieA8k096AgXD2kb6nspKNOhrArWA==
X-Google-Smtp-Source: APXvYqw/c0mO8AM4h+KXMmEbWELLPwL5VbxN/JLIX5UTOF18zfUgOlzWOzyPK9vsng7pgpLDnOHoTw==
X-Received: by 2002:a17:90a:d791:: with SMTP id z17mr113201277pju.40.1564527194200;
        Tue, 30 Jul 2019 15:53:14 -0700 (PDT)
Received: from Shannons-MBP.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 81sm105198736pfx.111.2019.07.30.15.53.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 15:53:13 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 15/19] ionic: Add netdev-event handling
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-16-snelson@pensando.io>
 <a27ba11984c8872a35206bd9fbeee0800ba7b050.camel@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <d491b9e9-46c4-c7a6-4bf9-0274b2fb147b@pensando.io>
Date:   Tue, 30 Jul 2019 15:53:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a27ba11984c8872a35206bd9fbeee0800ba7b050.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/19 4:55 PM, Saeed Mahameed wrote:
> On Mon, 2019-07-22 at 14:40 -0700, Shannon Nelson wrote:
>> When the netdev gets a new name from userland, pass that name
>> down to the NIC for internal tracking.
>>
> Just out of curiosity, why your NIC internal device/firmware need to
> keep tracking of the netdev name ?
>
>
It is helpful in a debugging method inside the NIC firmware.

sln

