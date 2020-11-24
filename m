Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4222C321A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 21:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732006AbgKXUn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 15:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731289AbgKXUn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 15:43:59 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF27C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 12:43:59 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id m9so23363707iox.10
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 12:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=43n1EjMvyhJk8C7hWsQMMmW60j2jTaJ4SG2BQACMYAM=;
        b=pcQotWOkqufbdHnr0CXPoHqp23pr3CwONhcINeXptke/a2+TTHwUIpT6+mpvbGpmzx
         MIEGGNTOJ9VnXQr2QFzNsIMVPQhldS6+SGpO8fuuUQy7Y+726TSmtT48kUlVqeSVba9T
         HaN//PLUWe25qgLwCTHGbNwvWShPiYMtkeISsHSi5kGyYxPv+LFCE20qj4BDlKpHnEYV
         wKCWgus2ksK7ZmBuVJjfzYRDJf9w+wamhbyXE7hSwAwj5izzr1GG4xc/Jbi/Tw08OD/Z
         dBKGg5L1nYo2z4xlzzvtWXSW3pHDPAA+AD58KN1oG1uYHL9hjGRlwqYhbIX8NwXkTIEu
         UXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=43n1EjMvyhJk8C7hWsQMMmW60j2jTaJ4SG2BQACMYAM=;
        b=PQYGhIKlKJduG/QMu9XbgL2pvQU0Ze4ZMhKV4QvTgWv6mE792naYbM1plus1UaO7IV
         mqezHn/iDEcJkMGjMCF1cAeNRYxg0EVdlxPeoSPu/9nQRWgUJLZZ2zwgAQVQeIWklN+g
         DbYgi5ZO7t4BbMZPHnMntpwmVlKplPMuwzLgYZYbrFurI+piV7An6iMfaiJaNav2Wi1n
         tqPjCoc4Tq3gn/XpwooR6o+GCB6Vm1QMZD1jD4PjFfBFBleAYrnYgO3zuOFsTD4q2Hkg
         fMTwChA1h5jHbQaqAEmYWwAE3Xndg95t1WvSHKMB0T2GuqJb8Day5OXx8alhq0uevsxn
         14RQ==
X-Gm-Message-State: AOAM5307G4p9eaOxCouIjgN6n7z+O1krN7lGUndHtZKjZNv5QSbkGGAD
        UdE9O4ko+jQ+d28fC4dxbWAqAv6B5nE=
X-Google-Smtp-Source: ABdhPJyqs4KNZGiJ2Xr0xDnzdkbKvVcWRkbfvylGP/BkClXwJZIPNj+E9R+EQaELCzfpLklPHzez3g==
X-Received: by 2002:a05:6602:2dcf:: with SMTP id l15mr102698iow.120.1606250637353;
        Tue, 24 Nov 2020 12:43:57 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:b920:c7b8:6a02:a6c0])
        by smtp.googlemail.com with ESMTPSA id l4sm8174042ioj.41.2020.11.24.12.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 12:43:56 -0800 (PST)
Subject: Re: VRF NS for lladdr sent on the wrong interface
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20201124002345.GA42222@ubuntu>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6d0df155-ef2e-f3eb-46df-90d5083c0dc0@gmail.com>
Date:   Tue, 24 Nov 2020 13:43:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124002345.GA42222@ubuntu>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/20 5:23 PM, Stephen Suryaputra wrote:
> Hi,
> 
> I'm running into a problem with lladdr pinging all-host mcast all nodes
> addr. The ping intially works but after cycling the interface that
> receives the ping, the echo request packet causes a neigh solicitation
> being sent on a different interface.
> 
> To repro, I included the attached namespace scripts. This is the
> topology and an output of my test.

Can you run your test script on 4.14-4.17 kernel? I am wondering if the
changes in 4.19-next changed this behavior.


