Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606CA5B4337
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 01:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiIIXvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 19:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiIIXvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 19:51:49 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAEAAF0DC
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 16:51:47 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id 3so1967165qka.5
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 16:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=6fP8CNI1SxZ1fqsdJdaC/pv7thUt1nxPlxiORBGKp64=;
        b=MxjwEnSwUP/WAiC2Q+zqIjSy1drtwLD0ENps6KAI9yPt4cV+v9E05MURgmj+hdRBqD
         jZUB9jyyWboy1BHvh+Gi6L74g7oVbYIEUDhD/Udt90QyPHEgRVpei+rbTTFwPXNfa+RX
         AnkQA16btV6Pykr4yUqLSsDgONAHGIFzx7qkPIPF6wvFMMK0uMtFfDaBN1AZEVG7a9BH
         PZSUtdTJWhQ7Fdw63D1DVR2V19wDlduEyxc92ZPiIkfG25kwrEcbhf2gKNc4DlocfJkY
         ena2XflfaF3Wqv7sY5grTEhZ7cNv/PswzBStBQPqpPoBOHsbyegfyFbpHIWPzr5GHHHC
         2XGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=6fP8CNI1SxZ1fqsdJdaC/pv7thUt1nxPlxiORBGKp64=;
        b=fsSS/wQqr1XC5adM1i7PZOC+cFr1j67NaSPyynN46xP5Rr4BhPlXR/ACYu0FORY2MI
         yq07VI04JyGQlyBidL5aI3PJVA9F3spzV8Ww2uRSRT1IHZZSJmbSqK2v6vByXorixFj4
         LduVA/ACCPvG85zYFPLb9ICWNHOVl7fCLvz+evoGd0xtSlaEyfIYcGW9tPZqA+FhomJU
         jVF74lnmwNk1fdBQMtJ6IKX9j92SE03Z3yhQ3ChTSBNbf3Ek4v+UuUUE9nQpV3TTvJOX
         TK6hUWdSrO2H8I5JIBGoQUPJET2WI5YKqimmIxO1VLUdX7P45+fp+IbFAJ8C+uSZg6rh
         M6fg==
X-Gm-Message-State: ACgBeo0MREXdxXQ0WvbFPoa0pl2qksyHsP/CpXpJCB5/aaNei5a4HwjB
        b3oIOL6DjJAcwzmktbwmln22/A==
X-Google-Smtp-Source: AA6agR40F6wDnZVRyuVCU0Yg5WdYoSgzbpigfa0MDjdj1e9+PHm+LZ5aIlUjodnEFoQxhfhYn6oYnA==
X-Received: by 2002:a05:620a:8088:b0:6cb:d5f0:2ad3 with SMTP id ef8-20020a05620a808800b006cbd5f02ad3mr7047916qkb.486.1662767506843;
        Fri, 09 Sep 2022 16:51:46 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id ay44-20020a05620a17ac00b006b5f06186aesm1588367qkb.65.2022.09.09.16.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 16:51:46 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oWnmj-00A0En-13;
        Fri, 09 Sep 2022 20:51:45 -0300
Date:   Fri, 9 Sep 2022 20:51:45 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Long Li <longli@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [Patch v5 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Message-ID: <YxvRkW+u1jgOLD5X@ziepe.ca>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <PH7PR21MB3263E057A08312F679F8576ACE439@PH7PR21MB3263.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB3263E057A08312F679F8576ACE439@PH7PR21MB3263.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 09:41:25PM +0000, Long Li wrote:

> Can you take a look at this patch set. I have addressed all the
> comments from previous review.

The last time I looked I thought it was looking OK, I was thinking of
putting it in linux-next for a while to get the static checkers
happy. But the netdev patches gave me pause on that plan.

However, Leon and I will be at LPC all next week so I don't know if it
will happen.

I would also like to see that the netdev patches are acked, and ask how
you expect this cross-tree series to be merged?

Jason
