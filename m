Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB7110A653
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfKZWEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:04:54 -0500
Received: from mail-pj1-f41.google.com ([209.85.216.41]:39316 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZWEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:04:54 -0500
Received: by mail-pj1-f41.google.com with SMTP id v93so5664846pjb.6
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 14:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mcXFt4fBaTESidGMV+5Gedmq0EKE4Gt/Yw9WRe9am+A=;
        b=BYkXeSeIKprCduhHs3cmnBarcMTjQUC0O/6QiFwjKLSH9XwVnq/yAgL8t2KtITLgmq
         uJKIntixsL1VFq3BP7NrpI3DTDMp88GJmZMnmZwkupx3Dt62ImH2fhQH7Ra68izKfLj7
         9ajwrRdqq0YOA9dpGTi30emowwZhm6gKIWxvocHodI7DqWcXctjzynk6rs4PglxjU5PE
         otc2/3UXtZacS8jjibBdfu27QK6g1OTRj7yPM4gPjl4XbS8u6is4433Xxyc14blAxVlL
         5jThXNpelcpzagb07bBKsYKCkbI4O2PxilrCao2B/jAwZ+OczhXIb9qJGRLmzUiTxC1+
         1umQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mcXFt4fBaTESidGMV+5Gedmq0EKE4Gt/Yw9WRe9am+A=;
        b=RtZeS/jBq/ACvd+VKLq/HSA4eIlQQOqev6USH1eqJUUEYecdDfLRf3S7RkYv/J0rxU
         kFQXcjJlxBvYBvvDNn2A3tiMLeaKKf7iuO+wxtiL+HliKjM6hoqmsa368B17MokHu7t8
         8Ps7VfPngt/AmIFT0saHCVg2lHda/vVr+bnoo8fnEl4nJg5/lAqBCOo4XK+r4Dyubz8P
         oABT2RZ/fpu7hQoAHW2FyPEVf22avysma0YLfY1zavlKqRw4HndXivbVBCq+6BUe5TJ+
         eryqCGz6YMzc+lpGNjTqqrxPnASAJxNKwpHKAF36ZY3TlKODtl1gK3n28yJpdlpV8QDS
         vtNA==
X-Gm-Message-State: APjAAAXaRsB7honWP8Nn4pHqZp2HJ9hv+kCok5lwuJS0+KuNMJn+xeXQ
        jtToyzJYNgS34dQ39ekWqieY/3L/FdN9ug==
X-Google-Smtp-Source: APXvYqyPTrIck6inyNd6fxFS6IM3YDRpVeINO2dAZlG4DtBb0s7dU9cO+UrIcAT6flJLSsYV7VtGXQ==
X-Received: by 2002:a17:902:8541:: with SMTP id d1mr595109plo.112.1574805892726;
        Tue, 26 Nov 2019 14:04:52 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id g26sm1298149pfo.128.2019.11.26.14.04.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Nov 2019 14:04:51 -0800 (PST)
Subject: Re: [PATCHSET 0/2] Disallow ancillary data from
 __sys_{recv,send}msg_file()
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20191126013145.23426-1-axboe@kernel.dk>
 <20191126.140039.2116411993007995978.davem@davemloft.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5dea14ec-d606-89f3-1fbf-65335121b5d7@kernel.dk>
Date:   Tue, 26 Nov 2019 15:04:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191126.140039.2116411993007995978.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/19 3:00 PM, David Miller wrote:
> From: Jens Axboe <axboe@kernel.dk>
> Date: Mon, 25 Nov 2019 18:31:43 -0700
> 
>> io_uring currently uses __sys_sendmsg_file() and __sys_recvmsg_file() to
>> handle sendmsg and recvmsg operations. This generally works fine, but we
>> don't want to allow cmsg type operations, just "normal" data transfers.
>>
>> This small patchset first splits the msghdr copy from the two main
>> helpers in net/socket.c, then changes __sys_sendmsg_file() and
>> __sys_recvmsg_file() to use those helpers. With patch 2, we also add a
>> check to explicitly check for msghdr->msg_control and
>> msghdr->msg_controllen and return -EINVAL if they are set.
> 
> For the series:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks David, added to the series.

-- 
Jens Axboe

