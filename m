Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386271E5E02
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 13:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbgE1LOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388202AbgE1LOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 07:14:10 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA81C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 04:14:09 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id g7so2166295qvx.11
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 04:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pd8G6rafR9wqBRaKMroEKBbNzUmp3RmWv6uFx28yGgU=;
        b=n8pfTdNSTzxPngfg2H6Tn1zGfX2vgVsR36ztyKhHur1aObeqIUKfAxf3VlAMSG+g5z
         x4kENiGjzqBDzL0/vqyeh8WLwl1jI8GLiOxgUAfHZx9WCwxv4s35Lfss6F6P24+0qHKY
         oyA7PCcLfZf6abETlLDUrywSa8HLY0OHSKOzECk36IkoxNaN4LesP0C8gDLMsPXoLryF
         T/eDxUtnp+ftKLjr7xEm9cy/lAyKz2DQGNwVdpDaDiNi8nqSVMvgcptLaAr9656VwOHf
         St2cVBU9dvj3BOZRyOemHwnjlIK21xj19gxtd2+8KtGJz6OVnMhwz7E4ylO1duIR5pDB
         W3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pd8G6rafR9wqBRaKMroEKBbNzUmp3RmWv6uFx28yGgU=;
        b=k3rn9Wkgr5qDlJNc+tng3f/0mDhntCL2laR15ZMqtPlGAixez9kAfMwAdKegLA0UVl
         fJFOk2qkt41ilRqt/1iMJd4u5chBmFqY7QRhPcvRUiYHexJDHqjUSuNug264bHdxqnb5
         OikZVnahZQBRApqOlPOLE+7hhPFORsJ9ZmAII01+fGWO7m+CtylHmdxGmQAxmvHpkqiV
         gB+w5W3Jliy8xZOQKpF/Elkqfb4gawefsgrjDrEZQz08UOteK0wzyJPZofj0kLfOVC6G
         eNmaenD1eweZ9eYOp4DZp2/1MUkYKhp37YAGrfWvnfpGoIhGf936eQ74nracJoYZvCQX
         j71w==
X-Gm-Message-State: AOAM531DaPpuwyYsjvV5jel3/6oj4vKHNUjD2QCSnbbr5LsoNGJgX5W9
        LlfSI/hPtZDk31K3QA8sKf/aig==
X-Google-Smtp-Source: ABdhPJzUN77UMW0WntVOks0gVLgzwTPIcdE1roooLvsjq3+nyAXFfQJVGW7wS0jm9JQB+NTJ5ASZWw==
X-Received: by 2002:ad4:580b:: with SMTP id dd11mr2504104qvb.145.1590664448276;
        Thu, 28 May 2020 04:14:08 -0700 (PDT)
Received: from [10.0.0.248] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id q46sm5219175qta.79.2020.05.28.04.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 04:14:07 -0700 (PDT)
Subject: Re: [iproute2 PATCH 0/2] Fix segfault in lib/bpf.c
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, asmadeus@codewreck.org
References: <cover.1590508215.git.aclaudi@redhat.com>
 <20200527151335.33ae7e9a@hermes.lan>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <658c1e43-80aa-1714-34ec-c5f2dff85710@mojatatu.com>
Date:   Thu, 28 May 2020 07:14:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527151335.33ae7e9a@hermes.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-27 6:13 p.m., Stephen Hemminger wrote:
> On Tue, 26 May 2020 18:04:09 +0200
> Andrea Claudi <aclaudi@redhat.com> wrote:
> 
>> Jamal reported a segfault in bpf_make_custom_path() when custom pinning is
>> used. This is caused by commit c0325b06382cb ("bpf: replace snprintf with
>> asprintf when dealing with long buffers").
>>
>> As the only goal of that commit is to get rid of a truncation warning when
>> compiling lib/bpf.c, revert it and fix the warning checking for snprintf
>> return value
>>
>> Andrea Claudi (2):
>>    Revert "bpf: replace snprintf with asprintf when dealing with long
>>      buffers"
>>    bpf: Fixes a snprintf truncation warning
>>
>>   lib/bpf.c | 155 +++++++++++++++---------------------------------------
>>   1 file changed, 41 insertions(+), 114 deletions(-)
>>
> 
> ok merged
> 

FWIW, it may be useful to grep the tree and check for
s[n]printf() return code.
It seems like modern compilers are good enough at catching
overruns but maybe useful to enforce a coding style consistency
given that most people doit the LinuxWay (cutnpaste existing
code to fix a bug or add a feature).

cheers,
jamal
