Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF0A255115
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0WdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgH0WdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 18:33:07 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6FEC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 15:33:07 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b14so7717071qkn.4
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 15:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4mVwoajqnqYDKwxTQ5kykvsf5HlDnllHosxg0HUjUQE=;
        b=JAjYGgfzx+pBlXGBC2Am5igSZSdaTV7+dpRW8A2fM+rKOWkx90nUhsICMEayUsWM6y
         6h03oJIEkk/zUW+2k3ppNdKGbqCqWMbGYgjpY0HLmafxHAqOngWAvJ3Y2VLJh55RLgy0
         4RnJCzcQ5VXO5yN+4mdnp56v8zjEQqasgN4x2RA4F7FpT/t5QE8jJ3ui04BycRhKB58C
         8L9DXBYCUr41ST1PAvzhkEl5K4RnF8toRtYeer1MqHe6s0835k9OrTobE9k9Ihynz9yp
         E2/v1+lDc1tBMXdnveCZSkbKU+9Xra1xMPrO8cfVs/FLZv+urqPphMKwdf7qj/HyT3k9
         1wDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4mVwoajqnqYDKwxTQ5kykvsf5HlDnllHosxg0HUjUQE=;
        b=ARfHlAy6WQ3nJIPY+OYjZnZM3ihYHuIX36D2byEldduDTF2J40vORyKHXyB1zYFyeN
         eYjNvju9oGsyDNen8Y997KgulSsymvMraXbHDi6/YE9zNaClO42ceQL1m85CBdX2Me6/
         9T9aTL8/qWKwTZ7eN006jbEBf/dt4y0KHYqllQMWIu933nGtUjxBE4Ch1OlV3OkFAwz7
         xyIikD3dQ3irsztRodwMYOIuIu0Hwucm/XSiUMVYnH9KhEd1uGOGJ3Pn5d9+8G5NTn6r
         Bfx8sZvepshgMy0180Afmix9mWfeHVn7sQ260pQ4YWnRCo6iTfYP6muaq/BZfR1TA1JD
         aycA==
X-Gm-Message-State: AOAM533IboLddObLnKcTftJjwn7IqrS5Em6hU0JvruWc909iM4GQNuea
        PWN8D2ve535S/d+nHDcsakQ=
X-Google-Smtp-Source: ABdhPJyp8U6PjfMKj0vriyu/K9fSUfBo03GGtDdYhFwlCZ2fsFxl873enDDthxarV1bjkYBQP0BE7Q==
X-Received: by 2002:a37:6848:: with SMTP id d69mr4637396qkc.80.1598567586116;
        Thu, 27 Aug 2020 15:33:06 -0700 (PDT)
Received: from localhost.localdomain ([177.220.174.181])
        by smtp.gmail.com with ESMTPSA id v28sm3286908qtk.28.2020.08.27.15.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 15:33:05 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 31810C1B7C; Thu, 27 Aug 2020 19:33:02 -0300 (-03)
Date:   Thu, 27 Aug 2020 19:33:02 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next] net/sched: add act_ct_output support
Message-ID: <20200827223302.GA2443@localhost.localdomain>
References: <1598335663-26503-1-git-send-email-wenxu@ucloud.cn>
 <20200825153318.GA2444@localhost.localdomain>
 <347b446d-ec80-9b8a-6678-86a6c3eddf6a@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <347b446d-ec80-9b8a-6678-86a6c3eddf6a@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 11:30:54AM +0800, wenxu wrote:
...
> So only othersolution for solving this problem?

Lets wait for Cong's input. LPC is happening and he had a talk there.

  Marcelo
