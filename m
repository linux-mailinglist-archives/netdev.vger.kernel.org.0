Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398215B2565
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 20:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiIHSNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 14:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIHSNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 14:13:11 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6BCCCE30
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 11:13:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t3so13630532ply.2
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 11:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=58YU/Um2Y+pIFav1jVCf02BC0IMsYkCsaqeH0L7ttmk=;
        b=nMYeQOh5B7GtIro5V6BodWH8tTWIw3fjVL97IhpzTJVmgth9cStV78u4gyWwsTkqvl
         S0p1Y009rotTkI8wqHQ5k6GSme29vDZrdU5QTdDKWJiind6hqeHHeCjKvP8bfoY2mo+D
         tUJZhNTA0kP4L6AidHcQ1uFBrwpYi/IgNYVPBHAZ1U70R3u9KD2sKXEms/pQbW8qCy8b
         okeQbu1T0vHOKYj6/ap4XkT+SQqniI55iRztL6PpUijOnjvoYihydPagg04UBQqeLAH5
         YOyeY1JGcndPeQ5hKvV2ur3GP61iUjMSW5tMwOiOoK+sbzZzwjcfy0AYo9ss6fzhfxvP
         kMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=58YU/Um2Y+pIFav1jVCf02BC0IMsYkCsaqeH0L7ttmk=;
        b=oEOV0qI1nh957P67cZsewOC/0wiwjkDdXrD3adf2+5AqSQOJnRwVDlqbjT6qhMoKdi
         wnfj1fDjIGA+05jnHPsykX8ziSKoV1QiMJIAGULfkqp9OyyogkkII7m8vL/Jy6mu6mWH
         lf0+jWBhivBahMfMPexVQX6xLcHRJW5OkztuOLIQfE+MVa4YMIgEZkqe5JOu4Wr9xRwS
         FCOMoX6H6SWQYstlf5qOwithCmN8qSoqbL38Ih3WuUMSdIqGR80UngfwSgZgn08tx4bF
         VaoIajjBvwoR/CWGH3rN2QbDjOiMDG6bxETyzcQX+slbRuwfEsxB4VyreFQx7hqJxYKT
         St0A==
X-Gm-Message-State: ACgBeo1vYWAR7hSPLX5Bxv1uZ72tAsoSodrr5p+EvJBeHZU9PB0hg6Op
        eH7poh7VLfj0UszUq49bdjU=
X-Google-Smtp-Source: AA6agR47hV/itFlyHfuQc0whMwGXu3sGH5dkL9YhGuZLrQgMSi5XlsxKLCNZKHM+j7/PoHYrGC+GsA==
X-Received: by 2002:a17:902:82c8:b0:177:e4c7:e8a6 with SMTP id u8-20020a17090282c800b00177e4c7e8a6mr7598844plz.130.1662660789025;
        Thu, 08 Sep 2022 11:13:09 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:23b:bb9:e15e:6876? ([2620:15c:2c1:200:23b:bb9:e15e:6876])
        by smtp.gmail.com with ESMTPSA id z27-20020aa7991b000000b005385e2e86eesm14757143pff.18.2022.09.08.11.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 11:13:08 -0700 (PDT)
Message-ID: <248395fc-7dd7-3c7d-affc-ced4145c5285@gmail.com>
Date:   Thu, 8 Sep 2022 11:13:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v6 net-next 0/6] tcp: Introduce optional per-netns ehash.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220908011022.45342-1-kuniyu@amazon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220908011022.45342-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/7/22 18:10, Kuniyuki Iwashima wrote:
> The more sockets we have in the hash table, the longer we spend looking
> up the socket.  While running a number of small workloads on the same
> host, they penalise each other and cause performance degradation.
>
> The root cause might be a single workload that consumes much more
> resources than the others.  It often happens on a cloud service where
> different workloads share the same computing resource.
>
> On EC2 c5.24xlarge instance (196 GiB memory and 524288 (1Mi / 2) ehash
> entries), after running iperf3 in different netns, creating 24Mi sockets
> without data transfer in the root netns causes about 10% performance
> regression for the iperf3's connection.
>
>   thash_entries		sockets		length		Gbps
> 	524288		      1		     1		50.7
> 			   24Mi		    48		45.1
>
> It is basically related to the length of the list of each hash bucket.
> For testing purposes to see how performance drops along the length,
> I set 131072 (1Mi / 8) to thash_entries, and here's the result.
>
>   thash_entries		sockets		length		Gbps
>          131072		      1		     1		50.7
> 			    1Mi		     8		49.9
> 			    2Mi		    16		48.9
> 			    4Mi		    32		47.3
> 			    8Mi		    64		44.6
> 			   16Mi		   128		40.6
> 			   24Mi		   192		36.3
> 			   32Mi		   256		32.5
> 			   40Mi		   320		27.0
> 			   48Mi		   384		25.0
>
> To resolve the socket lookup degradation, we introduce an optional
> per-netns hash table for TCP, but it's just ehash, and we still share
> the global bhash, bhash2 and lhash2.
>
> With a smaller ehash, we can look up non-listener sockets faster and
> isolate such noisy neighbours.  Also, we can reduce lock contention.
>
> For details, please see the last patch.
>
>    patch 1 - 4: prep for per-netns ehash
>    patch     5: small optimisation for netns dismantle without TIME_WAIT sockets
>    patch     6: add per-netns ehash
>
> Many thanks to Eric Dumazet for reviewing and advising.
>
>
> Changes:
>    v6:
>      * Patch 6
>        * Use vmalloc_huge() in inet_pernet_hashinfo_alloc() and
>          update the changelog and doc about NUMA (Eric Dumazet)
>        * Use kmemdup() in inet_pernet_hashinfo_alloc() (Eric Dumazet)
>        * Use vfree() in inet_pernet_hashinfo_(alloc|free)()
>
>    v5: https://lore.kernel.org/netdev/20220907005534.72876-1-kuniyu@amazon.com/
>      * Patch 2
>        * Keep the tw_refcount base value at 1 (Eric Dumazet)
>        * Add WARN_ON_ONCE() for tw_refcount (Eric Dumazet)
>      * Patch 5
>        * Test tw_refcount against 1 in tcp_twsk_purge()
>
>    v4: https://lore.kernel.org/netdev/20220906162423.44410-1-kuniyu@amazon.com/
>      * Add Patch 2
>      * Patch 1
>        * Add cleanups in tcp_time_wait() and  tcp_v[46]_connect()
>      * Patch 3
>        * /tcp_death_row/s/->/./
>      * Patch 4
>        * Add mellanox and netronome driver changes back (Paolo Abeni, Jakub Kicinski)
>        * /tcp_death_row/s/->/./
>      * Patch 5
>        * Simplify tcp_twsk_purge()
>      * Patch 6
>        * Move inet_pernet_hashinfo_free() into tcp_sk_exit_batch()
>
>    v3: https://lore.kernel.org/netdev/20220830191518.77083-1-kuniyu@amazon.com/
>      * Patch 3
>        * Drop mellanox and netronome driver changes (Eric Dumazet)
>      * Patch 4
>        * Add test results in the changelog
>      * Patch 5
>        * Use roundup_pow_of_two() in tcp_set_hashinfo() (Eric Dumazet)
>        * Remove proc_tcp_child_ehash_entries() and use proc_douintvec_minmax()
>
>    v2: https://lore.kernel.org/netdev/20220829161920.99409-1-kuniyu@amazon.com/
>      * Drop flock() and UDP stuff
>      * Patch 2
>        * Rename inet_get_hashinfo() to tcp_or_dccp_get_hashinfo() (Eric Dumazet)
>      * Patch 4
>        * Remove unnecessary inet_twsk_purge() calls for unshare()
>        * Factorise inet_twsk_purge() calls (Eric Dumazet)
>      * Patch 5
>        * Change max buckets size as 16Mi
>        * Use unsigned int for ehash size (Eric Dumazet)
>        * Use GFP_KERNEL_ACCOUNT for the per-netns ehash allocation (Eric Dumazet)
>        * Use current->nsproxy->net_ns for parent netns (Eric Dumazet)
>
>    v1: https://lore.kernel.org/netdev/20220826000445.46552-1-kuniyu@amazon.com/
>

SGTM, thanks.

For the whole series:

Reviewed-by: Eric Dumazet <edumazet@google.com>


