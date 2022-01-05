Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288A9484B98
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 01:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbiAEASP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 19:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbiAEASP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 19:18:15 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3380C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 16:18:14 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id l3so44020250iol.10
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 16:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NfB/MtJA0Kzm/Ln6KSwbz5y3JZ4mIJIUADCjE7z4mMs=;
        b=ZSDKsmPxI7vA+zJAtVZjQMY3r/gkRs3QmI4CRKV57eLMb5WAPQzllN/ElAcKOM8bg9
         bI8LL8D/gHdwpvSi04wAsW1Nqww/o7MiwpLDm9wmln9ms1uPFbqwOt2xHgEyHioaTU1C
         Fm75Uklpv0n4Pp4DNzDRldFGJUN3/JT9HwNetJPutuDxjkjx1BECLNcBoUVlfMqTlFKB
         UqHq+HrXb8q9tf4Xrsvg/P4L/DX3XbJRwlwJizKGWoDY7+DRRmckTr0f/RxjLKbqS0qI
         DahgkfT/UbiJw3tEnuEN/phU1tQ2OaCYYB2OKx6gPOAU/7QJN6BTJXBduMATkFDZJpCx
         Duvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NfB/MtJA0Kzm/Ln6KSwbz5y3JZ4mIJIUADCjE7z4mMs=;
        b=RI5up8lYSI4vP871y1e6XuwAqDNNbG9X05M3MD1E/Pr9uGzjB3fUEXOETiz8rXqFdB
         Q+K59R3g+2JysPiigf3ZXPZLctUQoPV5sCvCPXGbMORjKWtq/CaH0QfMbAZWJIyZlm7T
         BKRYRwgZUOCin9QzQOGbZ4S1MIfVc9XaKNJcpNI7KXW1Q3cBkheIT+ByN1LrpVXH+SrT
         fIo+74G3oVhx0NMwRIPPEO/0NALsPr+JM9HU39c6jH8uydfnvJHLt8gt8I+2QzeCR3Np
         dnJjqQauE+rZLPPOpDAHg7JUnBMi/i+99TN3cLsSn21iAnpJkyyPJQKZg1+ihgdGWzDe
         FgFA==
X-Gm-Message-State: AOAM531DsHyF5fjOPk/EsxAEh5pLFYO8ibUDlEUuWlJAF+TJ+vVvpePe
        meQaQflPd1pfmIuPwwR0xMQ=
X-Google-Smtp-Source: ABdhPJy/Y9u+mjQXUvKrlAezuPUhw64shTnEPKW4sA7N/MnLc/TbIqoCuf86uG9JWrLzP0snMTfZ2g==
X-Received: by 2002:a5d:8d89:: with SMTP id b9mr23374722ioj.205.1641341894232;
        Tue, 04 Jan 2022 16:18:14 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id g8sm23805086ilf.17.2022.01.04.16.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 16:18:13 -0800 (PST)
Message-ID: <df31afed-13a2-a02b-a5f8-4b76c57631d3@gmail.com>
Date:   Tue, 4 Jan 2022 17:18:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH net-next v6] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@idosch.org,
        nicolas.dichtel@6wind.com, nikolay@nvidia.com
References: <20220104081053.33416-1-lschlesinger@drivenets.com>
 <66d3e40c-4889-9eed-e5af-8aed296498e5@gmail.com>
 <20220104204033.rq4467r3kaaowczj@kgollan-pc>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220104204033.rq4467r3kaaowczj@kgollan-pc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/22 1:40 PM, Lahav Schlesinger wrote:
> I tried using dev->unreg_list but it doesn't work e.g. for veth pairs
> where ->dellink() of a veth automatically adds the peer. Therefore if
> @ifindices contains both peers then the first ->dellink() will remove
> the next device from @list_kill. This caused a page fault when
> @list_kill was further iterated on.

make sure you add a selftest for the bulk delete and cover cases with
veth, vlan, vrf, dummy, bridge, ...

> 
> I opted to add a flag to struct net_device as David suggested in order
> to avoid increasing sizeof(struct net_device), but perhaps it's not that
> big of an issue.
> If it's fine then I'll update it.

I was hoping to avoid bloating net_device with 16B that has such a
limited need. In one config I use, net_device is 2048B - a nice size and
an additional 16B makes netdevs much more expensive. A ubuntu config
comes in at 2368, so not really an issue there.

Staring at the existing list_head options close_list seems like a
candidate for a union with bulk_kill_list. If that does not work we can
add a new one.
