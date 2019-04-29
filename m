Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C55E57C
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfD2Oxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:53:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36948 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbfD2Oxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:53:42 -0400
Received: by mail-wr1-f67.google.com with SMTP id r6so16512213wrm.4
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 07:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iUY+GZis0kVqIpm5gzW2+iff8GWFEez2sdQ170vbkkE=;
        b=FLqJeH1lhFjJk+cNuTi7NfAM0u0EjSpxiWkv26mpHVrEeIDXCukNPDDjVIPVcNT4D5
         XGpdsIbojsL+HjGDl4tw+elZEMF4PoRTN3PnS4xsaH0Z9t1mA5VeQe7aSAjlZbEsntTb
         tsEqJOC7r0Z+FpgYFAhIDAiBhvbERdX9ohsH/Rthgm1MH86gkmlqDo3Q0HyyZ2YejwDU
         fBWiz0YU5j2NOXc0dUROMn+qm8PJksU0OJLgtsyvEpaiZHnYjCR+TMa7aKwEdV4loSBZ
         MXr7fVGrawOk4/4uAo+PwQNDOktIZZ3zW4lBZZmFqlyKIFLhl/q8OAxLEQTj/WwAyz2I
         0ivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iUY+GZis0kVqIpm5gzW2+iff8GWFEez2sdQ170vbkkE=;
        b=FDc/TN4Fow6z25iVw0ftNIgcuZ+qwWWP1aeG/G4LZysMTrSuXMtf/uIeMj8xi23oXV
         4MReRGpVstUBQ1y4Tt0W3lcZAxI3NmzeAWIjtfE1G6fM2M+OMofK9sZffaYSSqEn/ZzR
         roobs87HYpqo+cUOUnwA5aqS7Ba9CMvSbC4tXsfxjLAmCpssMEzDJ2r0waWwTdmQL2gw
         zTDYpvEwDK+uY6sKCoHeTEN8t011EFaETp/PbNQoI8YxNjipViuz6K5Hq9Da/lr5NCWj
         OQMYHbwWMSBn2ZFojJQB0hJP8mZxC5K1gtvyEAsn8eE8lt5g6/ADXPHTiBL5T5EIaowZ
         hRKA==
X-Gm-Message-State: APjAAAWMQghoCWgi4qu2BOm4/whLuEbkhW4qKRpp2wLpWR1vLc1fk4N0
        ok1JklBiG70leNod2ft3rRW6WzJY/Zc=
X-Google-Smtp-Source: APXvYqzfkkLBvLSqX81B4QdtwrMMITitehPL6s3VkiH2eniKRcw13gHIMzTrFx0WkTxxMgCrJJootA==
X-Received: by 2002:adf:f78e:: with SMTP id q14mr12978238wrp.100.1556549619986;
        Mon, 29 Apr 2019 07:53:39 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:a94e:84d3:3ed8:cdcd? ([2a01:e35:8b63:dc30:a94e:84d3:3ed8:cdcd])
        by smtp.gmail.com with ESMTPSA id o15sm37048023wrj.59.2019.04.29.07.53.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 07:53:39 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on
 flush
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
 <09d0cd50-b64d-72c3-0aa1-82eb461bfa19@6wind.com>
 <20190426192529.yxzpunyenmk4yfk3@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <2dc9a105-930b-83b1-130f-891d941dc09b@6wind.com>
Date:   Mon, 29 Apr 2019 16:53:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426192529.yxzpunyenmk4yfk3@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/04/2019 à 21:25, Pablo Neira Ayuso a écrit :
> On Thu, Apr 25, 2019 at 05:41:45PM +0200, Nicolas Dichtel wrote:
>> Le 25/04/2019 à 12:07, Nicolas Dichtel a écrit :
>> [snip]
>>> In fact, the conntrack tool set by default the family to AF_INET and forbid to
>>> set the family to something else (the '-f' option is not allowed for the command
>>> 'flush').
>>
>> 'conntrack -D -f ipv6' will do the job, but this is still a regression.
> 
> You mean, before this patch, flush was ignoring the family, and after
> Kristian's patch, it forces you to use NFPROTO_UNSPEC to achieve the
> same thing, right?
> 
Before the patch, flush was ignoring the family, and after the patch, the flush
takes care of the family.
The conntrack tool has always set the family to AF_INET by default, thus, since
this patch, only ipv4 conntracks are flushed with 'conntrack -F':
https://git.netfilter.org/conntrack-tools/tree/src/conntrack.c#n2565
https://git.netfilter.org/conntrack-tools/tree/src/conntrack.c#n2796


Regards,
Nicolas
