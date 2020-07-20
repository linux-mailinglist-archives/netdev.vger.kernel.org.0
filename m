Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A082226542
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 17:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbgGTPwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 11:52:14 -0400
Received: from mx4.wp.pl ([212.77.101.11]:35459 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731334AbgGTPwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 11:52:12 -0400
Received: (wp-smtpd smtp.wp.pl 31256 invoked from network); 20 Jul 2020 17:52:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1595260329; bh=ZrlhkySk6mEIjriz0LOP6iIg6Usur+0iMbg+WnnDg3w=;
          h=From:To:Cc:Subject;
          b=qPwg2Wp9j2HBXxpoYBVYI77NOsXOlm8vWdRYN1CUgp1MF2ZFNdB/kb/zY3MlsKPc+
           vu3cNBWjTvR0psRKRsfW0cwnYvP7Jy6ws/1VJlSpYWcv8Yl/5vj9w06WXnQMzEFXVy
           xn0lb09n2nSq7/OYBVh/efEFP9mUM5BiiWJmSjNQ=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.7])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jiri@resnulli.us>; 20 Jul 2020 17:52:09 +0200
Date:   Mon, 20 Jul 2020 08:51:59 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to
 flash update
Message-ID: <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200720100953.GB2235@nanopsycho>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
        <20200717183541.797878-7-jacob.e.keller@intel.com>
        <20200720100953.GB2235@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 3cd3569609cf8f4009c80ad218d394be
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [4fKz]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 12:09:53 +0200 Jiri Pirko wrote:
> This looks odd. You have a single image yet you somehow divide it
> into "program" and "config" areas. We already have infra in place to
> take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
> You should have 2 components:
> 1) "program"
> 2) "config"
> 
> Then it is up to the user what he decides to flash.

99.9% of the time users want to flash "all". To achieve "don't flash
config" with current infra users would have to flash each component 
one by one and then omit the one(s) which is config (guessing which 
one that is based on the name).

Wouldn't this be quite inconvenient?

In case of MLX is PSID considered config?
