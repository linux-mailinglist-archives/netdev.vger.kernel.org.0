Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1110667DA3C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjA0AKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjA0AK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:10:29 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F1F10C6
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:10:26 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 203so956664pfx.6
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6tLlHywhChu9GTpuLyfieVhfcqpQ4Wk34o1DLyfKoBk=;
        b=Gade1yqN8VnDVg6fV8VSJJdUD1U7c5lq+Gc67KL0zaxbodZz1jKNTKFuwKKl3cuQIa
         R+Iq2FQyGlaE5JgY9z5zJOr8IN+9N+7Rfr/FR1XelPczxdmQEAwqEJx7T1PfFXRj4Nfm
         RwEziyeYu6/xef2rFZsOLpUktEQ/Afaokh/D3+PhqhOJzFqrWgt3a13P9VXHDE0qtGk8
         8kSr1ZcMZ3eDmZXejBMYn64YEjgMQDhw3vOBMFrcP6ZM4axpDOmLgkrzjM/f8OrsY2Xq
         E15P4pIhoZu7AwJObPUe8P37Qbe1ofRVDmqrRaPjtChF7uM36MFElNa6OPUKjdww8NkD
         DMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6tLlHywhChu9GTpuLyfieVhfcqpQ4Wk34o1DLyfKoBk=;
        b=Ts0Ni4L5wWGK1gs+9XELlSPmGLjVmGaMjNF5kQcdkCts/hN14pHUsDYgu1Xja+zpgJ
         kG5AAvmIfYonAXT+x1kN/+cfKBYCWSEl7UD66IGg8FtxwOy5Xc9TBQ/dUWhSftsj7siB
         OC1ArrlSFBpPOPuvwwkHzd3XIbpsnWv9CRj99dXdZc67MBIAZXhOBZEYXVw/ZKVxjf+b
         QdGmtD6sxXQuKvbDSX9ZWclcAbdKUVwkPVPF5e2fp3XhQ/hqqSw7DrIXa2iJP/fDB5fa
         u5svUuZUqjMU88bGqr9n7qVPKXQ6b2a+BqizsPepS4uXzY960x7x7OipU8RH4ijVhWHx
         ziyA==
X-Gm-Message-State: AFqh2koDW81mlCT1HrDDQjtFxPDmikOuZUTz70fdmf52O7W8KnZQlUcN
        mQflMjoqp5tll73rvpIlBCw2ExY1cU2hDw==
X-Google-Smtp-Source: AMrXdXtjMB8nSHC3qduYdpMrOBus8Dtb/64pW/ZgbTiYszdrB4RjZ5txzmM417qoeZmNn8xXsvK3Hg==
X-Received: by 2002:a05:6a00:1887:b0:589:d831:ad2a with SMTP id x7-20020a056a00188700b00589d831ad2amr50638845pfh.6.1674778225434;
        Thu, 26 Jan 2023 16:10:25 -0800 (PST)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c12-20020a056a00248c00b005877d374069sm1470331pfv.10.2023.01.26.16.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 16:10:24 -0800 (PST)
Message-ID: <59edd2b9-6695-7b60-157f-abd405cb7b02@gmail.com>
Date:   Thu, 26 Jan 2023 16:10:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: ethtool: introducing "-D_POSIX_C_SOURCE=200809L" breaks
 compilation with OpenWrt
Content-Language: en-US
To:     Nick <vincent@systemli.org>, netdev@vger.kernel.org
References: <0723288b-b465-25d4-5070-d8aa80828b11@systemli.org>
 <77b6a4f9-be34-c1c6-9140-a39633fe4692@gmail.com>
 <c582757f-a633-3958-d72e-e606e43879db@systemli.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <c582757f-a633-3958-d72e-e606e43879db@systemli.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/25/2023 3:26 AM, Nick wrote:
> Indeed, it is fixed by those patches. Thanks! Why are they still not 
> merged?

Michal has some backlog he would like to process, he wrote he would try 
to merge these patches this week:

https://lore.kernel.org/all/20230124083907.w7h6rbvh7fsq334y@lion.mk-sys.cz/
-- 
Florian
