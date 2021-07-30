Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EEB3DBDBD
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhG3RcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhG3RcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 13:32:18 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4614EC0613CF;
        Fri, 30 Jul 2021 10:32:13 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id m13so12339457iol.7;
        Fri, 30 Jul 2021 10:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=B8zL+1qEXUiyhytb1znuh6gn0RRcTrCNxC66xqLEJ2M=;
        b=XPp6ZGO91Rb7e90Ovm8SWrrU4CdL9lQZ/5cZWVw6TXHCt5dwQ71FDZFH1oZYbn557g
         obTqqr4Kx7ReoyX7lZAxPdTp7YZEBXcHJND+JX3rxG9knyEL85L2UJr8pNvPmR2NFXVz
         VYiW5yKFNZee9HCT2hKXkXX669jimeI0ganqZdEz649nH70wCQYLv2pvhgravJXFnlfD
         ZbUj7NFmQQwKE/myDhnSrwauThxqb07/a86C/9ixMlIZy9g4m9ndcsxj4tMq5GqirJu6
         KqHqFmagahVRc6Xot69XUs9WpZZqWnoTpaPdkzbfy9DxsAgyLQidumdhLkIs8vh0jaHb
         ge2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=B8zL+1qEXUiyhytb1znuh6gn0RRcTrCNxC66xqLEJ2M=;
        b=Mo2AKvckU19nd5UT+O8W4u8YURmIkgQ5OCTNwCduB0QHVPnA265/mKBlaYvzHed0Bb
         amcA4z3V3CTw1jMb3V0KMPbo2M3qs5grB2YFxnJRsszeZ1t0pziJEyMDz3soW4v1Jcu0
         oxz1dECE56/WfT76oP/Ynd49kjuPjPItT26Bcfy8evaHDBiRHIyfVpWBefAfmXq6NhQ0
         9TlaPoenVdRR5G462FDKdQYeEYNnZzZGOfLw1clsOlo3tlu8T1cALl96H6NCY/k+i/Gl
         j5WhSlBn9ujvRW5RhnorwxFV+UuL8/WjYxW5AtoVthxin9kpNgEonipGRZhkJjmGsZGp
         JwcA==
X-Gm-Message-State: AOAM533buONkHDZ9o/6uPLAKwkkPm7R10YetvGk0Sa2kGOC0luFuzGD+
        zbFbekxjld7kfZuscRA78wg=
X-Google-Smtp-Source: ABdhPJySqKOIiujFAu9fj7/f5VnXJ3qIZVovsQHfHWytr2kYzmNRDmtj8MyJLQFiOujKYaEgo3l4hA==
X-Received: by 2002:a6b:4f16:: with SMTP id d22mr880154iob.15.1627666332729;
        Fri, 30 Jul 2021 10:32:12 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id l12sm1142444ilg.2.2021.07.30.10.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 10:32:12 -0700 (PDT)
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
Date:   Sat, 31 Jul 2021 01:32:03 +0800
Message-Id: <20210730173203.518307-1-dqfext@gmail.com>
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

You're right. Hardware learning on CPU port does have some limitations.

I have been testing a multi CPU ports patch, and assisted learning has
to be used, because FDB entries should be installed like multicast
ones, which point to all CPU ports.
