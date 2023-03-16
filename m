Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6970E6BCB62
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCPJuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCPJuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:50:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580E14B834;
        Thu, 16 Mar 2023 02:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA1E361FB3;
        Thu, 16 Mar 2023 09:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FA0C433EF;
        Thu, 16 Mar 2023 09:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678960210;
        bh=m5l503BDISnSlGXob2+iTWGt3YzL3096qBVoJwwdfjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r7FhgHEBmsMDP0TdNomSVKGzaeuzOjXZZ/glqFDQ0ijDERI9m/9eivHnEpSCPOaUN
         W5MpcpWHrlo18deKhSHH45jruRmfd/P+ZhtSiBMaL3LQOrAEEfV1Cqi9EQpQyn7VZb
         xuNFOYpfxau/QQLbTKwRN5moxu+Y4n6JVbi/1JSZTO6wRMmAQdM4+XiJq0YVKlaBZl
         b+GyzG57mGXR5/E58YJZryUs+6K3Pt1ysSiST9ar2CQMMu5R2wzxdgSOPYQtBy4mux
         v2S0yfY5LZd2sax1RxvtmJAt6nR5b2Y5NYAQPh8XsG84qxBK9pO5WlHTxezx0xeX8/
         e47hzSj7D7ovQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pckGU-0000N7-Tq; Thu, 16 Mar 2023 10:51:18 +0100
Date:   Thu, 16 Mar 2023 10:51:18 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: Re: [PATCH v6 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Message-ID: <ZBLmlgpTPd2ZzMo+@hovoldconsulting.com>
References: <20230316034759.73489-1-steev@kali.org>
 <20230316034759.73489-3-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316034759.73489-3-steev@kali.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 10:47:56PM -0500, Steev Klimaszewski wrote:
> Added regulators,GPIOs and changes required to power on/off wcn6855.
> Added support for firmware download for wcn6855.
> 
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> Tested-by: Bjorn Andersson <andersson@kernel.org>
> ---
> Changes since v5:
>  * Revert Set qcadev->initspeed since 6855 doesn't use it, don't touch.
>  * Convert get_fw_build_info to a switch statement
>  * Add poweroff handling
>  * Fix up line alignments
>  * Drop from microsoft extensions check since I don't actually know if we need

Thanks for the update.

Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>

Johan
