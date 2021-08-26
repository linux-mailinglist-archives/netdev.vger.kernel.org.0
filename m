Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA243F8DBF
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 20:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243264AbhHZSUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 14:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhHZSU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 14:20:26 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA526C061757;
        Thu, 26 Aug 2021 11:19:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x16so668207pll.2;
        Thu, 26 Aug 2021 11:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I292LG7vgq4KTBMOuKIuywhwI+2Z6jzDy4c1Rs1ZsBs=;
        b=qyea7EjeRrSDeFXhvwdwxYyD/cUxfn1B6lygpMv/gXzWpbGsTcAqk7HzMg6wXqYcwQ
         5bR5a3Pz11vSPm7t6lf1TmMYWr5TIeb7mUOw+iboqosrFSDjxGar5DcXrw6Mqr3w8z0W
         tIeAFju4JmZkddCN1KPygTJy1R0eaidvWCDBDw6tHtLmv6wC0T0FwKLvXr53+EsElStx
         4WhhHqHDCWUsUw3f8jrY6U9YwjzEUYcwVuHlpVO11WYdudNqyF0GGgcTf/RUHPAHJznj
         Q5XCjyHLv0xpP4ZcsopcWUPHly6q4qeWw61NxwSRlPR8u7fpw+L1THZV48e5iI9DlYF7
         fMDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I292LG7vgq4KTBMOuKIuywhwI+2Z6jzDy4c1Rs1ZsBs=;
        b=SqTMDYanCBoxPuIrUW6cLbM1zDZu/bcQ3qDJDjHCd0vsWFjjZnnCdcemBHxuzIYB78
         gadLUioicWHsQ1cLWqGaAdEKFx14ZhWgGNxIzAAfcoGSuJtz9bsww4HYNhG+I7lu/SBL
         L31epJsSH0fV9Ds5RitjXnl8wKaxjFReZHW8dEDPZTrcLer08mv6/1yH8QUb0sSwueea
         nCIyhFYopMGv0XNoRvd6NfihKBe27UvwgRguvJAMFmUAnnsV7k3hsKnRqnHNZNtgOXCH
         6njQqaZtG1uf6RFNSDrUwUP89IHSsYM16lQhM2+RNsoEDdTe8TuknsH7iVBmofDMycvJ
         zH8Q==
X-Gm-Message-State: AOAM5323OHWuILaxnAAXJJPmwkPwjVmAcYWVpMxyxsBR+fVFmCQ26dtL
        5aS8s5zJCm7Z81Th60d4QTk=
X-Google-Smtp-Source: ABdhPJwFev7mmxVJjjbNg7QurgKuXmBlTrzeC1J5XHsCkxZhqkXm1xBULzhHSJ7NG7icBkuFOUFitQ==
X-Received: by 2002:a17:902:e744:b029:12d:6479:83a3 with SMTP id p4-20020a170902e744b029012d647983a3mr4868681plf.30.1630001978448;
        Thu, 26 Aug 2021 11:19:38 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s15sm6758253pjk.21.2021.08.26.11.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 11:19:38 -0700 (PDT)
Subject: Re: [PATCH v4] ixgbe: let the xdpdrv work with more than 64 cpus
To:     Jason Xing <kerneljasonxing@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
References: <20210826141623.8151-1-kerneljasonxing@gmail.com>
 <00890ff4-3264-337a-19cc-521a6434d1d0@gmail.com>
 <860ead37-87f4-22fa-e4f3-5cadd0f2c85c@intel.com>
 <CAL+tcoCovfAQmN_c43ScmjpO9D54CKP5XFTpx6VQpwJVxZhAdg@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <da5da485-9dc7-e731-a8d9-f5ad7c7dffde@gmail.com>
Date:   Thu, 26 Aug 2021 11:19:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAL+tcoCovfAQmN_c43ScmjpO9D54CKP5XFTpx6VQpwJVxZhAdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/21 10:03 AM, Jason Xing wrote:

> 
> Honestly, I'm a little confused right now. @nr_cpu_ids is the fixed
> number which means the total number of cpus the machine has.
> I think, using @nr_cpu_ids is safe one way or the other regardless of
> whether the cpu goes offline or not. What do you think?
> 

More exactly, nr_cpu_ids is the max number cpu id can reach,
even in presence of holes.

I think that most/many num_online_cpus() in drivers/net are simply broken
and should be replaced by nr_cpu_ids.

The assumptions of cpus being nicely numbered from [0 to X-1],
with X==num_online_cpus() is wrong.

Same remark for num_possible_cpus(), see commit
88d4f0db7fa8 ("perf: Fix alloc_callchain_buffers()") for reference.
