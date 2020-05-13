Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D113B1D04D2
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgEMCVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgEMCVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 22:21:49 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AFAC061A0C;
        Tue, 12 May 2020 19:21:49 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id c64so15877109qkf.12;
        Tue, 12 May 2020 19:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GGhhasXuuhbZjHtgDHKIzfraEsH+O3PDW7OXcZoDnTg=;
        b=ljrH8A9jIhOz1bLzUXsd4W/0wzUcVOq7F66qXSqMsIz7LCMRUnWeIkJLbQ6FwolPtN
         d0HDeiJ1aITAaRZG2HoExZkhsZ7ivor5BuZlleh8DY7Z7R+T2kzdY+bZ+ZaOciEk7HRt
         HOGV3IIK3BfG2dwXq4htDjuiHhPcNV4HPI7VxM2DIWelLCBnkJInihhUMXWXZlpL1Ekk
         3IJXp4HW7dTqIJNuYNkEyjEKklU98PsaQHEn8cw7Hev00thiSSRCaknX/qseY1+/hEqi
         Tgxl03vLRjxgRtQ1xwaKae3amlcgo6dJcNNcTGX+jRUIqlL0mb9aipcU3FVTvFjVK0li
         P0iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GGhhasXuuhbZjHtgDHKIzfraEsH+O3PDW7OXcZoDnTg=;
        b=jfZYpuSX86/ycpjmSBhHoB2T/EpJpNl2e7ooLOsr5EkhKj3yilcZXznMb5ZbhXNq+H
         LZ5rcZRyyQK5vQx2h+M3CT3cQFxfFh6SstVAU2/4n/XX4I0KqC7Lyvxw0u+ZAVal1iTM
         eUfgrnz/xoS8HLOlvo8uFrmaDpifvGA2YJyEzVX/hWzffGYs6iEPFr3qTe/UTrhfYWTY
         DrypL+wf5KsXi9TtzSR7vHX4Hz8sCjgDGMl4MIDFZXsG3gBqJpIbPrR9IKfiLajdG9Ky
         pfh2i6hkoQpBMWgNorhNWeq1mGO/GpuFrAhj5PLFNgffMSH/82Z2kyLo4ppnu0DKFNLJ
         9tsA==
X-Gm-Message-State: AGi0PubgZAfEwhTti4ID5Oqrc+z4UTuXIurumgnUyJqrGcqJKkasxUnX
        h/GsA9ICaMs+g07jJiEG5VzA2KAF
X-Google-Smtp-Source: APiQypKu8v/2I7/OWB4sgxAbXpPmJJqNhaNw8iT27Qit56iaxZo5BPkP/W1EOP1fqwvwAbIEAWr7eg==
X-Received: by 2002:a37:8302:: with SMTP id f2mr23347571qkd.220.1589336507479;
        Tue, 12 May 2020 19:21:47 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4082:2138:4ed8:3e6? ([2601:282:803:7700:4082:2138:4ed8:3e6])
        by smtp.googlemail.com with ESMTPSA id y23sm14321189qta.37.2020.05.12.19.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 19:21:46 -0700 (PDT)
Subject: Re: [v5,iproute2-next 1/2] iproute2-next:tc:action: add a gate
 control action
To:     Po Liu <Po.Liu@nxp.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, stephen@networkplumber.org,
        dcaratti@redhat.com, davem@davemloft.net, vlad@buslov.dev,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com
References: <20200506084020.18106-2-Po.Liu@nxp.com>
 <20200508070247.6084-1-Po.Liu@nxp.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5b3606fc-6903-da8b-94c6-b93eac1308f7@gmail.com>
Date:   Tue, 12 May 2020 20:21:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508070247.6084-1-Po.Liu@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/20 1:02 AM, Po Liu wrote:
> Introduce a ingress frame gate control flow action.
> Tc gate action does the work like this:
> Assume there is a gate allow specified ingress frames can pass at
> specific time slot, and also drop at specific time slot. Tc filter
> chooses the ingress frames, and tc gate action would specify what slot
> does these frames can be passed to device and what time slot would be
> dropped.
> Tc gate action would provide an entry list to tell how much time gate
> keep open and how much time gate keep state close. Gate action also
> assign a start time to tell when the entry list start. Then driver would
> repeat the gate entry list cyclically.
> For the software simulation, gate action require the user assign a time
> clock type.
> 
> Below is the setting example in user space. Tc filter a stream source ip
> address is 192.168.0.20 and gate action own two time slots. One is last
> 200ms gate open let frame pass another is last 100ms gate close let
> frames dropped.
> 
>  # tc qdisc add dev eth0 ingress
>  # tc filter add dev eth0 parent ffff: protocol ip \
> 
>             flower src_ip 192.168.0.20 \
>             action gate index 2 clockid CLOCK_TAI \
>             sched-entry open 200000000ns -1 8000000b \
>             sched-entry close 100000000ns
> 
>  # tc chain del dev eth0 ingress chain 0
> 
> "sched-entry" follow the name taprio style. Gate state is
> "open"/"close". Follow the period nanosecond. Then next -1 is internal
> priority value means which ingress queue should put to. "-1" means
> wildcard. The last value optional specifies the maximum number of
> MSDU octets that are permitted to pass the gate during the specified
> time interval, the overlimit frames would be dropped.
> 
> Below example shows filtering a stream with destination mac address is
> 10:00:80:00:00:00 and ip type is ICMP, follow the action gate. The gate
> action would run with one close time slot which means always keep close.
> The time cycle is total 200000000ns. The base-time would calculate by:
> 
>      1357000000000 + (N + 1) * cycletime
> 
> When the total value is the future time, it will be the start time.
> The cycletime here would be 200000000ns for this case.
> 
>  #tc filter add dev eth0 parent ffff:  protocol ip \
>            flower skip_hw ip_proto icmp dst_mac 10:00:80:00:00:00 \
>            action gate index 12 base-time 1357000000000ns \
>            sched-entry CLOSE 200000000ns \
>            clockid CLOCK_TAI
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> ---
>

applied to iproute2-next. Thanks,

