Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5DA1B13D7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgDTSEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgDTSEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:04:05 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01855C061A0C;
        Mon, 20 Apr 2020 11:04:05 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id v18so5167476qvx.9;
        Mon, 20 Apr 2020 11:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j7VMRRnIFphfNvwdtJMnIhsBjuoy3IM/VJBbuzmtjMg=;
        b=RQq5vBOW8VHpe3Ic9+X56ZV5SBMFvMB6J8oGHfTpIhjjZF+sZJNlOy0JWI28t4KGTV
         2t98OVWvIOGp4fzCogz9WRMZrKJSd3vc83YP0QQ17Ryk1zJmNRZWZ0uF/FUNfSq627nW
         hsGOauMO3QxP6iHl1ozvGz/4zXFrtMRC93iaL6Eq0sxDFAEuClEQv49GBXbhThB3TW8W
         4KO0SUM6mqvTA+zaJ6/qz3fHn3xDu653MtHU5h6edaVJtZUp7DRRpzLzDxZI1ggYIJzV
         VhCV2OEGMBxrEYBUv1053UVyt5NFjExSoVKUIrSdcYegfoU2007heDcJlNr+/W026+NR
         /K/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j7VMRRnIFphfNvwdtJMnIhsBjuoy3IM/VJBbuzmtjMg=;
        b=qy0J9+4+xZShkI7bcsfpEJ2q3okocvpRCWRg27rmevaAtdNbmbP2H41aBJXqTlzBX0
         b3HMN74KohZFue7HHCmAroLCkDW2AgtD1OmzT3k9rr1iN6M79nGRAshsfo0a1dPDUsJz
         jz/L8sB06CzAsUky0fTn7gIm/b/1FuRjcBhx6qXuTHaSIg++qYKKduujESKQhLNw/tLS
         1SBILSNowNL8QQHtd+nN+Up4xPYXySgGFS6yfNzrDUFzQexaVrx7Oa1bnii9EvSi1rKz
         tzGGYknt6p7ZR9mbFkFy6MHz81fd1tZ5/n4syIEybmwCAnb8s8ce9Xa2pLUrl1QLtU8P
         /WrA==
X-Gm-Message-State: AGi0PuZypfTCH7WAQ2vthtzCiATnIpY3KpuOIAKaob/BVyYhvY4voyL1
        ipB1toMkWR/7UgfGfF8i40U=
X-Google-Smtp-Source: APiQypLQEKkUmk5+h6KzhdqgV+Pvr0BSUTt5hBpnQDcm0loCl5nzLnEuJSoWIYr/DLuNnMBoo9h0Xg==
X-Received: by 2002:a0c:b661:: with SMTP id q33mr15942400qvf.190.1587405844246;
        Mon, 20 Apr 2020 11:04:04 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:294e:2b15:7b00:d585? ([2601:282:803:7700:294e:2b15:7b00:d585])
        by smtp.googlemail.com with ESMTPSA id y188sm189254qkd.35.2020.04.20.11.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 11:04:03 -0700 (PDT)
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
 <20200420175421.GU6581@nanopsycho.orion>
 <916ab047-3b50-7104-311a-6dcf604bcf6d@gmail.com>
 <20200420180144.GV6581@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <75dffa6a-c14f-45c9-44e1-bf5b5c650a9b@gmail.com>
Date:   Mon, 20 Apr 2020 12:04:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420180144.GV6581@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/20 12:01 PM, Jiri Pirko wrote:
> Generic ndo with lag-specific arg? Odd. Plus, there is a small chance
> this is ever going to be used for other master. And if so, could be very
> easily renamed then...

core code should be generic, not specific and renamed at a later date
when a second use case arises.
