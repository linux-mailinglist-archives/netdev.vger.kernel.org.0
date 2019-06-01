Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D883B31909
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 04:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfFAC3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:29:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44125 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfFAC3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:29:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id x3so1740143pff.11
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 19:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NFXFXEOkkjAIQSb45jSKulxMlLMM34uaBWjCATNHC+M=;
        b=eVL4xcMsM6BqqP5aoin6SP7Y04v3UA0VeCsXclwtX9CkVz9kXCq6BxUNuuhPgeaenL
         /QKo6n/w1BQDQMD7ffm5DZypmDrd6vDUDbpXturtFrEEiuiHlAFV/c2Xf+bYt+zLZaQs
         vDigi5ePkycooTqqqQ3Yc00UKfUWIJ6hnaPgGo8SZu0ca5ZBz52Fs3xL7RtuSoDKeq3G
         5rJ3VqQqQQsJLUDkQ2xuC9uHyMUOqso+Qk9PIpe3ev7F2ROPEGi/eTP7U2lO1tovQVkH
         AneysOWEKPf6qIPLd/oosXzs0yR7nQ/MjUfi7WvCc1b2AcToRuJNnxX1aVkvLwjtZ/4N
         VO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NFXFXEOkkjAIQSb45jSKulxMlLMM34uaBWjCATNHC+M=;
        b=AD8ELvnHXq1/0NBYPU/DbYvcDW96TkrFK8yrMNUEvnSoD5hLpBIT5WM2njWCwOG4fP
         PAAgDaCrfC1uc0xyMnxFsf7v4ZqFeTn+8n6tKxA4gWDoqI20EwIiW3T+bgTP0P2tgQlL
         N752Yhk5EmxV/B72m+LzI0xQ6SDRi+SscF0ch+J0uOMR0qfw7e6Qa6yi7VFx5xhahpi+
         5yLRlcD9u28VVhPbDGNRJbMSpzSzXOh0jfMmCCnIzV3WJmQ8ey7wdSakal0MNTqEFV1R
         q4XPEIVLUPY7iutlXjNzGWau+F5iSJdDoiJuoEIrZE5eX5oPMgE31yT+dW3SMECRPGmr
         vyBA==
X-Gm-Message-State: APjAAAVs0Ck+fKax05Z+WTgBKDpVuuMwOXpOC4sXP+rq0N/jzTwhMWLv
        eF0Qbsp66uwaVOxcLgpjbmCIOnGcgCA=
X-Google-Smtp-Source: APXvYqyrilSO+vMvJLaPwS6XQfz2d4+fTKwvtSUR5WWNiC/SaI+z11HObGqFGjwlByXkxeXoL+HHRw==
X-Received: by 2002:a17:90a:ac11:: with SMTP id o17mr4717971pjq.134.1559356148213;
        Fri, 31 May 2019 19:29:08 -0700 (PDT)
Received: from [172.27.227.252] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id t10sm8139109pgk.17.2019.05.31.19.29.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 19:29:07 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        alexei.starovoitov@gmail.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, kafai@fb.com, weiwan@google.com
References: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
 <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
 <20190531.142936.1364854584560958251.davem@davemloft.net>
 <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
 <68a9a65c-cd69-6cb8-6aab-4be470b039a8@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9f57c949-66b6-20d9-2cab-960074616e71@gmail.com>
Date:   Fri, 31 May 2019 20:29:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <68a9a65c-cd69-6cb8-6aab-4be470b039a8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 7:04 PM, Eric Dumazet wrote:
> 
> I have a bunch (about 15 ) of syzbot reports, probably caused to your latest patch series.
> 
> Do we want to stabilize first, or do you expect this new patch series to fix
> these issues ?
> 

Please forward. I will take a look.
