Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909B62069F7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387974AbgFXCOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730898AbgFXCOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 22:14:33 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4333C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 19:14:31 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y2so498028ioy.3
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 19:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ln6jmHb6P2/um7MStjIOZ+1MO+YVQKOf+KBBOqTJ0Jw=;
        b=oRGvUhBsR2yuOhGODTZ+NS/FzmqBtJPGZwu5A5/C4mpguS8y+0o8Z3OMReRgG9IwLQ
         anHJnqomJbaorTYimntonTF13VlDErcrClibNj1wQBHFs6M6vbJZRWmtwonyi6iNkkOF
         K/gSmBAj+GDD86Sel7iNpUaE7Vpbmnhw3Zk6Hs4sNMoc4eu95abtMhGws6dOpRJttAUr
         Ah7aFr+IKsyNxYqjg1qkjxxK3AxKy8Ds0+2lo9EA8eJtG5Q8J4sZRuje2KpL2UYdY2Jv
         bGil0hn+crTjvzfv3co1CWpnlLAXDSypLIljExKV92H6kB87cIWNIvep4MgTRoD0F8Fx
         c4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ln6jmHb6P2/um7MStjIOZ+1MO+YVQKOf+KBBOqTJ0Jw=;
        b=Q1dccB4lwDQ9s6ZyfJYjDaADqJPRN7lxOR7HB3JyHaqIAGyWOtzwfGI16FAdrWQSzG
         VBX87IFxRwxVn6XKkbGKtVr40j8dGx/hhi91DZhYOBsw4O1hx/KDeEOZVjjjIIdOz0g1
         VZAQwMorvJCSNOVy15Dlhbp/0+27Ttok1DE/sw+mtCfApkKPWQ+pNMRt662BO1wxznZw
         618YnN5C3D1Tv2y52v7psfOMBM4T0ReuLqiYYd/1YxEm6dHHN/GjoW/214ytQvFJLSA/
         EJDio59XvsNS9Yi3jxp4kMx/xJvAj0diTJ9LgzijQdPKWg5d0OWJUw5E+YCGSaLOaZb2
         yayw==
X-Gm-Message-State: AOAM533rSh1ore9JFzYPiNN3I26K+wpB2kSsdoJRXHesXE2K77HbotMR
        HofN1BpMqg7KkhXtbqpsvSMbySFu
X-Google-Smtp-Source: ABdhPJxs/p8WIIxdkc9oZlE7Yhp/o4QEZixv5bf/qXIV1yOlBNZErrtV4wHcHtCFuw/5iX2Tqp0akw==
X-Received: by 2002:a05:6638:a0a:: with SMTP id 10mr27152324jan.30.1592964870683;
        Tue, 23 Jun 2020 19:14:30 -0700 (PDT)
Received: from [10.254.22.15] ([138.68.32.133])
        by smtp.googlemail.com with ESMTPSA id y8sm3765798ilq.21.2020.06.23.19.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 19:14:30 -0700 (PDT)
Subject: Re: Multicast routing: wrong output interface selected unless VRF
 default route is added
To:     Ido Schimmel <idosch@idosch.org>,
        Qiwei Wen <wenqiweiabcd@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CADxRGxBfaWWvtYJmEebdzSMkVk6-YTx+jff2bGwS+TXBUPM-LA@mail.gmail.com>
 <20200623183835.GA69452@shredder>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <891caeb6-9c1f-d79d-caa6-23aba7e4d0c7@gmail.com>
Date:   Tue, 23 Jun 2020 19:14:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623183835.GA69452@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/20 11:38 AM, Ido Schimmel wrote:
>>
>> My questions are:
>> 1. is fib_lookup supposed to work with multicast daddr? If so, has
>> multicast routing been working for the wrong reason?

yes; it is a quirk with Linux routing. see the code after fib_lookup in
ip_route_output_key_hash_rcu. perf can show you the call chain that gets
to that lookup if you want the details.

>> 2. Why does the addition of a unicast default route affect multicast
>> routing behaviour?
> 
> I believe this was discussed in the past. See:
> https://lore.kernel.org/netdev/20200115191920.GA1490933@splinter/#t
> 

