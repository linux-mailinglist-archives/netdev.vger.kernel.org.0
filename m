Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2232D3661CA
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 23:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhDTVxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 17:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbhDTVxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 17:53:43 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D940C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 14:53:10 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id l17so9136800oil.11
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 14:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=00OiHd+LRJcqptKfnQ5Z0Sf2+EdKL1vKJSY05rY22uk=;
        b=TZAfxlR5XGQkYdpwkNnMhe2QL/sDEdnfqGivcdlGL1g5oohd/2ubYo16yLNtQTVzfC
         owhG0BE8jcys96nXRL3BUo5nRqiCokqXpF62i2IQcxnfxL6EkGm7B6Dmo23cMxk+9jCE
         VH2LcOLRHdL0i6XAJnASHSp7ilBNfXikRvM0ZrYGkw13YkS0Rz8BaRUMwUi8H4x8qUHW
         A7XmRwPbP1nVeNtznfhW0KcCkkNNeiI4tiFRXAEqPYLcSSHmNHpnTzlRjau6aiihHaBN
         MXy/Ysnq0JAehIgU+EuX8nlNfjikDWRX3Z+q94E2i27+YNXEtm5fMeO2Ha1J3ohaBosY
         U+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=00OiHd+LRJcqptKfnQ5Z0Sf2+EdKL1vKJSY05rY22uk=;
        b=HUfjSGvsCHo6cIX1eFyVPwDuNgYysM9O4esHdl+iWlcX4gQ3F08Ci/19Rwb18DbYUb
         019Xk7pk1v0S5faUErQoiT1rnFZ8aYdF9GNGtVNTNrarMkB1j5cGN8T2szcR7oZWMkxr
         B1UOIaGhqfBM3ITHBJ4avdYsiRQ/hgGyKTO2gp+ko0zEKiiqECAO6044P2/oR69NysXC
         1kSYDYjvdMfrNhcMPkUBkOfBLAzzPTcDN594KinHD9qJKlM6hxKH7JINkF1SfWIxJJ45
         eoWoAtxUHmaMMTN65AKtcipM3eq+QiD/W6ZlCi/GxWTnzrVPVr3ieLexalVqXG3PPqQB
         iIhw==
X-Gm-Message-State: AOAM532q4wLU05LvW0tTHz8tHCjUOt/2HCJul6jLD4BqPWuHPs0hwoEj
        Z9q/PLP1SjSJIrtrLxkshfw=
X-Google-Smtp-Source: ABdhPJyyd2j0rETipbc3k7xYBw0Kf9qe4uN6kI+PjPB/SUnPb3jdbp8AKBP3V9uGyBZ6sZz2DrkzyQ==
X-Received: by 2002:aca:db85:: with SMTP id s127mr4531007oig.142.1618955589697;
        Tue, 20 Apr 2021 14:53:09 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w29sm68510ott.24.2021.04.20.14.53.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 20 Apr 2021 14:53:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Apr 2021 14:53:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next] virtio-net: restrict build_skb() use to some
 arches
Message-ID: <20210420215307.GA103196@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 01:01:44PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> build_skb() is supposed to be followed by
> skb_reserve(skb, NET_IP_ALIGN), so that IP headers are word-aligned.
> (Best practice is to reserve NET_IP_ALIGN+NET_SKB_PAD, but the NET_SKB_PAD
> part is only a performance optimization if tunnel encaps are added.)
> 
> Unfortunately virtio_net has not provisioned this reserve.
> We can only use build_skb() for arches where NET_IP_ALIGN == 0
> 
> We might refine this later, with enough testing.
> 
> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org

Tested-by: Guenter Roeck <linux@roeck-us.net>

on alpha, sh4 (little endian).

Thanks!

Guenter
