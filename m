Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7553A6BAA58
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjCOICB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjCOIBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:01:53 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1546772F;
        Wed, 15 Mar 2023 01:01:46 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id bi20so2016037wmb.2;
        Wed, 15 Mar 2023 01:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678867305;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7bY7uM2WUrQr++XXrQWRw8Isupq/sx4rHRa6AGV7kwM=;
        b=aJZBZt8+qQGUmGLRg1lShIpbmXGwdzVJDh3Wn+oX8FI8DsNFQyZqOuNwutOzqkAf/f
         bdEh0KrCFSwMbrw02U+tZnq0Cdw3eZtImTe038zXGsZg1bDS2e3KXXH/ISoX/kk5769T
         uaGXya5wmwCqyF+cwVxfSZDexQGzVca6GGasgq1VrW/geHnXeTYb5yLOtQJlMgrw310H
         IkXUASDUD8Hg/L8LcfeyDPxvJ9CR66i6JMA/UZZAIPGsdrPsSKjE8MUuj3l67VH+OjiF
         vGkGGox5UM7SRruncy9rwcSrujdP9x96Ofv6EhlUrrtqivgu7HAzW22QipqbJrwWmfmf
         n7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678867305;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7bY7uM2WUrQr++XXrQWRw8Isupq/sx4rHRa6AGV7kwM=;
        b=2Bk5hDE8oxWFqw9Kja0nK+W5CjuXzveaTm2VC3dy+d6UarTfmIl5Lp6DyNycjmbyhr
         lkF7v0Ylkgb5Rk0a9s+4t4h1CLuKrSRCPq6HlJHbhf7WWL06ONVUywS5TOR4rQPsnaHM
         /p4X6i2BTDJ6t/reahi2YB2ux7S756TZNwMkiuzbnYtBbWS3z2oU5nNR3PSZ1ia1il+n
         uu+Acojg8UHCCJhCPnMiq1tofDoJoxEP7gtr815s/LKQ4w7jXyFGJXubjmMqAMyeEszf
         DQ+Ax//Fd5MZMfrX3yW2Xcvvc6ayqY8R7nOgiDMVftt7HnOQqTAATXvzhJ75A5Te5OlR
         DxWA==
X-Gm-Message-State: AO0yUKV6E6ZX9JKkFge7Z3pZKAOAHVcBTPLS0k9QnHw7yB6i64JBcmLc
        UAGGMyj/hNCWleBuYJ0MsEg=
X-Google-Smtp-Source: AK7set/lqTfii/x9kup6SsaRh721b/XRSN95Hv9u4L+njZPWQwhfJ7r4py/nOuzdql3dN/3kumtAXg==
X-Received: by 2002:a05:600c:190a:b0:3e0:6c4:6a38 with SMTP id j10-20020a05600c190a00b003e006c46a38mr16519683wmq.33.1678867304741;
        Wed, 15 Mar 2023 01:01:44 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k18-20020a05600c1c9200b003dc434b39c7sm5957812wms.0.2023.03.15.01.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 01:01:43 -0700 (PDT)
Date:   Wed, 15 Mar 2023 11:01:39 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Simon Horman <simon.horman@corigine.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@collabora.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] qede: remove linux/version.h and linux/compiler.h
Message-ID: <e90eb551-3b56-4c34-be8d-3d2187a1f81c@kili.mountain>
References: <20230303185351.2825900-1-usama.anjum@collabora.com>
 <20230303155436.213ee2c0@kernel.org>
 <df8a446a-e8a9-3b3d-fd0f-791f0d01a0c9@collabora.com>
 <ZAdoivY94Y5dfOa4@corigine.com>
 <1107bc10-9b14-98f4-3e47-f87188453ce7@collabora.com>
 <8a90dca3-af66-5348-72b9-ac49610f22ce@intel.com>
 <ee08333d-d39d-45c6-9e6e-6328855d3068@kili.mountain>
 <20230313114538.74e6caca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313114538.74e6caca@kernel.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:45:38AM -0700, Jakub Kicinski wrote:
> Reality check for me - this is really something that should
> be handled by our process scripts, right? get_maintainer/
> /checkpatch ? Or that's not a fair expectation.

If it could be automated some way, that would help a lot.

There are a bunch of things which have confused me in the past such as
how RDMA and the net trees interact.  Also the Mellanox tree, I used to
think Mellanox maintainers collect patches and send git pulls but
apparently for fixes they prefer if you collect them from mailing list?

I'm looking at my process now and I can see that I was dumb when I set
this up.  Just doing a fetch and switching between git trees was taking
4 minutes but I can cut it down to 30 seconds.  So some of this was my
fault.

regards,
dan carpenter
