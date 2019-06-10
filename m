Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F513BEFA
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389168AbfFJV4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:56:04 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:38178 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389047AbfFJV4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:56:03 -0400
Received: by mail-pg1-f172.google.com with SMTP id v11so5723199pgl.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j3QBGZAX00q+IDbFvup8N2WsU8DhDhF6bBmHfzNVin8=;
        b=JlMoaqSXG2Pa7P4Jp/yipq6bfafOTKUhV0bSy1zHpZJfkE94j+uut4y3JQEF+Vv5Gb
         umI7rsij/Y4tzFZZtEJuB1aadKajk+EJ32GDeXTzITRKDT7RkKF19AGPuIR83yvtqm6v
         wbZEmvqKISqd3WbI5KTNFXA7vlFr1NXYDXU+pOSGh0PBUPMR4lIPFqG/Mo1vjdIdk/z0
         TMjgUz72no1hjLQYRCoyC5qZAgOEA+tg8Xmp+mX5ygT71Oho24ysHi7WuHjLTGEsvuwy
         ZXPh1B5q/vQKEEQ6dlwQa3KAfGM+vdwLoZUIVnyJn0lj4WktCmkL0B5+9uLjy078w1Mc
         WaCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j3QBGZAX00q+IDbFvup8N2WsU8DhDhF6bBmHfzNVin8=;
        b=imwN7BhVY9U7OJu38fHRX2fUUvh0I/6j+Hgh0YHyN4V1JnFE7Apg3DhorNf26rQinm
         DXPbLvWfXfg2BVtNFFTJfnL0NUqsZJTmzgnmUzxtZjy/FoA5KtIvmk6c8to1dUTGzGQ5
         Piu1FO76jXYtPk2nTHGCKYjeAYBY1voXDPISvz1oS9rIdLamb3/PS/cw7ucImXYgn692
         PQJCGaQh4MpeHkuGEf2aYR6q6J9/abmDa3r0/eihlCcV1fMD6BtwV906L5g1g/EaAb+o
         KiMk5WFzDzGehjHNtCDwCkVlS/gfxVw/IER+zYu13pZbHaG2Pox5o3N1ufzKehWW94oN
         Phgw==
X-Gm-Message-State: APjAAAV4lG4I1V0jR86ClkKOpFnPq6c67DelOdPK+QlYpyr3T2J2OCN/
        imILhnB4lfjHbDlUJzfGwAA=
X-Google-Smtp-Source: APXvYqwMGc6Ai6AxwFOPsEebAVhkC9aTaXP4ktWJI/xKafAymbaajY25k8R0lfOZ/s76W70CzApuLQ==
X-Received: by 2002:a17:90a:cd03:: with SMTP id d3mr22408317pju.127.1560203762999;
        Mon, 10 Jun 2019 14:56:02 -0700 (PDT)
Received: from [172.27.227.182] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id j23sm12887267pgb.63.2019.06.10.14.56.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 14:56:02 -0700 (PDT)
Subject: Re: [patch net-next v3 3/3] devlink: implement flash status
 monitoring
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org, f.fainelli@gmail.com
References: <20190604134044.2613-1-jiri@resnulli.us>
 <20190604134450.2839-3-jiri@resnulli.us>
 <08f73e0f-918b-4750-366b-47d7e5ab4422@gmail.com>
 <20190610102438.69880dcd@cakuba.netronome.com>
 <249eca9b-e62a-df02-7593-4492daf39183@gmail.com>
 <20190610104723.66e78254@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e82080ee-9098-01c5-1108-294c32f53f33@gmail.com>
Date:   Mon, 10 Jun 2019 15:56:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190610104723.66e78254@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/19 11:47 AM, Jakub Kicinski wrote:
> It's the kernel that does this, the request_firmware() API.  It's
> documented in both devlink's and ethtool's API.  I was initially
> intending to use the file request API directly in devlink, but because
> of the requirement to keep compatibility with ethtool that was a no go.
> 
> FWIW you can load from any directory, just prefix the file name
> with ../../ to get out of /lib/firmware.
> 
> I guess we could add some logic into devlink user space to detect that
> user does not know about this quirk and fix up the path for them.. 🤔

If the user can not load a file based on an arbitrary path, what is the
point of the option in the devlink command? You might as well just have
the driver use the firmware interface.
