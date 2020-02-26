Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B03A170506
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 17:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgBZQ6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 11:58:05 -0500
Received: from mail-qk1-f172.google.com ([209.85.222.172]:45646 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbgBZQ6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 11:58:05 -0500
Received: by mail-qk1-f172.google.com with SMTP id a2so27758qko.12
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 08:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xJFyvlLF2h5ZPaK+h4e58lxJuU8LLY6y+tye8YklPo0=;
        b=BdWzX/cXHBGMAi/3L1Jprws73CvBURK76RJkXdUkmEsL4nujbq0NBhqaZjYO2iw6GL
         LOtpZQjpED6Asd/KPo/FQeYlHikO2zRIShr866Y4/8bhYXyAWqwMTqTlelqkJ8qyxELG
         p5EVRoC4VRAx6g1H3wwoaDqmLPkZ5ktkZ15RM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xJFyvlLF2h5ZPaK+h4e58lxJuU8LLY6y+tye8YklPo0=;
        b=CZ4osjXa5S6rGeb+fT0Ub491vHLBt3ZesfrEoOpoqr8OFM4ZOanxn9CwBk0c4OpG1z
         Xs5j9emqefoXk00c/X3sH7jo/z9sixo/ANA2KtfiYwykuA25H5n0ROIXyI74gWH9eoc7
         QJhoPf8GWW29u4DNPRiu5iO22uk5VVE0ue5nZJ+xXNmpehHRqT5ZOSvHRxxnOYokjjpk
         1hdBLw2SXOkQulSI5VQX7PTuhHuKCG8uHve9HhxJKbq/pQEgpZ3fSy+SacVxBakeX8Mz
         g3Ph+WjhH8hWwtv9LpzfTnfLZ05E4nzVuAvPFq8vQu0SaSYHZeFB/SRoiK1Nfv2oUrtw
         Gpsg==
X-Gm-Message-State: APjAAAXntZf7T6dqIl9fmb8jYav/P4Y/68rGD7mfxAIWXoGAFNTRhPgd
        SR5pcma1fGBlFFk08buzW5a9Lb38trQJvmty
X-Google-Smtp-Source: APXvYqxQGVqsqRjHqXFckqeGKzHdo/F8yzwYajGoYeS0sXgNkpdUeDKfHFcGEqPje/3UVZjQ4HXMAQ==
X-Received: by 2002:a37:86c1:: with SMTP id i184mr44548qkd.386.1582736283827;
        Wed, 26 Feb 2020 08:58:03 -0800 (PST)
Received: from [10.0.45.36] ([65.158.212.130])
        by smtp.gmail.com with ESMTPSA id w18sm1416983qki.40.2020.02.26.08.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 08:58:03 -0800 (PST)
Subject: Re: virtio_net: can change MTU after installing program
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200226093330.GA711395@redhat.com> <87lfopznfe.fsf@toke.dk>
 <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com>
 <20200226115258-mutt-send-email-mst@kernel.org>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <ec1185ac-a2a1-e9d9-c116-ab42483c3b85@digitalocean.com>
Date:   Wed, 26 Feb 2020 09:58:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200226115258-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/20 9:55 AM, Michael S. Tsirkin wrote:
> 
> OK that seems to indicate an ndo callback as a reasonable way
> to handle this. Right? The only problem is this might break
> guests if they happen to reverse the order of
> operations:
> 	1. set mtu
> 	2. detach xdp prog
> would previously work fine, and would now give an error.

That order should not work at all. You should not be allowed to change
the MTU size that exceeds XDP limits while an XDP program is attached.

> 
> If we want to make it transparent for userspace,
> I guess we can defer the actual update until xdp prog is detached.
> Sound ugly and might still confuse some userspace ... worth it?
> 

