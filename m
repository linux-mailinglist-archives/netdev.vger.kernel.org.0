Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85F224F366
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 09:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHXHyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 03:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgHXHye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 03:54:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B688C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:54:33 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kA7JE-009mXe-9s; Mon, 24 Aug 2020 09:54:28 +0200
Message-ID: <251b824ef444ee46fb199b7e650f077fb7f682ea.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] genl: ctrl: support dumping netlink policy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Date:   Mon, 24 Aug 2020 09:54:11 +0200
In-Reply-To: <3e300840-35ea-5f05-e9c1-33a66646042e@gmail.com> (sfid-20200824_034555_442317_8B4FF994)
References: <20200819102903.21740-1-johannes@sipsolutions.net>
         <20200819102903.21740-2-johannes@sipsolutions.net>
         <3e300840-35ea-5f05-e9c1-33a66646042e@gmail.com>
         (sfid-20200824_034555_442317_8B4FF994)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-08-23 at 19:45 -0600, David Ahern wrote:
> On 8/19/20 4:29 AM, Johannes Berg wrote:
> > @@ -100,6 +102,30 @@ static int print_ctrl_grp(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
> >  
> >  }
> >  
> > +static const char *get_nla_type_str(unsigned int attr)
> > +{
> > +	switch (attr) {
> > +#define C(x) case NL_ATTR_TYPE_ ## x: return #x
> > +	C(U8);
> > +	C(U16);
> > +	C(U32);
> > +	C(U64);
> > +	C(STRING);
> > +	C(FLAG);
> > +	C(NESTED);
> > +	C(NESTED_ARRAY);
> > +	C(NUL_STRING);
> > +	C(BINARY);
> > +	C(S8);
> > +	C(S16);
> > +	C(S32);
> > +	C(S64);
> > +	C(BITFIELD32);
> > +	default:
> > +		return "unknown";
> > +	}
> > +}
> > +
> 
> This should go in libnetlink since it generic NLA type strings.

Arguably, pretty much all of the code here should go into libnetlink
then, since the kernel facility was expressly written in a way that
would allow dumping out arbitrary (not just generic netlink) policies,
just needs wiring up in the appropriate netlink family (or perhaps some
additional "policy netlink" family?)

I can make that change, but I sort of assumed it'd be nicer to do that
when someone else actually picked it up.

johannes

