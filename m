Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D823F5D2A
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhHXLf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:35:58 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:34212 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbhHXLfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 07:35:55 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 7306875957;
        Tue, 24 Aug 2021 14:35:06 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1629804906;
        bh=GYBaQLze7V8QkffIPN1VdgsX/1gXYT+yCMz9naFMfN4=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=pm5kl2r/3XsNo8wLflIie8bPCLk6TZGUFX2SfpkUbOnggCdIMiPz3svKCKRm7gzPS
         ckwnbNTeJROsCchTQ4mkhfHsbpMCHOtsvOyQJ8PIamXTyyIMBn6EbT5QqHHVDKa/z9
         85BYe1HjbnMX3FbXvipi3IIZKjHhTmZNJheAvx4FJy/gjOTvWcUTVM4AxsQ6i8Iq5i
         y82ffc6A6EFX1nRz357sEitxa/B6CvJyrTpW9iRUMHSnWaTb4/JWsipWyZlH/Q+mZI
         rml4F+pmYTlTQE+xtTRt2KRGC50JKZmCI8JRLmo+oaXiayH8qg+cvp7e1IwPY9Su0X
         Wo5VO0vlHpERw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 2C35175967;
        Tue, 24 Aug 2021 14:35:05 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 24
 Aug 2021 14:35:04 +0300
Subject: Re: [RFC PATCH v3 0/6] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
 <3f3fc268-10fc-1917-32c2-dc0e7737dc48@kaspersky.com>
 <20210824100523.yn5hgiycz2ysdnvm@steredhat>
 <d28ff03e-c8ab-f7c6-68a2-90c9a400d029@kaspersky.com>
 <20210824103137.v3fny2yc5ww46p33@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <0c0a7b61-524e-ab44-7d7e-b35bd094c7ca@kaspersky.com>
Date:   Tue, 24 Aug 2021 14:35:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210824103137.v3fny2yc5ww46p33@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/24/2021 10:59:13
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165761 [Aug 24 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/24/2021 11:01:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 24.08.2021 7:59:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/24 10:44:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/24 07:59:00 #17090872
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24.08.2021 13:31, Stefano Garzarella wrote:
> Caution: This is an external email. Be cautious while opening links or attachments.
>
>
>
> On Tue, Aug 24, 2021 at 01:18:06PM +0300, Arseny Krasnov wrote:
>> On 24.08.2021 13:05, Stefano Garzarella wrote:
>>> Caution: This is an external email. Be cautious while opening links or attachments.
>>>
>>>
>>>
>>> Hi Arseny,
>>>
>>> On Mon, Aug 23, 2021 at 09:41:16PM +0300, Arseny Krasnov wrote:
>>>> Hello, please ping :)
>>>>
>>> Sorry, I was off last week.
>>> I left some minor comments in the patches.
>>>
>>> Let's wait a bit for other comments before next version, also on the
>>> spec, then I think you can send the next version without RFC tag.
>>> The target should be the net-next tree, since this is a new feature.
>> Hello,
>>
>> E.g. next version will be [net-next] instead of [RFC] for both
>> kernel and spec patches?
> Nope, net-next tag is useful only for kernel patches (net tree -
> Documentation/networking/netdev-FAQ.rst).
Ack
>
> Thanks,
> Stefano
>
>
