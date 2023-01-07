Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3778A660D51
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjAGJoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjAGJoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:44:38 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB280777E1;
        Sat,  7 Jan 2023 01:44:36 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id F2A641883896;
        Sat,  7 Jan 2023 09:44:33 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id ECF6A2500682;
        Sat,  7 Jan 2023 09:44:33 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id E289C9EC000C; Sat,  7 Jan 2023 09:44:33 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sat, 07 Jan 2023 10:44:33 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 2/3] net: dsa: mv88e6xxx: shorten the locked
 section in mv88e6xxx_g1_atu_prob_irq_thread_fn()
In-Reply-To: <20230106163759.42jrkxuyjlg3l3s5@skbuf>
References: <20230106160529.1668452-1-netdev@kapio-technology.com>
 <20230106160529.1668452-3-netdev@kapio-technology.com>
 <20230106163759.42jrkxuyjlg3l3s5@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <540e6577f028c05c8ea39c2a09bce23e@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-01-06 17:37, Vladimir Oltean wrote:
> On Fri, Jan 06, 2023 at 05:05:28PM +0100, Hans J. Schultz wrote:
>> As only the hardware access functions up til and including
>> mv88e6xxx_g1_atu_mac_read() called under the interrupt handler
>> need to take the chip lock, we release the chip lock after this call.
>> The follow up code that handles the violations can run without the
>> chip lock held.
>> In further patches, the violation handler function will even be
>> incompatible with having the chip lock held. This due to an AB/BA
>> ordering inversion with rtnl_lock().
>> 
>> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
>> ---
> 
> Needs to compile without new warnings patch by patch.
> 
> ../drivers/net/dsa/mv88e6xxx/global1_atu.c: In function
> ‘mv88e6xxx_g1_atu_prob_irq_thread_fn’:
> ../drivers/net/dsa/mv88e6xxx/global1_atu.c:460:1: warning: label ‘out’
> defined but not used [-Wunused-label]
>   460 | out:
>       | ^~~
> ../drivers/net/dsa/mv88e6xxx/global1_atu.c:460:1: warning: unused label 
> 'out'

Can I fix it and resend the same version?
