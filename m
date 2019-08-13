Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68CE88AC66
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 03:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfHMBQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 21:16:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43923 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHMBQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 21:16:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id v12so2814907pfn.10
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 18:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1XI33rkuBq4SSZZi/Qw2STU224quSS0IKHB3YiAFlVg=;
        b=HfA/hL/d1Ju5jkp+0mgvXl6VqrFL52oNP6kqLI2/mKmlTJRC5Xx7gji6YYUar2h8ns
         gfR7m18ozyRlPr4icuisUgaoZ832XEis9v284nHFiTPcdCWYIKXAJbdwVjs84UG4ndyJ
         xPVNXATdpLlMJLpT4jFSLmzacJCL41PA3LhT/gihy1vZ72iq/9CSas9e4jAB1Qgq5eAf
         R29LlWmVhJrmitHra7mgtamVD2XFYr3bq7DTtPlV1nBcQYvNHd8fZ1S6UpoUMI7XnN/Q
         z58hIRdr6RJ+CbhhLhoyeWNPXypq3kwEw0JmUGeDvWk2rSA53fFslttZTk96B/xUzNWy
         tmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1XI33rkuBq4SSZZi/Qw2STU224quSS0IKHB3YiAFlVg=;
        b=jtF2v7YU2IFIcQqKVlff9pMcSqliK6iWaPR6onpRb+7Bt/DfY8aIW0E1Iir3aUOFDC
         7e9N0EQFnkYLddLaraGw4rWwa23j/eBwohzUCDiPuGMq/3WWus6ov+KlgZyybVnV31ge
         2LpwvnN3J75qLVkO2V2JNxCXb4V3TC8XaUnUEI2IN5axllnMeBb43cQjU01TzwYre8Vu
         DrQWF0kIwIeOLGZqsQ7Wvn7ZD7wCIzWvAqROe84TEE1wNF2QWsvHCo7Uuh/EYxaFZbuK
         FGbh52zsuqyQa5KObOxmwym9t0P0PdEb8ExlyE1NUETpPvlcPilO61+2aP/qFFi/6l7U
         LTIg==
X-Gm-Message-State: APjAAAXTXuEbx/lbHeyD0JJVq4sm2NA3cbU+xwWNPUAizTKGSObQBEjU
        VYSe/ocgRqglcZSenuDls7vkfQ==
X-Google-Smtp-Source: APXvYqwskHUDsHTWwsPH1u3J0t9gfpEW8LHJNlBX67K4anWCWjcz6sWiw+grYN5JvhHK6QBLTgzt4Q==
X-Received: by 2002:aa7:81d9:: with SMTP id c25mr38969713pfn.255.1565658968837;
        Mon, 12 Aug 2019 18:16:08 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j12sm98552711pff.4.2019.08.12.18.16.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 18:16:08 -0700 (PDT)
Date:   Mon, 12 Aug 2019 18:16:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH iproute2] tc: Fix block-handle support for filter
 operations
Message-ID: <20190812181601.6ac57847@hermes.lan>
In-Reply-To: <20190812101706.15778-1-idosch@idosch.org>
References: <20190812101706.15778-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 13:17:06 +0300
Ido Schimmel <idosch@idosch.org> wrote:

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Commit e991c04d64c0 ("Revert "tc: Add batchsize feature for filter and
> actions"") reverted more than it should and broke shared block
> functionality. Fix this by restoring the original functionality.
> 
> To reproduce:
> 
> # tc qdisc add dev swp1 ingress_block 10 ingress
> # tc filter add block 10 proto ip pref 1 flower \
> 	dst_ip 192.0.2.0/24 action drop
> Unknown filter "block", hence option "10" is unparsable
> 
> Fixes: e991c04d64c0 ("Revert "tc: Add batchsize feature for filter and actions"")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied
