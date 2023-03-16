Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884FC6BD85B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 19:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCPSwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 14:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCPSwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 14:52:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F059728E59;
        Thu, 16 Mar 2023 11:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ECE6B822BC;
        Thu, 16 Mar 2023 18:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD8AC433EF;
        Thu, 16 Mar 2023 18:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678992757;
        bh=59kceHKTQ9pP2wUCJX8jKFzLo8hYVTu7itr7dC78eII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PGUIcaZp6+rvtdA+AXlsWzUw+mepWVcL6mXTXRgW0sgMF6pYGsV9aGt95mIYsEPPn
         mzR0GYlsSB8sEZ3LLO5iUqDWrNzh5Nt6HAgUhzT7o6VTkakqrGjq7kTr2cH10BBHCr
         OCo5l8B4olKfIqW8YTjTcNro8TfwpLnUErrl6QLzMDzn1LuMaECLpL/frKH3ydjtov
         98a0yAp+TFpFg+L3Qe+M5G46OTDt6AqowmZer9SfOghnhOB35do/BwnWONyOswUr/6
         /H2Im6x3rgFHDG+u7QfFUyhJiTRD9aUvzjRAv5JfnwbNRHk1pIg+XRHf/yJRir8/BP
         iv0OYqCiOSLXg==
Date:   Thu, 16 Mar 2023 11:52:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, bhupesh.sharma@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com
Subject: Re: [PATCH net-next 08/11] net: stmmac: Add EMAC3 variant of dwmac4
Message-ID: <20230316115234.393bca5d@kernel.org>
In-Reply-To: <20230316183609.a3ymuku2cmhpyrpc@halaney-x13s>
References: <20230313165620.128463-1-ahalaney@redhat.com>
        <20230313165620.128463-9-ahalaney@redhat.com>
        <20230313173904.3d611e83@kernel.org>
        <20230316183609.a3ymuku2cmhpyrpc@halaney-x13s>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 13:36:09 -0500 Andrew Halaney wrote:
> static void emac3_config_cbs(struct mac_device_info *hw, u32 send_slope,
> 				    u32 idle_slope, u32 high_credit,
> 				    u32 low_credit, u32 queue)
> 
> I agree, that's quite gnarly to read. the emac3_config_cbs is the
> callback, so it's already at 6 arguments, so there's nothing I can
> trim there. I could create some struct for readability, populate that,
> then call the do_config_cbs() func with it from emac3_config_cbs.
> Is that the sort of thing you want to see?

Yes, a structure is much better, because it can be initialized member
by member,

struct bla my_bla = { .this = 1, .that = 2, .and = 3, another = 4, };

That's much easier to read. A poor man's version of Python's keyword
arguments, if you will.
