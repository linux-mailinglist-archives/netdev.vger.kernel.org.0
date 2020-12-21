Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2850A2DFC21
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 14:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgLUNBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 08:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgLUNBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 08:01:13 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56B8C0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 05:00:32 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id 186so8624365qkj.3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 05:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1bfoGOpJts7jaVWLrYThHJnE3Hjye0rclWOun0MdVuI=;
        b=gq8AxiPdrhZAFV/+9bswUF8u6F7YLtuabgKaboFK4nurUWIDGR4Y+Cg7KouefoLG4t
         /dLHKupZO2KkySj5/GJizJJmes0ZTEvKe11MWWoUTg2MU4LppsBhueMdmTCmLImbW9g/
         ea6DFGa/VC9YVkIJrbuwU9B31Fc1sYm9GmYGER2GgL6HMWkcxsLgmFwDsxKFWuKL3UNe
         zCCipXeu9QLwCUmlVXosQMeDpDbI3naEuhihA+UPdE7rwiOgyQMs9OfhBMd4QGjkHBaV
         liU3un0js/RBN9NB4m+5lkPtTCWbJjU+lkpHK6BJEKyXKE5sPVdM7b1IAQNtS82hyohG
         94vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1bfoGOpJts7jaVWLrYThHJnE3Hjye0rclWOun0MdVuI=;
        b=EhWO6K9gwNPIo66fur01ZRJzKUcHRS/39fTXpf5qqxxZexAZstnJyiCbbTWt9NW1XU
         PfycNq2+P/bFOe6dOJ9aA91/+YOVvgW1ZKlGYJi6WTtwgxGktTcM+ZJB/OXo2FyqYW9k
         TVMCs92+qx+2w08hPxlaZMoI15POpBGgxiwtaZc7h2rbj17lVZJZEA8hAU4iF5bvl6ri
         RvThYyL7KQWrHz35FkRyafAgsZMdmzYIQPVbBatvgwc4vc3Dkgc4GrLLKQcS3djo6nun
         zNFw2PAymm4tebfmojFks/C0Zt3LXGeRKB2T/ciA4Fxm1O1NRFpT3oBstvXIYXaNTXcI
         eICg==
X-Gm-Message-State: AOAM531A25mZV2Brvm9x2o3OvCwgbiI7E7jr+YBwPfvKBjBpYZfWYO9H
        wi/NofdPI0GzXCzKhUiNEkTutg==
X-Google-Smtp-Source: ABdhPJzvIlGiY8gz/R5rJyoN53CSLcFCkOP2l5RsSai5M3qf2GfskqoTGcfovPIvZt2xcdJCzbmsRg==
X-Received: by 2002:a37:6382:: with SMTP id x124mr16619138qkb.398.1608555631945;
        Mon, 21 Dec 2020 05:00:31 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id w33sm9350850qth.34.2020.12.21.05.00.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 05:00:30 -0800 (PST)
Subject: Re: [PATCH v5 bpf-next 03/14] xdp: add xdp_shared_info data structure
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, echaudro@redhat.com,
        jasowang@redhat.com
References: <cover.1607349924.git.lorenzo@kernel.org>
 <21d27f233e37b66c9ad4073dd09df5c2904112a4.1607349924.git.lorenzo@kernel.org>
 <5465830698257f18ae474877648f4a9fe2e1eefe.camel@kernel.org>
 <20201208110125.GC36228@lore-desk>
 <pj41zlk0tdq22i.fsf@u68c7b5b1d2d758.ant.amazon.com>
 <1b0a5b59-f7e6-78b3-93bd-2ea35274e783@mojatatu.com>
 <20201221100152.58fa6bd7@carbon>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <c7434cfc-66ed-8795-06b1-ec296eefc484@mojatatu.com>
Date:   Mon, 21 Dec 2020 08:00:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201221100152.58fa6bd7@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-21 4:01 a.m., Jesper Dangaard Brouer wrote:
> On Sat, 19 Dec 2020 10:30:57 -0500

>> Sorry to interject:
>> Does it make sense to use it to store arbitrary metadata or a scratchpad
>> in this space? Something equivalent to skb->cb which is lacking in
>> XDP.
> 
> Well, XDP have the data_meta area.  But difficult to rely on because a
> lot of driver don't implement it.  And Saeed and I plan to use this
> area and populate it with driver info from RX-descriptor.
> 

What i was thinking is some scratch pad that i can write to within
an XDP prog (not driver); example, in a prog array map the scratch
pad is written by one program in the array and read by another later on.
skb->cb allows for that. Unless you mean i can already write to some
XDP data_meta area?

cheers,
jamal
