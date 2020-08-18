Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B83F248F64
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgHRUJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:09:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59868 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgHRUJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 16:09:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k87vO-009yZK-UZ; Tue, 18 Aug 2020 22:09:38 +0200
Date:   Tue, 18 Aug 2020 22:09:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next 03/18] gve: Register netdev earlier
Message-ID: <20200818200938.GK2330298@lunn.ch>
References: <20200818194417.2003932-1-awogbemila@google.com>
 <20200818194417.2003932-4-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818194417.2003932-4-awogbemila@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 12:44:02PM -0700, David Awogbemila wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> Move the registration of the netdev up to initialize
> it before doing any logging so that the correct device name
> is displayed.

This is generally a bad idea. As soon as register_netdev() is called,
the device is in use. Packets are flowing. This is particularly true
with NFS root. The device must be 100% ready to do work before calling
register_netdev().

Take a look at dev_alloc_name().

     Andrew
