Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A9162A481
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiKOVwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiKOVwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:52:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E593B869;
        Tue, 15 Nov 2022 13:52:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D86DAB81B76;
        Tue, 15 Nov 2022 21:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3835C433D6;
        Tue, 15 Nov 2022 21:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668549151;
        bh=EX0dtFkOYtkcGU6zsa6IeJMRTQKuD4qbguL+7bW5s9I=;
        h=Date:From:To:Cc:Subject:From;
        b=WiJFUamwf5cFGkdpmf+Gx300gvWy+ricshy+HBYwQHZLKf6C5lgcox9Rdc/ZEUtfq
         QmQ5fiT0JtvVT3rjQ3x4yCRidX7zIhIqjizF/R/IEFtw4w/t2fkdvUoRl6NT1D9zRo
         4ycbMoA48sFJk/F+dyDas0bEyXMnvONpEtrhKkuYWIuELAxN93sjb2QOU3j0nwXz6I
         zVDAMyN+PlBsN5ieHhmfzeo56ibKwm9fOnclG/XOSvcxyu53NrBleC1HYJ+iamy64w
         oGQKe8Gxvh1Bsi2e+fknZ2+1DkGbaMFwtUtbV+56z39uCWBiV0Uzm07EJMkcC+BlI6
         BZ8r151Up+GJg==
Date:   Tue, 15 Nov 2022 15:52:15 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 0/2][next] wifi: brcmfmac: common: Replace one-element array
 with flexible-array member
Message-ID: <cover.1668548907.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series aims to replace a one-element array with flexible-array
member in drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
(in struct brcmf_dload_data_le) and use the struct_size() helper.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/230
Link: https://github.com/KSPP/linux/issues/79
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]

Gustavo A. R. Silva (2):
  wifi: brcmfmac: replace one-element array with flexible-array member
    in struct brcmf_dload_data_le
  wifi: brcmfmac: Use struct_size() in code ralated to struct
    brcmf_dload_data_le

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c  | 7 ++++---
 .../net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h  | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.34.1

