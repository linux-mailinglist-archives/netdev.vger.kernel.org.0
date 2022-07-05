Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE2E567086
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 16:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiGEOLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 10:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiGEOLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 10:11:13 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782A520BD5;
        Tue,  5 Jul 2022 07:03:33 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q9so17714973wrd.8;
        Tue, 05 Jul 2022 07:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K1faJAUPe99XaFEI9k8YOqkAPgSogag6E3JBddhKDAI=;
        b=mz8kUR7M1V13srg5ePE5YPQW3nbTDq+Gjs/owKp/hbML+wtTRQxJS7l0o7H+zXqKMN
         kwi6RERYlwBZdbxbzug8CXKDmdP1WnkiHNE093d4QGj2843v+xCdwmY6PGiEStY+NfIt
         C/MU5DsAsuzybxBhkqsEHplDZO2/Ht6pX8Fl6kVWIvbdugspTD/BzGqEK2JnA6TX1UfA
         P+C1SqB1wC2q8MVnwvHY0pt7fb19F0d9VC+Y4DLR/7WgmgTnzeGTe76Xm/arg4G8NVwn
         QB3Zu8FLd7sqMSEj5zslUyY2eU1byyla+fO6zzPfWu5K/BLsJAec4K16lCU5QJ1atTMK
         2biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K1faJAUPe99XaFEI9k8YOqkAPgSogag6E3JBddhKDAI=;
        b=m///CSJMPmgx96+L+/+5ULAuMN6uOO9WfJPm5eDrWUQd/yotHxYa/Cx5pIua/sUTKV
         jF7Y0sbw7ZB3kW1F8JAW6bEX6km6SfaNHaN4mh7Vc+CK+5MV9rXk6zUQY321XtwZ4Pom
         c+wTAQVwOsJsOmighGdhgA8al4AHSIBNQ/NlpoeaGCz6RSq/ggBO+q6kYyllQd4gwTTf
         LsPFN+yfl68gV41A3rOXpspXwlKXrU4jFA3X5bb3qnFCuIntrMcyhlncxqOpHVhhi+ki
         WCqciVSQErLijD+LcpYUtPGa734a5fwWwGM0L4r20yViXTdZ6R2iMkeMclkmRSpWmT94
         mzBg==
X-Gm-Message-State: AJIora+NT0tP7K45ryJpS735TeXR260cPrViLjeSfzUq2T9eRaqMufPx
        oC4dp5ekz+fXrnhTGKFzpZM=
X-Google-Smtp-Source: AGRyM1shAJGVMP5T46zZDRAWMQAWXsuKt60QS8xAgreB2J8VTimxf0yWirp0cVSmWbhIrkfsP4Pb2w==
X-Received: by 2002:adf:ee89:0:b0:21d:681b:47cf with SMTP id b9-20020adfee89000000b0021d681b47cfmr12319366wro.394.1657029811903;
        Tue, 05 Jul 2022 07:03:31 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m2-20020a05600c3b0200b0039c63f4bce0sm19059849wms.12.2022.07.05.07.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 07:03:31 -0700 (PDT)
Message-ID: <e453322f-bf33-d7c5-26c2-06896fb1a691@gmail.com>
Date:   Tue, 5 Jul 2022 15:03:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC net-next v3 05/29] net: bvec specific path in
 zerocopy_sg_from_iter
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
 <5143111391e771dc97237e2a5e6a74223ef8f15f.1653992701.git.asml.silence@gmail.com>
 <20220628225204.GA27554@u2004-local>
 <2840ec03-1d2b-f9c8-f215-61430f758925@gmail.com>
 <ee35a179-e9a1-39c7-d054-40b10ca9a1f3@kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ee35a179-e9a1-39c7-d054-40b10ca9a1f3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/22 03:28, David Ahern wrote:
> On 7/4/22 7:31 AM, Pavel Begunkov wrote:
>> If the series is going to be picked up for 5.20, how about we delay
>> this one for 5.21? I'll have time to think about it (maybe moving
>> the skb managed flag setup inside?), and will anyway need to send
>> some omitted patches then.
>>
> 
> I think it reads better for io_uring and future extensions for io_uring
> to contain the optimized bvec iter handler and setting the managed flag.
> Too many disjointed assumptions the way the code is now. By pulling that
> into io_uring, core code does not make assumptions that "managed" means
> bvec and no page references - rather that is embedded in the code that
> cares.

Core code would still need to know when to remove the skb's managed
flag, e.g. in case of mixing. Can be worked out but with assumptions,
which doesn't look better that it currently is. I'll post a 5.20
rebased version and will iron it out on the way then.

-- 
Pavel Begunkov
