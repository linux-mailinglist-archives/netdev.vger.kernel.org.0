Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E371E33C8
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 01:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgEZXgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 19:36:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:34494 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgEZXga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 19:36:30 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdj7E-0004iD-Ef; Wed, 27 May 2020 01:36:12 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdj7D-000Fqz-W9; Wed, 27 May 2020 01:36:12 +0200
Subject: Re: [PATCH RFC bpf-next 0/4] bpf: Add support for XDP programs in
 DEVMAPs
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200522010526.14649-1-dsahern@kernel.org>
 <87lflkj6zs.fsf@toke.dk> <f94be4c8-c547-1be0-98c8-7e7cd3b7ee71@gmail.com>
 <87v9kki523.fsf@toke.dk> <20200525144752.3e87f8cd@carbon>
 <87pnasi35x.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0bb7b04c-60a9-525a-575d-944385851487@iogearbox.net>
Date:   Wed, 27 May 2020 01:36:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87pnasi35x.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25824/Tue May 26 14:27:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/25/20 2:56 PM, Toke Høiland-Jørgensen wrote:
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> On Mon, 25 May 2020 14:15:32 +0200
>> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>> David Ahern <dsahern@gmail.com> writes:
>>>> On 5/22/20 9:59 AM, Toke Høiland-Jørgensen wrote:
>>>>> David Ahern <dsahern@kernel.org> writes:
>>>>>    
>>>>>> Implementation of Daniel's proposal for allowing DEVMAP entries to be
>>>>>> a device index, program id pair. Daniel suggested an fd to specify the
>>>>>> program, but that seems odd to me that you insert the value as an fd, but
>>>>>> read it back as an id since the fd can be closed.
>>>>>
>>>>> While I can be sympathetic to the argument that it seems odd, every
>>>>> other API uses FD for insert and returns ID, so why make it different
>>>>> here? Also, the choice has privilege implications, since the CAP_BPF
>>>>> series explicitly makes going from ID->FD a more privileged operation
>>>>> than just querying the ID.

[...]

>> I sympathize with Ahern on this.  It seems very weird to insert/write
>> one value-type, but read another value-type.
> 
> Yeah, I do kinda agree that it's a bit weird. But it's what we do
> everywhere else, so I think consistency wins out here. There might be an
> argument that maps should be different (because they're conceptually a
> read/write data structure not a syscall return value). But again, we
> already have a map type that takes prog IDs, and that already does the
> rewriting, so doing it different here would be even weirder...

Sorry for the late reply. Agree, it would at least be consistent to what is done
in tail call maps, and the XDP netlink API where you have the fd->id in both cases.
Either way, quick glance over the patches, the direction of this RFC looks good to
me, better fit than the prior XDP egress approaches.

Thanks,
Daniel
