Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEC8584BF
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 16:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0Oq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 10:46:56 -0400
Received: from uhil19pa11.eemsg.mail.mil ([214.24.21.84]:50882 "EHLO
        uhil19pa11.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0Oq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 10:46:56 -0400
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jun 2019 10:46:54 EDT
X-EEMSG-check-017: 423829992|UHIL19PA11_EEMSG_MP9.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by uhil19pa11.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 27 Jun 2019 14:35:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561646145; x=1593182145;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=wCjLS9SBMsaxCpBSG5kqdTihRrCzyiEPucIu7jv36QM=;
  b=ULXMlQhEgx3UWGYLj0/iRUUpA+5COR7fCSj7QZ+v9eynrR/6AYqmcpyG
   +wHr8QjjGf224uWnYvFHuv0cvYmZoTy2sRGKw1W37k5eTNdlB33fjjTjE
   83C2I4RjfDWMx1mH1IMB3laeYK3kNwqjaWKrIhqzDgbFUFwMFFlkIQARj
   rw4d3tezGC7Uqm67B6faNGttKHagO89hNUspGXY5glix9tEjiZJye35IJ
   RoX3Bx3MG2XayQH47eKke/OmocVYp50ZLIHE7GZtYb+3/PLQymZQaUxFr
   PSRusW1bybsZIJ4kgLx3/tkIoQiUONanbsURJY5wK1lJERoe16OtpPgXk
   w==;
X-IronPort-AV: E=Sophos;i="5.63,424,1557187200"; 
   d="scan'208";a="29501317"
IronPort-PHdr: =?us-ascii?q?9a23=3AzsFWLxEbuwGMA1kjE1qQWp1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ76ocq9bnLW6fgltlLVR4KTs6sC17OM9fmwEjNQqdbZ6TZeKcUKD0?=
 =?us-ascii?q?dEwewt3CUYSPafDkP6KPO4JwcbJ+9lEGFfwnegLEJOE9z/bVCB6le77DoVBw?=
 =?us-ascii?q?mtfVEtfre9FYHdldm42P6v8JPPfQpImCC9YbRvJxmqsAndrMYbjZZ8Jqor1x?=
 =?us-ascii?q?fEoXREduZVyGh1IV6fgwvw6t2/8ZJ+7ihcoe4t+9JFXa7nY6k2ULtUASg8PW?=
 =?us-ascii?q?so/sPrrx7DTQWO5nsYTGoblwdDDhbG4h/nQJr/qzP2ueVh1iaUO832Vq00Vi?=
 =?us-ascii?q?+576h3Uh/oiTwIOCA//WrKl8F/lqNboBampxxi347ZZZyeOfRicq/Be94RWH?=
 =?us-ascii?q?FMVdhNWSNfHoy8bpMPD+sfMuZes4n9vEYFoR+nCQWxGO/j1jpEi3n40q0g1+?=
 =?us-ascii?q?QqDB/I0gouEdkTtHjYtdv4OaMXXe2z0aLGzyjMb+lO1Dng9obIfBAvr/KCU7?=
 =?us-ascii?q?1+fsXey1UgGQzeg1WMqoHoJS+Z2vgDvmWZ6edrSOKhi3QgqwF0ujWh29sshZ?=
 =?us-ascii?q?fRhoIV1F/E8zhyzpswJdKiTE57ZcCrEZtNvCydLIt5X9giTnp0uCc61rIGuZ?=
 =?us-ascii?q?m7cDIMyJQ83RHTcfOHc4+W4h/6UuuaPDR2hGp9db6iiBu//lKsx+3hWsWuzl?=
 =?us-ascii?q?pHoTRJnsPRun0Lyhfd8NKISuFn8UekwTuP0gfT5fxaLk0sjqrbLoIhwqY3lp?=
 =?us-ascii?q?oOrUTPBi/2l1vyjK+Rbkgk5vKn6/7mYrX7vZ+QLZN0iwHiPaQuncyzG+I4PR?=
 =?us-ascii?q?QVX2eH4+i80bzj/UnhTLVLiP05jLXZvYjHKckUqaO1GQ9Y3ps55xqhADqqzs?=
 =?us-ascii?q?4UkWQfIFJAYh2HjozpO1/UIPD/CPeym0+snypwx/3dIr3gAonCLnjEkLv7e7?=
 =?us-ascii?q?Z98FRTxBA8zdBY+ZJYEqsBL+7rWk/tqNzYCQc0Mwipw+b7D9VwzZkRWWeVDa?=
 =?us-ascii?q?CFKqzSqV6I5v41LOmIfoMVvijyK+Q97f70kXA5gUMdfbWu3ZYPanC4G/NmI1?=
 =?us-ascii?q?+DYXrtmdcMCmEKsRA7TOP0iV2OSzlTZ2y9X6gk/DE0FJqmDZvfRoCqmLGB2D?=
 =?us-ascii?q?q7HoFRZm1dCVCDD23od4OaVPcIci6SJdVhkjMcX7i7V4AhzQ2utBP9y7d/K+?=
 =?us-ascii?q?rb4DEYtY7j1Ndr6ezTmgs99SZuD8uDz2GNU3p5nmwPRz8x06B/pVJyxk2f3q?=
 =?us-ascii?q?h/hvxSDcZT6O9RUgcmKZ7cyPR3C9TzWgLHY9eIR0+qQs64Dj4tU9Ix2d4OY1?=
 =?us-ascii?q?p9Gti5kBDD0DSlA6UPm7yIGpM06KTc0Gb1J8pnzHbGzqYhhUE8QsRTLW2mmr?=
 =?us-ascii?q?J/9w/LCo7NkkWZkbuqdKsF0C7O6miD12yOs19cUANrT6XFUm4QZlHModT6+E?=
 =?us-ascii?q?zCVbmuBqojMgdbzs6CMKRKYMXzjVpaXPfjJMjeY2Wplme0BBaIwK6MbYXzd2?=
 =?us-ascii?q?oHxCXdCVMJkx4c/XmYLwgyHCShrHzEDDxoC13vZ1ng8e5kqHO0VkU01R2Fb1?=
 =?us-ascii?q?V917qp/R4YneGTS/MU3rMKpighrzF0HE2m0tLMFdWPugphc79AYd8n/FhH0m?=
 =?us-ascii?q?fZvRRnPpO8N6BimkIecwNvskz00xV4FIpBntYrrH8w1wpyNbiX0ElGdzOG2p?=
 =?us-ascii?q?DwO6HXKm7s/B20ZK7W30vR0NeS+qsV9Ps4rFDjthmzFkU+63Vnz8VV03yE65?=
 =?us-ascii?q?XPDgoSXpL8X0Is+hh1oLHaZSY954fK2nF2Laa0tTrC0cozBOQ50hagY8tfMK?=
 =?us-ascii?q?ScGQ/0DcIaG9WhJ/I0m1WycBIEM/5d9LQuM8OlafSGwqirM/hknD68imRH+o?=
 =?us-ascii?q?992FqW9yVgUu7Iw4oFw/aA0wuFUzfzkkmuv9vsmYBZfjEdAHCzxjTjBI5Ufq?=
 =?us-ascii?q?dyZ5oECX+yI82rwdVzn4PiVGRe9F6iGVwG3NSkeRuVb1zywwJfz14XrmegmS?=
 =?us-ascii?q?q31TB0lS8mrraH1izU3+vibAYHOnJMRGR6iVfsII60j80VXUSxdAgmigeq5V?=
 =?us-ascii?q?vgx6hauKR+L3DfQUJPfyfrMmFiVrW/u6GcY85A9pwoqz9bUOeiblCATL7yvR?=
 =?us-ascii?q?8a3znkH2tEyzBoPw2t77z/kw0yrH+BK3NytmHaeIkkwQrD4/TVQPda1yIHWC?=
 =?us-ascii?q?B8zz/aGg74d/ug+NiP37LEqPq/TCr1VJhUazPq1quGvS625CttGxLpzN6pnd?=
 =?us-ascii?q?iyKhQ3yS/20ZFRUCzMqBvtKt3w27+SLfNsfk4uAkT1rcV9BNctwcMLmJgM1C?=
 =?us-ascii?q?1C1d2u9n0dnDK2aI4K1A=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2CpAwDH0hRd/wHyM5BlHQEBBQEHBQGBZ4FoBSqBOwEyK?=
 =?us-ascii?q?IQZknGBYggliVmRDwkBAQEBAQEBAQE0AQIBAYRAAoMAIzgTAQMBAQEEAQEBA?=
 =?us-ascii?q?QQBAWyKQ4I6KQGCZwEFIw8BBTYLEAsOCgICJgICVwYBDAYCAQGCXz+BdxSlf?=
 =?us-ascii?q?oEyhUeDL4FGgQwoikGBHhd4gQeBOAyCMS4+h06CWASLeYIym3sJghmCH5FQB?=
 =?us-ascii?q?huCK4sjihCMX0qZLSGBWCsIAhgIIQ87gmyCeI4pIwMwgQYBAY4kAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 27 Jun 2019 14:35:44 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5REZfVA011759;
        Thu, 27 Jun 2019 10:35:43 -0400
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
To:     Andy Lutomirski <luto@amacapital.net>,
        James Morris <jmorris@namei.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Matthew Garrett <matthewgarrett@google.com>,
        linux-security@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Matthew Garrett <mjg59@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Chun-Yi Lee <jlee@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-security-module@vger.kernel.org
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-25-matthewgarrett@google.com>
 <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com>
 <alpine.LRH.2.21.1906270621080.28132@namei.org>
 <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov>
Date:   Thu, 27 Jun 2019 10:35:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/19 8:57 PM, Andy Lutomirski wrote:
> 
> 
>> On Jun 26, 2019, at 1:22 PM, James Morris <jmorris@namei.org> wrote:
>>
>> [Adding the LSM mailing list: missed this patchset initially]
>>
>>> On Thu, 20 Jun 2019, Andy Lutomirski wrote:
>>>
>>> This patch exemplifies why I don't like this approach:
>>>
>>>> @@ -97,6 +97,7 @@ enum lockdown_reason {
>>>>         LOCKDOWN_INTEGRITY_MAX,
>>>>         LOCKDOWN_KCORE,
>>>>         LOCKDOWN_KPROBES,
>>>> +       LOCKDOWN_BPF,
>>>>         LOCKDOWN_CONFIDENTIALITY_MAX,
>>>
>>>> --- a/security/lockdown/lockdown.c
>>>> +++ b/security/lockdown/lockdown.c
>>>> @@ -33,6 +33,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>>>>         [LOCKDOWN_INTEGRITY_MAX] = "integrity",
>>>>         [LOCKDOWN_KCORE] = "/proc/kcore access",
>>>>         [LOCKDOWN_KPROBES] = "use of kprobes",
>>>> +       [LOCKDOWN_BPF] = "use of bpf",
>>>>         [LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>>>
>>> The text here says "use of bpf", but what this patch is *really* doing
>>> is locking down use of BPF to read kernel memory.  If the details
>>> change, then every LSM needs to get updated, and we risk breaking user
>>> policies that are based on LSMs that offer excessively fine
>>> granularity.
>>
>> Can you give an example of how the details might change?
>>
>>> I'd be more comfortable if the LSM only got to see "confidentiality"
>>> or "integrity".
>>
>> These are not sufficient for creating a useful policy for the SELinux
>> case.
>>
>>
> 
> I may have misunderstood, but I thought that SELinux mainly needed to allow certain privileged programs to bypass the policy.  Is there a real example of what SELinux wants to do that can’t be done in the simplified model?
> 
> The think that specifically makes me uneasy about exposing all of these precise actions to LSMs is that they will get exposed to userspace in a way that forces us to treat them as stable ABIs.

There are two scenarios where finer-grained distinctions make sense:

- Users may need to enable specific functionality that falls under the 
umbrella of "confidentiality" or "integrity" lockdown.  Finer-grained 
lockdown reasons free them from having to make an all-or-nothing choice 
between lost functionality or no lockdown at all. This can be supported 
directly by the lockdown module without any help from SELinux or other 
security modules; we just need the ability to specify these 
finer-grained lockdown levels via the boot parameters and securityfs nodes.

- Different processes/programs may need to use different sets of 
functionality restricted via lockdown confidentiality or integrity 
categories.  If we have to allow all-or-none for the set of 
interfaces/functionality covered by the generic confidentiality or 
integrity categories, then we'll end up having to choose between lost 
functionality or overprivileged processes, neither of which is optimal.

Is it truly the case that everything under the "confidentiality" 
category poses the same level of risk to kernel confidentiality, and 
similarly for everything under the "integrity" category?  If not, then 
being able to distinguish them definitely has benefit.

I'm still not clear though on how/if this will compose with or be 
overridden by other security modules.  We would need some means for 
another security module to take over lockdown decisions once it has 
initialized (including policy load), and to be able to access state that 
is currently private to the lockdown module, like the level.
