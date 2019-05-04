Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD7213AD0
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 16:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfEDO7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 10:59:53 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35295 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfEDO7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 10:59:53 -0400
Received: by mail-io1-f67.google.com with SMTP id r18so7644718ioh.2;
        Sat, 04 May 2019 07:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vXyPYwh2Aq3WibaP/8Un33K8uj/LrX/mI1kiBZBysck=;
        b=Li6WFi66KT0Byk46CFTux0SmkV0EI1YQ8bZwJXDG/JDdJh3wfoMXQn5hGoTOn2gTfI
         uVsEAYNKqtidKYzNjTEMoAjsV3mAgQjNaCUCXLDfTJPmBnU7DXmqTWre46h7b2GC0l6j
         5lIkDb9ojo9nMH05JJJAPX9WFJ4VaTrTUd6OlNSDVWa8AXrkAqoAlVGuAt0s9uJKnRKf
         s2DKUS1wSdnRtnF1txTk/8ydw9pPqUEf9Em7agPWuXuUFXAP25W90VeHxFy/EACmNmnS
         /MlMLhqivEACnGzKITctDMTB6ewAoca/O2/pLHGTYBq+Bo43wlKBLP0vPbjBTEC9vU3N
         3PNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vXyPYwh2Aq3WibaP/8Un33K8uj/LrX/mI1kiBZBysck=;
        b=YSZ7Wtv1S7Dfub6GxqV3Od2sR+evH9iKMZZ8CaXZdRb/grwxheS2YUFVBm0xA2aKgs
         6LdxkCPXsKIXr3h61j3LwYHh9yzYOJZ4JbQGj7sh57raRE5pCyjRWd5JjcJcqN2wNBkr
         U2sumfqUoXr2IVW181ktwpVjcZDZPv+3M6Bo1QF0qr35w294amMaknrQ4/5OfkLiz3DM
         /iCAkCYqm0GAZJMApJU9PppF7pN9mcr9PJaHxVx0MsnI6xTdGd4yYtuC7dfr436dqTAS
         obV2nkywAdhWXtdiQ24OP0qE8SHLeRGZS4ZxHwbYL0E4FneQUUL/iKuLxOKTKA2C029w
         zuPw==
X-Gm-Message-State: APjAAAVPmnZgLFG/IycaxDRny2toktdYweW06FcmGgqgoabiBCN4kbXi
        HKI0mIUe+QrolpQ7abkmQII=
X-Google-Smtp-Source: APXvYqzC3b9Dl43p57p3KMEmcNZzHnpDjPgVnP0RxcwE+lVMGcUTN7jBNnIE7IrZCFcARSPDRGRnSg==
X-Received: by 2002:a6b:9306:: with SMTP id v6mr2387711iod.278.1556981992799;
        Sat, 04 May 2019 07:59:52 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:ad89:69d7:57b3:6a28? ([2601:282:800:fd80:ad89:69d7:57b3:6a28])
        by smtp.googlemail.com with ESMTPSA id g13sm2043979iom.46.2019.05.04.07.59.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 07:59:51 -0700 (PDT)
Subject: Re: [PATCH v2] net: route: Fix vrf dst_entry ref count false
 increasing
To:     linmiaohe <linmiaohe@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     mousuanming <mousuanming@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>
References: <1a4c0c31-e74c-5167-0668-328dd342005e@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dd325420-37ae-f731-1ea8-01f630820af0@gmail.com>
Date:   Sat, 4 May 2019 08:59:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1a4c0c31-e74c-5167-0668-328dd342005e@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/19 7:13 AM, linmiaohe wrote:
> From: Suanming.Mou <mousuanming@huawei.com>
> 
> When config ip in default vrf same as the ip in specified
> vrf, fib_lookup will return the route from table local
> even if the in device is an enslaved l3mdev. Then the

you need to move the local rule with a preference of 0 after the l3mdev
rule.
