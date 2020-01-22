Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BF2145F59
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 00:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgAVXr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 18:47:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAVXr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 18:47:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=c7KvBsdgUtN0++kEbgF75xA9hdBSrsxPPPPaLMNB2m0=; b=In0xdwlgg0n2uolrIuJSHS85Nn
        +3SK8do7ILaWgHGzTkYfrYTRGubo20CXF6/oZgYfcK8VL5CNDRp5Se/U2pskhQSCGGWaJkAdWfkUx
        1BbX+zHqbjT3LdGTrXq7BoCsKsec6OdlD3BeKNEBzejwd9VMWRc6T1YrQ2e7dOwGJHrY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iuPiz-0004I7-D4; Thu, 23 Jan 2020 00:47:53 +0100
Date:   Thu, 23 Jan 2020 00:47:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luigi Rizzo <lrizzo@google.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH] net-core: remove unnecessary ETHTOOL_GCHANNELS
 initialization
Message-ID: <20200122234753.GA13647@lunn.ch>
References: <20200122223326.187954-1-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122223326.187954-1-lrizzo@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 02:33:26PM -0800, Luigi Rizzo wrote:
> struct ethtool_channels does not need .cmd to be set when calling the
> driver's ethtool methods. Just zero-initialize it.
> 
> Tested: run ethtool -l and ethtool -L

Hi Luigi

This seems pretty risky. You are assuming ethtool is the only user of
this API. What is actually wrong with putting a sane cmd value, rather
than the undefined value 0.

     Andrew
