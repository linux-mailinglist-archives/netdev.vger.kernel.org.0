Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0F8B3CDC
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbfIPOte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:49:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37832 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfIPOte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:49:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id r195so115967wme.2
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 07:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rSFC5tgZdhyQC9Mn7OVdOTOje+K81UX01c8JE+lQt3E=;
        b=LC9BAkpJlODq8nD/4nDYstazbiAuSaD+aw1xYmLFEC33i0sRUiRIuX96JA4p/9R5C6
         Z5LObW1/95/Ec9MM21j2cu6gN2xJQrTqdMGqTQSZvRfQAJckvVNZD+iorayGuZAKW+71
         xktdfEG+55ELri0KaIePmG9w84m2ViwqkrmZzBm//A+V2NtkqyJ9+D64T7KlTj7AubGf
         xjNBOchz+N2KM6I2o+bqB8UMpxxum/6GqEAl1Ob6f46xFsv4o4s6GHeCxWXCvECKnEIs
         cudRceZO26MiUhspD2FcJivApBcBjlM0hxn/30uFYdWwyQKdKfPqiIcDH1rJrTwT7Bgv
         Pb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rSFC5tgZdhyQC9Mn7OVdOTOje+K81UX01c8JE+lQt3E=;
        b=ktU4FEYVno0yqBu7gyv/FeFVqoTgWj1GLLrPG5YqDOIkV+1dLacE+xi3pE0wlwkLqP
         a0O6m5zVhPfOzxpsTeCpvMdBGjXs1N9LUV7/O5CQhsNkS/0gjM7zF6tNttmmDgxRqhXC
         A4oxzbl3vVkU0DRezx/BZaNtHrQChOHSjPlvM4ga0ArLGxOMZNebIM8X59s7UKITtl5O
         B21Fpqd/cnztbRPoDDSyiJHcfiKQDvrh4IWXRR4KZ8yFRCaqBegviS4hlYKAMZPQdol9
         R46U9Qm3dg3/Vr+rMxLxEpxVBJ6t7K2XMNKdgRSYS1BGLXPIzfI5CizKfULUFzS9gKxD
         RwLQ==
X-Gm-Message-State: APjAAAWsfqGRvtghUQlVNYLjvAghsCvq3M2zZNQKx37GfLfY/t1IoCJf
        1JV7EeUN0CrbNhxgYcbQ3Sbl4Q==
X-Google-Smtp-Source: APXvYqzPBLEVLmVXJ9YsBh+DVut8B8TIBt64ZH4dxP+2xgA2IZEWFw7JVRc9PZqOWVMLlsQFSoEgVw==
X-Received: by 2002:a1c:9d15:: with SMTP id g21mr90324wme.96.1568645371280;
        Mon, 16 Sep 2019 07:49:31 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q192sm58449wme.23.2019.09.16.07.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 07:49:30 -0700 (PDT)
Date:   Mon, 16 Sep 2019 16:49:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Subject: Re: [PATCH net v3 03/11] bonding: fix unexpected IFF_BONDING bit
 unset
Message-ID: <20190916144930.GO2286@nanopsycho.orion>
References: <20190916134802.8252-1-ap420073@gmail.com>
 <20190916134802.8252-4-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916134802.8252-4-ap420073@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 16, 2019 at 03:47:54PM CEST, ap420073@gmail.com wrote:
>The IFF_BONDING means bonding master or bonding slave device.
>->ndo_add_slave() sets IFF_BONDING flag and ->ndo_del_slave() unsets
>IFF_BONDING flag.
>
>bond0<--bond1
>
>Both bond0 and bond1 are bonding device and these should keep having
>IFF_BONDING flag until they are removed.
>But bond1 would lose IFF_BONDING at ->ndo_del_slave() because that routine
>do not check whether the slave device is the bonding type or not.
>This patch adds the interface type check routine before removing
>IFF_BONDING flag.
>
>Test commands:
>    ip link add bond0 type bond
>    ip link add bond1 type bond
>    ip link set bond1 master bond0
>    ip link set bond1 nomaster
>    ip link del bond1 type bond
>    ip link add bond1 type bond

Interesting. I wonder why bond-in-bond is not forbidden...
