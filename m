Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3496E4621
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjDQLNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjDQLNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:13:48 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F137EE5;
        Mon, 17 Apr 2023 04:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O/vAkZS7K/p9ehT9Ze/yUe6QqQOHYcbouGF16oaHqAg=; b=RaguJ35Cua8KKg6KKYNXsSwSM3
        3GqKhLr4jqNshAbzCE0f9KWatbgghhosB8cEtcGpFdyJ2naGblgdpxBapNH6KodLZ6zlu85Qjwp7O
        8xZ+JZstxRh6Mk6GhlyokYLNOJsvC7v+18dLROjxfFi2AC0/qrPa2zgZm8VidE/VOzQAwJXzQzxPL
        noX54O0gtjafHYagRXcpxJWiB5KujkzTeEACojdOHVkt3TtKr+qqEiZrTRiX3hS4M4mX1Zqyxt+2/
        wz4WHhhhVGyYpsZK/X7nHRSKxJNAMMfiL6zXhbkrnLwnMzZ0Ro3VEoR04gudAhlvQQctFORfQJW40
        8WNk9jsQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1poMln-00HIbx-0z;
        Mon, 17 Apr 2023 11:11:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A8CA53002A3;
        Mon, 17 Apr 2023 13:11:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 871C024248706; Mon, 17 Apr 2023 13:11:37 +0200 (CEST)
Date:   Mon, 17 Apr 2023 13:11:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v2 0/8] sched/topology: add for_each_numa_cpu() macro
Message-ID: <20230417111137.GI83892@hirez.programming.kicks-ass.net>
References: <20230415050617.324288-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415050617.324288-1-yury.norov@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Something went wrong with sending your patches; I only have 0/n.
