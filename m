Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174C55860B4
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237746AbiGaTP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiGaTP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:15:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B64644D;
        Sun, 31 Jul 2022 12:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B7BCB80D11;
        Sun, 31 Jul 2022 19:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33937C433D7;
        Sun, 31 Jul 2022 19:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659294954;
        bh=wZPiOmb/8y3eGL/2h6/nS4c4cbBrC5BVAnNHwWdf0GU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T9jGZEBnUXLfaa8X7PKLziwJ0/gtSigoQGvVgA14bEv3XngpVWIXW8iksAjIMqSav
         4WfoTj7ox8y9lP3t1dusu++r8cFwf/tf8PrbfwSPUAA07RjC+/uTe5h7uINWx6eP9m
         czT313x97GQnnWiUz9oSONS3V1P5iqus9MVAr+VbYyB6+YJ27X56fsTF2Kx1mSfdh5
         11eHqxXr4IDxrxksfrnc0A2YCNqabIB3vbZRK0GejO1qfVDJE7ezzxLQirWm2d6o1G
         EKnfF0rHw4RHjqtNTXRHDkEgKAx4AwjERSjAybhUArQGdxXnWUBriayLi9pLhmdpOO
         xx2EZNtgZDN7Q==
Received: by pali.im (Postfix)
        id 388B36E8; Sun, 31 Jul 2022 21:15:51 +0200 (CEST)
Date:   Sun, 31 Jul 2022 21:15:51 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Xin Long <lucien.xin@gmail.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Juergen Gross <jgross@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Xie Yongji <xieyongji@bytedance.com>,
        Chen Yu <yu.c.chen@intel.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Suma Hegde <suma.hegde@amd.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Scott Wood <oss@buserror.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Wang Qing <wangqing@vivo.com>, Yu Zhe <yuzhe@nfschina.com>,
        Benjamin Poirier <bpoirier@nvidia.com>,
        Victor Erminpour <victor.erminpour@oracle.com>,
        "GONG, Ruiqi" <gongruiqi1@huawei.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [RFC] Remove DECNET support from kernel
Message-ID: <20220731191551.5m7ql3ysozi3owrl@pali>
References: <20220731190646.97039-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220731190646.97039-1-stephen@networkplumber.org>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday 31 July 2022 12:06:10 Stephen Hemminger wrote:
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> index 805f2281e000..299d9c3407d3 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -39,7 +39,6 @@ Table : Subdirectories in /proc/sys/net
>   802       E802 protocol         ax25       AX25
>   ethernet  Ethernet protocol     rose       X.25 PLP layer
>   ipv4      IP version 4          x25        X.25 protocol
> - bridge    Bridging              decnet     DEC net
>   ipv6      IP version 6          tipc       TIPC
>   ========= =================== = ========== ==================
>  

Hello! You should remove only decnet from the list, not bridge.
This is two columns table.
