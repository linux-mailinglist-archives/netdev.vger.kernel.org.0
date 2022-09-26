Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891A75EAF0C
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiIZSE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiIZSEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:04:40 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE925F7CD;
        Mon, 26 Sep 2022 10:47:44 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id c6so4753449qvn.6;
        Mon, 26 Sep 2022 10:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=G3bHFZGpy4Poxm+wH6LN2ddhGFQ+Urh+BT5iemrEejo=;
        b=b5vcMt8+7sNF3eUeXl8HvedwsMz2yb8O5/UexwHWxxXwkwhPbE+jUs2FPTFFoGcHBv
         vMRaiWKcLTo8qz4KJ7qQ/a2fOvRA7dxvrSupWTP53jHZ66fxR3B39GkBvMJZUNkn+Tue
         EC/CHq+6ak6+2Oanv+hqq37yVamNdInxWDNe5LseWcCEm/0oHJvAtVVIIKGTDbHy03Y+
         M82Jt3atFG6GVPL1p2CwnK0XyH5kNPsOcB+4A5+2PmvnZMt/HhnXibtsPOwitD+ksyxc
         T2KTA8ofcznk7fY7FQpZ8XZ6vfqBiaFYXo+S0Cjgd2IT1Tfw5O9qVjJg/FEJtGYt3S0B
         jYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=G3bHFZGpy4Poxm+wH6LN2ddhGFQ+Urh+BT5iemrEejo=;
        b=0PDPtk3VMZ58hI0ZkdaYCEMxQHLRrhkAaeq+E4Ecsj0r9sOnbHuTPiPwQKdx6vbtsx
         aisyOTQnJ7F8TCFhDn+7FCAhrJDRsVTqjceDe+SIaLydb1LkV0Qdi9cCYbBz5dx1rckl
         KC0CbXcf7ANsHbQ/loikX+Hm9yW5a/os13hndNIhDCb+t4v6zPtiV8AdRZbc2GZg41pB
         h4h6t8LAOEAjBE2ysL8fLGV6eiaNPx0zrqtHty1prlZCf28cWUO21rCr4oEiYQMHNsRD
         qUXp4kvU4PfBcUMTFdelkTVIEDwjTjskfviutYLnhKVgu9aU3+Ex5Noc3R89nG+UoG+f
         AfSA==
X-Gm-Message-State: ACrzQf0oXqZYgx/5P8qS4Mp2frFfT3UovJ1b23QpOZ/Ou+equIt5SWlp
        c7lVP9oKh0hdLBei2LjzzVo=
X-Google-Smtp-Source: AMsMyM6mrZblzdPv19H0KjO0t+ilx/R020iClAFxH9x/Nbpu7j9NAUt2UdKMpBljW14pzyx77zAKYg==
X-Received: by 2002:a05:6214:1d21:b0:4ad:1361:befa with SMTP id f1-20020a0562141d2100b004ad1361befamr17637837qvd.111.1664214463927;
        Mon, 26 Sep 2022 10:47:43 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:155c:f237:bceb:6273])
        by smtp.gmail.com with ESMTPSA id x16-20020ac87ed0000000b003422c7ccbc5sm11121875qtj.59.2022.09.26.10.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 10:47:43 -0700 (PDT)
Date:   Mon, 26 Sep 2022 10:47:42 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 2/7] net: fix cpu_max_bits_warn() usage in
 netif_attrmask_next{,_and}
Message-ID: <YzHlvsDcuji9CxpU@yury-laptop>
References: <20220919210559.1509179-1-yury.norov@gmail.com>
 <20220919210559.1509179-3-yury.norov@gmail.com>
 <20220926103437.322f3c6c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926103437.322f3c6c@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 10:34:37AM -0700, Jakub Kicinski wrote:
> On Mon, 19 Sep 2022 14:05:54 -0700 Yury Norov wrote:
> > The functions require to be passed with a cpu index prior to one that is
> > the first to start search, so the valid input range is [-1, nr_cpu_ids-1).
> > However, the code checks against [-1, nr_cpu_ids).
> 
> Yup, the analysis looks correct:
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks. If no other comments from you and others, I'll take the series in
bitmap-for-next.
