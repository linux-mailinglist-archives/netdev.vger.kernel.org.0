Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4086320A44
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 13:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBUMj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 07:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhBUMj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 07:39:58 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C18AC061574;
        Sun, 21 Feb 2021 04:39:18 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id e17so47639223ljl.8;
        Sun, 21 Feb 2021 04:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ooJNNgyLxSgtXrlAqytg6PlPTL1gBhKSaEdENZ44wU=;
        b=B9acX6iN9eqTg0mLidcuyzgxYnKymlJcyVcHlXprYUxUdun9xANNEUVJzWCo6Gw2TT
         UgFi8r6TfNB0mAy/nc5xs18oEocRa4sCUrdafDQ02jlCl6ey1zdTVhE/VeCn+OSlZbhh
         JhyylCgudNf2/NhRWgAV6p/8fvwt+xGhUMtAfmXCsI0iRoXF19g4iZhY49vagUnpHqx6
         aqe9AZMTQq6fuU8qDp3ST1G0ERcVuZ/2yZ7rV0c8t8ddkO/Jg1OYE3VxlBtrSq1lE3NR
         XmickdD8eEndQ2FRontRHjExiDWPTxxLpcCaggaVu/nqPY9t1rIvushie5hEzPj0KX9L
         s1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ooJNNgyLxSgtXrlAqytg6PlPTL1gBhKSaEdENZ44wU=;
        b=EytUB+0DnpXQpw5saWtHU4vbBE+vaHILnNpSl8TWv6mNItOdJXmUWnA+wY39VEVWsR
         BX4gP4wLvfGHqerTrlaucxtuSejRQnGLnioTyOMCbcO3YKPoy5ywpS6e8TQurWN1eIAb
         itm5XLStr58uE3p2iIArwmTkoedHG22vSpTFiecFhvIqrKPgyqntQbKXsKK1saoq0Pv5
         xmkAhmVBQsnK0WNYQmjlcfh9i4r4/liwWJwJz+Y+viGUifny9WbxrKzVrG2UH79s+tyY
         2+u3SH6L0aBNZ6Fb/O+Vgrr3W7Bz624HovHejY+SMOKhAct9eYFmpaRm5+DfsqNhEczC
         aRxQ==
X-Gm-Message-State: AOAM530A5kxH4T7LBrPdi4p1Tf1nKfQuqHS9PBpQsNVF4gVFbfDnV6qH
        mhTOR+gzGtbs4iiCfJI3zHg=
X-Google-Smtp-Source: ABdhPJwKhyoWxWMqQrvDAxezIvfKgkgDz8xjxAZSo7ShaWjCfzZqXVvk1ISVEoLcC84Tm23Gd9hQBA==
X-Received: by 2002:a2e:a404:: with SMTP id p4mr5629250ljn.286.1613911156434;
        Sun, 21 Feb 2021 04:39:16 -0800 (PST)
Received: from localhost.localdomain ([37.150.90.70])
        by smtp.googlemail.com with ESMTPSA id b14sm1677559lji.120.2021.02.21.04.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 04:39:15 -0800 (PST)
From:   Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To:     eric.dumazet@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, snovitoll@gmail.com,
        syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/qrtr: restrict length in qrtr_tun_write_iter()
Date:   Sun, 21 Feb 2021 18:39:12 +0600
Message-Id: <20210221123912.3185059-1-snovitoll@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <3b27dac1-45b9-15ad-c25e-2f5f3050907e@gmail.com>
References: <3b27dac1-45b9-15ad-c25e-2f5f3050907e@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do we really expect to accept huge lengths here ?

Sorry for late response but I couldnt find any reference to the max
length of incoming data for qrtr TUN interface.

> qrtr_endpoint_post() will later attempt a netdev_alloc_skb() which will need
> some extra space (for struct skb_shared_info)

Thanks, you're right, qrtr_endpoint_post() will alloc another slab buffer.
We can check the length of skb allocation but we need to do following:

int qrtr_endpoint_post(.., const void *data, size_t len) 
{
	..
	when QRTR_PROTO_VER_1:
		hdrlen = sizeof(*data);
	when QRTR_PROTO_VER_2:
		hdrlen = sizeof(*data) + data->optlen;
	
	len = (KMALLOC_MAX_SIZE - hdrlen) % data->size;
	skb = netdev_alloc_skb(NULL, len);
	..
	skb_put_data(skb, data + hdrlen, size);


So it requires refactoring as in qrtr_tun_write_iter() we just allocate and
pass it to qrtr_endpoint_post() and there
we need to do len calculation as above *before* netdev_alloc_skb(NULL, len).

Perhaps there is a nicer solution though.
