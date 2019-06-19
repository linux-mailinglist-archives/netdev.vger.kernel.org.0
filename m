Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779B14B6D3
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 13:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbfFSLNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 07:13:01 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43373 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbfFSLNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 07:13:00 -0400
Received: by mail-lj1-f196.google.com with SMTP id 16so2804890ljv.10
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 04:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qJcvlUovAHnsilJK/HJCelkVG/K886wzuVRNrzXumoQ=;
        b=VhkZb5xdHwlE1Q+seOkxPCsZ+I1v2VIyEUm2tAGsJwue6NpCKUQ1UjY18iIPzlO+6q
         dy2zcu7a+r7EebiPcktTlg2pIy+uttlMR99bNxnj1I8HtOR65TXzwDQ7qlmSL0NfjbH6
         58fCmbdGhtzSsjTZ5gE+3bRP1kgOSa7xr0jYwmavu4s1yQBAvH6Y+pb2YSO0gfTrEK2q
         fuNwL1W+phWgYA502ZJIDbyXhByb/Rmv7mOKLXz7UQHnxIOjD9yzPofG7ke7Pwl8r+aO
         q3W6r5ol+qgNbfw2c1E3huZQrUboK0MHbAledvM8B7NmLnsqjRVxtL2xqIrGL7f+YKC8
         LFRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qJcvlUovAHnsilJK/HJCelkVG/K886wzuVRNrzXumoQ=;
        b=OIMql0s6rfjbJPZ0JXxDsrt/C2O+PAWrdgCn54Z0AZRjL51cq2XBTHA3Za6qRcsZZ0
         Zy4VcdB39gT+fbuLcjPuFakbvujGRgX8MxNgG+coixvWPGwXC7zrmIsdbpybf/GDDxCp
         nRkVTikga+OuMOYW0uh8ERVB49TSrDtrXV0WdqPDt0bkWBS2jlUh94xGDUnfyAd3FvOX
         YQKJWJcWd0dWzLPG5EPjYDZ1WiHifUdtSbSXdQX7Uq3z4KpBeFMRqZMbSxm1QAcrex6O
         oJqpXW0DPY1MOPvarBpEwvdv2Y4VSrghNWJwioRUTSzF33oJT5bT3L299jbdDdG/QGsb
         o93w==
X-Gm-Message-State: APjAAAXumSsU4osbyZuhsXpjHuNFeDMvpOphToSnyGoq7/GFgo2K/OXj
        ZBZ7STbhNW/KdVigngGFTzoN8g==
X-Google-Smtp-Source: APXvYqw30NXpDSrEDv4g6GfBynCNltCJMYx98ChInTe2QKDyxFnOJJ16zthvorYZeC3wawd0I/S7eg==
X-Received: by 2002:a2e:9997:: with SMTP id w23mr33179342lji.45.1560942778491;
        Wed, 19 Jun 2019 04:12:58 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id t21sm2639940lfl.17.2019.06.19.04.12.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jun 2019 04:12:58 -0700 (PDT)
Date:   Wed, 19 Jun 2019 14:12:55 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "toshiaki.makita1@gmail.com" <toshiaki.makita1@gmail.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "mcroce@redhat.com" <mcroce@redhat.com>
Subject: Re: [PATCH net-next v1 08/11] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190619111254.GA4225@khorivan>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
 <156045052249.29115.2357668905441684019.stgit@firesoul>
 <20190615093339.GB3771@khorivan>
 <a02856c1-46e7-4691-6bb9-e0efb388981f@mellanox.com>
 <20190618125431.GA5307@khorivan>
 <20190618171951.17128ed8@carbon>
 <20190618175405.GA3227@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190618175405.GA3227@khorivan>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 08:54:07PM +0300, Ivan Khoronzhuk wrote:
Hi, Jesper

>On Tue, Jun 18, 2019 at 05:19:51PM +0200, Jesper Dangaard Brouer wrote:
>

[...]

>>If we had to allow page_pool to be registered twice, via
>>xdp_rxq_info_reg_mem_model() then I guess we could extend page_pool
>>with a usage/users reference count, and then only really free the
>>page_pool when refcnt reach zero.  But it just seems and looks wrong
>>(in the code) as the hole trick to get performance is to only have one
>>user.

Let's try this variant. This might be used only in case if no choice.
If no issues and provide appropriate comments in the code it can look
more a while normal.

-- 
Regards,
Ivan Khoronzhuk
