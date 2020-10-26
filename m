Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070FE2990D5
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 16:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783591AbgJZPRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 11:17:37 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41063 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1783587AbgJZPRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 11:17:34 -0400
Received: by mail-io1-f68.google.com with SMTP id u62so10430584iod.8
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 08:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qU2cUlp6lacy7jhGZxnd3HZxFpJlhPJm65nXlFAIKlw=;
        b=LDjWXf3GSyGNT8+mopteWEVjBizPlVzcoHiENMjhbx4Qh/0UZlAGNqO0YarB/zfpDi
         JeWhCtfr+yaVuH38uHheFHKOpTdECaiCOMIgemvQUcV478e8LPl/r7eSQQqNwAVu8GBJ
         ayh/lZYZKH0jcebbRbyVLsdir33WTcdjFSU+9NLJ3Q25/R3gijiQKpzawEfTOAFSE8a8
         BZcen5qWKL4m2dClZGKfIWnzm7PFat3V9AZdaQ3RYCjG2vcX8e+hL8axb5sfIJjoSUMs
         ALWEPkYSq7uhf029MJk35EfqV+YBTGWZ4v+FNHQaYibBy5PuChBWbjkUN/KLasp6Hv2B
         EaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qU2cUlp6lacy7jhGZxnd3HZxFpJlhPJm65nXlFAIKlw=;
        b=dYTd2k1jyKjhKIAdo9lwGHLpvzao+qZN70yBGXYAu0ZkMXZ4cpYuH/JuJQRGDqn+zc
         gsJa3t1gg7lESM1oA+ELwDJaUzu0HPjJJlE0zimYtgqdy0Ig5zAyW1SuVcAjImF+OC2h
         j9jmF1Bx6cHrd9U26rH+Pg4i9iorkojaDPjbPmsgdSDe3hvZzwgQSzub595M70zVg9xQ
         ZTJE9ukiMrrt0vbMMeMP6EitmfTFcPWt6V4KefNsPSfYtNhr3ex+jslGMNBTFyk70FqN
         FnXnQtLIErG1NkPd5JkHZlWzzUvlQivm9jTVbhDdx5YAFDOYTE2ZxdnJP+wq//VeCmMr
         InWw==
X-Gm-Message-State: AOAM533M1qbU5VnBTeJi01Ft7jmmWBX0yx8ZfFn1Ashyfewks9C3HXiJ
        mKo3JhtCv/wtAmPoLfUeDjY=
X-Google-Smtp-Source: ABdhPJzwmFCRLIbUr3pGBGMSrNzj0wu0pl0inBw1/nN4MVJ/WD8gUMKxzAchrG/y058Mp58/vFpnMw==
X-Received: by 2002:a6b:f401:: with SMTP id i1mr11467032iog.130.1603725452483;
        Mon, 26 Oct 2020 08:17:32 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:146b:8ced:1b28:de0])
        by smtp.googlemail.com with ESMTPSA id i7sm6610706ilq.64.2020.10.26.08.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 08:17:31 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Vlad Buslov <vlad@buslov.dev>,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
 <20201016144205.21787-3-vladbu@nvidia.com>
 <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
 <87a6wm15rz.fsf@buslov.dev>
 <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
 <877drn20h3.fsf@buslov.dev>
 <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com>
 <87362a1byb.fsf@buslov.dev>
 <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com>
 <ygnh8sc03s9u.fsf@nvidia.com>
 <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com>
 <ygnh4kml9kh3.fsf@nvidia.com>
 <89a5434b-06e9-947a-d364-acd2a306fc4d@mojatatu.com>
 <ygnh7drdz0nf.fsf@nvidia.com>
 <0112061b-6890-9f22-bec4-d24a2d67d882@gmail.com>
 <ygnhzh4958o0.fsf@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <31ffad3e-d5b9-61bf-72c9-9467ec0cc4f0@gmail.com>
Date:   Mon, 26 Oct 2020 09:17:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <ygnhzh4958o0.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/20 9:06 AM, Vlad Buslov wrote:
> What do you mean? Kernel terse dump flag and implementation have been
> committed long time ago and are now present in released kernels.
> 

ah, kernel side feature, not the iproute2 change.
