Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044D4DAC9
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 05:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfD2D1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 23:27:07 -0400
Received: from anchovy3.45ru.net.au ([203.30.46.155]:49500 "EHLO
        anchovy3.45ru.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbfD2D1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 23:27:07 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Apr 2019 23:27:05 EDT
Received: (qmail 13446 invoked by uid 5089); 29 Apr 2019 03:20:24 -0000
Received: by simscan 1.2.0 ppid: 13358, pid: 13360, t: 0.1741s
         scanners: regex: 1.2.0 attach: 1.2.0 clamav: 0.88.3/m:40/d:1950
Received: from unknown (HELO ?192.168.0.122?) (preid@electromag.com.au@203.59.235.95)
  by anchovy2.45ru.net.au with ESMTPA; 29 Apr 2019 03:20:23 -0000
Subject: Re: Testing of r8169 workaround removal
To:     Neil MacLeod <neil@nmacleod.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d2f64f21-6a1d-00bd-ec30-51c31acdb177@gmail.com>
 <CAFbqK8kk8UqLXC=FPHjjYawHRozCmsKuV3WcD8x1y5HvYw_2rA@mail.gmail.com>
 <a7d1f3fc-2ab3-33dc-b0f8-146fdfb46a1d@gmail.com>
 <CAFbqK8n3vVuTfX+ZAi-TN70HtY75u3fBiM-h0USqPuk9K3=FZg@mail.gmail.com>
 <7dfaf793-1cb1-faef-d700-aa24ff4d50d9@gmail.com>
 <CAFbqK8m1kH-+KQG_ozWjSwM1Ti-UgpBys6sAo4j4k+PVPKnrAg@mail.gmail.com>
From:   Phil Reid <preid@electromag.com.au>
Message-ID: <e8b12136-3dc2-17e4-ccdf-f2fd2040ff7b@electromag.com.au>
Date:   Mon, 29 Apr 2019 11:20:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAFbqK8m1kH-+KQG_ozWjSwM1Ti-UgpBys6sAo4j4k+PVPKnrAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2019 6:05 am, Neil MacLeod wrote:
> Hi Heiner
> 
> 5.0.6 is the first kernel that does NOT require the workaround.
> 
> In 5.0.6 the only obvious r8169 change (to my untrained eyes) is:
> 
> https://github.com/torvalds/linux/commit/4951fc65d9153deded3d066ab371a61977c96e8a
> 
> but reverting this change in addition to the workaround makes no
> difference, the resulting kernel still resumes at 1000Mbps so I'm not
> sure what other change in .5.0.6 might be responsible for this changed
> behaviour. If you can think of anything I'll give it a try!
> 
> Regards
> Neil

The symptom sounds very similar to a problem I had with 1G link only linking at 10M.

Perhaps have a look at:
net: phy: don't clear BMCR in genphy_soft_reset

https://www.spinics.net/lists/netdev/msg559627.html

Which looks to have been added in 5.0.6
commit	fc8f36de77111bf925d19f347c21134542941a3c


> 
> PS. A while ago (5 Dec 2018 to be precise!) I emailed you about the
> ASPM issue which it looks like you may have fixed in 5.1-rc5[1].
> Unfortunately I don't have this issue myself, and I've been trying to
> get feedback from the bug reporter[2,3] "Matt Devo" without much
> success but will confirm to you if/when he replies.
> 
> 1, https://bugzilla.kernel.org/show_bug.cgi?id=202945
> 2. https://forum.kodi.tv/showthread.php?tid=298462&pid=2845944#pid2845944
> 3. https://forum.kodi.tv/showthread.php?tid=343069&pid=2850123#pid2850123
> 
> On Sun, 28 Apr 2019 at 19:43, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> Interesting, thanks for your efforts! I submitted the patch removing
>> the workaround because it seems now (at least since 5.1-rc1) we're fine.
>>
>> Heiner
>>
>> On 28.04.2019 20:40, Neil MacLeod wrote:
>>> Hi Heiner
>>>
>>> I'd already kicked off a 5.0.2 build without the workaround and I've
>>> tested that now, and it resumes at 10Mbps, so it may still be worth
>>> identifying the exact 5.0.y version when it was fixed just in case
>>> that provides some understanding of how it was fixed... I'll test the
>>> remaining kernels between 5.0.3 and 5.0.10 as that's not much extra
>>> work and let you know what I find!
>>>
>>> Regards
>>> Neil
>>>
>>> On Sun, 28 Apr 2019 at 18:39, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>
>>>> Hi Neil,
>>>>
>>>> thanks for reporting back. Interesting, then the root cause of the
>>>> issue seems to have been in a different corner. On my hardware
>>>> I'm not able to reproduce the issue. It's not that relevant with which
>>>> exact version the issue vanished. Based on your results I'll just
>>>> remove the workaround on net-next (adding your Tested-by).
>>>>
>>>> Heiner
>>>>
>>>>
>>>> On 28.04.2019 19:30, Neil MacLeod wrote:
>>>>> Hi Heiner
>>>>>
>>>>> Do you know if this is already fixed in 5.1-rc6 (Linus Torvalds tree),
>>>>> as in order to test your request I thought I would reproduce the issue
>>>>> with plain 5.1-rc6 with the workaround removed, however without the
>>>>> workaround 5.1-rc6 is resuming correctly at 1000Mbps.
>>>>>
>>>>> I went back to 4.19-rc4 (which we know is brroken) and I can reproduce
>>>>> the issue with the PC (Revo 3700) resuming at 10Mbps, but with 5.1-rc6
>>>>> I can no longer reproduce the issue when the workaround is removed.
>>>>>
>>>>> I also tested 5.0.10 without the workaround, and again 5.0.10 is
>>>>> resuming correctly at 1000Mbps.
>>>>>
>>>>> I finally tested 4.19.23 without the workaround (the last iteration of
>>>>> this kernel I published) and this does NOT resume correctly at
>>>>> 1000Mbps (it resumes at 10Mbps).
>>>>>
>>>>> I'll test a few more iterations of 5.0.y to see if I can identify when
>>>>> it was "fixed" but if you have any suggestions when it might have been
>>>>> fixed I can try to confirm this that - currently it's somewhere
>>>>> between 4.19.24 and 5.0.10!
>>>>>
>>>>> Regards
>>>>> Neil
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> On Sun, 28 Apr 2019 at 14:33, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>>>
>>>>>> Hi Neil,
>>>>>>
>>>>>> you once reported the original issue resulting in this workaround.
>>>>>> This workaround shouldn't be needed any longer, but I have no affected HW
>>>>>> to test on. Do you have the option to apply the patch below to latest
>>>>>> net-next and test link speed after resume from suspend?
>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>>>>>> That would be much appreciated.
>>>>>>
>>>>>> Heiner
>>>>>>
>>>>>> ----------------------------------------------------------------
>>>>>>
>>>>>> After 8c90b795e90f ("net: phy: improve genphy_soft_reset") this
>>>>>> workaround shouldn't be needed any longer. However I don't have
>>>>>> affected hardware so I can't test it.
>>>>>>
>>>>>> This was the bug report leading to the workaround:
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=201081
>>>>>>
>>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>>> ---
>>>>>>   drivers/net/ethernet/realtek/r8169.c | 8 --------
>>>>>>   1 file changed, 8 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
>>>>>> index 383242df0..d4ec08e37 100644
>>>>>> --- a/drivers/net/ethernet/realtek/r8169.c
>>>>>> +++ b/drivers/net/ethernet/realtek/r8169.c
>>>>>> @@ -4083,14 +4083,6 @@ static void rtl8169_init_phy(struct net_device *dev, struct rtl8169_private *tp)
>>>>>>          phy_speed_up(tp->phydev);
>>>>>>
>>>>>>          genphy_soft_reset(tp->phydev);
>>>>>> -
>>>>>> -       /* It was reported that several chips end up with 10MBit/Half on a
>>>>>> -        * 1GBit link after resuming from S3. For whatever reason the PHY on
>>>>>> -        * these chips doesn't properly start a renegotiation when soft-reset.
>>>>>> -        * Explicitly requesting a renegotiation fixes this.
>>>>>> -        */
>>>>>> -       if (tp->phydev->autoneg == AUTONEG_ENABLE)
>>>>>> -               phy_restart_aneg(tp->phydev);
>>>>>>   }
>>>>>>
>>>>>>   static void rtl_rar_set(struct rtl8169_private *tp, u8 *addr)
>>>>>> --
>>>>>> 2.21.0
>>>>>
>>>>
>>>
>>
> 
> 


-- 
Regards
Phil Reid

ElectroMagnetic Imaging Technology Pty Ltd
Development of Geophysical Instrumentation & Software
www.electromag.com.au

3 The Avenue, Midland WA 6056, AUSTRALIA
Ph: +61 8 9250 8100
Fax: +61 8 9250 7100
Email: preid@electromag.com.au
