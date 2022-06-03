Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14CF53CD85
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 18:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiFCQvD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Jun 2022 12:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344103AbiFCQvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 12:51:01 -0400
Received: from relay4.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE0751E4F
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 09:50:59 -0700 (PDT)
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A48621869;
        Fri,  3 Jun 2022 16:50:58 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id 6CCA66000F;
        Fri,  3 Jun 2022 16:50:56 +0000 (UTC)
Message-ID: <b59b922f96603468cbbe69b6359ec417083c526b.camel@perches.com>
Subject: Re: [PATCH v1 1/2] wireless: ray_cs: Utilize strnlen() in
 parse_addr()
From:   Joe Perches <joe@perches.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Fri, 03 Jun 2022 09:50:55 -0700
In-Reply-To: <20220603164414.48436-1-andriy.shevchenko@linux.intel.com>
References: <20220603164414.48436-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        KHOP_HELO_FCRDNS,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: okcnk5cmofrjybgoo7ydqd64kod4ee87
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 6CCA66000F
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/4xxsV2H8BDzNRFB1JaWin3vAilsfloO8=
X-HE-Tag: 1654275056-704682
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-06-03 at 19:44 +0300, Andy Shevchenko wrote:
> Instead of doing simple operations and using an additional variable on stack,
> utilize strnlen() and reuse len variable.
[]
> diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
[]
> +	while (len > 0) {
> +		if ((k = hex_to_bin(in_str[len--])) != -1)
>  			out[i] = k;
>  		else
>  			return 0;

could be reversed and unindented

>  
> -		if (j == 0)
> +		if (len == 0)
>  			break;
> -		if ((k = hex_to_bin(in_str[j--])) != -1)
> +		if ((k = hex_to_bin(in_str[len--])) != -1)
>  			out[i] += k << 4;
>  		else
>  			return 0;

and here


