Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D264BC22FC
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 16:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731417AbfI3OQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 10:16:58 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44408 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731113AbfI3OQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 10:16:58 -0400
Received: by mail-io1-f68.google.com with SMTP id w12so10607300iol.11
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 07:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qSyzuXDiOCBGYUe5x3wq3t+cEuvzBt8YWh4PsSfAxng=;
        b=UN3DqBAKeUwm8D0QEQjS3xJkE3+G7UwQhw6O0nfYZs1PZxchfelnwuw6XbPAxU+6iT
         z7SVP3YgvJDIJkPDy8Bfe1iwyqHZfIHIy7DYtqo1N8vSDthWvJQNB9ATkSpZlZ3XCuki
         qXAC8XV3pv/MJIMPSXlVWaEDCm27ZkGzg0pXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qSyzuXDiOCBGYUe5x3wq3t+cEuvzBt8YWh4PsSfAxng=;
        b=W6u67C3Y4sAHIteYkbqSZ661GLcLzK9JTc8U7nPKAHXMJeIRMFgInJryBSTuktWP2C
         vq13sZABmOI4K5VOttZPyZAzkU4VnsjpsX0n4B/PKLOwo7mA2ii4bUlBFhn9JEruOQYR
         /0E8jN5GmADxz3Mp80QEwM8ji1kb38AWfSs7wEEWGJ7p5BqBaA0UZ31aF50su692cZq7
         a0WwGDQCTd71Y+2/QmlGl7QVWTAoRWy/Z10ECmCNV/JgbNcG5gffArckbaLIwyS8a3yC
         z83wYAQfuk+0H2rA0tTGfCwtyZbJHOK4wpM/eKaG8mE37VhHLR94eRL+s3CPj8/5EmYV
         dvNQ==
X-Gm-Message-State: APjAAAXb9UBiQSEoWWpRQgeSsdDBukmwYOvTt3SLBhkSBuQyj+K4PgcS
        Ae0b6HiDf/9FWK108bGQJO+shg==
X-Google-Smtp-Source: APXvYqxn8RJVirvm2HAhcEVkXxh7lQAUGhEQpdT+JkKACOG3a8byP3d+14FHtvWo1veaYWwLKjPYgA==
X-Received: by 2002:a92:6c10:: with SMTP id h16mr6350326ilc.299.1569853017550;
        Mon, 30 Sep 2019 07:16:57 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r2sm5475403ila.52.2019.09.30.07.16.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 07:16:56 -0700 (PDT)
Subject: Re: [PATCH] tools: bpf: Use !building_out_of_srctree to determine
 srctree
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20190927011344.4695-1-skhan@linuxfoundation.org>
 <20190930085815.GA7249@pc-66.home>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ea108769-1b3e-42f8-de9c-50b4a563be57@linuxfoundation.org>
Date:   Mon, 30 Sep 2019 08:16:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190930085815.GA7249@pc-66.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/19 2:58 AM, Daniel Borkmann wrote:
> On Thu, Sep 26, 2019 at 07:13:44PM -0600, Shuah Khan wrote:
>> make TARGETS=bpf kselftest fails with:
>>
>> Makefile:127: tools/build/Makefile.include: No such file or directory
>>
>> When the bpf tool make is invoked from tools Makefile, srctree is
>> cleared and the current logic check for srctree equals to empty
>> string to determine srctree location from CURDIR.
>>
>> When the build in invoked from selftests/bpf Makefile, the srctree
>> is set to "." and the same logic used for srctree equals to empty is
>> needed to determine srctree.
>>
>> Check building_out_of_srctree undefined as the condition for both
>> cases to fix "make TARGETS=bpf kselftest" build failure.
>>
>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> Applied, thanks!
> 

Hi Daniel!

Is the tree the patch went into included in the linux-next?

thanks,
-- Shuah
