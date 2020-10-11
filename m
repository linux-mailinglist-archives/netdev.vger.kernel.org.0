Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764EA28AAC8
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 23:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgJKV7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 17:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgJKV7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 17:59:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B6A206E9;
        Sun, 11 Oct 2020 21:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602453580;
        bh=G3Je8do+5ZsaJ4dZz2JT/utl+q/clQ9J2TDTsewcOSs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uEZpa/v4wPmXNbh/J3KoP+MilduzkxhK9d2yg2zCSh80YKHvh9YociYwtCPgNvG2F
         vdZJIpwuK/UAwQOFZXtpa3V8toBjUO8WPcUzYLOtdN9LdzDVKEkTTDV3XdP7zHpnXh
         hU/1ON51DQsxQrp0IvQJRQnAaOGuIRshJGaO+iRc=
Date:   Sun, 11 Oct 2020 14:59:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next 8/9] bnxt_en: Refactor bnxt_dl_info_get().
Message-ID: <20201011145938.7090b195@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602411781-6012-9-git-send-email-michael.chan@broadcom.com>
References: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
        <1602411781-6012-9-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 06:23:00 -0400 Michael Chan wrote:
> +static int bnxt_dl_info_put(struct bnxt *bp, struct devlink_info_req *req,
> +			    enum bnxt_dl_version_type type, const char *key,
> +			    char *buf)
> +{
> +	if (!strlen(buf))
> +		return 0;

I think buf can be directly read from FW in later patches, it'd be good
to see a strnlen(), or bnxt_hwrm_nvm_get_dev_info() ensuring strings
are null-terminated.
