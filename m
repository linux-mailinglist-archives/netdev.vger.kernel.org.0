Return-Path: <netdev+bounces-3991-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA538709F24
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB1E9281DCE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFFAE8F41;
	Fri, 19 May 2023 18:35:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01486FD2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 18:35:14 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4451B7
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=0KtoxaZpZKlvXmIoiKmeOXekgoFhZD3G+l4Z3Gcg4kw=; b=kH4q3W3apU0ei03M8CTr9sR+Sz
	ZSH3ZigRgi2gTQ1dfPs3Ec8cCZkmXtSro6FawQYRvnlTeHFcWjnutb/SQwd7pRoYLNrfovxlOKl8p
	y9YUbwM0pv1C5FsprQakIH73U4WxRT+R14tqmlTc5K9U/R3gzAiYPp+X8gHPg1jfNHmc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q04wS-00DMG7-Eq; Fri, 19 May 2023 20:35:04 +0200
Date: Fri, 19 May 2023 20:35:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Radoslaw Tyl <radoslawx.tyl@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: Re: [PATCH net-next] i40e: add PHY debug register dump
Message-ID: <f6b96409-5b08-4df5-b4fd-6f1db8ada690@lunn.ch>
References: <20230519170208.2820484-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519170208.2820484-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 10:02:08AM -0700, Tony Nguyen wrote:
> From: Radoslaw Tyl <radoslawx.tyl@intel.com>
> 
> Implement ethtool register dump for some PHY registers in order to
> assist field debugging of link issues.
> 
> Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
> Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Why not just implement phy_mii_ioctl()? You don't need custom ethtool
registers if these are PHY registers. You can use the well defined
IOCTL interface for reading PHY registers.

      Andrew


