Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884B94E80B9
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 13:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiCZMMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 08:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiCZMMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 08:12:35 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2ED62A00;
        Sat, 26 Mar 2022 05:10:58 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id bq24so1495272lfb.5;
        Sat, 26 Mar 2022 05:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Ll5knS5YA52Kc4SbaRYixAUy03BOBNgYGFoMKYNZTIg=;
        b=bIWm3xtJfUJmweXArCFB/6GKKm4CDtfED0ixkIKU9Vg0UNlwQmdC2lwTKeV0EYKCAg
         41ypveRNCpWi+SOlXU9zgvN1g1R7Wu8U0S1jTgZDiaQOAUDhcPmg3dxmG88sxZhHKlB1
         7Ze/HNL5FG7OHuNgI0oE02V1LC7oGI0eYwP17iMj/9JJ4p2Hm1smAsAp9oPqFcvEaWNl
         rKor25c60uk8vDm4uOkIyuRCpjV/Bpt8dye4motVtG595QXprTU+4zQ+lxzhp6cNMobP
         3kfZoS4wkoWTcaB6QFJequjpuT+24FpOK6cJ2mlKvOilndmvtC6a0aJN59S1IotvgDN0
         YT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ll5knS5YA52Kc4SbaRYixAUy03BOBNgYGFoMKYNZTIg=;
        b=WVvf9bMlVtITLqmJvaVGN3TQv1t6+Hmq8m2QTaDraFSiSaMjhCAu0RBjzbbDGv1eUH
         lPRN36AxQNjTAtuRka3yz4V4uj5p2584Pbu4SJqjik4LCBUa+WYOAkVKGwP/ifk3Z3on
         7wCBqezaF+EKyAI06ZAY0VT1q8WlxWgutEdjCIaZibSAvzGgenN5sX5KWigz2vRNor9Y
         0YfI0a3hD5ErdnKRvPIWqa1F8/VUKm1rmwF46ogIXRHZ7vCKqd0GhO7bk4MBMnQImq23
         GYRXN8/S1H8T5ZmVSPaUsS+eW/5hDc5Lo7xT16GcO2wOmo6YZkyozQd1MighZ+t7PlWQ
         8Cgw==
X-Gm-Message-State: AOAM533V7HvbfM5MXghJNdK12/8ZYC3oIAYGvQzJU/K/zX0x8d8pGEvt
        9gQoW88BnOErLzM3yjsw8C4=
X-Google-Smtp-Source: ABdhPJwj+mzvxH9OfMNHs/OW5zJhrbfF6E3JAuD0uNtIYYFvw/Dpa9LIUM+AedD1YYxDgVs9BW0YQg==
X-Received: by 2002:a05:6512:22cd:b0:44a:6d2c:8b9f with SMTP id g13-20020a05651222cd00b0044a6d2c8b9fmr7855962lfu.142.1648296656622;
        Sat, 26 Mar 2022 05:10:56 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.225.225])
        by smtp.gmail.com with ESMTPSA id b36-20020a0565120ba400b0044a245f918esm1041607lfv.232.2022.03.26.05.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 05:10:55 -0700 (PDT)
Message-ID: <f468c651-4bc7-75f2-e5e3-2b88aaf37cb2@gmail.com>
Date:   Sat, 26 Mar 2022 15:10:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] KMSAN: uninit-value in ax88179_led_setting
Content-Language: en-US
To:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        jgg@ziepe.ca, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com,
        syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        arnd@arndb.de
References: <CAAZOf27PHWxdZifZpQYfTHb3h=qk22jRc6-A2LvBkLTR6xNOKg@mail.gmail.com>
 <CAAZOf24Gux0bfS-QGgjcd93NpcpxeA5xU5n2k+EhhyphJo-Mmg@mail.gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAAZOf24Gux0bfS-QGgjcd93NpcpxeA5xU5n2k+EhhyphJo-Mmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 3/26/22 14:47, David Kahurani wrote:
> Same here. My apologies.
> 
> On Sat, Mar 26, 2022 at 2:28 PM David Kahurani <k.kahurani@gmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit: 85cfd6e539bd kmsan: core: delete kmsan_gup_pgd_range()
>> git tree: https://github.com/google/kmsan.git master
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12d6c53c700000
>> kernel config: https://syzkaller.appspot.com/x/.config?x=b9807dd5b044fd7a
>> dashboard link: https://syzkaller.appspot.com/bug?extid=d3dbdf31fbe9d8f5f311
>> compiler: clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
>>
>> Based off a previous patch to fix a similar issue.
>> -------------------------

Looks sane.

Can you, please, send it as proper patch with explanation in commit 
message and with a bit cutted log, since full ->probe() calltrace is not 
interesting :)




With regards,
Pavel Skripkin
