Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE3B15A3B0
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgBLIqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:46:32 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37168 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgBLIqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:46:31 -0500
Received: by mail-lf1-f67.google.com with SMTP id b15so1000497lfc.4
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 00:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NJqTMD1Mpok/K3wBMHyLjNE9yRCsny+AdoftJuRS9PE=;
        b=E7du2nfx4aEfz5UWNIDDpCcYDQm6Vcer5I4kbS1uOgpkO6KQ+3b2ZMI+xF2zzS7Wjw
         Nkw+1vhrFs+EFX+VVp9/NvKoFKncIh5Jq4jU0wV1GoZ94UDL/kdG+23GTxqE4W+mAJjc
         xztUpkGylYiHZUlA7aE2G5rTI8H6JaVT3pmyOF/toL3Evcdc2+d5awGyB0V7O90i2AGI
         ySD/WEQJdxPfIUNnjzNVVbeVZlEnj3uNRSxaLYvM+aMPD9y0jAyDcSrE445v9VTdaVTH
         9wtmqpR957ygkNUt5WZgb23euhLuz0JxOm3yulg4e0OctuKqpJLrKuTfCQ65ROUMkJv9
         TPaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NJqTMD1Mpok/K3wBMHyLjNE9yRCsny+AdoftJuRS9PE=;
        b=aIlc8gNB+RzIS3XFY3ZQJfyXcg3JxtDMMeVJeKfxOAtlqUD16bll4iQ/qun8euD2Xq
         WefKOF/D3FKD51dhlrnVUFg4+BHy1icgMVLrFLUnKHCSSDBSgAfE3mxlGYOJmAvjX6d8
         jSItGWn6bM3FRNY47/l0PU7N1B4m3EldjSf/ruH265nct10kCbIM58qmy5KB3Dt0V6g8
         wQdV+zvtEdSS2i+8icFj5etanKXsmfjEaPgotxM+qgg9s5JhBT0nUMEMTlRBwxOcJ8ms
         06OdQt4tSsDvHjyEN7jxcBekaiUbzNg/2/nHDlvCUp1dMpxAs5acN4JS05KgMwRQErrO
         bfXg==
X-Gm-Message-State: APjAAAUuYjfqMuz89GfEaVxloy1wFjUqCv/+xDuPRD4UG4mGU4qDZmnn
        fiQtv9nrx7K47Srx/5ZTBU0=
X-Google-Smtp-Source: APXvYqwB4zE4iqPnsn3SEs9/Cos+2WVJM6ooOm9RC8/NS/vBlygdNJfWY4x+DNAKi8UxUrcJabD+rw==
X-Received: by 2002:a05:6512:1cc:: with SMTP id f12mr6285471lfp.128.1581497189420;
        Wed, 12 Feb 2020 00:46:29 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id g21sm3513526ljj.53.2020.02.12.00.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 00:46:28 -0800 (PST)
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <a9360348-c6a0-bb2f-6424-281e041153cd@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <1a45bd7e-44ef-ccb8-9ca7-a3d68eb6c71d@gmail.com>
Date:   Wed, 12 Feb 2020 09:46:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <a9360348-c6a0-bb2f-6424-281e041153cd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.02.2020 08:59, Eric Dumazet wrote:
> On 2/11/20 11:37 PM, Rafał Miłecki wrote:
>> Hi, I need some help with my devices running out of memory. I've
>> debugging skills but I don't know net subsystem.
>>
>> I run Linux based OpenWrt distribution on home wireless devices (ARM
>> routers and access points with brcmfmac wireless driver). I noticed
>> that using wireless monitor mode interface results in my devices (128
>> MiB RAM) running out of memory in about 2 days. This is NOT a memory
>> leak as putting wireless down brings back all the memory.
>>
>> Interestingly this memory drain requires at least one of:
>> net.ipv6.conf.default.forwarding=1
>> net.ipv6.conf.all.forwarding=1
>> to be set. OpenWrt happens to use both by default.
>>
>> This regression was introduced by the commit 1666d49e1d41 ("mld: do
>> not remove mld souce list info when set link down") - first appeared
>> in 4.10 and then backported. This bug exists in 4.9.14 and 4.14.169.
>> Reverting that commit from 4.9.14 and 4.14.169 /fixes/ the problem.
>>
>> Can you look at possible cause/fix of this problem, please? Is there
>> anything I can test or is there more info I can provide?
>>
>> I'm not sure why this issue appears only when using monitor mode.
>> Using wireless __ap mode interface (with hostapd) won't expose this
>> issue. I guess it may be a matter of monitor interfaces not being
>> bridged?
>>
> 
> This commit had few fixes, are you sure they were applied to your kernel ?

Thanks for looking at this! Unfortunately I already have all listed
patches so it has to be yet another issue.


> 9c8bb163ae784be4f79ae504e78c862806087c54 igmp, mld: Fix memory leak in igmpv3/mld_del_delrec()

First included in v4.10-rc8, so it's present in my 4.14.169.


> 08d3ffcc0cfaba36f6b86fd568cc3bc773061fa6 multicast: do not restore deleted record source filter mode to new one
First included in v4.18-rc8, so it's present in my 4.14.169.


> a84d016479896b5526a2cc54784e6ffc41c9d6f6 mld: fix memory leak in mld_del_delrec()
Backported to linux-4.14.y as df9c0f8a15c283b3339ef636642d3769f8fbc434
and first included in v4.14.143, so it's present in my 4.14.169.
