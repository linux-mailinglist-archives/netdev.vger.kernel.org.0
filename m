Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED359632C9A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiKUTGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiKUTGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:06:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5FD1DF04
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:06:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E80D7CE18AA
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D665BC433C1;
        Mon, 21 Nov 2022 19:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669057563;
        bh=3TKCNJ7xJki6/UZeUfu0Vyu0ujIO9wqu/DrvutJF91g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fUtdPdQv5AHM57EMWb2f3Aijsml1oZHSZ6G3g6GK76pnmhl1dmMTTRH29z0GrfBPf
         6HZbfUpDl2SNfja1LGsNDwqhLoO9AMA6rkF/XTGs8xErLuOxRFGr5+9oc8vStv6nwS
         YjbxYeB9h8j8yO8bNphaEcZTog70v607wtPsiphcEaBh0j0gC9ZRGr3Q7j73LqTCVA
         r5OUKfb6r35hE0D+I11HnqZHePQDB6MYHJlYPZ4vNkHl8zxQKce4a9HuBlLhFU2ayA
         LvsAp4tvtDjxCCABBnr3zqtB0TYcQeQ010cI0OYl5s+vLpffaS3pH2bGN32DVXJlSo
         i5lHnGlJIfkHg==
Date:   Mon, 21 Nov 2022 11:06:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/8] devlink: use min_t to calculate data_size
Message-ID: <20221121110602.6cc663f4@kernel.org>
In-Reply-To: <8b8d2f27-7295-4740-3264-9b4883153dd5@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
        <20221117220803.2773887-3-jacob.e.keller@intel.com>
        <20221118173628.2a9d6e7b@kernel.org>
        <753941bf-a1da-f658-f49b-7ae36f9406f8@intel.com>
        <8b8d2f27-7295-4740-3264-9b4883153dd5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Nov 2022 10:35:34 -0800 Jacob Keller wrote:
> > Sure, that makes sense.
> 
> This becomes the only variable in patch 5 of 8. It ends up making the 
> diff look more complicated if I change it back to a combined 
> declare+assign in that patch.

Don't change it back to declare+assign, then? :)
In general declare+assign should be used sparingly IMO.
My eyes are trained to skip right past the variable declarations,
the goal is to make the code clear, not short :S

BTW you can probably make DEVLINK_REGION_READ_CHUNK_SIZE a ULL to switch
from min_t() to min() ?
