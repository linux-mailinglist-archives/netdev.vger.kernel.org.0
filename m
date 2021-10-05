Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8C1422A41
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhJEOKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236341AbhJEOJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 10:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A88C261165;
        Tue,  5 Oct 2021 14:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633442869;
        bh=zNOkvSGG3EXgvmwNdPutQn0jnc2MuSX/e08M17gN7FE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ucb4p7YfcbuYmELsVziQb08UXRI6xxta/99HkfsKPoBOGrECnxbG4aaYr87lsUSWL
         qbjnqWuJ2TWGwMjKMyNPWRSZXgT1WSUjEAv9XFoDyE4gnegD1KpLXHtEmOGAJjJOsB
         uPz2f8Sp5SaiCrE943fTmPuD8XjrkdSi35s4HRArysTzGL7IaVQqvpInnDNKTSWn4y
         MoRu6raU39NC66JBDqbqtOICghy/Wg1mlxpGEMnz9UVQEl+38Qy6Pdu/E09tXhJqv2
         SZm6ve1uZ7ABJaBEPzGqLvXVGUkpJXgWplVRhPfz0xh/S1B02gRuuIYvsvraeJJ48q
         bZT/JLddekQgA==
Date:   Tue, 5 Oct 2021 07:07:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <20211005070747.1244a113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVw/MluEOlQjQRr7@shredder>
References: <20211003073219.1631064-1-idosch@idosch.org>
        <20211003073219.1631064-2-idosch@idosch.org>
        <20211004180135.55759be4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVv3UARMHU8HZTfz@shredder>
        <YVw/MluEOlQjQRr7@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 15:04:02 +0300 Ido Schimmel wrote:
> > > Can't there be drivers which implement power but don't support the
> > > mode policy?  
> > 
> > I don't really see how. The policy is a host attribute (not module)
> > determining how the host configures the power mode of the module. It
> > always exists, but can be fixed.
> > 
> > Do you still think we should make the change below?
> > 
> > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > index 1b126e8b5269..a2223b685451 100644
> > --- a/include/uapi/linux/ethtool.h
> > +++ b/include/uapi/linux/ethtool.h
> > @@ -721,7 +721,7 @@ enum ethtool_stringset {
> >   *     administratively down.
> >   */
> >  enum ethtool_module_power_mode_policy {
> > -       ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH,
> > +       ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH = 1,
> >         ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO,
> >  };  
> 
> I read your reply again about "still need a valid bit, granted just
> internal to the core". My confusion was that I thought only the valid
> bit in the driver-facing API bothered you, but you actually wanted me to
> remove all of them.
> 
> How about the below (compile tested)?

Yup, exactly!
