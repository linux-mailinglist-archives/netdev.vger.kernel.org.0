Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168956BB51F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbjCONs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbjCONsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:48:41 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10DA26A8
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:48:11 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i9so8363045wrp.3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678888089;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cEFUi1slu6dOkNLkp7IROJB0khiY4A1tkjf39LAoBwc=;
        b=GXFon7y5xeNCh1jMMJ3XKJ8q93X7DtgDb8qd+cLlNraAUCu15xCpCqMWwr1WaVmKte
         XFMa+ouPr0xqY36OakZYJfJxwdoNmaEyvc7Amymc+x/Fhsu+cBZUZU5se2F9UA5Gjug3
         BFeW6ybylRIzRYML0kDt44KqqjOu6+/biSZKI82BjmuEcWj+rGnAIzM+RAhsVaqL2VmS
         r4wOn8leYcTKk47rcUI+rlvwWmnJDQNB+zgkappkZrwddgpuoBN74IusHOxAPXYSYuoR
         qF/6V4Uix4oWB2v+kcIsls6nDkj12Tp4q3AD6KtRs/xkDdfKDIv/9xsKrJfDJGUfvN12
         0vug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678888089;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cEFUi1slu6dOkNLkp7IROJB0khiY4A1tkjf39LAoBwc=;
        b=iT6EyH2K9ytNNocQV/qqke9eCh4SaULkfPZ2tKFycq66aw9CXmOWLQn0JvDmPapV+7
         rVaQQHFpWxLZT9CetzfogCBABf2R62LS++YHclawew54il2tCaRr+Ei1AgNPyCaLtytL
         CxvHuZMlflYwwJF4jj9hT/jsWJaUgyw3QhgLEnQlmpyy8bQo6oPW2xDXPxxaxvilYAIF
         z/7CkcGHgNk7oVpler4/sOmFnqc9ZHDKMcol5bZ6GMjlaIG4uPwHptfKxknFkd807Jxo
         fEW7eNmY1KaHbwzsn61r8b7bNRghZ5u0MGShcxSEBZnOxWGCiLmDV7SiwdEv4fchJuDE
         pCdQ==
X-Gm-Message-State: AO0yUKWSRkZ+5qJiHhvXwFJ7DYG2EQHh8KJHKHqR0QGMopyBuW4NqKAt
        EmNfncJ7BO+hA+NU9VKw2LI=
X-Google-Smtp-Source: AK7set93woiHaecwOrHeQJ1jku4yUNlT2XoekNi5D87oQ8ZOHSxvDClQeEKWgguNjuaBMWgUKA6WBQ==
X-Received: by 2002:a5d:4ac4:0:b0:2d0:2d4:958d with SMTP id y4-20020a5d4ac4000000b002d002d4958dmr1547421wrs.21.1678888088690;
        Wed, 15 Mar 2023 06:48:08 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id j19-20020a5d6e53000000b002cfea3c49d5sm4409454wrz.52.2023.03.15.06.48.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 06:48:08 -0700 (PDT)
Subject: Re: [PATCH net-next 2/5] sfc: handle enc keys in
 efx_tc_flower_parse_match()
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <962d11de229400416804173b2ab035d73493a6b4.1678815095.git.ecree.xilinx@gmail.com>
 <ZBGJdWyXZSlXwN96@localhost.localdomain>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <abda3c58-fbb2-669f-6cf5-052af1bd5c91@gmail.com>
Date:   Wed, 15 Mar 2023 13:48:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ZBGJdWyXZSlXwN96@localhost.localdomain>
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

On 15/03/2023 09:01, Michal Swiatkowski wrote:
> On Tue, Mar 14, 2023 at 05:35:22PM +0000, edward.cree@amd.com wrote:
>> +#if !defined(EFX_USE_KCOMPAT) || defined(EFX_HAVE_FLOW_DISSECTOR_KEY_ENC_IP)
> Are these defines already in kernel, or You want to add it to kconfig?
> I can't find it in tree, aren't they some kind of OOT driver defines?

Whoops, yes, that's from our OOT driver, it's part of the machinery we
 use to make it build on older kernels.
Embarrassing copy-paste error that slipped through internal review :(
Will remove all instances of this in v2.  Thanks for catching it!
