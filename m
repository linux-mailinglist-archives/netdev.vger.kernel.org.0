Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C0B108174
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 03:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfKXCZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 21:25:51 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33354 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfKXCZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 21:25:50 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay6so4901192plb.0
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 18:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=O1nyYlECjp0BHoEkdlX1u+EmoR7HXi9s61iX1ye0QNg=;
        b=F9Q1zyQnHoqvRkvUyxc75tvx/7Hc0KdxQCXE7E7G2mtU0C++RNydvVcevUBNiwtB76
         3yAaNcEU0c+0KYjgoCVe4oazerk5qMtWsTEvzaD0YuvcGyr/B53EWVw3o1CPF7e0zfH7
         XO+dIhDZIAVuv/OlTG2r52gznYaXCPTPD+JtXVOX38kLK4Ko/azPep9mX09We+f7yr/5
         21G3Sg+WT62U7R0Ul4WeM+yAoazH0qz7id3M3LZUeHfV2mdknVbNfjIJ3CcSqkJqYZwF
         7LPO4r1txTKglogpFj0dJ7h/9YpxxO6qhvwb179kCLhtQAJg6H+et3QTmTdUz1xlJMLT
         vRng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=O1nyYlECjp0BHoEkdlX1u+EmoR7HXi9s61iX1ye0QNg=;
        b=TA4NTvj435li6PuARjVuH05W7xW+WW7Y1t2Te9WKwB4KGO7FrSNMmM5o0Agi6iK3g1
         NygyckaWbEC0L4KBY/KQJnaZkO4Fy1TWPbhiB4N6PM3TGWgo7Gw02qKTt/Mc/8hantuC
         68GRI5ezsQjQjCUg4ej+HlO2kpIYn71r8d3Sfc3Vm+FXn6SEPO0IK85O6h47y+D6Y1vf
         puasMB4QDwcNiUkK/h9BmC93J4bOEjSNFOGdiaGyLpL7ml67QxHEl1fbJALzh8XmhxiT
         N6/eRNDWBuh5lpBE4NecgQymxV42JwBFZ3u1O+Jm11DLuWVGUbEdapm2M27fj0wf8AcF
         /k/g==
X-Gm-Message-State: APjAAAXXh0cjpU7lwWq2Oph3o4oW7yFZn26fAL34oBiAiSdMNqrAJ1Tk
        bF8uKGVHAX5iJ3zFYoxVOr9/LPAVXkQ=
X-Google-Smtp-Source: APXvYqyhfKeVUj1c3iwZ2gGQjiP9Sw1k2q7K+12TsTIZl9kCXTKEBzuMKqmTjt9OBkr/cWJdOUyQ5g==
X-Received: by 2002:a17:902:a403:: with SMTP id p3mr20634633plq.275.1574562350095;
        Sat, 23 Nov 2019 18:25:50 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id r16sm3262712pgl.77.2019.11.23.18.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 18:25:49 -0800 (PST)
Date:   Sat, 23 Nov 2019 18:25:45 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, emamd001@umn.edu
Subject: Re: [PATCH] sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook
Message-ID: <20191123182545.2c73268a@cakuba.netronome.com>
In-Reply-To: <20191122221759.32271-1-navid.emamdoost@gmail.com>
References: <20191122221759.32271-1-navid.emamdoost@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 16:17:56 -0600, Navid Emamdoost wrote:
> In the implementation of sctp_sf_do_5_2_4_dupcook() the allocated
> new_asoc is leaked if security_sctp_assoc_request() fails. Release it
> via sctp_association_free().
> 
> Fixes: 2277c7cd75e3 ("sctp: Add LSM hooks")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Applied, queued for stable, thanks!
