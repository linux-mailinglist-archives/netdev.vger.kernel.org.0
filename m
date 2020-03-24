Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B7190A15
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCXKBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:01:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41831 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgCXKBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:01:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id h9so20601236wrc.8
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 03:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YXwXXyf4FFoH6g7bKxTH+XMwT8dvCco8fnyGy8BbH0U=;
        b=QDAlHA9bG8dxJapJMUVdl7SSfzjRwftlM0jT/kCptr/tZzU0kY2soxUAM3ezP1rj/K
         NLWi5HDGR2pSC0+mTbUvx3FNzvBl6v4EJo03KBnlB1svpO4emsIa8635EHUgU9/1iOGe
         Po5VJK/wDQ/keZp1zbUujB4U5LdA/uzELiJlako/i0PxNdyYZU7HFbGz/7woBdChgpWh
         wKHuLwTYxPKxdy76wZie4l6JXj1pfcUCW1iXMfAhrl/kNTsXubyLICwVmXHTouEsreeJ
         sVYV5p6rX6yW2GfD+w+zg7pwq8J3EqXT2rRKwfkk8HORngkZ8bW6OVP8FXTLoUHE2wLF
         X8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YXwXXyf4FFoH6g7bKxTH+XMwT8dvCco8fnyGy8BbH0U=;
        b=IH69hu0PCXOBrG3AiuQWr9/hAsEkw0+AtN1mgKeJKoxgP7KoStD6bwytpkZe8B6/8M
         mFyv8NwcEphX0ndNFQYlwW6+CqupUTwHLIA3utCTEyv1HexEfaq68acEb2Kl7Q6Y7B7g
         kxLhbUzTyciYN5Q1oLxiBA4KMYCStmkbYs3H7ye2Ib+HqmiohleqF5xOtNVY7w2z67dt
         YACOcWN+cDky9RACytwPMnm8K58ye1o5PJUa+CybZYxDdMgsaWUb5ZVMcd2M/09nxN44
         6Re70PDNovymnIjePL6q2H8AfSlL0alYQIxucyXLQ2RP4CJaaCWWiE3evVzmlgQ5QWnb
         lPLg==
X-Gm-Message-State: ANhLgQ3NiliVnF0WPPGnFqmpgxyo8w6b3fP45z16xtj22In4DrikirVL
        NEYaChy9D0sAjygbcRu2DKRu4w==
X-Google-Smtp-Source: ADFU+vs+oZMrTA+XjIVihEjmm3kkuM0VpBBT6FouF1t7AnwQf9AWhrAkOA5fgdwclkEuWXDSzOly8A==
X-Received: by 2002:adf:9dc6:: with SMTP id q6mr34986704wre.70.1585044109070;
        Tue, 24 Mar 2020 03:01:49 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t81sm3607126wmb.15.2020.03.24.03.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 03:01:47 -0700 (PDT)
Date:   Tue, 24 Mar 2020 11:01:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Po Liu <Po.Liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        roy.zang@nxp.com, mingkai.hu@nxp.com, jerry.huang@nxp.com,
        leoyang.li@nxp.com, michael.chan@broadcom.com, vishal@chelsio.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        pablo@netfilter.org, moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org
Subject: Re: [v1,net-next  1/5] net: qos offload add flow status with dropped
 count
Message-ID: <20200324100146.GR11304@nanopsycho.orion>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
 <20200324034745.30979-1-Po.Liu@nxp.com>
 <20200324034745.30979-2-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324034745.30979-2-Po.Liu@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 24, 2020 at 04:47:39AM CET, Po.Liu@nxp.com wrote:
>Add the hardware tc flower offloading with dropped frame counter for
>status update. action ops->stats_update only loaded by the
>tcf_exts_stats_update() and tcf_exts_stats_update() only loaded by
>matchall and tc flower hardware filter. But the stats_update only set
>the dropped count as default false in the ops->stats_update. This
>patch add the dropped counter to action stats update. Its dropped counter
>update by the hardware offloading driver.
>This is changed by replacing the drop flag with dropped frame counter.

I just read this paragraph 3 times, I'm unable to decypher :(



>
>Driver side should update how many "packets" it filtered and how many
>"dropped" in those "packets".
>

[...]


> 	return action;
> }
> 
>-static void tcf_gact_stats_update(struct tc_action *a, u64 bytes, u32 packets,
>-				  u64 lastuse, bool hw)
>+static void tcf_gact_stats_update(struct tc_action *a, u64 bytes, u64 packets,
>+				  u64 lastuse, u64 dropped, bool hw)
> {
> 	struct tcf_gact *gact = to_gact(a);
> 	int action = READ_ONCE(gact->tcf_action);
> 	struct tcf_t *tm = &gact->tcf_tm;
> 
>-	tcf_action_update_stats(a, bytes, packets, action == TC_ACT_SHOT, hw);
>+	tcf_action_update_stats(a, bytes, packets,
>+				(action == TC_ACT_SHOT) ? packets : 0, hw);

Avoid ()s here.


> 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
> }
> 
