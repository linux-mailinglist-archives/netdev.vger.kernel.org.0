Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68AD18EDF2
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbfHOOPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:15:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35812 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732116AbfHOOPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:15:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so1389281wmg.0
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 07:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mxfj9o0P5tEgod6FKkLFIahvcuu1vbJFdLB5VIxwJrQ=;
        b=QDCYP0DkglpbzoNmC3xXMbqF3JLEi7RZ38mZaMo21vRL440eO9beuJy1z3WRRWOSMi
         eUx6gvujg2aYEWNlkKzt7mcv+YOQh8U/0NkzAk0VLMxAAgRRSB/dRa/hqfrqtwFsD/mn
         iucbLLSydumMz8D7a0V0nM1fLyTPOE6koimawUc/6PUl5grfAIBZdJHaGVjP9B26gv/X
         1I0xp2s1O2HiHLjkYbwJ0DZWKhILtImreanJ+L6Jf+JleuivEsf99l1hMAA6lTUiIvnQ
         xFKz0a2CjkGNyeZuyy2DaZPCiWobpwL4sFcTZBI1/7CgBDjT/A8FXvYeg74y4tYAY960
         B0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Mxfj9o0P5tEgod6FKkLFIahvcuu1vbJFdLB5VIxwJrQ=;
        b=D02VkCdnQmQmBiM8so/lvXOTd/u/AGr/yG3DVyHAY+KZ+a+GfLoEWgczv5mun0KNwx
         Aji/6QQvuKZmyC4DAgnBXnRiHs5UPdNQW4P13btnlAqXmCw0+yNC1kVmsEV79iLlyRb5
         pyERya93MtBl5vFdtfwYk0LasVabkgHoiXWusCgLaNVuYaMfn71w5xAlk0SUEUh7Ogom
         OLG2GZz/pgEA9xDLNmzvLJBRGYaWPyTqrY2XnuBckCMmIxX1LLZfa8QB/dL4VTz7xVTQ
         pSgnBVxVCmjcU0b/ohXlUPA4VulQpjjkWlPxFw8g6bc9p1kDBtwStxTEpwMChY0VSGJm
         f7gA==
X-Gm-Message-State: APjAAAU0GHikHfSgzxIutpgDJ9jW1GoysTNSk/8Wp2bRDXZKf0oEDxyz
        EVKWWo3Rb0AMtRAjUuJyesRnZPqcB3I=
X-Google-Smtp-Source: APXvYqwSWnjm0osJQ3uqUB7vF7WzfYLODyyjHhCplD1OAT2LRKKPYWhp4WlVqz74HvE3m/KgQnZraA==
X-Received: by 2002:a7b:cf21:: with SMTP id m1mr3161253wmg.150.1565878535481;
        Thu, 15 Aug 2019 07:15:35 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r17sm6792721wrg.93.2019.08.15.07.15.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 07:15:34 -0700 (PDT)
To:     Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
 <20190814015149.b4pmubo3s4ou5yek@ast-mbp>
 <ab11a9f2-0fbd-d35f-fee1-784554a2705a@netronome.com>
 <bdb4b47b-25fa-eb96-aa8d-dd4f4b012277@solarflare.com>
 <18f887ec-99fd-20ae-f5d6-a1f4117b2d77@netronome.com>
 <84aa97e3-5fde-e041-12c6-85863e27d2d9@solarflare.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [RFC bpf-next 0/3] tools: bpftool: add subcommand to count map
 entries
Message-ID: <031de7fd-caa7-9e66-861f-8e46e5bb8851@netronome.com>
Date:   Thu, 15 Aug 2019 15:15:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <84aa97e3-5fde-e041-12c6-85863e27d2d9@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-14 18:14 UTC+0100 ~ Edward Cree <ecree@solarflare.com>
> On 14/08/2019 17:58, Quentin Monnet wrote:
>> 2019-08-14 17:45 UTC+0100 ~ Edward Cree <ecree@solarflare.com>
>>> This might be a really dumb suggestion, but: you're wanting to collect a
>>>  summary statistic over an in-kernel data structure in a single syscall,
>>>  because making a series of syscalls to examine every entry is slow and
>>>  racy.  Isn't that exactly a job for an in-kernel virtual machine, and
>>>  could you not supply an eBPF program which the kernel runs on each entry
>>>  in the map, thus supporting people who want to calculate something else
>>>  (mean, min and max, whatever) instead of count?
>>>
>> Hi Edward, I like the approach, thanks for the suggestion.
>>
>> But I did not mention that we were using offloaded maps: Tracing the
>> kernel would probably work for programs running on the host, but this is
>> not a solution we could extend to hardware offload.
> I don't see where "tracing" comes into it; this is a new program type and
>  a new map op under the bpf() syscall.
> Could the user-supplied BPF program not then be passed down to the device
>  for it to run against its offloaded maps?
> 

Sorry, I misunderstood your suggestion :s (I thought you meant tracing
the insert and delete operations).

So if I understand correctly, we would use the bpf() syscall to trigger
a run of such program on all map entries (for map implementing the new
operation), and the context would include pointers to the key and the
value for the entry being processed so we can count/sum/compute an
average of the values or any other kind of processing?

Thanks,
Quentin
