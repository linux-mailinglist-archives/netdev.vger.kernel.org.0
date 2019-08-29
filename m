Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C62FA10C7
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 07:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbfH2F0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 01:26:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:43824 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbfH2F0X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 01:26:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5D5D4AC67;
        Thu, 29 Aug 2019 05:26:22 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 82EC4E0CFC; Thu, 29 Aug 2019 07:26:20 +0200 (CEST)
Date:   Thu, 29 Aug 2019 07:26:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190829052620.GK29594@unicorn.suse.cz>
References: <20190826151552.4f1a2ad9@cakuba.netronome.com>
 <20190826.151819.804077961408964282.davem@davemloft.net>
 <20190827070808.GA2250@nanopsycho>
 <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho>
 <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
 <20190828070711.GE2312@nanopsycho>
 <CAJieiUiipZY3A+04Po=WnvgkonfXZxFX2es=1Q5dq1Km869Obw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUiipZY3A+04Po=WnvgkonfXZxFX2es=1Q5dq1Km869Obw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 09:36:41PM -0700, Roopa Prabhu wrote:
> 
> yes,  correct. I mentioned that because I was wondering if we can
> think along the same lines for this API.
> eg
> (a) RTM_NEWLINK always replaces the list attribute
> (b) RTM_SETLINK with NLM_F_APPEND always appends to the list attribute
> (c) RTM_DELLINK with NLM_F_APPEND updates the list attribute
> 
> (It could be NLM_F_UPDATE if NLM_F_APPEND sounds weird in the del
> case. I have not looked at the full dellink path if it will work
> neatly..its been a busy day )

AFAICS rtnl_dellink() calls nlmsg_parse_deprecated() so that even
current code would ignore any future attribute in RTM_DELLINK message
(any kernel before the strict validation was introduced definitely will)
and it does not seem to check NLM_F_APPEND or NLM_F_UPDATE either. So
unless I missed something, such message would result in deleting the
network device (if possible) with any kernel not implementing the
feature.

Michal
