Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9B6293063
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732775AbgJSVTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732742AbgJSVTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 17:19:19 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6114DC0613CE;
        Mon, 19 Oct 2020 14:19:19 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dt13so1026502ejb.12;
        Mon, 19 Oct 2020 14:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8Ty8dwHSeXQPAOmP4uMgdH5+uEFMpgtnYRrEFF0f/Qs=;
        b=kwL1DDLqX5lnIM7eJyhiC8HPP9Tj6rE6CGHbQeS357ozxRgyzZMulSzigIqXpxj/Oo
         /JzEktIL2l7x+FdroTe9bZ3WKJ7lycYKt7pkFFaQPkD/r5es4NiBS9dkt7zf6iX4hgc/
         qllop4/Nsp1WCSV4KQetgl/DGjPvGCK0UxyQnmZIPqFd+lfxHSBVng/VOMHu4lOyJS6X
         BzJpB0cnyTQwXHqAkZfVXWQCDaBGcrTeCBcHocrkON6bjjt22BWcVAbk0vgGX9Vhdux+
         0qvA8kBBxGt2kaXFyPEo9WjaTHy8nC62jO4YH4MjziUgv1Jq8JMBdUYC53kP1Gz+Iffp
         vrxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8Ty8dwHSeXQPAOmP4uMgdH5+uEFMpgtnYRrEFF0f/Qs=;
        b=o+uTChWcQIs9y15gI2cluGob4pqLu/HTSdRJdO7g256DyXKF4Y+qg3PY4++gfdjrza
         bW7iDXmZYO01QuKgE4DDfzotQvd2KEcQrdY+XAuhwdBFtai7pE8NEf+ynkzEl0vON/Dv
         u6DKQN9FtD8mb2MgVp+Jd3tYdN83CcTqvjnQkhzvIhLvu1SpsIS+xNg4hiC2U0io2DxP
         9OqnzR9zpEBkMlazFt8s9lTKrmN4LHwmj3h/gcpGX9iBUAA08ZRhlKMio4RovFPdg8TX
         DLO4054TQVaxCp/jAHJ3q3dmgoNVqZtHfK1FjlfgYDWD/hRYCObXAdKpmDoArngA+JYP
         Bniw==
X-Gm-Message-State: AOAM530/tF9IxP9UPRWRBLQLp2U+PrFGi9JpfePJ3pqdCh8EyN9UEBpn
        4S/Kpvdxqw/+T6glTK2mCic=
X-Google-Smtp-Source: ABdhPJy5pUJ/NhXH0Rf87vh8sDkSni/NPSvsrDv4FzGxUQ2Y652bR8yjYGuKdhpL6MifZnOgocKALA==
X-Received: by 2002:a17:906:364d:: with SMTP id r13mr1738370ejb.521.1603142358009;
        Mon, 19 Oct 2020 14:19:18 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id k21sm1073749edv.31.2020.10.19.14.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 14:19:17 -0700 (PDT)
Date:   Tue, 20 Oct 2020 00:19:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
Message-ID: <20201019211916.j77jptfpryrhau4z@skbuf>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
 <20201019200258.jrtymxikwrijkvpq@skbuf>
 <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 02:03:40PM -0700, Florian Fainelli wrote:
> > Completely crazy and outlandish idea, I know, but what's wrong with
> > doing this in DSA?
> 
> I really do not have a problem with that approach however other stacked
> devices like 802.1Q do not do that. It certainly scales a lot better to
> do this within DSA rather than sprinkling DSA specific knowledge
> throughout the network stack. Maybe for "configuration less" stacked
> devices such as DSA, 802.1Q (bridge ports?), bond etc. it would be
> acceptable to ensure that the lower device is always brought up?

For upper interfaces with more than one lower (bridge, bond) I'm not so
sure. For uppers with a single lower (DSA, 8021q), it's pretty much a
no-brainer to me. Question is, where to code this? I think it's ok to
leave it in DSA, then 8021q could copy it as well if there was a need.
