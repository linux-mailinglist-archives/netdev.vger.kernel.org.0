Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B3163780E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiKXLws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiKXLwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:52:47 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C89D5C778;
        Thu, 24 Nov 2022 03:52:45 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id r9-20020a1c4409000000b003d02dd48c45so3426603wma.0;
        Thu, 24 Nov 2022 03:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rjp+fW1bIQwING6AJlrFaM4AzfZM4MmHMV52VaJCTow=;
        b=mYp0E98DM64doiO3NHxbAr0gXGaqZqgFBVnA5H1oiRykusbvnaI7OT1XQpsMyuWu0y
         Rq0ydBmR938KEBoNjYupdZ4McPJpMs8HER0HiHHy8lKkvrIS19o8ttFRb1cJ4l8ZDsWp
         6EFTgFc0hBFe700OEuIHBR4C4U36I6N8pajD6qVWRVZwrMw9lnPjMFORSgTmpKSWAunl
         CQDXKsrbn1lYumgrOhe3Xt41ZvTlZ4rp7Uqt+vH6iolE8qYnb7NFikOkL/aSU89rDG76
         Xganf43juGXRyUtaSIUQULTxzLKDNl51qEews99SY9wrnQKlAbvRUJqOfY5R+zwQRT//
         KsrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rjp+fW1bIQwING6AJlrFaM4AzfZM4MmHMV52VaJCTow=;
        b=ySRxT+nebS7XjwriVzGJQMvHBejUcu1LCD1IcjVP36ZEn612bGLNzl9WekNT/PFM02
         xpiKk073BcvNk6J6I66OjLWLZ371RtoAMd8JZ04xoTkQzDFyjFCb96i7nsMHU/qk8gbk
         lFV4x89zHI+IvPK3ShVdWE31VHpChfs3pBwepMI9bgIlUWlf/pgKOBoSbVj52Tb6M1ev
         ZbrrKfEH8ggCigAwdrsD7oA6eE5PfmdT1bOmQOrQx5nqHxd1jXnN07CN0MHF3Dm6dMGn
         7sBbmqp5poC9juVoZgF6cD9BIz4UFPxoEnmL79TFZRetitzZTBYWQZDBOhzb5OnmJpOB
         VZSA==
X-Gm-Message-State: ANoB5pk0g3zfH+a4gYvOnFrh2KgbfFO4WTMT1OCdJHU/1Stx1O2Wq9vv
        BoXOdpKKXq9A91RRbTpaffM=
X-Google-Smtp-Source: AA0mqf6VQzuKPgkYKrGpI4tyOBS9i9qMshBeho3hjSdPYsd8DRYQahzDKB+xV6VTlMAXdrf+Q01GKA==
X-Received: by 2002:a05:600c:a41:b0:3cf:895a:b22b with SMTP id c1-20020a05600c0a4100b003cf895ab22bmr10659070wmq.81.1669290764427;
        Thu, 24 Nov 2022 03:52:44 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c3b8c00b003cfbbd54178sm12918700wms.2.2022.11.24.03.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:52:43 -0800 (PST)
Date:   Thu, 24 Nov 2022 12:52:09 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] gro: simplify tcp_gro_receive
Message-ID: <20221124115143.GA73639@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series attempts to make tcp_gro_receive more readable, and easier to
understand. The first patch also removes a few unnecessary runtime checks.

Richard Gobert (2):
  gro: simplify flush logic
  gro: change confusing use of flush variable

 net/ipv4/tcp_offload.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

-- 
2.36.1

