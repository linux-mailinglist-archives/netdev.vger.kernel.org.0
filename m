Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7F5585AEB
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 17:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbiG3PIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 11:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiG3PIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 11:08:18 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0BB18B1C;
        Sat, 30 Jul 2022 08:08:17 -0700 (PDT)
Received: from [44.168.19.21] (unknown [86.242.59.24])
        (Authenticated sender: f6bvp@free.fr)
        by smtp3-g21.free.fr (Postfix) with ESMTPSA id 14E4C13FA45;
        Sat, 30 Jul 2022 17:08:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1659193696;
        bh=R+cE9MuRqvbsRh1KnTNBRO2TxDgwG8rKKp3XBNCIrdY=;
        h=Date:To:Cc:From:Subject:From;
        b=EZN/OyiHwmHj9QKZHR++hFtDRcLwU6SSg00WYkK0Q3YG2gxFlgRdZtfhkWzS8e7HS
         jJNkRx58Xz5Z7KIzmyyYMkKne5AH1npAbG/tYonmumEg0Yh3u4al00XhxpLBTV8GnO
         giVqJ71wyvrF+/gvqV89YEjmzTxyS47a/+FD4JREh3bIU5upXfHeI9wWR0pTfrDLqM
         90AikcM1IIdnt+8Ggisa3ByPrT2PeYMW2zUrsYV6/uxgT9IqpNS0ng2rG8z5Xi55XU
         zJUHJ+lHvGHXXYV54nAg3r8jWcGqdvpvTaAn+ZZuOV02oFUm163k/NisStPaEjA73F
         tFfBbx+cbgr5Q==
Message-ID: <d5e93cc7-a91f-13d3-49a1-b50c11f0f811@free.fr>
Date:   Sat, 30 Jul 2022 17:08:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     linux-hams@vger.kernel.org,
        Thomas Osterried DL9SAU <thomas@x-berg.in-berlin.de>,
        netdev@vger.kernel.org
From:   Bernard f6bvp <f6bvp@free.fr>
Subject: rose timer t error displayed in /proc/net/rose
Organization: Dimension Parabole
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rose proc timer t error

Timer t is decremented one by one during normal operations.

When decreasing from 1 to 0 it displays a very large number until next 
clock tic as demonstrated below.

t1, t2 and t3 are correctly handled.

root@ubuntu-f6bvp:/home/bernard# cat /proc/net/rose
dest_addr  dest_call src_addr   src_call  dev   lci neigh st vs vr va   
t  t1  t2  t3  hb    idle Snd-Q Rcv-Q inode
2080175524 WP-0      2080175524 NODE-0    rose0 002 00001  2  0 0  0   6 
200 180 180   5   0/000     0     0 68541
*          *         2080175524 ROUTE-0   rose0 000 00000  0  0 0  0   0 
200 180 180   5   0/000     0     0 68448
*          *         2080175524 F6BVP-15  rose0 000 00000  0  0 0  0   0 
200 180 180   5   0/000     0     0 68447
*          *         2080175524 WP-0      rose0 000 00000  0  0 0  0   0 
200 180 180   5   0/000     0     0 68433
root@ubuntu-f6bvp:/home/bernard# cat /proc/net/rose
dest_addr  dest_call src_addr   src_call  dev   lci neigh st vs vr va   
t  t1  t2  t3  hb    idle Snd-Q Rcv-Q inode
2080175524 WP-0      2080175524 NODE-0    rose0 002 00001  2  0 0  0 
73786976294838206 200 180 180   5   0/000     0     0 68541
*          *         2080175524 ROUTE-0   rose0 000 00000  0  0 0  0   0 
200 180 180   5   0/000     0     0 68448
*          *         2080175524 F6BVP-15  rose0 000 00000  0  0 0  0   0 
200 180 180   5   0/000     0     0 68447
*          *         2080175524 WP-0      rose0 000 00000  0  0 0  0   0 
200 180 180   5   0/000     0     0 68433
root@ubuntu-f6bvp:/home/bernard# cat /proc/net/rose
dest_addr  dest_call src_addr   src_call  dev   lci neigh st vs vr va   
t  t1  t2  t3  hb    idle Snd-Q Rcv-Q inode
*          *         2080175524 ROUTE-0   rose0 000 00000  0  0 0  0   0 
200 180 180   5   0/000     0     0 68448
*          *         2080175524 F6BVP-15  rose0 000 00000  0  0 0  0   0 
200 180 180   5   0/000     0     0 68447
*          *         2080175524 WP-0      rose0 000 00000  0  0 0  0   0 
200 180 180   5   0/000     0     0 68433

Bernard

