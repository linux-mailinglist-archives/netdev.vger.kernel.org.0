Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016EA485679
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 17:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241832AbiAEQJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 11:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241867AbiAEQJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 11:09:36 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AB1C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 08:09:36 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id b1so31376063ilj.2
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 08:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Wdmf1W7IdPkoLg+CzEWdA2Q4oruwS0oQUJXzqRWu1GU=;
        b=EHCekrYd8LhVErlN83VhCaDzUnWMoTe+eSUsPgIPjLdpQ7hnsxhu7gnPZCWblZVLFi
         S2+q6RSllVROmlGskZMAwajNZblSuSbmvGWDDqwqmRZgzu3lT5Kg3GVSRhoJeAb6FviG
         fboTk4I0e+hRONxX2dEI0MBNSncno+4l/rNYW19bI0kdEgYIOxNLKvGzHlR6UX22Xfs+
         g2KSUck0SVWjM93Ef2ibhACQwv9slDIrAwgGdI4DYvu8S20z+dkxne/y5gPLcgHxQTqa
         ZTCwYBsElgfMLEhxD7fTheoy4qRmwTrfqRpoQribdMSrQfj08UvfWf/pE3E7PLExjrf+
         REGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Wdmf1W7IdPkoLg+CzEWdA2Q4oruwS0oQUJXzqRWu1GU=;
        b=cPL0KDU5N4+c4Xv0jOHcxEN0SxifhPdYnbdPqlXz1nrzDpEcVBRkYfse4zkEFNXYPS
         gnUTRS2cWsJ8yqfD0KbuGeEttakGDPposJL3enw4cRH6D32W3ZoSWg5UY78HmjeVuV0/
         SSdPdCxPPRoHlfdoTUxK0UlP2YGyBhN6u+2MJetwfLARjJpAETiaWmbj+ixoki0WVnjv
         WQkSls3OqNF4ATXADodYECNlDNsMkZaMAdT1OouvJiBiByf3G/ZyNQuocnqRqAeXBYOi
         U3ufT/OfGmvqVKHbVetY75VeIu0zmXi+jA1ohtjzdftyQfARC4uoVbhA4zWaONv2CHsJ
         e2Dg==
X-Gm-Message-State: AOAM530jA6A5K5gxjbM9cKfakzqkoxLMZfRhC8YLLY1E4mkzCxFcRPdv
        HNMobqmZ7pzOqIfOytJBp/0=
X-Google-Smtp-Source: ABdhPJy7X+eRu3P9VPg7yo0Fl2pZymflsUscpztULcTvBYaU1HIoSdo+2uNWEXB5jdXOovnv4iYhLQ==
X-Received: by 2002:a05:6e02:148c:: with SMTP id n12mr26546682ilk.51.1641398976033;
        Wed, 05 Jan 2022 08:09:36 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id l12sm14575176iow.19.2022.01.05.08.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 08:09:35 -0800 (PST)
Message-ID: <269e52cd-2d84-3bca-2045-b49806ba6501@gmail.com>
Date:   Wed, 5 Jan 2022 09:09:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v6] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
From:   David Ahern <dsahern@gmail.com>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@idosch.org,
        nicolas.dichtel@6wind.com, nikolay@nvidia.com
References: <20220104081053.33416-1-lschlesinger@drivenets.com>
 <66d3e40c-4889-9eed-e5af-8aed296498e5@gmail.com>
 <20220104204033.rq4467r3kaaowczj@kgollan-pc>
 <df31afed-13a2-a02b-a5f8-4b76c57631d3@gmail.com>
In-Reply-To: <df31afed-13a2-a02b-a5f8-4b76c57631d3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/22 5:18 PM, David Ahern wrote:
> On 1/4/22 1:40 PM, Lahav Schlesinger wrote:
>> I tried using dev->unreg_list but it doesn't work e.g. for veth pairs
>> where ->dellink() of a veth automatically adds the peer. Therefore if
>> @ifindices contains both peers then the first ->dellink() will remove
>> the next device from @list_kill. This caused a page fault when
>> @list_kill was further iterated on.
> 
> make sure you add a selftest for the bulk delete and cover cases with
> veth, vlan, vrf, dummy, bridge, ...
> 

BTW, delete of a netdev clears out neighbor entries, network addresses,
routes, hardware updates, etc. with lots of notifications to userspace.
Bulk delete of 1000s of netdevs is going to end up holding the rtnl for
a "long" time. It would be good for the selftests to include a cases
with lots of neighbor entries, routes, addresses.
