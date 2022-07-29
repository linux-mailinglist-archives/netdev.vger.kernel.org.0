Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9C1585373
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 18:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiG2QcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 12:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbiG2QcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 12:32:06 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA191263A
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:32:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w63-20020a17090a6bc500b001f3160a6011so6988859pjj.5
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8vEvEoXiOGD+iC089b5mhdDPX1NyQHNd+5UkIwp9jpU=;
        b=F2Y8kzczwb9Km0nTTNTajsiO92LybDkIifBYVq4p6ymFg7+WSIyfXBFF52ceO21JVD
         JqWFT19Kn/PRXZpfy7eL1Cv41SlhQ2HdMXOwFfP36dGIOdn1hFq0j3S76arWHXwxdw4k
         pLD/TV69dbLrO0ugmieC7WExIVCh1vqqOAPmoIVATp9he30zbKarFbt7e3TMgWFfN3Tq
         kN87eNJBtu7agDtVESu0GYRIrYqZUWVnqxTi7uNKDgS8HsjDStNuHHnfQ/BTDaf5jERU
         X28afroqc6Grdb8Nu1I+txorb6coSVUmBgJU3vb0lAuqDB+8qt3UWQYd/9X4pOwGdJ4l
         zQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8vEvEoXiOGD+iC089b5mhdDPX1NyQHNd+5UkIwp9jpU=;
        b=6awVGVKP3DUSbA5AhHx05fx1kCYch9H6n681EJb/CjCraMlevJaV6RLpJYgd4hV9MV
         rn/UdHHb6egxr37NFFrxeeL0MX4jQs9pDQEGHAyK5pAlnmgBjQAEQBv8RywH9rLwGhlR
         W0H6FbsblFufPGlSOPJnpUTmrCdrNq3cTeNtQHyYbbGkSLpUiH1AlH5OZczk77SQObh8
         OhxULjbm6Y7OU/azrkhHkHz4jJJgCsFgomG1Q7zsWcK9RDwChhOENEeqPFmpSrKSqwoK
         bDeBRw3YrdX9lgalxJlY8AKZtjXdva417tu8GNuJY3pDFCqmeYQn2tlld58zPLsa8whm
         2R4Q==
X-Gm-Message-State: ACgBeo0nbPNMs5B4lV9PGAbjkekcZoGWWnIdspfyQlJBuCwO843qkxui
        Ae4Uew8BdcYQc37JYcbvmRDBsZoHf+dIwg==
X-Google-Smtp-Source: AA6agR6lyMYO+GX4YTLRUO8LAJhKt8b8BkgoLNf7SXU/iApo9H2hD5WF0kIFPWtmsu0ndMGBVorkPQ==
X-Received: by 2002:a17:902:a9c6:b0:16c:9d5a:fde1 with SMTP id b6-20020a170902a9c600b0016c9d5afde1mr4662863plr.3.1659112324302;
        Fri, 29 Jul 2022 09:32:04 -0700 (PDT)
Received: from [192.168.0.3] ([50.53.169.105])
        by smtp.gmail.com with ESMTPSA id f15-20020a17090a638f00b001f04479017fsm3291279pjj.29.2022.07.29.09.32.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 09:32:03 -0700 (PDT)
Message-ID: <4f3764f1-1faa-c28d-21b1-3356ddb3cede@pensando.io>
Date:   Fri, 29 Jul 2022 09:32:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net 2/2] net: ionic: fix error check for vlan flags in
 ionic_set_nic_features()
Content-Language: en-US
To:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        brett@pensando.io, drivers@pensando.io, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
References: <20220729101755.4798-1-huangguangbin2@huawei.com>
 <20220729101755.4798-3-huangguangbin2@huawei.com>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20220729101755.4798-3-huangguangbin2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/22 3:17 AM, Guangbin Huang wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> The prototype of input features of ionic_set_nic_features() is
> netdev_features_t, but the vlan_flags is using the private
> definition of ionic drivers. It should use the variable
> ctx.cmd.lif_setattr.features, rather than features to check
> the vlan flags. So fixes it.
> 
> Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>

Good catch - thanks!

Acked-by: Shannon Nelson <snelson@pensando.io>


> ---
>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index f3568901eb91..1443f788ee37 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1437,7 +1437,7 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
>   	if ((old_hw_features ^ lif->hw_features) & IONIC_ETH_HW_RX_HASH)
>   		ionic_lif_rss_config(lif, lif->rss_types, NULL, NULL);
>   
> -	if ((vlan_flags & features) &&
> +	if ((vlan_flags & le64_to_cpu(ctx.cmd.lif_setattr.features)) &&
>   	    !(vlan_flags & le64_to_cpu(ctx.comp.lif_setattr.features)))
>   		dev_info_once(lif->ionic->dev, "NIC is not supporting vlan offload, likely in SmartNIC mode\n");
>   
