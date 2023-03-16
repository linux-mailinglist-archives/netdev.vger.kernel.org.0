Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F3D6BDA24
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCPU24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCPU2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:28:54 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B13F20555;
        Thu, 16 Mar 2023 13:28:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id DE37B60501;
        Thu, 16 Mar 2023 21:28:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1678998529; bh=ahEFVVhdg+LtRwVQf0dgtf/npUuwtlKdwtIwDCR5Vk4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=piIgxmLo2kvU5rj8gYAND6x2kY5XGbtyqGmDHTM5GtgNw+x8raHemruZDKJzDIOnW
         UEBThEyq7YGgz2KDYVD54xzkga6jCsOW1+bfJkFIMzAyjQ0kxuJSeKppU3YP49/QfZ
         S32juUZbrGfPcbsoz/94G9l4eayG+Nt5ckqPr0AqPDheytq/P/GlfT5AFQF1oiLCDN
         PlsvIXML8gcLEK6bPxHJjs/tmumvD5yTKCAojzpNUYC4imZNCykbLLzJRyZxNse3hN
         oC3cQeZLt+98jWxdyiKgn0TnOafGbaBrGvCRiru8z64jvXdNPTqa4b8Zwkkwgo7lsz
         u/Pex60FJShWA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vZz56q_HW_Mx; Thu, 16 Mar 2023 21:28:47 +0100 (CET)
Received: from [192.168.1.4] (unknown [77.237.109.125])
        by domac.alu.hr (Postfix) with ESMTPSA id 1FAC1604FE;
        Thu, 16 Mar 2023 21:28:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1678998527; bh=ahEFVVhdg+LtRwVQf0dgtf/npUuwtlKdwtIwDCR5Vk4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Vh2RaTiy/ONE5mWyhcOgcEwqN0X0ftYO4JO192uRSIufRzw+Fv0BQlezVh/Iv0r+7
         noEbpJCdfiwPELB8dCoOY5Z/v6mdiZO42/pzKLYeEL8KgoqWoqXU/jgvyREkEp6gel
         AYwfz2nVT2N8pncqG6LFpkNfU1N3l+09gj3VnsOYVVKcy44r5Ym04hsoqV18wFZIBf
         Jq7Xi19lQiQBcixslRY5NevCyryC1jjJeW/w5WuR9o1u1GCpQ6QwLsk1t4I5+GT2e1
         mRm2am6qT6e2VZH7cM7UvwgADUVUnPVsWKkQq83JZ9tx3vtGiTfPajBbzkQaV0XF4s
         N1LA/ijV2SJuA==
Message-ID: <5260feaa-1b0d-b398-b648-b10263145751@alu.unizg.hr>
Date:   Thu, 16 Mar 2023 21:28:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: BUG: selftest/net/tun: Hang in unregister_netdevice
To:     Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, shuah@kernel.org
References: <910f9616-fdcc-51bd-786d-8ecc9f4b5179@alu.unizg.hr>
 <20230315205639.38461-1-kuniyu@amazon.com>
 <CANn89iJDRG_CFWUz1GOSEi4YagCynZ-zhjq4POjbpyjkv9aawg@mail.gmail.com>
Content-Language: en-US, hr
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <CANn89iJDRG_CFWUz1GOSEi4YagCynZ-zhjq4POjbpyjkv9aawg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15. 03. 2023. 21:59, Eric Dumazet wrote:
> On Wed, Mar 15, 2023 at 1:57 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>>
>> However, we don't assume the delay and also the failure in
>> tun_set_real_num_queues().
>>
>> In this case, we have to re-initialise the queues without
>> touching kobjects.
>>
>> Eric,
>> Are you working on this?
>> If not, let me try fixing this :)
> 
> I am not working on this, please go ahead, thanks !

Hi,

It's me again. I just have new findings.

[root@pc-mtodorov linux_torvalds]# grep -E '(KOBJECT|TRACKER)' /boot/config-6.3.0-rc2-00006-gfc89d7fb499b 
CONFIG_REF_TRACKER=y
CONFIG_NET_DEV_REFCNT_TRACKER=y
CONFIG_NET_NS_REFCNT_TRACKER=y
CONFIG_DEBUG_KOBJECT=y
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
# CONFIG_SAMPLE_KOBJECT is not set
# CONFIG_TEST_REF_TRACKER is not set
[root@pc-mtodorov linux_torvalds]# uname -rms
Linux 6.3.0-rc2-00006-gfc89d7fb499b x86_64
[root@pc-mtodorov linux_torvalds]# grep -E '(KOBJECT|TRACKER)' /boot/config-6.3.0-rc2-00006-gfc89d7fb499b 
CONFIG_REF_TRACKER=y
CONFIG_NET_DEV_REFCNT_TRACKER=y
CONFIG_NET_NS_REFCNT_TRACKER=y
CONFIG_DEBUG_KOBJECT=y
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
# CONFIG_SAMPLE_KOBJECT is not set
# CONFIG_TEST_REF_TRACKER is not set
[root@pc-mtodorov linux_torvalds]# tools/testing/selftests/net/tun
TAP version 13
1..5
# Starting 5 tests from 1 test cases.
#  RUN           tun.delete_detach_close ...
#            OK  tun.delete_detach_close
ok 1 tun.delete_detach_close
#  RUN           tun.detach_delete_close ...
#            OK  tun.detach_delete_close
ok 2 tun.detach_delete_close
#  RUN           tun.detach_close_delete ...
#            OK  tun.detach_close_delete
ok 3 tun.detach_close_delete
#  RUN           tun.reattach_delete_close ...
#            OK  tun.reattach_delete_close
ok 4 tun.reattach_delete_close
#  RUN           tun.reattach_close_delete ...
#            OK  tun.reattach_close_delete
ok 5 tun.reattach_close_delete
# PASSED: 5 / 5 tests passed.
# Totals: pass:5 fail:0 xfail:0 xpass:0 skip:0 error:0
[root@pc-mtodorov linux_torvalds]# 

My interpretation if you allow it is that the bug search can be narrowed to the code
that depends on CONFIG_DEBUG_KOBJECT_RELEASE=y.

Best regards,
Mirsad


CONFIG_DEBUG_KOBJECT=y alone doesn't seem to be sufficient to trigger the reference leak.

Hope this helps narrow down the search.

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

