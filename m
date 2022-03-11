Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6168F4D5A97
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 06:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346318AbiCKF0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 00:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbiCKF02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 00:26:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769D11ACA1C;
        Thu, 10 Mar 2022 21:25:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1237D61AEA;
        Fri, 11 Mar 2022 05:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA12BC340EC;
        Fri, 11 Mar 2022 05:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646976325;
        bh=nRLq8Za1OvjwHMYV/kaWFi/fkLoSP1yixascqRgAgJo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G+sXxkE0xe4SXpOBYALj55qRoOWUaBKi/qYdqhv73VynBcv8P0jXIjEpTAzRMwN1N
         TexUMP/UnjFZDa2OmK+sGAGAcBqFExtkN6s6hC/NwfLJ6p9AHOLuomQwekphtU3Wfb
         OAe11YEY5rZTYvlB0WWDIVNDzoaGXSgTeh9D/kNflh3gcd05R4iDgDcptWwTBZLktY
         4CPb2xREk5gQMFx7iCeu+narKP9ZXwg9tcSeEyk/rqxieREv6HEOkVBxDv5G+N6bgw
         zLqUbyyjBII1qlG3ZcrJxB4UNuci8vgsq7ZvaUvrvUH0HbdEokhHBZvSKodyLhS/8P
         qOp3IAZc5H4Bw==
Date:   Thu, 10 Mar 2022 21:25:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, djakov@kernel.org, bjorn.andersson@linaro.org,
        mka@chromium.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/7] net: ipa: embed interconnect array in
 the power structure
Message-ID: <20220310212523.633287d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309192037.667879-7-elder@linaro.org>
References: <20220309192037.667879-1-elder@linaro.org>
        <20220309192037.667879-7-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Mar 2022 13:20:36 -0600 Alex Elder wrote:
> -	power = kzalloc(sizeof(*power), GFP_KERNEL);
> +	size = data->interconnect_count * sizeof(power->interconnect[0]);
> +	power = kzalloc(sizeof(*power) + size, GFP_KERNEL);

struct_size(), can be a follow up
