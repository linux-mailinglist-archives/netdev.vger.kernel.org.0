Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1614105E8
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 12:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbhIRKON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 06:14:13 -0400
Received: from mout.gmx.net ([212.227.17.21]:58827 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231649AbhIRKOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 06:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631959945;
        bh=H3tRWYxuhIRjBxTKOCfOX3TM81li5t9cdGykyOXsdlY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=iziszq6x26jPVEEutUcYBZwRwAQjuDU29KssGkhRFyFnyvo5WN6DRG7mqsC36iTGT
         kllFEULRrTksShzc6RNeWtQvxy2Z9aOkSUqVLw6/RHe4/QNlKhlKUhtC2tW/BK6v9p
         bKmAFrvkvulrZ+iXkPQNvo7d5MEHiDkioDcIvXW8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.100] ([79.206.231.202]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MK3Rm-1mBeND1QSc-00LSVW; Sat, 18
 Sep 2021 12:12:25 +0200
Subject: Re: [PATCH V2] ath10k: don't fail if IRAM write fails
To:     ojab // <ojab@ojab.ru>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath10k@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20210722193459.7474-1-ojab@ojab.ru>
 <CAKzrAgRt0jRFyFNjF-uq=feG-9nhCx=tTztCgCEitj1cpMk_Xg@mail.gmail.com>
 <CAKzrAgQgsN6=Cu4SvjSSFoJOqAkU2t8cjt7sgEsJdNhvM8f7jg@mail.gmail.com>
 <CAKzrAgSEiq-qOgetzryaE3JyBUe3URYjr=Fn0kz9sF7ZryQ5pA@mail.gmail.com>
From:   "sparks71@gmx.de" <sparks71@gmx.de>
Message-ID: <538825a2-82f0-6102-01da-6e0385e53cf5@gmx.de>
Date:   Sat, 18 Sep 2021 12:12:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAKzrAgSEiq-qOgetzryaE3JyBUe3URYjr=Fn0kz9sF7ZryQ5pA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:1k9yNyZFQRUsK6JEgczeDTsNx3bODEpJ6PC+mqth2f8vGpYaKMm
 lkjbw3qlT4/GqCYf0HRNe1KDOG3a09RL3UkNfDAbP2obIcTVrAJtKUaNTU0V4jqpehjxD1d
 P1Y4gSF6X4ioLhprb5WiZJ8+SIIHLbpdWgNn/uP4KwheX/0RDMkeXEGW/3D9yo8JhRQ09Zv
 y2jyQRs//V752d15SUMaA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:H1ORkNVaYGk=:vs366eiYFEibi+fOuzHOl/
 LvZpL6vFesTKdvA21FS9etpkDlWlhIDXgVDVIsgvxTOPq/lR+/wmYSzsjgjtqa2su3dsU4vzC
 VamO+xBd6SCLaIcRiHwCOZ02Wh94V2V0sNA9BgbCvDfy0p+NehNJnLabekOeBPO7I0yNDGQ8W
 7BDQncNWYShloyV7u9vzUNdQ7IqfCkbVpg4JTm/b7dlqqkGIHREuxj7RcFngOFhvOcDH5U1Pd
 44wLQb1orq2eroI/UyT6Yij9ZbOonod12RvukB7arGQgWUaLDO3YLvGnaHb6vMcLk9X35NpGX
 qBSb45k3z6dn7RRKXUwbAvmZMYmXXWyYK0nr1ee7B3JspoH6qGuCq1E6wGZDZ1RQU7+0yotBw
 NVIyj7no6t9bSjLWgQzzDE5z+v7Y6jmqJBJhvCIF9xRIp1eKOXyN/H+JQV2C/AYCZKZBS/cIq
 Ks5deRN/O0G23zA+2mtk6a3H6AI2zHURrZRY4vT9euyxpX9a95psKXkPrKiXwjQhWJiEhe901
 aGxRaWTeTmk71d8oACHOzfDejUHuPV7gOPVlHVfEdxGs+sqCE1RMfD/FX8YwOtGwoDBsHMf11
 USXNi65uTjAouZqSH7Vu6z5C2sVujqn5eIdi+bFv+WBBIYBa+T147alle2qtQxoBZXuDbHiKJ
 d92fv0k2PxnZVx7scQN3e7fKpLp5XNYwL2tEZe5m8UPX6S5Vq8Z5Bs9B1Td0T8us5Ph+4jMNx
 HmdmGFBFssNIkHKcKde5xl8HHoCv6iMDt3z36lJhlTXlbR+OKt9OyfAYqiHF7uq3ceX6ErD54
 x5IEVudfENLuq6NQZBvygvfO8rn7fH7nGafO3Y2jsYkd72nDd28KuX6GSsTQ+MJJebjxre6Cb
 Qje4hmM1H6+KCGf32WxNNppUuypJTkRw7O2qRAjgL8kYWF7NhASwh8TuYGW6m2/s9RbVrSWH+
 RR/3O7LOEvPVWTCBEHEJuWq8/Pu2/wRtEJlPfSXEdIRek9lGPgsX7rHxbvQFy+k0BPKfURbkK
 KOCkInhIC7Gw2CTCWI4W7Bs78g6lx9qWVxU5Cept4zEHWZf14o9YF0jXseR7CLz26m1WNFjjL
 fSoBNhgKSbhRJQ=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Have you seen the new patch?

https://www.mail-archive.com/ath10k@lists.infradead.org/msg13784.html

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=master-pending&id=973de582639a1e45276e4e3e2f3c2d82a04ad0a6


could probably have been communicated better


best regards



Am 17.09.21 um 21:30 schrieb ojab //:
> ._.
>
> //wbr ojab
>
> On Thu, 9 Sept 2021 at 02:42, ojab // <ojab@ojab.ru> wrote:
>> Gentle ping.
>>
>> //wbr ojab
>>
>> On Wed, 25 Aug 2021 at 19:15, ojab // <ojab@ojab.ru> wrote:
>>> Can I haz it merged?
>>>
>>> //wbr ojab
>>>
>>> On Thu, 22 Jul 2021 at 22:36, ojab <ojab@ojab.ru> wrote:
>>>> After reboot with kernel & firmware updates I found `failed to copy
>>>> target iram contents:` in dmesg and missing wlan interfaces for both
>>>> of my QCA9984 compex cards. Rolling back kernel/firmware didn't fixed
>>>> it, so while I have no idea what's actually happening, I don't see why
>>>> we should fail in this case, looks like some optional firmware ability
>>>> that could be skipped.
>>>>
>>>> Also with additional logging there is
>>>> ```
>>>> [    6.839858] ath10k_pci 0000:04:00.0: No hardware memory
>>>> [    6.841205] ath10k_pci 0000:04:00.0: failed to copy target iram contents: -12
>>>> [    6.873578] ath10k_pci 0000:07:00.0: No hardware memory
>>>> [    6.875052] ath10k_pci 0000:07:00.0: failed to copy target iram contents: -12
>>>> ```
>>>> so exact branch could be seen.
>>>>
>>>> Signed-off-by: Slava Kardakov <ojab@ojab.ru>
>>>> ---
>>>>   Of course I forgot to sing off, since I don't use it by default because I
>>>>   hate my real name and kernel requires it
>>>>
>>>>   drivers/net/wireless/ath/ath10k/core.c | 9 ++++++---
>>>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>>>> index 2f9be182fbfb..d9fd5294e142 100644
>>>> --- a/drivers/net/wireless/ath/ath10k/core.c
>>>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>>>> @@ -2691,8 +2691,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
>>>>          u32 len, remaining_len;
>>>>
>>>>          hw_mem = ath10k_coredump_get_mem_layout(ar);
>>>> -       if (!hw_mem)
>>>> +       if (!hw_mem) {
>>>> +               ath10k_warn(ar, "No hardware memory");
>>>>                  return -ENOMEM;
>>>> +       }
>>>>
>>>>          for (i = 0; i < hw_mem->region_table.size; i++) {
>>>>                  tmp = &hw_mem->region_table.regions[i];
>>>> @@ -2702,8 +2704,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
>>>>                  }
>>>>          }
>>>>
>>>> -       if (!mem_region)
>>>> +       if (!mem_region) {
>>>> +               ath10k_warn(ar, "No memory region");
>>>>                  return -ENOMEM;
>>>> +       }
>>>>
>>>>          for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
>>>>                  if (ar->wmi.mem_chunks[i].req_id ==
>>>> @@ -2917,7 +2921,6 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
>>>>                  if (status) {
>>>>                          ath10k_warn(ar, "failed to copy target iram contents: %d",
>>>>                                      status);
>>>> -                       goto err_hif_stop;
>>>>                  }
>>>>          }
>>>>
>>>> --
>>>> 2.32.0
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
>
>

