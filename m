Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573535817F9
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 18:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiGZQz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 12:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGZQz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 12:55:26 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0885595B6
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:55:25 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id va17so27318859ejb.0
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nFY1eChyGTvkBEHNrqOb+S8zqJz1mUEgNkA/2C+EAXI=;
        b=TzOcJminSv1Bl/Fxdg2f6B3qzxrhno0q7Jxk4EpMjdEYbngbuZsa1fcgS3gwfAlrVs
         /mCnpieNG4WvMvuTCYLGQdsqFo6TkSmNt+m/lvMBKwbnGULknZkG3GAVkmvOb/qjjcPg
         rIzd0Vf1WiM4T+pWcKl1lOY2xePsm9HAzQ0cJgwQZAizBwBuG7bQ8Urj3YiUBmiwo8Ds
         LHZoqLaVVtqGzrkDtRyDo2l0Ozq8iuUCDGkpVNy+iaSHhH0CYY+jxTXlqkEZokR9dN/h
         UY0WNA1eHV0Ep3fq/cnNWPZpa3hStwwmisNG7StiwH37rHdCN+zKcY9QpzCdz/zn04ld
         aYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nFY1eChyGTvkBEHNrqOb+S8zqJz1mUEgNkA/2C+EAXI=;
        b=bNqaX5nViPPoPMnw8BIzhb39fSvaYR5q9v3pefZcvRrCErsdrpob9jSZKIYt4Ox3zA
         lfpTtiJQp1KZggg+gX8XdikGzEUZqrAe3Yc8IwdqrazQ6I3l6HxabS6Jv66I30Iw3f0P
         qps+eP2FPF4li1C7PEoBQZ2QNeNE/Iab76oEj0ourySwRSeKLmTPshpeG/GqRwR/wll/
         GSgY1oquG2AcYec5dCxT5Gh/4cVqHTKzSyIMnqiRcz+qn9WBX5mUPyFzqVG+WT317cl4
         pZEBZX3li0W1kuGsBDR3SgwRNpkoZrzjmuI8crlil3iPrB8DWjcsEfB/iky99B3shX/r
         9d1g==
X-Gm-Message-State: AJIora8jdpgWvbggxMt5FARaPKJzcRe6t6URfuF2uWi1CgnZF4NWxqaM
        fgzXbQhuRbIES5LDPTbuhYU=
X-Google-Smtp-Source: AGRyM1ucqx/ZwNGsWxvl2QdEfltqCfX7SeyBpMN9M7ymQWAw6GlGaBS0bvwITsVu60XhPX3TJmczaQ==
X-Received: by 2002:a17:907:94ca:b0:72b:8f3e:3be0 with SMTP id dn10-20020a17090794ca00b0072b8f3e3be0mr14833987ejc.462.1658854523088;
        Tue, 26 Jul 2022 09:55:23 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id kv11-20020a17090778cb00b0072eddc468absm6666480ejc.134.2022.07.26.09.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 09:55:22 -0700 (PDT)
Date:   Tue, 26 Jul 2022 19:55:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [patch net-next RFC] net: dsa: move port_setup/teardown to be
 called outside devlink port registered area
Message-ID: <20220726165520.due75djbddyz4uc4@skbuf>
References: <20220726124105.495652-1-jiri@resnulli.us>
 <20220726134309.qiloewsgtkojf6yq@skbuf>
 <20220726124105.495652-1-jiri@resnulli.us>
 <20220726134309.qiloewsgtkojf6yq@skbuf>
 <Yt/+GKVZi+WtAftm@nanopsycho>
 <Yt/+GKVZi+WtAftm@nanopsycho>
 <20220726152059.bls6gn7ludfutamy@skbuf>
 <YuAPBwaOjjQBTc6V@nanopsycho>
 <YuASl48SzUq/IOrR@nanopsycho>
 <YuASl48SzUq/IOrR@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuASl48SzUq/IOrR@nanopsycho>
 <YuASl48SzUq/IOrR@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 06:13:11PM +0200, Jiri Pirko wrote:
> Here it is:

Thanks, this one does apply.

We have the same problem, except now it's with port->region_list
(region_create does list_add_tail, port_register does INIT_LIST_HEAD).

I don't think you need to see this anymore, but anyway, here it is.

[    4.949727] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
[    5.020395] CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.19.0-rc7-07010-ga9b9500ffaac-dirty #3397
[    5.047447] pc : devlink_port_region_create+0x6c/0x150
[    5.052587] lr : dsa_devlink_port_region_create+0x64/0x90
[    5.057983] sp : ffff80000c17b8b0
[    5.132669] Call trace:
[    5.135109]  devlink_port_region_create+0x6c/0x150
[    5.139899]  dsa_devlink_port_region_create+0x64/0x90
[    5.144946]  mv88e6xxx_setup_devlink_regions_port+0x30/0x60
[    5.150520]  mv88e6xxx_port_setup+0x10/0x20
[    5.154700]  dsa_port_devlink_setup+0x60/0x150
[    5.159141]  dsa_register_switch+0x938/0x119c
[    5.163496]  mv88e6xxx_probe+0x714/0x770
[    5.167416]  mdio_probe+0x34/0x70
