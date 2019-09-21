Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 726C6B9BCE
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 03:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbfIUBMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 21:12:16 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33621 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730498AbfIUBMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 21:12:16 -0400
Received: by mail-qk1-f195.google.com with SMTP id x134so9236023qkb.0
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 18:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6zCGyGhBzGJntzR+JVLXXp2vIikA3F6eph+tKUIQPTc=;
        b=OnTaWSVe7ocWBli/lZOWwcXor7BGGLXv/Hh9NnGXYztmb41NFoZPvVl8gqWcJkgCBd
         Wh/B/g9Z4dhjyHzApwqcVkh3kdehYJT47aiZN3lGk1GicqBjztdSyNA7xRKcFPogHka0
         X3UVEhGR/baYiL6+0KXznK173Bug00AulGkYrJx3b6BhwjE3fdub3ON/IvCoJfoOHWkB
         rESZG3vPNrSFgx4xMGqlUpZ5OyeyIDGraop7K8s46RMkLeG3ZzOZwZNvNX/E4PATCJCy
         H8g0Abx5OwNIlZc45YOLYEe4hw35KriDcKoA9dDTem6F7PSDXpu1xTQ4g7tXd3B3+plS
         6qpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6zCGyGhBzGJntzR+JVLXXp2vIikA3F6eph+tKUIQPTc=;
        b=OeXRpzk6p4SjRpXSRgvFK2KkDk/NPsd65NJ6VJVGHxgczcZlAHrtG/Jl0R7FcffPPw
         5tjroX5fX5kfByly36BGisckxYHLSeduu1mI/fea+030q+bFSS/t24UVXQ50tip7alfd
         3cRIh+vkiTa7mmUMn4SgLzqbCHYSod6+mXs6oRV6Pgc6qKhdWPTLpBnFnr3limN/e/ir
         GfssBc9J6XnwPCKy2eHKp+Z2VtWUCMW7oPibTwLYugN5zB2YrV1XNzCfx1VOylPUpZTA
         agAT/5UFGF8t79WdG08ZS7ZSsS7VpkaqY480fyo/6HD1cZ/8kBNNECmS1SuhaDjlL//q
         l8dw==
X-Gm-Message-State: APjAAAW5ZRphRBhr6uPEWSGgPc2wXBGDsJsUycmwNezbxbgxqtXdVKYT
        qgFTeTYt89y3cbiZS2biTHQ+qw==
X-Google-Smtp-Source: APXvYqxHSEM6/3lFEYqxhUekrHE3YNPxXnZ9VZ0cJhwbwsoVl4OAijtCWZlQsV3ZAsjKVyzA+4nEeQ==
X-Received: by 2002:a37:a00f:: with SMTP id j15mr6463666qke.335.1569028333903;
        Fri, 20 Sep 2019 18:12:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c185sm1888309qkg.74.2019.09.20.18.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 18:12:13 -0700 (PDT)
Date:   Fri, 20 Sep 2019 18:12:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Yotam Gigi <yotamg@mellanox.com>
Subject: Re: [PATCH net] net/sched: act_sample: don't push mac header on
 ip6gre ingress
Message-ID: <20190920181210.70d56137@cakuba.netronome.com>
In-Reply-To: <c359067b4a84342ff24c6a3d089171de68489fcd.1568709449.git.dcaratti@redhat.com>
References: <c359067b4a84342ff24c6a3d089171de68489fcd.1568709449.git.dcaratti@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Sep 2019 11:30:55 +0200, Davide Caratti wrote:
> current 'sample' action doesn't push the mac header of ingress packets if
> they are received by a layer 3 tunnel (like gre or sit); but it forgot to
> check for gre over ipv6, so the following script:
> 
>  # tc q a dev $d clsact
>  # tc f a dev $d ingress protocol ip flower ip_proto icmp action sample \
>  > group 100 rate 1  
>  # psample -v -g 100
> 
> dumps everything, including outer header and mac, when $d is a gre tunnel
> over ipv6. Fix this adding a missing label for ARPHRD_IP6GRE devices.
> 
> Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied, queued for stable, thank you!
