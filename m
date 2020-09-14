Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5E12699E8
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgINXrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINXrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:47:16 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E18C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 16:47:16 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 7so960257pgm.11
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 16:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=+X1J8fyLIO3dMakPIu7Wymcmqd+kucZsQBZeNoexqV8=;
        b=4qXcTRt0UE3gNjkWhIjakTDriWOhoS+FV5k7a6cwrorjQ9HSukEukqkA6zkdpQJmd7
         Xp22WaWrVbwTxIgb5OGDsDE1HGa48QTHYQO3KB4P+ZOjGQpeYQF/WzWEZ7/YX5abUeFq
         h93pcCmb/3iajTSWPAm9NnBfSaE6lSx9M22wZ5UItP0oGdMDoDVNovyv4JlZo458rkGG
         aub6hKoCjE8zZGISD7HtXerTWI3sHuweGZByZmOrhAyBH/M0YSWjh5vCnUbF+rZo75/S
         T6D05OdJFXK+RBZzTrDBGkfrB96TroNlNRpWUIfpbSZMQ/NtGM2DWuu17b/0HPfKgFhX
         MeWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+X1J8fyLIO3dMakPIu7Wymcmqd+kucZsQBZeNoexqV8=;
        b=NItDgLxyDSt6Q4cF7HK67+l0QugJ5EzHazauEd+xyk2qjD9cuH9CS1frSIjpkDx5ED
         ErXhCgKpfotHEXAdo7kN/oXWvuxxxGU9qbwsRfB2O44o60z7VerP0rZdSPeZXi6tK2hm
         4ufcip40BUdqrQQODIICMOdWnncGGlVaJVKKDlCGYharTR8OTuj1+Z1507NPmQaUpczC
         CxTgrbuZ9arz9B8MdRfnyI59NHLYQ6vqJID/abOi9wqLURpWUWRHkqP7xVkuGumyCCMI
         Uj8Wgu9gIZ7MP6dFriLZl6WeyRVwdP21mOsuWZplpdYJr+RoJ96u7GJTkpLZdj6wvWta
         fnRg==
X-Gm-Message-State: AOAM533YCB+x8chPNokKcfC/Qf58HS5j41OL3aWip63r7qXAThHGuwbc
        wsnGxUF3EYkH/8+FIkz/7E4r7w==
X-Google-Smtp-Source: ABdhPJw5FpVibwkPNwaMXJlhoyxRUZ+qpcGgjLsgMdjbE0vM44PG4nE+zulFU9fwQgMGrZ/z6wFGHA==
X-Received: by 2002:aa7:9ae3:: with SMTP id y3mr15347676pfp.51.1600127235802;
        Mon, 14 Sep 2020 16:47:15 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id hk17sm9196439pjb.14.2020.09.14.16.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 16:47:15 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200908224812.63434-1-snelson@pensando.io>
 <20200908224812.63434-3-snelson@pensando.io>
 <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
 <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
 <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
 <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
 <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3b18d92f-3a0a-c0b0-1b46-ecfd4408038c@pensando.io>
Date:   Mon, 14 Sep 2020 16:47:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/20 4:36 PM, Jakub Kicinski wrote:
> On Mon, 14 Sep 2020 16:15:28 -0700 Jacob Keller wrote:
>> On 9/10/2020 10:56 AM, Jakub Kicinski wrote:
>>> IOW drop the component parameter from the normal helper, cause almost
>>> nobody uses that. The add a more full featured __ version, which would
>>> take the arg struct, the struct would include the timeout value.
>>>    
>> I would point out that the ice driver does use it to help indicate which
>> section of the flash is currently being updated.
>>
>> i.e.
>>
>> $ devlink dev flash pci/0000:af:00.0 file firmware.bin
>> Preparing to flash
>> [fw.mgmt] Erasing
>> [fw.mgmt] Erasing done
>> [fw.mgmt] Flashing 100%
>> [fw.mgmt] Flashing done 100%
>> [fw.undi] Erasing
>> [fw.undi] Erasing done
>> [fw.undi] Flashing 100%
>> [fw.undi] Flashing done 100%
>> [fw.netlist] Erasing
>> [fw.netlist] Erasing done
>> [fw.netlist] Flashing 100%
>> [fw.netlist] Flashing done 100%
>>
>> I'd like to keep that, as it helps tell which component is currently
>> being updated. If we drop this, then either I have to manually build
>> strings which include the component name, or we lose this information on
>> display.
> Thanks for pointing that out. My recollection was that ice and netdevsim
> were the only two users, so I thought those could use the full __*
> helper and pass an arg struct. But no strong feelings.

Thanks, both.

I'd been going back and forth all morning about whether a simple single 
timeout or a timeout for each "chunk" would be appropriate. I'll try to 
be back in another day or three with an RFC.

sln

