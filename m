Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A422F6CDF
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbhANVIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:08:21 -0500
Received: from mail-pl1-f178.google.com ([209.85.214.178]:37855 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbhANVIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:08:21 -0500
Received: by mail-pl1-f178.google.com with SMTP id be12so3562660plb.4
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:08:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DVg1oNfEVBgfvsUX222J2RVxfLhd7d7Ta6Z42Snkcqo=;
        b=FpFoUC34c9c3GGQUNbKfNcOCfEIpx5p+tHbJwinVVuzzWzjAm4uj4lhJOGbIx1S1fd
         ag/zOtt7ywBBGvH1nA6YOVxjuFvD2CHSeRFaV3yUPXS5xa2rrmtf2TiW9EgLdah86YFb
         m/HgrPxj0NcHpmSyLeHsPQl+7OoIt/jQdxg/rpOyewf6nynVAKcXVShvnt2niHSEXpSP
         fggJOjTHzkonPn0B+Y8ZKRvWCeAm98UNuXW9onsQeQhdLJGZ8irOQCzuiOoafzaicLV/
         RGM19XX61uSMxoxbOG6BOeXYRApk/wA+LSkD5WJlB0HO2VwDG52ZC2cyZCCF0Gkdh1ee
         2NPQ==
X-Gm-Message-State: AOAM5301E1G7N/qhloZT+hN1MJOuJaMtLjdGoegpEWi5hqZZN9Cvm3Fb
        h1nkLVPBIerBzY4efsAmRa4=
X-Google-Smtp-Source: ABdhPJyiuuEDPj6uI3yVSujW4SS4ixWBdszT3qqJdtpd7o/NMXWt4Di4hauPFp+ZrazDE1BNdiFfpA==
X-Received: by 2002:a17:902:6b0a:b029:dc:31af:8dc3 with SMTP id o10-20020a1709026b0ab02900dc31af8dc3mr9344603plk.41.1610658460210;
        Thu, 14 Jan 2021 13:07:40 -0800 (PST)
Received: from ?IPv6:2600:1700:65a0:78e0:9240:50d6:cd00:1b14? ([2600:1700:65a0:78e0:9240:50d6:cd00:1b14])
        by smtp.gmail.com with ESMTPSA id h5sm6612194pgl.86.2021.01.14.13.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 13:07:39 -0800 (PST)
Subject: Re: [PATCH v1 net-next 00/15] nvme-tcp receive offloads
To:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     yorayz@nvidia.com, boris.pismenny@gmail.com, benishay@nvidia.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        ogerlitz@nvidia.com
References: <20201207210649.19194-1-borisp@mellanox.com>
 <69f9a7c3-e2ab-454a-2713-2e9c9dea4e47@grimberg.me>
 <6b9da1e6-c4d0-7853-15fb-edf655ead33f@gmail.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <02f12db0-4f66-8691-72cb-7531395c7990@grimberg.me>
Date:   Thu, 14 Jan 2021 13:07:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6b9da1e6-c4d0-7853-15fb-edf655ead33f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> Hey Boris, sorry for some delays on my end...
>>
>> I saw some long discussions on this set with David, what is
>> the status here?
>>
> 
> The main purpose of this series is to address these.
> 
>> I'll take some more look into the patches, but if you
>> addressed the feedback from the last iteration I don't
>> expect major issues with this patch set (at least from
>> nvme-tcp side).
>>
>>> Changes since RFC v1:
>>> =========================================
>>> * Split mlx5 driver patches to several commits
>>> * Fix nvme-tcp handling of recovery flows. In particular, move queue offlaod
>>>     init/teardown to the start/stop functions.
>>
>> I'm assuming that you tested controller resets and network hiccups
>> during traffic right?
>>
> 
> Network hiccups were tested through netem packet drops and reordering.
> We tested error recovery by taking the controller down and bringing it
> back up while the system is quiescent and during traffic.
> 
> If you have another test in mind, please let me know.

I suggest to also perform interface down/up during traffic both
on the host and the targets.

Other than that we should be in decent shape...
