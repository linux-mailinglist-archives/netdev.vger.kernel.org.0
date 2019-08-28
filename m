Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE4CA0E0B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfH1XEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:04:53 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36086 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfH1XEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:04:52 -0400
Received: by mail-ed1-f65.google.com with SMTP id g24so1841770edu.3
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 16:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Q7JSnutSKY6xFT4D0TS+NhWVJ0m3aop0mXkuXZwQ1WQ=;
        b=qb/E47jXOQPuSvEFEgQZ7e41y//cnPauFgA7N4iBWYIFh6wHQFWfYFLNNfbQ4A+sb/
         /qnFd2EB8mWvqw4vz7E//rOpCQ3J8x7zvsV/DMFXEWxYoTU6ItNXRO0108vKV2kENDnm
         PpjkDlT2YtJbRTDKhSvJ3U0DqYWwfduFnp0wGBXxvtBMR3xuUQOEiJzP2XVES6qL+WVh
         ktXbUmgNkTA+t/6QApnEGFEQQq+PkfIKy5urWRJqmlEO+36R3IehsZ3pJ5Mq35rAFzFr
         vEgFYvHXzZhVXhP/w6b/yicN1Sju0q+zvBG02tORCEgOso/0Ijm9TXar209tRNN25BIs
         IZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Q7JSnutSKY6xFT4D0TS+NhWVJ0m3aop0mXkuXZwQ1WQ=;
        b=SRIJYab9q6tZSMT1MjSnBnFpv+c7WsFYbtE48lxhkQzs6UEFfEIPVJBY33tRLjpNe9
         LpmfucgNuBR+CniyxJL1PZrdDz8IYvMR9WXEDinkdcQI/F+/U7symzmYGkLaRZEOGSsL
         ALz+gbPhko0yV2R5JfhPCIhBBSxiHMRcvYP70QDZ0EBIzc7iqYtcUWG0Pa22p4v0V7Px
         IjSmHbKIAMW4Mn3G2HPsItG7u4LTUfJpDLHDYLuAUQRpJWi3qWNJC6VHuQBfuaAA9TUE
         IZNt1Z3AKQKZsAS44IDnqZSSFJseecRLnAZPzRArUBQD0BtjgLPjH6Cou2PuapHSdqWQ
         2uew==
X-Gm-Message-State: APjAAAX5sl9IwPEHwxkPUa5ajwOJhCCmaPPALw6RBellivHzCRYHLvaL
        2HeJmJIZm1N23VjD1OCN/DzH2Q==
X-Google-Smtp-Source: APXvYqzv+JrKNf2JDsSOceh0HfkjOXGNKBtr248ZuV0rxGOLR7awEnFCsvsCnef6NT1LwX6c05Rjjg==
X-Received: by 2002:a17:906:5391:: with SMTP id g17mr5530333ejo.61.1567033491155;
        Wed, 28 Aug 2019 16:04:51 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d10sm102967ejd.86.2019.08.28.16.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 16:04:50 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:04:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/15] net: sgi: ioc3-eth: split ring
 cleaning/freeing and allocation
Message-ID: <20190828160429.6f9abb4e@cakuba.netronome.com>
In-Reply-To: <20190828140315.17048-10-tbogendoerfer@suse.de>
References: <20190828140315.17048-1-tbogendoerfer@suse.de>
        <20190828140315.17048-10-tbogendoerfer@suse.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 16:03:08 +0200, Thomas Bogendoerfer wrote:
> Do tx ring cleaning and freeing of rx buffers, when chip is shutdown and
> allocate buffers before bringing chip up.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

Ah, so you are moving the alloc/free to open/close, that's good.
