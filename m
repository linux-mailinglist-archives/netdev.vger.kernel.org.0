Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5378712233E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 05:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfLQErb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 23:47:31 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39920 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfLQErb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 23:47:31 -0500
Received: by mail-pg1-f195.google.com with SMTP id b137so4959596pga.6
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 20:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q/WYb5eKIvPjBMlmEfjG8U9z1NC8goFXtiTlXIxr3io=;
        b=12SvFyvwVEokrJYBfMMmyQiny9LZYG/3HIo9kyuDcoG2f2ZuOTNH2c1s1LbGKkW+jI
         LySem7xAQeXjH6g5phRAZ8PVxBn7eVAlwV+0ab7aUy2AgFSe+tRFhRvScNN0nRNZxaSc
         EbiPwOUycV9M3Ag909/KFHwcty31MHK9UWJdbGqrdsXP5MBLl5ssYyGzh4/IbsKFQEsj
         QTvpp7n28iBMUuw1b+Se9J6rfyk+/nomHRsmOQnqOtgePH8usNicbzwxmg7dTDJJ8E+/
         U72fWoRDnWgGdKpLK3zK0YLxyi3ZFYQmU10jZVpXx9TwPBueEiUBE6aUJZVW51VLs/pO
         kSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q/WYb5eKIvPjBMlmEfjG8U9z1NC8goFXtiTlXIxr3io=;
        b=Vi7W5y9xi66ZEAkPhdh3Z+VXnkkYbvCxDIrm3ve0QP3SxyHhT5DQszHDmUSK1CTHVI
         /IDCGv3ZrEOZX+ozQoH+z7SqA+8GGN4Zw0iyFS49lyK9/xLpNkvzUiUZNxIe9JR+jwW4
         yYz7Y4AR4cIAiYWPSe0bCuDuPpAwD6RYIcu8IEdRU0OPlXfjN0rsLRNf/FTxXBus9tL9
         O914NJso+2E0HuIEH1wJ1Khrr0D3d2JTEscES7+0xg22UaEOJR2xHPJnKNsTih28sBCb
         9V6syBmrTowyBIFcCAM3k22asgQE/EE2BQTZIa4XK1qEWyF0hvXhhncF7QJIKEd7JDP2
         rdgQ==
X-Gm-Message-State: APjAAAVCU5SNR1WPdOqV3L7EQDrS+NOvdXap+Rm9zX00wVJYQp8BFVoU
        7mp4k457UcfnFoZV3pIoMa8Atg==
X-Google-Smtp-Source: APXvYqx+8n3PUa1sWO2uGzXTa/627jq+2WbDmLjJwAHzo+scOSJ10CjL5iSrENpCEOy46TxvlRyyHQ==
X-Received: by 2002:a63:946:: with SMTP id 67mr22474547pgj.277.1576558050352;
        Mon, 16 Dec 2019 20:47:30 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 144sm130203pfc.124.2019.12.16.20.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 20:47:30 -0800 (PST)
Date:   Mon, 16 Dec 2019 20:47:26 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "mizuta.takeshi@fujitsu.com" <mizuta.takeshi@fujitsu.com>
Cc:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'davem@davemloft.net'" <davem@davemloft.net>
Subject: Re: [PATCH iproute2 v5 1/2] ip-xfrm: Fix getprotobynumber() result
 to be print for each call.
Message-ID: <20191216204726.1659235f@hermes.lan>
In-Reply-To: <OSBPR01MB37842549BE2C2957005AFE498E510@OSBPR01MB3784.jpnprd01.prod.outlook.com>
References: <OSBPR01MB37842549BE2C2957005AFE498E510@OSBPR01MB3784.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 04:01:03 +0000
"mizuta.takeshi@fujitsu.com" <mizuta.takeshi@fujitsu.com> wrote:

> Running "ip xfrm state help" shows wrong protocol.
> 
>   $ ip xfrm state help
>   <snip>
>   UPSPEC := proto { { tcp | tcp | tcp | tcp } [ sport PORT ] [ dport PORT ] |
>                   { icmp | icmp | icmp } [ type NUMBER ] [ code NUMBER ] |
> 
> In order to get the character string from the protocol number, getprotobynumber(3) is called.
> However, since the address obtained by getprotobynumber(3) is static,
> it is necessary to print a character string each time getprotobynumber(3) is called.
> 
> Signed-off-by: MIZUTA Takeshi <mizuta.takeshi@fujitsu.com>

These two patches do not apply to current git version of iproute2.

