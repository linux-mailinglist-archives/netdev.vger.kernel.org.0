Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B201B1522
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgDTSsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgDTSsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:48:14 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80902C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:48:14 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id d17so13465092wrg.11
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2cSdc7HOKNn19uIovkBV2qQLh5+gmDP21h5U9G3vQpg=;
        b=AWt7dvWRP+vAoE+odGSw7XNnLZObieoTenf9eCtsh7RVN/TGFvcAACtffqBThNrcS3
         zlsMF/jJreikztfpiqVKzjgSIFM4qjed8tvPnuxNNDLP15XzxLkr0h/PGgSII0P0sAqF
         lmVeVm3FrGFdKB9eeAyOzIeGYwO8v/NwLvBei3p0LWS3CINC+60AS1V5JXMUEs5ANHZI
         QKB+6lyaSIJTmKFQSohenGvdTEm+yBs4CtxG6NyqvCiCKgj0F9C+aT26ElLTWuwdi0m9
         rFDTH48y22+S/y70iDfaE+cpCiet5XiTzu+otbKEcVlIXWzbkw32YpaEkctMGDMAZGp8
         ym3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2cSdc7HOKNn19uIovkBV2qQLh5+gmDP21h5U9G3vQpg=;
        b=dAIZQ0wTYXkWUrrA169WwcIElpShz8UwihNF7ZsVSgLauD4WYealdoSruAQX54yi/r
         YU9iYQdl6fUcfBidempS0U8+aQ82IxfskBGJtgP5H1g8RoskpIskMgZjV5YLYqOWsEpa
         MdyEu61o2jDmL5QG2AanE5xyzgak7rZnU4Tyi+tCFWHx4xKW7+T8YFrlVcQbeCVGMuM9
         40W7wgqBhJz3x+B4fWYPhPyWzKLEbFnwSwNtSppgovPpY27K74folEGTcsrb6R2MHZT5
         gq3XuYujD9BDTp4C2+7jGBc9p0hHHsG4jf0OjAM4+a39grdj0w/v+DHUymTtmQusCf/K
         ztaQ==
X-Gm-Message-State: AGi0PuYGmyfa7M3em08MkttFFSrnzIhAlUL+XlvvKdjxKn5q1lYPMZ9N
        cxo5PHM/LVdtqHXaztaOowJXzA==
X-Google-Smtp-Source: APiQypJTmGD6w4kcJc/Jb8LZ9aIRN3E+NN52Jim9VsAd/ZOeMB8QLIvIrgK3iYSjr2bKc6PscVe0HQ==
X-Received: by 2002:a5d:610e:: with SMTP id v14mr19672293wrt.159.1587408493333;
        Mon, 20 Apr 2020 11:48:13 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y63sm386040wmg.21.2020.04.20.11.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 11:48:12 -0700 (PDT)
Date:   Mon, 20 Apr 2020 20:48:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
Message-ID: <20200420184811.GW6581@nanopsycho.orion>
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
 <20200420175421.GU6581@nanopsycho.orion>
 <916ab047-3b50-7104-311a-6dcf604bcf6d@gmail.com>
 <20200420180144.GV6581@nanopsycho.orion>
 <75dffa6a-c14f-45c9-44e1-bf5b5c650a9b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75dffa6a-c14f-45c9-44e1-bf5b5c650a9b@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 08:04:01PM CEST, dsahern@gmail.com wrote:
>On 4/20/20 12:01 PM, Jiri Pirko wrote:
>> Generic ndo with lag-specific arg? Odd. Plus, there is a small chance
>> this is ever going to be used for other master. And if so, could be very
>> easily renamed then...
>
>core code should be generic, not specific and renamed at a later date
>when a second use case arises.

Yeah, I guess we just have to agree to disagree :)

