Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6EAC8D75F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfHNPm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:42:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34885 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfHNPm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:42:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id gn20so1604149plb.2;
        Wed, 14 Aug 2019 08:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=DYA5xx5hyEUZw7ybqZXJz5NWAkOUsK+7lDp10dnSwVY=;
        b=RKTRcFQFhNg8wMb6AkJStLeB0sUZRetJ7IXxLs1lqWeLhir7Sphy+Sc1AHZ6PMwVRS
         QEkKeYPHsSP5yx1bxS8tCT7wJ0yS7RNhpYF4BMV0w2N+/ColtHSyt98K0DbtPlWjj77y
         znnSq/1E7WSHlfCPL840wJPWd+tBJZm9vu1sH8aur6UzMoY9jD7QdpIhsmW5sPiAoDAH
         acgzkV7iRk0q7jjzouNOHs3dG5rD+MyUvmr1uKeC092YLUmMPJH6y+LzwgQRl9PmJB2s
         hQNOaBCJHxKwM0fiBqQWoE2gRAUdloV5/neC5Nbaai8004XKlawoayNYUNIe9KjO1TYN
         7jkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=DYA5xx5hyEUZw7ybqZXJz5NWAkOUsK+7lDp10dnSwVY=;
        b=GdVgkD9oP7nJiBtR/nAiSRhkRMfJlilsa3eaE58n/zr/DkmwgqQwybqXTfj9ZeP90G
         m7upk/FIwpbVu5C6jVWPe8Z2eh6F5sDe4JP5ZQgvOM6PCK/WfdNceGvncevrid8wH7IK
         7ff8eiTYUs5YjrCR8p4MafnA7nwEWkAjsEQLZbBidkiN2dqDU+fteFNzyZtu8oFFsTJZ
         b9VMGpbe91gzjvd19+Zy2JscUT5Z/GiTfCrEopD+iqm3Vn5P5BzHGYLgaACBq6LDbSyD
         uU0nFdJs8jk3DHG7oSHmsfXFPWGe8Klw4yLO0PHw7L0j46FUfS8jtQDdv4FmegvvLF5+
         p3Iw==
X-Gm-Message-State: APjAAAVaQmvyFLzzNmJOP1f5eMBOvWT3D/gEnjok1TA466MzSh1mPpuu
        +2xHzzwx5KalHkY9AVftYzE=
X-Google-Smtp-Source: APXvYqx5nEGUKZ3WiQGzuTkUBuju10ec8RUMiR5JLP5IL8PXQCQ2bB0H2fLFfD2ZDXB6eNEqAEyVdQ==
X-Received: by 2002:a17:902:883:: with SMTP id 3mr70862pll.318.1565797377949;
        Wed, 14 Aug 2019 08:42:57 -0700 (PDT)
Received: from [172.26.122.72] ([2620:10d:c090:180::6327])
        by smtp.gmail.com with ESMTPSA id q8sm203353pjq.20.2019.08.14.08.42.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 08:42:57 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@gmail.com>
Cc:     "Magnus Karlsson" <magnus.karlsson@intel.com>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Network Development" <netdev@vger.kernel.org>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        bpf <bpf@vger.kernel.org>, bruce.richardson@intel.com,
        ciara.loftus@intel.com,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Ye Xiaolong" <xiaolong.ye@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Kevin Laatz" <kevin.laatz@intel.com>, ilias.apalodimas@linaro.org,
        Kiran <kiran.patil@intel.com>, axboe@kernel.dk,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Maciej Fijalkowski" <maciejromanfijalkowski@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH bpf-next v4 3/8] i40e: add support for AF_XDP need_wakeup
 feature
Date:   Wed, 14 Aug 2019 08:42:55 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <61B6830B-7EBF-4B44-A53C-9F56D5D42426@gmail.com>
In-Reply-To: <CAJ8uoz0Tnb=i-LkGqLU87be9BuYqxmu2pN1Mte0UEWA2+f8bTQ@mail.gmail.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
 <1565767643-4908-4-git-send-email-magnus.karlsson@intel.com>
 <3B2C7C21-4AAC-4126-A31D-58A61D941709@gmail.com>
 <CAJ8uoz0Tnb=i-LkGqLU87be9BuYqxmu2pN1Mte0UEWA2+f8bTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Aug 2019, at 7:59, Magnus Karlsson wrote:

> On Wed, Aug 14, 2019 at 4:48 PM Jonathan Lemon 
> <jonathan.lemon@gmail.com> wrote:
>>
>>
>>
>> On 14 Aug 2019, at 0:27, Magnus Karlsson wrote:
>>
>>> This patch adds support for the need_wakeup feature of AF_XDP. If 
>>> the
>>> application has told the kernel that it might sleep using the new 
>>> bind
>>> flag XDP_USE_NEED_WAKEUP, the driver will then set this flag if it 
>>> has
>>> no more buffers on the NIC Rx ring and yield to the application. For
>>> Tx, it will set the flag if it has no outstanding Tx completion
>>> interrupts and return to the application.
>>>
>>> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>>> ---
>>>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 18 ++++++++++++++++++
>>>  1 file changed, 18 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>>> b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>>> index d0ff5d8..42c9012 100644
>>> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>>> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
>>> @@ -626,6 +626,15 @@ int i40e_clean_rx_irq_zc(struct i40e_ring
>>> *rx_ring, int budget)
>>>
>>>       i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
>>>       i40e_update_rx_stats(rx_ring, total_rx_bytes, 
>>> total_rx_packets);
>>> +
>>> +     if (xsk_umem_uses_need_wakeup(rx_ring->xsk_umem)) {
>>> +             if (failure || rx_ring->next_to_clean == 
>>> rx_ring->next_to_use)
>>> +                     xsk_set_rx_need_wakeup(rx_ring->xsk_umem);
>>> +             else
>>> +                     xsk_clear_rx_need_wakeup(rx_ring->xsk_umem);
>>> +
>>> +             return (int)total_rx_packets;
>>> +     }
>>>       return failure ? budget : (int)total_rx_packets;
>>
>> Can you elaborate why we're not returning the total budget on failure
>> for the wakeup case?
>
> In the non need_wakeup case (the old behavior), when allocation fails
> from the fill queue we want to retry right away basically busy
> spinning on the fill queue until we find at least one entry and then
> go on processing packets. Works well when the app and the driver are
> on different cores, but a lousy strategy when they execute on the same
> core. That is why in the need_wakeup feature case, we do not return
> the total budget if there is a failure. We will just come back at a
> later point in time from a syscall since the need_wakeup flag will
> have been set and check the fill queue again. We do not want a
> busy-spinning behavior in this case.

That makes sense.  Thanks for all the work on this, Magnus!
-- 
Jonathan
