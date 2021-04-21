Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8B1366B02
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbhDUMnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbhDUMnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 08:43:04 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B0EC06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:42:28 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id c15so32286912wro.13
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JBZkzdzNBhrMRPGWD17+SCVQpQvoN/SQipwfw73+rDM=;
        b=vffTDay9c4zTNxQAzZFcAVWjvRClRl7SyF2DkFRcHvHFEAk0/Lwq/F0JLBrHGGINym
         FzxuO20RhZkuDldvBQUmR/wrlKIwvjlwkqbRHbRFxpMi0odBs8JO3AVGMrXW8dLX6ySe
         gvxbEWYkSp1/WbE+AzUvnaqCQKJLBdYu2Vnf3wZvhoasGYv8C3b67Mw/0kwvq9Hia1PS
         AgZCauNIpkYxhUvPq205ikNbQGyd4BEQASfGy0GTRBIjs24N1stUh2NS6ZiQPn7uuI2L
         rnDLo/EMJWwGC8PC0JU0E2OH+oTPG2mHut5ZBLaXSZrKyb6R3R56D0W1xnZs4u3xIvy9
         /vBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JBZkzdzNBhrMRPGWD17+SCVQpQvoN/SQipwfw73+rDM=;
        b=P1y8IXU5WOOQyxvQ3mPODXgnS79XMvY6cOz5TnAQVENFxD2qBNY6h44qxP0OltfMxT
         QPZZSu+/sYNQaZaBscNB1yzUk+SrlPKcvMLw7K4FM7i6h9G/F+0Y3W9laur6qxNRYnHp
         0hLxIr+N+cbdrbc93Z4lucFHSJvwM21uBitTtCHIM9AKw7nQ2YCqCGocT4pnWjU78BaS
         gLzLbvWRIjS4l+P0o8GzRimE47ewv6Vn1G665Bvw6Z6Sp3RQ8lBHqwg1MKTy6OH5MxNL
         IZ4jJVGgLdMcZsANbuxc3tl9FUry/onVdnBfClN3EsyXJvbHTYy2PLOPtVLk/uB6FGll
         d8MA==
X-Gm-Message-State: AOAM531y5ub4NiNSpU4akIgtqKKfKU/h8VhNv727FflfqWkIvyy0y3AB
        rZcok24ZxSXqX3iv9cjoz7fL3qnqHq+D2lXjutI1M/qd3MU=
X-Google-Smtp-Source: ABdhPJx1pEk1aAmTMLR3t1huVf/oJxOOEKL7N1YhG+aBnyE9uaWAgsHHAQSqO0YOowMLP9yzIWPKWupjZT5OFxqe1pA=
X-Received: by 2002:adf:a3c4:: with SMTP id m4mr26748475wrb.217.1619008947446;
 Wed, 21 Apr 2021 05:42:27 -0700 (PDT)
MIME-Version: 1.0
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 21 Apr 2021 18:12:16 +0530
Message-ID: <CA+sq2Ce+AW3HUhqxa2Q9+2G0BGTnjuzLdnLLBVfeY=_0s6dANQ@mail.gmail.com>
Subject: How to toggle physical link via ethtool
To:     Linux Netdev List <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Have a query on how to bring down physical link (serdes) for a NIC interface.

I am under assumption that for a SR-IOV NIC, when user executes
"ifconfig eth-pf down",
it should not bring down physical link as there could be virtual
interfaces still active.
Let me know if this assumption itself is wrong.

If the assumption is correct and if user wants to intentionally bring
down physical link for
whatever reasons, then I do not see a way to do this. There are no
commands either in
'ethtool' or 'ip link' to achieve this.

Would it be okay to add a ethtool command similar to 'ethtool
--identify" to toggle physical link.

Thanks,
Sunil.
