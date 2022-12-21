Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47A4652D61
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 08:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiLUHnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 02:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbiLUHnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 02:43:04 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EA920BD8
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 23:43:03 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id h7so14057778wrs.6
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 23:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gtEeCyZo+BoK/gQWnIMAa0rL2S7n7yu+aVkFuuU4nIA=;
        b=ts3U2g9DAdjZwMBXYPV6zCdRGXuJJ8ilhPuD1/k/EqxC76ujHmNY8V2SNeuYubCOE2
         /p6f7XlOWcFi7MY04O0T0TLDRBCI0W3pXws+fo3w8aSnw1oVRXh/gvn+7p7/Sug2Vs0V
         gXdK9KU8AHN7FY+KV7vD3oIajRCvP+vnIO3aOPCamTNgosNkFwW7q8nhB85FJa4OKmVd
         ldbu1oskwqEbazIHH+WDEfwxcMacIVstFiYYByladoAgRpvSWbl7wnIL1Tm0wH9ZGCJH
         17VekoSk0gT+22cG73DH4fpue1rpWo3nVEH8z81vpOM5dyNHvknn7C1RijusSnYAV4kg
         94Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gtEeCyZo+BoK/gQWnIMAa0rL2S7n7yu+aVkFuuU4nIA=;
        b=tT3Cy4EdVSyyIMCtBOEQ552zixQ/txaJL/T172FAB3wS3ICL5KA2FY8wfZh4ssqEL5
         x9/rXpTqTlkG2X5yYP9PWC3b5nJ95mud7TPHq8urKFlEWXAMKWxcvRXYfs3bvaaX1Q+l
         FWJD/gzI1uop3J4addXesDirhuP66dXTygCysd5A6Ds/UUoex+7FWlSE4DkYs2kd/xhr
         /FoiHveqp+bOEiIUObUqKAlDbibaN+2ju/m0L5DxBe5kBXzhpcXIgsYC5aMjccXkRPC9
         SE+zBXEZHy8MjgPL7sNaYGLcJG1Z+LorDKiQwq8/78wEW3mTnAl66BGjKHxiQg/c2FVi
         UW+Q==
X-Gm-Message-State: AFqh2koK4x6uZOupiyH+bxhxHaX9m/i9pWOkLRzuLLETHXlw3m1F8cno
        cauDPwNJQrpqoewQLl7LxVAR9OxXJ8DY1bdd
X-Google-Smtp-Source: AMrXdXv21kIbZbZLvmA9ia6JHuOYyE+pfn930c/N7aqu/GugI0f9rh6mUvA63yF75WtQg4YoH/Tr4A==
X-Received: by 2002:a05:6000:1372:b0:242:4d28:6a55 with SMTP id q18-20020a056000137200b002424d286a55mr2871319wrz.51.1671608581915;
        Tue, 20 Dec 2022 23:43:01 -0800 (PST)
Received: from [192.168.0.173] ([82.77.81.131])
        by smtp.gmail.com with ESMTPSA id u1-20020a5d6ac1000000b00241cfe6e286sm14490746wrw.98.2022.12.20.23.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 23:43:01 -0800 (PST)
Message-ID: <fc60e8da-1187-ca2b-1aa8-28e01ea2769a@linaro.org>
Date:   Wed, 21 Dec 2022 09:42:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: kernel BUG in __skb_gso_segment
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, willemb@google.com,
        syzkaller@googlegroups.com, liuhangbin@gmail.com,
        linux-kernel@vger.kernel.org, joneslee@google.com
References: <82b18028-7246-9af9-c992-528a0e77f6ba@linaro.org>
 <CAF=yD-KEwVnH6PRyxbJZt4iGfKasadYwU_6_V+hHW2s+ZqFNcw@mail.gmail.com>
 <a13f83f3-737d-1bfe-c9ef-031a6cd4d131@linaro.org>
 <Y6K3q6Bo3wwC57bK@kroah.com>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <Y6K3q6Bo3wwC57bK@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.12.2022 09:37, Greg KH wrote:
> On Wed, Dec 21, 2022 at 09:28:16AM +0200, Tudor Ambarus wrote:
>> Hi,
>>
>> I added Greg KH to the thread, maybe he can shed some light on whether
>> new support can be marked as fixes and backported to stable. The rules
>> on what kind of patches are accepted into the -stable tree don't mention
>> new support:
>> https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> 
> As you say, we don't take new features into older kernels.  Unless they
> fix a reported problem, if so, submit the git ids to us and we will be
> glad to review them.
> 

They do fix a bug. I'm taking care of it. Shall I update
Documentation/process/stable-kernel-rules.rst to mention this rule as
well?


Thanks,
ta
