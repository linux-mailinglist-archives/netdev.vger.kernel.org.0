Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70B31B8075
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 22:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgDXUXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 16:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDXUXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 16:23:51 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3135DC09B048
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 13:23:50 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id j4so11539949qkc.11
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 13:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=avZPr6eGfGDCct0YhMWe5ojXQpdCD9z2J8at2w55o+Y=;
        b=T0HKNRRu3ZqQYjmfj+tzkJMp0fn4wsOoQHptTKNODF6Xuk3DVf0zd8J1fqPhJ3xsQi
         jQANbYzKv5wacuhhHoeA1ei5GDH4LxY5N9zArFmiSGXytKZBtMZxQWQVY3csA/CmjpsY
         9gU5JbMX2aw8mw3jY1VaDAO7oF0AINhHqNonbf8i3yjFhpHDVs+UNtjj0Tf1/plVRM9T
         6oCFyRWRkzNMxjNPUe51SXhWO/sq/v109aMesiCwkyvlsmIa1rGlqy7A+96Xdr7DK7Sc
         qSvIoucO66PLxm6l/m4qUwjj5dYjfVfU7nBG8j3OYRYH4pzsEYSqoPR/066/1vBIUzKK
         VWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=avZPr6eGfGDCct0YhMWe5ojXQpdCD9z2J8at2w55o+Y=;
        b=rdxrFdLndbCWxHFdHdewQDFzbMwcRz4JvrVH9i+hyaDZW7I2sPagv1xXiGU73kpEQi
         SvDDqcL3ZWPfpud/UO1CtiqsLHscGAaTwQl6x98Y1JJKVNoxeREDiUfz8rX+v7ls4X7u
         NGT0XiCxSBsaS+FP7vO7QzU2qC9o1RHwP9OY7MRnO+sMLyx5iIcGexd56O+xWYdGQf3M
         k71/KjB14ooBFCP44zcKXtZs8cuS9oJmXUz7bBBUtoBcc52w9wSlkhTIaCXFz9TNY7j/
         VHN0+uFAbUiptDJQimjgGFnpkCu/SSKqR+/H/APwFfSw4+mq4t3Vy6g8g8u9BsppzjMX
         gc/w==
X-Gm-Message-State: AGi0PuYuXG2xuFtLi0/D8m3p8lkut25oK9mK4J6axrHKCzB8UR1Ia5l8
        oJiqyK8xGPoPyBP+uhgL/ZA=
X-Google-Smtp-Source: APiQypI+Su1flSMCT8xvsC35CXf6o+1kbL53uxQZGD+HMjiuGTnUF3OYaoOJfCxbRkuFvnSUgO0jYg==
X-Received: by 2002:a37:6697:: with SMTP id a145mr10922420qkc.479.1587759829290;
        Fri, 24 Apr 2020 13:23:49 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2064:c3f6:4748:be84? ([2601:282:803:7700:2064:c3f6:4748:be84])
        by smtp.googlemail.com with ESMTPSA id o94sm4664625qtd.34.2020.04.24.13.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 13:23:48 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 06/17] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200424021148.83015-1-dsahern@kernel.org>
 <20200424021148.83015-7-dsahern@kernel.org> <877dy55khl.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <867d5d17-753a-10f6-fba5-1c854b891b03@gmail.com>
Date:   Fri, 24 Apr 2020 14:23:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <877dy55khl.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/24/20 2:57 AM, Toke Høiland-Jørgensen wrote:
> 
> I think this will be a problem: Since we don't reject unknown netlink
> attributes, userspace can't know if xdp_egress is supported. So maybe

Well known problem with networking and one Johannes, myself and others
discussed and worked on a solution for -- add strict_start_type to new
attributes so going forward we can detect that support directly vs
indirectly (probing). For link attributes that opportunity was missed in
December when IFLA_PERM_ADDRESS was added.

> it's better to just re-use IFLA_XDP with a new flag, instead of using a
> separate attribute?

After considering how the code has evolved over past few months, I
reworked the uapi to be more consistent with existing XDP attach modes.
