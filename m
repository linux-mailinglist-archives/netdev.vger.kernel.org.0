Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440D6288839
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 14:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbgJIMDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 08:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgJIMDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 08:03:19 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA2BC0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 05:03:18 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id b10so2389865qvf.0
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 05:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0BGMuWrUszVCtPRxjEsJJGPHeNg7YgpmjoJcrvbQqak=;
        b=lfb0eYcSg8O7M9esNqWAS+HcUZiYUPoQ0nzXnw8h0kd/NxkC4FvIFdAhABmamt920A
         ZjRAV4dJeVO4tasH/N3LMUnSmZa6Bax22yGlHvqQQDDd1xxXhcLn9P1AZcrFEajRlkZy
         AzbdwSqRvhMOkHHRvJx0XBMubgAwXdx8hOFiCUXzhcjWf1+pDocvd47zV7X2JZ05QKNK
         7s640b3knqOTq6mlczOIKkHJB/tflBd1LcQ4ZFG90dbBfOaBps6TqnnMQsL+neYVoTb3
         wBqngosYXAn263qUgSiZpGWfIi1kJIb0rJzuljqL/9SbROg4w3W4hCfoe8mBQrta6bbm
         Jp0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0BGMuWrUszVCtPRxjEsJJGPHeNg7YgpmjoJcrvbQqak=;
        b=SN6Fu+UvYGDtQQbVVm96lhvIaA+xogvZ6XU+V3satuUnizifMXbAm6FBXLT63GzMdr
         OlW19knMGMtN2/c7Kz6GVmmyxPqg9fufurbGzfQKy5wFURMcjQihkKWPyj3k3J4EjaoN
         8ZU3FPhjg7hSTZFtP6EueqrUu4NeM6SLqsN3uihOAQ6jVwcTof9W+1rTp72nIJJ2Nlwp
         h6WoJ80d5+itFtu0rFvGxE67um5S5v5GYjfUR7nmpfZXkiM2/SSSWCi9gB7eacXL1NkA
         W/9fNF9o4CmgOpexSo6BT+sptAsNWCwLEGD5WHs+7wRnMu7iDkNEalrtZV+/Q5nytax3
         +S7Q==
X-Gm-Message-State: AOAM532s4oABkeU8RxRTJn7Wk2m3QVpbK0xeOgitYb3dg4bJaVEZ07VC
        yuTskDiOVIX437pLiG0HrWp0hg==
X-Google-Smtp-Source: ABdhPJzFUT0j/NpbR11iubGIDcop3Imp4uqIO4EvMaLV9ZQOCPDE7kVxiNUrBkvANzbLHHWyDex25Q==
X-Received: by 2002:a0c:e5cf:: with SMTP id u15mr12344939qvm.24.1602244997683;
        Fri, 09 Oct 2020 05:03:17 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id d21sm5904415qtp.97.2020.10.09.05.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 05:03:16 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vlad@buslov.dev>
Cc:     David Ahern <dsahern@gmail.com>, Vlad Buslov <vladbu@nvidia.com>,
        stephen@networkplumber.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20200930165924.16404-1-vladbu@nvidia.com>
 <20200930165924.16404-3-vladbu@nvidia.com>
 <9961ad12-dc8f-55fc-3f9d-8e1aaca82327@gmail.com>
 <ff969d59-53e0-aca3-2de8-9be41d6d7804@mojatatu.com>
 <87imbk20li.fsf@buslov.dev>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <81cf5868-be3d-f3b0-9090-01ec38f035e4@mojatatu.com>
Date:   Fri, 9 Oct 2020 08:03:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87imbk20li.fsf@buslov.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-08 11:34 a.m., Vlad Buslov wrote:
> 
> On Thu 08 Oct 2020 at 15:58, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> 
> Hi Jamal,
> 
> The existing terse dump tdc tests will have to be changed according with
> new iproute2 tc syntax for brief(terse) output.
>

Which test(s)?
I see for example d45e mentioning terse but i dont see corresponding
code in the iproute2 tree i just pulled.

I feel like changing the tests this early may not be a big issue
if they havent propagated in the wild.

cheers,
jamal


