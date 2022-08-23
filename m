Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB4059EABB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 20:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiHWSOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 14:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiHWSOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 14:14:34 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4326B102674
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 09:28:52 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m15so6417805pjj.3
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 09:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=KT5REq5taFOVOyHwQQhW+thH+xp6ED4rso/wf6UMx0U=;
        b=e5Z48MPFIC4T5h/fM3kMz8ma4bTsmzgDjsaGEDt1RpEtGKEDVNyJpWBHE9hjdsum12
         VTMCdfUFLWNb7ywZu7o+/SG0hQ21jOyXF1S6aUTexzz/2h/QDLIxyAOaa9cl8j6evfqW
         nrczp2Xq4czUjO6uMQxfZCFVIcgI5obzy+nD96WA4Zer1DVYPy0oBOmnzjHRo6/Vb3MS
         BtciKdTgleDPZ93LPamlWonO7yw4PpNELKfMz/q1hRNGpXCwh2I9eh8XBW4zaXQdV9eq
         /GRcxkUnLFuNBHrWKWXEFR2xEixt8VXe+kKcsgmQZsHhCexsbRBCyw1qqDTN2wSIjjvP
         FzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=KT5REq5taFOVOyHwQQhW+thH+xp6ED4rso/wf6UMx0U=;
        b=j6xr4osYucg4I2/yPduglF3VsKbg0OMol4pXoaWJ0B5uv92G8CboA1ba3ORN3JTY0c
         1jVkWhLyZ88yrICT9n/m91vcI83Cii4gZRrl0ArONyPU7wUUsiwsqI+TlC9M2ZjeIm9K
         CrgF9FueVJlXK/p1wbdcFjjXcA7o5Q3Xltt6baO5KOGqOLdGsrpx73fDCqee2Ta2sDXx
         dMaEDYf1NfnxxLdVwBLEqs6q5MHtW1vdo1qoggQjqe8H9uMX+GK7aSPLUmApMlui3enK
         ZlaR3lSTN2zaVBVkfjdKj7JEFHlRW1nvYsyFjzdFRXtW33rQtRgEE5Nk73c40tIGIYoB
         xOBQ==
X-Gm-Message-State: ACgBeo3/AgTO9bMXPddvkBE61sNd36ILM9Eu647h6EWH3NKZzMl3nFaw
        pfMfhAF578e6punguRzd80M=
X-Google-Smtp-Source: AA6agR7Nlq05DUINhRrCD43qjScHAolYUAax5XnCMHAagunY1wPrFmUKn6kcfewfswn8L5z8BjcFuw==
X-Received: by 2002:a17:90b:3903:b0:1fb:6da8:dce6 with SMTP id ob3-20020a17090b390300b001fb6da8dce6mr2396485pjb.5.1661272131203;
        Tue, 23 Aug 2022 09:28:51 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902a3c100b0016d62ba5665sm10708063plb.254.2022.08.23.09.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 09:28:50 -0700 (PDT)
Date:   Tue, 23 Aug 2022 09:28:45 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Thampi, Vivek" <vithampi@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [net-next 00/14] ptp: convert drivers to .adjfine
Message-ID: <YwUAPQh+h269+8/n@hoboy.vegasvil.org>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
 <Yv8+GdoEEIPpSYJB@hoboy.vegasvil.org>
 <CO1PR11MB5089804163547BD4593B7E06D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB5089804163547BD4593B7E06D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 08:56:38PM +0000, Keller, Jacob E wrote:
> > I'm on vacation until Monday, but I can test cpts on BBB then.
> > 
> > Thanks,
> > Richard
> 
> That would be great, thanks!

Oh well, net-next doesn't even boot out of the box on BBB.  Maybe the
TI folks have a recent working board with cpts...

Thanks,
Richard
