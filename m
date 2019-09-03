Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC57A6DC0
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfICQQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:16:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54341 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbfICQQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 12:16:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id k2so112637wmj.4
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 09:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n+PT/ljKd90pClvM3jxWxKx7GDQ+a9uqR7P0TDJ8Ozc=;
        b=LuOz2fIyE+NoZIDgyr5PX+GllkuAYKXCoB+ZK+NsodemE0THaZn2BBIlUG7zLEgBlf
         DfF4FSBBbLo/plvEim1na00qpmUxTD9rLDAJVU+5KBPoaeBfAItdgRFDa0nfkr1hXWz5
         jY5ixDPCM8dZZxYv3tnGAN/nQbs0fEdKtMYpHIMPyY5uspPFrAcbjzesR+0CAwq/Ue5N
         qVkXaQNZGanGJnEU1WqZXGhCm2lLPolGOf/jeq723ZovFV359Y0AhaWYe0vuR93d/UgF
         d90nLktEHh+WNfv2vhwbLyKpHtWvyHGuSFQBGy1/ZADcTP3mWNOZSt63Ib3ZMeZc3Cet
         aiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n+PT/ljKd90pClvM3jxWxKx7GDQ+a9uqR7P0TDJ8Ozc=;
        b=R1OVVWkhsz9qPtXBntTHxtz+9pShstI0jqSXsQGFRkeCXohiFKzKtWHZv50tbyJj3J
         x2ImYhePmEFc3OjYMXOo6T1QWNA8d/CmSR5QAswOr1g8ep0PuTGbnlHB1juzvlAiZixH
         chLlz3ppQT5hftOIRNhXT8AmL7jDTkhRjQ19x89uNllIpSA4uVKypCwH2iF4M4P5ZTlD
         MLjVX87/bbHN4Fwra2S+wA1FkOQQ9F39VpbHmilhbueQDkR/YW3Hh+3v4RoxE9KQB6Sw
         aGDetflOkduALNi06IZIqqsFc/K5RZJKVcvDd8eGalot0qI8pEOoSxSgtcCvnqsTwf3e
         JO/g==
X-Gm-Message-State: APjAAAU1FWg5Jpe89p4AucQGx+P4OW2fVEuo5lCf04mpTU/4KxtEG7nf
        nCPQPKg3nhiZUBuXVCLLHsX3GeKg
X-Google-Smtp-Source: APXvYqz+rGPnriaCs7gj788p9+vae80S2uASplQZMrP5U79AyBFQonOjbz4l6ibk0lx2joMnU72q7A==
X-Received: by 2002:a1c:1aca:: with SMTP id a193mr111904wma.120.1567527372092;
        Tue, 03 Sep 2019 09:16:12 -0700 (PDT)
Received: from [192.168.8.147] (83.173.185.81.rev.sfr.net. [81.185.173.83])
        by smtp.gmail.com with ESMTPSA id d17sm27343040wre.27.2019.09.03.09.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 09:16:11 -0700 (PDT)
Subject: Re: [PATCH] Clock-independent TCP ISN generation
To:     Cyrus Sh <sirus.shahini@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     shiraz.saleem@intel.com, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, sirus@cs.utah.edu
References: <70c41960-6d14-3943-31ca-75598ad3d2d7@gmail.com>
 <fa0aadb3-9ada-fb08-6f32-450f5ac3a3e1@gmail.com>
 <bf10fbfb-a83f-a8d8-fefc-2a2fd1633ef8@gmail.com>
 <2cbd5a8f-f120-a7df-83a3-923f33ca0a10@gmail.com>
 <4ffba048-a46c-41da-ce67-e5dbac1de5a7@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <db9ad0f0-9aa8-4002-60e3-57124ef619ba@gmail.com>
Date:   Tue, 3 Sep 2019 18:16:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4ffba048-a46c-41da-ce67-e5dbac1de5a7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/19 6:12 PM, Cyrus Sh wrote:
> 
> 
> On 9/3/19 9:59 AM, Eric Dumazet wrote:
> 
>> You could add a random delay to all SYN packets, if you believe your host has clock skews.
> 
> And by the way adding delays has its own performance penalties.
> 


You understand your patch has been rejected, right ?

You will have to convince people at IETF and get a proper RFC before
I even look at the idea.

BTW, sending a patch only dealing with IPv4 is also not a good thing.
