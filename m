Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6A82798D9
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 14:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgIZMhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 08:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZMhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 08:37:21 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA305C0613CE;
        Sat, 26 Sep 2020 05:37:20 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id t16so5249476edw.7;
        Sat, 26 Sep 2020 05:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UsD2oc+XQsKozUmXOuq/VQfKAHLA2ozlfJCrCJ6m2RU=;
        b=WO0xLM9/knOKumJ+ooHoRYFr3Mwnqofl343/vGHS95H+c/VgYp1iq1+jtEn2X0bixh
         lpQA1KzweVMRJhp697NxSCfjteZ3ALlwmoxyBBHvVkiJ76Hebpkx1jhu1pF/pEj9cOJA
         ItXP+cmaqCjLd/K97eq77bDg1JHm8ErRRusZ2p5EC05Nr3l/JQy6d/DgmCunJqjFVW98
         e3VUbUFc/upSiP4yrUuHjzsoxJRmeOnNDS8yxQDrj7HreuPAqF1FvUI5TP3G89R1m+jN
         5M6FSFdQ+G5Id6JvPkaDoOZt8rlh7kpHp1ArR1uhzcAxPPGiBRkDWauoj6OkxCcAqmhi
         lggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UsD2oc+XQsKozUmXOuq/VQfKAHLA2ozlfJCrCJ6m2RU=;
        b=K0StoXK11HarKkbIY37PkKfXQRAzSzAUETD+bmSj20uN230SJr4ZUWgfvhwToZ0yEL
         flwvIQBqB7J3ChZWml3o/Jxm6YrYB/uxRml19wHHlka6ut1I2OK7sSfZfjOtUWp/m2/D
         F0ZzrLBbnMVyZx1RFhcyx74XuF3ye/m0AyZF+1pcbUvcwraP0/+18OuU4gv7amTDF9J7
         aiHnXEciedRguoGq0NoHKA49yn2wf/blSrqHyJBtcTYVtximAG2nC6ae4nEeBjaWjDY4
         CSVeOQxim5GO9yPSjm+nlWHIZk7p0ytXK5k3hH31QCYMgtw/xgz1MyJqbKujUBAfMcCb
         5Smg==
X-Gm-Message-State: AOAM5321xvp1WR7ICr5No2q+IDzp+BzW1VVzVVBTi4yxxPGSCJ5nabaR
        /LAFrjOOWF74BOULRSZ0+rs=
X-Google-Smtp-Source: ABdhPJxVNThrYku1JriS7wvr6X88AU5LfKDMCxeSO02VOYMClWEea5i16ESkFkbKh7fQvhbjXiw9Ew==
X-Received: by 2002:a50:ef0c:: with SMTP id m12mr6280247eds.264.1601123839478;
        Sat, 26 Sep 2020 05:37:19 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id a26sm3970526ejk.66.2020.09.26.05.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 05:37:18 -0700 (PDT)
Date:   Sat, 26 Sep 2020 15:37:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, hongbo.wang@nxp.com
Subject: Re: [PATCH net-next v3 1/2] net: mscc: ocelot: Add support for tcam
Message-ID: <20200926123716.5n7mvvn4tmj2sdol@skbuf>
References: <1559287017-32397-1-git-send-email-horatiu.vultur@microchip.com>
 <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
 <CA+h21hprXnOYWExg7NxVZEX9Vjd=Y7o52ifKuAJqLwFuvDjaiw@mail.gmail.com>
 <20200423082948.t7sgq4ikrbm4cbnt@soft-dev3.microsemi.net>
 <20200924233949.lof7iduyfgjdxajv@skbuf>
 <20200926112002.i6zpwi26ong2hu4q@soft-dev3.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926112002.i6zpwi26ong2hu4q@soft-dev3.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Sat, Sep 26, 2020 at 01:20:02PM +0200, Horatiu Vultur wrote:
> To be honest, I don't remember precisely. I will need to setup a board
> and see exactly. But from what I remember:
> - according to this[1] in chapter 3.8.6, table 71. It says that the full
>   entry of IS2 is 384. And this 384 represent a full entry. In this row,
>   can be also sub entries like: half entry and quater entries. And each
>   entry has 2 bits that describes the entry type. So if you have 2 bits
>   for each possible entry then you have 8 bits describing each type. One
>   observation is even if you have a full entry each pair of 2 bits
>   describing the type needs to be set that is a full entry.

But if I have a single entry per row, I have a single Type-Group value,
so I only need to subtract 2, no?

>   Maybe if you have a look at Figure 30, it would be a little bit more
>   clear. Even there is a register called VCAP_TG_DAT that information
>   is storred internally in the VCAP_ENTRY_DAT.

See, this is what I don't understand. You're saying that the Type-Group
is stored as part of the entry inside the TCAM, even if you're accessing
it through a different set of cache registers? What else is stored in a
TCAM row sub-word? The key + mask + Type-Group are stored in the same
sub-word, I assume?

> - so having those in mind, then VCAP_IS2_ENTRY_WIDTH is the full entry
>   length - 8 bits. 384 - 8 = 376.

But there are 4 Type-Group (and therefore 4 entries per row) only if the
entries are for quarter keys, am I not correct? And the IS2 code
currently uses half keys. Does this variable need to be set differently
according to the key size?

> - then if I remember correctly then VCAP_CONST_ENTRY_WIDTH should be
>   384? or 12 if it is counting the words.

Yes, it is 384 and the VCAP core version is 0.

> Does it make sense or am I completly off?

So, in simple words, what is the physical significance of
(VCAP_CONST_ENTRY_WIDTH - VCAP_CONST_ENTRY_TG_WIDTH * VCAP_CONST_ENTRY_SWCNT)?
To my understanding, it means the size used by all key+mask entries
within a TCAM row (therefore without the length of Type-Group fields)
when that row contains 4 quarter keys. Divide this number by 2, you get
the length of the key, or the length of the mask, for a single sub-word,
BUT only assuming that quarter keys are used.
So, why does this value have any significance to a driver that is not
using quarter keys?

Am _I_ completely off? This is so confusing.

Thanks,
-Vladimir
