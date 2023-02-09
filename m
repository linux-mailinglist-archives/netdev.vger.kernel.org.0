Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0FB68FECF
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 05:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjBIEa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 23:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBIEaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 23:30:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98EB3B64B;
        Wed,  8 Feb 2023 20:29:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88ECBB8201A;
        Thu,  9 Feb 2023 04:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1454C433EF;
        Thu,  9 Feb 2023 04:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675916532;
        bh=r896al9/ic3TVzWhQihrH5WWe9yq5i1aPuOB0FJblUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BN/W1fmhyUDYnWQNFRl0yiZAlLtkPZOeM9PRJliT8ril6wiUbcRvBv1HMVz8E0tvT
         mbyq5LYLXG+Q0iC3FE+j8oPN8wrX8CzcUUbhXZ8fLkv6SW7OFkTdgoSDQ4Z4S7676q
         ekM+HlbJO6e1a7rJmpHX2uhrjQmq5U7OdTYpCuhnJvE8DoMV488k6BQ9GV5iJQMl+R
         Z4eAbD3zOtPVRjxwl6mYHQRaDOaj1IjnIDvEt0MNJ02q3yVnhiKjhsmUqY3r16pJbp
         2l1erYVmeAs/OrQ3L+bCLx5ypvDAgc3kGR5MyqzFDCB3QgSGPs4TzDKRQdWSO0Gb80
         XNY+n6Qa5PJyg==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Rob Clark <robdclark@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Elliot Berman <quic_eberman@quicinc.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andy Gross <agross@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alex Elder <elder@kernel.org>, Sean Paul <sean@poorly.run>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Will Deacon <will@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Vikash Garodia <quic_vgarodia@quicinc.com>,
        David Airlie <airlied@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Amit Kucheria <amitk@kernel.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-pm@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-remoteproc@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-media@vger.kernel.org, linux-scsi@vger.kernel.org,
        dri-devel@lists.freedesktop.org, ath10k@lists.infradead.org,
        freedreno@lists.freedesktop.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] firmware: qcom_scm: Move qcom_scm.h to include/linux/firmware/qcom/
Date:   Wed,  8 Feb 2023 20:23:26 -0800
Message-Id: <167591660372.1230100.2523010471979974316.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203210956.3580811-1-quic_eberman@quicinc.com>
References: <20230203210956.3580811-1-quic_eberman@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Feb 2023 13:09:52 -0800, Elliot Berman wrote:
> Move include/linux/qcom_scm.h to include/linux/firmware/qcom/qcom_scm.h.
> This removes 1 of a few remaining Qualcomm-specific headers into a more
> approciate subdirectory under include/.
> 
> 

Applied, thanks!

[1/1] firmware: qcom_scm: Move qcom_scm.h to include/linux/firmware/qcom/
      commit: 3bf90eca76c98c55c975fa817799789b9176f9f3

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
