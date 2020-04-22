Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B831B4574
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgDVMxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726935AbgDVMxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 08:53:18 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987AAC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 05:53:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id d15so652736wrx.3
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 05:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w/PWZJXJZgDfz4iNWB2KZp9I640+mPU8cwPuzIWsiRs=;
        b=sOMfmtdt+hzknrF9ZQrPXV4unWrYzqXOrXLo8M7Punqbe1fQQb9uwd0BidK1aAGOkP
         /gpzRcQ34v8KrGV372DX3e6NNLX7poZmh2J0BGaGmMWhSrLlXZh3V/NY0mj00XIvE74B
         kWSZsvh1zarAuPCI6kBpnCus1znWoV1cnnPWas+ElNs+Gkld00r1gg/tNR7zPX/mfu8Q
         vo2VwwvKPg5L27JiSw7CYTtXirAogdMnrpQ02uDpnoX+5NAdH9svEJDr6DEOYnXcyudb
         UMCyD0HzIIX/BEEZiTykGKWU3VbHZkYVzB4PSh2aKGXMcwXZfsSioabGq26KhaLO5b7v
         MLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w/PWZJXJZgDfz4iNWB2KZp9I640+mPU8cwPuzIWsiRs=;
        b=r9a0nBKm2JFzBYn30mJjPmi4/skI92l78NT3iqsmjt2Qaxwfu6sIYmb3SDj9tVJ/PG
         yJ2r5UEN2YtZ8W4EoRA4vjxvpmekHGqFhOkl7MF6lpMHZikRHHfa+GOzOyTZqsBSWLdm
         HxtO0lXUAjG8kTJDcsWYTBavFefG8MonKqt0a7KES4MP0vRMYuOonctVEABHkezEhrca
         50rJgh3Uqt4o5IWjiwcuCnmGEOjduRd5KIaS46EiYWuHTNKaLVXs8/dUWF0uCx8CfMkd
         eC1ZtelNBFVRKoC3njL+CzDaL/sYNC2nIYE5sQeaq7GAK+jglxBRpfnYpcAvAXC6P7kD
         E/Bw==
X-Gm-Message-State: AGi0PuaraLOmminV2HUjYPFW3tni9Aj35QCjJZ32gf+Qh2FOuGIVlv1a
        qmZGMkYekGyoMPoGs3gW6UK9pQ==
X-Google-Smtp-Source: APiQypI2/8C8w3ol0j/2F6Av2XjVlwCuvopgb7m3X+OXcChNXRqrGRxGwWu0Zls9UboSkpINpyHgAQ==
X-Received: by 2002:a5d:4702:: with SMTP id y2mr26969333wrq.15.1587559996366;
        Wed, 22 Apr 2020 05:53:16 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id j17sm8659343wrb.46.2020.04.22.05.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 05:53:15 -0700 (PDT)
Date:   Wed, 22 Apr 2020 14:53:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V4 mlx5-next mlx5-next 09/15] bonding: Implement
 ndo_get_xmit_slave
Message-ID: <20200422125315.GM6581@nanopsycho.orion>
References: <20200422083951.17424-1-maorg@mellanox.com>
 <20200422083951.17424-10-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422083951.17424-10-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 22, 2020 at 10:39:45AM CEST, maorg@mellanox.com wrote:
>Add implementation of ndo_get_xmit_slave. The .ndo call to the helper
>function according to the bond mode and return the xmit slave. If the

Sorry, but this sentence does not make sense.
"The .ndo call to the helper function according to the bond mode"


>caller set all_slaves to true, then we search for the slave assume all

Who's "we"?



>slaves are available to transmit.
>
