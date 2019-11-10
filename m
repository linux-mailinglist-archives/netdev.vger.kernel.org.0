Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4430DF6956
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfKJOLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:11:17 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42795 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfKJOLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:11:17 -0500
Received: by mail-pf1-f195.google.com with SMTP id s5so8540696pfh.9;
        Sun, 10 Nov 2019 06:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h8eMClpCjaC9/eG1emZN+Rx3CQQJyECB4vddmHzKxA0=;
        b=Gy1/Ts2uVJ0mxHGyMcSKWA7jVhlc2aWT4GeKJ+wCJ1+g1vnuRtSXJWXaqTUj+nJsOd
         JKZUNvluHsgZmZijJ8sTQbr93abNK+YvsKkmRpWawnEwUTT1Kq1BHB0sGRdSxkeD6mZY
         IWOdFQYA55TkivXHi4DfC5n74lntpRzKspuHnAttV/8MG25Akfwg6EHBYJEJsyRzLPfT
         inIP9tfU2yvU22QLl7j9mylQo9bqpeJW0587mVb45jNs6gGNdC/XdOZC/+sziBi6Z+FK
         4I4SF1A3aAW5Jidv7wZcH6raZ01M6sKZsFTCKJCq9K26UQa7QG3RaqQC8V2uTaVTTUus
         kTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h8eMClpCjaC9/eG1emZN+Rx3CQQJyECB4vddmHzKxA0=;
        b=WNcJg2rBfZeDwyfzc1HXbGygb4qRpK8fyX4Ucxekgx+cZh5wmYgGeSUcQckagMF1bQ
         CtlvWtb7kWiT+J/JXihTIwGRYwH7NdeUFEHpT8LloZOIi7GnBHYg5E/4uZDN+/9WMGG3
         wNsXTnqx6xIfv1ZFQe+Wa2+7MtbvS6xcnQekqBs7UqPywCd5UFVVXSRyeivzvdoMrIN5
         fKlIGGxAZ2KA7fNc51/DJaEMrA5uSBmuvbq5E+qvSeUNa4uIEHF6ji4/G8PqixDBVJQp
         msVcELG6Dx66WKavQt+siPXmuBFDrQd1E4+SSTQI5xQZ9OGelO9Wt4w39xoddtbHUzoV
         OKhQ==
X-Gm-Message-State: APjAAAVXurtucj9AXxFNAXbDb0DCnK905JpUJU/Ky37puxgbLE2rWb6y
        z3O50Vo4wae9MTCTVCRSojU=
X-Google-Smtp-Source: APXvYqymgZR5AdaaWCC2GIgXY8iVx9FHw+I6mEGSJqVKzRxgimJcaj9SXyirQhGW/Pi1ZCxPQv5Ajw==
X-Received: by 2002:a17:90a:a483:: with SMTP id z3mr26513359pjp.55.1573395076245;
        Sun, 10 Nov 2019 06:11:16 -0800 (PST)
Received: from ?IPv6:2405:4800:58f7:3f8f:27cb:abb4:d0bd:49cb? ([2405:4800:58f7:3f8f:27cb:abb4:d0bd:49cb])
        by smtp.gmail.com with ESMTPSA id w26sm17012987pfj.123.2019.11.10.06.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Nov 2019 06:11:15 -0800 (PST)
Cc:     tranmanphong@gmail.com,
        syzbot+7dc7c28d4577bbe55b10@syzkaller.appspotmail.com,
        gregkh@linuxfoundation.org, glider@google.com,
        hslester96@gmail.com, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: Re: [PATCH] usb: asix: Fix uninit-value in asix_mdio_write
To:     David Miller <davem@davemloft.net>
References: <0000000000009763320594f993ee@google.com>
 <20191107004404.23707-1-tranmanphong@gmail.com>
 <20191107.152118.922830217121663373.davem@davemloft.net>
From:   Phong Tran <tranmanphong@gmail.com>
Message-ID: <5679efce-797a-ea2c-f7fb-882ac450e9d2@gmail.com>
Date:   Sun, 10 Nov 2019 21:11:11 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107.152118.922830217121663373.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/19 6:21 AM, David Miller wrote:
> From: Phong Tran <tranmanphong@gmail.com>
> Date: Thu,  7 Nov 2019 07:44:04 +0700
> 
>> The local variables use without initilization value.
>> This fixes the syzbot report.
>>
>> Reported-by: syzbot+7dc7c28d4577bbe55b10@syzkaller.appspotmail.com
>>
>> Test result:
>>
>> https://groups.google.com/d/msg/syzkaller-bugs/3H_n05x_sPU/sUoHhxgAAgAJ
>>
>> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> 
> There are several more situations in this file where the data blob passed
> to asix_read_cmd() is read without pre-initialization not checking the
> return value from asix_read_cmd().
> 
> So, syzbot can see some of them but not all of them, yet all of them
> are buggy and should be fixed.
> 
> These kinds of patches drive me absolutely crazy :-)
> 
> Really, one of two things needs to happen, either asix_read_cmd() clears
> the incoming buffer unconditionally, 

thank you for your suggestion.
Sent Patch v2 reply-to this mail thread.

regards,
Phong.
