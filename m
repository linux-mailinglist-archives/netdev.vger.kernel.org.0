Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C73828891E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 14:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731938AbgJIMpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 08:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgJIMpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 08:45:24 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099E7C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 05:45:24 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id o21so7787745qtp.2
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 05:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8DPjwNAaWWskCPRXavFxZ2WY3wTQksAIyNLpUX46WeM=;
        b=YfVWM46PNpVHP9ROn09zNgGvQZGRrohy3uVDWSgDCDrsqXglmns+y1euLHdwg6Kzlt
         HS6DVtVcwH7I+a6Bx3sjpDJhQvQQ/Umh6Dc9dp6YSM+JS5OLLXQH1z/Jjd0e6ifEhQBD
         9fK4WIUVBggy4IMamUVc36VdiLV+BKTaIEbLnSs02OsizuuKRFnhGcmawaaoG3myQrSP
         Qa+DOcaF7nUQH9FjC3moPYBtgiyd5vaQS99e2Jgbx0yE1K+KNNbDQc2yM5qXtZrbT0t5
         T3JR8xIVgXls4mMtbGkkZVe7FG7MeDFgjNRxcKfP2gTdnkJjKpI4tAo5lFRmhw2LGBTI
         +L0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8DPjwNAaWWskCPRXavFxZ2WY3wTQksAIyNLpUX46WeM=;
        b=cM3B5blzVmGpBgL7RkIrQVmuczL4D6cq71NX8oWUT1W7eTdcgkkaCsQG8dUf0e51iV
         mZogeKk17AVPolItpTWgsTY3Vsk6mIv715OmKLrNE8kNtqYjnG7zA3sNA/0NxQGzzAz7
         uVazIjY6oUcsKSTexXqQgiOJGGnsxF+U3kJXGbWTLdEcQiCoqJBY9JNty7gkG/U7cEQk
         2uBGBigHhv7YaNzw+lwDIoQp8+xt3w9Nidx5waDrvL/j/jvDgKn1V0qFHNJ2toxEdtAF
         OrMo8oQAconG4u7CgyC2bcASmlnKhDnCji3jD067tEbIRhD7KbkLjRhwITVNnNgXBObG
         0kBg==
X-Gm-Message-State: AOAM531CD6eNhiOm1mnl6s0mLhkNAEpm5lCIwkrCa36xKfJO88bbzPd7
        QyeQhsQGTwE6PGm06dDgjxW/yA==
X-Google-Smtp-Source: ABdhPJzbywAv6yEFJJS6acZcdHU3FpEDy10ctrLH26+Tmjd51GqLOZR1d/uPi0xDu0x4/AsDT9KZ2g==
X-Received: by 2002:ac8:5c94:: with SMTP id r20mr13355536qta.292.1602247523237;
        Fri, 09 Oct 2020 05:45:23 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id d13sm1057730qtw.77.2020.10.09.05.45.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 05:45:22 -0700 (PDT)
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
 <81cf5868-be3d-f3b0-9090-01ec38f035e4@mojatatu.com>
 <87ft6n1tp8.fsf@buslov.dev>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <5d4231c5-94d2-4d14-292f-e68d015ea260@mojatatu.com>
Date:   Fri, 9 Oct 2020 08:45:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87ft6n1tp8.fsf@buslov.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-09 8:15 a.m., Vlad Buslov wrote:
> 
> On Fri 09 Oct 2020 at 15:03, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

>> Which test(s)?
>> I see for example d45e mentioning terse but i dont see corresponding
>> code in the iproute2 tree i just pulled.
> 
> Yes. The tests d45e and 7c65 were added as a part of kernel series, but
> corresponding iproute2 patches were never merged. Tests expect original
> "terse flag" syntax of V1 iproute2 series and will have to be changed to
> use -brief option instead.

Then i dont see a problem in changing the tests.
If you are going to send a v3 please include my acked-by.
Would have been nice to see what terse output would have looked like.

cheers,
jamal
