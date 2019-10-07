Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4796DCE6F6
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbfJGPMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:12:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32852 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJGPMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:12:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id i76so1244723pgc.0;
        Mon, 07 Oct 2019 08:12:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/9NiR/EGmLVvEuIyLxgqDAfTAOHQfowQ8T4gGNw66rk=;
        b=W95bIsQUy/atmVy6C+fkPjoUknE3nxFgZO9ruJ1UC+oiYxsBKOc2tqs2Jnlc6bbV0d
         EzD2C8nrA6PJk6AbBj+rQnQwSvI0sVV+6ctMKrm2WMjdelLmCqMXcJo+9Qt55L0D+XaC
         31PjiwuJbCPw2A3N08H0ElvIutTMUI3H1CyY2IuIdV2Ijd9j1mt0+ZzNSg3t7eV8/j+3
         WwzO1zV+7qQi92z2OMJ6Iz+uInNMExyMTVCnZUc/qDqlcf4jlmFV+YGqBQ7rJa+cR7IJ
         6f5ytX8hl5Ze4RdvAqD/HYeHJftRUT/vaVApSaoMV1bJNrNIotDIvpXObLyQedHOS0iK
         k+ew==
X-Gm-Message-State: APjAAAX8up7sFP1Y7vUaoiMmj2doFNbz0/9rLHalcHxF5++64/I3L0Lx
        CiGmF7Li+9u37pAzkbU4HW1g/krd
X-Google-Smtp-Source: APXvYqzlBwWZTtfGIcr4D5Cx6lcJ9Q+hS8B906sdGCAjE3xYhL+33BRoNAuXm8550yfZzkAD30EuxQ==
X-Received: by 2002:a63:2016:: with SMTP id g22mr2288585pgg.158.1570461159359;
        Mon, 07 Oct 2019 08:12:39 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id i190sm7575369pgc.93.2019.10.07.08.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 08:12:38 -0700 (PDT)
Subject: Re: [PATCH rdma-next v2 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-3-leon@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <04420039-1877-c35d-83ce-b7365c1e6b65@acm.org>
Date:   Mon, 7 Oct 2019 08:12:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191007135933.12483-3-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/19 6:59 AM, Leon Romanovsky wrote:
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 4f671378dbfc..60fd98a9b7e8 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -445,6 +445,8 @@ struct ib_device_attr {
>   	struct ib_tm_caps	tm_caps;
>   	struct ib_cq_caps       cq_caps;
>   	u64			max_dm_size;
> +	/* Max entries for sgl for optimized performance per READ */
                                    ^^^^^^^^^
                                    optimal?

Should it be mentioned that zero means that the HCA has not set this 
parameter?

> +	u32			max_sgl_rd;

Thanks,

Bart.
