Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035F16328DA
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiKUP7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiKUP7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:59:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B62D14FA;
        Mon, 21 Nov 2022 07:59:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1DF8B810E5;
        Mon, 21 Nov 2022 15:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5D0C433D6;
        Mon, 21 Nov 2022 15:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669046357;
        bh=NiniSOPGKqhdfVPafjU8CKNZvdS31QSh/55JMb9zJes=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=a/XuarW4mNIbqbd7XBC2KEovRFbFI0Cn8HGxor9WCskdjYW9wP+i33fR3L/YbBAdb
         JBToPIO95id5D7gCvcI1UKdABittIPylI7B5C0y6Hje4bNLMt0kknKdWy+buSze5G9
         QliJMfMVSnIQdSgDXwmkUS1hM13R1DgRGSb+XUj/7hFPpXMWf9akqhod1iCCCvar9d
         wf8EVZWfUEKSZ3v+87b0ziwJPN4WP4ebWZBKxIyPpXNFnImRFbkEQT0yCxzrkgux89
         +tVaefxhLXHps+kJrZqFWY9j4ZnjMk7f5mdKV3dvCGelrv9EcVOXYoH0jcZWaIcjDq
         x5hT8nHQsCNNg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Elliot Berman <quic_eberman@quicinc.com>
Cc:     Bjorn Andersson <quic_bjorande@quicinc.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Murali Nalajala <quic_mnalajal@quicinc.com>,
        Trilok Soni <quic_tsoni@quicinc.com>,
        "Srivatsa Vaddagiri" <quic_svaddagi@quicinc.com>,
        Carl van Schaik <quic_cvanscha@quicinc.com>,
        Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Lorenzo Pieralisi" <lpieralisi@kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-acpi@vger.kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-remoteproc@vger.kernel.org>
Subject: Re: [PATCH v7 18/20] firmware: qcom_scm: Use fixed width src vm bitmap
References: <20221121140009.2353512-1-quic_eberman@quicinc.com>
        <20221121140009.2353512-19-quic_eberman@quicinc.com>
Date:   Mon, 21 Nov 2022 17:59:07 +0200
In-Reply-To: <20221121140009.2353512-19-quic_eberman@quicinc.com> (Elliot
        Berman's message of "Mon, 21 Nov 2022 06:00:07 -0800")
Message-ID: <874jus9u44.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Elliot Berman <quic_eberman@quicinc.com> writes:

> The maximum VMID for assign_mem is 63. Use a u64 to represent this
> bitmap instead of architecture-dependent "unsigned int" which varies in
> size on 32-bit and 64-bit platforms.
>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
>
> Note this will have build conflicts with
> https://lore.kernel.org/all/20221114-narmstrong-sm8550-upstream-mpss_dsm-v2-2-f7c65d6f0e55@linaro.org/
> which would also need an "unsigned int" -> "u64" in struct qcom_mpss_dsm_mem:perms.
>
>  drivers/firmware/qcom_scm.c           | 12 +++++++-----
>  drivers/misc/fastrpc.c                |  6 ++++--
>  drivers/net/wireless/ath/ath10k/qmi.c |  4 ++--

For ath10k:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
