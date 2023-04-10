Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2846DCA77
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 20:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjDJSJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 14:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjDJSJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 14:09:26 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6006B198C;
        Mon, 10 Apr 2023 11:09:25 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-2465fe1a898so413768a91.2;
        Mon, 10 Apr 2023 11:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681150165; x=1683742165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0fXu7DYdVuCd14gLxRopl/Lt9Z7GNto7IFGejwkrdq0=;
        b=B+Me6XJodXH/F8t2+xmQ4g5q4NwxpD3jBH0wq+IHarUEnaG0mziX0jvzxjkAZe9iAS
         pyl0293gHLgPUIzX+/ZivGSxZM9uyZ6darbL0xu7AdpPts3UiyPGJEUOaEpdgz6rrtF+
         qlQrL4TqMRpus3rSqHFvDHWgYpI/C9ywtyHwXN/XvijMNdnMNqWUSnZNdsC63ptlnQbN
         9ThaT4Z6FADUV5YNG4mGck2Ojfczvs6nL44wrbFDdlWSJKMzqlFCteGh6aF+XjVNldyZ
         iu2du2ps3MKIgE//d5l3qo99Ro2CsQHHcaUpjfaauKgCkGRCw4nSeaPFhk3boQHGTmx+
         rdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681150165; x=1683742165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0fXu7DYdVuCd14gLxRopl/Lt9Z7GNto7IFGejwkrdq0=;
        b=bwMrlqw5ctCsDoJ+rWqW9Q/jOMObmDFQftoC5VM58KD9/EVJcpClywOcXwhWflph35
         dyOYSdB1HsFvArX46haDhWNa+t2SI3vBB/cvCzeJGswN4/NifMz7fOsaFXPs/ibXVdvK
         J4Jd03xt9ZCJ0pvl6Vvfkqy8BBCoXciDwkEDaKAhW1CO0Ot/SMtc+ZkYiEwQ0A7YLowL
         Xpb6GmQtvJIQwOeLUIwguKsQfgwnTzUDlhdW6JxeGSzv1oIE0uRXC64PIXCOreSkyN+o
         4KeST/Yw6irwhAygtcDagjUumNIinR9wtypgqoLGBR0m2gCyL85hBqCV0nkWmiqjIIHK
         Fy2A==
X-Gm-Message-State: AAQBX9cWrPMjHzBtDCNk3ZsqvTXrxw0YchYXWl/jyv8SgaVb38XHFaIP
        SjkArBwy0nfznqo96+EeraVyHAxWxtM=
X-Google-Smtp-Source: AKy350Y+06dUcvpO3pOPLHpKFIuB68N8vOVy/RuFufG/YJ8AA3vKs6iChbdg9Wml+pDHimbD6lwGaQ==
X-Received: by 2002:aa7:9a41:0:b0:63a:38d2:d41f with SMTP id x1-20020aa79a41000000b0063a38d2d41fmr1884203pfj.29.1681150164744;
        Mon, 10 Apr 2023 11:09:24 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id u25-20020aa78399000000b0062d7e9bb17asm8111025pfm.81.2023.04.10.11.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 11:09:24 -0700 (PDT)
Date:   Mon, 10 Apr 2023 11:09:22 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH 0/8] sched/topology: add for_each_numa_cpu() macro
Message-ID: <ZDRQ0oyyWYIwGhUP@yury-laptop>
References: <20230325185514.425745-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325185514.425745-1-yury.norov@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 11:55:06AM -0700, Yury Norov wrote:
> for_each_cpu() is widely used in kernel, and it's beneficial to create
> a NUMA-aware version of the macro.
> 
> Recently added for_each_numa_hop_mask() works, but switching existing
> codebase to it is not an easy process.
> 
> This series adds for_each_numa_cpu(), which is designed to be similar to
> the for_each_cpu(). It allows to convert existing code to NUMA-aware as
> simple as adding a hop iterator variable and passing it inside new macro.
> for_each_numa_cpu() takes care of the rest.
> 
> At the moment, we have 2 users of NUMA-aware enumerators. One is
> Melanox's in-tree driver, and another is Intel's in-review driver:
> 
> https://lore.kernel.org/lkml/20230216145455.661709-1-pawel.chmielewski@intel.com/

Are there any more comments to the series? If not, I'll address those
shared by Andy and send v2.

Thanks,
Yury
