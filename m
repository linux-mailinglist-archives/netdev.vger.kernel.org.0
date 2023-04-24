Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3C76ECA09
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 12:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjDXKSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 06:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjDXKSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 06:18:00 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE03B7;
        Mon, 24 Apr 2023 03:17:58 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2f3fe12de15so2499252f8f.3;
        Mon, 24 Apr 2023 03:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682331477; x=1684923477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sFd3GouLvmJwZXxGkUryj0wCtEPdyUrIZGRi3VcHFcY=;
        b=TqsT5bDLQhdBasdYkLmm+ue2xSgsEVBAjc5YTj++1vp6A3jb/eAm2ISqbClYNA/bN3
         Bm0Qobi1sk/79zsr5IujFFPFlbsGzbAi1EJzMSmku+dNUifDgkAbCbcM8YUtWcBVvZOy
         SVPpWE5OWQfTe1GQr8ZTxOp6tt3VCUbd2OuOAC/DfDigTp0Uj1Rx+xCoGvzmour5y5R+
         4Hu3Tw5p+fFJfRaY5cfLbeLqTcGzpFGk6nHgmtiTQqRoAbl4T73JR4lVcu+fut660/g4
         rcTw4Qo24E64xvf+zM2d8K0I3IEMc/kusIdXVd5+7w3YBNQEVSY8dQymZOSt9O+uppQ5
         sLHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682331477; x=1684923477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sFd3GouLvmJwZXxGkUryj0wCtEPdyUrIZGRi3VcHFcY=;
        b=KZaSb58DixHsITFjpPEvqU4J0LBuP7xZMkG3CbbRBKM0SJKRExNXRphnSRCcX1abvc
         41oYyyUWrBATXhImhA6s725xOeMTBQlTJqrHy6nE3h+ZUfHjXpjP95s8DjytFolKE3qC
         cBpD2xdt1vWvaRneEAQTlwJ7yFfjotElTX3VgwWWy5I/cUugozQ1L2xGcbV3ckWsNDqS
         MRvUNRPQa9bN8FlvDO6GZ/9LUiP0WbX4WagwjWudFQEsLSBAhFrc6R3EnX6rVuOmY1kS
         uIi5UUs1ZZoTF7lO9b4hyITfkXMP0CUW9u0MoRk5zmM2MYpvyBL0xnasHSrtw14PH9XJ
         CDAg==
X-Gm-Message-State: AAQBX9dwqPpNnEJRgCJWwK2GhFORrF+JPh2WF/K5ZhpYolM0LPRLdwyj
        m1zyH32GKWYI4NAFTokEiuiOpsiAuHGGVw==
X-Google-Smtp-Source: AKy350as+uWvZB1UDA0rClSPEJZ9KJctRGU6UJ7yZVRqXBfMpnr1bm8yMh1ziKuQa5ocG0CjKQw7XQ==
X-Received: by 2002:adf:ec46:0:b0:2ce:9fb8:b560 with SMTP id w6-20020adfec46000000b002ce9fb8b560mr9761836wrn.8.1682331476919;
        Mon, 24 Apr 2023 03:17:56 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id a14-20020adfe5ce000000b002fbe0772ab1sm10448840wrn.16.2023.04.24.03.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 03:17:55 -0700 (PDT)
Date:   Mon, 24 Apr 2023 11:17:55 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEZPXHN4OXIYhP+V@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 02:43:56AM -0700, Christoph Hellwig wrote:
> I'm pretty sure DIRECT I/O reads that write into file backed mappings
> are out there in the wild.
>
> So while I wish we had never allowed this, the exercise seems futile and
> instead we need to work on supporting this usecase, with the FOLL_PIN
> infrastructure being a big step toward that.

It's not entirely futile, there's at least one specific use case, which is
io_uring which is currently open coding an equivalent check themselves. By
introducing this change we prevent them from having to do so and provide a
means by which other callers who implicitly need this do not have to do so
either.

In addition, this change frees up a blocked patch series intending to clean
up GUP which should help open the door to further improvements across the
system.

So I would argue certainly not futile.

In addition, I think it's useful to explicitly document that this is a
broken case and, through use of the flag, highlight places which are
problematic (although perhaps not exhaustively).

I know Jason is keen on fixing this at a fundamental level and this flag is
ultimately his suggestion, so it certainly doesn't stand in the way of this
work moving forward.
