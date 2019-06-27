Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B28F58B6F
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfF0UQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:16:49 -0400
Received: from uhil19pa14.eemsg.mail.mil ([214.24.21.87]:41177 "EHLO
        UHIL19PA14.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfF0UQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:16:49 -0400
X-EEMSG-check-017: 65213347|UHIL19PA14_EEMSG_MP12.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UHIL19PA14.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 27 Jun 2019 20:16:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1561666580; x=1593202580;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=8l9xC6P1/OJMbhl/jD7hRTBK7b0tMi/TO3xmshBDaTY=;
  b=mOmrrKGHwTQ/LzMWrJTbesWmg1Ym8z2E5F1WAjgy4prEby6boKIR+TBw
   RRuhUVZi0mz6tQcQhskEnlVAMKteasV7nXkuiXWgqxyDjb6+7nsOiJk3s
   I1r7ayRNkK2n2/T/dooQG5ufekyjZzpHpH5lmaqAB1/pP4cYuqZeGqV+s
   XtCYNFu4WBU3vLQBT3/bf2ugwNpnds2ezBx++JCjiqyzGyLiU2QxpH+5U
   CTRCcsuOMCPkYLD/P/4dEIgxJjTJasuSGoYrknhJEaAwnFuii17dTP4J2
   /J9hokqMO9LOQuWDi+FZ0bOcJJek/75Gqgh3kjD3Dp7oyzvcMuQo3uUUS
   A==;
X-IronPort-AV: E=Sophos;i="5.63,424,1557187200"; 
   d="scan'208";a="25207146"
IronPort-PHdr: =?us-ascii?q?9a23=3AK4i8pB93KXh13/9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B+1ekXIJqq85mqBkHD//Il1AaPAdyBrasUwLOK7uigATVGvc/Y9ihaMdRlbF?=
 =?us-ascii?q?wssY0uhQsuAcqIWwXQDcXBSGgEJvlET0Jv5HqhMEJYS47UblzWpWCuv3ZJQk?=
 =?us-ascii?q?2sfQV6Kf7oFYHMks+5y/69+4HJYwVPmTGxfa5+IA+5oAnMqMUam5ZuJ6U+xh?=
 =?us-ascii?q?fUrXZFe/ldyWd0KV6OhRrx6dq88IN5/yhMp/4t8tNLXLnncag/UbFWFiktPX?=
 =?us-ascii?q?ov5M3suxnDTA+P6WUZX24LjBdGABXL4Q/jUJvpvST0quRy2C+BPc3rVr80Qi?=
 =?us-ascii?q?it771qSBDzligKMSMy/XzNhcxxiKJbpw+hpwB6zoXJboyZKOZyc6XAdt4BW2?=
 =?us-ascii?q?FPQtheWDBAAoOkbosAEewBPfpDr4Lgo1cCtAayCRWwCO/qzDJHiGX23akn2O?=
 =?us-ascii?q?o/Fw/I0hErE9YXvHnUqNj5MaEfWv23wqbV1zXOd+5Y1ynz6IbIcR4vr/+DUr?=
 =?us-ascii?q?1yfsXNxkciDB/Fg1eKpID5Iz+Y2OYAvm6G5ORgT+KvjGsnphlsrDiz2Mgsko?=
 =?us-ascii?q?nJiZwTylvZ6Ct5xZw6Jdm8SEFlYd+vDZxdtzqHOIttWc4iX2Fptzo6yr0Bo5?=
 =?us-ascii?q?K7ejMKx449yx7QbPyHbZGF7xT+X+iSOTd1nG9pdb2wihqo8UWs1/fwWte73V?=
 =?us-ascii?q?pUtCZJj9/BvW0X2RPJ8MiIUP5981+k2TaIyg/c9PlJIVsxlarHM54hxaMwlo?=
 =?us-ascii?q?YLvUTDACD2nEL2gbeKdko+4Oio6vnnYq78qp+AN457lgH+MqM0lsy5Hes4KR?=
 =?us-ascii?q?QBU3Ke+eS90L3v5Uz5QLNUgf0qiqTVrZ/XKMsBqqO5HgNZyJgv5hmhAzu8zd?=
 =?us-ascii?q?gUhXwHI0hEeBKDgYjpIVbOIPXgAPeknlusiyxmx+zGP7L9ApXNKWLPkLH6fb?=
 =?us-ascii?q?ln8UJcxw0zzc5H65JOFr4BOO7zWlP2tNHADB85Ngu0w/z9CNV8zYMTQmSPDb?=
 =?us-ascii?q?WcMKzMsF+E/OUvI/ODZIUNojbyN+Al5+LyjX8+gVIdebSp3YcQaH2jBPtmJl?=
 =?us-ascii?q?+Wbmb2jdcZEGcKohAxTOjwhF2ETzFTe264X7gg6TEjFIKmEYDDS5ipgLycwC?=
 =?us-ascii?q?e7GYZbZmNYBVCWF3fnaYGEV+0LaCKILc9riiYEWqS5S489yRGusxf3y799Ie?=
 =?us-ascii?q?rI5i0YtYzs1dZ65+LJjxEy7yJ7D9iB02yWQGF0mWQIRzAy3K9hu0By1lCD0a?=
 =?us-ascii?q?1gifxCCdNT/+9JUhs9NZPEy+x6CtbyWh/Of9uQU1apXMmpASwrTtIw398PY1?=
 =?us-ascii?q?1wG8utjh/dxSqmGbwVmKKRBJwy7K3c22L9J8Fny3bJzKMhlUUpQtNTNW26ga?=
 =?us-ascii?q?5y7wzTB4/Pk0WEmKembKcc0zDX9GeF02WOuFpVUBB/UarbR3ATfEjWosrj5k?=
 =?us-ascii?q?PEUbCuDa4rMgxbyc6NMqFKcMHmjU1aRPf/P9TTe2axm2a2BRaVybKAdZDle3?=
 =?us-ascii?q?0c3CjGFkgEnB4c/WycOQg9GCihuWTeAyJqFV71ZEPs6+Z+omuhTkAo1wGKc1?=
 =?us-ascii?q?Fh172t9xEIhfycTP0S0awAuCclsDV5B0y90MzLBNqAvQVhYL9Qbs864FdCzW?=
 =?us-ascii?q?jZrRByPoS8L6B+gV4Tax54v0fw2BR4FIpAkNImrGg2zAVoM6KY101BdzSZ3Z?=
 =?us-ascii?q?DsPb3XNHL//B+qa6HM21He1Mya9bsI6PQ9s1/jph2mFlI+83V71NlYy36c5p?=
 =?us-ascii?q?fFDAcSVZ/8SUk39x99p7HVZiky+ZnY2mFrMamxqjXCwc4mBPM5yha8eNdSKK?=
 =?us-ascii?q?WEGxHuE8IHGceuNvcnm0ambh0aJuBe7q00MN28d/uAxqGrOPxsnDW8jWRI+I?=
 =?us-ascii?q?p9yF6D9zJgSu7U2JYI2/OY3g+ZWDjil1qhqd33mZtaaj0IAmW/zi3kDpZLZq?=
 =?us-ascii?q?JuZYYLFXuuI8qvy9pjnZHtXX9Y+0CnB14d2c+pfhWSYELn0g1KzksXpnOmlT?=
 =?us-ascii?q?G+zzNqjzEjtrCf0zDWw+T+aBoHPXZGRG1jjVfqPIi1gMkWXFO2YAc1iRul/0?=
 =?us-ascii?q?f6x7RbpahmKmnTRlpHfzXyL258SaawqLWCbNBV6J8ysiVYTv68YVaERb75uR?=
 =?us-ascii?q?ca1DnjH2QNjAw8IhOjv5ji1zl9knicNz4nrn/eY9tx3j/Z7dnRRLhWxDVQFw?=
 =?us-ascii?q?dijjyCPUSxJ9mk+52vkp7Htu2vHza6WoZ7bTjgzYTGsjCyo2JtH0vszLiIht?=
 =?us-ascii?q?T7HF1igmfA3N5wWHCN9Uutbw=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2DcAwB/IxVd/wHyM5BkHQEBBQEHBQGBZ4FtKoE7ATKEQ?=
 =?us-ascii?q?ZJxgWoliVmRDwkBAQEBAQEBAQE0AQIBAYRAAoMAIzgTAQMBAQEEAQEBAQQBA?=
 =?us-ascii?q?WyKQ4I6KQGCZwEFIxVBEAsOCgICJgICVwYNCAEBgl8/gXcUpnSBMoVHgzOBR?=
 =?us-ascii?q?oEMKIpBgR4XeIEHgREnDIIxLj6HToJYBI4rhieVVAmCGYIfiRqINgYbl16mV?=
 =?us-ascii?q?iGBWCsIAhgIIQ+DKIJ3jikjA4E2AQGOGQEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 27 Jun 2019 20:16:19 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5RKGHfr001562;
        Thu, 27 Jun 2019 16:16:17 -0400
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
To:     James Morris <jmorris@namei.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
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
 <bce70c8b-9efd-6362-d536-cfbbcf70b0b7@tycho.nsa.gov>
 <alpine.LRH.2.21.1906280332500.17363@namei.org>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <de8b15eb-ba6c-847a-7435-42742203d4a5@tycho.nsa.gov>
Date:   Thu, 27 Jun 2019 16:16:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.1906280332500.17363@namei.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/19 2:06 PM, James Morris wrote:
> On Thu, 27 Jun 2019, Stephen Smalley wrote:
> 
>> There are two scenarios where finer-grained distinctions make sense:
>>
>> - Users may need to enable specific functionality that falls under the
>> umbrella of "confidentiality" or "integrity" lockdown.  Finer-grained lockdown
>> reasons free them from having to make an all-or-nothing choice between lost
>> functionality or no lockdown at all.
> 
> Agreed. This will be used for more than just UEFI secure boot on desktops,
> e.g. embedded systems using verified boot, where finer grained policy will
> be needed for what are sometimes very specific use-cases (which may be
> also covered by other mitigations).
> 
>> This can be supported directly by the
>> lockdown module without any help from SELinux or other security modules; we
>> just need the ability to specify these finer-grained lockdown levels via the
>> boot parameters and securityfs nodes.
> 
> If the lockdown LSM implements fine grained policy (rather than the simple
> coarse grained policy), I'd suggest adding a new lockdown level of
> 'custom' which by default enables all hooks but allows selective
> disablement via params/sysfs.
> 
> This would be simpler than telling users to use a different lockdown LSM
> for this.
> 
>> - Different processes/programs may need to use different sets of functionality
>> restricted via lockdown confidentiality or integrity categories.  If we have
>> to allow all-or-none for the set of interfaces/functionality covered by the
>> generic confidentiality or integrity categories, then we'll end up having to
>> choose between lost functionality or overprivileged processes, neither of
>> which is optimal.
>>
>> Is it truly the case that everything under the "confidentiality" category
>> poses the same level of risk to kernel confidentiality, and similarly for
>> everything under the "integrity" category?  If not, then being able to
>> distinguish them definitely has benefit.
> 
> Good question. We can't know the answer to this unless we know how an
> attacker might leverage access.
> 
> The value here IMHO is more in allowing tradeoffs to be made by system
> designers vs. disabling lockdown entirely.
> 
>> I'm still not clear though on how/if this will compose with or be overridden
>> by other security modules.  We would need some means for another security
>> module to take over lockdown decisions once it has initialized (including
>> policy load), and to be able to access state that is currently private to the
>> lockdown module, like the level.
> 
> Why not utilize stacking (restrictively), similarly to capabilities?

That would only allow the LSM to further lock down the system above the 
lockdown level set at boot, not grant exemptions for specific 
functionality/interfaces required by the user or by a specific 
process/program. You'd have to boot with lockdown=none (or your 
lockdown=custom suggestion) in order for the LSM to allow anything 
covered by the integrity or confidentiality levels.  And then the kernel 
would be unprotected prior to full initialization of the LSM, including 
policy load.

It seems like one would want to be able to boot with lockdown=integrity 
to protect the kernel initially, then switch over to allowing the LSM to 
selectively override it.
