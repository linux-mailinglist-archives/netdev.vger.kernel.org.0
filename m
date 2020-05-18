Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20EE1D7C13
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 16:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgERO7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 10:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERO7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 10:59:45 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531C0C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 07:59:45 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id z80so10392585qka.0
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 07:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zsu10hDoLE9FRHXF2sBwwgeh8A3XOKa2vQ0+Jpk3aZs=;
        b=hBeLCKujzj3Wqj07xwT6+hLZwL138MGJLOHWaUmopBvnH1UwLXOcJ/J4GH1SlgVDtF
         WVoSJdoy4kBTA5CVqEjilFtlQJU8b72CVbt7drQ+0HWrCAscDqWzFzcNWeWSrsgvuz5c
         bZD7gnD8bk01Zi7YPmWO/NoigINjvNB33RiW5aSr4citqZ0aIQLwNXEaR+TqDIOGk0zj
         o1+cBl9vYLOHjbpTyutlGr1ODVQGTA+49BWmxbZva/gzUtQxLbRxuzf7kp/zR/BeJ1qj
         1cq5N6O1+5y3+ZGgoPFQgr5fCGoBQoLyFdYoF7eygOdHldCzvsbrSmVQbylZdcPyf1t0
         VtSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zsu10hDoLE9FRHXF2sBwwgeh8A3XOKa2vQ0+Jpk3aZs=;
        b=Q9BLv043P7D/2SfYHiSWWAuXcAGuw+DkGrjIEiqpEAch32juRB/IyrdfZ/k94vCnua
         wJesTSesL8eW66bDl2NGut6UrpOB6aOUvHZDM810skppcaUFIYj+TRBXZbf767tuDYvq
         Xy9ANrJ9DdT9FBbJ0b0dWvzWV1v/KhduT/bX7KFio0G1IAj/AGt9omINlHkio69q7hnR
         a+XfcT0wSWxqtSFQV21laVp1n4NU8JHok69tDltIvAj/PgusUqFnpaTFehpRyrOd1550
         PpabbrtnfRD7hdZ1bMgslSYoM00VTC5HXGDDjywOvk6wCSlcejhLnP5RdHtrQ8cVvVf2
         Fwug==
X-Gm-Message-State: AOAM533G/rJ54WuREXDRY7c/qci79qhAFoI81QIenELlD1UqjXwZGEVB
        D3XKrAMgsxJUH2Se269X1+TM3hJT
X-Google-Smtp-Source: ABdhPJwy1SGbVVwDZ66n4mFOEAyaDNv59JngTy9aYppQcKNa6gFepHmvCIfmcVQtKL3WdXs0qHwhUA==
X-Received: by 2002:a37:8782:: with SMTP id j124mr16732767qkd.349.1589813984126;
        Mon, 18 May 2020 07:59:44 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f866:b23:9405:7c31? ([2601:282:803:7700:f866:b23:9405:7c31])
        by smtp.googlemail.com with ESMTPSA id q17sm8460607qkq.111.2020.05.18.07.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 07:59:43 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc: mqprio: reject queues count/offset pair
 count higher than num_tc
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, kiran.patil@intel.com
References: <20200513194717.15363-1-maciej.fijalkowski@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <231c5b50-3709-5a2e-ce20-5a90a3c035be@gmail.com>
Date:   Mon, 18 May 2020 08:59:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513194717.15363-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 1:47 PM, Maciej Fijalkowski wrote:
> Provide a sanity check that will make sure whether queues count/offset
> pair count will not exceed the actual number of TCs being created.
> 
> Example command that is invalid because there are 4 count/offset pairs
> whereas num_tc is only 2.
> 
>  # tc qdisc add dev enp96s0f0 root mqprio num_tc 2 map 0 0 0 0 1 1 1 1
> queues 4@0 4@4 4@8 4@12 hw 1 mode channel
> 
> Store the parsed count/offset pair count onto a dedicated variable that
> will be compared against opt.num_tc after all of the command line
> arguments were parsed. Bail out if this count is higher than opt.num_tc
> and let user know about it.
> 
> Drivers were swallowing such commands as they were iterating over
> count/offset pairs where num_tc was used as a delimiter, so this is not
> a big deal, but better catch such misconfiguration at the command line
> argument parsing level.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tc/q_mqprio.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
\

applied to iproute2-next. Thanks,

