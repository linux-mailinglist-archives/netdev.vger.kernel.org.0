Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394235128C5
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240576AbiD1Bau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240368AbiD1Bap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E1872471;
        Wed, 27 Apr 2022 18:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5614961F4C;
        Thu, 28 Apr 2022 01:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B7AC385A7;
        Thu, 28 Apr 2022 01:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651109251;
        bh=5dLrCbyI9dL25gLCPU2lKXEykc++03SFd32wMmRhRMY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=koKAxCKdTDd8Xos0qjF/PfaziMK1H7iXllHu4DOFfT+tReZ2slA19GSEMY1NlrAXx
         VCl18ElprtpHwUe4m65SdEsv1lGqWR3skTPCIuYj/AcvueZmK3CfpzJW38Oe9aW1zU
         niSCpJJrh/1kho5qWUQ0hxDz49tTwAxQmRAVgyHOutEFpbyFTQT+0/n0f2LPwPcn1R
         +Dx77zrHy1TrRK6QnZ774j01Ivr9AWwFEgJu1KMLXjMZHmBX7IyZ29UEvIk2CTFpUy
         L/bxWFE2CanErRZcRufMiQgOIsSO8CHUEukTRo4tKbwzfo1NiCLAjsYKkuz+oVQVEq
         ZQkANYmzOu1Zg==
Message-ID: <bde14dfc-d1ea-ca1f-5074-01e13eef3cab@kernel.org>
Date:   Wed, 27 Apr 2022 19:27:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v3] net: SO_RCVMARK socket option for SO_MARK
 with recvmsg()
Content-Language: en-US
To:     Erin MacNeil <lnx.erin@gmail.com>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Martynas Pumputis <m@lambda.lt>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Wei Wang <weiwan@google.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Florian Westphal <fw@strlen.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Willem de Bruijn <willemb@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Richard Sanger <rsanger@wand.net.nz>,
        Yajun Deng <yajun.deng@linux.dev>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-can@vger.kernel.org, linux-wpan@vger.kernel.org,
        linux-sctp@vger.kernel.org
References: <202204270907.nUUrw3dS-lkp@intel.com>
 <20220427200259.2564-1-lnx.erin@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220427200259.2564-1-lnx.erin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/22 2:02 PM, Erin MacNeil wrote:
> Adding a new socket option, SO_RCVMARK, to indicate that SO_MARK
> should be included in the ancillary data returned by recvmsg().
> 
> Renamed the sock_recv_ts_and_drops() function to sock_recv_cmsgs().
> 
> Signed-off-by: Erin MacNeil <lnx.erin@gmail.com>
> ---


Reviewed-by: David Ahern <dsahern@kernel.org>

