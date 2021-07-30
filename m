Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC733DBE9B
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 21:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhG3TAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 15:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhG3TAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 15:00:34 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125EFC061765;
        Fri, 30 Jul 2021 12:00:30 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id y200so12670291iof.1;
        Fri, 30 Jul 2021 12:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=LW9Axg6PO2+fAhkVIielz/2kuUe/8kVjL2M0TRJoppw=;
        b=h7Wff98sS/D3hYcTAQd9yf/JkVaCdiSHAqFI7XGUFgQn0PsjpPMP6lFqvGDPX+GUx3
         tV9rgybUcmKNS1+Im0jIqkUUZsfNKGKTQ9Pb1udvrIdAP6k6wAoZCXF40YOIkDtxRhnJ
         AcyCyYuqEonB/Xfe/i7796npkV50tMNLbPEuN2K2R7BRrMSb3HKS66QYfe/tiQI46E6C
         lS68qjy8vANHhH47BAiRcX72HhDn1oMpfDzGuvAQanZ8ihb7Rl9U6msuPixBqOuGjzX2
         AkKBNhokvZ0rrRJIdp64lpJBKSOkgqX+dC6osTkB7mTvi+XVJduQNDWM3MCeCylnLCsV
         bOwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=LW9Axg6PO2+fAhkVIielz/2kuUe/8kVjL2M0TRJoppw=;
        b=RgpGXTsXiDtzxJGu8sS3bCuA3w8+hHbZ6AVBiyofu6JRK0YC+4Qi+Y5uvkw/Bn5SHm
         6GXWPC+u+Ybc4My/AWULrEyz8bURIhrNYOaA56XQkbQPpxaHNfWYbMI8ZNfFNyOfSMQu
         UFrnrwOQmWWkqZ8LoPPXeFoeiJre6ITHkufandggp+lGkE7LdzgqM8IBWoMkbvVCsFJJ
         nz4XCPZwzLP+g1ixDwT4K1l4TjbAk2Q5A0eSBkfDSjDsWXasDaEgGx9EQ1EkhF0JyZQl
         UGglzE2I8GCXmW0B9st4Z6UQe1GhG0Y/KzFoItSJDjJBAriLhPF+3U35CqG9dlgPaMN4
         t7Gw==
X-Gm-Message-State: AOAM532F256D24kTGQ99Uo0hXskc1jvSIxm66fHCZSRWu35nCt3evWyE
        kD+eXC3HUbD0ZqfWLf/ye34=
X-Google-Smtp-Source: ABdhPJww/+ckhdc92jt2T7e4jkYlM9JINk8XOuefIN5BFo+AtM3w9Tc+bDl5jNoH+2PkQCj9U8jaRQ==
X-Received: by 2002:a05:6602:2d10:: with SMTP id c16mr2254956iow.40.1627671629552;
        Fri, 30 Jul 2021 12:00:29 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id x4sm1336069ilj.52.2021.07.30.12.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 12:00:28 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 1/2] net: dsa: tag_mtk: skip address learning on transmit to standalone ports
Date:   Sat, 31 Jul 2021 03:00:20 +0800
Message-Id: <20210730190020.638409-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730162403.p2dnwvwwgsxttomg@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com> <20210728175327.1150120-2-dqfext@gmail.com> <20210728183705.4gea64qlbe64kkpl@skbuf> <20210730162403.p2dnwvwwgsxttomg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 07:24:03PM +0300, Vladimir Oltean wrote:
> Considering that you also have the option of setting
> ds->assisted_learning_on_cpu_port = true and this will have less false
> positives, what are the reasons why you did not choose that approach?

After enabling it, I noticed .port_fdb_{add,del} are called with VID=0
(which it does not use now) unless I turn on VLAN filtering. Is that
normal?
