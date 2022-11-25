Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1DB638301
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 05:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiKYEEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 23:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiKYEDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 23:03:42 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77337BC80
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 20:02:43 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so1579376pjd.5
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 20:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u9xL+kKVeK3fUG0sNPtGZIyjN9ROKBmvsYprLJmIhmo=;
        b=O5lTutq3uwwBkvP6TCAZI/ibWuqaSyPIMbLCq2yIVky/j6V0/GHzDQAxh9Hkh9+gyf
         OXc0kqPofEea2E7QeZnzXgEBk24fkz/Cqn26RDeyYzDjLGaXuYulQwN+SNCiYBme+ZeL
         46k58rONU5XE3ONsb7DFV1ng8C/nQ9KYP30t+/T4b/kant+jX031WJK3M635GlVIKm/S
         fEGG/1srtACm8NG9u464k2Li7JrQV8ByP6TGDVy7aauTrDm5asr4qDjWIEHl/eP1Szn3
         /Zx3YbpglO8xffdfQ998E+sakm41OzBval0zwgyRPM572eKGpAPbBVSx+BNKD7jeudL+
         Epsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u9xL+kKVeK3fUG0sNPtGZIyjN9ROKBmvsYprLJmIhmo=;
        b=gkNtEPk7CiflAZo0BX49oIkTb2v7m7tbS3o1eF9to9UeaCJ5Hw9TUDxWICk/D+0WgZ
         Y/hXATdlWR1UgZ8A7foDCFh61hgyKTj9bR+nyfVnBc++Q/EakECg5xXiTRQ+2vqMSXNr
         n5IGR9MR67cCqPlN9MpRLEGCqWmNOPOEvL8RbV4L7k4sCg26ZSxqF7SiWzERWWx8Mx9s
         Kw0NUpaGfkzfboqMGQ+dv2mwxnt1SzcjSxHLPXsVRtat9Xy42FrgDrhHHNLAyt2N4sy2
         VTS75flvE/M/91RBXuEcBCKDjz4a82SFU2aM1JliLknNu2eg9pbvx/e64L8dLTRPbi5F
         MGxA==
X-Gm-Message-State: ANoB5plFuJt4k6fPP+fnbAsueZOppQQjPq9aveN7nn3hUh2mDMYG4wCl
        swZs2O4mWCgtwMLLNgt/URL7GuYdaHE=
X-Google-Smtp-Source: AA0mqf5nA9zzrpvD/6gpcWooNGb/VLitxxKjF+fEKUf6J5/zSTqOQ0c7X1wpvcVX90Rb+E/KkOJpTA==
X-Received: by 2002:a17:903:1206:b0:188:cd12:c2e1 with SMTP id l6-20020a170903120600b00188cd12c2e1mr19212607plh.171.1669348962830;
        Thu, 24 Nov 2022 20:02:42 -0800 (PST)
Received: from ?IPV6:2600:8801:1c8b:7b00:adfe:487d:e345:f456? ([2600:8801:1c8b:7b00:adfe:487d:e345:f456])
        by smtp.googlemail.com with ESMTPSA id i19-20020aa796f3000000b0056b8af5d46esm1964671pfq.168.2022.11.24.20.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 20:02:42 -0800 (PST)
Message-ID: <79df4604-9abc-50ae-3d8b-3338d9d69ab0@gmail.com>
Date:   Thu, 24 Nov 2022 20:02:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [patch iproute2] devlink: load ifname map on demand from
 ifname_map_rev_lookup() as well
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20221109124851.975716-1-jiri@resnulli.us>
 <Y3s8PUndcemwO+kk@nanopsycho> <20221121103437.513d13d4@hermes.local>
 <Y38rQJkhkZOn4hv4@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <Y38rQJkhkZOn4hv4@nanopsycho>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/22 1:28 AM, Jiri Pirko wrote:
> Mon, Nov 21, 2022 at 07:34:37PM CET, stephen@networkplumber.org wrote:
>> On Mon, 21 Nov 2022 09:52:13 +0100
>> Jiri Pirko <jiri@resnulli.us> wrote:
>>
>>> Wed, Nov 09, 2022 at 01:48:51PM CET, jiri@resnulli.us wrote:
>>>> From: Jiri Pirko <jiri@nvidia.com>
>>>>
>>>> Commit 5cddbb274eab ("devlink: load port-ifname map on demand") changed
>>>> the ifname map to be loaded on demand from ifname_map_lookup(). However,
>>>> it didn't put this on-demand loading into ifname_map_rev_lookup() which
>>>> causes ifname_map_rev_lookup() to return -ENOENT all the time.
>>>>
>>>> Fix this by triggering on-demand ifname map load
>>> >from ifname_map_rev_lookup() as well.
>>>>
>>>> Fixes: 5cddbb274eab ("devlink: load port-ifname map on demand")
>>>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>  
>>>
>>> Stephen, its' almost 3 weeks since I sent this. Could you please check
>>> this out? I would like to follow-up with couple of patches to -next
>>> branch which are based on top of this fix.
>>>
>>> Thanks!
>>
>> David applied it to iproute2-next branch already
> 
> Actually, I don't see it in iproute2-next. Am I missing something?
> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/log/
> 
> Thanks!
> 

please resend.
