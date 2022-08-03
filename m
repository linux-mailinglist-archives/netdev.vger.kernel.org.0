Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9180588F3E
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236714AbiHCPTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiHCPTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:19:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98B15FA9;
        Wed,  3 Aug 2022 08:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RQOFXZWs2tYr8L8+xWFfYSf+X3mKpoMc+tlzny8a7aU=; b=ghTmO+qLfHAJHYRXY/jt5jXHuV
        Qrj1MkFatPZdVbKhVcDL6hjoIAeYxBOC9E8POkPZoO63HZ/8Oa9VQOF7GO6q2kEI8ZN235GLKV5yG
        mv1z+XDR6MHcJLbz3rDdZwwbExeYhoWd8sEW/lwmSC8XKJMbNVf4D5BtmXhXMjI4GOMY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oJG9Q-00CLld-QF; Wed, 03 Aug 2022 17:19:12 +0200
Date:   Wed, 3 Aug 2022 17:19:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Subject: Re: [PATCH net 1/2] s390/qeth: update cached link_info for ethtool
Message-ID: <YuqR8HGEe2vWsxNz@lunn.ch>
References: <20220803144015.52946-1-wintera@linux.ibm.com>
 <20220803144015.52946-2-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803144015.52946-2-wintera@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 04:40:14PM +0200, Alexandra Winter wrote:
> Speed, duplex, port type and link mode can change, after the physical link
> goes down (STOPLAN) or the card goes offline

If the link is down, speed, and duplex are meaningless. They should be
set to DUPLEX_UNKNOWN, SPEED_UNKNOWN. There is no PORT_UNKNOWN, but
generally, it does not change on link up, so you could set this
depending on the hardware type.

	Andrew
