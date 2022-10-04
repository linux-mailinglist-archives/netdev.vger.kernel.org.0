Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2C15F3CC5
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 08:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiJDGd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 02:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiJDGdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 02:33:25 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6C3476CD
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 23:33:21 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id z23so9951085ejw.12
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 23:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=UNNn+aJyKI7I3QUSuIMb8vSXj6mDccgMNFpRl4lXEZo=;
        b=qbzOi5HQQpg2bpB7VFrL6MOFvNBzUpBIFU0Jkug447grp9HeZAH2n6sy8rA5RIC6fz
         D8n3wfg+ocxPaaE3RS4ChENpq3hWVsLDgjrRoJ/2fpcca/lyYxZT0V/wragvfyqJDlcB
         X0J1x1UnAxcbjc0nbBMH0I3fHNw3Bx2vgihvUxpxp0iSLrVP+kodALGPHYcBG49/FSpF
         L6xEt84ML6OLZl6lfAlgF0iHsutBY2jOCKeQD7nZ0GooqspZ1LqBmdmOtPgEhqj+9Uru
         +VCJ5Np8yz7F0laVp5RfSpvYhPk8qgZ9gFX8WXIgNqGTU9w3uwsJxIinykmTcHrhG/s4
         WJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=UNNn+aJyKI7I3QUSuIMb8vSXj6mDccgMNFpRl4lXEZo=;
        b=fr8r+e3tkKsBfDxmzyRdJ9aKr8w2IKwOz3pArXOG9vxiQbd0LVz0/CpUumGKzAOa7k
         Qy0KooOcwDHwZzP3HL3ImThwSnB6MZCly/wXDPNGQiIXPkFSoNm0YUHE0UjGcwssOiEn
         I2d6NnZcANMbywzZuWhiSdoK8siZ05uqkwWq+lYElRnx8VpcQE4sSYyNRn5jExgZYfRF
         kMH1dcjPQNPk2b2wsMHksc2MDoafwZpE1nYxqN+roQ57H0DxkUlM8lgxaoEsfwD5B0pd
         +o6Z4Wo8P6uwoyOVlLS42+tML00VmlI5+ZC1Okncg9L2nBvLQUfbfEacDv6ZKdhKMzQX
         zA5w==
X-Gm-Message-State: ACrzQf3u4GmbTfrqRdWMBYhr5vZU6jhhMAxzxoqMK5GsYmi3x/70OnSX
        fVQ8gxPC9fC7ZNlYq8gML+iCkQ==
X-Google-Smtp-Source: AMsMyM4YNNSdZ3jELO3jJlClXSpsmKpVP+uzmbFBv3c3rAY2Qn0ESKGXEg2j9wNmf/k0HLhSJK89mA==
X-Received: by 2002:a17:907:1b0e:b0:72f:9b43:b98c with SMTP id mp14-20020a1709071b0e00b0072f9b43b98cmr18063878ejc.710.1664865200276;
        Mon, 03 Oct 2022 23:33:20 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id sh39-20020a1709076ea700b0073cd7cc2c81sm6526138ejc.181.2022.10.03.23.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 23:33:19 -0700 (PDT)
Date:   Tue, 4 Oct 2022 08:33:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vadfed@fb.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Aya Levin <ayal@nvidia.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [RFC PATCH v2 0/3] Create common DPLL/clock configuration API
Message-ID: <YzvTrvE9HPHmtoQ7@nanopsycho>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <YzWESUXPwcCo67LP@nanopsycho>
 <6b80b6c8-29fd-4c2a-e963-1f273d866f12@novek.ru>
 <Yzap9cfSXvSLA+5y@nanopsycho>
 <20220930073312.23685d5d@kernel.org>
 <YzfUbKtWlxuq+FzI@nanopsycho>
 <20221001071827.202fe4c1@kernel.org>
 <Yzmhm4jSn/5EtG2l@nanopsycho>
 <20221003072831.3b6fb150@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003072831.3b6fb150@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 03, 2022 at 04:28:31PM CEST, kuba@kernel.org wrote:
>On Sun, 2 Oct 2022 16:35:07 +0200 Jiri Pirko wrote:
>>>> What I'm trying to say
>>>> is, perhaps sysfs is a better API for this purpose. The API looks very
>>>> neat and there is no probabilito of huge grow.  
>>>
>>> "this API is nice and small" said everyone about every new API ever,
>>> APIs grow.  
>> 
>> Sure, what what are the odds.
>
>The pins were made into full objects now, and we also model muxes.
>
>Vadim, could you share the link to the GH repo? 
>
>What's your feeling on posting the latest patches upstream as RFC,
>whatever state things are in right now?
>
>My preference would be to move the development to the list at this
>stage, FWIW.

I agree, that would be great.
