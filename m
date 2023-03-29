Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE7B6CD421
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjC2ILd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjC2ILS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:11:18 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B2A35B5;
        Wed, 29 Mar 2023 01:10:59 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso10909957wmb.0;
        Wed, 29 Mar 2023 01:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680077458;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/4t4OvCQjo33JGjobittaaxVDDegfvrkYrLpIGC83o=;
        b=hc+I7GgxDJExRVT0qlKTaDwMBbzUxEWpa2RNLp2ERtN3JnGBdLEc4s2KKx10imXy7T
         84biQJEVomdzXbuWYOqtylvbdglKk/PurgFmvuvRi+AzonLKfjTNGTzl8Q2Tl/YyY2jX
         gEKsd49ue3Q7WYjLNmwQO1AFMFXXaoXZOXXuaeCETn4MFeHwaFGy/ujWpJ+F1TCpxo3y
         S2S/WJMXl6mta4slX9JM5KeDEPbb3mNDEOEl39fgJblRKIGEHMlx7Ui2g9anMzdNbRIL
         wvtOs/VJpCiDiGqFXvkIz1MYsHTjCVOVdbRKhgm1NZKM7c6xQxQo2tGXhbmubxbAjGes
         HRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680077458;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M/4t4OvCQjo33JGjobittaaxVDDegfvrkYrLpIGC83o=;
        b=GE2zVHYDYcf9f1frZ+hoRSUM/XMTXdTjGnNiYriiBGeFFbP2/NaK0kf2H5ug2oSurn
         oaiTOALKab0v98J+8skcdBucc9XrPuhwDVus1TMsnHxdM4ZWKKe4geziuDhc7XrufXnx
         cZemQjV2ButLgSC/AGchjYit0stAEphdZon2FEyusqzhWqLIrL/iatZkp/d0h0Q50Y90
         PUgWUGOByxpudQXm8dpeFd/lVBzs7qeEUsJa7AEaV/5Mdm/FVzRz6l47GEFojZ15B33j
         tGALoc6Jm2C2tb6CGodpEvqHXpe/s6jgYXWwHw3+u+F9KHZPzJTeN3T77XG4J+lAU3Er
         5G3A==
X-Gm-Message-State: AO0yUKUfWO6viMafh5UfBvzGVRFGDW1mvTH4r7noBqRR3c/J1Xavntsp
        z+wltbE5fjmW832TuKgYrcs=
X-Google-Smtp-Source: AK7set9x9jFN4Plu2UmMtpejEnFrvn6a6z16+v/aEEdxK2Y8krzFM/wAHnT+KxPR01RzEqUm2SqdVg==
X-Received: by 2002:a7b:ce08:0:b0:3ed:9a37:acbf with SMTP id m8-20020a7bce08000000b003ed9a37acbfmr14013889wmc.31.1680077457916;
        Wed, 29 Mar 2023 01:10:57 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id s17-20020a7bc391000000b003edd1c44b57sm1323559wmj.27.2023.03.29.01.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 01:10:57 -0700 (PDT)
Subject: Re: [PATCH bpf RFC 1/4] xdp: rss hash types representation
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net
References: <168003451121.3027256.13000250073816770554.stgit@firesoul>
 <168003455815.3027256.7575362149566382055.stgit@firesoul>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <39543d22-4e71-9696-17f8-5ae22728aa25@gmail.com>
Date:   Wed, 29 Mar 2023 09:10:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <168003455815.3027256.7575362149566382055.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/03/2023 21:15, Jesper Dangaard Brouer wrote:
> Hardware RSS types are differently encoded for each hardware NIC. Most
> hardware represent RSS hash type as a number. Determining L3 vs L4 often
> requires a mapping table as there often isn't a pattern or sorting
> according to ISO layer.
> 
> The patch introduce a XDP RSS hash type (xdp_rss_hash_type) that can both
> be seen as a number that is ordered according by ISO layer, and can be bit
> masked to separate IPv4 and IPv6 types for L4 protocols. Room is available
> for extending later while keeping these properties. This maps and unifies
> difference to hardware specific hashes.

Would it be better to make use of the ETHTOOL_GRXFH defines (stuff
 like UDP_V6_FLOW, RXH_L4_B_0_1 etc.)?  Seems like that could allow
 for some code reuse in drivers.
