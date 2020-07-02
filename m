Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACF621222D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 13:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgGBLZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 07:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgGBLZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 07:25:42 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16787C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 04:25:42 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id o5so28396641iow.8
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 04:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y3eOAdXw1NhnAxI5LN5ukA0ePcO6Ycjk8EHcU3ptZvg=;
        b=VX3+T0wAjOcyJQXsSE22p6hjwxIEslK9trdMOEFCpon7rOo9uZJvfRheWJfe0kIrW2
         jvBeRU6VWJdzjuewBljKV7jrqtM2NEI2gRqTjfwFfGFnNB6oHuZxn7gDgJi2hfSHaK0H
         bf/zXS6wmJxAYvZgHYmNEdAlA1m25d7kkFJ3VKn+AeMLat7jJa9Wg1Q9o7h4ezqLtnvo
         8egpR65uZSZ+43+YOQdAYSeMhtfH5zdmV/RIcT68xinjj5yHd/f1qMx+TwcqVzDvKQJ6
         MyudbArryWewtcWygFqF10Vk68G1+L9My7RyKmNqNGLQigysBrPQZLmXyWRVblgtVZTS
         nB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y3eOAdXw1NhnAxI5LN5ukA0ePcO6Ycjk8EHcU3ptZvg=;
        b=RsX7+tCtqYI9ThIwhBpPZEoaj/jeGaU/9hsCZXJC3efEupak6zvAvGCPjPBZfXUq0k
         rLvZU8kgWLtgndcDNVBA9Hz9p1l6W10OetO47XGRTfX943Jg/yjZnUazvny7hRqC/DZI
         R13ZDFlM5nYKnD8UFwWYxTCOIjZ7c6ObClarWJBlf4YKpDhSm4c/BbGJPcQ6obOMNbtX
         M1tYSdxeX0QKjjvGSijG4NM9c0qnD4bCyydcJ5EhBhqYQd3e4n4eytf1SdddLLAQWCo7
         Drwe3ef+t55sh7b7a9zXUd0XPQ/QD3sGDfPa1RzlJxmyGYX+XUUdbOBnJcB6kiWboLhP
         m9tw==
X-Gm-Message-State: AOAM53236E8VhQN1bR/Dqc6qYrmVAPzV6UZskIHjHAWrDD6nSWzFCl1w
        N4g+EDeNT3rwa/8ANUOTa0FJmbG6bqzIRg==
X-Google-Smtp-Source: ABdhPJxJJVohuYXhVMwZUnkwtOEvVkj8qB74QVZNRSnSgepzbkAsC6UEJujGV5uhCD6jy5xGUbPkrQ==
X-Received: by 2002:a02:70d4:: with SMTP id f203mr34472237jac.74.1593689141424;
        Thu, 02 Jul 2020 04:25:41 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c3sm4692842ilj.31.2020.07.02.04.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 04:25:40 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] net: ipa: simplify endpoint programming
Date:   Thu,  2 Jul 2020 06:25:33 -0500
Message-Id: <20200702112537.347994-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests to functions so they don't update undefined endpoint
registers, rather than requiring the caller to avoid calling them.

Move the call to a workaround function required when suspending
inside the function that puts an endpoint into suspend mode.  This
requires moving a few functions (which are otherwise unchanged).

Then simplify ipa_endpoint_program() to call essentially all
endpoint register update functions unconditionally.

					-Alex

Alex Elder (4):
  net: ipa: move version test inside ipa_endpoint_program_delay()
  net: ipa: always handle suspend workaround
  net: ipa: move version test inside ipa_endpoint_program_suspend()
  net: ipa: simplify ipa_endpoint_program()

 drivers/net/ipa/ipa_endpoint.c | 190 +++++++++++++++++----------------
 1 file changed, 99 insertions(+), 91 deletions(-)

-- 
2.25.1

