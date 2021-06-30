Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587E13B87F5
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhF3Rt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:49:59 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:39618 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbhF3Rt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:49:58 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 69DA85212CB;
        Wed, 30 Jun 2021 20:47:27 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1625075247;
        bh=KMK/XtAgaPbAL+Ft8ff2uL8aGm1M1EL96l+Q9qcXa20=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=BZt5fbT4AyCsoPdJQb2Y0HVyxcWOJbXdMh4Piaa0+HDGpzKY7u682fIQyC9Gq87MA
         PTPUQqIPCitn3SKmMF8o2LcdrzFtDAK4YrEpFYDBhbJsBIatglz+Mse6uCBKXuuomz
         Tn9v6wlqXEzeGoMADDZIzCBy0qoaLZ6Lm3t+za6But1zAg+UsxpczHDqLuVn3aNxuk
         nmSnh7yNfvVHTAOmMcXtrNShhTIqelcFalxJYkgq+EkX3hqf19lyHA5KXbU65wzKll
         +6rOH+oYdDKPuX2u47zEFfZAjgLmlC3j3CKSGBcdi/Tx4YE6/kZnDceSS62obkTtOE
         QaorEeBfcEtzA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id B2BAD5212DF;
        Wed, 30 Jun 2021 20:47:26 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Wed, 30
 Jun 2021 20:47:26 +0300
Subject: Re: [MASSMAIL KLMS] Re: [RFC PATCH v1 05/16] af_vsock: use
 SOCK_STREAM function to check data
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100250.570726-1-arseny.krasnov@kaspersky.com>
 <CAGxU2F6owSKJWEkYSTBGy+yrVhp1tcjDmC+gwj9NAJzddMrFkQ@mail.gmail.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <ed0a3ac9-41eb-8826-9758-b1e7f1831e0e@kaspersky.com>
Date:   Wed, 30 Jun 2021 20:47:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGxU2F6owSKJWEkYSTBGy+yrVhp1tcjDmC+gwj9NAJzddMrFkQ@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/30/2021 17:34:42
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164748 [Jun 30 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/30/2021 17:37:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 30.06.2021 11:32:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/30 16:18:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/30 08:30:00 #16841989
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30.06.2021 15:10, Stefano Garzarella wrote:
> On Mon, Jun 28, 2021 at 01:02:47PM +0300, Arseny Krasnov wrote:
>> Also remove 'seqpacket_has_data' callback from transport.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> include/net/af_vsock.h   |  1 -
>> net/vmw_vsock/af_vsock.c | 12 +-----------
>> 2 files changed, 1 insertion(+), 12 deletions(-)
> In order to avoid issues while bisecting the kernel, we should have
> commit that doesn't break the build or the runtime, so please take this
> in mind also for other commits.
>
> For example here we removed the seqpacket_has_data callbacks assignment
> before to remove where we use the callback, with a potential fault at
> runtime.
>
> I think you can simply put patches from 1 to 5 together in a single
> patch.
>
> In addition, we should move these changes after we don't need
> vsock_connectible_has_data() anymore, for example, where we replace the
> receive loop logic.
>
> Thanks,
> Stefano
Ack
>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index ab207677e0a8..bf5ea1873e6f 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -141,7 +141,6 @@ struct vsock_transport {
>>       int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
>>                                size_t len);
>>       bool (*seqpacket_allow)(u32 remote_cid);
>> -      u32 (*seqpacket_has_data)(struct vsock_sock *vsk);
>>
>>       /* Notification. */
>>       int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 21ccf450e249..59ce35da2e5b 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -860,16 +860,6 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk)
>> }
>> EXPORT_SYMBOL_GPL(vsock_stream_has_data);
>>
>> -static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
>> -{
>> -      struct sock *sk = sk_vsock(vsk);
>> -
>> -      if (sk->sk_type == SOCK_SEQPACKET)
>> -              return vsk->transport->seqpacket_has_data(vsk);
>> -      else
>> -              return vsock_stream_has_data(vsk);
>> -}
>> -
>> s64 vsock_stream_has_space(struct vsock_sock *vsk)
>> {
>>       return vsk->transport->stream_has_space(vsk);
>> @@ -1881,7 +1871,7 @@ static int vsock_connectible_wait_data(struct
>> sock *sk,
>>       err = 0;
>>       transport = vsk->transport;
>>
>> -      while ((data = vsock_connectible_has_data(vsk)) == 0) {
>> +      while ((data = vsock_stream_has_data(vsk)) == 0) {
>>               prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
>>
>>               if (sk->sk_err != 0 ||
>> -- 2.25.1
>>
>
