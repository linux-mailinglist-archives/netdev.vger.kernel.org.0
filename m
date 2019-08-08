Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137B5860F9
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 13:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfHHLkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 07:40:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:58610 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbfHHLkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 07:40:09 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hvgm2-00007p-JZ; Thu, 08 Aug 2019 13:40:02 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hvgm2-000W6w-Cb; Thu, 08 Aug 2019 13:40:02 +0200
Subject: Re: [PATCH net 1/2] sock: make cookie generation global instead of
 per netns
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        m@lambda.lt, Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
References: <20190808094937.26918-1-daniel@iogearbox.net>
 <20190808094937.26918-2-daniel@iogearbox.net>
 <CANn89iKzaxxyC=6s45PEnTsKfz7GN4HHOw3wtpb6-ozrJSRP=g@mail.gmail.com>
 <d87d35a1-0ebc-4e48-1950-e94fde62a6c4@iogearbox.net>
 <CANn89iLqhYF=JYtNtB25O=0a_tn50dRko3fqvvC-sWTZXuK+0g@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <31e7c59d-a937-d312-476a-8074704d4bf0@iogearbox.net>
Date:   Thu, 8 Aug 2019 13:40:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANn89iLqhYF=JYtNtB25O=0a_tn50dRko3fqvvC-sWTZXuK+0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25535/Thu Aug  8 10:18:42 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/19 1:37 PM, Eric Dumazet wrote:
> On Thu, Aug 8, 2019 at 1:09 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 8/8/19 12:45 PM, Eric Dumazet wrote:
>>> On Thu, Aug 8, 2019 at 11:50 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>
>>>> Socket cookie consumers must assume the value as opqaue in any case.
>>>> The cookie does not guarantee an always unique identifier since it
>>>> could wrap in fabricated corner cases where two sockets could end up
>>>> holding the same cookie,
>>>
>>> What do you mean by this ?
>>>
>>> Cookie is guaranteed to be unique, it is from a 64bit counter...
>>>
>>> There should be no collision.
>>
>> I meant the [theoretical] corner case where socket_1 has cookie X and
>> we'd create, trigger sock_gen_cookie() to increment, close socket in a
>> loop until we wrap and get another cookie X for socket_2; agree it's
>> impractical and for little gain anyway. So in practice there should be
>> no collision which is what I tried to say.
> 
> If a 64bit counter, updated by one unit at a time could overflow
> during the lifetime of a host,
> I would agree with you, but this can not happen, even if we succeed to
> make 1 billion
> locked increments per second (this would still need 584 years)
> 
> I would prefer not mentioning something that can not possibly happen
> in your changelog ;)

Yep fair enough, makes sense. I'll fix it :)
