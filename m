Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2774C4D38D0
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiCIS26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiCIS25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:28:57 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3834730F4F;
        Wed,  9 Mar 2022 10:27:57 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id r7so5318860lfc.4;
        Wed, 09 Mar 2022 10:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6Wfvf+Q1dHpq5+onmxCyJ2OGjzL7oPxurPNJQLIqmfY=;
        b=i+lRW+f7oPWk7jcy7w1AalK8NE85rsaceNF0w2ytooHwol3fZIMtcywmIm+P0I2Vp5
         b+JLJzp7IzP554e+1ELikmlo/Gm5zZfHmbcHfi3D0FUQgCwDpKPcQuPb1ymOTVWyMnXB
         xTBXt+q+wTmhmOP60lxSNUqgGwsYNMUCiMMJgCdS90sMovQkRNfygN59OyQ+k8wQhl38
         m75RZeoyfKQIeIjB3hUJ1EH3DJTKX05/8ABd2dtgJ/lsqkIChoXJG9v+N5u6n4J81BSZ
         6eZG5riskYhC23IYlbnclwaVdRRQ/m91DZgDlCl3pMmJGj5P52GWS9OrAfUCZS1YxlPq
         2Byg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6Wfvf+Q1dHpq5+onmxCyJ2OGjzL7oPxurPNJQLIqmfY=;
        b=BuZHNgVkiA24SLO8HX8BQT798vwzeDQlMGVQuMxAIzntqmwDmyg4m6WPlF5O0fuBB7
         d0JKndl1dfA2e8hiyJ32zv9HIO9NZinZo2UEwPAgyNahMkJ+pZKnJ33/XN/v1vUcIci3
         1uqwZLDUBRfDULsWAqTfdMFF5Mb0exo6QDJd1p5KOLqk5kpZKtnCQooxw9weoA3qdVYD
         K/79WtYdZAR1jb2JaOwbmHQiD95QwUsvSU48fVgsTr0CTyTpuGn5h58paBY7MKYOa1RY
         LtHfzEMfKfV96a9VJc1HfRBVWfz8czqkq3dgGTre984RPrVL/vJJ5aHp6hFzxlmLcAB2
         oSYA==
X-Gm-Message-State: AOAM5338V6Y5LhaQwAzljEXSSNSjFeenVZvGyrg2nVkDjgWxnX05aA5c
        dWPOLaLmVqhaGX7MQCIe3s0=
X-Google-Smtp-Source: ABdhPJzA0KMD3/dvoxflUnM7ShAVTJalNTkZZHAC4qEm02JiUvoHmrLHBnPSiF25175TRgaTmkSUiw==
X-Received: by 2002:a05:6512:33d3:b0:448:38e4:3088 with SMTP id d19-20020a05651233d300b0044838e43088mr556297lfg.272.1646850475308;
        Wed, 09 Mar 2022 10:27:55 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id q26-20020a19a41a000000b004485b32c483sm210037lfc.192.2022.03.09.10.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 10:27:54 -0800 (PST)
Message-ID: <b46bfa75-2c87-61d9-c0fc-33efb2678f27@gmail.com>
Date:   Wed, 9 Mar 2022 21:27:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] NFC: port100: fix use-after-free in port100_send_complete
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        sameo@linux.intel.com, thierry.escande@linux.intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com
References: <20220308185007.6987-1-paskripkin@gmail.com>
 <cbdd5e41-7538-6d8f-344a-54a816c6d511@canonical.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <cbdd5e41-7538-6d8f-344a-54a816c6d511@canonical.com>
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

Hi Krzysztof,

On 3/9/22 12:52, Krzysztof Kozlowski wrote:
> 
> 
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> Thanks, this looks good. I think I saw similar patterns also in other
> drivers, e.g. pn533. I will check it later, but if you have spare time,
> feel free to investigate.
> 
> Similar cases (unresolved):
> https://syzkaller.appspot.com/bug?extid=1dc8b460d6d48d7ef9ca
> https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
> https://syzkaller.appspot.com/bug?extid=dbec6695a6565a9c6bc0
> 

Thanks for reviewing and pointing out to these bugs! Will take a look


With regards,
Pavel Skripkin
