Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C8B2E8DBF
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 19:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbhACSXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 13:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbhACSXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 13:23:41 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029BDC061573
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 10:23:01 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 15so17307607pgx.7
        for <netdev@vger.kernel.org>; Sun, 03 Jan 2021 10:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=by47pALq1923sWp/Woa91R8G7twyCZwWW7wDqZ2tMYs=;
        b=RcLhcG/MsbAeRI/Dsz1x94Z51R9wTKHxWN/f/p3w72ipC2fgx7pwhU882ZLaX2jCS4
         tolPh0ym/MPN0xTnIUe5udw9sx1ox14pxPKnE88JfPNnJsQz3ua6OUSq2o0KzNkWVY5L
         1iZGyv3CVXIrlMqT7jTslJOWyh1V2zjT72MZ/afosnZ7ZpVB8CcYlKDd3S8BkNlqVP11
         5K8IYKq3N9UUdvGrvSusJykCTepkryDKHxKs1W17/xPW1iuoNkiBn8aQ2ebOlDDN/ikS
         Lbx96anbCPB2N6ONTx1aPVLyJR0OixfYsAMYM03u3Kcjv6phkACFzf5gzAERksnQQuAs
         0Hag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=by47pALq1923sWp/Woa91R8G7twyCZwWW7wDqZ2tMYs=;
        b=CAPTcJfQ6ppjKSr3fYXDIJlU/zGEubERW0mB+3lNEaw76HZ6bBgrN9b7CLQYbFNN8H
         O59VppcxSYJNccNZJDYXZyBrIc0/BzzYuuQ7SKq61nWLAHJTkVGO4QVUA+WG73eXJ8qy
         AUDqinQbeGZOfUvH7OEGGMBuCf2kv/P0Y8/dHGxFRHe4KGhJB3bpKw3lfSExpNa4qot4
         +UBMQCXwPYqQ4JwIv+2/zaMvw3ayq1EqNF0EawafArxOOZQhAI4U64QUAMhLghRQASJQ
         Kh3+ceI3W4Buq01M+sY5amCYwinOmJ2Xi+9mZBQIdc9h/SanOSQW0kPmT5q1b6yYhlfd
         jfDA==
X-Gm-Message-State: AOAM533M2Uw0C6gkbKlMIcaTmXQjsn+YF1ao3yTC/Mb1Gi3d4PFKruiP
        n10fdF/TSHSHlyzE7DnYGUjC8w==
X-Google-Smtp-Source: ABdhPJzDKbKAPYlU7HglRWdvmyWellCXzzbuUJHaF6RNfHqKIqaG3dWuW4HoRIx5fPDTxqYMfWYFtg==
X-Received: by 2002:a65:688a:: with SMTP id e10mr68169205pgt.347.1609698180604;
        Sun, 03 Jan 2021 10:23:00 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id jz20sm18549852pjb.4.2021.01.03.10.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 10:23:00 -0800 (PST)
Date:   Sun, 3 Jan 2021 10:22:57 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2 1/3] dcb: Set values with RTM_SETDCB type
Message-ID: <20210103102257.7978520d@hermes.local>
In-Reply-To: <87h7nywb3h.fsf@nvidia.com>
References: <cover.1609543363.git.me@pmachata.org>
        <61a95beac0ea7f2979ffd5ba5f4a08f000cc091a.1609543363.git.me@pmachata.org>
        <20210102093423.2033de6a@hermes.local>
        <87h7nywb3h.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 03 Jan 2021 11:47:46 +0100
Petr Machata <me@pmachata.org> wrote:

> Stephen Hemminger <stephen@networkplumber.org> writes:
> 
> > On Sat,  2 Jan 2021 00:25:50 +0100
> > Petr Machata <me@pmachata.org> wrote:
> >  
> >> dcb currently sends all netlink messages with a type RTM_GETDCB, even the
> >> set ones. Change to the appropriate type.
> >> 
> >> Signed-off-by: Petr Machata <me@pmachata.org>
> >> ---
> >>  dcb/dcb.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/dcb/dcb.c b/dcb/dcb.c
> >> index adec57476e1d..f5c62790e27e 100644
> >> --- a/dcb/dcb.c
> >> +++ b/dcb/dcb.c
> >> @@ -177,7 +177,7 @@ int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr, const void *da
> >>  	struct nlattr *nest;
> >>  	int ret;
> >>  
> >> -	nlh = dcb_prepare(dcb, dev, RTM_GETDCB, DCB_CMD_IEEE_SET);
> >> +	nlh = dcb_prepare(dcb, dev, RTM_SETDCB, DCB_CMD_IEEE_SET);
> >>  
> >>  	nest = mnl_attr_nest_start(nlh, DCB_ATTR_IEEE);
> >>  	mnl_attr_put(nlh, attr, data_len, data);  
> >
> > Should I add fixes tag to this?  
> 
> Ha, I forgot that Fixes: tags are a thing in iproute2. Sorry about that,
> I'll resend.

Thanks, Fixes are mainly to help out distribution maintainers who want
to backport to older versions.
