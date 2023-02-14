Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1CF8696EE2
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjBNVK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBNVK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:10:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BD621A04;
        Tue, 14 Feb 2023 13:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DDDA618D1;
        Tue, 14 Feb 2023 21:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283F0C433D2;
        Tue, 14 Feb 2023 21:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676409054;
        bh=5RzJw57sCR6dsu9mn3AagmYRm0h8TmTXiyAU3nKNK2o=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=LMfL0DSgNF2/1Ga8t7WkwSU9AJC+2rtIPHhJLezmDNI1WfpDME/TkTlxN003HsdJj
         Lp60gt2B2Lkq83mN9tV1w3F6bHqiHJkGvzI7718ylsS7ES45/wuMAHpJLoFvVf4JvY
         25hC6/2IRMaHNQbEb3l38/Zpv4fX9qPw3ZqjKT71Clo9WRNT0dyFckeypNsPLYSRbT
         4FdmoFFp2Qo05VnZiT9NqIQukmgvAsQ/zt8ibUDMqjbTCdvMiSQvtouQF5z7Lq7luO
         PRXOphVyUvGrR7kNRN5+9kFhrB30IxHUjwMWu+TIL6xnjdedsV08L9ktm3DtqQVnAb
         aiJPBWIg9vS+Q==
From:   Mark Brown <broonie@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-spi@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <93a051da85a895bc6003aedfb00a13e1c2fc6338.1676370870.git.christophe.jaillet@wanadoo.fr>
References: <93a051da85a895bc6003aedfb00a13e1c2fc6338.1676370870.git.christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] spi: Reorder fields in 'struct spi_transfer'
Message-Id: <167640905215.3115947.16225000677069804009.b4-ty@kernel.org>
Date:   Tue, 14 Feb 2023 21:10:52 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 11:34:50 +0100, Christophe JAILLET wrote:
> Group some variables based on their sizes to reduce hole and avoid padding.
> On x86_64, this shrinks the size from 144 to 128 bytes.
> 
> Turn 'timestamped' into a bitfield so that it can be easily merged with
> some other bifields and move 'error'.
> 
> This should have no real impact on memory allocation because 'struct
> spi_transfer' is mostly used on stack, but it can save a few cycles
> when the structure is initialized or copied.
> 
> [...]

Applied to

   broonie/spi.git for-next

Thanks!

[1/1] spi: Reorder fields in 'struct spi_transfer'
      commit: 9d77522b45246c3dc5950b9641aea49ce3c973d7

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

