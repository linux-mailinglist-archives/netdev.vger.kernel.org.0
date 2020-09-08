Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E770F261F5F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732657AbgIHUC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbgIHPek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:34:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D39BC08E835
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:35:55 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l4so15608391ilq.2
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lcFrF/zwCBq9tQZ4Zz+6ASxDWq9Ku8l7S3t4Q9Bn80Y=;
        b=GD8kH5PIB54YfN3PcEtB7rY8eFsn2gqKYujl5kmCn+mB5w9ZXxyTtm/jJW+qbWu5IZ
         k83XDwPTVw3JMd8n82HumRcvnxufj49Ius3HO8JyIY8Rd28O6meYvpNv/5Rl/Qz1o7+k
         tI37v0w0G9QoWBo5H27ndj+q7X0m3hcAzAqANV6/1wOAhxtxYbyDH5eLNcfnCESeQRcB
         CiHcG4/hK/qeBplk3iV8Xt4JBxH0u5hBmO43lgOQ+XiZtvwIVo11H1R3095olSBAqwDF
         3G6dE5Q/xLCz0ykeuJ5Mq9yqTonLP2tNqdPhVrMUxkRvsMsw5L1JIsJKx20WoU9at9zx
         2S6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lcFrF/zwCBq9tQZ4Zz+6ASxDWq9Ku8l7S3t4Q9Bn80Y=;
        b=GGsgMgDa9wBDGwPh4yE+jna4gDqfg2eP4v8rQ7QKTjlMH7h7SDWp5/iRSt7yq0RbPJ
         VmsIMb3OhCZV5fm0suz0rvw5BpfhiASSbMKRajPhUyDhULEnSQUL3mI4ql8tZpM77rXp
         pjViwjuJV62PVSBhDBe0e5d7wtnXTIsBcB9iqCZjElTYeqgYIIXCn/mRYkt1bUo5urbs
         kx6xO36cJA58ZJlh/kY2kDipwlkgibKbRkYU9ANRz0fIjXJcaw/j91UPqwt4b6p9FRaU
         Pz/GHf0D0AldKzO8oB5Rh5VkB1nijcjIKlQriIZDLwhivBQrj6pWomPwpbTdhzdMBsvC
         A30Q==
X-Gm-Message-State: AOAM531AnI8oNtwpM40+q9RCtVAQjv2gnQWPuNJCMC9RXWJxV61kZj8p
        Wxviw8aEEnFSpd6kbCaxs7KHIKb69cxOUw==
X-Google-Smtp-Source: ABdhPJzmTHHnPN4KlojdXcdFBkBukplq+HnK+MvPnWHILbp9l8dwwJZOFIqY0F6Nwz/qMWPPfEZS6Q==
X-Received: by 2002:a92:1944:: with SMTP id e4mr6856774ilm.229.1599575755221;
        Tue, 08 Sep 2020 07:35:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id 64sm10796666ilv.0.2020.09.08.07.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:35:54 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 04/22] selftests: fib_nexthops: Test cleanup
 of FDB entries following nexthop deletion
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-5-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ffcd9b2a-366a-d804-1ab6-281f883fe786@gmail.com>
Date:   Tue, 8 Sep 2020 08:35:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-5-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Commit c7cdbe2efc40 ("vxlan: support for nexthop notifiers") registered
> a listener in the VXLAN driver to the nexthop notification chain. Its
> purpose is to cleanup FDB entries that use a nexthop that is being
> deleted.
> 
> Test that such FDB entries are removed when the nexthop group that they
> use is deleted. Test that entries are not deleted when a single nexthop
> in the group is deleted.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


