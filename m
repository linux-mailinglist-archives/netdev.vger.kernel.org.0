Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CCE553E8B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 00:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353850AbiFUWcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 18:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiFUWce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 18:32:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6B131906;
        Tue, 21 Jun 2022 15:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A237FB81983;
        Tue, 21 Jun 2022 22:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12855C3411C;
        Tue, 21 Jun 2022 22:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655850751;
        bh=7XdW2j4X4yyswL54ikYHYoDPSpxywaPFm4d3hRJ2gFI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d55LLhCIgpjTvbBzXN8A5UZGP/9wx+pxhakmYaKVkYbv7SSPJSFA+nw0MKbixdJmI
         oImR5ehqLnyUO1cwdegAvupLP0hzW8gzm4XIi8rHkEcsSjdW89LERSXMk4g+KQALtk
         pdt6u2fPsffDNfz7LtIveefziHWtxUbei8qYHWg7X8pZUVXzK0eN0fEC3SIZxprVda
         165UEX+3O06s4qlfAqbqhKI0DbEBQQb+ZdkI0Pg4dj9wvCSpdOXSlfsq0CsG7smwRn
         qi7N+R9TnNIq2SbVDSgs1MS9Y3cu/CjXKccxYczOvfcA1j3fgHc+0+DzelumMDjXCI
         UwPCvcjAihuXA==
Date:   Tue, 21 Jun 2022 15:32:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     wintera@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/net: Fix duplicate 'the' in two places
Message-ID: <20220621153222.0d328987@kernel.org>
In-Reply-To: <20220621160756.16226-1-jiangjian@cdjrlc.com>
References: <20220621160756.16226-1-jiangjian@cdjrlc.com>
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

Please add the version to the patch subject.
This is the second versions, AFAIU so it should have had
[PATCH v2] in the subject line.

On Wed, 22 Jun 2022 00:07:56 +0800 Jiang Jian wrote:
> file: drivers/s390/net/qeth_core_main.c
> line: 3568
>                 /*
>                  * there's no outstanding PCI any more, so we
>                  * have to request a PCI to be sure the the PCI
>                  * will wake at some time in the future then we
>                  * can flush packed buffers that might still be
>                  * hanging around, which can happen if no
>                  * further send was requested by the stack
>                  */
> changed to:
> 		/*
>                  * there's no outstanding PCI any more, so we
>                  * have to request a PCI to be sure the PCI
>                  * will wake at some time in the future. Then we
>                  * can flush packed buffers that might still be
>                  * hanging around, which can happen if no
>                  * further send was requested by the stack
>                  */

That's basically a copy of the diff, please describe the why and what
not how.

> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> ---
>  drivers/s390/net/qeth_core_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
> index 9e54fe76a9b2..5248f97ee7a6 100644
> --- a/drivers/s390/net/qeth_core_main.c
> +++ b/drivers/s390/net/qeth_core_main.c
> @@ -3565,8 +3565,8 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
>  			if (!atomic_read(&queue->set_pci_flags_count)) {
>  				/*
>  				 * there's no outstanding PCI any more, so we
> -				 * have to request a PCI to be sure the the PCI
> -				 * will wake at some time in the future then we
> +                 * have to request a PCI to be sure the PCI
> +                 * will wake at some time in the future. Then we

You broke the whitespace now.
