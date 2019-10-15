Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF5BD6C81
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 02:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfJOAeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 20:34:18 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42968 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfJOAeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 20:34:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id q12so11294248pff.9;
        Mon, 14 Oct 2019 17:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p63sdX+Vdm+k9Q/K8b8bZcwryvDdi7+PCTGQ3bkMavU=;
        b=imtzrVDYOhDb9/YBqDjfqrkETYkU9AyX8BQUP5CpRE6I71aSaE+YG1IImuLT79wZbZ
         EZU6AVpnMlH+1H5maCD34DFb5lYcXTgkv35FmgWjd7TbCKdtvCJ35yti4mrSIZwGxqth
         mHUy3chTY2JVnT2lB9EHj3aZl0UTN9S4x1ABpEperXS007ppUQ6uVQXfn7Oe2LQKhxUA
         7DkDHcTT+VnmXTJGIV8NC+J5hCaDL3pvgg1lsmCt0x/cm3KgKBXhTseuzP7LT6LgSXGS
         kB9xcdCCD70S+D0tVCFKnUJPy1IYtiLysJERFx0oq4ZvsKnF9gUUo0b8qqAGotP8tSDG
         XMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p63sdX+Vdm+k9Q/K8b8bZcwryvDdi7+PCTGQ3bkMavU=;
        b=A5CYvI2X/dK3rQbchZmqOP8tyoWfVM88uxTj23ZqrRt5UXsFm6c9nZCuP8BWcmJz7L
         YbYCO0cRjcVuBhkNXxyELNH/zpkywd6D+AMCswvRKYKZaKn0TV9kGyK0W0AnxIIPArEN
         QMt2uHHfRYHXkAnEL0Kd/fAj3EJ50pN92XBeDq01oVcUTV5BwxK5OSA2m24WbXlktfb0
         RT24jPbSisuFK+lopAH5HxKTGIzao6PsfRkdJWeT4qNkBaIoeQnZFCDQajuvBO14cWfw
         ByTtV5B6A+KpXC6dwrC0lrQg+BBuR8BZk3lAYxVmXAEFrj96fXPXoKxOPxCSp6w5nXzR
         e9fg==
X-Gm-Message-State: APjAAAWxL1yh12LoyEBRjQtLip/RoLQpevxIntVq26oPY2fQAkzFlPcp
        ihJXE4ISa1Sx5dGnxM1LN/gub87V
X-Google-Smtp-Source: APXvYqz+E34/dO6gMNpeSAMB6A0OsVDc28bUq28UDzqCg991LYJ0c2nmez5bgrso2AkovfLe9ZKTiQ==
X-Received: by 2002:a65:51cd:: with SMTP id i13mr36383031pgq.142.1571099655427;
        Mon, 14 Oct 2019 17:34:15 -0700 (PDT)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id j24sm19366486pff.71.2019.10.14.17.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2019 17:34:14 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] tuntap: reorganize tun_msg_ctl usage
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     David Ahern <dsahern@gmail.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
 <20191012015357.1775-2-prashantbhole.linux@gmail.com>
 <739281a8-59fe-d898-0147-656d01fdfabc@redhat.com>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <18ab09ed-55b9-babb-6d78-04a920918562@gmail.com>
Date:   Tue, 15 Oct 2019 09:33:42 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <739281a8-59fe-d898-0147-656d01fdfabc@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,
Thanks for reviewing.

On 10/12/19 4:44 PM, Jason Wang wrote:
> 
> On 2019/10/12 上午9:53, prashantbhole.linux@gmail.com wrote:
>> From: Prashant Bhole <prashantbhole.linux@gmail.com>
>>
>> In order to extend the usage of tun_msg_ctl structure, this patch
>> changes the member name from type to cmd. Also following definitions
>> are changed:
>> TUN_MSG_PTR : TUN_CMD_BATCH
>> TUN_MSG_UBUF: TUN_CMD_PACKET
> 
> 
> Not a native English speaker, but the conversion here looks not as 
> straightforward as it did.
> 
> For TUN_MSG_PTR, it means recvmsg() can do receiving from a pointer to 
> either XDP or skb instead of ptr_ring. TUN_CMD_BATCH sounds not related.
> 
> For TUN_MSG_UBUF, it means the packet is a zercopy (buffer pointers to 
> userspace). TUN_CMD_PACKET may bring confusion in this case.

Understood. Next time I will come up with better command names,
performance numbers and other changes suggested by you.

Thanks.

> 
> Thanks
> 
> 
>>
>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>> ---
>>   drivers/net/tap.c      | 9 ++++++---
>>   drivers/net/tun.c      | 8 ++++++--
>>   drivers/vhost/net.c    | 4 ++--
>>   include/linux/if_tun.h | 6 +++---
>>   4 files changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>> index 3ae70c7e6860..01bd260ce60c 100644
>> --- a/drivers/net/tap.c
>> +++ b/drivers/net/tap.c
>> @@ -1213,9 +1213,10 @@ static int tap_sendmsg(struct socket *sock, 
>> struct msghdr *m,
>>       struct tap_queue *q = container_of(sock, struct tap_queue, sock);
>>       struct tun_msg_ctl *ctl = m->msg_control;
>>       struct xdp_buff *xdp;
>> +    void *ptr = NULL;
>>       int i;
>> -    if (ctl && (ctl->type == TUN_MSG_PTR)) {
>> +    if (ctl && ctl->cmd == TUN_CMD_BATCH) {
>>           for (i = 0; i < ctl->num; i++) {
>>               xdp = &((struct xdp_buff *)ctl->ptr)[i];
>>               tap_get_user_xdp(q, xdp);
>> @@ -1223,8 +1224,10 @@ static int tap_sendmsg(struct socket *sock, 
>> struct msghdr *m,
>>           return 0;
>>       }
>> -    return tap_get_user(q, ctl ? ctl->ptr : NULL, &m->msg_iter,
>> -                m->msg_flags & MSG_DONTWAIT);
>> +    if (ctl && ctl->cmd == TUN_CMD_PACKET)
>> +        ptr = ctl->ptr;
>> +
>> +    return tap_get_user(q, ptr, &m->msg_iter, m->msg_flags & 
>> MSG_DONTWAIT);
>>   }
>>   static int tap_recvmsg(struct socket *sock, struct msghdr *m,
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 0413d182d782..29711671959b 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -2529,11 +2529,12 @@ static int tun_sendmsg(struct socket *sock, 
>> struct msghdr *m, size_t total_len)
>>       struct tun_struct *tun = tun_get(tfile);
>>       struct tun_msg_ctl *ctl = m->msg_control;
>>       struct xdp_buff *xdp;
>> +    void *ptr = NULL;
>>       if (!tun)
>>           return -EBADFD;
>> -    if (ctl && (ctl->type == TUN_MSG_PTR)) {
>> +    if (ctl && ctl->cmd == TUN_CMD_BATCH) {
>>           struct tun_page tpage;
>>           int n = ctl->num;
>>           int flush = 0;
>> @@ -2560,7 +2561,10 @@ static int tun_sendmsg(struct socket *sock, 
>> struct msghdr *m, size_t total_len)
>>           goto out;
>>       }
>> -    ret = tun_get_user(tun, tfile, ctl ? ctl->ptr : NULL, &m->msg_iter,
>> +    if (ctl && ctl->cmd == TUN_CMD_PACKET)
>> +        ptr = ctl->ptr;
>> +
>> +    ret = tun_get_user(tun, tfile, ptr, &m->msg_iter,
>>                  m->msg_flags & MSG_DONTWAIT,
>>                  m->msg_flags & MSG_MORE);
>>   out:
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index 1a2dd53caade..5946d2775bd0 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -462,7 +462,7 @@ static void vhost_tx_batch(struct vhost_net *net,
>>                  struct msghdr *msghdr)
>>   {
>>       struct tun_msg_ctl ctl = {
>> -        .type = TUN_MSG_PTR,
>> +        .cmd = TUN_CMD_BATCH,
>>           .num = nvq->batched_xdp,
>>           .ptr = nvq->xdp,
>>       };
>> @@ -902,7 +902,7 @@ static void handle_tx_zerocopy(struct vhost_net 
>> *net, struct socket *sock)
>>               ubuf->desc = nvq->upend_idx;
>>               refcount_set(&ubuf->refcnt, 1);
>>               msg.msg_control = &ctl;
>> -            ctl.type = TUN_MSG_UBUF;
>> +            ctl.cmd = TUN_CMD_PACKET;
>>               ctl.ptr = ubuf;
>>               msg.msg_controllen = sizeof(ctl);
>>               ubufs = nvq->ubufs;
>> diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
>> index 5bda8cf457b6..bdfa671612db 100644
>> --- a/include/linux/if_tun.h
>> +++ b/include/linux/if_tun.h
>> @@ -11,10 +11,10 @@
>>   #define TUN_XDP_FLAG 0x1UL
>> -#define TUN_MSG_UBUF 1
>> -#define TUN_MSG_PTR  2
>> +#define TUN_CMD_PACKET 1
>> +#define TUN_CMD_BATCH  2
>>   struct tun_msg_ctl {
>> -    unsigned short type;
>> +    unsigned short cmd;
>>       unsigned short num;
>>       void *ptr;
>>   };
