Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE0C362B3
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 19:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFERb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 13:31:56 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37379 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfFERbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 13:31:55 -0400
Received: by mail-pg1-f194.google.com with SMTP id 20so12778816pgr.4
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 10:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i1A/MIFpERyy1X0HJILKq3+OpgfCrT2ihHliA/0bnyw=;
        b=S7bg7aNPRFBfPCcu2XKCYmQFuDfXsUQ7EILAQtd/1hxZte47pT/+bZmQPUnj/S4CcL
         F0tkaQqShoUEuddijBatxTvVDdCrbu5xbhX9VHEPGsgHPDYWyYVWFqwLqTwAjCwcb0Y5
         y1TKpX3ZBmg9U1oltV3GPoWEDaQTMqOs39jkCLuqYGXViD852k3qedPRvrotbdsgS8lH
         3JDyQmu/lqtu323+a9pmAlloP07TbB7D9qtTECSk1x7WmoLn++DsW8Lv5FFz/nDctXkr
         /T8IT8DAUJ2aEikPoFzxZF6yYwAHaZ0t5TzfgqrjDb82QlkNTAMntBr4apSKkhCm3XCa
         BmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i1A/MIFpERyy1X0HJILKq3+OpgfCrT2ihHliA/0bnyw=;
        b=OOl0vPk6x7OpdDOGaXM2WYpfy20nGFv659NTabWJBUJwtfV41DEx0pVPON2+B/FbRM
         2PdUYaWsXQVHnLnKfhY3B5scJzw1FpIRPN4J7EJ+dSbo6zVhJehjez3BVE6ANbD7ULLx
         diKJeHwfnY+Ingtb/fc3plOZIvGX/4HHOb+MUTZGFVQ3NeG343SaE4LJzfWEOkm5Qhp4
         K7Ja1Y2eezDysj/bvbDywT9obw/vgFOC+LR7Q55pJzos2dHZCYN1GNftNr7hdDHXppGm
         7Tj8wtmiZOCvsIBHtyi1ck95vc7nNdfMG6FgBEq5LKFCpxWmKd8aVzlNiWsYD2/c1byN
         AlXg==
X-Gm-Message-State: APjAAAUs8n58WFvjaS3WjKy7S/NRrgE8CDPcZ3QHV94vbOsFk3M0nIid
        0ljUlvGi3ji4d7mlKn4Hfxo=
X-Google-Smtp-Source: APXvYqzYA7fhPQ0+GNgV07Cb6j75wgiDyDkNiAESn+671b48eUwc5Li1NrC7FrHdi4kxS2oGDt+Oqw==
X-Received: by 2002:a17:90a:22c6:: with SMTP id s64mr13796428pjc.5.1559755915303;
        Wed, 05 Jun 2019 10:31:55 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 188sm12015565pfg.11.2019.06.05.10.31.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 10:31:54 -0700 (PDT)
Date:   Wed, 5 Jun 2019 10:31:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 7/9] mlxsw: spectrum_ptp: Add implementation for
 physical hardware clock operations
Message-ID: <20190605173152.4lsfx7a5cvyzatww@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-8-idosch@idosch.org>
 <20190604170349.wqsocilmlaisyzar@localhost>
 <87muiwxv8o.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87muiwxv8o.fsf@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 09:00:09AM +0000, Petr Machata wrote:
> We don't build the PTP module at all unless CONFIG_PTP_1588_CLOCK is
> enabled, and fall back to inline stubs unless it IS_REACHABLE. I believe
> this should be OK.

Please use "imply PTP_1588_CLOCK" in your kconfig, just like the other
PTP drivers do.

Thanks,
Richard
