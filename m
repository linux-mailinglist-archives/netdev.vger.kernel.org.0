Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FC81376D7
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgAJTUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:20:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgAJTUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:20:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12254157526BE;
        Fri, 10 Jan 2020 11:20:11 -0800 (PST)
Date:   Fri, 10 Jan 2020 11:20:10 -0800 (PST)
Message-Id: <20200110.112010.1346105549012746598.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        david.beckett@netronome.com, simon.horman@netronome.com
Subject: Re: [PATCH net] net/tls: avoid spurious decryption error with HW
 resync
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200110123655.996-1-jakub.kicinski@netronome.com>
References: <20200110123655.996-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 11:20:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 10 Jan 2020 04:36:55 -0800

> When device loses sync mid way through a record - kernel
> has to re-encrypt the part of the record which the device
> already decrypted to be able to decrypt and authenticate
> the record in its entirety.
> 
> The re-encryption piggy backs on the decryption routine,
> but obviously because the partially decrypted record can't
> be authenticated crypto API returns an error which is then
> ignored by tls_device_reencrypt().
> 
> Commit 5c5ec6685806 ("net/tls: add TlsDecryptError stat")
> added a statistic to count decryption errors, this statistic
> can't be incremented when we see the expected re-encryption
> error. Move the inc to the caller.
> 
> Reported-and-tested-by: David Beckett <david.beckett@netronome.com>
> Fixes: 5c5ec6685806 ("net/tls: add TlsDecryptError stat")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Applied.
