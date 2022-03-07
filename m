Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EC24D0B54
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343841AbiCGWo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343834AbiCGWoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:44:25 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53E83EB98
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 14:43:30 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id c11so2353426pgu.11
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 14:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=SQ3V0TfbXmsRsMhkLQ/sEh6cz/OW5hMEqva4Bmdh220=;
        b=Y+UIU/JCGWnpErpDKHaIS4BcBNFB7WAu7n+wOSsJqenaFkvle0/QAhEXjUHNM/Gkyt
         nkFH8OaS1oGbfgs/DHx7SBthOYKdGPJLHUL58TD9Lkdt1syUNoCwqhGAEtdW89juRkJX
         HLCS35zSLkQx19Oh7DBq6RbmZSzf8Q0f6dX+kotgWaGcuKgcb9EmZcOv41pmQkHxOFGs
         wnTpqfnPZT4yAL+aSdoJXXGDmh3vGc1PaNe0VsU6BHpEgY3Q64UjlTjlKPj4EqqCcqL/
         B9R1VQo4MTohMvhQDiQx891Yyfaj3bjLTtUYkc6LEf366Zgexc6rfTJoLwZyyArLWmeE
         mR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SQ3V0TfbXmsRsMhkLQ/sEh6cz/OW5hMEqva4Bmdh220=;
        b=l/7cj5mslr6y0ZEIjA3dsICgftEk7EWSTGkiqMhp1QVpDYhpY5yQePWByrLdRwhlTr
         NlEltR8IiIYQyYpTqipNhAbTwpTdGZbgYU1kC506RNpZuxv4ZnojuzkX6jaoczlK3VCR
         kfdppJKUsJMnOgzn0lNCYf3S55Gu2V7HQcwvI8wlZoiuRAEg1K/pAsFECTofdU1olA7l
         hl/sbozNjvHmXlYcm3upwZ29rYmC9rtBZLRA8qFWn/EOc3H0Gn2OuR0OSjsOsiE6QW7g
         oBsSYNt0noMcLxywq8uyAXja/77lMAWAjQsF3oQneL5FfzEVrFNGIddIq5A3ztxcHsCW
         CafQ==
X-Gm-Message-State: AOAM532i5RnP2CM6Q/JOERBSspwa5Gg1RoTNweLzMf8pzcZ+Lf+dMXch
        J+4I+IZdbNdcZq+S0UzJqbXfusY3T90=
X-Google-Smtp-Source: ABdhPJyUuzlDPzJcaGsEBTWIEssN+puEJ+jo+kDNFsVw+CFPzgTSiE6tNutdjBMcrHpe9WDraLHiag==
X-Received: by 2002:a65:4108:0:b0:36b:ffa6:9c86 with SMTP id w8-20020a654108000000b0036bffa69c86mr11373194pgp.203.1646693010208;
        Mon, 07 Mar 2022 14:43:30 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p10-20020a637f4a000000b00373a2760775sm12742028pgn.2.2022.03.07.14.43.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 14:43:29 -0800 (PST)
Message-ID: <195db88f-501a-03f1-3f1c-a33d3358768c@gmail.com>
Date:   Mon, 7 Mar 2022 14:43:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 2/2] sch_fq_codel: fix running with classifiers that don't
 set a classid
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
References: <20220307182602.16978-1-nbd@nbd.name>
 <20220307182602.16978-2-nbd@nbd.name> <87lexl7axu.fsf@toke.dk>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <87lexl7axu.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/7/22 12:41, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
>
>> If no valid classid is provided, fall back to calculating the hash directly,
>> in order to avoid dropping packets
>>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> While I agree that this behaviour makes more sense, it's also a
> user-facing API change; I suppose there may be filters out there relying
> on the fact that invalid (or unset) class ID values lead to dropped
> packets?


Indeed.

This part was copied from SFQ, so if we want to (optionally ?) change 
the behavior,

same change should be applied to SFQ.


