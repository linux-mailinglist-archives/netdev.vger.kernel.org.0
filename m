Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038253D133A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhGUPYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbhGUPYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 11:24:21 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702F7C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:04:57 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id z9so2540641qkg.5
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JV9VMqj3df1yfOSic0Q0B2vsE9Jz6Xq7DcAZSDfbsYQ=;
        b=1niBHiVqeHeuU+//qLyYm2BizEzLgZCAx6jBX2Ap4JJImEaGiYHocOesxPMHc3Efme
         vuItUsCNQM555NfmdAOdupCdPohf9XYxi4HHyu3dSmIQY1xWHSkr0t6XJPYlitTRidoH
         vDMd4nVUAia7k4xNK4QiGjn8Fc80a8K48ihnVfZyhTYXws+1WidnIkz+ZdU5GpdcPEzM
         kM4XLqFiJilLVEu7c4Pkz6o0Cl0fOFTnTJeLEKUrnFLJvl7UL9MLWybLvvwBqju3Y9oi
         Q7GqfwVUas7BsJmGVeKnTJ8skRJH5n30zRNtC9gnk1Okansp0hcweErZMOpdTOvGMKWz
         adBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JV9VMqj3df1yfOSic0Q0B2vsE9Jz6Xq7DcAZSDfbsYQ=;
        b=h9I2/ZUvo8PzaFQO8P9aAxtvN8C6qh9yvcbgXP4p2tyt7G7+7VTOKvDkeXxUY5TA4N
         RY93z99hEzw0alhUHUcALfXvPoVugQvVUI/fs448Hssz/0GFVRAgCckpdyhL6SsfSsj+
         iST2oMKOxXKPZfCXk6+AT/F24GC0ic2ej6UwSqA1ZkUeSs+O9FOJbB1uwvPxYgL2HBay
         c0t3+bEsqTR9QWRf7K/1hmliPgFftCdhgP0UBfYr41D0Q99Fqm4uzCwZI8mVahDASR2B
         3HVqWyOEhOhyv2QOJruCKZtSXJO4gYLD9KJ3hr8xgnOjBUZzEz3CDxtufJ3mAc3XaFzw
         YvAQ==
X-Gm-Message-State: AOAM530iFotK6QzZamfVuPMDWklhh/lvhwMghwLEae9Fq22g7V+INRKT
        nd6gZewWm29Yj4KPXkIPk7GgMA==
X-Google-Smtp-Source: ABdhPJwto4Z+BXIrGNiPYKujhMxAFPJMGc+lx8H346AjxNU1LZd87c4cj3qJIEgC1Y/Ot38IR4XfeQ==
X-Received: by 2002:a05:620a:1fc:: with SMTP id x28mr416046qkn.84.1626883496682;
        Wed, 21 Jul 2021 09:04:56 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id h10sm11233396qka.83.2021.07.21.09.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 09:04:56 -0700 (PDT)
Subject: Re: [Patch net-next] net_sched: refactor TC action init API
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>
References: <20210720233454.8311-1-xiyou.wangcong@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <9e6cd365-fda6-7329-78ad-e0ebe9068f28@mojatatu.com>
Date:   Wed, 21 Jul 2021 12:04:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720233454.8311-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-20 7:34 p.m., Cong Wang wrote:
> From: Cong Wang<cong.wang@bytedance.com>
> 
> TC action ->init() API has 10 parameters, it becomes harder
> to read. Some of them are just boolean and can be replaced
> by flags. Similarly for the internal API tcf_action_init()
> and tcf_exts_validate().
> 
> This patch converts them to flags and fold them into
> the upper 16 bits of "flags", whose lower 16 bits are still
> reserved for user-space. More specifically, the following
> kernel flags are introduced:
> 
> TCA_ACT_FLAGS_POLICE replace 'name' in a few contexts, to
> distinguish whether it is compatible with policer.
> 
> TCA_ACT_FLAGS_BIND replaces 'bind', to indicate whether
> this action is bound to a filter.
> 
> TCA_ACT_FLAGS_REPLACE  replaces 'ovr' in most contexts,
> means we are replacing an existing action.
> 
> TCA_ACT_FLAGS_NO_RTNL replaces 'rtnl_held' but has the
> opposite meaning, because we still hold RTNL in most
> cases.
> 
> The only user-space flag TCA_ACT_FLAGS_NO_PERCPU_STATS is
> untouched and still stored as before.
> 
> I have tested this patch with tdc and I do not see any
> failure related to this patch.
> 
> Cc: Vlad Buslov<vladbu@nvidia.com>
> Cc: Jamal Hadi Salim<jhs@mojatatu.com>
> Cc: Jiri Pirko<jiri@resnulli.us>
> Signed-off-by: Cong Wang<cong.wang@bytedance.com>
> ---

Looks good to me.
Acked-by: Jamal Hadi Salim<jhs@mojatatu.com>

cheers,
jamal
