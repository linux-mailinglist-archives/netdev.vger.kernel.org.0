Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C0F6B9A7D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjCNQBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjCNQBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:01:05 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210996B337;
        Tue, 14 Mar 2023 09:01:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 14959604F7;
        Tue, 14 Mar 2023 17:01:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1678809660; bh=JUO899XbhZktRUpiZFjSvUdGkb1mGeG/QXgEEoOoKZQ=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=HJM5fAPnbgUKa1x6XjKtsr3EAf9v1VcDxjox2yK6fMzUTDd/iFD5/T8wFT4pwIEVg
         tj3zBX77xi7RHHj81xGnc0b6YCPod+q6LtfxM+fZJAz3cSq0zl5zS9Kgm/Y/Hdm4Db
         8Gf9YsRF3L+MKtwLdHi1sZL+KqiKoeXM9P4cAwfqSgEOr7xf/R5l4+K1S8bqZeAN8e
         1duVpRZibyXnn88viBVkB/u8jAxAJrzCXlSkOAbHANgwpsAv6klAtwV2af8GBZgsOy
         2tXSBANCNfSGHWVm23Mt6Kv0KUNPw+ULIlo1Ji+0DFiI0oWBfxJLmW1fbmOSIkvqKx
         oWGR3Jl4ZobVA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xmo1QOXER_yU; Tue, 14 Mar 2023 17:00:55 +0100 (CET)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
        by domac.alu.hr (Postfix) with ESMTPSA id CF002604F0;
        Tue, 14 Mar 2023 17:00:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1678809655; bh=JUO899XbhZktRUpiZFjSvUdGkb1mGeG/QXgEEoOoKZQ=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=YAL5JRN/0c6yEFB6pUbT/oMihbQ87TghRuPrS3IUmB0z/Qxj91TqBppBWqGm8+5tq
         KAu59Qy/fi4F/L1aF0iP5imt657ZN+Pu945g9uWQUe+72MiDiMYK4RZz65DaEfBqsZ
         veWG5wLGz+9fHOmjOY2LpUdrch4xiKbW0F9rD8WkXOgIQOOJOVKFO3N+5T+cX4yE41
         2npRLw8mJl5Zj5hBunT4XFvCnGtQuhwvc379ModVC4+EANoRE2XYdSnSKFaivA3cUa
         LviEK+JktsLEdjijOHZS6ghyTaI3Nwo0X3w5VqzavDgFvGEvA8zTDortUBgTI+3OOX
         CEeNj1X1gFhUw==
Message-ID: <27769d34-521c-f0ef-b6c2-6bd452e4f9bf@alu.unizg.hr>
Date:   Tue, 14 Mar 2023 17:00:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: BUG: selftest/net/tun: Hang in unregister_netdevice
From:   Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <a0734a6b-9491-b43a-6dff-4d3498faee2e@alu.unizg.hr>
 <d7a64812-73db-feb2-e6d6-e1d8c09a6fed@alu.unizg.hr>
Content-Language: en-US, hr
In-Reply-To: <d7a64812-73db-feb2-e6d6-e1d8c09a6fed@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/23 14:52, Mirsad Todorovac wrote:
> On 3/14/23 12:45, Mirsad Todorovac wrote:
>> Hi, all!
>>
>> After running tools/testing/selftests/net/tun, there seems to be some kind of hang
>> in test "FAIL  tun.reattach_delete_close" or "FAIL  tun.reattach_close_delete".
>>
>> Two tests exit by timeout, but the processes left are unkillable, even with kill -9 PID:
>>
>> [root@pc-mtodorov linux_torvalds]# ps -ef | grep tun
>> root        1140       1  0 12:16 ?        00:00:00 /bin/bash /usr/sbin/ksmtuned
>> root        1333       1  0 12:16 ?        00:00:01 /usr/libexec/platform-python -Es /usr/sbin/tuned -l -P
>> root        3930    2309  0 12:20 pts/1    00:00:00 tools/testing/selftests/net/tun
>> root        3952    2309  0 12:21 pts/1    00:00:00 tools/testing/selftests/net/tun
>> root        4056    3765  0 12:25 pts/1    00:00:00 grep --color=auto tun
>> [root@pc-mtodorov linux_torvalds]# kill -9 3930 3952
>> [root@pc-mtodorov linux_torvalds]# ps -ef | grep tun
>> root        1140       1  0 12:16 ?        00:00:00 /bin/bash /usr/sbin/ksmtuned
>> root        1333       1  0 12:16 ?        00:00:01 /usr/libexec/platform-python -Es /usr/sbin/tuned -l -P
>> root        3930    2309  0 12:20 pts/1    00:00:00 tools/testing/selftests/net/tun
>> root        3952    2309  0 12:21 pts/1    00:00:00 tools/testing/selftests/net/tun
>> root        4060    3765  0 12:25 pts/1    00:00:00 grep --color=auto tun
>> [root@pc-mtodorov linux_torvalds]#
>>
>> The kernel seems to be stuck in some loop, and filling the log with the
>> following messages until reboot, where it is also waiting very long on the
>> situation to timeout, which apparently never happens.
>>
>> Mar 14 11:54:09 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
>> Mar 14 11:54:19 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
>> Mar 14 11:54:29 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
>> Mar 14 11:54:40 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
>> Mar 14 11:54:50 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
>>
>> The platform is kernel 6.3.0-rc2 on AlmaLinux 8.7 and a LENOVO_MT_10TX_BU_Lenovo_FM_V530S-07ICB
>> (lshw output attached).
>>
>> The .config is here:
>>
>> https://domac.alu.hr/~mtodorov/linux/selftests/net-tun/config-6.3.0-rc2-mg-andy-devres-00006-gfc89d7fb499b
>>
>> Basically, it is a vanilla Torvalds tree kernel with MGLRU, KMEMLEAK, and CONFIG_DEBUG_KOBJECT enabled.
>> And devres patch.
>>
>> Please find the strace of the net/tun run attached.
>>
>> I am available for additional diagnostics.
> 
> Hi, again!
> 
> I've been busy while waiting for reply, so I wondered how would a vanilla kernel
> go through the test, considering that I've been testing a number of patches
> lately.
> 
> I did a fresh git clone from repo and woa.
> 
> Surprisingly, the test with CONFIG_DEBUG_KOBJECT turned off passes:
> 
> [root@pc-mtodorov linux_torvalds]# tools/testing/selftests/net/tun
> TAP version 13
> 1..5
> # Starting 5 tests from 1 test cases.
> #  RUN           tun.delete_detach_close ...
> #            OK  tun.delete_detach_close
> ok 1 tun.delete_detach_close
> #  RUN           tun.detach_delete_close ...
> #            OK  tun.detach_delete_close
> ok 2 tun.detach_delete_close
> #  RUN           tun.detach_close_delete ...
> #            OK  tun.detach_close_delete
> ok 3 tun.detach_close_delete
> #  RUN           tun.reattach_delete_close ...
> #            OK  tun.reattach_delete_close
> ok 4 tun.reattach_delete_close
> #  RUN           tun.reattach_close_delete ...
> #            OK  tun.reattach_close_delete
> ok 5 tun.reattach_close_delete
> # PASSED: 5 / 5 tests passed.
> # Totals: pass:5 fail:0 xfail:0 xpass:0 skip:0 error:0
> [root@pc-mtodorov linux_torvalds]#
> 
> So, no hanging processes that cannot be killed now.
> 
> If you think it is worthy to explore the lockup that occurs when turning
> CONFIG_DEBUG_KOBJECT=y, I will rebuild once again with these turned on,
> to clear any doubts.

Confirmed.

With the sole difference of:

[marvin@pc-mtodorov linux_torvalds]$ grep KOBJECT /boot/config-6.3.0-rc2-vanilla-00006-gfc89d7fb499b
CONFIG_DEBUG_KOBJECT=y
CONFIG_DEBUG_KOBJECT_RELEASE=y
# CONFIG_SAMPLE_KOBJECT is not set
[marvin@pc-mtodorov linux_torvalds]$

we get again unkillable processes:

[root@pc-mtodorov linux_torvalds]# ps -ef | grep tun
root        1157       1  0 16:44 ?        00:00:00 /bin/bash /usr/sbin/ksmtuned
root        1331       1  0 16:44 ?        00:00:01 /usr/libexec/platform-python -Es /usr/sbin/tuned -l -P
root        3479    2315  0 16:45 pts/1    00:00:00 tools/testing/selftests/net/tun
root        3512    2315  0 16:45 pts/1    00:00:00 tools/testing/selftests/net/tun
root        4091    3364  0 16:49 pts/1    00:00:00 grep --color=auto tun
[root@pc-mtodorov linux_torvalds]# kill -9 3479 3512
[root@pc-mtodorov linux_torvalds]# ps -ef | grep tun
root        1157       1  0 16:44 ?        00:00:00 /bin/bash /usr/sbin/ksmtuned
root        1331       1  0 16:44 ?        00:00:01 /usr/libexec/platform-python -Es /usr/sbin/tuned -l -P
root        3479    2315  0 16:45 pts/1    00:00:00 tools/testing/selftests/net/tun
root        3512    2315  0 16:45 pts/1    00:00:00 tools/testing/selftests/net/tun
root        4095    3364  0 16:50 pts/1    00:00:00 grep --color=auto tun
[root@pc-mtodorov linux_torvalds]#

Possibly the kernel /proc/cmdline is also important:

[root@pc-mtodorov linux_torvalds]# cat /proc/cmdline
BOOT_IMAGE=(hd0,gpt5)/vmlinuz-6.3.0-rc2-vanilla-00006-gfc89d7fb499b root=/dev/mapper/almalinux_desktop--mtodorov-root ro 
crashkernel=auto resume=/dev/mapper/almalinux_desktop--mtodorov-swap rd.lvm.lv=almalinux_desktop-mtodorov/root 
rd.lvm.lv=almalinux_desktop-mtodorov/swap loglevel=7 i915.alpha_support=1 debug devres.log=1
[root@pc-mtodorov linux_torvalds]#

After a while, kernel message start looping:

  kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3

Message from syslogd@pc-mtodorov at Mar 14 16:57:15 ...
  kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3

Message from syslogd@pc-mtodorov at Mar 14 16:57:24 ...
  kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3

Message from syslogd@pc-mtodorov at Mar 14 16:57:26 ...
  kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3

This hangs processes until very late stage of shutdown.

I can confirm that CONFIG_DEBUG_{KOBJECT,KOBJECT_RELEASE}=y were the only changes
to .config in between builds.

Best regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
