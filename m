Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7332191FA
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgGHVOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHVOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:14:10 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791E3C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 14:14:10 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u185so33502pfu.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 14:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7iQsxGSyEH3MyHRTG0oUTpnNA246oLU0Ge746Dv78/8=;
        b=qZHVTxc43MhkPx1WKmNbl3tL7Zswe1LC53OsLte2eZubNvuw5Y5qh8ot8X3PZKDKKO
         gXyw8AJtWbUibOF/m4VwNArf4HTup9nTkObngDUAUl6ETeRWU/xmM7sSfnoaudqrsxZU
         odBjFNu/78ZvfArllZfYQTrjaJR0JY1tczAGXj8CDbthL2bQFPgOuuGuN8w4eFRsoEie
         gYWDyYP8CrLOLmXPdHE80B5hv6ULyx6hGtztqeL2LhR2KHCZ1Dnb20ZNz3wfMfQvfDbx
         q6R3f7x/sndJLgvuzEa1aIN2zXkH1qn+kFsPG7V7HPelFfGc1DAgV+13ML1rohnt70gK
         d9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7iQsxGSyEH3MyHRTG0oUTpnNA246oLU0Ge746Dv78/8=;
        b=ioh+IfHJ9LE5rZzYGijm7scLDq5Dl03Gy8OeGgeerV8u9+6QDlZNoCmx5V+Js1+cAr
         fn4ljaM3V1V39Br9kL6RJE6l8a7RJfCLttqgjcjvdkNzjPOXO3LT9OaB+/djfbPIWcPE
         1J/xhdtUsnvzMDD6J16p7Zd9/B8FwXIHvX/+Bpc0tQAB2oXfQjI5juMyr/e4FyvpvlFf
         7EN7bgsHPfusKuk3tr7vX2JD7tH5HLuU3cwcSfMocy47qHubP+4LKUkue5HWrcG2mgDv
         rFk9BbYUyH7/SRMcHGQlEJ/+6JJZGPHlver6rTFoEQLYUNVArqHmHU5ruBfm2Ln02clb
         /lew==
X-Gm-Message-State: AOAM533ThaTaxFS/a0z1aOEiBhjaH/2efgYOfm8I6iXXl+2J05QScrOC
        3lt0VZH5SXYJJ+jM1C+L99XptaHl
X-Google-Smtp-Source: ABdhPJyQLB2xAXRinl9iDKDpCI1AFwhAHWUFYGIzK/FtC88QjWfRC7tQTVRq34tXWz64LizoQuY88A==
X-Received: by 2002:aa7:9f8f:: with SMTP id z15mr31015182pfr.73.1594242849667;
        Wed, 08 Jul 2020 14:14:09 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c15sm666774pgb.4.2020.07.08.14.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 14:14:08 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <049a23c1-a404-60c8-9b20-1825b5319239@gmail.com>
Date:   Wed, 8 Jul 2020 14:14:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 9:38 AM, YU, Xiangning wrote:
> Lockless Token Bucket (LTB) is a qdisc implementation that controls the
> use of outbound bandwidth on a shared link. With the help of lockless
> qdisc, and by decoupling rate limiting and bandwidth sharing, LTB is
> designed to scale in the cloud data centers.
> 

Before reviewing this patch (with many outcomes at first glance),
we need experimental data, eg how this is expected to work on a
typical host with 100Gbit NIC (multi queue), 64 cores at least,
and what is the performance we can get from it (Number of skbs per second,
on a class limited to 99Gbit)

Four lines of changelog seems terse to me.
