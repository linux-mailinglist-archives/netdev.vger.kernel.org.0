Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F247935582
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 05:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFEDFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:05:24 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37228 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfFEDFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:05:23 -0400
Received: by mail-pl1-f196.google.com with SMTP id bh12so3063612plb.4
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 20:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sg3/Mxh3ZY/ETtg8Vy8DdHWI8cX8DsRwtHwVCYrdW5A=;
        b=El/Ljlxl5iRoMi/NBTcDbuenZBPAYTlhjag7A+YdCorgrGXeJBjjZxciuEnYEjNlxb
         sb1zqrVdjdjIEisdI3IKhw5jOHWut4gMpgiyZ+CjyUv3Djbmt9oQGnnlHISN2GeXar7m
         vD5KyAC9lvbtaPjYGmpBYnxI1zUN9eJtQqhalSa91mH/mnqHuF/ZDMq0Sn6vW7hdgEcn
         l4iiF7iCUCvbGYH1iBMHlWinzEkn7EeEMoD6HQiBDwrTnOjrqXx0izbtASe95MI6HEBs
         bi6kfnUFep0ZC7jWIlSiA+4s1xeAyoQwrEJw4xGUOBMIVPnUVFrHq6JJdW4PBKwnetWx
         WtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sg3/Mxh3ZY/ETtg8Vy8DdHWI8cX8DsRwtHwVCYrdW5A=;
        b=QvC/ob7ols3g6OtOFYrQ6yENl6US1DUpGaOpWRHCNz+NPYsZUvEfsPQhhMDyb0pGnz
         klIl6feMXJHEz84AvCJ8koSK7Ctg/nzagwQrd4V9m8AfKqWET0nobrF/s08jS3NKskM8
         VqJ8pXwAIPeFuJ3tY2JQsOoZ2ZuDoR/Bx5kBQ/mZsSrnUs1AFLwAQvttJo7NLkH+V4rt
         m898W91rBq3l4ZW9h7k98ePMIl1157Edxh9TaI7EMxzW/4HkNXssfGASqimUgNj2EDLy
         0lgNrV//HjSPQ07a0YkoZWvAsDaqcE6etShQ+OjDvqkvVUy+bEDZV6y36PBhxErGPAnt
         13zg==
X-Gm-Message-State: APjAAAXhICPKjPw93EFU5ux1fPtolXYT22ZQbF79OAWBjdvLC2OeAodO
        7R7b4Eg20am0utkC4+q0M18=
X-Google-Smtp-Source: APXvYqw0NLXyo0vSCykq9KFMWPBjBIu5KWbM4i1DZias6VuxsRHNKcspLaTY2gQXOb1yaXXVUQMZ5w==
X-Received: by 2002:a17:902:724:: with SMTP id 33mr39436559pli.49.1559703923234;
        Tue, 04 Jun 2019 20:05:23 -0700 (PDT)
Received: from [172.27.227.186] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id l1sm17535336pgi.91.2019.06.04.20.05.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 20:05:22 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 0/7] net: add struct nexthop to fib{6}_info
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
References: <20190604031955.26949-1-dsahern@kernel.org>
 <20190604.192741.471970699001122583.davem@davemloft.net>
 <CAADnVQLRjBQaoYA0Af12dBLgzWqFjOmpnY+kBrhQNrpQQqQEsg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8f0805f3-f240-9a94-5faf-3141bd74a433@gmail.com>
Date:   Tue, 4 Jun 2019 21:05:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQLRjBQaoYA0Af12dBLgzWqFjOmpnY+kBrhQNrpQQqQEsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/19 9:03 PM, Alexei Starovoitov wrote:
> As far as I can see the discussion on a better path forward
> was still ongoing in v2 thread between David, Martin and Wei.
> Since the set is already applied it demotivated everyone
> to review and discuss it further.
> Please reconsider such decisions in the future.

The discussion on the other thread has nothing to do with this patch
set; it is about changing / removing *existing* code.
