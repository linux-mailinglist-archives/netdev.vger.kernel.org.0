Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775C61F703B
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgFKWbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:31:24 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:7612 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726288AbgFKWbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 18:31:23 -0400
X-Greylist: delayed 1805 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2020 18:31:22 EDT
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 05BLsWeq017078;
        Thu, 11 Jun 2020 22:59:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=Ou0AeyLxoFdNb92A9CF8UFK7uyT7UftWP0Y92ItCU3M=;
 b=gUjwKPXzKOyd/neEgobh/cyr8diMNLNiXh5Yjb6SdScbN/lzd/bDdQEsh0PqSYRdmq2Y
 ajOKnSZp22gyqdvvCFMgQpkLhYGT55R2bD8Ull82ZTuvaBhl23O4wA9JTQAIYDcurrE7
 JrGwdDfBh5dKWgH59yzb4OOhSsmGnvHczjIW9MBPNWHTHJ17cMZF+ILESZ7knLIQF+W2
 18umUFIUmr+8JqunM+12LF/k5T6486jbWs/gjSQ4smCOEcGp6EWmw1sYds69AhTtghDj
 BKBtKPL/0OyzV/BlRb9KZ6T6CcI21Zh3P9EpQ28BbpSbQ7NABOsDBsT7QqwBCW1cMzkH VA== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 31g2e3a9v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jun 2020 22:59:20 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 05BLp0f0015603;
        Thu, 11 Jun 2020 17:59:19 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint3.akamai.com with ESMTP id 31g6g098n8-1;
        Thu, 11 Jun 2020 17:59:19 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id BACBA60217;
        Thu, 11 Jun 2020 21:59:18 +0000 (GMT)
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
To:     jim.cromie@gmail.com, Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org
References: <20200609104604.1594-7-stanimir.varbanov@linaro.org>
 <20200609111414.GC780233@kroah.com>
 <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
 <20200610133717.GB1906670@kroah.com>
 <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
 <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
 <20200611062648.GA2529349@kroah.com>
 <bc92ee5948c3e71b8f1de1930336bbe162d00b34.camel@perches.com>
 <20200611105217.73xwkd2yczqotkyo@holly.lan>
 <ed7dd5b4-aace-7558-d012-fb16ce8c92d6@linaro.org>
 <20200611121817.narzkqf5x7cvl6hp@holly.lan>
 <CAJfuBxzE=A0vzsjNai_jU_16R_P0haYA-FHnjZcaHOR_3fy__A@mail.gmail.com>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <e65d2c81-6d0b-3c1e-582c-56d707c0d1f1@akamai.com>
Date:   Thu, 11 Jun 2020 17:59:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAJfuBxzE=A0vzsjNai_jU_16R_P0haYA-FHnjZcaHOR_3fy__A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-11_23:2020-06-11,2020-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006110167
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-11_23:2020-06-11,2020-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 cotscore=-2147483648 phishscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006110168
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/11/20 5:19 PM, jim.cromie@gmail.com wrote:
> trimmed..
> 
>>>> Currently I think there not enough "levels" to map something like
>>>> drm.debug to the new dyn dbg feature. I don't think it is intrinsic
>>>> but I couldn't find the bit of the code where the 5-bit level in struct
>>>> _ddebug is converted from a mask to a bit number and vice-versa.
>>>
>>> Here [1] is Joe's initial suggestion. But I decided that bitmask is a
>>> good start for the discussion.
>>>
>>> I guess we can add new member uint "level" in struct _ddebug so that we
>>> can cover more "levels" (types, groups).
>>
>> I don't think it is allocating only 5 bits that is the problem!
>>
>> The problem is that those 5 bits need not be encoded as a bitmask by
>> dyndbg, that can simply be the category code for the message. They only
>> need be converted into a mask when we compare them to the mask provided
>> by the user.
>>
>>
>> Daniel.
> 
> 
> heres what I have in mind.  whats described here is working.
> I'll send it out soon

Cool. thanks for working on this!

> 
> commit 20298ec88cc2ed64269c8be7b287a24e60a5347e
> Author: Jim Cromie <jim.cromie@gmail.com>
> Date:   Wed Jun 10 12:55:08 2020 -0600
> 
>     dyndbg: WIP towards module->debugflags based callsite controls
> 
>     There are *lots* of ad-hoc debug printing solutions in kernel,
>     this is a 1st attempt at providing a common mechanism for many of them.
> 
>     Basically, there are 2 styles of debug printing:
>     - levels, with increasing verbosity, 1-10 forex
>     - bits/flags, independently controlling separate groups of dprints
> 
>     This patch does bits/flags (with no distinction made yet between 2)


I think it might be nice to have this proposal to integrate level too
so we see how it fits in. Maybe level is just about we enable things?
So you still mark callsites with pr_debug_typed(), but we can eanble
them via something like, 'echo module foo level N +p  >
/proc/dynamic_debug/control'. And that and 'p' to all callsites <= N.
So anybody using pr_debug_typed() can use either style to enable/disable.


> 
>     API:
> 
>     - change pr_debug(...)  -->  pr_debug_typed(type_id=0, ...)
>     - all existing uses have type_id=0
>     - developer creates exclusive types of log messages with type_id>0
>       1, 2, 3 are disjoint groups, for example: hi, mid, low
> 
>     - !!type_id is just an additional callsite selection criterion
> 
>       Qfoo() { echo module foo $* >/proc/dynamic_debug/control }
>       Qfoo +p               # all groups, including default 0
>       Qfoo mflags 1 +p      # only group 1
>       Qfoo mflags 12 +p     # TBD[1]: groups 1 or 2

So I thought this meant select group twelve. Aren't there 32 groups?

>       Qfoo mflags 0 +p      # ignored atm TBD[2]
>       Qfoo mflags af +p     # TBD[3]: groups a or f (10 or 15)
> 
>     so patch does:
> 
>     - add u32 debugflags to struct module. Each bit is a separate print-class.
> 

what is this for again?

>     - add unsigned int mflags into struct ddebug_query
>       mflags matched in ddebug_change
> 
>     - add unsigned int type_id:5 to struct _ddebug
>       picks a single debugflag bit.  No subclass or multitype nonsense.
>       nice and dense, packs with other members.
>       we will have a lot of struct _ddebugs.
> 
>     - in ddebug_change()
>       filter on !! module->debugflags,
>       IFF query->module is given, and matches dt->mod_name
>       and query->mflags is given, and bitmatches module->debugflags
> 
>     - in parse_query()
>       accept new query term: mflags $arg
>       populate query->mflags
>       arg-type needs some attention, but basic plumbing is there
> 
>     WIP: not included:
> 
>     - pr_debug_typed( bitpos=0, ....)
>       aka: pr_debug_class() or pr_debug_id()
>       the bitpos is 1<<shift, allowing a single type. no ISA relations.
>       this covers OP's high,mid,low case, many others
> 
>     - no way to exersize new code in ddebug_change
>       need pr_debug_typed() to make a (not-null) typed callsite.
>       also no way to set module->debugflags
> 
>     Im relying on:
>     cdf6d00696 dynamic_debug: don't duplicate modname in ddebug_add_module
> 
>     which copies the ptr-val from module->name to dt->mod_name, which
>     allowed == tests instead of strcmp.
> 
>     That equivalence and a (void*) cast in use of container_of() seem to
>     do the trick to get the module, then module->debugflags.
> 
>     Notes:
> 
>     1- A query ANDs all its query terms together, so Qfoo() above
>     requires both "module foo" AND all additional query terms given in $*
> 
>     But since callsite type_id creates disjoint groups, "mflags 12" is
>     nonsense if it means groups 1 AND 2.  Here, 1 OR 2 is meaningful, if
>     its not judged to be too confusing.
> 
>     2- im not sure what this does atm, or should do
>        Qfoo mflags 0 +p      # select only untyped ? or no flags check at all ?

seems like it should group 0 which you're calling untyped. So you can write group
0 call sites as pr_debug(); or pr_debug_typed(0, ...); I'm not sure why we should
treat it differently other than it can be written without the pr_debug_typed().

> 
>     3- since modflags has 32 bits, [1-9a-v] could select any single type_id
>        it is succinct, but arcane.
>        its a crude alphanumeric map for developers to make flags mnemonic
>        maybe query keyword should be mbits
> 

Also wondering if the control file should display the type (if non-zero). I think
that would be nice.

Thanks,

-Jason
