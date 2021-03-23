Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232D2346A74
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 21:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhCWUvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 16:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbhCWUug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 16:50:36 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37695C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 13:50:36 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 16so27406431ljc.11
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 13:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=BQg+UWe15oS+WO3ZurBaCfirVI9mrzGmp4/2Lh4PFc4=;
        b=Y50dOPNJ4cAEPAMY6Bt7YQNFMxwx2raesfWZvySFD1AhoV4EFXV6aPK1uaM79GiFcv
         r66Lrxgbd/MdiH7pK/EcreUUeNNeRQPacS1ItlPTC7lGRRlktI2bsjhJy9fOXcu3qrM7
         N9U/khPnas6FkiSwQWXHXG1ASyDZLRuAkggqyjh0E7jGKXmHLkkZtc2xT84rZMbXYJCh
         QlKZHvKKcAa8eRrCFSHXLTfLRpHZMbwSY7ZpaeBEKtvAIC5Ka/6xSKnFlYVN/UV+qzJo
         USdQ3PIw4QEigh+awTPfIX84wsMRNf5ufFBCH/NG/95LwU+UfsYgkUfSwMbCbNMiC+R/
         bGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BQg+UWe15oS+WO3ZurBaCfirVI9mrzGmp4/2Lh4PFc4=;
        b=lbE1jxXNgZo8Ro3SdFFtxONW2khJisAKM1YV196jmX5jgIbzmet3nE+oMyJrYlbka6
         e4pf3W0KWj1qfP0AqvDTTQHSErViMAya0tAJ/nqSArY4pEcMCwrTssC6SDBPdkn3X7xm
         pehhj4n6blzI0vuFaBItTdkm5MJP+tEj58z5KmeHYGX6anqPi4JwXYNHxP74p8J25O2H
         ZxMJpoGwJP2pykiygOHzBbFbZXmFQRu+ZW0anPneez98usFEd2gVMn1QjEM8xG63CYfH
         fQG1nrGsAeO5pDVH7HUtrH0U1hjK6udHf3iYdnXznjouSZrL/adASwARXTbTPRicVS9I
         0cRQ==
X-Gm-Message-State: AOAM530AUAyukaGNtegx6/Y/kkRWVxuGLwlnsGIlTJi5ti2y5U1S4/wf
        gYDZhdKoiDiePxtfudx900XTgUPZDtlkSoPu
X-Google-Smtp-Source: ABdhPJwFWcEhWJknk317rNTTk2B5atho232otPq9AfDSUB2ts7hvc4gGYz4FrqVcAW5LXDVJET7VUw==
X-Received: by 2002:a2e:7a11:: with SMTP id v17mr4342696ljc.403.1616532634388;
        Tue, 23 Mar 2021 13:50:34 -0700 (PDT)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id l7sm22030lje.30.2021.03.23.13.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 13:50:33 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
In-Reply-To: <7dd44f34-c972-2b4f-2e71-ec25541feb46@gmail.com>
References: <20210323102326.3677940-1-tobias@waldekranz.com> <YFnh4dEap/lGX4ix@lunn.ch> <87a6qulybz.fsf@waldekranz.com> <7dd44f34-c972-2b4f-2e71-ec25541feb46@gmail.com>
Date:   Tue, 23 Mar 2021 21:50:33 +0100
Message-ID: <875z1hmw6e.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 09:53, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 3/23/2021 7:49 AM, Tobias Waldekranz wrote:
>> On Tue, Mar 23, 2021 at 13:41, Andrew Lunn <andrew@lunn.ch> wrote:
>>> On Tue, Mar 23, 2021 at 11:23:26AM +0100, Tobias Waldekranz wrote:
>>>> All devices are capable of using regular DSA tags. Support for
>>>> Ethertyped DSA tags sort into three categories:
>>>>
>>>> 1. No support. Older chips fall into this category.
>>>>
>>>> 2. Full support. Datasheet explicitly supports configuring the CPU
>>>>    port to receive FORWARDs with a DSA tag.
>>>>
>>>> 3. Undocumented support. Datasheet lists the configuration from
>>>>    category 2 as "reserved for future use", but does empirically
>>>>    behave like a category 2 device.
>>>>
>>>> Because there are ethernet controllers that do not handle regular DSA
>>>> tags in all cases, it is sometimes preferable to rely on the
>>>> undocumented behavior, as the alternative is a very crippled
>>>> system. But, in those cases, make sure to log the fact that an
>>>> undocumented feature has been enabled.
>>>
>>> Hi Tobias
>>>
>>> I wonder if dynamic reconfiguration is the correct solution here. By
>>> default it will be wrong for this board, and you need user space to
>>> flip it.
>>>
>>> Maybe a DT property would be better. Extend dsa_switch_parse_of() to
>>> look for the optional property dsa,tag-protocol, a string containing
>>> the name of the tag ops to be used.
>> 
>> This was my initial approach. It gets quite messy though. Since taggers
>> can be modules, there is no way of knowing if a supplied protocol name
>> is garbage ("asdf"), or just part of a module in an initrd that is not
>> loaded yet when you are probing the tree. Even when the tagger is
>> available, there is no way to verify if the driver is compatible with
>> it. So I think we would have to:
>> 
>> - Keep the list of protcol names compiled in with the DSA module, such
>>   that "edsa" can be resolved to DSA_TAG_PROTO_EDSA without having the
>>   tagger module loaded.
>> 
>> - Add (yet) another op so that we can ask the driver if the given
>>   protocol is acceptable. Calling .change_tag_protocol will not work as
>>   drivers will assume that the driver's .setup has already executed
>>   before it is called.
>> 
>> - Have each driver check (during .setup?) if it should configure the
>>   device to use its preferred protocol or if the user has specified
>>   something else.
>> 
>> That felt like a lot to take on board just to solve a corner case like
>> this. I am happy to be told that there is a much easier way to do it, or
>> that the above would be acceptable if there isn't one.
>> 
>
> The other problem with specifying the tag within the Device Tree is that
> you are half way between providing a policy (which tag to use) and
> describing how the hardware works (which tag is actually supported).

Yeah it is a grey area for sure. Still, I think of it more as a hint
from the OEM. You could argue that the "label" property is policy, you
could also see it as a recommendation that will make the product easier
to use.

We can of course keep modifying drivers as incompatible ones are
discovered, hoping that we will never hit one that does not allow you to
disable the block responsible for dropping the frames.

I guess one argument for applying this change anyway is that it gives
you an easy way to test if your controller behaves better if all frames
are guaranteed to honor Ethernet II. Especially for users that might not
be comfortable with building their own kernels.

> FWIW, the b53/bcm_sf2 binding allows one to specify whether an internal
> port should have Broadcom tags enabled because the accelerator behind
> that port would require it (brcm,use-bcm-hdr).

