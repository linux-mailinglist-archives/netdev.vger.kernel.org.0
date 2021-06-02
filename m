Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9537F3989F6
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhFBMrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBMrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 08:47:52 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAEBC061574;
        Wed,  2 Jun 2021 05:45:53 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so1225904otu.6;
        Wed, 02 Jun 2021 05:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WVXpnpg85QY1n+XQbQwo5ampIxgrZeixQi2//ZteRcA=;
        b=kfQtdmfpIv+3c9Qbxo12VXBCRlc5f0AxnV8Y9Rr0Y9Wci7q0FR3tAcqOinrF0W57ya
         /wf8YiwTn25gWQANErDQ7K7lH/q9clxWyK7JTgqf0Mx3L+r1wVHlmXjN6ZTjCTukCqVm
         03sJ4DbeN1GwYla8CPlI248q7Y7ydnc1iChjL5FMOWWww4XPRPQNM9P2mN0VkDc05ZSu
         JSPQQHPfok/D08DJqmRRT23p8XHSeudXFe6JOFt6+1mzQ3TiYQPHhuGBhkRT3FC8eZGr
         pLth2IlW+RJ3EtDDHD7AAM85hR61s/LB1uCHpN4LMBqmrH4mPQtLMg9fIEK7S7Gvjp+P
         pLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WVXpnpg85QY1n+XQbQwo5ampIxgrZeixQi2//ZteRcA=;
        b=l601Hnz8+iAYbMGIt/L31qFmjnj8bzRTXPKXnARJw+waYEIA0iXBhlku47dnkvIRNK
         Gt3ba2nbq0wtaMgOzu2oaGbxmy4XRD/DHuiY0yqRO4fHGuZ7DlmcYRhF0uT8c3uqxvnm
         A7/z7+Gl7fgRwIY7K30XKY8kKhmtpyJbgzrR1LfjDzL46Kz2jirpI8WLiza8V/ZG3u90
         GZC4//kqsq2cMmY9Ix/SrNMffOiL5q1Uvom8zHoMkXErSOQAF1nig47T2kRnNb0tJFwK
         bVRnhd1EVR/EIkXBk97m6cWJLzTgpJnOTzPchzUoLO4et6pMmINpNyBnci1+leYd0FrM
         Pi+g==
X-Gm-Message-State: AOAM531hxnysm4KUHwyXtsbBKp2ns+/K8ppFDDBaqctTwMoV/5S0oq9d
        GDzzzOZ49w6IqdeUE1KQiXWyMXkU1IFdoamoiPrrPCmNq8E=
X-Google-Smtp-Source: ABdhPJwO0yC8co2oFUFXOIwYhqkhiXCm7Gf+8AGtoeMSCfLI1WcFL+xloe7R8Cg/NcqdY5iJnkk42pKHQ3bJw7AnlZA=
X-Received: by 2002:a9d:3e5:: with SMTP id f92mr3464476otf.181.1622637952761;
 Wed, 02 Jun 2021 05:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210601080538.71036-1-johannes@sipsolutions.net>
 <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
 <CAHNKnsRv3r=Y7fTR-kUNVXyqeKiugXwAmzryBPvwYpxgjgBeBA@mail.gmail.com> <15e467334b2162728de22d393860d7c01e26ea97.camel@sipsolutions.net>
In-Reply-To: <15e467334b2162728de22d393860d7c01e26ea97.camel@sipsolutions.net>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 2 Jun 2021 15:45:41 +0300
Message-ID: <CAHNKnsQh7ikP4MCB0LhjpdqkMTjWq2ByWG4wToaXgzteYjUQaQ@mail.gmail.com>
Subject: Re: [RFC 3/4] wwan: add interface creation support
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        m.chetan.kumar@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Johannes,

On Wed, Jun 2, 2021 at 10:38 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>> Wow, this is a perfect solution! I just could not help but praise this
>> proposal :)
>
> Heh.
>
>> When researching the latest WWAN device drivers and related
>> discussions, I began to assume that implementing the netdev management
>> API without the dummy (no-op) netdev is only possible using genetlink.
>> But this usage of a regular device specified by its name as a parent
>> for netdev creation is so natural and clear that I believe in RTNL
>> again.
>>
>> Let me place my 2 cents. Maybe the parent device attribute should be
>> made generic? E.g. call it IFLA_PARENT_DEV_NAME, with usage semantics
>> similar to the IFLA_LINK attribute for VLAN interfaces. The case when
>> a user needs to create a netdev on behalf of a regular device is not
>> WWAN specific, IMHO. So, other drivers could benefit from such
>> attribute too. To be honest, I can not recall any driver that could
>> immediately start using such attribute, but the situation with the
>> need for such attribute seems to be quite common.
>
> That's a good question/thought.
>
> I mean, in principle this is trivial, right? Just add a
> IFLA_PARENT_DEV_NAME like you say, and use it instead of
> IFLA_WWAN_DEV_NAME.
>
> It'd come out of tb[] instead of data[] and in this case would remove
> the need to add the additional data[] argument to rtnl_create_link() in
> my patch, since it's in tb[] then.

Yep, exactly.

> The only thing I'd be worried about is that different implementations
> use it for different meanings, but I guess that's not that big a deal?

The spectrum of sane use of the IFLA_PARENT_DEV_NAME attribute by
various subsystems and (or) drivers will be quite narrow. It should do
exactly what its name says - identify a parent device.

We can not handle the attribute in the common rtnetlink code since
rtnetlink does not know the HW configuration details. That is why
IFLA_PARENT_DEV_NAME should be handled by the RTNL ->newlink()
callback. But after all the processing, the device that is identified
by the IFLA_PARENT_DEV_NAME attribute should appear in the
netdev->dev.parent field with help of SET_NETDEV_DEV(). Eventually
RTNL will be able to fill IFLA_PARENT_DEV_NAME during the netdevs dump
on its own, taking data from netdev->dev.parent.

I assume that IFLA_PARENT_DEV_NAME could replace the IFLA_LINK
attribute usage in such drivers as MBIM and RMNET. But the best way to
evolve these drivers is to make them WWAN-subsystem-aware using the
WWAN interface configuration API from your proposal, IMHO.

-- 
Sergey
