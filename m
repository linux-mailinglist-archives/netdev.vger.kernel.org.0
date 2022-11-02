Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B3A616625
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiKBP3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiKBP3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:29:05 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824626478;
        Wed,  2 Nov 2022 08:28:55 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id bs21so25097508wrb.4;
        Wed, 02 Nov 2022 08:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4egQs23B/0jD+O5d0KXLiUFX5T/QwoarUGlcyJUeObo=;
        b=lhX+ZWrUkKM7HX+sgDGmFCN+A6u2sNjtuKiZxSQ4mBJwSZ9KHSgkNvtZgSfpnFW91Q
         hCwgAhCGjLNjdwaBZPkzihlW5Z/YEIk4flwfSSVT6MtAYAl8v9mNuPqFKZ4uNnc71ZZN
         5PrRnS2pTUfjhUwaX4WXqetuE8bbyBFQad70Gu8goJaNXzHV4VJI5T6S4VwimwXKp0tN
         Qr6+PP6o9wK778I1yvNnre2p2Yg7K+f8myrmCMk9dXlWw4Tor8ImuuFH5XTOvOYV+umS
         vsK1SNIZFsvlSd5qZyO1O6w6T3Vbtfki1xecI68qhaTgOLRhwPjrnaEKZdoB9ooEZTW/
         1T+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4egQs23B/0jD+O5d0KXLiUFX5T/QwoarUGlcyJUeObo=;
        b=m4W4WlHjsx4JlN1itFggdctgOUIG/RilmKX2Ra2bBYhoBWaTycdX1X0A+9iaRqE3bs
         YJrnW1gyYpRO/qG5krW2PIQN3gH2rJwhJ2EXNTEsCFZdsaFUJYrqHtiJ1KR7p7ZyKqDk
         gpDpt8Xs4SHUhhK/WcA4KIju8uP2KUA9D60pcrve5wfrclBxGtzDQolgkwKwEePFXoNp
         6npCHkH1Ep1GxHysrzlhOISEZauFZbVKQo09s5bO2xGNep906S5XYX243/Bm1zTy7SwO
         OXzQvml/+qmD9Hz5KyuJVr3aP8g0chpSy+IDovPS2dM+csOyCXBXxw/fU4D41LeYV0pn
         qwKA==
X-Gm-Message-State: ACrzQf1UrWpZFK0BRZfjGIBC07p3sBBoFjkMkLH0bMLKl701QOo1TTZa
        yAor/NNZryl2MP5wAbH6yrk=
X-Google-Smtp-Source: AMsMyM5c8Dd+BBbbPeuG4s5bkCzaunkFfFLCR3siYEdjHx9T6SX0lVAVVT1cCGA/ijAWwR4MUa7RsQ==
X-Received: by 2002:a5d:554e:0:b0:236:ccf1:f958 with SMTP id g14-20020a5d554e000000b00236ccf1f958mr11087212wrw.378.1667402933989;
        Wed, 02 Nov 2022 08:28:53 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id bk17-20020a0560001d9100b0022cdb687bf9sm16075337wrb.0.2022.11.02.08.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 08:28:53 -0700 (PDT)
Subject: Re: [PATCH net] net: Fix memory leaks of napi->rx_list
To:     Eric Dumazet <edumazet@google.com>,
        Wang Yufen <wangyufen@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ecree@amd.com
References: <1667361274-2621-1-git-send-email-wangyufen@huawei.com>
 <CANn89i+cNjUH8pR0-QTdWM09G8ZfX_gzDqOY6ecyY4igDwrYaQ@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <7632c326-5727-2c71-9895-08c540b2c8d5@gmail.com>
Date:   Wed, 2 Nov 2022 15:28:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CANn89i+cNjUH8pR0-QTdWM09G8ZfX_gzDqOY6ecyY4igDwrYaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
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

On 02/11/2022 04:27, Eric Dumazet wrote:
<snip>
> I do not think the bug is there.
> 
> Most likely tun driver is buggy.
<snip>
>> @@ -6471,6 +6481,7 @@ void __netif_napi_del(struct napi_struct *napi)
>>         list_del_rcu(&napi->dev_list);
>>         napi_free_frags(napi);
>>
>> +       flush_rx_list(napi);

But maybe it makes sense to put a WARN_ON_ONCE(!list_empty(&napi->rx_list))
 here, to catch such buggy drivers sooner.  WDYT?

-ed
