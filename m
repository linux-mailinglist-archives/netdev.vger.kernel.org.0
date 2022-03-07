Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371984D0AF2
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239033AbiCGWW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343736AbiCGWWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:22:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357838CDBB
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 14:22:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9E63B816FC
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 22:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78212C340F3;
        Mon,  7 Mar 2022 22:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646691718;
        bh=BRhHkPsxgSaDR8ZknERxLFDBmMUCOOXGuTupi7r2sro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sNvsJ6hgBcrT4lneogC9+WwqspAmZosC7/+jDghARfCW/yljaSVXEElMDwPTT6Ld1
         yc8pEx7PExPoK8pY61Q+efNoHfmIPc0Bx13pEOwJGch+SnawXvXSlcA6sOaboyjktH
         vvtK1yfyls5PYo+q0Rj0wRO4M4hBPO80SDVVNlnPk86j5iVdOyjUh5sQYH/bho/FkJ
         p4kP6z/Ocl/pcQ2PXsH1YvzIrEQT3pY3IJVA6YldjsfupwBdSnPNEpegchXx9NfLGb
         TW22D7Q4AzfWx8RrNhOdb4Cum6WUM3NkfM2nIwfJLnGYSGA5xxdGGgZSAHyQeEqhbg
         Zr/NZfshVw2pg==
Date:   Mon, 7 Mar 2022 14:21:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 8/9] bnxt_en: implement hw health reporter
Message-ID: <20220307142157.143c9beb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1646470482-13763-9-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
        <1646470482-13763-9-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Mar 2022 03:54:41 -0500 Michael Chan wrote:
> +static int bnxt_hw_recover(struct devlink_health_reporter *reporter,
> +			   void *priv_ctx,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct bnxt *bp = devlink_health_reporter_priv(reporter);
> +	struct bnxt_hw_health *hw_health = &bp->hw_health;
> +
> +	hw_health->synd = BNXT_HW_STATUS_HEALTHY;
> +	return 0;
> +}

This seems like a very weird recovery function.

I guess the FW automatically does auto-recovery and the driver 
has no control over it?
