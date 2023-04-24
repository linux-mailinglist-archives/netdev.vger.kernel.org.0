Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AD06ED3E0
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjDXRtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDXRtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:49:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEBC6E8C
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:49:38 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b5fca48bcso4086800b3a.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1682358578; x=1684950578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=edIyrpOkZxkR7qQPvMEjMBtYXDIPtOhEQ7kSltA2Y7E=;
        b=B0RGu9bSAOqeQFKM2kCfJoKnl08Vl+oe+fwmnFVAivzg30GMkKXPEJIoCB0NsHbaMh
         y1QOEsnnYJO/COyfiUTW2dtgpEZrqz2vLI1HRdIkW9hABd7zQuI3eeVtbR5A2iA6mCaV
         5QBQkDfq+xdn7BOEA9dEj6QIjjHMU11j/zgdaVZsVhi8C2oRl6bFxT6thxHV49P2U8UL
         zYC+DjT2f/NHcPLoSAHdcnqWWaY/yPWwMTsi+NOz2XxNjs9qrmO2DZcxaSVTMPKUaaw8
         WFfpAud6lL6IcXM5+aRHmp/yuX4VH+U0aJ4N7MhsIExmp9g+j5ts12kN96no48OTOYsl
         BwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682358578; x=1684950578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edIyrpOkZxkR7qQPvMEjMBtYXDIPtOhEQ7kSltA2Y7E=;
        b=XU+2S0234WAkcMIckz4RgH9weqcT62zQ/Vq14x03tDoxVpB7cfsVjsqQQy2jIS95zS
         7vECMZ9fqNhkTeeBIPZNuMZ4RqqN0fiw+PRNbUYeyXaciagSFLmzwU715AzFZC1T/XrX
         VkadNUDbcqL9B+9sB44lW+h0OANpCEYLfgtOWkNNTkHi/IUGK+kxsC7B0znHW5zSH7Ac
         lYtg/eXu1eQxBgRTa1awHOgQDFhtSky+NGmxcvAhaLdDxIj+RGR0OyZ95OEwhIt4Djsb
         +IGK5BMfiSZRQNUscsInkSdA1WTzUSfhXDXRfTABPD5LukOp1+gifNhL+UBm3cQjOLfI
         0Hcw==
X-Gm-Message-State: AAQBX9dnXv3ln1HQiwQczIugP2kqbRKJ5opR6uGdcGb7hsQEDMZSpIM9
        czDQhPNfvSiiqYEXCH3Zt8eEsg==
X-Google-Smtp-Source: AKy350a+fQ5RH2pzme3FmdqfnV6Q9HMfXN8/2YLOzRVV6aO9E2YFNfCF27d33yNs3+ss0MWXL38FXg==
X-Received: by 2002:a05:6a20:269f:b0:f0:7b8:c77b with SMTP id h31-20020a056a20269f00b000f007b8c77bmr14185926pze.59.1682358578033;
        Mon, 24 Apr 2023 10:49:38 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id b6-20020a63d806000000b005143d3fa0e0sm6814788pgh.2.2023.04.24.10.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 10:49:37 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pr0Jj-001Vpp-HL;
        Mon, 24 Apr 2023 14:49:35 -0300
Date:   Mon, 24 Apr 2023 14:49:35 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Message-ID: <ZEbBLzy4SU8IZR68@ziepe.ca>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
 <20230423222941.GR447837@dread.disaster.area>
 <14c6f0f3-0747-4800-8718-4f109f7321ea@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14c6f0f3-0747-4800-8718-4f109f7321ea@lucifer.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 11:56:48PM +0100, Lorenzo Stoakes wrote:

> This warned upon check should in reality not occur, because it implies the
> GUP user is trying to do something broken and is _not_ explicitly telling
> GUP that it knows it's doing it and can live with the consequences. And on
> that basis, is worthy of a warning so we know we have to go put this flag
> in that place (and know it is a source of problematic GUP usage), or fix
> the caller.

It is fine for debugging, but we can't merge user triggerable
WARN_ONs..

Since the GUP caller has no idea if userspace might be maliciously
passing in a file VMA we can't throw warnings.

Jason
