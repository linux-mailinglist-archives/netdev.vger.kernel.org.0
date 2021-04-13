Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F7235DCEB
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 12:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbhDMK4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 06:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhDMKz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 06:55:59 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1216C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 03:55:38 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o20-20020a05600c4fd4b0290114265518afso8486636wmq.4
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 03:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:subject:to:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gyk1R/2jQPlA3t+EKRdfQlscDn+3pd+/7/4XIApaYIY=;
        b=GQR9ItVP2lXEmeKH6pJq+uciicpt0/e79sg09QrjQU/vGjzbmg5bm8ehPGSfel7iw1
         n7CDZqTMCQ8LnGWXqY0YGrvvDXcpXSzR7u/uO9m72JUafzD3sBhC9IDw8iUyHj44t0i+
         tLv1D/KPWRJ7FLKjOjW2I/Ml7XdDWzZbSlVIQh34pUOqXesQgUV2aizs5BV3MOSrgSOn
         /FLZGAOxyiP5oHSZXKZcTbI1bPN5WUE1GY0SRNBjvPP5b2+/pdDnj0yz4DgkGASqNsez
         wl5E3vgz15+3wZezXpYn+4yiMvWIhvi78Alr/QIfmC0Qz9w2+2ySeQkxaLhPDFQdj4wA
         +fEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:to:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gyk1R/2jQPlA3t+EKRdfQlscDn+3pd+/7/4XIApaYIY=;
        b=JPf+LFBetksD8+QS/8vnuTAB+FnAuH048wRD3+7Z9HrvhtzYNdRHtfgKa017qe+qUq
         TF7sRwdJZYrVVI8SVj/s/nQKMUXvUaplrJ7VX4hM8WA5Y/XZQ4GoQMuekyqyUxfYcUYa
         6V8BsXhnYvDp+7ntFWU+z8fKqxWLQ09g4BV4P8Syb1/gJEAfFK6Srn/gnXWrTgD7mJFC
         MnloS7eu8fpAR9B4Pv/wbd6TqsU0qUQlDRjN3F8zDnj8T2ZTDa/pSF57iqN2De1NcLyP
         njyBKtd5meXBY26iJ7+s9oT9R2ESDWpkOsqzfgQjdfF1QiMi+5g1+mnA1GvRX8P/Mi83
         2/DQ==
X-Gm-Message-State: AOAM530hEWEeH5F+N5oJxNuHKQ0ADgtCUAqHX7yAQPs6LtRPI9B8Tv7/
        1o3POG8V9G20HWsNYwQBKsE=
X-Google-Smtp-Source: ABdhPJyYSZuBIwhQYL7lM0XOhccS5FiKDIS28Ur5j6d3ses1tVkhHXkv8w2yLY42L9hiDUqcsDVQJg==
X-Received: by 2002:a05:600c:1550:: with SMTP id f16mr3557871wmg.22.1618311337654;
        Tue, 13 Apr 2021 03:55:37 -0700 (PDT)
Received: from [192.168.1.186] (host86-180-176-157.range86-180.btcentralplus.com. [86.180.176.157])
        by smtp.gmail.com with ESMTPSA id c8sm22243008wrd.55.2021.04.13.03.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 03:55:37 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Reply-To: paul@xen.org
Subject: Re: xen-netback hotplug-status regression bug
To:     Michael Brown <mcb30@ipxe.org>, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>
References: <afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org>
 <f469cdee-f97e-da3f-bcab-0be9ed8cd836@xen.org>
 <58ccc3b7-9ccb-b9bf-84e7-4a023ccb5c56@ipxe.org>
Message-ID: <54659eec-e315-5dc5-1578-d91633a80077@xen.org>
Date:   Tue, 13 Apr 2021 11:55:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <58ccc3b7-9ccb-b9bf-84e7-4a023ccb5c56@ipxe.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2021 11:48, Michael Brown wrote:
> On 13/04/2021 08:12, Paul Durrant wrote:
>>> If the frontend subsequently disconnects and reconnects (e.g. 
>>> transitions through Closed->Initialising->Connected) then:
>>>
>>> - Nothing recreates "hotplug-status"
>>>
>>> - When the frontend re-enters Connected state, connect() sets up a 
>>> watch on "hotplug-status" again
>>>
>>> - The callback hotplug_status_changed() is never triggered, and so 
>>> the backend device never transitions to Connected state.
>>
>> That's not how I read it. Given that "hotplug-status" is removed by 
>> the call to hotplug_status_changed() then the next call to connect() 
>> should fail to register the watch and 'have_hotplug_status_watch' 
>> should be 0. Thus backend_switch_state() should not defer the 
>> transition to XenbusStateConnected in any subsequent interaction with 
>> the frontend.
> 
> Thank you for the reply.  I've tested and confirmed my initial 
> hypothesis: the call to xenbus_watch_pathfmt() succeeds even if the node 
> does not exist.
> 
> I confirmed this with ftrace using:
> 
>   cd /sys/kernel/debug/tracing
>   echo function_graph > current_tracer
>   echo set_backend_state > set_ftrace_filter
>   echo xenbus_watch_pathfmt >> set_ftrace_filter
>   echo register_xenbus_watch >> set_ftrace_filter
>   echo xenbus_dev_fatal >> set_ftrace_filter
> 
> On the second time that the frontend transitions to Connected, this 
> produced the trace:
> 
>   set_backend_state [xen_netback]() {
>     register_xenbus_watch();
>     register_xenbus_watch();
>     xenbus_watch_pathfmt() {
>       register_xenbus_watch();
>     }
>   }
> 
> which seems to confirm that the error path in xenbus_watch_path() is 
> *not* taken, i.e. that the call to register_xenbus_watch() succeeded 
> even though the node did not exist.
> 
> 
> Other observations also seem to confirm this behaviour:
> 
> - Running "xenstore ls" in dom0 confirms that on the second frontend 
> transition to Connected, the frontend state is indeed Connected (4) but 
> the backend state remains in InitWait (2)
> 
> - Running "xenstore watch 
> /local/domain/0/backend/vif/<domU>/0/hotplug-status" *before* starting 
> the domU confirms that it is possible to create a watch on a node that 
> does not (yet) exist, and that the watch *is* notified when the node is 
> later created.
> 
>> Are you seeing the watch successfully re-registered even though the 
>> node does not exist? Perhaps there has been a change in xenstore 
>> behaviour?
> 
> So, the TL;DR is that yes, the watch does successfully register even 
> though the node does not exist.
> 
>  From a quick look through the xenstored source, it looks as though the 
> only check on the node name is the call to is_valid_nodename(), which 
> seems to perform a syntactic validity check only.  I can't immediately 
> find any commit that would have changed this behaviour.
> 

Ok, so it sound like this was probably my misunderstanding of xenstore 
semantics in the first place (although I'm sure I remember watch 
registration failing for non-existent nodes at some point in the past... 
that may have been with a non-upstream version of oxenstored though).

Anyway... a reasonable fix would therefore be to read the node first and 
only register the watch if it does exist.

   Paul

> Thanks,
> 
> Michael

