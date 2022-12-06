Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF58A6449F8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 18:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbiLFRKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 12:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbiLFRKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 12:10:51 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D4023EA2
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 09:10:49 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id t17so7859343eju.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 09:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=79eHhskHd+VsDUIczdSDWgETp1hG7Qe3YReOkIvkprQ=;
        b=Ukx/l1OjBykX54vdFV6ixT74SBRPzeXY1qPLy3Z4rLDB68v+G0+MUVAJpCa3UlPhcG
         zQ6rbUfJKPlvqTWWN/3aIRr301vA2l/OEmv+XHUDaD5ncJZmiPaaG+oJ7uOu2h83X+/d
         RQx55cw/tS9BjjWemkwaGChRvj9/mrufnycCIDWKrlkH9BK22N33QvwFB5luPxvMRTtQ
         sTjhgnWe72t7h1W1goUBa3SDhA6ksrXg/kGl2DQH3HXPasXYQCmQx1rrt1oS1AR0TNJt
         qUy/b4ZbkQHm3bsIVd2+mxSSXpqi8o4CZ0zG0/ZjpMKmA8tVyuUoDlBT8A/fAW6Jx3FL
         i2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79eHhskHd+VsDUIczdSDWgETp1hG7Qe3YReOkIvkprQ=;
        b=50sxNLeCY/NqBpCj3uq9i8TC0qJYOUAWk9BKp/E8TCYGeK3MKU+eqycOgB9YRYSSyF
         UZdA7aHkGxmnFaMkSeJkfzux0SRAEtDW6oyh3Oi/Raxh3hJXyjXvrqKxC3fuyQfmaO5M
         fYQhi/aJ6zgolD2CsWa7n8gtFej7ucBTmfF3DuMUTUqB/6Oz2v/QSlywKETCVoCl7xBJ
         tdEhHCchCeg2upt8UTIEgs+QJxckVo8dBfxccaz9RusIA2gYh1jCVQuut1gPw1AAgr4Q
         nAJXGAVfWl9Nrk6nHMpWBJUmAbjwyB0bRT3Y0VjQtDCAe6ZN80274MWXY9Z39aqgHFP3
         OgYg==
X-Gm-Message-State: ANoB5pmhUIiYtwa2F1vHFc4W0zCRXWM44HWa203uWAGFefKPLZM1sdFH
        ki3Hsxb96LkdZyvUHWRkSsw=
X-Google-Smtp-Source: AA0mqf4zmvwqf+o3dtXeL2aOLESM8/cosu7A7Hs+sxCAKrNRvwznsy9myGrZYgYfi8XRPcL1XItziA==
X-Received: by 2002:a17:906:3a09:b0:78d:6655:d12e with SMTP id z9-20020a1709063a0900b0078d6655d12emr59636230eje.260.1670346647916;
        Tue, 06 Dec 2022 09:10:47 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id cb26-20020a0564020b7a00b0046ba536ce52sm1182366edb.95.2022.12.06.09.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:10:47 -0800 (PST)
Date:   Tue, 6 Dec 2022 19:10:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH] net: dsa: sja1105: fix memory leak in
 sja1105_setup_devlink_regions()
Message-ID: <20221206171045.ifukw6qdmszydlxh@skbuf>
References: <20221205012132.2110979-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205012132.2110979-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 09:21:32AM +0800, Zhengchao Shao wrote:
> When dsa_devlink_region_create failed in sja1105_setup_devlink_regions(), 
> priv->regions is not released.
> 
> Fixes: bf425b82059e ("net: dsa: sja1105: expose static config as devlink region")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
