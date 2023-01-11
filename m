Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451B56652E9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjAKEoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjAKEoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:44:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E176301;
        Tue, 10 Jan 2023 20:44:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7FC161A1E;
        Wed, 11 Jan 2023 04:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01849C433EF;
        Wed, 11 Jan 2023 04:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673412259;
        bh=qaUYBRYmWbqBGZhHnLUAONEN9YZTBsX4mroopazyi0I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e3t9Y3779jVPIyKv3Zt8HGqA+d4tHmFvNli1yk09qr/nnWq5Ytw5FM80xBgfud9Rp
         QGgb4gNZgz9kURKT3ytd7Dz7e6ac/4qIDs4hbuqZf5tfqeokPu1jlzaQIaZMDxGZ80
         YtfLHfflWphpxSQxhlCn7kQs9qhWcAqegpSbY0rE0xcN1TtTkvBDzXhctnLHXaq+Hd
         O8L5H38A0FJojuGckI7z3qCtGieFuZ2YcSNHhtfCYcDHr8pv+SID1wybkGgFC6+eqL
         fwi4RfvUU19FiBdyU21gG9GJwyVfjkm/bK9Rc8tx2k+oJtssclgFGgq+IMSL5Ago0i
         gQ3wrgJpwsVBg==
Date:   Tue, 10 Jan 2023 20:44:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Esina Ekaterina <eesina@astralinux.ru>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: wan: Add checks for NULL. If uhdlc_priv_tsa !=
 1 then utdm is not initialized. And if ret != NULL then goto
 undo_uhdlc_init, where utdm is dereferenced. Same if dev == NULL.
Message-ID: <20230110204418.79f43f45@kernel.org>
In-Reply-To: <20230110114745.43894-1-eesina@astralinux.ru>
References: <20230110114745.43894-1-eesina@astralinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Jan 2023 14:47:45 +0300 Esina Ekaterina wrote:
> Subject: [PATCH v2] net: wan: Add checks for NULL. If uhdlc_priv_tsa != 1 then utdm is not initialized. And if ret != NULL then goto undo_uhdlc_init, where utdm is dereferenced. Same if dev == NULL.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Esina Ekaterina <eesina@astralinux.ru>
> 
> v2: Add check for NULL for unmap_si_regs
> ---

The format of your commit is wrong. You should make the commit message
look like this in git:

  net: wan: Add checks for NULL

  If uhdlc_priv_tsa != 1 then utdm is not initialized. 
  And if ret != NULL then goto undo_uhdlc_init, where 
  utdm is dereferenced. Same if dev == NULL.

  Found by Linux Verification Center (linuxtesting.org) with SVACE.
 
  Signed-off-by: Esina Ekaterina <eesina@astralinux.ru>
  ---
  v2: Add check for NULL for unmap_si_regs

But the first line (subject) is still not specific enough.
Refer to the bug that's being fixed, not how it's fixed.

Also no braces needed around single-line if blocks.
