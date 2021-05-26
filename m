Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01565391732
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhEZMRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:17:44 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:46260 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbhEZMRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 08:17:42 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 1635677034;
        Wed, 26 May 2021 15:16:09 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1622031369;
        bh=sUAg7c0OJaDV8893akfTQUnFA9//98ey29nrJI7rLlk=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=bXc+5kW4ZAA5MnQRMLVFqfJU/asSbIkOyQ/WQ9lUS+FAsFLzMBT33L+JJ9fEulXrK
         niYQfTvwUZ3Fcjr6XG9eLM86//TZaeOiMTgd2K8z/twUlZm9hpCctJUsU3vSEIhpEo
         aNP2m2JMwfgMNVoJ6Dp33co8q1smJO//pdDD0AAnZRD4fFp8Y6EXpVqrGtasrCUFTb
         Jpl28Fce2vKtXzJjlYsmXqKCDHSFlQFk1T4MBO/9lPA9QMngbXnc4e56+JUfcHMxD7
         yEf178axo514r1vCZ8HalGs8l3z/nmveKcfpcXQtIeZaZ+2t9sFxtevK5+BqVFOE8Q
         sSatzWMzf4SRQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 451607704D;
        Wed, 26 May 2021 15:16:08 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Wed, 26
 May 2021 15:16:07 +0300
Subject: Re: [PATCH v10 00/18] virtio/vsock: introduce SOCK_SEQPACKET support
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210521075520.ghg75wpzz42zorxg@steredhat>
 <108b0bba-5909-cdde-97ee-321b3f5351ca@kaspersky.com>
 <b8dd3b55-0e2c-935a-d9bb-b13b7adc4458@kaspersky.com>
 <20210525145220.amzme5mqqv4npirt@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <becbd621-3773-be9e-b314-5fd0c589110e@kaspersky.com>
Date:   Wed, 26 May 2021 15:16:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210525145220.amzme5mqqv4npirt@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/26/2021 12:06:35
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163941 [May 26 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: patchwork.kernel.org:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2;lists.oasis-open.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/26/2021 12:08:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 26.05.2021 10:27:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/26 10:29:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/26 08:53:00 #16657861
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25.05.2021 17:52, Stefano Garzarella wrote:
> On Tue, May 25, 2021 at 11:22:09AM +0300, Arseny Krasnov wrote:
>> On 23.05.2021 15:14, Arseny Krasnov wrote:
>>> On 21.05.2021 10:55, Stefano Garzarella wrote:
>>>> Hi Arseny,
>>>>
>>>> On Thu, May 20, 2021 at 10:13:53PM +0300, Arseny Krasnov wrote:
>>>>> 	This patchset implements support of SOCK_SEQPACKET for virtio
>>>>> transport.
>>>> I'll carefully review and test this series next Monday, in the mean time
>>>> I think we should have at least an agreement about the changes that
>>>> regards virtio-spec before merge this series, to avoid any compatibility
>>>> issues.
>>>>
>>>> Do you plan to send a new version of the specification changes?
>>>>
>>>> Thanks,
>>>> Stefano
>>> Hello, sorry for long answer. I'm on vacation now, but i plan to send
>>>
>>> it in next several days, because with current implementation it is short
>>>
>>>
>>> Thank You
>> Hello, here is spec patch:
>>
>> https://lists.oasis-open.org/archives/virtio-comment/202105/msg00017.html
>>
>> Let's discuss it
> Yep, sure.
>
> About this series I think is better to split in two series since it 
> became very long. Patchwork [1] also complains here [2].
>
> You can send a first series with patches from 1 to 7. These patches are 
> reviewed by me and can go regardless of the discussion of the VIRTIO 
> specifications.
Ok, i'll send it on next week.
> Maybe you can also add the patch with the test to this first series.
>
> Please specify in the cover letter that the implementation for virtio 
> devices is under development and will be sent later.
>
>
> When it will be merged in the net-next tree, you can post the second 
> part with the rest of the series that implements SEQPACKET for virtio 
> devices, possibly after we received an agreement for the specifications.
>
> Please use the "net-next" tag and take a look at 
> Documentation/networking/netdev-FAQ.rst about netdev development.
Ok
>
>
> Anyway, in the next days (hopefully tomorrow) I'll review the rest of 
> the series related to virtio devices and spec.
>
> Thanks,
> Stefano
>
> [1] 
> https://patchwork.kernel.org/project/netdevbpf/list/?series=486011&state=*
>
> [2] 
> https://patchwork.kernel.org/project/netdevbpf/patch/20210520191449.1270723-1-arseny.krasnov@kaspersky.com/
>
>
