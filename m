Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A70283FAC
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgJETb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgJETbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:31:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81906C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 12:31:25 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPWCY-00HOXo-B6; Mon, 05 Oct 2020 21:31:14 +0200
Message-ID: <93103e3d9496ea0e3e3b9e7f9850c9b12f2397b6.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 5/6] netlink: add mask validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, dsahern@gmail.com, pablo@netfilter.org
Date:   Mon, 05 Oct 2020 21:31:13 +0200
In-Reply-To: <20201005192857.2pvd6oj3nzps6n2y@lion.mk-sys.cz>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-6-kuba@kernel.org>
         <c28aa386c1a998c1bc1a35580f016e129f58a5e3.camel@sipsolutions.net>
         <20201005192857.2pvd6oj3nzps6n2y@lion.mk-sys.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 21:28 +0200, Michal Kubecek wrote:

> > > +	if (value & ~(u64)pt->mask) {
> > > +		NL_SET_ERR_MSG_ATTR(extack, nla, "reserved bit set");
> > > +		return -EINVAL;
> > 
> > You had an export of the valid bits there in ethtool, using the cookie.
> > Just pointing out you lost it now. I'm not sure I like using the cookie,
> > that seems a bit strange, but we could easily define a different attr?
> 
> The idea behind the cookie was that if new userspace sends a request
> with multiple flags which may not be supported by an old kernel, getting
> only -EOPNOTSUPP (and badattr pointing to the flags) would not be very
> helpful as multiple iteration would be necessary to find out which flags
> are supported and which not.

Message crossing, I guess.

I completely agree. I just don't like using the (somewhat vague)
_cookie_ for that vs. adding a new explicit NLMSGERR_ATTR_SOMETHING :)

I would totally support doing that here in the general validation code,
but (again) don't really think NLMSGERR_ATTR_COOKIE is an appropriate
attribute for it.

johannes


