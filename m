Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C926C58627F
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 04:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238696AbiHACUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 22:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbiHACUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 22:20:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1F912ABB;
        Sun, 31 Jul 2022 19:20:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 038D8CE0F0E;
        Mon,  1 Aug 2022 02:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6678CC433D6;
        Mon,  1 Aug 2022 02:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659320435;
        bh=8+H9rIFxtVXMLizyjzjdfAN5H4rrg+kZwIAaizE2yzQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qbHrryCgLDT40La7RvFNZvpswRq37MotxkwMrnSgvThg10C5P0Wuvbhb+kgAW2IV/
         7l9AinfPyV+s0mp74V/lgRfNNWtXpVcoBhJZq6nNU0+Y+uztq9mnx8qZUNJtGfOmBy
         z9E4MQQrlRBjePrgwRm5wkSRkYp1eh67rIz1eWdsjiCrWjEg7KPlp9UuuRYFvVdF4H
         AG5ozENZQdt/UaSewznbAtfMQ42eqJ8Aijum4zvDsoNX31z1VJqC3WWFB8VpixZRdN
         eZ7vzT+qAn+vAnbV2YEMFy6M4I4SzFXOjvGZzYicWbyrhI6mijE08eH8oBJNpMbil5
         HrwTfHKih8DWg==
Message-ID: <65fb5e26-2000-ffa5-5a3b-21db87da9e3b@kernel.org>
Date:   Sun, 31 Jul 2022 20:20:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [RFC] Remove DECNET support from kernel
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
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
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
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
References: <20220731190646.97039-1-stephen@networkplumber.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220731190646.97039-1-stephen@networkplumber.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/22 1:06 PM, Stephen Hemminger wrote:
> Decnet is an obsolete network protocol that receives more attention
> from kernel janitors than users. It belongs in computer protocol
> history museum not in Linux kernel.
> 
> It has been Orphaned in kernel since 2010.
> And the documentation link on Sourceforge says it is abandoned there.
> 
> Leave the UAPI alone to keep userspace programs compiling.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---

Acked-by: David Ahern <dsahern@kernel.org>


