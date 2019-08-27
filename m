Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 321919EF07
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 17:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfH0Pez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 11:34:55 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:36669 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfH0Pez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 11:34:55 -0400
Received: by mail-wr1-f50.google.com with SMTP id y19so1425350wrd.3
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 08:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6oBwq+K9qTcQtYp/Hz8osR6pxTP/rPLVJLy9wif4hkA=;
        b=Wo3+UQ5pOR9T4ZdqK/14+kliTxvR/vQwJB0eC1QHGlhzATKTGPACNfC8Khn/fB5CNe
         +3axoRRG+4L11ECdXgrFoEi4vfaFpbHQgGJtI3MmO7O5G3DVvWIjyMT9yLGFt1dkkvwR
         apaCGWTweN6izlB6nmSS1VHhYkfR4AKQ20qwSsOu0g0XvU7i4cnUhgkSksvdiVRhskGV
         LjVt1ADiqfemJB3sLFoFEw3K2o1ZqmODOiI50XeBQp4I3vDZ5Lk6uCSbdT+/tW8AnuK2
         Q+5wm7ZO51/juP9ybWeYCUJsFmTIV43aDa4V78ZNXkqezAen1gG9Krkgh2AJl6g2ZKyf
         VKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6oBwq+K9qTcQtYp/Hz8osR6pxTP/rPLVJLy9wif4hkA=;
        b=rGHSIutBUIq9VGIpn3vTjTV0kTr04Ex2HQdOOVsam/wWvZ5ri2I63Ng5mP+Sayui4w
         K66pKqxyrQA3WZMm9VtS0wLZ98tYNZ1byNSevxueIUXs+NHdNtUWAUndZE9/+mYN6lO/
         hVDBHgJ6cCZeFmazxPw/td9Fuh1lWqrD+keheCrob3f8bGA9WFlJ1SpvscoBOb2qbV66
         mYc41ESYbf1l1oihPfAK3vAodKr4x06239NfJfM3hfVo+CtgYJ4mEE28+J/smcvNTu8l
         hynePH/UISO4a7tV4Cs2iH9pyy8Uf6RgHoMclIUlY6uxfaRv+VFgkD0l5RXWNc/lQ0IF
         JEoQ==
X-Gm-Message-State: APjAAAXKGJyxoMFkygTuAe7Wkmv5IdPSKlGe3lQlj4oF4hDmhx9WsbQZ
        Aiw/576ARFYbTI8wBfQUGMA=
X-Google-Smtp-Source: APXvYqw3kw6EfPClPyejwj9ptqK8iLXiuLV9JVlq8C+lm8lPUHURO8juRjVmmlV8SUWwptumqhPH5w==
X-Received: by 2002:adf:e708:: with SMTP id c8mr8387613wrm.25.1566920093385;
        Tue, 27 Aug 2019 08:34:53 -0700 (PDT)
Received: from [192.168.8.147] (212.160.185.81.rev.sfr.net. [81.185.160.212])
        by smtp.gmail.com with ESMTPSA id f192sm3202067wmg.30.2019.08.27.08.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2019 08:34:52 -0700 (PDT)
Subject: Re: [net-next] net: sched: pie: enable timestamp based delay
 calculation
To:     Gautam Ramakrishnan <gautamramk@gmail.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, davem@davemloft.net, xiyou.wangcong@gmail.com,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Dave Taht <dave.taht@gmail.com>
References: <20190827141938.23483-1-gautamramk@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <316fdac3-5fa9-35d5-ad74-94072f19c5fc@gmail.com>
Date:   Tue, 27 Aug 2019 17:34:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827141938.23483-1-gautamramk@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/19 4:19 PM, Gautam Ramakrishnan wrote:
> RFC 8033 suggests an alternative approach to calculate the queue
> delay in PIE by using per packet timestamps. This patch enables the
> PIE implementation to do this.
> 
> The calculation of queue delay is as follows:
> 	qdelay = now - packet_enqueue_time
> 
> To enable the use of timestamps:
> 	modprobe sch_pie use_timestamps=1


No module parameter is accepted these days.

Please add a new attribute instead,
so that pie can be used in both mode on the same host.

For a typical example of attribute addition, please take
a look at commit 48872c11b77271ef9b070bdc50afe6655c4eb9aa
("net_sched: sch_fq: add dctcp-like marking")
