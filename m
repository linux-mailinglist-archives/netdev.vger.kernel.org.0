Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23325822EF
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiG0JUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiG0JUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:20:05 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08D937FB7;
        Wed, 27 Jul 2022 02:20:04 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h8so23307133wrw.1;
        Wed, 27 Jul 2022 02:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6GV9r+xMhkzrix1zVwuoFAT+2lz1nxuiG9jX5dFRLKs=;
        b=jBli6wkJvQPrlTu9I8L+7p+WAj9MTjQl4w5ECDX5sx3eT2wtgzR6bvLDoHk0lyZdCt
         gonJKGM73VpyIANTBCwXOcgi7mT1+Y6P2CkLcessQmvcQYdW2V3HB4d/rX/MSYStA5i1
         snT/HQWrN8Ep6AR+ITz8QEd2DP6uuEmblbehyVhnxwFb0p0iolZiKLtVzJexu7xvRLxA
         vdI5B6RoEFwOl5TaBfcmhMk7phrzjekKTjPkyaHE8lizwcSYTUJMhzizGoKXpuWAqPLf
         2lgDlMaQeYLxq63+shVdWeKAfaamT9G47fztwMlDbz41Y+RUIUXqznkc01t6W/WrpHTk
         u7Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6GV9r+xMhkzrix1zVwuoFAT+2lz1nxuiG9jX5dFRLKs=;
        b=smaTSizG3aGUHe3fRagmbG++XVboZ1MCTN+k/WLXrq4njd6Q4EcrcdklHlBT8ctSzG
         8xv09dSaTLCJR9EtYkXiXe2nVrISVa4i2LTJDCfaavDcZAJyIdIUOh/QnMsuWGABrDBl
         WBeuPTo1b0ML59AUmIjNV3oWyzcWZqQR/AXb0yO0t4UPcGYQzN524WUDxvjIkF3p14Kn
         5ywTInEg6n95PJHbGdEECkrWR077383XGDSn1XfT0CwV4hYxjnhTEq+/mEPjr5MHQHqL
         FllUAHQkeUlnKcWFf78V28Y9iQwALE8QoECVKuq+107g3lk0hqRQBKGgMLYAMUprhUVC
         DfDA==
X-Gm-Message-State: AJIora9AsCPmzlqwq3ROeDZ/BttIobBJuxnidSgW9HxidDmSp0zRlV8Y
        nAkPTSY8Lb6WAo4+cETNrRg=
X-Google-Smtp-Source: AGRyM1thbs/2gKvh2iI5ibtm/dj3VoLVCC5dmvTSrymmc9mjWk+zXeucjYFrY4JIWFWw8/FbSV05zA==
X-Received: by 2002:a5d:64ec:0:b0:21e:92fe:ac77 with SMTP id g12-20020a5d64ec000000b0021e92feac77mr7032343wri.24.1658913602956;
        Wed, 27 Jul 2022 02:20:02 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:5b44])
        by smtp.gmail.com with ESMTPSA id bi26-20020a05600c3d9a00b003a2eacc8179sm1740076wmb.27.2022.07.27.02.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 02:20:02 -0700 (PDT)
Message-ID: <e4f4c89c-cdc5-2a37-c087-1c356a2a425a@gmail.com>
Date:   Wed, 27 Jul 2022 10:18:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v5 27/27] selftests/io_uring: test zerocopy send
Content-Language: en-US
To:     dust.li@linux.alibaba.com, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com
References: <cover.1657643355.git.asml.silence@gmail.com>
 <03d5ec78061cf52db420f88ed0b48eb8f47ce9f7.1657643355.git.asml.silence@gmail.com>
 <20220727080101.GA14576@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220727080101.GA14576@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 09:01, dust.li wrote:

>> +static void do_test(int domain, int type, int protocol)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < IP_MAXPACKET; i++)
>> +		payload[i] = 'a' + (i % 26);
>> +	do_tx(domain, type, protocol);
>> +}
>> +
>> +static void usage(const char *filepath)
>> +{
>> +	error(1, 0, "Usage: %s [-f] [-n<N>] [-z0] [-s<payload size>] "
>> +		    "(-4|-6) [-t<time s>] -D<dst_ip> udp", filepath);
> 
> A small flaw, the usage here doesn't match the real options in parse_opts().

Indeed. I'll adjust it, thanks!

-- 
Pavel Begunkov
