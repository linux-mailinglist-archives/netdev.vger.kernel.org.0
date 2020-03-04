Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4641797F5
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgCDSeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:34:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:45336 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgCDSeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 13:34:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1BE94B1A1;
        Wed,  4 Mar 2020 18:34:14 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id F1A77E037F; Wed,  4 Mar 2020 19:34:11 +0100 (CET)
Date:   Wed, 4 Mar 2020 19:34:11 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Edward Cree <ecree@solarflare.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org
Subject: Re: [PATCH net-next v2 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200304183411.GJ4264@unicorn.suse.cz>
References: <20200304043354.716290-1-kuba@kernel.org>
 <20200304043354.716290-2-kuba@kernel.org>
 <20200304075926.GH4264@unicorn.suse.cz>
 <20200304100050.14a95c36@kicinski-fedora-PC1C0HJN>
 <45b3c493c3ce4aa79f882a8170f3420d348bb61e.camel@linux.intel.com>
 <410f35ef-b023-1c24-f7e7-2724bae121ff@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <410f35ef-b023-1c24-f7e7-2724bae121ff@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 06:16:13PM +0000, Edward Cree wrote:
> On 04/03/2020 18:12, Alexander Duyck wrote:
> > So one thing I just wanted to point out. The used_types won't necessarily
> > be correct because it is only actually checking for non-zero types. There
> > are some of these values where a zero is a valid input
> Presumably in the netlink ethtool world we'll want to instead check if
> the attribute was passed?

Yes, that's one of the advantages: you can see which attributes
user(space) wants to set instead of guessing by comparing to zero or
current value.

> Not sure but that might affect what semantics we want to imply now.

My understanding is that Alexander's comment was only about the name of
the variable, not the semantics. The test will look different in netlink
implementation as I will also want to pass the information about (first)
offending attribute in extack.

Michal
