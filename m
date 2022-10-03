Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5135D5F364F
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 21:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiJCTaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 15:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJCTah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 15:30:37 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6CD2FFEA
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 12:30:35 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id z13-20020a7bc7cd000000b003b5054c6f9bso9628889wmk.2
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 12:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=IpAyGd+P1NAu/iylRs5OH9L2DuNjwygjPVOrrq5MbPU=;
        b=luv4qaWNrW7frjbYsDTywhCzf1AxFBi55hDEDQPBumu9TsEDjS+bThoh84Rzh/SWRZ
         NDFkSSbmRaVO/gQkr6lj7j3zHo1SepeUKjuzjW8r98ONMpOV9nyHbm/aEr/UnUyFrKEO
         uzyg/imHSpZ242bLvdxu995Bp5Ee3SdjeoGA41RSR2aXzJndj/g/L/4DBAshdy8eIcBH
         sRkuZ4hf1/N9gMkh0gHyX4jgRiWVdMAewhIlktkTeH60E1rgJlmvF626GYXKtWV1I/O7
         ruMvNrkiVwZ7EO72OlHYi3ZRCieIXfF1r9WHqQjgMj2FmpVopI2qu/nv18DuI1Wm4jjw
         1CFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=IpAyGd+P1NAu/iylRs5OH9L2DuNjwygjPVOrrq5MbPU=;
        b=jYW0RrZEPOlvZgeTrYZDl6qDxohJf6HsSUQ93F1Rv9+MtQU2RMG4m2Q5aYSQJDoPsy
         q5T5BOeptmHeCdlxtXso6+28xFZVgcieDNP36XaeX+uNBT5/Mk7hpiOlH9uR59yXdRZs
         Enz7i7yuy/CzqMow1EI0I86xuPeo+jfKp1OoGgo8OderUGRnI/mP5UH8l1Zi57KkyYrS
         DsVQYzAea8EvWp19mRBxbWCGQc0zlDjstLFmIhgy0mrOrgAA+MGgM6QTaur2kOvYy5ua
         aYQsFGPFzkZAoxGWW6Svi9m8JNzLMUyefmxZ8UPePE+vzMXzqUhnVnK4S66gEFHIIGiw
         7rbQ==
X-Gm-Message-State: ACrzQf3qIhtMJ+sUI51zfTvXJQSikWMEwVv20zP8rVdXGxLx6hQYznrp
        gEpEk1AVKlT40+IKFh4pzsk=
X-Google-Smtp-Source: AMsMyM4esJmvpMHLbfxtXHyDrO8bjcWq/L2OQ7zZafQ69GPGnQ/pbEN2e9gyghKzIuTTkUNClhWMJQ==
X-Received: by 2002:a05:600c:22c7:b0:3b4:92ba:ff99 with SMTP id 7-20020a05600c22c700b003b492baff99mr8382557wmg.190.1664825433654;
        Mon, 03 Oct 2022 12:30:33 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c05c800b003b332a7b898sm11857913wmd.45.2022.10.03.12.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 12:30:33 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload
 errors
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
 <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
 <20220928104426.1edd2fa2@kernel.org>
 <b4359f7e-2625-1662-0a78-9dd65bfc8078@gmail.com>
 <20220928113253.1823c7e1@kernel.org>
 <cd10c58a-5b82-10a3-8cf8-4c08f85f87e6@gmail.com>
 <20220928120754.5671c0d7@kernel.org>
 <bc338a78-a6da-78ad-ca70-d350e8e13422@gmail.com>
 <20220928181504.234644e3@kernel.org>
 <16da471c-076b-90b3-3935-abd31c6ef4d3@gmail.com>
 <20220930071951.61f81da6@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <f4ee3271-7180-c408-2b04-cec8e784176c@gmail.com>
Date:   Mon, 3 Oct 2022 20:30:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220930071951.61f81da6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/09/2022 15:19, Jakub Kicinski wrote:
> On Fri, 30 Sep 2022 10:03:01 +0100 Edward Cree wrote:
>> It has one (do_trace_netlink_extack()), but sadly that won't play
>>  so well with formatted extacks since AIUI trace needs a constant
>>  string (I'm just giving it the format string in my prototype).
>> But yeah it's better than nothing.
> 
> We can add a new one which copies the data. Presumably we'd have a "set
> an extack msg which needs to be freed" helper were we could place it?
> It'd mean we cut off at a static length but good enough, I say.

Hmm, seems I was wrong about the tracepoint, the machinery already
 handles a dynamic string just fine.
I should have an RFC patch ready in a few days.

-ed
