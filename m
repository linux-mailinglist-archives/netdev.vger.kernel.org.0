Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0A668A7FF
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 04:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjBDDlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 22:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjBDDlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 22:41:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E7C6EDD2
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 19:41:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28EF2B82AD6
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 03:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA88C433EF;
        Sat,  4 Feb 2023 03:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675482092;
        bh=WsWgBt2tH++JXkyXB7EIAp2Z20LWTwYRMHcAOAtdqHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=byULJ6++AfNCgms6UR2Y7h6Cwd1itpSfnRNAP8TkUbntTeSSmUl1RVxu+UT3A2Hn2
         sp4vUBqQnU21P2vY0sng0YJk9R1IQoUNn2xurhVminQAVEXpp/SvYTqFtX//UcmbUL
         U1m2dZJfZ8lV1hChmGtVWboJxvoT+fFccP54+DLyOn3iTw5R/0Bagg917X7LQO3W5L
         4uzWlzESw4BCcmij93zSWCSrDqPLniaXxfULEAd6QpvvZ55dBaswOWCL3BFqNrBHEb
         JuwTCRCCHUePSLRkhXGaZeNy/Nz92ZwEEVYCUn/bkPlw1yOHqr9t4oqjBIuMKNU5hV
         2rXiQExvWrbyQ==
Date:   Fri, 3 Feb 2023 19:41:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v11 04/25] Documentation: document netlink
 ULP_DDP_GET/SET messages
Message-ID: <20230203194131.52b8c904@kernel.org>
In-Reply-To: <20230203132705.627232-5-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
        <20230203132705.627232-5-aaptel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Feb 2023 15:26:44 +0200 Aurelien Aptel wrote:
> +      do: &ulp-ddp-get-op
> +        request:
> +          value: 44
> +          attributes:
> +            - header
> +        reply:
> +          value: 44
> +          attributes:
> +            - header
> +            - hw
> +            - active
> +            - stats
> +      dump: *ulp-ddp-get-op
> +    -
> +      name: ulp-ddp-set
> +      doc: Set ULP DDP capabilities
> +
> +      attribute-set: ulp-ddp
> +
> +      do:
> +        request:
> +          value: 45
> +          attributes:
> +            - header
> +            - wanted
> +        reply:
> +          value: 45
> +          attributes:
> +            - header
> +            - hw
> +            - active

If you need to respin for other reasons - you can drop the value:
entries here. I had to add it for the previous command because of
the discontinuity in IDs but if you're just adding subsequent entries
- the value being previous + 1 is implied.

Acked-by: Jakub Kicinski <kuba@kernel.org>
