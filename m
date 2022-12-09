Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EDE6488AD
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiLISz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLISz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:55:26 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E16812D3D
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 10:55:25 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id d123so2525123iof.6
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 10:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nGLoWITHjG06dcWceAaXk5qUvlOLPuCVd2rlF/bcbAw=;
        b=FWAKqX4FtKlJGM5SjqaLfsmcZdOUlOngtDCDewoJJ5A+BpZwk1oJFr1EedrmmLfjra
         W+BC3VnGr/6YSjFJM9kqGfqm1Sb2VRosMD9vG2ndl5VD26oJZKDLghl9QUY6KEUozUW6
         /thNyrvjYsWL/MyQT0PFmBhkXqzm1wmSKQxu0qebVO37BQlp2zwLV27qwAWV5Z7Wfx9w
         NNgJak1smVfvlAU1rHSNBOmK1GeaJbH/3AXrmZEybK4eXkvcLDD6q0NVGw0IKv1x4KbY
         Wl5rhYo+P5pVaua6Th0bUZbPB7yhjQkqdzDi+CzIQrqKG3rHnqDjG5Ofw7cmAKmidoYS
         pAuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nGLoWITHjG06dcWceAaXk5qUvlOLPuCVd2rlF/bcbAw=;
        b=w53Qog979KfGbUXJEue2wsa+GeFBonMR+wNcskqOM159d1Atl9JM3vyctC1bnPiG4e
         kxIerBOsNZNsTRMVcHM6IYfzvoKwxtuJEY42nRg27fUORVl77VKXjb9w5sVy0kdokMpx
         w3M39Txt3DEDorqIdvpWh+5hX+gV+2fDd6Bl1zT+dtp63Hbvz/CUK03xSlp0sdTnw4LC
         xuJhMsVV5a4kwtHR8uQuUYuAPZDnIavFmz6cxvRxX3xqLFT/j/siVOcJ8VtYFOCVsDr5
         Gn/Uk0UplzmjxCAG5C+uKGBuZIM717ZFuRVPknOoye8MZFt2MV8xiKRSMJDPi9IV9dDM
         sl2g==
X-Gm-Message-State: ANoB5pnEfCSmpNQxOQ2PMgmnubIYcd1Dh2lEK259ZNql1sbVdRgSyRAX
        UXjXj4Z04w+Og++zJgx/fBs=
X-Google-Smtp-Source: AA0mqf6/OeU6XiGNg8ei70CLvEztSz2eqE1zzP2cCh6MD7NOCAuuP+0d4NMcHwcxINAniH4a7qZ1Lg==
X-Received: by 2002:a6b:d80b:0:b0:6e2:c257:4493 with SMTP id y11-20020a6bd80b000000b006e2c2574493mr4272902iob.10.1670612124605;
        Fri, 09 Dec 2022 10:55:24 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:d973:620b:c569:ca01? ([2601:282:800:dc80:d973:620b:c569:ca01])
        by smtp.googlemail.com with ESMTPSA id l3-20020a0566022dc300b006c05ff4cd91sm913825iow.35.2022.12.09.10.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 10:55:24 -0800 (PST)
Message-ID: <f11a6a89-8fef-e67a-7d54-0058dee84b0b@gmail.com>
Date:   Fri, 9 Dec 2022 11:55:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: iproute2 - one line mode should be deprecated?
Content-Language: en-US
To:     Dave Taht <dave.taht@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20221209101318.2c1b1359@hermes.local>
 <CAA93jw56DJKuP+yVim4Hq8UJs9gMJgew_4czNNW+obL3WZ7puA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CAA93jw56DJKuP+yVim4Hq8UJs9gMJgew_4czNNW+obL3WZ7puA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/22 11:16 AM, Dave Taht wrote:
> I'm terribly old-fashioned myself and still use one-line mode, and the
> kinds of scripts I use still use awk. I may be the last one standing
> here...
> 

I use oneline a lot as well for a quick list of netdevs and network
addresses.

