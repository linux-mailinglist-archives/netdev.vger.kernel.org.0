Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B624259C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbfFLM0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:26:09 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:34430 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfFLM0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:26:08 -0400
Received: by mail-ua1-f66.google.com with SMTP id c4so1346262uad.1
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 05:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=7goNvhglzUO2C7xjkqDQYZkLXNCnrE6QZxOYE9iirMg=;
        b=PI8YDnw3uUtj+5PSxCJUN9Mt10dWUuswZQbQmfrjW1h2+ZuLxEORSTfDBNYbXFC/34
         C6bPlD1pj5Z7LAEvrCGlS4tv32l01lFu+mFDE8mY17grUO0OxTmfTN3SUstIYGOTqepr
         D5j/tWhCRh+zMgsuTQnY/YNTROZIdktGE+WRDfqcy8h+qnHQ2rXWVtu/Y6l7UK0IL4g8
         BYWMLJdiVB0RjOoyD7cKvc9PX365ZnpfikcglTFATQSuNIIXjbNHcRtoIGLSObZ7mhs8
         FnvlkEa4HhelMXacq3doefoTFwxVLh1C9j/rggHGZ7gI+Z0zJgxICfHXfqhUj2nGFc8R
         evMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=7goNvhglzUO2C7xjkqDQYZkLXNCnrE6QZxOYE9iirMg=;
        b=Myxwc1giIcrmNmh/1/rRX35t4avhp+uQ1mr2fq4fxDDLtD/HLm8BvBuCeN+OtCzyYC
         mXW+l0DcG2S/WK4KR0Edzwxzq55/EX3MBE9dbhtO39bXPEpodzj8O7ZXIL/CFXEMHu+Y
         wLc/8crBtoocfUKPGHRVyscUj+5TQn0kpgOm3+gnN2+qgr9NDyrPuzPyc8rN92ixPmbt
         Xis7NKIojD32VMuMvbRltzn2CVrAzEhIgfGm5OFj8tJ8kVpa0K+lQNserCQNiHofpbLu
         cRG5EIaxDeN7DQxO706NXCf2Db5KTK9VqNu8B239I1Vlid6YY53AwIeeSgF05YEVQg5j
         PDEg==
X-Gm-Message-State: APjAAAVADZ1hg2RWrxZEX2SrkBEsK2HdmbR/5e2TQJoh+lj2nEVjgjNh
        D7Pepsmxnuh8BzHBqxcYIHh9YoAmbEo57UELPpKmIQ==
X-Google-Smtp-Source: APXvYqynk/i4mwDYyq1YwQCoVDH2UoekfgAzWEDjsTxXRLr9MT2bobgcnziipLn/hbKAG3Ebca2LtGryZgNmE6HOrUs=
X-Received: by 2002:ab0:734f:: with SMTP id k15mr28416792uap.28.1560342367656;
 Wed, 12 Jun 2019 05:26:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:108a:0:0:0:0:0 with HTTP; Wed, 12 Jun 2019 05:26:07
 -0700 (PDT)
X-Originating-IP: [5.35.24.158]
In-Reply-To: <20190612120909.GI31797@unicorn.suse.cz>
References: <20190612113348.59858-1-dkirjanov@suse.com> <20190612113348.59858-3-dkirjanov@suse.com>
 <20190612120909.GI31797@unicorn.suse.cz>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 12 Jun 2019 15:26:07 +0300
Message-ID: <CAOJe8K0x-OFg656266oc8ky6VtcX9tUOm03_gWtVBfiXgjJ73w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] ipoib: correcly show a VF hardware address
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     davem@davemloft.net, dledford@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/19, Michal Kubecek <mkubecek@suse.cz> wrote:
> On Wed, Jun 12, 2019 at 01:33:47PM +0200, Denis Kirjanov wrote:
>> in the case of IPoIB with SRIOV enabled hardware
>> ip link show command incorrecly prints
>> 0 instead of a VF hardware address. To correcly print the address
>> add a new field to specify an address length.
>>
>> Before:
>> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
>> state UP mode DEFAULT group default qlen 256
>>     link/infiniband
>> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
>> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>>     vf 0 MAC 00:00:00:00:00:00, spoof checking off, link-state disable,
>> trust off, query_rss off
>> ...
>> After:
>> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
>> state UP mode DEFAULT group default qlen 256
>>     link/infiniband
>> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
>> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>>     vf 0     link/infiniband
>> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
>> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
>> checking off, link-state disable, trust off, query_rss off
>> ...
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>> ---
> ...
>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>> index 5b225ff63b48..904ee1a7330b 100644
>> --- a/include/uapi/linux/if_link.h
>> +++ b/include/uapi/linux/if_link.h
>> @@ -702,6 +702,7 @@ enum {
>>  struct ifla_vf_mac {
>>  	__u32 vf;
>>  	__u8 mac[32]; /* MAX_ADDR_LEN */
>> +	__u8 addr_len;
>>  };
>
> This structure is part of userspace API, adding a member would break
> compatibility between new kernel and old iproute2 and vice versa. Do we
> need to pass MAC address length for each VF if (AFAICS) it's always the
> same as dev->addr_len?

I believe so, initially I thought that it's required to pass a length
but looks like I can use RTA_DATA/RTA_PAYLOAD() for that.


>
> Michal
>
>
