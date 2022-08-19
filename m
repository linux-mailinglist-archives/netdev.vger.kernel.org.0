Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADF5599778
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346724AbiHSI1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346749AbiHSI1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:27:32 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F90E1A8B
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:27:30 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c39so4810983edf.0
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=gneh9P8SPlkzkLwRB/RmsA9iXnVHaiFlM5W1LuTdJDE=;
        b=tINS8JEZVVHDXXIvMjqE2MilyQMbxjaAYQGMx8b3gVxoqxb51t1ky5JbzSzMxqgFaG
         nc88TkSsXKlFyNFyRJdqbVBSgxi6wkiQ1XfduZR7aJF9gsFA2ARdT2hSA/e5vBdmhb3j
         +QxPOWd2mUG2+R2DfDqZqNtBHJLxOJzpsQRaIRkmYZrolO3Gqj3RHUmSStogTJpkUtPt
         bEXSCG799KBITLNvLETV/SaJqEwLvNIG0ufMqGugZgcfMt5zT6S0V9i0Tu/MeHMPRgbj
         zQdOoC9wmymXgTyZlOmZs2qDhVPhUtVwYbEadXtQoHrigqJCRfk3mh62in/CfmsXqz11
         /Z5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=gneh9P8SPlkzkLwRB/RmsA9iXnVHaiFlM5W1LuTdJDE=;
        b=678ME0865zCqfZe5Pj/mIERFQ+0CAYUE5udj9TL/btCvobQxQdXCFdYpjcVCjJgSH6
         uDrPmfEmJ9tE4cXOWRyis7Wp507QrZN0whWSis+hzPTu88Y8K7JK+ZAr0VtE6gu3GP8e
         fCBm14D0LyTFvL5DZ9TUprJfibXyX9Nj1aDfuPd2Lr05Ruw9v+TvdLHetrlwDDuEQyQh
         Ar6f/V1sIeYjVSK9MIgWzqSHOZNivnIIqcVETAPgFdDNga9Sqb3/bQpysh7usQx2Jchj
         fJFxhs8K+d9boOcISHN+3Y9nTqTLQoFozR2BNv20kHGgSBdvz1Ee1dqZAjwcY5T+lhMa
         3Ccg==
X-Gm-Message-State: ACgBeo032oelUemRoxzrZ1PSKXT4lT0szKPDCROcISGCaSQPMAuIWrE3
        mo8SX9gZooshTxHLf+pPHh0Cfw==
X-Google-Smtp-Source: AA6agR7c4ju9LoubTNZtjLgiPat2ZKA3ZYn4C+OK+xuOaYxEVweEwUtGeofgB68C+UlDLQUBJWhpJw==
X-Received: by 2002:a05:6402:13c6:b0:446:1c68:915b with SMTP id a6-20020a05640213c600b004461c68915bmr4253097edx.208.1660897649316;
        Fri, 19 Aug 2022 01:27:29 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id r10-20020a17090609ca00b007317ad372c0sm1976753eje.20.2022.08.19.01.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 01:27:28 -0700 (PDT)
Date:   Fri, 19 Aug 2022 10:27:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [iproute2-next 0/2] devlink: remove dl_argv_parse_put
Message-ID: <Yv9JcA/Fil0y1c6p@nanopsycho>
References: <20220818211521.169569-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818211521.169569-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 18, 2022 at 11:15:19PM CEST, jacob.e.keller@intel.com wrote:
>This series removes the dl_argv_parse_put function which both parses the
>command line arguments and places them into the netlink header.
>
>This was originally sent as an RFC at
>https://lore.kernel.org/netdev/20220805234155.2878160-1-jacob.e.keller@intel.com/
>
>Since there is some ongoing work around policy code being generated from
>YAML, I thought it best to wait on the devlink policy portion of this series
>for now.
>
>Jiri mentioned he wanted to base some work on top of this, so I am sending
>just the cleanup patches.
>
>The primary motivation for this is due to the fact that dl_argv_parse_put
>requires a netlink header, meaning a command must have already been
>prepared. This prevents addition of a different netlink command to get the
>policy data, and thus prevents us from using this variant while checking
>netlink policy.

Thanks Jacob!
