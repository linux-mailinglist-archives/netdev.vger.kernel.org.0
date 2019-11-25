Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4476D108FF0
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 15:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfKYOaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 09:30:06 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41971 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbfKYOaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 09:30:06 -0500
Received: by mail-pl1-f194.google.com with SMTP id t8so6515318plr.8
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 06:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=msccr5HjWscnRgcVLCsdE6yYVz7Q2sue/VbW9SOWZmw=;
        b=mKJ+NwvVtI6FcgdMq5F/w8EQK/uCq/1Tv96638us4U2SeUPtgCfBoVC7GNubdUPOXi
         Uq0BCqB6jH4/hgq7ZEC1aAojo6Tjooj3VwnFdjuUO0Hx3yLUuvu7ojzZBQSdYqoT4OTc
         NxCkwhWFNZosyBGcl1O9H/DheqaaV/zH7d0n4UHvmmAuRIkQwQ1nVNOtJfkEvQg0KWHm
         HLivvhWynSvUUMlFGt8DrwrFvbGZDvyQtmf4M8WBolZyk2fGtjz49HsKUk4ogl4O8rc1
         XAphKwsU5JF77exAXET1EaMuVuw9zKnW5g2NrHywF/Jdh09bZu5NOgXtbwqkEJcDU0Rm
         DPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=msccr5HjWscnRgcVLCsdE6yYVz7Q2sue/VbW9SOWZmw=;
        b=au5zHqpXzBMWcSCCkFj8sx7Ln9Eyx4CSKk7geuZWxIX8Rq5HXJ+hd79u5o/4ev6fpV
         UKGsSiHLfG7ZwQUHmnrhDLfRQUmG8xpP9sbiGHGLd/rINfrBqXpovaxvlumRmRk4TO8i
         as4mKDRNFHXEF6zqLoFgIdQAzukLzLurZvufWwOYq0jWzh+feCAxupFsLUBlqNFiPfJ0
         nUQjJQo3mNPcvXCEofWtUo+3P2J6xVSWfrZDCOXpUW5VbHPlH9e+aIgp7G3sPch7Dx/l
         JPE5LNwIg1IKZTB/d9vcLBNQJoQJnCdf9x7LKQJ6rArndpaPa5y7dyVjeND8mfDifLHb
         HdAg==
X-Gm-Message-State: APjAAAXjE50ej67AxgRkE2rjp3er3pp6s+CNP1cwL5h8BtYwP5/IBCkM
        wGSKDUop4Lk4aFsvtYwXYaTXxA==
X-Google-Smtp-Source: APXvYqxDkKyiX6PQPBdq8saqXuktE9X6p6JGw5gsHRm/ywagCtmSK6UvwHwhYEuLy4/81lltcM75zg==
X-Received: by 2002:a17:90a:1ac8:: with SMTP id p66mr38436914pjp.24.1574692204117;
        Mon, 25 Nov 2019 06:30:04 -0800 (PST)
Received: from localhost ([2620:10d:c090:180::71c0])
        by smtp.gmail.com with ESMTPSA id h195sm9229020pfe.88.2019.11.25.06.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 06:30:03 -0800 (PST)
Date:   Mon, 25 Nov 2019 09:30:01 -0500
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] mm: implement no-MMU variant of
 vmalloc_user_node_flags
Message-ID: <20191125143001.GA602168@cmpxchg.org>
References: <20191123220835.1237773-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191123220835.1237773-1-andriin@fb.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 02:08:35PM -0800, Andrii Nakryiko wrote:
> To fix build with !CONFIG_MMU, implement it for no-MMU configurations as well.
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
