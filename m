Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1848550DF6E
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiDYLz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236204AbiDYLzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:55:13 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4191413DCA
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 04:51:54 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m15-20020a7bca4f000000b0038fdc1394b1so12339158wml.2
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 04:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ib6nQlp08A5L9C0VdErv324vMKIB/tKGFJooHE6SPao=;
        b=FGPew/JsMHemqppExogpDPOAw5g4gf1ssAKTU8fEoDX/TYrqhqAgx36NUbhIHfxaxO
         oGCt5CK2FsLLjjcHAuSPTrThgGRIqlrWQMHnrmZyf0JSJyqDjvrjQYK4tUkqgX1qx0Lu
         5yGCgzmxlkwn2fZfqW2Jv3JM938EbEunI/vGTmh5yFSWsU5lr6FoQth79T/LrEb0UhBS
         /3/zjjJGFYSJp2AdQUMsZG3QiYUzMih4wfHLiglTYwfQCtRm/US0vOI7RuiQHcY0XerE
         5xdNs5OqFcAzVGc0Cv54TyVkjrOzE/R8SljWIFQ4Vkd9C7s248D6rCUJ93Ue1XOjrsFf
         QvQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ib6nQlp08A5L9C0VdErv324vMKIB/tKGFJooHE6SPao=;
        b=Z+D95T+5602O/vq1hUwDd/grKHH23L3At7zDhsjcc921U2BeqdgfhE710exYMaA/M+
         ABVs/be7OiTFYi50j0d3Ny+3g9KRkPMWvaC9vR8l1w5YAzx3T9y4XtpPCDmjBOwDCZ/Z
         JG8+jCnD3Wag76OGvqSsrPNNlgmMpfJpxkncM9IVHOCWSJUWtcDvYjh1oPKPCGfFzt+C
         jyA6XkIZZbKQFGSS7lIAV4+NAMm/CQ9aq6Yp+KSJ/Jzg+2BIbcTGRuWmUxQdl2xqLcbR
         bP/kGMgvv3tI8YPkHJWnkxdaoWKgIpr9QxhqejxAg5mWiQT+rCg27dvQVUQd70kfI0gk
         8UtA==
X-Gm-Message-State: AOAM533XebNux69HseliTHZatgwJZjz4sanjud8qjjcP6aS+87VHNQB7
        nVOSXwSFXHyOrReCuKQBOPAGJ5acYJp46Q==
X-Google-Smtp-Source: ABdhPJwTi7rTFUk/I2iEam2Reae+PhOpYVcJX2xASabdJn+lKdmLrBwmczED1vVi1f2ATPqORx5UTg==
X-Received: by 2002:a7b:c7c3:0:b0:389:cbf1:fadf with SMTP id z3-20020a7bc7c3000000b00389cbf1fadfmr26141200wmk.147.1650887513507;
        Mon, 25 Apr 2022 04:51:53 -0700 (PDT)
Received: from 6wind.com ([2a01:e0a:5ac:6460:c065:401d:87eb:9b25])
        by smtp.gmail.com with ESMTPSA id a16-20020a056000051000b00207b5d9f51fsm8796490wrf.41.2022.04.25.04.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 04:51:53 -0700 (PDT)
Date:   Mon, 25 Apr 2022 13:51:52 +0200
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, intel-wired-lan@osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH net v2 0/2] ixgbe: fix promiscuous mode on VF
Message-ID: <YmaLWN0aGIKCzkHP@platinum>
References: <20220406095252.22338-1-olivier.matz@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406095252.22338-1-olivier.matz@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Apr 06, 2022 at 11:52:50AM +0200, Olivier Matz wrote:
> These 2 patches fix issues related to the promiscuous mode on VF.
> 
> Comments are welcome,
> Olivier
> 
> Cc: stable@vger.kernel.org
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> Changes since v1:
> - resend with CC intel-wired-lan
> - remove CC Hiroshi Shimamoto (address does not exist anymore)
> 
> Olivier Matz (2):
>   ixgbe: fix bcast packets Rx on VF after promisc removal
>   ixgbe: fix unexpected VLAN Rx in promisc mode on VF
> 
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Any feedback about this patchset?
Comments are welcome.

Thanks,
Olivier
