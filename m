Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAE7298FF1
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 15:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782132AbgJZOw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 10:52:27 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:46037 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1782128AbgJZOw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 10:52:26 -0400
Received: by mail-il1-f194.google.com with SMTP id g7so8542005ilr.12
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 07:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FTng+zyv77tm/F4bpy3+5G+qlgZCVsAwR65fqP3e7cA=;
        b=ThIqw49sy2tDg0ybFwvT3FNriZRvDgOIe6UaBLjVeE2n2caQ37rvTMjywGfeGEd2Ax
         DBvaOh+Ym5ZNGh9PmMkHlCC0HdV9ga7Yok1h9A+eywT//cgCdLcpjOzYK7bu5kwlu4hm
         fTSLKRqhisX6C5DoCuw05VOfkWChbMDjHw/acahiK2i1yALmudCkX0Wd8Q7NSOxXYn1M
         blQMl2gu31PAOBntQFuAlb2px2nq0I91nFD7eNPXnAblcfNM9FdploMbomBVVFSZiNfy
         xoA8ieL5700IQ4wyrHT16vxOHRBUFLkMZiXCzzU5hyTRohYTuQLUjmGzDI90Mr+S8MzH
         3d7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FTng+zyv77tm/F4bpy3+5G+qlgZCVsAwR65fqP3e7cA=;
        b=UCzQod0QVTWmf6sUOJvxboaJnzs6vNybY8fr3KiKvs4t9gDKiX7Hd8emcpKfQcy8E4
         gcTOySVrbg9w/go30v/2NSJV/ulb9Oj+LVpZNB5D7YVueUswtkqu+8YuwwTnH90UMqvL
         QHsvLGM6/EBNiO2YuVQ5SMd4LFZsiojw/l7qE5ujxlCCfk1D69T4mL1z4jLh0S0Zh2M6
         ldrgzgVMIRN1yi77/ow03exCF1cfx5xlmCGkDfdifqswINzPlxVejem6Zx0FLzBtyvzF
         WMi81MneeOV5OfEx1l9nDRYcVjW36JoXdHRcNkUCjkDwwIgC0Ze8Xi/bgu3COx0wjtAf
         eiKg==
X-Gm-Message-State: AOAM533SjGgC22nIoUn5Uhf6CGlHxij5ADjnuQOyEv+tdOHRwM923Swx
        htsbUa7QuEFC4n6moxGvObw=
X-Google-Smtp-Source: ABdhPJwj3cnmHjMQdqmjtDfYDbyXPBIhDsUzmPMbw8QaKikpOfKtffqJz0AP/3bFsiFSAzxwnY2o7Q==
X-Received: by 2002:a05:6e02:4ad:: with SMTP id e13mr9962759ils.59.1603723945246;
        Mon, 26 Oct 2020 07:52:25 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:146b:8ced:1b28:de0])
        by smtp.googlemail.com with ESMTPSA id h13sm1704517ile.79.2020.10.26.07.52.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 07:52:24 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vlad@buslov.dev>, stephen@networkplumber.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ivecera@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0112061b-6890-9f22-bec4-d24a2d67d882@gmail.com>
Date:   Mon, 26 Oct 2020 08:52:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <ygnh7drdz0nf.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/20 5:28 AM, Vlad Buslov wrote:
> Patch to make cookie in filter terse dump optional? That would break
> existing terse dump users that rely on it (OVS).

Maybe I missed something in the discussions. terse dump for tc has not
been committed to the tree yet, so there are no users relying on it.
