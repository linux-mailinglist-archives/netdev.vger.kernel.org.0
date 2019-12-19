Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993E5126880
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfLSR5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:57:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25130 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbfLSR5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:57:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576778253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IBjkDb5bxKZgPTJPSYkBdYcfsBZZ4lMUWmQn47NPw2s=;
        b=E0bTRhoICfYTTjDZy+8UwKYdInOsaSsHk3nu1lMFcWIykoiruiDDAt/UIOPhW4epJICSYN
        7YLmsbnixyuuXmhJQZrJYOIG19EmajaYHTFKchyu/9TSVXsaGUpA9IWemaTdKkD4SCA4Wh
        Oxzk6+QPIvMWaCChYWWesSx5dDXRuug=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-jICiC5nzMzaNsM0DnsmU0g-1; Thu, 19 Dec 2019 12:57:32 -0500
X-MC-Unique: jICiC5nzMzaNsM0DnsmU0g-1
Received: by mail-wr1-f69.google.com with SMTP id t3so1944421wrm.23
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 09:57:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IBjkDb5bxKZgPTJPSYkBdYcfsBZZ4lMUWmQn47NPw2s=;
        b=V/oxodXHzvRkD9CfZmy3G13h+kMhSmVn1VWy5SfNtmnPxL7yQW5Y5WeT1XcJBYFnux
         J7RGl9N97sWuSVWvc7frDUUal0Q9RGjhZFnYjQxxuI3x3bwDxFGSmR4ZaDiSpJ37wax4
         n2UcJSweee1i9vL73+466y3NgOg5zNnRRWG1HU27Lee+A68k+JqazSiaXMBEZnd5wTwB
         BqmwJ9Cr9g2RI7lpArG7ot8fLsMBfp/kun8X3llhgE3u39lVSk/Kjn1z2D9mD/Pr6Mgl
         Hp0+VYND1YBmeY78lRriWOQg9D4aWaVYMoOASHkZmLiufSfNPgxyNZpjFVG3xx56Wnqe
         pyQA==
X-Gm-Message-State: APjAAAWRY7kmpm+JiLHohn/1FE8pbHNX8ffxa003D8roaTL+C5zCzzZj
        xA4kJbAdT7Id950/h8B0Ew/FHFMkzt+jFAvMij8wfezh8f6foKzMErj2gVDBb/oGuK1/o6IrAkA
        3nSfDj18haueKZJdo
X-Received: by 2002:adf:c746:: with SMTP id b6mr10223881wrh.298.1576778251458;
        Thu, 19 Dec 2019 09:57:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDrMmVOwMIjbTBYxIO/czR4ZJg+G0My6ksIMAD+C2hff9iB4Sqi/n0s+qeqdKpWPGBcTxcqg==
X-Received: by 2002:adf:c746:: with SMTP id b6mr10223860wrh.298.1576778251274;
        Thu, 19 Dec 2019 09:57:31 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id x10sm7376246wrp.58.2019.12.19.09.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 09:57:30 -0800 (PST)
Date:   Thu, 19 Dec 2019 18:57:28 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: Re: [PATCH net-next 0/8] disable neigh update for tunnels during
 pmtu update
Message-ID: <20191219175728.GD14566@linux.home>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191218120147.GA27948@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218120147.GA27948@dhcp-12-139.nay.redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 08:01:48PM +0800, Hangbin Liu wrote:
> On Wed, Dec 18, 2019 at 07:53:05PM +0800, Hangbin Liu wrote:
> > When we setup a pair of gretap, ping each other and create neighbour cache.
> > Then delete and recreate one side. We will never be able to ping6 to the new
> > created gretap.
> > 
> 
> Oh... Sorry I forgot to add PATCHv3 in the subject...
> 
Also, it looks like -net material to me.

