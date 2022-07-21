Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1591C57CA0D
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 13:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiGULyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 07:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiGULyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 07:54:52 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247F283225;
        Thu, 21 Jul 2022 04:54:50 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id DA5C11008B396;
        Thu, 21 Jul 2022 19:54:46 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id C99782008B6BA;
        Thu, 21 Jul 2022 19:54:46 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YmJURmnhOz3I; Thu, 21 Jul 2022 19:54:46 +0800 (CST)
Received: from [192.168.24.189] (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id 1F3E0200C0822;
        Thu, 21 Jul 2022 19:54:35 +0800 (CST)
Message-ID: <4c1d4b69-33d9-1b84-1e3f-58441c3e67d3@sjtu.edu.cn>
Date:   Thu, 21 Jul 2022 19:54:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC 0/5] In virtio-spec 1.1, new feature bit VIRTIO_F_IN_ORDER
 was introduced.
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     eperezma <eperezma@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, mst <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
 <CACGkMEtvjy1_NYHOV=VKMWcggYnOUBk3PRue=t0Kd4wtHjfzQg@mail.gmail.com>
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
In-Reply-To: <CACGkMEtvjy1_NYHOV=VKMWcggYnOUBk3PRue=t0Kd4wtHjfzQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/7/21 17:17, Jason Wang wrote:
> On Thu, Jul 21, 2022 at 4:44 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>> When this feature has been negotiated, virtio driver will use
>> descriptors in ring order: starting from offset 0 in the table, and
>> wrapping around at the end of the table. Vhost devices will always use
>> descriptors in the same order in which they have been made available.
>> This can reduce virtio accesses to used ring.
>>
>> Based on updated virtio-spec, this series realized IN_ORDER prototype
>> in virtio driver and vhost.
> Thanks a lot for the series.
>
> I wonder if you can share any performance numbers for this?
>
> Thanks

As a RFC series, current prototype only support virtio_test, and its 
performance evaluation between

in order and traditional has little difference. We can focus on the 
prototype design at this stage.

I will continue work to support real network driver and device, thus 
share more persuasive performance result.

Thanks.

>> Guo Zhi (5):
>>    vhost: reorder used descriptors in a batch
>>    vhost: announce VIRTIO_F_IN_ORDER support
>>    vhost_test: batch used buffer
>>    virtio: get desc id in order
>>    virtio: annouce VIRTIO_F_IN_ORDER support
>>
>>   drivers/vhost/test.c         | 15 +++++++++++-
>>   drivers/vhost/vhost.c        | 44 ++++++++++++++++++++++++++++++++++--
>>   drivers/vhost/vhost.h        |  4 ++++
>>   drivers/virtio/virtio_ring.c | 39 +++++++++++++++++++++++++-------
>>   4 files changed, 91 insertions(+), 11 deletions(-)
>>
>> --
>> 2.17.1
>>

