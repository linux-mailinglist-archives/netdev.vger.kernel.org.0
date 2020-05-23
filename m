Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F95A1DF6A0
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 12:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgEWKcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 06:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgEWKcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 06:32:21 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3221FC061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 03:32:20 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id x13so5923429qvr.2
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 03:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IZk77Tyfa+NM27sL0QJ+7ZS86kYHuCNCInwx2wcWyyI=;
        b=oHotsWgS4cOKwlglDBZKLllln5Jvd2IxpfHdOkg8K2VTlDc6WnBB+IkCBwOw1W54Rd
         lcnBqs/NrCeYnXSR1zw7EG/W7akNdmYDAmK8h/tmG4h6LKeKIEHm3t6Wq9KtjvHMaygh
         /9EnLDq93MzcQyy1EA/Td+w4Cad16MzRlnbTt6uqO7eNE4cfOmTblO9zzJovOXNdh6QK
         LQj+dNaFL63jyl94T1VJE6xOlebAw5onaU9M9gV8GN9LF1uxVSWSodUMQnpwK6qFgIBd
         HMpGwuYrZbbQcziJNqhULgvEHLSaM2abf0ZoBY15bcbbW+XXtbxMmor8sehuyXBAcznS
         x1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IZk77Tyfa+NM27sL0QJ+7ZS86kYHuCNCInwx2wcWyyI=;
        b=WBuxzWadlR2+aLwwFjSfGJRpNwF0eUc0gwlGAXvk/dZDvKV+ZurtNxTbwRMFjAL+qV
         ITkH9ZqC4lT1GYIi+BmAO8yvTEzbNHpffFd5r0RlrDLwLSAvyayB20LtrZOvemKyXZHR
         l3FwQsHbMhJclF4uXSRvGkrJ/PK2KvavtvBxQTG+XPtf1jxAs4mn12c143YeAppSFbwU
         Z9P45d26332mg0YXfHrsp/c16yIApuih3vAWiPXn5R2Cv02IKmIf/moFy3gc6NbHvT4H
         AHTo/KK6XETGiF4nI4BdgcsMoSNEaRW13r/oq2Av1Dg8CfHUY2NbVBf49q8EcKTvhCRs
         W0Qg==
X-Gm-Message-State: AOAM530dUoiK5Lpz6nEz5521Np1D1ui/doGxFnYXD/rFuACZZqp2Ww67
        jIQU7CPhh+6/bBsYDQdhq0PqXXiiqm7QFg==
X-Google-Smtp-Source: ABdhPJx4S1CC6xUK3eb6CeKJsS4Qt2p+pNAaTaBFeJhJb2w3AizVG2tiA+B/hTlB6v3jp+BeV0X/Ow==
X-Received: by 2002:a0c:a619:: with SMTP id s25mr7726028qva.21.1590229939426;
        Sat, 23 May 2020 03:32:19 -0700 (PDT)
Received: from [10.0.0.248] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id g51sm804753qtb.69.2020.05.23.03.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 03:32:18 -0700 (PDT)
Subject: Re: [PATCH iproute2 v3 0/2] bpf: memory access fixes
To:     Daniel Borkmann <daniel@iogearbox.net>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        asmadeus@codewreck.org
References: <20200423175857.20180-1-jhs@emojatatu.com>
 <125e68f2-2868-34c1-7c13-f3fcdf844835@mojatatu.com>
 <1d1e025b-346b-d5f7-6c44-da5a64f31a2c@mojatatu.com>
 <e192690f-ad1a-14c1-8052-e1a3fc0a1b8f@iogearbox.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <f18653bd-f9a2-8a87-49a5-f682038a8477@mojatatu.com>
Date:   Sat, 23 May 2020 06:32:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e192690f-ad1a-14c1-8052-e1a3fc0a1b8f@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-22 9:33 p.m., Daniel Borkmann wrote:
> On 5/18/20 3:00 PM, Jamal Hadi Salim wrote:
>> ping?
>>
>> Note: these are trivial bug fixes.
> 
> Looking at c0325b06382c ("bpf: replace snprintf with asprintf when 
> dealing with long buffers"),
> I wonder whether it's best to just revert and redo cleanly from 
> scratch.. How much testing has
> been performed on the original patch? We know it is causing regressions, 
> and looking Jamal's
> 2nd patch we do have patterns all over the place wrt error path that go 
> like:

Reverting c0325b06382c would work as well..

Note: I believe Andrea's original goal was to just get rid of a
compiler warning from sprintf(). Stephen suggested to use
asprintf. Andrea's original solution to get rid of the compiler
warning would suffice. Maybe then an additional code audit to
ensure consistency on usage of s[n]printf could be done and
resolved separately.

Thanks for taking the time Daniel.

cheers,
jamal
