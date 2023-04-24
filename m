Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD3E6ED8C8
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 01:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbjDXX1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 19:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjDXX1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 19:27:17 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CC8AF19;
        Mon, 24 Apr 2023 16:26:38 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f1950f569eso24424755e9.2;
        Mon, 24 Apr 2023 16:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682378787; x=1684970787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dxcDkLWArFVGxXFjJV1x9Mo2OcABMU93AnXLMQRENu4=;
        b=c2TG5nuleMll1lOBF+XEICpEXvEsyXZQd4wVbiThL4heUkDk9VL44B5Rc1yrKyCnWB
         Cci1nvmPgz8YXTeygn2yS5Ocu0QGagMQAystMMjPtt4Tj3L+K/FjytNKbAWpaK9lzZKs
         8olcJsWqRyr92H7z8CBxcwdDaGTGNJv/MVVSGKdTDaSl0nZqacgLm6RUvLXXN8duB3A/
         dWcsBVGAPO3OHq4dksLEzBiRPmrtdC9Cx92HaDamEnGIcawGcBY4pyjzIADaOKRzYmNU
         Ay0T4FT8uiDo9il2R/9uafQ4R6XwKWbRhcRjMyBGruUYd6XT1PrnxdierIHLUGalpyGA
         QO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682378787; x=1684970787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dxcDkLWArFVGxXFjJV1x9Mo2OcABMU93AnXLMQRENu4=;
        b=bk+dGvA+EptHmrX1gwnGyPbrg94BczownDpZEpQPNfNiQZdelHHA4dKDjyNQBhP0Pl
         p4R6/119N/4u0bauwRX4zNnWV6TxysorfP1R4rJAUiMVhn7nC6wXnJEuoE36M7MbMLqH
         HsF8+1dMpgNjIMjX82/+zVIxumzQPOusdKnHlbQprb4LM3/Ml1MObU4mSdqpZ9UDYgv7
         Dr1yVg1eF4we47E6NI1wdxVZLT2l/QV26N3l+EKylzRhOeottL4fiEO/OMuMhYphPmjZ
         dmQ6Q3FiDTDWCf0EmbfwknWfdigFVZfJ0WWjVdJg9E6HReWCtjNmgY9PXySoWoCgX7/9
         EhKw==
X-Gm-Message-State: AAQBX9cTbtTQ5JxlQyQ3oyNoGCDm4vyt6vIECH7mErVlEHTO3zWFt4xG
        vWY/aw8l6i9USvhqXwWv61Q=
X-Google-Smtp-Source: AKy350YmwGfgqMWEg5TF8ScWD6s70vEkQPfSE8eO5Ql2sSUhDXrK+9lnC0X0xiqHMd3x63H/ACYBZg==
X-Received: by 2002:a05:600c:3657:b0:3f0:4734:bef8 with SMTP id y23-20020a05600c365700b003f04734bef8mr8467694wmq.39.1682378787397;
        Mon, 24 Apr 2023 16:26:27 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id p13-20020a7bcc8d000000b003ee63fe5203sm13343552wma.36.2023.04.24.16.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 16:26:26 -0700 (PDT)
Date:   Tue, 25 Apr 2023 00:26:25 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
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
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ff1bb8cd-896f-4c7f-a182-42112f5ac5af@lucifer.local>
References: <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
 <ZEaGjad50lqRNTWD@nvidia.com>
 <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
 <ZEa+L5ivNDhCmgj4@nvidia.com>
 <cfb5afaa-8636-4c7d-a1a2-2e0a85f9f3d3@lucifer.local>
 <ZEbQeImOiaXrydBE@nvidia.com>
 <f00058b8-0397-465f-9db5-ddd30a5efe8e@lucifer.local>
 <ZEcIZspUwWUzH15L@nvidia.com>
 <4f16b1fc-6bc5-4e41-8e94-151c336fcf69@lucifer.local>
 <ZEcN92iJoe+3ANVc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEcN92iJoe+3ANVc@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 08:17:11PM -0300, Jason Gunthorpe wrote:
> On Tue, Apr 25, 2023 at 12:03:34AM +0100, Lorenzo Stoakes wrote:
>
> > Except you dirty a page that is mapped elsewhere that thought everything
> > was cleaned and... not sure the PTLs really help you much?
>
> If we have a writable PTE then while the PTE's PTL is held it is impossible
> for a FS to make the page clean as any cleaning action has to also
> take the PTL to make the PTE non-present or non-writable.
>

That's a very good point! Passing things back with a spinlock held feels
pretty icky though, and obviously a no-go for a FOLL_PIN. Perhaps for a
FOLL_GET this would be workable.

> > If we want to be more adventerous the opt-in variant could default to on
> > for FOLL_LONGTERM too, but that discussion can be had over on that patch
> > series.
>
> I think you should at least do this too to explain why io_uring code
> is moving into common code..
>

OK, I'll respin this as a v3 of this series then since we'll be defaulting
FOLL_LONGTERM at least (for which there seems to be broad consensus), but
also permit this flag to be set manually and set it for io_uring.

> Jason
