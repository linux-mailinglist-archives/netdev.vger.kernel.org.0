Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B2E6BC491
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjCPDTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCPDSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:18:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498B3A18A7;
        Wed, 15 Mar 2023 20:18:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F1C8B81FB9;
        Thu, 16 Mar 2023 03:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE274C433AE;
        Thu, 16 Mar 2023 03:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678936682;
        bh=y0sZoUeFff+6cDV3HaVMqB5f4yIzmgYZdM8d6h5o3pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jawiJkp4F2oYL3A1ptkMbLijjPnwxZp3UEKvAHclV5SnuNbnvSKtEvzsA5/2zLFX1
         wNhl3Zja0S9RiC6c6bD5aJ5EDGoejYe2Q/W4Vqyf2ipXCkD7RERM0xTkL5tBHBmYt0
         uNmGObR85LSgDkI6ZAhx09n+b+bA1g734mcxcies2Dd4UAa2enhH1EHydVBWDzFQyH
         qYLuQ3LGLLxZ7bQl/kv9TiHXU5iRi4PENdtAc6jrSCWOOPZB4XNptSZ4Tau1K/qHAz
         4hgcG/tmkkee1FWYq1YSJ4cL3D3TRPVAyalv3ZCpfpl8WMXTtiBop9i10FzPY+51Ia
         0L8sJJUIiXpHg==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Elliot Berman <quic_eberman@quicinc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Bjorn Andersson <quic_bjorande@quicinc.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        ath10k@lists.infradead.org, Jassi Brar <jassisinghbrar@gmail.com>,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-remoteproc@vger.kernel.org,
        Carl van Schaik <quic_cvanscha@quicinc.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        netdev@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Murali Nalajala <quic_mnalajal@quicinc.com>,
        Will Deacon <will@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
        Marc Zyngier <maz@kernel.org>, linux-doc@vger.kernel.org,
        Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
        Trilok Soni <quic_tsoni@quicinc.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: (subset) [PATCH v9 17/27] firmware: qcom_scm: Use fixed width src vm bitmap
Date:   Wed, 15 Mar 2023 20:21:02 -0700
Message-Id: <167893686406.303819.2573416221076147237.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230120224627.4053418-18-quic_eberman@quicinc.com>
References: <20230120224627.4053418-1-quic_eberman@quicinc.com> <20230120224627.4053418-18-quic_eberman@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Jan 2023 14:46:16 -0800, Elliot Berman wrote:
> The maximum VMID for assign_mem is 63. Use a u64 to represent this
> bitmap instead of architecture-dependent "unsigned int" which varies in
> size on 32-bit and 64-bit platforms.
> 
> 

Applied, thanks!

[17/27] firmware: qcom_scm: Use fixed width src vm bitmap
        commit: 968a26a07f75377afbd4f7bb18ef587a1443c244

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
