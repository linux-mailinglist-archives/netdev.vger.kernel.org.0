Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46ABAED435
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 19:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfKCSpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 13:45:30 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36294 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbfKCSpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 13:45:30 -0500
Received: by mail-lf1-f67.google.com with SMTP id a6so7191616lfo.3
        for <netdev@vger.kernel.org>; Sun, 03 Nov 2019 10:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eOdq8Hu6igUnwgJC6ijMcGO8XX2Wgr8N1NgWmkUqIi0=;
        b=sp5TpDxPjH4w1V6jLSm2h6J1pDcSftgxeyJArv/dQoGUI3R1XfxH5953TesJkyK5Ve
         xdWI5IlFQSJhV3QUwWUqpGA5MIpqYV2bF2zi/KAMmPQuWp6oFkwY+esINYEiIwGftzaf
         /yQd3ZisQiPyiU6tTDT7y/5zMthKbJk4yRbkTVaxNkMKrz0rvIY0xEIIT8/ELrG05F6L
         lHn08RFrtS92Vs4B7u3lwxSDl9dBJsCCdM718U55+QI8TjyYFSpiO4SO5qrDiVfxikYt
         qAQI94eyUIeNWtGmfphM4CyjMzXwyDtDqSvowudi4fdhTYU5MyKj+adEcbgssPCnF3At
         lZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eOdq8Hu6igUnwgJC6ijMcGO8XX2Wgr8N1NgWmkUqIi0=;
        b=bf0w+dFtAuVPwuatuOkC+BEWI4g9t2vQADhc2LwKRyGYnNwKlsriFbc5mMkl6pRnps
         jUG/TmYSCz3wZcrRjqWkQYyhxU1fMdU32zQKywC/WAjQZ706j0NWw6rIXzhWmwGCamDB
         digOGPdQBJo7gOdjpneIMGkGc/Q7+HWRqWBxcwrSobpOwzDXzbYWStbUglJUoqaj4ehn
         reznP8odhOYUd0Jn3sA66wdYssyg+F5dNEPTgLYqFQ73YOdB1jZjMWUPL0P6FQPCJ+mU
         8cESC/EcQz5P8/dwLp6sJIJOlVw/Egd+PDQai/r/ptM3rVO7qhYEtnokXBEhzEP8UenN
         5jyw==
X-Gm-Message-State: APjAAAWDOabTCeFBzjLPdFGyhaBCtPc+B5NyHLgJ6SxF+uPX4WlNaM3x
        mOcc3aKowDbD0KnuevWxtR+xHT66lgKAKg==
X-Google-Smtp-Source: APXvYqydZXTIg7xJ23CQfiPJxmqJfmJseGcyxSumUlwv5YUDi6l1hRLoQlzFBxBvvoURhE6KrYUFCw==
X-Received: by 2002:ac2:44d5:: with SMTP id d21mr7788722lfm.66.1572806726889;
        Sun, 03 Nov 2019 10:45:26 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:47a:43f6:66fd:82d0:1ef5:f513])
        by smtp.gmail.com with ESMTPSA id d16sm6152522ljh.74.2019.11.03.10.45.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Nov 2019 10:45:26 -0800 (PST)
Subject: Re: [net v2 4/4] net: sgi: ioc3-eth: fix setting NETIF_F_HIGHDMA
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>
References: <20191103103433.26826-1-tbogendoerfer@suse.de>
 <20191103103433.26826-4-tbogendoerfer@suse.de>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <fdff4eb0-06e0-28e0-2398-2c0bdc3079a1@cogentembedded.com>
Date:   Sun, 3 Nov 2019 21:45:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20191103103433.26826-4-tbogendoerfer@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/03/2019 01:34 PM, Thomas Bogendoerfer wrote:

> From: Christoph Hellwig <hch@lst.de>
> 
> Set NETIF_F_HIGHDMA together with the NETIF_F_IP_CSUM flag insted of

   Instead. :-)

> letting the second assignment overwrite it.  Probably doesn't matter
> in practice as none of the systems a IOC3 is usually found in has

   s/a/an/ (before IOC3).

> highmem to start with.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

   Your sign-off is also needed, even if you just post the other's
patches.

[...]

MBR, Sergei
