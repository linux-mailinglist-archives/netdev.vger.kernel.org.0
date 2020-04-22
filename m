Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A211B4561
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgDVMuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgDVMuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 08:50:16 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC472C03C1A8
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 05:50:15 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t14so2216818wrw.12
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 05:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sYKwJ7+IoprBPdU6iUBgXZMoI3xaAISOSE08tbY6BWI=;
        b=xuKO93oVyfEFk12aVmBbHSbioP6bw5QVoGPmsMMRSKfvkvhSY0N3fMjgfnJwQadOqi
         ovsQp92qkU3saQ/T+uXRFfDs08EYeCYw4Zt8t39uNwiJKBbjOiSE3Sp520BLvbA49sAn
         oV6AICnvsYTpmThg+bCutTVw2MP7aD87dUZqN5d7arDTmaQtRlm3bhRpEB74nn2nU/ed
         1hSIF+Pmvns9oWcPJm10fKXhUOMeEdWZeq6g910HwTrE0B0eAwA/MnXtntwFVSjTiWoP
         3cBr3wHJy1fd+CR6A01NltfT5bmbmkwVS01IgOw/cPPOJKm92skkym+yMahLj7bP1nDv
         mOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sYKwJ7+IoprBPdU6iUBgXZMoI3xaAISOSE08tbY6BWI=;
        b=EfqVbhLixS7AArV/kiMKVIpP0R5lFJhembobg+wK0Qr3sBHh0ZuzYQ9IxSFxLebXIN
         g7UwlgkmQ6cPcUz01j1NCYZmHY00JYQe4CkAIfZ3R+T8BqvG21pPy+saMpKFkkBWv63q
         dp2f8C8+bM3rH4ct4FSvD0A1msZTUukk4taFob2ot5mZZ0ugY2W6w2FbJYq4aq7CTDLM
         MtrZEaszDU8NrMzR53SCFxas/7SKC6E4IJwn6JUqhMl/nRk3Z6DZKLbjyBlsN9zWhnxn
         8LFkEI0KWldqrEvU+xaeAotOVEPg7JCfyIO5rIICGnd80J8nB4aLWi2M9CXG8lxAKu+z
         hH2Q==
X-Gm-Message-State: AGi0PuYOzrqUuyyvQtULpQ9UdB0df6/3RVgIvNiMJIj/LapTvQF8FmGI
        tC3ergCQ3kJe5OZCHOqO1gyoSw==
X-Google-Smtp-Source: APiQypIsQIVN9ZkfL9Bjg9ZIvKF/a0D36oFt4ABQ8hE82QXsIWaXfczCNACt3niNZ4KMhflFERfniw==
X-Received: by 2002:adf:e791:: with SMTP id n17mr31600594wrm.217.1587559814607;
        Wed, 22 Apr 2020 05:50:14 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v19sm8356168wra.57.2020.04.22.05.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 05:50:14 -0700 (PDT)
Date:   Wed, 22 Apr 2020 14:50:13 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V4 mlx5-next 01/15] net/core: Introduce
 netdev_get_xmit_slave
Message-ID: <20200422125013.GL6581@nanopsycho.orion>
References: <20200422083951.17424-1-maorg@mellanox.com>
 <20200422083951.17424-2-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422083951.17424-2-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 22, 2020 at 10:39:37AM CEST, maorg@mellanox.com wrote:
>Add new ndo to get the xmit slave of master device.
>Caller should call dev_put() when it no longer works with
>slave netdevice.
>User can ask to get the xmit slave assume all the slaves can
>transmit by set all_slaves arg to true.
>
>Signed-off-by: Maor Gottlieb <maorg@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
