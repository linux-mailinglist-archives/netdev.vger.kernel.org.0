Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D514F3478E8
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 13:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhCXMxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 08:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhCXMxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 08:53:42 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDE2C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 05:53:42 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id y1so30033783ljm.10
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 05:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=MrHnRV2UMDJDYoFIjPPwMZMOEByizjQFjS1teKnfUz8=;
        b=m3mXZpHdGuIH7xRVwDldLYKjfMole7eQlL2CPEoxetxTkkBVaB6Gzt/Fg1Vpf8eQl/
         JEFr2BJ2Twbz77IUqR0e/0YvzIiPlu5hrM8dIsuiISFBerBnIwemnKluFJSLUmQCAVG3
         4dLWoJlubO97rT8V/Very/HrEhGhIoFkHL62LjurdtC1af1QGj0CwN46VlRPltef+3m8
         JnwJYwlA5APdoD2V83k7qOSWZmBa6o8eRXtb/c3iB8IgCSLcY+2AFMsZLuEXuYEIQb0/
         ndx0omEkj/so5iEov1nUhks3mgP5ozwux+d3Wq9GjxxwPgKYCUgBoWYDaW+ODF7araAL
         ujuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MrHnRV2UMDJDYoFIjPPwMZMOEByizjQFjS1teKnfUz8=;
        b=AQ1c8qV0zuo0yKIFJ5paMD31Oba7w8Ajo1O4Es95K0CV/1IYI3fcJiJx8zk8q9wQgR
         VSuMhZ/Epr5BplB/zjIXjacR15XdmDqLsTNVAxj9v4nvf00RqNl+7HjLIbIKEvYG45fa
         BEGq/dceY+bCJ2t1KVBuDjicr18MgcqmM5niiy+rtTfCAAmDjEDGA6ERX540Hjb7IXsn
         X+akMKF2du1cWxhv9VBs2e2q5l1Z2l3uE7ZtxoTsPD8/hGYIPFiPyx9kAcf5PWitNXb7
         AtaLpSJ95a2WoJePA7I+NDdFDMBX2C9KI1PlvXpE0tMOUqbmjtbyMQTFnbx3gM4cx8W7
         hKPA==
X-Gm-Message-State: AOAM530sf1wH+bk6f+QWxJVpa0piNmoAzveboUiEpN1vgosE0JTTpaFy
        LUBrsUbY18gciWYxs3l6KB6v5JAHOvpTcsxQ
X-Google-Smtp-Source: ABdhPJyYkglPnowvkXDrLSFWWag8pTm8FroSpMnSBKhirRWzO/xyUtBimwgA9B2KcJHGQs7vTMobdw==
X-Received: by 2002:a2e:7c14:: with SMTP id x20mr2128300ljc.146.1616590420667;
        Wed, 24 Mar 2021 05:53:40 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 192sm297889ljj.95.2021.03.24.05.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 05:53:40 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
In-Reply-To: <YFqLX+o2n2qRVW8M@lunn.ch>
References: <20210323102326.3677940-1-tobias@waldekranz.com> <YFnh4dEap/lGX4ix@lunn.ch> <87a6qulybz.fsf@waldekranz.com> <YFqLX+o2n2qRVW8M@lunn.ch>
Date:   Wed, 24 Mar 2021 13:53:39 +0100
Message-ID: <87v99glnl8.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 01:44, Andrew Lunn <andrew@lunn.ch> wrote:
>> This was my initial approach. It gets quite messy though. Since taggers
>> can be modules, there is no way of knowing if a supplied protocol name
>> is garbage ("asdf"), or just part of a module in an initrd that is not
>> loaded yet when you are probing the tree.
>
> Hi Tobias
>
> I don't think that is an issue. We currently lookup the tagger in
> dsa_port_parse_cpu(). If it does not exist, we return
> -EPROBE_DEFER. Either it eventually gets loaded, or the driver core
> gives up. I don't see why the same cannot be done for a DT
> property. If dsa_find_tagger_by_name() does not find the tagger return
> -EPROBE_DEFER. Garbage will result in the switch never loading, and
> the DT writer will go find their typo.
>
>> Even when the tagger is available, there is no way to verify if the
>> driver is compatible with it.
>
> I would of though, calling the switch drivers change_tag_protocol() op
> will that for you. If it comes back with -EINVAL, or -EOPNOTSUPP, you
> know it is not compatible.
>
> So i guess i would keep all the code you are adding here to allow
> dynamic setting of the protocol. And add more code in
> dsa_switch_parse_of() to parse the optional tagging protocol name,
> error out -EPROBE_DEFER if it is not known yet, otherwise store it
> away in something like dst->tag_ops_name. And then probably in
> dsa_switch_setup(), if dst->tag_ops_name is not NULL, invoke the
> dynamic change code to perform the actual change.

Sounds like a plan. I will try it out and get back with a v2. Thanks.
