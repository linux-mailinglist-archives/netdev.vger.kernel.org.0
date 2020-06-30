Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC4020FD6E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbgF3UIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:08:06 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:19064 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgF3UIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:08:06 -0400
Received: (qmail 55975 invoked by uid 89); 30 Jun 2020 20:08:04 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 30 Jun 2020 20:08:04 -0000
Date:   Tue, 30 Jun 2020 13:08:01 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@herbertland.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ADQ - comparison to aRFS, clarifications on NAPI ID, binding
 with busy-polling
Message-ID: <20200630200801.4uejth6qawnebyou@bsd-mbp.dhcp.thefacebook.com>
References: <e13faf29-5db3-91a2-4a95-c2cd8c2d15fe@mellanox.com>
 <807a300e-47aa-dba3-7d6d-e14422a0d869@intel.com>
 <AM6PR05MB5974D512D3205C247B07D0C7D1930@AM6PR05MB5974.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR05MB5974D512D3205C247B07D0C7D1930@AM6PR05MB5974.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 12:48:06PM +0000, Maxim Mikityanskiy wrote:
> Thanks a lot for your reply! It was really helpful. I have a few 
> comments, please see below.
> 
> On 2020-06-24 23:21, Samudrala, Sridhar wrote:
> 
> > ADQ also provides 2 levels of filtering compared to aRFS+XPS. The first
> > level of filtering selects a queue-set associated with the application
> > and the second level filter or RSS will select a queue within that queue
> > set associated with an app thread.
> 
> This difference looks important. So, ADQ reserves a dedicated set of 
> queues solely for the application use.

I wanted to break this out as it looks like the most interesting part.
There are several use cases where the application needs to have its
packets arrive on a specific queue (or queue set): AF_XDP, and other
zero-copy work. 

Having the app bind to a napi_id doesn't seem to provide the same
functionality.
 

 
> Ethtool RSS context API (look for "context" in man ethtool) seems more 
> appropriate for the RX side for this purpose.

Agreed.
-- 
Jonathan
