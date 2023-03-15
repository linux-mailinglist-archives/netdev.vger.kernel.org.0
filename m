Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EB66BAD71
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjCOKTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjCOKTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:19:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E5623A73;
        Wed, 15 Mar 2023 03:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAEC0B81DB7;
        Wed, 15 Mar 2023 10:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B443C4339B;
        Wed, 15 Mar 2023 10:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678875516;
        bh=P4PR/J1VSp93ASIxZ95h9QGDLtrqnHpwJX+AZxMNMiA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=vPDNpTZFF02nnIbA8wP8f0pmHYThgI1wYVo95qD16L+YOup+r/10ImZaBeTsuc4ZC
         x5P/eFMQ8Hiw5LsLeWHTse0+HPiCE2fKC6uKnymsiFDLx3EDNGB4gjU+lYXPmXaSx3
         LK2sGy/ysXCdSq2DvSfYvvs2eKEoh9a+MWz4TuhXVEPOKTsWzQwqxeJjhhP2lJrAz8
         89XxuFPUXDi+hLRqqWjj4uORwAZFnLmjoE2+o//lwbgZCB/tvG9qhAXBs9Ld0/UZA7
         hOFt2cbX9sxjlz8qqSoiZxG6P1+TIC/I2/5bIi9g8cMTvWzSJeVgpq4Wb+FcdW0edu
         6ekOvkH+HUw1A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath12k: Add missing unwind goto in
 ath12k_pci_probe()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230307104706.240119-1-harshit.m.mogalapalli@oracle.com>
References: <20230307104706.240119-1-harshit.m.mogalapalli@oracle.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     unlisted-recipients:; (no To-header on input) error27@gmail.com,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        P Praneesh <quic_ppranees@quicinc.com>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)error27@gmail.com
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167887550837.27926.11659991726085359589.kvalo@kernel.org>
Date:   Wed, 15 Mar 2023 10:18:33 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com> wrote:

> Smatch Warns:
>         drivers/net/wireless/ath/ath12k/pci.c:1198 ath12k_pci_probe()
>         warn: missing unwind goto?
> 
> Store the error value in ret and use correct label with a goto.
> 
> Only Compile tested, found with Smatch.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://lore.kernel.org/all/Y+426q6cfkEdb5Bv@kili/
> Suggested-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

488d9a484f96 wifi: ath12k: Add missing unwind goto in ath12k_pci_probe()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230307104706.240119-1-harshit.m.mogalapalli@oracle.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

