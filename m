Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593F752905B
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 22:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244772AbiEPUOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348229AbiEPUNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:13:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C9A1402B;
        Mon, 16 May 2022 13:07:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13263B8160D;
        Mon, 16 May 2022 20:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C4BC385AA;
        Mon, 16 May 2022 20:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652731627;
        bh=2oHu2lhqVArxUeRpeWfK80VGG2Jg12XQxHaXI1SK7Es=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XDVyAo4+h6+CWwT6cHzq7d2W7k3WO47CMu0dQG3dXNvLZLO5dyKSAnVnqmOMJv4s9
         OW13kfOyoB2P6HPuzrEcl/LduJfIzgJK9+bd5Ej0N0bf7gSjv/baSbJLb4oyWj6YBa
         GSCW5DBt2mJDE5TXmXHF9rg3phBDUaS6/z9w/GwCoS/afRBohzMbDNQOnvndshnL6t
         iiB97ztZP3HDj4jcNlwQfVEBmFIgL3DILIM9IbvIFa8UgBS4KVui0U8+3LjiL4zEhp
         jXW4d5EG2/jdMq2siS4hoLop0VZMiUOcxpGKk+jNzm3swmviREhFOLTd+kGaugd9ug
         FNimXEbGwesZA==
Date:   Mon, 16 May 2022 13:07:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     netdev@vger.kernel.org, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org
Subject: Re: [PATCH net] NFC: nci: fix sleep in atomic context bugs caused
 by nci_skb_alloc
Message-ID: <20220516130705.2d51a6cf@kernel.org>
In-Reply-To: <20220513133355.113222-1-duoming@zju.edu.cn>
References: <20220513133355.113222-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 May 2022 21:33:55 +0800 Duoming Zhou wrote:
> Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation ")
> Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")

Are there more bad callers? If st_nci_se_wt_timeout is the only source
of trouble then the fixes tag should point to when it was added, rather
than when the callee was added.
