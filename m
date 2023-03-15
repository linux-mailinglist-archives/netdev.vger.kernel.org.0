Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D026BB7F6
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjCOPfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbjCOPfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:35:22 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920CF38648;
        Wed, 15 Mar 2023 08:35:21 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id mg14so1153578qvb.12;
        Wed, 15 Mar 2023 08:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678894520;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YcFqNcNOQFyK8M0Bg6u2CF1KIEClFjxJotNtkabpSfQ=;
        b=NfT+tfWo4zYwBmLLayk/HYeliqkWhZoWyReFNr9whV1D5k4aDJ6poZn4PyuWXrSgFT
         pATmqe9w5uy7G9Wzy/VNF4aEXvfvDILvMq4CF8ox+CMYtX0qhpLyya86cfr5lHw3mIhe
         kj1EXeUipXhesJyrQzDuk9xLP8lKpMhucdCUrZlyYwMvcJmL67xhOItxm0qSYhplDASQ
         m1R0HTYg3XqUKy9Q8YZERq2l8fuoYAtN4IcATAd068RKlPg+ivEh/jMoMloSMmvkrNM5
         hwEiAV4PJjToeext8xyDmSnxca0jZconG+FbG67QLSbpCk9SCTfrIRePTCIVcdIIzCbp
         rUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894520;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YcFqNcNOQFyK8M0Bg6u2CF1KIEClFjxJotNtkabpSfQ=;
        b=tAzBjabnm8BSgOQydJSZVUQ0tw28IuP1ciyLKkX2/P/hHyEEdFpqNTSUBacmOhsulf
         GKW3Ritj3D+lq17Txgdat2T+lKeHTnObZxMm/KyMpP076FniJQsNm8EmVjKkIBHwfE2R
         GsdLetwypSbMWNRHDsbO/z3tm2ExJj8+2P6JMDng3Y9iZEAOFViSw8lZlLIl/KdD9AVr
         VB1ZE7kJ6+2chGJFRmjFqx42LI7F2vJFlO8edaM3OXk18WPUAMbmhw28uFPdfBzDBs1i
         NPI9/fb2rdpwtLNigbESMXyH5CFIG/k1gvf+HlSEIFgcms0kodWaxGk9vKTxgdMIMtdS
         5usA==
X-Gm-Message-State: AO0yUKUlR3AHVbnBZstmYFVIQo+Bid3ru4SjYqhHPwkNG4OMwm1npjN7
        F1mKPPp7zY3edc89M5BEYQ0=
X-Google-Smtp-Source: AK7set9AF+gTWCSQ/CTM6RbI8c7LsuTudICO9uEFswpUE9N/v8w+JwXI9EPJXJkasKYBYD8m2EoOVQ==
X-Received: by 2002:a05:6214:d89:b0:56e:ac97:85da with SMTP id e9-20020a0562140d8900b0056eac9785damr25868272qve.30.1678894520675;
        Wed, 15 Mar 2023 08:35:20 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id t9-20020a37ea09000000b0074357fa9e15sm3925085qkj.42.2023.03.15.08.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 08:35:20 -0700 (PDT)
Message-ID: <a5eea573-2418-d4dd-94b7-72bda4978666@gmail.com>
Date:   Wed, 15 Mar 2023 11:35:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 1/9] net: sunhme: Just restart autonegotiation
 if we can't bring the link up
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-2-seanga2@gmail.com> <ZBF/wr8HUg49gWZK@corigine.com>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <ZBF/wr8HUg49gWZK@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 04:20, Simon Horman wrote:
> On Mon, Mar 13, 2023 at 08:36:05PM -0400, Sean Anderson wrote:
>> If we've tried regular autonegotiation and forcing the link mode, just
>> restart autonegotiation instead of reinitializing the whole NIC.
>>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> 
> Hi Sean,
> 
> This patch looks fine to me, as do patches 3 - 4, which is as far as I have
> got with my review.
> 
> I do, however, have a general question regarding most of the patches in this
> series: to what extent have they been tested on HW?

I have tested them with some PCI cards, mostly with the other end autonegotiating
100M. This series doesn't really touch the phy state machines, so I think it is
fine to just make sure the link comes up (and things work after bringing the
interface down and up).

> And my follow-up question is: to what extent should we consider removing
> support for hardware that isn't being tested and therefore has/will likely
> have become broken break at some point? Quattro, the subject of a latter
> patch in this series, seems to be a case in point.

Well, I ordered a quattro card (this hardware is quite cheap on ebay) so
hopefully I can test that. The real question is whether there's anyone using this
on sparc. I tried CCing some sparc users mailing lists in the cover letter, but no
luck so far.

--Sean
