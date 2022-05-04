Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914D551AB67
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 19:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358219AbiEDRqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 13:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359431AbiEDRoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 13:44:20 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915F652E61;
        Wed,  4 May 2022 10:07:30 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n8so1983689plh.1;
        Wed, 04 May 2022 10:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5heQlZbmjl3R/ScgbWjY3UOlALlpc5dyNuQE2J2tTh8=;
        b=PYGn8cyOYJe7mUdyDAprPahcuw7uwaYeqc+0nVFaR6gawsQBFxMTWvkwZH/bqb3sAO
         N0Ncz1b27atKy9ekgZOUYq8XgUvyg2kCVQf/kexa3P9ysLxH7h69nh4sXRBkC5IwBuCU
         lvDyw1lV89wkkkItT4fsGfUBTGVxqmFrcFUIMCLOdTsvLIJvnKYz9zTpsn69h6CggRVL
         wnJeHZ86dibGEhFYGLcA9xHFAtNnuag4oce8bW9hRT7w1lnQI3wzymNLYEGTOvTegbC6
         i+1IulZwNL0CqPF3/nykpMzjJrWoRina/vvqquTC/eXDrcuWKo0GxhEPoa2CCgDTfFMz
         jluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5heQlZbmjl3R/ScgbWjY3UOlALlpc5dyNuQE2J2tTh8=;
        b=IGlcPAX85HZz0TZNjpIMMzCLFW9WASK3BL+1i0Yu5NeuW2OHXH2Zc0l1zg36+PR+vY
         iuHA47JBHVf6GJjnD4Ldf5Sl84HISG4iLwbqiTrORKzmVH98fhLnNdhn7mw5RnUD3Vl0
         dn9PSBGiBrYxURnpMmFd9sGaYoBrWA65tR/EBcBx8cFbRXP8OfbS4RpVQqWgmc8BGOyY
         6fMJY3wcVy6e9+fI9eRLgN56whUsDt8bvO9UQINttlh8cW+wS4YaW2cc1NMIjh9Ahtdn
         vr+nETW7XlQB/7EXZmDi6fe/O99OPoaXQe/h/ufax2fnx07BdDTlHY704uWT0Mf0l8bj
         bidQ==
X-Gm-Message-State: AOAM530o6AkyBKpdHyip2VAyo22g2pgL24EQJQ25wqgOR360FJhjDHlP
        2NDRD0orbBsNBZbKwBg+pT4=
X-Google-Smtp-Source: ABdhPJzuNG+G7WrVCnZo6oM5E1j+8EOpXMiSJct3FZoI4MOoDiNL6HXgay/Dmjg9M7ZFvLy9XbMCjw==
X-Received: by 2002:a17:902:70c1:b0:154:667f:e361 with SMTP id l1-20020a17090270c100b00154667fe361mr22914608plt.148.1651684049858;
        Wed, 04 May 2022 10:07:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i15-20020a170902c94f00b0015e8e7db067sm2502228pla.4.2022.05.04.10.07.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 10:07:28 -0700 (PDT)
Message-ID: <5480dd4a-5626-a6e4-c4e4-90c9e10554f9@gmail.com>
Date:   Wed, 4 May 2022 10:07:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 1/2] net: switch to netif_napi_add_tx()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        rafal@milecki.pl, opendmb@gmail.com, dmichail@fungible.com,
        hauke@hauke-m.de, tariqt@nvidia.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, shshaikh@marvell.com, manishc@marvell.com,
        jiri@resnulli.us, hayashi.kunihiko@socionext.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        grygorii.strashko@ti.com, elder@kernel.org, wintera@linux.ibm.com,
        wenjia@linux.ibm.com, svens@linux.ibm.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        s-vadapalli@ti.com, chi.minghao@zte.com.cn,
        linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
        mptcp@lists.linux.dev
References: <20220504163725.550782-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220504163725.550782-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 09:37, Jakub Kicinski wrote:
> Switch net callers to the new API not requiring
> the NAPI_POLL_WEIGHT argument.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: rafal@milecki.pl
> CC: f.fainelli@gmail.com
> CC: opendmb@gmail.com
> CC: dmichail@fungible.com
> CC: hauke@hauke-m.de
> CC: tariqt@nvidia.com
> CC: kys@microsoft.com
> CC: haiyangz@microsoft.com
> CC: sthemmin@microsoft.com
> CC: wei.liu@kernel.org
> CC: decui@microsoft.com
> CC: shshaikh@marvell.com
> CC: manishc@marvell.com
> CC: jiri@resnulli.us
> CC: hayashi.kunihiko@socionext.com
> CC: peppe.cavallaro@st.com
> CC: alexandre.torgue@foss.st.com
> CC: joabreu@synopsys.com
> CC: mcoquelin.stm32@gmail.com
> CC: grygorii.strashko@ti.com
> CC: elder@kernel.org
> CC: wintera@linux.ibm.com
> CC: wenjia@linux.ibm.com
> CC: svens@linux.ibm.com
> CC: mathew.j.martineau@linux.intel.com
> CC: matthieu.baerts@tessares.net
> CC: s-vadapalli@ti.com
> CC: chi.minghao@zte.com.cn
> CC: linux-rdma@vger.kernel.org
> CC: linux-hyperv@vger.kernel.org
> CC: mptcp@lists.linux.dev
> ---
>   drivers/net/ethernet/broadcom/bcm4908_enet.c       | 2 +-
>   drivers/net/ethernet/broadcom/bcmsysport.c         | 2 +-
>   drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 3 +--

For the above:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
