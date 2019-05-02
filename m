Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FD71155F
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfEBI1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:27:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51300 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfEBI1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 04:27:22 -0400
Received: by mail-wm1-f66.google.com with SMTP id t76so1529087wmt.1
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 01:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ao3kEYMCUqHOzBLJovAegoGQgAW4TxYose+CKc7SEJw=;
        b=BJL4AQlwArrxgv9YY1yFtN3r/okhFFdh7EuoGwhhbOIvl+LU+42RCQc4h+MHyaMMjp
         xBfgiSjv/JJGO1iGThsPR6Zi3cEz8FF69lIrYYwGLe+8ZWAEG/NR5vsi6QYP0ICPjCDR
         S8FZj8ct7dwWWHTy7RatzocikW8fcasFLqLyxwmOovyXULb9+WXS4Yf4EHmwf7NtQq+e
         nrg0Y4HRwwruKZJ7FhDkUkR5OzteTXvYa85w4PKp7hkSTG2+fMp1Ldd1FK8SkO0DuE+D
         zFfzPMBUVPPiHOlmQH3gxpjYwXlgJUX+cyB/qwfBQfk1b0cd++mrL+rEYzdBIokwC7N6
         BQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ao3kEYMCUqHOzBLJovAegoGQgAW4TxYose+CKc7SEJw=;
        b=GtDqfzcdNraPT57QkpTs8qQtLqNqhEWTn7papi0OjRKMB582NSHF5g89857TyivATj
         s2ynK8yOlUZOADZtVWBIGW+pfs0DutMzVyql/iDuUVLdQQIv/3KlxITjWXWRumRWA6qb
         x72IMRuI4hku7NyC+DLDvQF6r/p2eq3pCEavnybjB/Pg9STpA0bKb5hFWrG+JgDmv0VU
         L1L8HQcPPSoQut2RKufC8b/6mLTtEGiJOJFhAQtOs+MXuu9fa+UEs3QtdrXIP7zgKLNN
         hFuAtse/cdHt1rUIwlokutWIc9sd/g3UM60qm/U8UZwmpns9X/C7UlCX6tvcdkkXHFtY
         vWyg==
X-Gm-Message-State: APjAAAUnpOHkE6Ka8DgB8RtX2AM3/VxRktOB0gYGiV1q9i3COKSJArcZ
        cKt+dNQKIn76pheJCTVWVCqm9u5EqJM=
X-Google-Smtp-Source: APXvYqyi+Pu/pZ/fRBYszac2eyuwuRB0aESCFCRNd20PX21fXOyR49jAo/D0ysYLfYXGA+bQbxloAA==
X-Received: by 2002:a7b:cb11:: with SMTP id u17mr1353408wmj.55.1556785639572;
        Thu, 02 May 2019 01:27:19 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:c51a:8579:612a:9e21? ([2a01:e35:8b63:dc30:c51a:8579:612a:9e21])
        by smtp.gmail.com with ESMTPSA id y7sm1216856wrg.45.2019.05.02.01.27.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 01:27:18 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on
 flush
To:     Florian Westphal <fw@strlen.de>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
 <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
 <51b7d27b-a67e-e3c6-c574-01f50a860a5c@6wind.com>
 <20190502074642.ph64t7uax73xuxeo@breakpoint.cc>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <a4f2df82-be23-ed46-79f5-749adc3c52c3@6wind.com>
Date:   Thu, 2 May 2019 10:27:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502074642.ph64t7uax73xuxeo@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 02/05/2019 à 09:46, Florian Westphal a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>> I understand your point, but this is a regression. Ignoring a field/attribute of
>> a netlink message is part of the uAPI. This field exists for more than a decade
>> (probably two), so you cannot just use it because nobody was using it. Just see
>> all discussions about strict validation of netlink messages.
>> Moreover, the conntrack tool exists also for ages and is an official tool.
> 
> FWIW I agree with Nicolas, we should restore old behaviour and flush
> everything when AF_INET is given.  We can add new netlink attr to
To avoid regression, we sould ignore it, AF_INET or not.

> restrict this.
Yes.
