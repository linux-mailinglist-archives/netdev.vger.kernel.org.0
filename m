Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6913ADF18
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 16:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhFTOvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 10:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhFTOvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 10:51:33 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D19C061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:49:20 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so15021943oti.2
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YJbKMhaiLsLGWhXR6RrDop8J/vC4lrxLIz0FyapQUhM=;
        b=nOTuTyIMocsOjxwkLQjU817rcUSltpGgUnnpjHixAcK6hC0NLCdyjMMJN8gmsMVilt
         ep6B3D0JFq2+2QOVrbtrJx9yadrtZx6M1/u7BY4zpbSBRJ2WNJnJp4u8dAG1qSB93HYN
         PT/epDptjl7cMyZ0kYFUdkiNOaC5HTkuLpvQriQzoTICCwyL0rCm+55QLWn1o6fOMXwS
         vwF1IIrYc+l7xamX28wZJyN0h/x6bMgttJStfiDMeIpkT2o9r6S0Y8OFX+i8TXe29xXv
         SSNkeEJBamyGytOgGy+8IreYYU4kAibWEbVg5g4L44JdhftBzkzYjNhRCKk8/8GVa+Kr
         m7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YJbKMhaiLsLGWhXR6RrDop8J/vC4lrxLIz0FyapQUhM=;
        b=UB8DIXrgKxb69xYrHYxvOBYABAg4aV6a5qK5h49b8jEytvk+kbnGZDrHq+q0wJJEY3
         71srq96ntC7CRP2FzmfQVyVJMgVT3j2Odv0vSC2iaxaJYi2Z2ZL1ricPdj/kjGFoQenT
         B5rAr0KyJGvX307Pq12g9Yt4af7jwKKOvmSYvNoiwGh9q6jAHLejXzHdF2KLQ24tf+KX
         ecRNWNjwhPSkvLVEtO6aZs85he1e9zhiwbOwieeM5raRW0d3DQ9wamK9HOgpQpC5n/AK
         w4ZWth8ddysvyIDErVYkaBZA80KXAO+8KxSLn5yHHE4SscvpNn+xxA6triMFsn6Y4wpK
         sWWQ==
X-Gm-Message-State: AOAM53283GW/bUqw5d6KQGqzKdAVBauI7JKtAt/N3dJ1sr1bdbnybdtg
        4W6jbYZwJKrzcQTNMi1uchbtB1ALsxyPoR3E4ZU=
X-Google-Smtp-Source: ABdhPJx1BO7K3QlU3lzqZb+VtV6wbjKXX5rCK3qzPq6QxzLrtnFNBH7qiKZL9VHAJQQUayHiq/9uI0S+4z28zdVt1O4=
X-Received: by 2002:a9d:7748:: with SMTP id t8mr16642669otl.110.1624200559430;
 Sun, 20 Jun 2021 07:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-11-ryazanov.s.a@gmail.com>
 <badd96aa7c475819ed3b9ca48743e10e756b2820.camel@sipsolutions.net>
In-Reply-To: <badd96aa7c475819ed3b9ca48743e10e756b2820.camel@sipsolutions.net>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 20 Jun 2021 17:49:11 +0300
Message-ID: <CAHNKnsR3O1-x1_NossR+02bqg6QfJEo1VkkVMYPFZfnX3x3-xw@mail.gmail.com>
Subject: Re: [PATCH net-next 10/10] wwan: core: add WWAN common private data
 for netdev
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Johannes,

On Tue, Jun 15, 2021 at 10:31 AM Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2021-06-15 at 03:30 +0300, Sergey Ryazanov wrote:
>> The WWAN core not only multiplex the netdev configuration data, but
>> process it too, and needs some space to store its private data
>> associated with the netdev. Add a structure to keep common WWAN core
>> data. The structure will be stored inside the netdev private data before
>> WWAN driver private data and have a field to make it easier to access
>> the driver data. Also add a helper function that simplifies drivers
>> access to their data.
>>
>> At the moment we use the common WWAN private data to store the WWAN data
>> link (channel) id at the time the link is created, and report it back to
>> user using the .fill_info() RTNL callback. This should help the user to
>> be aware which network interface is binded to which WWAN device data
>
> Nit: "binded" -> "bound".

Oh. Will fix it in V2.

>> +static size_t wwan_rtnl_get_size(const struct net_device *dev)
>> +{
>> +     return
>> +             nla_total_size(4) +     /* IFLA_WWAN_LINK_ID */
>> +             0;
>> +}
>>
>
> Not sure I like that code style, but I guess I don't care much either :)

Yeah. I am not happy with that code style either. But this is the only
git-blame friendly style known to me that allows us to add new lines
without touching existing ones :(

-- 
Sergey
