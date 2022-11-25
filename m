Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A49E638524
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiKYIV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 03:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKYIV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:21:26 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8887A205FA
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 00:21:24 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id f18so8676668ejz.5
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 00:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OzAqy5yB4+6IFMiokezU2dcU778CH7+EqpDp1oWQuac=;
        b=IT7eMTTbvbbmGhZnV7On7YOd62t5ujX1eyS+T9g3UEbTwDI8lOEbKNsGWAMvS0wrgU
         /1Ae6g/VjQRdUCpxGbzyq7QuRm15RO2RDFgF6RzlQv8FBBT0rgPo9vfgLmqyJGnwWF8F
         ZmuN2xFdWfuydWQ/8B8Ld11bquSuomtyPQJ/UO+B4GtHr6vEYUmD88vt7KeIuD5s36Ag
         F7APSSMYHg9vpSzbd6jtAaAitMLCZehQufAQLQ4D+A2moCo58whAmo7dFxJwJ7m8fSVz
         96Qnu5Eu69W0BQpcumPE6qsA+jlIU949BSxBZAxVgL/W0uTLZr+6Id7Bl5Qgki9Km4jC
         WC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzAqy5yB4+6IFMiokezU2dcU778CH7+EqpDp1oWQuac=;
        b=VF0GkjIgup7GUiVfTex3lCgAN7WXG8gzq1mETeLlPqoWbXJVc+58bpeBVbAJhrXA7w
         qHZz/6PuXiisr1PK/1sa8KJVFoQNCkeyWq/zFSvDl66B0/oVCOSgzXRofnUO+qO7AYi4
         8bWjIPxVsnrevjPYKrMaHJXvyukNYuGgTrk9uey+7CqbIeS7gSurqU7uFHVrXFRT1H2b
         ecxSRYKZ6aIaQJWPojEQiRZLP0TsglSvDSp9eaPEC2sqAN7dcxvVgZ8Urobg6MKEilaN
         QHmqJlshZR71CfSVJPzHcJc5pDrneRMPe8FGracAWvmjjlfR8h6yCMmR5zECW/6V3Tua
         TffQ==
X-Gm-Message-State: ANoB5pktWrHhPUrlvX4CUP9ywyer+bQ63FnL4dGNT2Ps1Tdhfq2AYb79
        4/iGx2hWGEykKj1mMYnFNfDRpA==
X-Google-Smtp-Source: AA0mqf7l80hUkIZvw1y2AfZZWqZo/32WQUBG+HF98L8/Y11Yo8WuAFjKVucPFEgl1Auvm1GQsil62A==
X-Received: by 2002:a17:906:1cf:b0:7bb:f0eb:a350 with SMTP id 15-20020a17090601cf00b007bbf0eba350mr3502774ejj.575.1669364482969;
        Fri, 25 Nov 2022 00:21:22 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q1-20020a17090676c100b0077a1dd3e7b7sm1293421ejn.102.2022.11.25.00.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 00:21:22 -0800 (PST)
Date:   Fri, 25 Nov 2022 09:21:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [patch iproute2] devlink: load ifname map on demand from
 ifname_map_rev_lookup() as well
Message-ID: <Y4B7AZN9gGsb6Sm2@nanopsycho>
References: <20221109124851.975716-1-jiri@resnulli.us>
 <Y3s8PUndcemwO+kk@nanopsycho>
 <20221121103437.513d13d4@hermes.local>
 <Y38rQJkhkZOn4hv4@nanopsycho>
 <79df4604-9abc-50ae-3d8b-3338d9d69ab0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79df4604-9abc-50ae-3d8b-3338d9d69ab0@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 25, 2022 at 05:02:40AM CET, dsahern@gmail.com wrote:
>On 11/24/22 1:28 AM, Jiri Pirko wrote:
>> Mon, Nov 21, 2022 at 07:34:37PM CET, stephen@networkplumber.org wrote:
>>> On Mon, 21 Nov 2022 09:52:13 +0100
>>> Jiri Pirko <jiri@resnulli.us> wrote:
>>>
>>>> Wed, Nov 09, 2022 at 01:48:51PM CET, jiri@resnulli.us wrote:
>>>>> From: Jiri Pirko <jiri@nvidia.com>
>>>>>
>>>>> Commit 5cddbb274eab ("devlink: load port-ifname map on demand") changed
>>>>> the ifname map to be loaded on demand from ifname_map_lookup(). However,
>>>>> it didn't put this on-demand loading into ifname_map_rev_lookup() which
>>>>> causes ifname_map_rev_lookup() to return -ENOENT all the time.
>>>>>
>>>>> Fix this by triggering on-demand ifname map load
>>>> >from ifname_map_rev_lookup() as well.
>>>>>
>>>>> Fixes: 5cddbb274eab ("devlink: load port-ifname map on demand")
>>>>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>  
>>>>
>>>> Stephen, its' almost 3 weeks since I sent this. Could you please check
>>>> this out? I would like to follow-up with couple of patches to -next
>>>> branch which are based on top of this fix.
>>>>
>>>> Thanks!
>>>
>>> David applied it to iproute2-next branch already
>> 
>> Actually, I don't see it in iproute2-next. Am I missing something?
>> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/log/
>> 
>> Thanks!
>> 
>
>please resend.

Well, it is a fix, it should be put into iproute branch, not next. I'm
confused to be honest :/
