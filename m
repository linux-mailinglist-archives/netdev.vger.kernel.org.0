Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9922AAA6F
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 10:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgKHJoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 04:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgKHJoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 04:44:10 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D39C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 01:44:09 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id i19so8007184ejx.9
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 01:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=NqzS9U+QS3IP0V0izaLcyeyzRCwvQwZCD+ve+WO/lPo=;
        b=fuANvQfljCYaTnot/4xUrVG3z1cKdJ5KKWyE66/A4/63QkW653/Quws5G5JPUky1hE
         lN65vGWKrTuK11lOjwH7oXXuMaE78NWG/McS6tWv6FTfknZMJAmkawx32Q+1wI1xcDRZ
         gDuzVQXfL1P8PDhcbGV1eDDwrPoxm7Ytfb6LA9rQh4oIeLjYz5oXP9MNEQubjqKFE9L/
         jHi61tHXLvHIpggoK270tqyKgHN0xV6mo+mOwR+PWdL+UKZS1x6KS3IlN3YuCByn4sux
         zV4JZn1G419TSrqfKEUL2trPl1hY4etz2xCr4QF2i69AgETIx0d9kmgLeoLr/8fu8w2I
         C9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NqzS9U+QS3IP0V0izaLcyeyzRCwvQwZCD+ve+WO/lPo=;
        b=aTy/fsqmWED+lUiCTNHdrXuhuetLbrQVE8oDddf3qkbWDaTYq5K1Ba3xSqe9gDYt9A
         JXOTC9NfXKLCXyoJXanXGrg8XVMcuUTtC3/MfCXanqvsWadFA48YKcQtWEaaFjpCad8p
         BijrfrEFDy97oYmL+J8CuNhVJbA5xuyZ0Ywx+YwjGmQzOxxuC4Fmtsb5PL9B64oQuzMg
         vh1jgD7hFYm/BIOTGGz2b+gLwdFVwovIIcmnPF03mB3juh9upIeqe7RAibg12A/MT54y
         134BmjxYads5pe0fPbrBa1OS5UFYI6ihLFsiiJpuX8XovexuwDllCXYCpMmH/a4JDddU
         K4Tw==
X-Gm-Message-State: AOAM533TQGOxt11KtENisYdLRUhiKc3v3nu2UJHqfdR7VXIMOChc+6eo
        QWH0mOBjSaVdA/Q47jy3MoRAOsJTFAYyTQ==
X-Google-Smtp-Source: ABdhPJyibw5wtNj0Zwr9hH+v06TvP7u+Tyg8yIDZOsxh8GHanFBVO0mxdO4JhSfZNzfLXCMYMpfFZA==
X-Received: by 2002:a17:906:4104:: with SMTP id j4mr10399207ejk.439.1604828648586;
        Sun, 08 Nov 2020 01:44:08 -0800 (PST)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id us11sm5617067ejb.91.2020.11.08.01.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 01:44:07 -0800 (PST)
From:   Boris Pismenny <borispismenny@gmail.com>
Subject: Re: [PATCH net-next RFC v1 06/10] nvme-tcp: Add DDP data-path
To:     Sagi Grimberg <sagi@grimberg.me>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-7-borisp@mellanox.com>
 <5a23d221-fd3e-5802-ce68-7edec55068bb@grimberg.me>
Message-ID: <12692704-126a-4242-f0a9-f00db6071e40@gmail.com>
Date:   Sun, 8 Nov 2020 11:44:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <5a23d221-fd3e-5802-ce68-7edec55068bb@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/10/2020 1:29, Sagi Grimberg wrote:
>
>>   static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>> @@ -1115,6 +1222,7 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>>   	bool inline_data = nvme_tcp_has_inline_data(req);
>>   	u8 hdgst = nvme_tcp_hdgst_len(queue);
>>   	int len = sizeof(*pdu) + hdgst - req->offset;
>> +	struct request *rq = blk_mq_rq_from_pdu(req);
>>   	int flags = MSG_DONTWAIT;
>>   	int ret;
>>   
>> @@ -1123,6 +1231,10 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>>   	else
>>   		flags |= MSG_EOR;
>>   
>> +	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags) &&
>> +	    blk_rq_nr_phys_segments(rq) && rq_data_dir(rq) == READ)
>> +		nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id, rq);
> I'd assume that this is something we want to setup in
> nvme_tcp_setup_cmd_pdu. Why do it here?
Our goal in placing it here is to keep both setup and teardown in the same thread.
This enables drivers to avoid locking for per-queue operations.


