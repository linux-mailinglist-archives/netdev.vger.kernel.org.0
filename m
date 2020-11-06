Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF782A9A5E
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgKFRDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgKFRDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 12:03:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5EC220720;
        Fri,  6 Nov 2020 17:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604682223;
        bh=cLr1RUeZiBN3G96tbBiVYIi2i1f35CfFY9K+FCzjUas=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eH5yk5nueQI84XjhOjJ3VQjy3DpH1ESviXPibOAe+meYZWmDZDGtaBXNV/gbdUHLO
         L5xLPzrKZugE0Fct9JDr8USO9YVI3WikKrbWt8VyFt56+CQFhWYcg4/d4+whfSJoR7
         qqTsgmC9QNE4En9R31XxPRW65jf+HfnWyM5CHR8k=
Date:   Fri, 6 Nov 2020 09:03:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 6/8] ionic: flatten calls to
 ionic_lif_rx_mode
Message-ID: <20201106090341.02ac148c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106001220.68130-7-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
        <20201106001220.68130-7-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Nov 2020 16:12:18 -0800 Shannon Nelson wrote:
> +			work = kzalloc(sizeof(*work), GFP_ATOMIC);
> +			if (!work) {
> +				netdev_err(lif->netdev, "%s OOM\n", __func__);
> +				return;
> +			}

Can you drop this message (can be a follow up, since you're just moving
it).

AFAICT ATOMIC doesn't imply NOWARN so the message is redundant no?
