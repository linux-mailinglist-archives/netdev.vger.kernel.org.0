Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2FE31B151
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 17:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBNQws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 11:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhBNQws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 11:52:48 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF82C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 08:52:09 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id i20so4040577otl.7
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 08:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mLWO/kFYrC3UC2ZI2wy36mu9HRBoElvIkVPYAVahQaw=;
        b=kputFFEPjj09gyCmL0H5TN7qWLlHyVkWCcyPQI3ZtkjB1MtvGU4kLdfDB51omfJTXv
         jFJMHpg4EmIMVcCQbAoHwK9udmZscluHlX5AuVnskmkbl02u2UXN23Vi9EmVDRLFSWhh
         bFJPO/xPrCzjSNDxUe29ZON6Ttvz914fLAjJzFDTXDAItTVDaKkGtB0UKzal8sW3vpLs
         IlqSLApVtnQyksnxVWEt3lv/PH6jw6K2UZu3fWyIvLLDtEpVstfJg4bwxejRBAZutZ5V
         +5cKktrOOefGkL6NqmuZAgIEy0uhLbTtdT1ZGvVeOUE6ZiE3wy6mc0XuaJpFBRqCT1j5
         vRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mLWO/kFYrC3UC2ZI2wy36mu9HRBoElvIkVPYAVahQaw=;
        b=SPGFF+p5a4CV6A1sXWUQhq27TdqCu7LkLgrktNtoRIOLsT2YXrXtcCzjH5xjFpbdcP
         1M6JSP8GiE2bNsutKDThiD+YmxSTgG7EaD2QwKCJWc58o7chmBd4gDvnTftydMxk40XC
         rDztFTO4RXyv5+8SAG3M0KfoH6B3tkuIpraffLZI73tfOE2p0rAAeJInnJ0C2cfIho32
         jEG8O71F0Pgi5Dx3K4C0IaJWc3AD/b/uw8D8inc5Y3TPUYHd+y1ls0d5pCNTIILlqM/a
         Yn1Dcn82s0hvWJVBO7kegmeVKA1TPA5oINTecm4wPuDzNMA3Y62ZIE2ADiCnHY13O8Jx
         ZUXw==
X-Gm-Message-State: AOAM533sAVCK6Njli01Eb3DuOSDZwaGOaJqauB33gIlgj8tbFzGwknoQ
        /8VyEomReuyu6oyMsGVVX8Y=
X-Google-Smtp-Source: ABdhPJzKmqoWBmfRQ2THheP1SV8K+C4QEkyEXINKitcOkrZwwWQSiKgoz+piEaqcJa36FLDgHL/vTA==
X-Received: by 2002:a05:6830:14c6:: with SMTP id t6mr8844767otq.4.1613321528440;
        Sun, 14 Feb 2021 08:52:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id i12sm3041674ots.17.2021.02.14.08.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 08:52:07 -0800 (PST)
Subject: Re: [PATCH net-next v2 0/7] mld: change context from atomic to
 sleepable
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <20210213175038.28171-1-ap420073@gmail.com>
 <3032e730-484f-d58d-8287-44e179c27ebb@gmail.com>
 <cdd58315-0550-fb80-c1fa-f1a913f6c9e7@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e99a3b55-1c7e-bda7-a098-1647cc902a53@gmail.com>
Date:   Sun, 14 Feb 2021 09:52:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <cdd58315-0550-fb80-c1fa-f1a913f6c9e7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/14/21 4:40 AM, Taehee Yoo wrote:
> 
> 
> On 21. 2. 14. 오전 4:58, David Ahern wrote:
>> your patches still show up as 8 individual emails.
>>
>> Did you use 'git send-email --thread --no-chain-reply-to' as Jakub
>> suggested? Please read the git-send-email man page for what the
>> options do.
>>
> 
> I sent all patches individually with these options.
> git send-email --thread --no-chain-reply-to 0000.patch
> git send-email --thread --no-chain-reply-to 0001.patch
> and so on.
> 
> So, it didn't work I think.
> Then I tested the below command and it works well.
> git send-email --thread --no-chain-reply-to 000*
> 

yes, you have to send all of the patches in 1 command.
