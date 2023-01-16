Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A6166BCE4
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjAPL3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjAPL2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:28:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA8B1F5D0;
        Mon, 16 Jan 2023 03:28:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1527CB80E59;
        Mon, 16 Jan 2023 11:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E02FC433D2;
        Mon, 16 Jan 2023 11:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673868518;
        bh=m8r+MA8M9SSTC6lPE34HeHkrHNMpB1WU90h6CeoFNkM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aosC56xLVELNoaaT32vZpAaADbjkcp3GKCBZapKF/pycro35XRHMSl2Q33jtK6W3g
         qXLDOhYSAm3gpRpfk0bOstzJYTbzXillz6DjTKV1MbS7wQuOfKpz/Gv5osjIu0XbJW
         irkK4MR9dsntQTN1di3Pc4znIDUVWaWOvuNd9ge5ege1e8BNEEErlH9SLRL7T3QXKK
         xdB34hEPOh0N9gXEsOt/V230tUYFmiEPwiUjFB7So+geFCBL2gA8skywj37VnMX7T3
         fatS4s3IXYyAlMpG2w0ecAZtJsh08KMlCZTo4keHrD0OrOr3BDJ83/avGkQJ91DST5
         0ChW7DdbjNczw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230111175031.7049-1-szymon.heidrich@gmail.com>
References: <20230111175031.7049-1-szymon.heidrich@gmail.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     alexander.duyck@gmail.com, jussi.kivilinna@iki.fi,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, greg@kroah.com, szymon.heidrich@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167386851260.4736.15589868061067872069.kvalo@kernel.org>
Date:   Mon, 16 Jan 2023 11:28:36 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Szymon Heidrich <szymon.heidrich@gmail.com> wrote:

> Since resplen and respoffs are signed integers sufficiently
> large values of unsigned int len and offset members of RNDIS
> response will result in negative values of prior variables.
> This may be utilized to bypass implemented security checks
> to either extract memory contents by manipulating offset or
> overflow the data buffer via memcpy by manipulating both
> offset and len.
> 
> Additionally assure that sum of resplen and respoffs does not
> overflow so buffer boundaries are kept.
> 
> Fixes: 80f8c5b434f9 ("rndis_wlan: copy only useful data from rndis_command respond")
> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Patch applied to wireless.git, thanks.

b870e73a56c4 wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230111175031.7049-1-szymon.heidrich@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

