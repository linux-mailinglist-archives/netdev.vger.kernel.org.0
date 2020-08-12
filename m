Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB32224243F
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 05:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHLDWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 23:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgHLDWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 23:22:14 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABDEC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:22:13 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id j7so583839oij.9
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dY3KSE5aZaMnE4vkYvmn08NB3GzwbxaxyIEm6xdaovU=;
        b=DD1ALcRpB7nAWLxdflHJFRcy/tCW06lTpDp9kSI8RZR6n/wEeawBMPAEhUsZEh0YVw
         zvnPIG8IxaB+aWxzyDevkNRFle0ll8GGJLNmML8oimBj4sz9KpDJHAy5p7qcF4EcmqCL
         0lWLc9eiqZi2ixFDfbfnSf1A0z+KKAnTSjUSWn0tT35liAydHnfrcy6yaULFmf5bOdz0
         cnQo+3ChMnXJVxBYjLpic8EpPpHbfkV1uvA6Knb6pgnDISNziPXuIvjC/RSn0wTCniLu
         oqauo59mL6zm65ceUuSNBk/3rGq5/pVGUoGalJZ9BCiYKaP6x52Ll2Tn69eIQkjh7tF7
         T5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dY3KSE5aZaMnE4vkYvmn08NB3GzwbxaxyIEm6xdaovU=;
        b=T9Q0/NBBUmUnLiXJuaIrQbHsr5WgIqqgg8crSwF+YVCSXrfw9rk0kgXNvdmQDuFAnm
         PUjAh33/GS+coSXBLAIBvHR5IrWh48qH2qz2yfV5FRbX4Bh1yA0fx5sGn87f9rjkcX0Y
         Zl9MiOTWRNLwyjeosZrX3WBiY9GXs4wc/E1lmOjICS708LBlSWSK5pFUatBq/2+OQJgl
         lIBOR5IZgrw+v/O3WN9cA1B3c61OWoMK2sOsey0/5lkdBxCYkcaH8Iu10TdqINlwEkWw
         SvnLcP0aYVW0gLdP7bLMgO0TjR5Tq79+iJVKf79CgyS7cMTMZ0LU5MUa+ulUWhwBdeKW
         SHvA==
X-Gm-Message-State: AOAM530zA+D14RTPRbyXAyUcc4UfL5IWa6uufHmbCK4WBOuUNXf5ijWT
        v6BtGE3rJ4G8as+TgxtSzyo=
X-Google-Smtp-Source: ABdhPJyaexlJ6uvadohqDeG6FPlHqCH1x56oAvuKsRHCsqtH/CPfJfkfMnsFyYZmHazJCWfDKDtpRw==
X-Received: by 2002:a05:6808:8ef:: with SMTP id d15mr6007722oic.134.1597202533218;
        Tue, 11 Aug 2020 20:22:13 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:c1d8:5dca:975d:16e])
        by smtp.googlemail.com with ESMTPSA id h21sm219481oib.51.2020.08.11.20.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 20:22:12 -0700 (PDT)
Subject: Re: [PATCH net] net: accept an empty mask in
 /sys/class/net/*/queues/rx-*/rps_cpus
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alex Belits <abelits@marvell.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200812013440.851707-1-edumazet@google.com>
 <5b61d241-fedb-f694-c0a1-e46b0dedab66@gmail.com>
 <CANP3RGevbWwJ-oEmSjoC6wi1sUNtt6fqvE=sS8mTLnknNVMxJQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c75f6c00-47ce-4557-151d-f65609b5525c@gmail.com>
Date:   Tue, 11 Aug 2020 21:22:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANP3RGevbWwJ-oEmSjoC6wi1sUNtt6fqvE=sS8mTLnknNVMxJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/20 9:19 PM, Maciej Żenczykowski wrote:
> Before breakage, post fix:
> 
> sfp6:~# echo 0 > /sys/class/net/lo/queues/rx-0/rps_cpus
> 
> With breakage:
> lpk17:~# echo 0 > /sys/class/net/lo/queues/rx-0/rps_cpus
> -bash: echo: write error: Invalid argument
> 

ah, so this is recent breakage with 5.9. I had not hit before hence the
question. thanks for clarifying.
