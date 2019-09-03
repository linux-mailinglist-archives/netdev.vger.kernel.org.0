Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2CA5F44
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 04:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfICCSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 22:18:24 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45210 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfICCSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 22:18:23 -0400
Received: by mail-io1-f68.google.com with SMTP id f12so14934594iog.12
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 19:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LUCBFfHD2i11G1b0kiR/J+U7LRZv5PnVhdBo/gSxhoo=;
        b=E8bo6wxsp5qtTMB4F1ir9Xq35sBwBgQGX92CvLagAFkrt36v/6/VXF+aD0X6w+U3WQ
         oEBFNn7ei7Oi6ynaUmYAQzDECNzqZ0YHjdt/7Yx/z/orOD7j/khFZz6NALOGXqXSX6i1
         dv9YJsAsSBMRPCqRufMvoIJVr4ERfS2TbY6WmIiAw6wtwk3R/T8+aCbBSltVBIYVvW8X
         6g27lRnmBmP1kiYnGdztz1OCz2Hjc/ikssbr3gY94NoYF5d6c9JCJIPSjKPH6zM7Jnb5
         9vYTWVCtXRsRfo6E+OZd/e6LygtVLKmhr15YP1tOwbbHXvJnW8CCSdydC1Rz2rRIW1N9
         y3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LUCBFfHD2i11G1b0kiR/J+U7LRZv5PnVhdBo/gSxhoo=;
        b=hwnmEka10FjsqEMHtHVtV5DUXKnQNhuYt5sUnuH3WxRYKrtU8A1fa6396FnXUsKHzW
         tmYZOUUQRR/owT5Ngup4Ys2DYC1nQbBc3/vMJXuZQaO7XhpvnpMt+gQdYM3sgYAtCC4m
         7XW4TpjnZuTv9UI41RuxJg4o4/2CIV1a/bhUU24Ry0h4gYOWFF/NQh+VT3S7UG4ZAEkf
         gh6i+1CHevZrWxkn0fBZaYZeas1XU50sh4o4QcCrZJwI4Jk13Z8a4XJPvjKtkEipHq9G
         bZd+mJez9YjmJcYdd6Kq1RVcglXD3w9KRgr/w22/pwh+fqvi2snMkB78UoS9+ZgsVDLv
         6Mrw==
X-Gm-Message-State: APjAAAWn4qB4Xvpp86jHJLtuMlXryz71uxinQAFU8p3axItG8pC9oBD3
        IBOmmEIVxMab+nGZxwT7rp8pWpvX
X-Google-Smtp-Source: APXvYqzl4Hhi5TF+q0ZfTE8tY9yG2HpQP03FfZCCFCA74zNXlMslrnLjnvLOx8P7kwtaIlXfY/hbnQ==
X-Received: by 2002:a6b:f203:: with SMTP id q3mr29690238ioh.208.1567477102726;
        Mon, 02 Sep 2019 19:18:22 -0700 (PDT)
Received: from [10.227.83.82] ([73.95.135.6])
        by smtp.googlemail.com with ESMTPSA id f7sm9580020ioj.66.2019.09.02.19.18.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 19:18:22 -0700 (PDT)
Subject: Re: [PATCH] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>
References: <20190901174759.257032-1-zenczykowski@gmail.com>
 <CAHo-Ooy_g-7eZvBSbKR2eaQW3_Bk+fik5YaYAgN60GjmAU=ADA@mail.gmail.com>
 <CAKD1Yr2tcRiiLwGdTB3TwpxoAH0+R=dgfCDh6TpZ2fHTE2rC9w@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cd6b7a9b-59a7-143a-0d5f-e73069d9295d@gmail.com>
Date:   Mon, 2 Sep 2019 20:18:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAKD1Yr2tcRiiLwGdTB3TwpxoAH0+R=dgfCDh6TpZ2fHTE2rC9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/19 8:12 PM, Lorenzo Colitti wrote:
> Not sure if this patch is the right fix, though, because it breaks
> things in the opposite direction: even routes created by an IPv6
> address added by receiving an RA will no longer have RTF_ADDRCONF.
> Perhaps add something like this as well?
> 
>  struct fib6_info *addrconf_f6i_alloc(struct net *net, struct inet6_dev *idev,
> -                                     const struct in6_addr *addr, bool anycast,
> -                                     const struct in6_addr *addr, u8 flags,
>                                       gfp_t gfp_flags);
> 
> flags would be RTF_ANYCAST iff the code previously called with true,
> and RTF_ADDRCONF if called by a function that is adding an IPv6
> address coming from an RA.

addrconf_f6i_alloc is used for addresses added by userspace
(ipv6_add_addr) and anycast. ie., from what I can see it is not used for RAs
