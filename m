Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4314350058
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfFXDry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:47:54 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42443 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfFXDry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 23:47:54 -0400
Received: by mail-io1-f67.google.com with SMTP id u19so4616ior.9
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 20:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rFXnCsIYHh0xCcgX+Ak9Gg+Q4t3lxhKDfK2s/UDFSZI=;
        b=NLPXDboY/TzJH7eMTy292vUjsYxhR/Y/lK0l3sIsDnwTmYlZ59EEwAnzMIbx9we3qj
         0fkr3ynQB9ENDvX3fgjzYjyhLu3mxwNuhayNKjZBAAgotniVEECjmquID7zuT+SGwI5w
         DJ045RBmIRelEXsPCvHR99HS5RBfp67VVswDh+6esIFb1b5NBTLnEczo3M9yJpvfBH4N
         978V/MxA0iq9UQaBe8K2RJ3xhV0J7MICw+IElFP5at6r5vHZ2unoGZcrh+kZTvysXSot
         rKXmCfR0nVUpZkpHcfKSud1h56CWkrdmN67HM5Z/E61HEhy8j6n3rwSqbFS5A/X/2FTZ
         K/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rFXnCsIYHh0xCcgX+Ak9Gg+Q4t3lxhKDfK2s/UDFSZI=;
        b=jBfoBM90pLWM46RpSr9+aNKh0kixBJmAprvaIec45pE2yZVVCqJf1eEAx2KnATNzr0
         wuKtFtaYuLASMuG/I4x9GUMUn901DPxrxMQ7rv+zTKGmH11FCvQ9VivN+SBLUeAwpRdy
         sBdHF+LHb2tSojxnSmQNNDQK4z4ybYtBFBhl/v1hRPnOxFHW3qbGTZJwha2B0bGhbaNA
         tPtVNeF+xf76lpE+G3BDX+zf/K9bRMJiBma9LASK9vkyOnH9EJeqAfiroMbBMGaAw61g
         oFSjG0b08+thDERJNEsj8eYsyD9cWeHSCpaDfyxJ/ShMKb0gBLG2krJSPX6QBNcSN91v
         UMcg==
X-Gm-Message-State: APjAAAUszas6Ez60m5w26TtBdWNUoP0V3MtoX1f0JyDn+fCe4AcrErOt
        e5q36M3mYiMD0OOcbEaLofQ=
X-Google-Smtp-Source: APXvYqyJv3eVDM2GyyUT9dIu6Zz+yzIF+ahVs0c1FFAqvlbvDfbli3wLamUkP9uBtu/XvHLwtoj+TQ==
X-Received: by 2002:a5e:8a05:: with SMTP id d5mr14388805iok.147.1561348073450;
        Sun, 23 Jun 2019 20:47:53 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:6d83:2625:ad6c:635d? ([2601:282:800:fd80:6d83:2625:ad6c:635d])
        by smtp.googlemail.com with ESMTPSA id f20sm11344795ioh.17.2019.06.23.20.47.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 20:47:52 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] fix bugs when enable route_localnet
To:     David Miller <davem@davemloft.net>, liuzhiqiang26@huawei.com
Cc:     luoshijie1@huawei.com, tgraf@suug.ch, netdev@vger.kernel.org,
        wangxiaogang3@huawei.com, mingfangsen@huawei.com,
        zhoukang7@huawei.com
References: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
 <e52787a0-86fe-bf5f-28f4-3a29dd8ced7b@huawei.com>
 <20190622.084611.1808368522428755652.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bd5bda6c-8bb2-98ae-e020-f31eeeec9134@gmail.com>
Date:   Sun, 23 Jun 2019 21:47:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190622.084611.1808368522428755652.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/19 6:46 AM, David Miller wrote:
> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Date: Sat, 22 Jun 2019 16:41:49 +0800
> 
>> Friendly ping ...
> 
> I'm not applying this patch series without someone reviewing it.
> 

I have stared at it a few times since the patches were sent and can not
find anything obviously wrong about it. The fallout seems limited to
users of route_localnet which I have to believe is small (I only know of
2 other users of 127/8 for non-loopback and those were almost 10 years ago).

Putting in net-next is the safest.
