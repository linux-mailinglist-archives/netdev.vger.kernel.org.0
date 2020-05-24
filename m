Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7E01DFEF2
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 14:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgEXMgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 08:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgEXMgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 08:36:44 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD45C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 05:36:43 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h10so16183065iob.10
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 05:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=e1VHJxKoXYaS6aGUYqj2LiAO7erpHlAjFqD5QRIADoY=;
        b=kWfgLcjl1wDha7dLXnrtS96vlQz4+36zAgJd3j7yjl7+PdErL0POSdnkOY0+nr2b6V
         whH175h2/vsVIaQql9jAouXKN2xJ2PprzACzSsosKVgGibnyCOoHKRB+MlJO5N0qGH40
         Mpy8qS0TXz3jHC/Q4lCwIkmiMLBsZkMOOrB9F/KfjNDbZ3UWeA+dukk+vm/NWYJGTt+J
         O/pRQbSqOEpf/N8oSSlM4yy0GejxP6A1F799JhZzl7OjPDwqWZmpmZdRKWDwIQoedMbt
         pveexUs9y4L9drEnhIn7HAfxDPHCOsLaJbLSwNaIrC+eA7FBvC0uB8ul8bZoPin3pY4A
         1ASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=e1VHJxKoXYaS6aGUYqj2LiAO7erpHlAjFqD5QRIADoY=;
        b=A9HFL5zmv2eHAVLFWU9jEgGTWHnD55Vzn55JSHEUvDYoflcYrPc9NuPgtkfoNmFKFF
         X2hq01mOCpIsK1vXR0VQMuNBTwpAZbk+9+vn/H9XQShkgZPm5zMB7u/SnHhRF9uz+T8k
         q2Y17OhRxE9iG+H2EKYR2hGl/j4aKxTOktobBWrGIec4o6DJ0zWr5wACGQbBZMNtpyBd
         pSOMRtH2HaRBV7DWJ5HAe0l9dlqffCD416ZdX2gbw7uUmbqrogUOrdiE4TFGh+98MC/4
         hlwKavVpMCsG84wbAf3VxUGb7c/GSbIyP2EosLEwtjyODs/5K5ybcThsZw4D+smC5p+c
         SC7A==
X-Gm-Message-State: AOAM533LW6vyvJR5yRLc1vWo+SHlCmyGLta6h89cP/UbzW5PUMJSRN7N
        akEwecgNhJms53jkD90PH5H3yA==
X-Google-Smtp-Source: ABdhPJztCq/lLe9mA1v1eUYRxftDoz2e+5AsjomHm0FEkZzkEn3bFjXG1YYqgHQLT0RBWJpZ0VDJVA==
X-Received: by 2002:a6b:8b12:: with SMTP id n18mr8055705iod.160.1590323803355;
        Sun, 24 May 2020 05:36:43 -0700 (PDT)
Received: from sevai ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id v18sm7780850iln.1.2020.05.24.05.36.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 05:36:42 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        kernel@mojatatu.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH iproute2-next 1/1] tc: report time an action was first used
References: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
        <6619cab4-02bb-51e7-0c2c-acb0cb13d022@gmail.com>
Date:   Sun, 24 May 2020 08:36:28 -0400
In-Reply-To: <6619cab4-02bb-51e7-0c2c-acb0cb13d022@gmail.com> (David Ahern's
        message of "Tue, 19 May 2020 12:11:28 -0600")
Message-ID: <851rn9ik6r.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 5/17/20 7:28 AM, Roman Mashak wrote:
>> Have print_tm() dump firstuse value along with install, lastuse
>> and expires.
>> 
>> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
>> ---
>>  tc/tc_util.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>> 
>
> I can merge master once Stephen commits the bug fix. Then resubmit this
> patch.

Hi David,

Stephen has commited the fix, please merge the master branch and I will
resubmit the patch.
