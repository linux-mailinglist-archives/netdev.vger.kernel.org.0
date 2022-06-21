Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D379552A5C
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 06:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344398AbiFUEre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 00:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiFUErc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 00:47:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459DE183B3
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 21:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9703060DF7
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 04:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FAEC3411D;
        Tue, 21 Jun 2022 04:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655786839;
        bh=2Un33cgWUTTy10j5hYwxQDoeBlf4PdwmIZEQ1NKZoWY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VEq3vgsKg0F/jOx5n20M2e91hJaZ5eF2LxrdtEwWo8fuQPySspnOZ3iBhtczt3CWR
         AknCq2Z/z4I7ZOZDMW9XOSB9EWoJYIb55QAC5JTYy9TtsXnMuYDjigR9W1rM/zdcU2
         5Pb4VnFB+KKVPz2g2esfwra8seu16Uy/O1pPf8sIfoZPSn7uHb8bsP9Deo5aKJwptL
         Z1fQcxcAAeNDIdvPe54iEGYOUOAHlDRaTllOEeeIf3E6F6EwtZksjdDoqvSB6fenVZ
         vFUH9Up3+E+lVaB+SoinEUrDeJpOShV3jWIFoiTm2COAlzPShj3hEP+U0vaD4HfXJP
         oW/EKnT+I1Kqg==
Date:   Mon, 20 Jun 2022 21:47:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>
Subject: Re: [PATCH net-next] nfp: compose firmware file name with new
 hwinfo "nffw.partno"
Message-ID: <20220620214717.71537153@kernel.org>
In-Reply-To: <20220620103912.46164-1-simon.horman@corigine.com>
References: <20220620103912.46164-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jun 2022 12:39:12 +0200 Simon Horman wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> During initialization of the NFP driver, a file name for loading
> application firmware is composed using the NIC's AMDA information and port
> type (count and speed). E.g.: "nic_AMDA0145-1012_2x10.nffw".
> 
> In practice there may be many variants for each NIC type, and many of the
> variants relate to assembly components which do not concern the driver and
> application firmware implementation. Yet the current scheme leads to a
> different application firmware file name for each variant, because they
> have different AMDA information.
> 
> To reduce proliferation of content-duplicated application firmware images
> or symlinks, the NIC's management firmware will only expose differences
> between variants that need different application firmware via a newly
> introduced hwinfo, "nffw.partno".
> 
> Use of the existing hwinfo, "assembly.partno", is maintained in order to
> support for NICs with management firmware that does not expose
> "nffw.partno".
> 
> Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

FWIW:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
