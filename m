Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87AE50670B
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344736AbiDSIk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241487AbiDSIk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:40:28 -0400
X-Greylist: delayed 310 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Apr 2022 01:37:44 PDT
Received: from anxur.fi.muni.cz (anxur.ip6.fi.muni.cz [IPv6:2001:718:801:230::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2755BCAF;
        Tue, 19 Apr 2022 01:37:44 -0700 (PDT)
Received: by anxur.fi.muni.cz (Postfix, from userid 11561)
        id 103EE60A95; Tue, 19 Apr 2022 10:32:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fi.muni.cz;
        s=20190124; t=1650357148;
        bh=jymOhwxmQe12q8zbmcOQnJ6kTXHr2kL9eIxQfNWshKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SIQgz8DSiu6FRZvg0mkbG4ICIEvN8Ck/dWVowXRSfo6OAT42eT+iA9/loSigwb5r1
         2Af5qU8qjgwigEBsBXbZpe0r34a4U+p1tUFBrTueYRuR8mLmEfNHLg4Ql/dKwEjAm4
         xqeLJf5mM2wtY40ossEX7tcv0EeufFWG+mlqIgo0=
Date:   Tue, 19 Apr 2022 10:32:28 +0200
From:   Jan Kasprzak <kas@fi.muni.cz>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net: cosa: fix error check return value of
 register_chrdev()
Message-ID: <20220419083228.GA25641@fi.muni.cz>
References: <20220418105834.2558892-1-lv.ruyi@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418105834.2558892-1-lv.ruyi@zte.com.cn>
X-Clacks-Overhead: GNU Terry Pratchett
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-By: Jan "Yenya" Kasprzak <kas@fi.muni.cz>

Thanks!

-Yenya

cgel.zte@gmail.com wrote:
: From: Lv Ruyi <lv.ruyi@zte.com.cn>
: 
: If major equal 0, register_chrdev() returns error code when it fails.
: This function dynamically allocate a major and return its number on
: success, so we should use "< 0" to check it instead of "!".
: 
: Reported-by: Zeal Robot <zealci@zte.com.cn>
: Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
: ---
:  drivers/net/wan/cosa.c | 2 +-
:  1 file changed, 1 insertion(+), 1 deletion(-)
: 
: diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
: index 23d2954d9747..1e5672019922 100644
: --- a/drivers/net/wan/cosa.c
: +++ b/drivers/net/wan/cosa.c
: @@ -349,7 +349,7 @@ static int __init cosa_init(void)
:  		}
:  	} else {
:  		cosa_major = register_chrdev(0, "cosa", &cosa_fops);
: -		if (!cosa_major) {
: +		if (cosa_major < 0) {
:  			pr_warn("unable to register chardev\n");
:  			err = -EIO;
:  			goto out;
: -- 
: 2.25.1
: 

-- 
| Jan "Yenya" Kasprzak <kas at {fi.muni.cz - work | yenya.net - private}> |
| http://www.fi.muni.cz/~kas/                         GPG: 4096R/A45477D5 |
    We all agree on the necessity of compromise. We just can't agree on
    when it's necessary to compromise.                     --Larry Wall
