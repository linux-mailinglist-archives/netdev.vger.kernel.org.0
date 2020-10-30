Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7152A01AC
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJ3JmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:42:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbgJ3JmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604050941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2tgruroP9jJW1k71r6slMACjC291wBRTOg8qbm4sZnc=;
        b=SlMk1B3ceckGV25+K05rH65pQ+JLE2QzS8VkF7zP9TjvuJP53ZMQEVXrvKGGv29ELVKuai
        Pp1VcDPrYWfKG1iQiAf9ixx31YqOZeEsv3XKIKv5WqEoix7Vw2TwZTIE4MBZF6L6TeuULB
        CL2lB3+hm9/Fd88LRFlx0pCkC/p00Uc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-MvbU45ebNw-nOmfw_UGdew-1; Fri, 30 Oct 2020 05:42:20 -0400
X-MC-Unique: MvbU45ebNw-nOmfw_UGdew-1
Received: by mail-wr1-f69.google.com with SMTP id b6so2420034wrn.17
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2tgruroP9jJW1k71r6slMACjC291wBRTOg8qbm4sZnc=;
        b=I/wnHgTpHdvPnrK/B+w7fTuNkyVXgV/c1vfI2jIP0IrkK3U/vC9UDAqb9Z1CeF6kNU
         Mdecen0JOfTib60GBrLhaaYvvK/TuLBL2U/MqV4hmHRjfiFfZC1IfyI0x4VEZNJBThkl
         zkWXxYEgClZ0dEe6U1j8e177ORAIpv4dppYRsqaztTPGJA2Ks0wUevBLS5FBdLOmval6
         Uxmgkqebd+Sc0p5keBOr2ceQRG9J0zVb30r3FWSqUu6dAnCNGp07bOwvrr/7wxYpqh9F
         UDThj5faHXmyOitjMvijGyz7unZ9oD2wYXy6DrqfSwHUAp/JOr6+YLyXbV0fQkUBZdPg
         ydsg==
X-Gm-Message-State: AOAM532fe6NXb2fsbZcu2vYQ9bffRlMKCYD/RJ37ageoJ+ki7cvysLZR
        BuKK07vjATwRcfrKTGfOQfQG5yaUw0HiiK9Kk31LmyxnP/HJwWANMf49d3+Qdex/sJ+ysSCyHmB
        LBrpNyQHySYw4SrBZ
X-Received: by 2002:adf:ec0e:: with SMTP id x14mr2100425wrn.204.1604050938905;
        Fri, 30 Oct 2020 02:42:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRhhQXVR8908MPiS62tCQz8F+FOMKNKriVn232zNg9qLt016TNginiGjaAKgH6F5IXQA2omg==
X-Received: by 2002:adf:ec0e:: with SMTP id x14mr2100409wrn.204.1604050938759;
        Fri, 30 Oct 2020 02:42:18 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id r1sm10387688wro.18.2020.10.30.02.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 02:42:17 -0700 (PDT)
Date:   Fri, 30 Oct 2020 10:42:16 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] selftests: add test script for bareudp tunnels
Message-ID: <20201030094216.GB5719@pc-2.home>
References: <72671f94d25e91903f68fa8f00678eb678855b35.1603907878.git.gnault@redhat.com>
 <HE1PR0701MB2956A07E30A9ED0DCC2C4A57ED150@HE1PR0701MB2956.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0701MB2956A07E30A9ED0DCC2C4A57ED150@HE1PR0701MB2956.eurprd07.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 04:20:13AM +0000, Varghese, Martin (Nokia - IN/Bangalore) wrote:
> On Wed, Oct 28, 2020 at 07:05:19PM +0100, Guillaume Nault wrote:
> >Test different encapsulation modes of the bareudp module:
> 
> Comprehensive tests. Thanks a lot William.

Thanks Martin! I think I can simplify the script a bit. I'll do that in
v2 since a repost is needed anyway.

