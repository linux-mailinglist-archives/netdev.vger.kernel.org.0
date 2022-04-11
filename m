Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955724FB142
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 03:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbiDKBNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 21:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiDKBNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 21:13:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDC63A5C0;
        Sun, 10 Apr 2022 18:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE86F60EF9;
        Mon, 11 Apr 2022 01:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509F6C385A1;
        Mon, 11 Apr 2022 01:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649639497;
        bh=fTes6JGGokhrpUq274WThThhCqdCAPEybXDIHMyHnwc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oOXEPH+K+bkdawVLm6QgS7WbUZe1Y4g1AcfifMPfr7IRWK9XmH3R+HHrvjDTGnJfa
         vWjMw5PImV/9P+0ogrDTBv1KhBmN1BoztpVw8Lj66M3gtf2BKCr25qUtuA5pukJFMt
         GQdq6QM/capKfXb2A+yEiE0Gx61lOiaXVkoXWvifkJI4D7HdzIyu6sG0Zl/h5IzjN4
         zGi4a1QJmeaOJFC1ARXOhj88xYYWOIT/0MPlL94CtsOhauEJxqJftgi4srk+TRQ0RY
         MIzNoh8VRAJf+5mEqm3bHB0kGxm8tDeqkmYsW02yMTlPPSb1p/M5bgyIR/eyMXg47m
         kDErvtt+yDeMA==
Message-ID: <636075e9-8902-6909-1a7d-8dfdc395d67d@kernel.org>
Date:   Sun, 10 Apr 2022 19:11:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net] ipv6: fix panic when forwarding a pkt with no in6 dev
Content-Language: en-US
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Eric Dumazet <edumazet@google.com>,
        kongweibin <kongweibin2@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, rose.chen@huawei.com,
        liaichun@huawei.com, stable@vger.kernel.org
References: <59150cd5-9950-2479-a992-94dcdaa5e63c@6wind.com>
 <20220408140342.19311-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220408140342.19311-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/22 8:03 AM, Nicolas Dichtel wrote:
> kongweibin reported a kernel panic in ip6_forward() when input interface
> has no in6 dev associated.
> 
> The following tc commands were used to reproduce this panic:
> tc qdisc del dev vxlan100 root
> tc qdisc add dev vxlan100 root netem corrupt 5%
> 
> CC: stable@vger.kernel.org
> Fixes: ccd27f05ae7b ("ipv6: fix 'disable_policy' for fwd packets")
> Reported-by: kongweibin <kongweibin2@huawei.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


