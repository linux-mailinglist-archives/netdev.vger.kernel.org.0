Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A44695DC1
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjBNI6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbjBNI6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:58:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AB7126D8;
        Tue, 14 Feb 2023 00:58:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A987614B5;
        Tue, 14 Feb 2023 08:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52427C433EF;
        Tue, 14 Feb 2023 08:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676365126;
        bh=2Mx33+vREW0hBWChvR3fhbCd1ACURr0Cnsk5gvIAps8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MFW/w0XIdOIS1xNdLpuQS1+t4sw4dF5SJ4dUA1yOgIw+87cFeBAm1ycOmkgBbrkqD
         Va2135tatjWfeTK3GAmD3M2I+BFrG7cYzuB4bWjAdMCC+WLDe0ElhDbboV0iaXjB+K
         USC5sF/TgKzw5dYvLQ+vQoVpKl9fWJInENMtDnEY=
Date:   Tue, 14 Feb 2023 09:58:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bjorn Andersson <andersson@kernel.org>
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
Message-ID: <Y+tNRPf0PGdShf5l@kroah.com>
References: <20230213181832.3489174-1-quic_eberman@quicinc.com>
 <20230213214417.mtcpeultvynyls6s@ripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213214417.mtcpeultvynyls6s@ripper>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 01:44:17PM -0800, Bjorn Andersson wrote:
> On Mon, Feb 13, 2023 at 10:18:29AM -0800, Elliot Berman wrote:
> > The maximum VMID for assign_mem is 63. Use a u64 to represent this
> > bitmap instead of architecture-dependent "unsigned int" which varies in
> > size on 32-bit and 64-bit platforms.
> > 
> > Acked-by: Kalle Valo <kvalo@kernel.org> (ath10k)
> > Tested-by: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
> > Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> 
> Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> 
> @Greg, would you mind taking this through your tree for v6.3, you
> already have a related change in fastrpc.c in your tree...

I tried, but it doesn't apply to my char-misc tree at all:

checking file drivers/firmware/qcom_scm.c
Hunk #1 succeeded at 898 (offset -7 lines).
Hunk #2 succeeded at 915 (offset -7 lines).
Hunk #3 succeeded at 930 (offset -7 lines).
checking file drivers/misc/fastrpc.c
checking file drivers/net/wireless/ath/ath10k/qmi.c
checking file drivers/remoteproc/qcom_q6v5_mss.c
Hunk #1 succeeded at 227 (offset -8 lines).
Hunk #2 succeeded at 404 (offset -10 lines).
Hunk #3 succeeded at 939 with fuzz 1 (offset -28 lines).
checking file drivers/remoteproc/qcom_q6v5_pas.c
Hunk #1 FAILED at 94.
1 out of 1 hunk FAILED
checking file drivers/soc/qcom/rmtfs_mem.c
Hunk #1 succeeded at 30 (offset -1 lines).
can't find file to patch at input line 167
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/include/linux/firmware/qcom/qcom_scm.h
b/include/linux/firmware/qcom/qcom_scm.h
|index 1e449a5d7f5c..250ea4efb7cb 100644
|--- a/include/linux/firmware/qcom/qcom_scm.h
|+++ b/include/linux/firmware/qcom/qcom_scm.h
--------------------------

What tree is this patch made against?

thanks,

greg k-h
