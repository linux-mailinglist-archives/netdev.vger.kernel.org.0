Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5500A56A908
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 19:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbiGGREZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 13:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbiGGREM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 13:04:12 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A085C94C;
        Thu,  7 Jul 2022 10:04:05 -0700 (PDT)
Received: (Authenticated sender: ben@demerara.io)
        by mail.gandi.net (Postfix) with ESMTPSA id 5E422100005;
        Thu,  7 Jul 2022 17:04:01 +0000 (UTC)
Message-ID: <cb49da01-584a-bb71-eecb-c54e40bce062@demerara.io>
Date:   Thu, 7 Jul 2022 18:04:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101
 Thunderbird/103.0a1
Subject: Re: [PATCH 2/3] wfx: add antenna configuration files
Content-Language: en-US
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-firmware@kernel.org
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jerome.pouiller@gmail.com
References: <20220221163754.150011-1-Jerome.Pouiller@silabs.com>
 <20220221163754.150011-3-Jerome.Pouiller@silabs.com>
From:   Ben Brown <ben@demerara.io>
In-Reply-To: <20220221163754.150011-3-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/02/2022 16:37, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
<snip>
> diff --git a/WHENCE b/WHENCE
> index 0a6cb15..96f67f7 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -5845,8 +5845,18 @@ Driver: wfx - Silicon Labs Wi-Fi Transceiver
>  File: wfx/wfm_wf200_C0.sec
>  Version: 3.12.1
>  
> +File: wfx/brd4001a.pds not listed in WHENCE
> +File: wfx/brd8022a.pds not listed in WHENCE
> +File: wfx/brd8023a.pds not listed in WHENCE

This format does not appear to be correct. While this will seemingly
pass the `check_whence.py` check, it will be completely ignored by
`copy-firmware.sh`, as that takes the full line after 'File: ' (e.g.
'wfx/brd4001a.pds not listed in WHENCE', which of course does not exist).

I'm assuming the trailing ' not listed in WHENCE' needs to be removed
from each of these lines. Otherwise these are likely not being picked up
by distros (they are missing from Arch, for example). This may have been
the intention, but that seems odd (and unclear if so).


Regards,
Ben
