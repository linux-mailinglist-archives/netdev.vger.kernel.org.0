Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC78646FDA
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLHMjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLHMjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:39:00 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286A51EC54
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:38:59 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id f7so1882944edc.6
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 04:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BzDsuTaY/cFaw3BQnFCif2uPLIS7pAopkFj2E7LPliw=;
        b=fNMIC2Lug67gNnuAa7mfk+i08Sy3VSO2Bc2UFqxWtLHP5Tsl44XO6RSRiPv0VWp99c
         EAkHx9CS5gFUHLj19dbndu42zv40xqCFks3lVdnKUMTK8+yFXwxDWoAqVCGMS6tbGFRH
         tuUHJpXGqC+nRqKZsEc8oQ/cKAVC1yGW9nFdbnsTGe+VEMAWuPlY4U8Q91mC5VzAf88+
         hgQCs3IQ4mSy3EF6bXE0B/uQPzU4A3JaCLDKcIlHPeSnEmet3VJt8TQhjWLYBes1SXR4
         MqLbiswclShy+HoXC8gaHl1QZObVK4hDKoK6zQX+xojF5moWE5eJYGqRYrE7B/PF9S+3
         arGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BzDsuTaY/cFaw3BQnFCif2uPLIS7pAopkFj2E7LPliw=;
        b=IO2yyM9QABBqfq1PQMJeP/1dlRWiVSOyuX1mdgZDQUOgFt+4OgBMmuiM2cPHRHvgBC
         HaKkdS+yPv0zhCl04kFeWQT8kYT+K0oWrRuMW80BP3/u+M4ISCDi3YzCLV65JbOQWhqY
         o13vK/mfgu3/0VCtQ0U+43U583ClrlNEOIij47mxGu4L2vBRQhBkUfO+NinvU1HayhtJ
         5hEsczDBO6j9AQNBaLoVdmxtbHO9B8nBfkzSO5Iw4C1y5thuep7C2s2zB9TWzBBeQL6t
         02Irdx4LZXhRHVT9Cpkkg4ltqw0VbNP5sxBavyd33Hdh2Vd92z4dqjY8x5d7UtuwcLvM
         8AsQ==
X-Gm-Message-State: ANoB5pnO3unoH3QEZYzryEVNF0Xrp0NAu81d0n2F8iwdFqt6XnbyrjUS
        90/em+0nDld1HycbeaMxINU/9g==
X-Google-Smtp-Source: AA0mqf7p1UKqFFIyL6h7gUpdu4yZfnF18hEyQpuEzdiD8FuiiOlThH/rD05sJ9TOEwX54c4pInmVZw==
X-Received: by 2002:aa7:c844:0:b0:461:9faf:6895 with SMTP id g4-20020aa7c844000000b004619faf6895mr1777233edt.16.1670503137719;
        Thu, 08 Dec 2022 04:38:57 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d17-20020aa7d691000000b0046bb7503d9asm3319343edr.24.2022.12.08.04.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 04:38:56 -0800 (PST)
Date:   Thu, 8 Dec 2022 13:38:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        William Tu <u9012063@gmail.com>, Andy Zhou <azhou@nicira.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Jianlin Shi <jishi@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [PATCH net] net/tunnel: wait until all sk_user_data reader
 finish before releasing the sock
Message-ID: <Y5Ha3zG/iJzKJVnH@nanopsycho>
References: <20221208120452.556997-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208120452.556997-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 01:04:52PM CET, liuhangbin@gmail.com wrote:
>There is a race condition in vxlan that when deleting a vxlan device
>during receiving packets, there is a possibility that the sock is
>released after getting vxlan_sock vs from sk_user_data. Then in
>later vxlan_ecn_decapsulate(), vxlan_get_sk_family() we will got
>NULL pointer dereference. e.g.
>
>   #0 [ffffa25ec6978a38] machine_kexec at ffffffff8c669757
>   #1 [ffffa25ec6978a90] __crash_kexec at ffffffff8c7c0a4d
>   #2 [ffffa25ec6978b58] crash_kexec at ffffffff8c7c1c48
>   #3 [ffffa25ec6978b60] oops_end at ffffffff8c627f2b
>   #4 [ffffa25ec6978b80] page_fault_oops at ffffffff8c678fcb
>   #5 [ffffa25ec6978bd8] exc_page_fault at ffffffff8d109542
>   #6 [ffffa25ec6978c00] asm_exc_page_fault at ffffffff8d200b62
>      [exception RIP: vxlan_ecn_decapsulate+0x3b]
>      RIP: ffffffffc1014e7b  RSP: ffffa25ec6978cb0  RFLAGS: 00010246
>      RAX: 0000000000000008  RBX: ffff8aa000888000  RCX: 0000000000000000
>      RDX: 000000000000000e  RSI: ffff8a9fc7ab803e  RDI: ffff8a9fd1168700
>      RBP: ffff8a9fc7ab803e   R8: 0000000000700000   R9: 00000000000010ae
>      R10: ffff8a9fcb748980  R11: 0000000000000000  R12: ffff8a9fd1168700
>      R13: ffff8aa000888000  R14: 00000000002a0000  R15: 00000000000010ae
>      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>   #7 [ffffa25ec6978ce8] vxlan_rcv at ffffffffc10189cd [vxlan]
>   #8 [ffffa25ec6978d90] udp_queue_rcv_one_skb at ffffffff8cfb6507
>   #9 [ffffa25ec6978dc0] udp_unicast_rcv_skb at ffffffff8cfb6e45
>  #10 [ffffa25ec6978dc8] __udp4_lib_rcv at ffffffff8cfb8807
>  #11 [ffffa25ec6978e20] ip_protocol_deliver_rcu at ffffffff8cf76951
>  #12 [ffffa25ec6978e48] ip_local_deliver at ffffffff8cf76bde
>  #13 [ffffa25ec6978ea0] __netif_receive_skb_one_core at ffffffff8cecde9b
>  #14 [ffffa25ec6978ec8] process_backlog at ffffffff8cece139
>  #15 [ffffa25ec6978f00] __napi_poll at ffffffff8ceced1a
>  #16 [ffffa25ec6978f28] net_rx_action at ffffffff8cecf1f3
>  #17 [ffffa25ec6978fa0] __softirqentry_text_start at ffffffff8d4000ca
>  #18 [ffffa25ec6978ff0] do_softirq at ffffffff8c6fbdc3
>
>Reproducer: https://github.com/Mellanox/ovs-tests/blob/master/test-ovs-vxlan-remove-tunnel-during-traffic.sh
>
>Fix this by waiting for all sk_user_data reader to finish before
>releasing the sock.
>
>Reported-by: Jianlin Shi <jishi@redhat.com>
>Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
>Fixes: 6a93cc905274 ("udp-tunnel: Add a few more UDP tunnel APIs")
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
