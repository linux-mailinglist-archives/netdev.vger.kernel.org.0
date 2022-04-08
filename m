Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790204F9CBD
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238717AbiDHSdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238807AbiDHScy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:32:54 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3657FDB493
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:30:49 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w18so10956561edi.13
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 11:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=zsacSiYIJdA2/VBYX7tqRtE5Pw+r00w2Ibh+DlmRbEQ=;
        b=fMjHi55teVou+F4VFVIp1l561CfuLheptCyUwHlRFu5n87b2wl8c5j4lgGucDD62lM
         trmqrlvpAG9H7Y9I78jeKhJN9OFJqpRTZ3EseER0Bl/ayYwpQDWep43fPxQuwOJPIw1t
         87tIeRLTDz942qpZQLh12aeNGNh7bhLiGeOriIvAjQsLsH+5UIixP1EKTfUDVlB5eAe4
         uOd+9LJRjvsOW6Ox3c2YFcACV8PD/vC3dH9R5w/BCACSvx3dCVF6rirAR5rFVvBrmxaB
         UaOENUzkINMMve1W/r58dKN2zKLqg9Hmp5Jbhp6KbQzKjFqMs8JMBBFEW4PO4WD7tZgS
         5esg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=zsacSiYIJdA2/VBYX7tqRtE5Pw+r00w2Ibh+DlmRbEQ=;
        b=eFkCteMzLbHU+N0uTlh5ocS7dLUjRZN47CYBuEcE+8kyGjKiZKk+KDiKMuaR2QIZBf
         5CnCT74THiImH2aj3+jvVP57jRfb6wdoHbasim7jIBGa76QiNnFugAn7WA/9C3vMiY3D
         KHjBN3JpacnEG9XZmUTn9f1RBrOB1FX/usonLQYYko/lJxzhCtJfVhCg2BMPszLUzMHJ
         BKlxttuKhH+bgMj1y3l0AvMLcHVFfttbcSakLdwzPYXy4sAOatjDxmxQqxmAB1AEKT+e
         mFGGgLHOXCYMzT2jyolA+UODdLC1WU8DsfuIXwO8hjeKTNXByfFaa6hFRDnBGxP0Z2vs
         TvAg==
X-Gm-Message-State: AOAM5319EURLTFxHdqhod9oEFZvLY1wcICjXOAd/L2ptiFRHMQKoTp+S
        BGnIWZXTJfRJajS2t7xhQuCCQffWNPM=
X-Google-Smtp-Source: ABdhPJyQMpLdPGGLbUm1OmJf1D3DBavXW2LvaXz0PpNqdJ9F0mBLIVW8iqOMR2XpV48fRk3nl+U+wA==
X-Received: by 2002:a05:6402:2688:b0:419:5dde:4700 with SMTP id w8-20020a056402268800b004195dde4700mr21176592edd.124.1649442647287;
        Fri, 08 Apr 2022 11:30:47 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id u26-20020a17090626da00b006e7cb663277sm6488092ejc.90.2022.04.08.11.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 11:30:46 -0700 (PDT)
Date:   Fri, 8 Apr 2022 21:30:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: What is the purpose of dev->gflags?
Message-ID: <20220408183045.wpyx7tqcgcimfudu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am trying to understand why dev->gflags, which holds a mask of
IFF_PROMISC | IFF_ALLMULTI, exists independently of dev->flags.

I do see that __dev_change_flags() (called from the ioctl/rtnetlink/sysfs
code paths) updates the IFF_PROMISC and IFF_ALLMULTI bits of
dev->gflags, while the direct calls to dev_set_promiscuity()/
dev_set_allmulti() don't.

So at first I'd be tempted to say: IFF_PROMISC | IFF_ALLMULTI are
exposed to user space when set in dev->gflags, hidden otherwise.
This would be consistent with the implementation of dev_get_flags().

[ side note: why is that even desirable? why does it matter who made an
  interface promiscuous as long as it's promiscuous? ]

But in the process of digging deeper I stumbled upon Nicolas' commit
991fb3f74c14 ("dev: always advertise rx_flags changes via netlink")
which I am still struggling to understand.

There, a call to __dev_notify_flags(gchanges=IFF_PROMISC) was added to
__dev_set_promiscuity(), called with "notify=true" from dev_set_promiscuity().
In my understanding, "gchanges" means "changes to gflags", i.e. to what
user space should know about. But as discussed above, direct calls to
dev_set_promiscuity() don't update dev->gflags, yet user space is
notified via rtmsg_ifinfo() of the promiscuity change.

Another oddity with Nicolas' commit: the other added call to
__dev_notify_flags(), this time from __dev_set_allmulti().
The logic is:

static int __dev_set_allmulti(struct net_device *dev, int inc, bool notify)
{
	unsigned int old_flags = dev->flags, old_gflags = dev->gflags;

	dev->flags |= IFF_ALLMULTI;

	(bla bla, stuff that doesn't modify dev->gflags)

	if (dev->flags ^ old_flags) {

		(bla bla, more stuff that doesn't modify dev->gflags)

		if (notify)
			__dev_notify_flags(dev, old_flags,
					   dev->gflags ^ old_gflags);
					   ~~~~~~~~~~~~~~~~~~~~~~~~
					   oops, dev->gflags was never
					   modified, so this call to
					   __dev_notify_flags() is
					   effectively dead code, since
					   user space is not notified,
					   and a NETDEV_CHANGE netdev
					   notifier isn't emitted
					   either, since IFF_ALLMULTI is
					   excluded from that
	}
	return 0;
}

Can someone please clarify what is at least the intention? As can be
seen I'm highly confused.

Thanks.
