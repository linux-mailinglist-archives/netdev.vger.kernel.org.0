Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3C11C3D62
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 16:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgEDOmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 10:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgEDOl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 10:41:59 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBDEC061A0E;
        Mon,  4 May 2020 07:41:59 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s9so14118117qkm.6;
        Mon, 04 May 2020 07:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NkMwBJDlPtKc7IPtaLLfagBNdN2mLm8jarZATLwqSqY=;
        b=Ljj8M+WORWav2k2sUXlaUAeKZWZDqTp+V52Q36m4i+3HKTvzSXJ2Dq31yI7E4RHeud
         nJu48oOhxOfe7+yPqktvmqy/4o1fEY0JqgC7DPAXBCm4e9M5BFdwt4KokyS7FsPrUK3P
         g8whXBVIA5CP9DYuMuZsnj6hMKuor5uvhSCHrtOT8A0WfhW+OmT6M1uSg9h3nIJxjB07
         m3nZ7RV72sU+jqE+2r+QCQ17kQZXT58qxwvBkjUtee8r02PA2VKRppv6qF4qRWT9effV
         aA2CdEUlx2f+uBX9cA14hRlcYHlbuy6rChy6gnXT0AuBc7bX98oWuwL8xP2tW0hIzP5h
         zR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NkMwBJDlPtKc7IPtaLLfagBNdN2mLm8jarZATLwqSqY=;
        b=NikFe40TeOrEuu6WRW3Z7pliXRKhCKUDMYtrqCPljd3r+Qxh2Ge0OguzQUhRGLdLg3
         6ljx+huf1fQBOr2lZgZ2G5LnvjzCr3E2pdk1hljl/w3GufUsd9pca4h3tDlY1JuvV7+0
         IiVL6sUFCXo5o3Sf6f4EiQxAIDJ8vUKCKuGicQyUtUX4rjpn1qe/hIii7R7uBaStvo9x
         F9ZQCuNfXKKvsgGnUkuqFz470Ttdcp+7zs+mkzAQPOqMbtoy12tZo7POcKzGp2YL1rvi
         4ZR7axl9rSaajdLvVkkAqaMXoziI+ULQHUVkoUPuEFoYQLiZyI6hFnkWpOBrdM2CDt99
         oG3Q==
X-Gm-Message-State: AGi0PuaQgTstEW+r6kpSMQ9jB7U22Mw52T8SN2ERxSayftZLkjWu159e
        rx2cn3hxkU3EBaX77co49gY=
X-Google-Smtp-Source: APiQypJLgRH6Y6vgX00eIv9Dr6kc5DWBBuMG/UGteJMIC93I1rP9dCafaQGm9abFhky131DjbFEsbw==
X-Received: by 2002:a37:a753:: with SMTP id q80mr10125089qke.492.1588603318578;
        Mon, 04 May 2020 07:41:58 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4fe:5250:d314:f77b? ([2601:282:803:7700:4fe:5250:d314:f77b])
        by smtp.googlemail.com with ESMTPSA id d207sm6389442qkc.49.2020.05.04.07.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 07:41:57 -0700 (PDT)
Subject: Re: [PATCH V7 mlx5-next 00/16] Add support to get xmit slave
To:     Jarod Wilson <jarod@redhat.com>, Maor Gottlieb <maorg@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, jgg@mellanox.com,
        Doug Ledford <dledford@redhat.com>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, alexr@mellanox.com
References: <20200430185033.11476-1-maorg@mellanox.com>
 <CAKfmpSdchyUZT5S7k07tDzwraiePsgRBvGe=SaaHvvm83bbBhg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <27196f08-953a-4558-7c95-90fb13976c92@gmail.com>
Date:   Mon, 4 May 2020 08:41:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAKfmpSdchyUZT5S7k07tDzwraiePsgRBvGe=SaaHvvm83bbBhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/20 8:36 AM, Jarod Wilson wrote:
> At a glance, I'm not sure why all the "get the xmit slave" functions
> are being passed an skb. None of them should be manipulating the skb,
> that should all be done in the respective xmit functions after the
> slave has been returned.

a number of them select a slave based on hash of the packet data -- from
ethernet data only to L3+L4 hashing.
