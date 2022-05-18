Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9974B52C61C
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiERWR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiERWRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:17:23 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6889520AE45
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:17:20 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id pq9-20020a17090b3d8900b001df622bf81dso3420497pjb.3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to;
        bh=nzIyieH7MAvgBEfFhrngDq7+OdD6Mddu+OzEYaaAdQ8=;
        b=V+02dL3vvtVgWsul2ZC0abgK+rUc+3j0YniF6L0IcgF2XuQR2qzhDGLEVDpc220KH/
         gL9dz+rKf0OboNaGD29HRp3wvpXA4Cl25kCNVFTUkUVnwEHH/hTsRZdTA/EORHnH0qyJ
         ZHwNG59YEUZUJnMC3jDT5FgkuwfymWTuzky50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to;
        bh=nzIyieH7MAvgBEfFhrngDq7+OdD6Mddu+OzEYaaAdQ8=;
        b=mjYB696iMyooG0ZASZYk9p/JKGGh1WsXTG4yPJhWDjXH2JF+xmHZX9vXEEaULFz5KA
         afwpoqIQIWHivli9SFBZA4OcXb8NauKqrmeytXbmPrnV0HVC8ZeiIBpBwZXb8O1P4HIx
         zY13oIXIfVBhONdNflIyba0DzDqRdH8qqiz20pMKEn7/8Shzpc/J1kurMIxvDvc9mh4A
         y7fqfPHf8g7/MYHg15y0sHOAE/rpL8/8mDsf48ADCuuZ9jnEmO3DSLUDsAMkpaox1Roq
         pQ4fXhYtQwZSm3caDZTu5XpoyFD4zk8wECZOPGqrhA7M9GbsU1Kxo99sEd5de18e3SJM
         f+Kw==
X-Gm-Message-State: AOAM530qUWAUwPgA9kNyaeBw9MAITJeEI0YPG/eRQ6fyBBkg4pwhzVFE
        +9ZfswA1Qt2vOg1+XpfkMGQXBA==
X-Google-Smtp-Source: ABdhPJxkLsE36Kq2JcCUoiWV2ClSYG7H68DZOk0Dnd5ufVpjZfzcSk9Zz5AbXiW59SdIpTBHz/LAmw==
X-Received: by 2002:a17:902:ec92:b0:161:7e29:6f9d with SMTP id x18-20020a170902ec9200b001617e296f9dmr1458536plg.157.1652912238747;
        Wed, 18 May 2022 15:17:18 -0700 (PDT)
Received: from [10.136.13.180] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id ji15-20020a170903324f00b001616e13fccdsm2195161plb.221.2022.05.18.15.17.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 15:17:17 -0700 (PDT)
Message-ID: <81878a67-21f1-fee8-1add-f381bc8b05df@broadcom.com>
Date:   Wed, 18 May 2022 15:17:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 19/30] panic: Add the panic hypervisor notifier list
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Petr Mladek <pmladek@suse.com>,
        Sebastian Reichel <sre@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Desmond yan <desmond.yan@broadcom.com>
Cc:     David Gow <davidgow@google.com>, Evan Green <evgreen@chromium.org>,
        Julius Werner <jwerner@chromium.org>,
        bcm-kernel-feedback-list@broadcom.com, linux-pm@vger.kernel.org,
        akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Doug Berger <opendmb@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>,
        zhenwei pi <pizhenwei@bytedance.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-20-gpiccoli@igalia.com> <YoJZVZl/MH0KiE/J@alley>
 <ad082ce7-db50-13bb-3dbb-9b595dfa78be@igalia.com> <YoOpyW1+q+Z5as78@alley>
 <d72b9aab-675c-ac89-b73a-b1de4a0b722d@igalia.com>
From:   Scott Branden <scott.branden@broadcom.com>
In-Reply-To: <d72b9aab-675c-ac89-b73a-b1de4a0b722d@igalia.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000dffd7a05df509e67"
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000dffd7a05df509e67
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Guilherme,

+Desmond

On 2022-05-17 09:42, Guilherme G. Piccoli wrote:
> On 17/05/2022 10:57, Petr Mladek wrote:
>> [...]
>>>>> --- a/drivers/misc/bcm-vk/bcm_vk_dev.c
>>>>> +++ b/drivers/misc/bcm-vk/bcm_vk_dev.c
>>>>> @@ -1446,7 +1446,7 @@ static int bcm_vk_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>> [... snip ...]
>>>> It seems to reset some hardware or so. IMHO, it should go into the
>>>> pre-reboot list.
>>>
>>> Mixed feelings here, I'm looping Broadcom maintainers to comment.
>>> (CC Scott and Broadcom list)
>>>
>>> I'm afraid it breaks kdump if this device is not reset beforehand - it's
>>> a doorbell write, so not high risk I think...
>>>
>>> But in case the not-reset device can be probed normally in kdump kernel,
>>> then I'm fine in moving this to the reboot list! I don't have the HW to
>>> test myself.
>>
>> Good question. Well, it if has to be called before kdump then
>> even "hypervisor" list is a wrong place because is not always
>> called before kdump.
> 
> Agreed! I'll defer that to Scott and Broadcom folks to comment.
> If it's not strictly necessary, I'll happily move it to the reboot list.
> 
> If necessary, we could use the machine_crash_kexec() approach, but we'll
> fall into the case arm64 doesn't support it and I'm not sure if this
> device is available for arm - again a question for the maintainers.
We register to the panic notifier so that we can kill the VK card ASAP
to stop DMAing things over to the host side.  If it is not notified then
memory may not be frozen when kdump is occurring.
Notifying the card on panic is also needed to allow for any type of 
reset to occur.

So, the only thing preventing moving the notifier later is the chance
that memory is modified while kdump is occurring.  Or, if DMA is 
disabled before kdump already then this wouldn't be an issue and the 
notification to the card (to allow for clean resets) can be done later.
> 
> 
>>   [...]
>>>>> --- a/drivers/power/reset/ltc2952-poweroff.c
>>>>> +++ b/drivers/power/reset/ltc2952-poweroff.c
>>> [...]
>>> This is setting a variable only, and once it's set (data->kernel_panic
>>> is the bool's name), it just bails out the IRQ handler and a timer
>>> setting - this timer seems kinda tricky, so bailing out ASAP makes sense
>>> IMHO.
>>
>> IMHO, the timer informs the hardware that the system is still alive
>> in the middle of panic(). If the timer is not working then the
>> hardware (chip) will think that the system frozen in panic()
>> and will power off the system. See the comments in
>> drivers/power/reset/ltc2952-poweroff.c:
>> [.... snip ...]
>> IMHO, we really have to keep it alive until we reach the reboot stage.
>>
>> Another question is how it actually works when the interrupts are
>> disabled during panic() and the timer callbacks are not handled.
> 
> Agreed here! Guess I can move this one the reboot list, fine by me.
> Unless PM folks think otherwise.
> 
> 
>> [...]
>>> Disagree here, I'm CCing Florian for information.
>>>
>>> This notifier preserves RAM so it's *very interesting* if we have
>>> kmsg_dump() for example, but maybe might be also relevant in case kdump
>>> kernel is configured to store something in a persistent RAM (then,
>>> without this notifier, after kdump reboots the system data would be lost).
>>
>> I see. It is actually similar problem as with
>> drivers/firmware/google/gsmi.c.
>>
>> I does similar things like kmsg_dump() so it should be called in
>> the same location (after info notifier list and before kdump).
>>
>> A solution might be to put it at these notifiers at the very
>> end of the "info" list or make extra "dump" notifier list.
> 
> Here I still disagree. I've commented in the other response thread
> (about Google gsmi) about the semantics of the hypervisor list, but
> again: this list should contain callbacks that
> 
> (a) Should run early, _by default_ before a kdump;
> (b) Communicate with the firmware/hypervisor in a "low-risk" way;
> 
> Imagine a scenario where users configure kdump kernel to save something
> in a persistent form in DRAM - it'd be like a late pstore, in the next
> kernel. This callback enables that, it's meant to inform FW "hey, panic
> happened, please from now on don't clear the RAM in the next FW-reboot".
> I don't see a reason to postpone that - let's see if the maintainers
> have an opinion.
> 
> Cheers,
> 
> 
> Guilherme

--000000000000dffd7a05df509e67
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cRe0CRXA7ypOJSgxO/nOOyQoaJxT7CGg1npOeSpPjEuc3fE4xum3l0nvU85hj6MlKZu43hokdBh0
D0nLyyhEwlR3AC/msdff/UGbM/JR9vk812RP4m/aNWZFJwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRpzY290dC5icmFuZGVuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUOhjEpl04Sz9dh5MI82E1
V39lM/owDQYJKoZIhvcNAQELBQADggEBAA7Rlypx/esz/iq1yA4+KW7uwV/aBY344BWcXt6I+SNK
VwFBgFWfLj5vaEud9TVv2fPSiaHJo0umemOJk+43QD+bsoqmgcFXd21PrOt7Jjs+jjVED9VC5kJq
S4NNKUkS+BqijJwSegtVygrc/atrIlJbjI21q4qpemUo5fgwqCNm++BmBGTI8yA09vtGSNDRN42k
lLX9hl3iEj5SBgkQqCbbnoE+ZjjKfqt7ED166WhgyQWNrl39yLcvLj+JRUB3RuvXKZjH0NQEEBII
wZBDSkyneykLt3CBNIhSCTxKM6OWxVp936ALSa5K9FNy00TeWSpokR6NmzaW8VD/EjTgvqAxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgx9oXSJpKniO4dS
Gk8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIILFBbO32At0jlQYmvDlBzxxKfke
QfIJzMrdu2nIpFihMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
MDUxODIyMTcxOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBIc7nOZb/W3CkCvD0kf3LJMsgwBiUyTBcOQHeudvIMXgiB
QQ8+U0c03geY7pr3oC9UDTjRSIF1RwJcP3BwheBLJu7kfHK3jy1JiouqgOLb3cV+n/v8R/+Xc+Q9
MlWFHGJrAD9gPOMrvJ1KMqx0CFXaz0l8rlyXDGV6s+r8X1jt1rnbjZIGoBbGOP0+bObjxE+1Gdyd
bQJRFfYVGChsqzAPm+mOmOBOafJhgclqEhJSTDfXRiL12HGLyzWipIAmcAo0FrSMyjIkYTvnPG2n
n3uZVbKScFO51F6GoCOYWwE5SK0CHfHOWXk8TRl9CTBHlWCZR0XRAfCmijeVCq6/xT0J
--000000000000dffd7a05df509e67--
