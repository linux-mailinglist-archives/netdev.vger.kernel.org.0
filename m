Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B30B9BD9
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 03:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbfIUBas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 21:30:48 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43588 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730662AbfIUBar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 21:30:47 -0400
Received: by mail-qk1-f193.google.com with SMTP id h126so9200471qke.10
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 18:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nQs4Jz85IPb8Y8s/yPeK+1656cS0v7T8RuxG55hg9ZE=;
        b=nqyT/aUyJAL+EBgB860KK21k80L5UEYslh6B/1F5CyMiNyA8MbilEMuvDuVRHPcjnW
         NqvjZqCaoKENTn64REXuOAcgMFzyFGducItf8gDZHNfQUTWMMq38PQbxxShbbP79/xCs
         hsEYW4+3zD/UzqbEDzm5BLyPormN0fZQ7vdNKHV0vcpE10Q4mqT6N4DQFUVVxoMCwh/p
         yI8n0PeK6uM4AyOnTm3MPEsCaXwKubU3WjvFybpnlAmbxc+cZ2plfos61TbgXr9vVOSD
         N9kxY+jHjCbZAZmKGqixVmeEdknlZ18n0kwaM6h8Z76pVrgur3ufrVV4Rm/CBFNQEh5C
         Kzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nQs4Jz85IPb8Y8s/yPeK+1656cS0v7T8RuxG55hg9ZE=;
        b=JF/Etvz16zC+M9t8JRopgIfdcLKTKyxzF9WpUBstyo92V9Xg0n2Rpzj+iDztBmMcgM
         ZN3vj6x7BYE2d9dWrc2MTlCoWda1RGjnDwLKiRf78HlRgH2i4yF/dzFjJQpf27uG2MaQ
         eEHpIawl3BxjIJEyXccQN+UuADzr59sFAm7syEOoOaDJOB9r6R48+i8wz8SATCL9utgI
         vWOReW4lSJbTjgqF7+5ny4E3J4uNZdK0Fp8Jg8LPFB0C2h+B5YarKk4mNlJnK3zNe19r
         6TLIiIX7OG50JSaBdSHhRNhpo5u3MQtjANcske9+bdEPxee0d9hi0jpmLkj1nJWoxJ1f
         Y3qQ==
X-Gm-Message-State: APjAAAX5nGg2fKjyfKBZT/1zGzpvlmjS8aLZ/ZleavBhfgBfwB3vjc91
        iY/lHZ/1iFlUr6EHDiJg4N/WODLQXUw=
X-Google-Smtp-Source: APXvYqxCJGmKgtECYQ0ePnCqpH67ve/M2MLWvxatFlsr5fGaXe8Gi3Sdcqg5AzlvwoPFnDo/rDU4yg==
X-Received: by 2002:ae9:ef8c:: with SMTP id d134mr6849912qkg.286.1569029445401;
        Fri, 20 Sep 2019 18:30:45 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c201sm1788506qke.128.2019.09.20.18.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 18:30:45 -0700 (PDT)
Date:   Fri, 20 Sep 2019 18:30:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ja@ssi.bg,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] ipv4: Revert removal of rt_uses_gateway
Message-ID: <20190920183041.7c57b973@cakuba.netronome.com>
In-Reply-To: <20190917173949.19982-1-dsahern@kernel.org>
References: <20190917173949.19982-1-dsahern@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Sep 2019 10:39:49 -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Julian noted that rt_uses_gateway has a more subtle use than 'is gateway
> set':
>     https://lore.kernel.org/netdev/alpine.LFD.2.21.1909151104060.2546@ja.home.ssi.bg/
> 
> Revert that part of the commit referenced in the Fixes tag.
> 
> Currently, there are no u8 holes in 'struct rtable'. There is a 4-byte hole
> in the second cacheline which contains the gateway declaration. So move
> rt_gw_family down to the gateway declarations since they are always used
> together, and then re-use that u8 for rt_uses_gateway. End result is that
> rtable size is unchanged.
> 
> Fixes: 1550c171935d ("ipv4: Prepare rtable for IPv6 gateway")
> Reported-by: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: David Ahern <dsahern@gmail.com>

I'm assuming the mix of u8 and __u8 is intentional, since this is a partial revert :)

Applied, queued, thanks!
