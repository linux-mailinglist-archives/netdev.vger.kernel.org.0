Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FFA66D3A7
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 01:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbjAQAee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 19:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbjAQAeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 19:34:31 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EB52A165;
        Mon, 16 Jan 2023 16:34:30 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id tz11so7286893ejc.0;
        Mon, 16 Jan 2023 16:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vq93ogCrPOGg0HiQewh9SHWJXLDhF+axB/rCaxgDnc0=;
        b=mk0bWkVIwtDNQjJ1m8JmAs1cQvTDNp7m7zHGOU/RdKRLAFPO74DcIaMsyckIPCbPsi
         YRoc9uvDmg66mdgsHAmS1ibYPvSPdk0OhPo6gPg+EL9me/19mnoBDeZiJN2wU1kcXWTc
         jRoh9n60IHSXjtPAQXPAKWHwmV4EjrrWUvNDd0NNpC+YvnsODblPMAHMJh3upYIWe2sM
         s2NacqKxId08HILfa90GkAjw/LDNo461ktbkFinh/5Bn4eLcrVE0jpx5dwyC37GzPlZ7
         HyboYBd99FiJMnJepqT7n0MzrLidIn/ppB2nVihafJvcM1lP1Lbz9iEh0HAT/+IoWPV6
         kCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vq93ogCrPOGg0HiQewh9SHWJXLDhF+axB/rCaxgDnc0=;
        b=l/xVruc9B62yoo6IIa05wi3DwoUh66wj41zvo3W7ON7wKdtlumsTcrNYvxgiQXGMGO
         rDRPML3OAaMcexHzh1uEOaxztfQ+y26LTlqrwxHX+mj+r6EQ2yA3ZDTo3KPzgnSUo1vs
         MwwZADzjpauX25dQoW2NGUHMYEroNFSN03nx7Jh8aqX+QuKQQG0dCD+T3HR95j5dwteG
         1SE9hsj/5B7mCca2IvulxQWvrqLh58xQukL0RWhJ/GC+GpV4dafSi+bI7kKSxdprg8H/
         Qf9B4C9fKfU5x44cORCyp9eN/LxUUjDhtAc+2asll3c3Ovt8rzQz8+HD80BB1Q5PyCec
         vVwQ==
X-Gm-Message-State: AFqh2kph0F1rdXDW0vqhQbKbxYWYQxgqgUaNURrFO4Ec+XoukaLTWe3l
        fcqcZe4WhS5u4YF9UU62jNY=
X-Google-Smtp-Source: AMrXdXvVncIK5Ul92PycuucsYrx7tsk0JFtqTS6tvKh9Vo6nBNYscTyOLvBzoUJbScESalt0tzQG5g==
X-Received: by 2002:a17:907:a609:b0:7c1:22a6:818f with SMTP id vt9-20020a170907a60900b007c122a6818fmr16709350ejc.25.1673915669328;
        Mon, 16 Jan 2023 16:34:29 -0800 (PST)
Received: from skbuf ([188.27.185.68])
        by smtp.gmail.com with ESMTPSA id j2-20020aa7de82000000b004972644b19fsm11818990edv.16.2023.01.16.16.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 16:34:28 -0800 (PST)
Date:   Tue, 17 Jan 2023 02:34:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: Re: [PATCH net-next 1/1] ethtool/plca: fix potential NULL pointer
 access
Message-ID: <20230117003426.pzioywqybaxq4pzm@skbuf>
References: <6bb97c2304d9ab499c2831855f6bf3f6ee2b8676.1673913385.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bb97c2304d9ab499c2831855f6bf3f6ee2b8676.1673913385.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 12:57:19AM +0100, Piergiorgio Beruto wrote:
> Fix problem found by syzbot dereferencing a device pointer.
> 
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> Reported-by: syzbot+8cf35743af243e5f417e@syzkaller.appspotmail.com
> Fixes: 8580e16c28f3 ("net/ethtool: add netlink interface for the PLCA RS")
> ---
>  net/ethtool/plca.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
> index be7404dc9ef2..bc3d31f99998 100644
> --- a/net/ethtool/plca.c
> +++ b/net/ethtool/plca.c
> @@ -155,6 +155,8 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
>  		return ret;
>  
>  	dev = req_info.dev;
> +	if(!dev)
> +		return -ENODEV;

Shouldn't be necessary. The fact that you pass "true" to the
"require_dev" argument of ethnl_parse_header_dev_get() takes care
specifically of that.

Looking at that syzbot report, it looks like you solved it with commit
28dbf774bc87 ("plca.c: fix obvious mistake in checking retval"). Or was
that not the only issue?

>  
>  	rtnl_lock();
>  
> -- 
> 2.37.4
> 
