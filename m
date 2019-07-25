Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9EF755C4
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 19:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbfGYRaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 13:30:55 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33928 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfGYRaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 13:30:55 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so17156258pgc.1;
        Thu, 25 Jul 2019 10:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=pFhWwpuQJAAZriheotQswFNnxzflRBwJk2feUQZd+IM=;
        b=UiqfizTF36wlkgKv42171Utz/Ecd0W5DIOosQUAc5FDsJ4ywteQZfcZLhzoZcx0Ne8
         q+LvSN4xYvHxvfAwQLeOJOI65P9ECvtNOAlgNZOIc9hSL6HDarl0EutCCwNEOfs2tHjB
         MVsPYlC39g3U3QlsGgXk+86RpWopQGXyzj7lgNs+Uo7QMMhb2OSNOAkDOhUvZwaIng98
         oYaaxQAH2p5+7FOdnE/bOj+gZWAQ2/t9dUOQeLqNzYoGkBEJs2xVLqRoi5UAb7LFakb7
         MMEzDuo4Cg4oj06x+njFnVardBm48z5zdDwM3WAkJnQPxJPu49nI3yf0lbENNk27QHyV
         U2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=pFhWwpuQJAAZriheotQswFNnxzflRBwJk2feUQZd+IM=;
        b=lXOxD/CmCtHNZxPgMQ7IRNX+s297z/JBocfv3zcf00xcuX8AxuabH80Bzubc2USUaz
         tu2yVzdWyo0mRYkzyKe0EhKe0/bLL3ymW6BqOCspIV5tRG13H2P51A5puWweqpBSnx+j
         If+oXPewC1exEdmoBWcaXbpZcy4vR8bIwkzDlw3UJuHVj/ss3AhRSzHf1Lqzy4t09LaO
         yKt9k5eGfsH30JaR3Y5dZmT0HSigrjM3Vt17vDMQzskbaMplyRmTeaIKQ8bMQwDMlz/s
         B+MH5wNesYuOQIZGzlQMQuu0HZNJ6rG88mxhhVPJsRzeS6MjH7pcx5OiwMFALKn2zBRi
         GQyg==
X-Gm-Message-State: APjAAAVUnzqW9wXcse/HMtALPcK/tGZYNP+01b9z3ifPwePq9FyX7eXS
        Sv67ubzc4E7pAL7hVTAQHppOMIyhzpA=
X-Google-Smtp-Source: APXvYqzByMxo1emAABFwvUzRIRFa7QaY+BEiXXjgp4NiQ4ksoT6rN1CmBdDSh1YZFMsY4mSbEC0azg==
X-Received: by 2002:a17:90a:21ac:: with SMTP id q41mr95501707pjc.31.1564075854370;
        Thu, 25 Jul 2019 10:30:54 -0700 (PDT)
Received: from [172.20.174.128] ([2620:10d:c090:180::1:622f])
        by smtp.gmail.com with ESMTPSA id 11sm51383575pfw.33.2019.07.25.10.30.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 10:30:53 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Richardson, Bruce" <bruce.richardson@intel.com>
Cc:     "Laatz, Kevin" <kevin.laatz@intel.com>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        "Loftus, Ciara" <ciara.loftus@intel.com>, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v3 00/11] XDP unaligned chunk placement support
Date:   Thu, 25 Jul 2019 10:30:51 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <8189384E-6050-4389-AA6A-09CD86FE8829@gmail.com>
In-Reply-To: <59AF69C657FD0841A61C55336867B5B07EDB5C3F@IRSMSX103.ger.corp.intel.com>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
 <94EAD717-F632-499F-8BBD-FFF5A5333CBF@gmail.com>
 <59AF69C657FD0841A61C55336867B5B07EDB5C3F@IRSMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25 Jul 2019, at 8:56, Richardson, Bruce wrote:

>> -----Original Message-----
>> From: Jonathan Lemon [mailto:jonathan.lemon@gmail.com]
>> Sent: Thursday, July 25, 2019 4:39 PM
>> To: Laatz, Kevin <kevin.laatz@intel.com>
>> Cc: netdev@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net; Topel,
>> Bjorn <bjorn.topel@intel.com>; Karlsson, Magnus
>> <magnus.karlsson@intel.com>; jakub.kicinski@netronome.com;
>> saeedm@mellanox.com; maximmi@mellanox.com; stephen@networkplumber.org;
>> Richardson, Bruce <bruce.richardson@intel.com>; Loftus, Ciara
>> <ciara.loftus@intel.com>; bpf@vger.kernel.org; intel-wired-
>> lan@lists.osuosl.org
>> Subject: Re: [PATCH bpf-next v3 00/11] XDP unaligned chunk placement
>> support
>>
>>
>>
>> On 23 Jul 2019, at 22:10, Kevin Laatz wrote:
>>
>>> This patch set adds the ability to use unaligned chunks in the XDP umem.
>>>
>>> Currently, all chunk addresses passed to the umem are masked to be
>>> chunk size aligned (max is PAGE_SIZE). This limits where we can place
>>> chunks within the umem as well as limiting the packet sizes that are
>> supported.
>>>
>>> The changes in this patch set removes these restrictions, allowing XDP
>>> to be more flexible in where it can place a chunk within a umem. By
>>> relaxing where the chunks can be placed, it allows us to use an
>>> arbitrary buffer size and place that wherever we have a free address
>>> in the umem. These changes add the ability to support arbitrary frame
>>> sizes up to 4k
>>> (PAGE_SIZE) and make it easy to integrate with other existing
>>> frameworks that have their own memory management systems, such as DPDK.
>>> In DPDK, for example, there is already support for AF_XDP with zero-
>> copy.
>>> However, with this patch set the integration will be much more seamless.
>>> You can find the DPDK AF_XDP driver at:
>>> https://git.dpdk.org/dpdk/tree/drivers/net/af_xdp
>>>
>>> Since we are now dealing with arbitrary frame sizes, we need also need
>>> to update how we pass around addresses. Currently, the addresses can
>>> simply be masked to 2k to get back to the original address. This
>>> becomes less trivial when using frame sizes that are not a 'power of
>>> 2' size. This patch set modifies the Rx/Tx descriptor format to use
>>> the upper 16-bits of the addr field for an offset value, leaving the
>>> lower 48-bits for the address (this leaves us with 256 Terabytes,
>>> which should be enough!). We only need to use the upper 16-bits to store
>> the offset when running in unaligned mode.
>>> Rather than adding the offset (headroom etc) to the address, we will
>>> store it in the upper 16-bits of the address field. This way, we can
>>> easily add the offset to the address where we need it, using some bit
>>> manipulation and addition, and we can also easily get the original
>>> address wherever we need it (for example in i40e_zca_fr-- ee) by
>>> simply masking to get the lower 48-bits of the address field.
>>
>> I wonder if it would be better to break backwards compatibility here and
>> say that a handle is going to change from [addr] to [base | offset], or
>> even [index | offset], where address = (index * chunk size) + offset, and
>> then use accessor macros to manipulate the queue entries.
>>
>> This way, the XDP hotpath can adjust the handle with simple arithmetic,
>> bypassing the "if (unaligned)", check, as it changes the offset directly.
>>
>> Using a chunk index instead of a base address is safer, otherwise it is
>> too easy to corrupt things.
>> --
>
> The trouble with using a chunk index is that it assumes that all chunks are
> contiguous, which is not always going to be the case. For example, for
> userspace apps the easiest way to get memory that is IOVA/physically
> contiguous is to use hugepages, but even then we still need to skip space
> when crossing a 2MB barrier.
>
> Specifically in this example case, with a 3k buffer size and 2MB hugepages,
> we'd get 666 buffers on a single page, but then waste a few KB before
> starting the 667th buffer at byte 0 on the second 2MB page.
> This is the setup used in DPDK, for instance, when we allocate memory for
> use in buffer pools.
>
> Therefore, I think it's better to just have the kernel sanity checking the
> request for safety and leave userspace the freedom to decide where in its
> memory area it wants to place the buffers.

That makes sense, thanks.  My concern is that this makes it difficult for
the kernel to validate the buffer start address, but perhaps that isn't a
concern.

I still believe it would simplify things if the format was [base | offset],
any opinion on that?
-- 
Jonathan
