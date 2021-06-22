Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55153B105E
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFVXMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:12:48 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48618 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFVXMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:12:47 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 63B581FD45;
        Tue, 22 Jun 2021 23:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1624403430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1gF0ZdC90O64KxzGDSH7UicbWohLy4amAkLAymfTUno=;
        b=ksGcIDeonw0i7DynsIz9bDUeHdVaNStgMdnnem4qzBTUsbDiKETjnN9ehsPkMYoe53vQMf
        q6zUXbUfp5z+W8LhhYHKafu2UUXXdeV1MSRqRfpPBrBeG9oaOs1DdbMA3KkQkkLQe75k2T
        ye9HVo2BwZZCtN6wSyZggaRd0n9KXpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1624403430;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1gF0ZdC90O64KxzGDSH7UicbWohLy4amAkLAymfTUno=;
        b=PXx5S3AuS3NViLmAtHpnHRee8sIUcKjEQUURF4NlADTVeZ607c+Q/wP5cCbpKgtKf0bdlO
        q/d94G+gzNC0JuBg==
Received: from lion.mk-sys.cz (unknown [10.163.29.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 52F6CA3B96;
        Tue, 22 Jun 2021 23:10:30 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2663D607E1; Wed, 23 Jun 2021 01:10:30 +0200 (CEST)
Date:   Wed, 23 Jun 2021 01:10:30 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, andrew@lunn.ch, vladyslavt@nvidia.com,
        moshe@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/7] ethtool: Module EEPROM API improvements
Message-ID: <20210622231030.fmknwontiqirdbw7@lion.mk-sys.cz>
References: <20210622065052.2545107-1-idosch@idosch.org>
 <20210622093005.23bda897@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622093005.23bda897@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 09:30:05AM -0700, Jakub Kicinski wrote:
> On Tue, 22 Jun 2021 09:50:45 +0300 Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > This patchset contains various improvements to recently introduced
> > module EEPROM netlink API. Noticed these while adding module EEPROM
> > write support.
> 
> Scary that 3/7 was not generating a warning.

Actually, it's not as scary as it seems. If an array variable is
declared with fixed size and then defined and initialized with just
"[]", the number of elements is still taken from the declaration, not
from the maximum initializer index. So there was nothing to worry about,
we just had a partially initialized array with extra elements zero
initialized.

Michal
