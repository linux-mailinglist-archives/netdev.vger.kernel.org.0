Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375D26BA5E6
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjCOEIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjCOEIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:08:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B86B171E;
        Tue, 14 Mar 2023 21:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2258E61AAD;
        Wed, 15 Mar 2023 04:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27010C433D2;
        Wed, 15 Mar 2023 04:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678853277;
        bh=KJqyxTArsBbv6ReyKMgsMSt6IK3Nx4mxhE44Z4zwGi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KubU8rW5zY1FS0YPdL5x43KMZenlN84ZIrfHq4nxfw3uGXTt6hcvuywqbabSvzZVL
         t9ugsSaMCjKQL4sEISaKMfzJzqvLLQFQI+bhDCI4+4r+z8KvcDy0y/1XhgCCymNPEX
         TH1TvXD+2i6NmINmWYqfvfZNk4aYqgj3BG7TM2tSNUy0er6kniiNPIPPOzjaLyjyYV
         aiY0qexUbqz/90PvCWBRho/NJKGzPW0fyYzJl6trUAPjy829CBGznfbh8DP60K9+8V
         PZwaC7FNxujAHBVBYef/nty+R6hUmBsdQmsvsULPKq5BVPtwHyZTfYuhfp9S5LlJEk
         piSSadL8T2tow==
Date:   Tue, 14 Mar 2023 21:11:19 -0700
From:   Bjorn Andersson <andersson@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Elliot Berman <quic_eberman@quicinc.com>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org
Subject: Re: [PATCH] firmware: qcom_scm: Use fixed width src vm bitmap
Message-ID: <20230315041119.fp7npwa5bia5hck3@ripper>
References: <20230213181832.3489174-1-quic_eberman@quicinc.com>
 <20230213214417.mtcpeultvynyls6s@ripper>
 <Y+tNRPf0PGdShf5l@kroah.com>
 <20230214172325.lplxgbprhj3bzvr3@ripper>
 <bdda82f7-933d-443b-614a-6befad2899b5@quicinc.com>
 <2ae96b75-82f1-165a-e56d-7446c90bb7af@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ae96b75-82f1-165a-e56d-7446c90bb7af@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 01:09:08PM -0800, Elliot Berman wrote:
> 
> 
> On 2/14/2023 10:52 AM, Elliot Berman wrote:
> > 
> > 
> > On 2/14/2023 9:23 AM, Bjorn Andersson wrote:
> > > On Tue, Feb 14, 2023 at 09:58:44AM +0100, Greg Kroah-Hartman wrote:
> > > > On Mon, Feb 13, 2023 at 01:44:17PM -0800, Bjorn Andersson wrote:
> > > > > On Mon, Feb 13, 2023 at 10:18:29AM -0800, Elliot Berman wrote:
> > > > > > The maximum VMID for assign_mem is 63. Use a u64 to represent this
> > > > > > bitmap instead of architecture-dependent "unsigned int"
> > > > > > which varies in
> > > > > > size on 32-bit and 64-bit platforms.
> > > > > > 
> > > > > > Acked-by: Kalle Valo <kvalo@kernel.org> (ath10k)
> > > > > > Tested-by: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
> > > > > > Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> > > > > 
> > > > > Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> > > > > 
> > > > > @Greg, would you mind taking this through your tree for v6.3, you
> > > > > already have a related change in fastrpc.c in your tree...
> > > > 
> > > > I tried, but it doesn't apply to my char-misc tree at all:
> > > > 
> > > > checking file drivers/firmware/qcom_scm.c
> > > > Hunk #1 succeeded at 898 (offset -7 lines).
> > > > Hunk #2 succeeded at 915 (offset -7 lines).
> > > > Hunk #3 succeeded at 930 (offset -7 lines).
> > > > checking file drivers/misc/fastrpc.c
> > > > checking file drivers/net/wireless/ath/ath10k/qmi.c
> > > > checking file drivers/remoteproc/qcom_q6v5_mss.c
> > > > Hunk #1 succeeded at 227 (offset -8 lines).
> > > > Hunk #2 succeeded at 404 (offset -10 lines).
> > > > Hunk #3 succeeded at 939 with fuzz 1 (offset -28 lines).
> > > > checking file drivers/remoteproc/qcom_q6v5_pas.c
> > > > Hunk #1 FAILED at 94.
> > > > 1 out of 1 hunk FAILED
> > > > checking file drivers/soc/qcom/rmtfs_mem.c
> > > > Hunk #1 succeeded at 30 (offset -1 lines).
> > > > can't find file to patch at input line 167
> > > > Perhaps you used the wrong -p or --strip option?
> > > > The text leading up to this was:
> > > > --------------------------
> > > > |diff --git a/include/linux/firmware/qcom/qcom_scm.h
> > > > b/include/linux/firmware/qcom/qcom_scm.h
> > > > |index 1e449a5d7f5c..250ea4efb7cb 100644
> > > > |--- a/include/linux/firmware/qcom/qcom_scm.h
> > > > |+++ b/include/linux/firmware/qcom/qcom_scm.h
> > > > --------------------------
> > > > 
> > > > What tree is this patch made against?
> > > > 
> > > 
> > > Sorry about that, I missed the previous changes in qcom_q6v5_pas in the
> > > remoteproc tree. Elliot said he based it on linux-next, so I expect that
> > > it will merge fine on top of -rc1, once that arrives.
> > > 
> > 
> > Yes, this patch applies on next-20230213. I guess there are enough
> > changes were coming from QCOM side (via Bjorn's qcom tree) as well as
> > the fastrpc change (via Greg's char-misc tree).
> > 
> > Let me know if I should do anything once -rc1 arrives. Happy to post
> > version on the -rc1 if it helps.
> > 
> 
> The patch now applies on tip of Linus's tree and on char-misc.

Greg, I have a couple more patches in the scm driver in my inbox. Would
you be okay with me pulling this through the Qualcomm tree for v6.4?

Regards,
Bjorn
