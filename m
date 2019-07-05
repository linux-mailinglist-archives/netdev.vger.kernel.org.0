Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF097601BB
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 09:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfGEHt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 03:49:27 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:41230 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbfGEHt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 03:49:27 -0400
Received: by mail-ed1-f54.google.com with SMTP id p15so7390338eds.8
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 00:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/MLEv92GqqhfzkPbhKXPeYHM89GaF48poNnxDzUtrDA=;
        b=hIsrZpZkv8k4J3rDZTewtRdtjFXtrUR9evjWBnPLSP9aRFu/haMCyOTgWsIeyNzr6/
         tUig5hPdgWvOTfK3aCaDLpExbtyzS+vRI3tTS90c37xf2PTUj0l5KqNQurGitU0btm+k
         ZnVm7FQMSOp78bSJ2rzq1PGy2ildEhfPxsQpCcVYAmWAWl6/xjsw0EzhMjFBuQ+jYSjL
         egCcrsb7sfBLVoIfVblH7Lov4fFAu+eZLk74WbDVal6EfUa/drREWKm+M4lP1JTa2k9Q
         bdqYq6p9ftFWzvxiMxl2wrAcFlV5tO1JXvQ8Er93OTYYykfFS7KbwuMk7pLtsC8/e7rJ
         fidw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/MLEv92GqqhfzkPbhKXPeYHM89GaF48poNnxDzUtrDA=;
        b=bVxwpyni5HIgsplfR8gyoiDxYe34sabNst/cs3AvAW3x8EFzxgXbD9ucqxWgq9zb8G
         nZ+SikLsot6Dqx3Im2XEAsQX+8inpZJknxwF0UkMO7dQMa+by9QPZ9B0k79DVHaiCO37
         J9PE0q18lU3y6/hTZhOpYLFbyAXxKL2V9ZBKlbkRT5A6k+pNwvHD7WdIYhjmVMFmRNkZ
         6SQZtxgWHwSZwp1jm51gnAT79JcmeQ6uXGPwbXI7chNk7QJGAP7HN9Zmjy2ALUYx1Nsj
         jYW01bXqpaGcNlEbUQl6X0AYkGvBgIMYBdeZUFaY1Y09ChaRPMvZlPEPz9hcsEDQTA97
         1S4w==
X-Gm-Message-State: APjAAAW2Nht1l1BNQHmsiJRQHl6tqIa+GOBrB+LST4XQOZzPpGxMpXk5
        +HdpKEcUnd2EX5nwocGGxMt4VrEq
X-Google-Smtp-Source: APXvYqwDy9+BoK/Y2jbEDf6Y30ToByDtxIc89COMeGVpznsLCje8n2w1Hm+roZujxNQTADHmLSiejg==
X-Received: by 2002:a17:906:f43:: with SMTP id h3mr2174512ejj.143.1562312965080;
        Fri, 05 Jul 2019 00:49:25 -0700 (PDT)
Received: from win95.local (D96447CA.static.ziggozakelijk.nl. [217.100.71.202])
        by smtp.gmail.com with ESMTPSA id i6sm2461928eda.79.2019.07.05.00.49.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 00:49:24 -0700 (PDT)
Subject: Re: bug: tpacket_snd can cause data corruption
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Network Development <netdev@vger.kernel.org>
References: <1562152028-2693-1-git-send-email-debrabander@gmail.com>
 <CAF=yD-+wHzfP6QWJzc=num_VaFvN3RYXV-c3+-VY8EjS87WEiA@mail.gmail.com>
 <d32bc4b8-b547-1d78-e245-2ec51df19c77@gmail.com>
 <CAF=yD-J-17g_riv367tCC7Go_iuqW4wqE=ye+=kKCxJ=oEXaiA@mail.gmail.com>
From:   Frank de Brabander <debrabander@gmail.com>
Message-ID: <6ebd745e-17fb-e71c-5c7c-b68e36edb731@gmail.com>
Date:   Fri, 5 Jul 2019 09:49:23 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAF=yD-J-17g_riv367tCC7Go_iuqW4wqE=ye+=kKCxJ=oEXaiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05-07-19 00:59, Willem de Bruijn wrote:

>>> Can you reproduce the issue when running the modified test in a
>>> network namespace (./in_netns.sh ./txring_overwrite)?
>> But even when running the test with ./in_netns.sh it shows
>> "wrong pattern", this time without length mismatches:
>>
>> wrong pattern: 0x62 != 0x61
>> wrong pattern: 0x62 != 0x61
>> wrong pattern: 0x62 != 0x61
>> wrong pattern: 0x62 != 0x61
>> wrong pattern: 0x62 != 0x61
>> wrong pattern: 0x62 != 0x61
>> wrong pattern: 0x62 != 0x61
>> wrong pattern: 0x62 != 0x61
>> wrong pattern: 0x62 != 0x61
>> wrong pattern: 0x62 != 0x61
>>
>> As already mentioned, it seems to trigger mainly (only ?) when
>> an USB device is connected. The PC I'm testing this on has an
>> USB hub with many ports and connected devices. When connecting
>> this USB hub, the amount of "wrong pattern" errors that are
>> shown seems to correlate to the amount of new devices
>> that the kernel should detect. Connecting in a single USB device
>> also triggers the error, but not on every attempt.
>>
>> Unfortunately have not found any other way to force the
>> error to trigger. E.g. running stress-ng to generate CPU load or
>> timer interrupts does not seem to have any impact.
> Interesting, thanks for testing. No exact idea so far. The USB devices
> are not necessarily network devices, I suppose? I don't immediately
> have a setup to test the usb hotplug, so cannot yet reproduce the bug.
It triggers with different types of USB devices. Verified the
bug can trigger with an USB flash drive, mouse, USB-serial
adapter and USB hub (also with no devices connected).

It can trigger when the USB device is connected as well as when
it's disconnected. But there is a bit of luck needed, it can take
a bunch of times before it happens. Using a large USB hub with
many connected devices will trigger it much easier.
