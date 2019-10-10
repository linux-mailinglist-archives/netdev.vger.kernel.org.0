Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D39D25BA
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388643AbfJJJC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:02:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42562 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388012AbfJJIkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 04:40:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so6713071wrw.9
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 01:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=42sItMr/D5Wq+0dBHN6jU3FpIi4hpB3vOynEYa+fIL4=;
        b=dhYSWNgKFNmhHl0NqJPT5ow3NshhQlWKNtRKhTYeImMosjkghw2gL/3AHxLstTJLOq
         eWCcECIzT4ogDpaZxN75m/JiyPIULduxX0ro0OQHY+2tFch+y8k/bphJ8nAC+c21WhnV
         Y626DgddgNawu0J2OpQ1MjSzzPWVJXuCtm1OfUkmP1sZBVTRSqLSf2zV8uck2MlUmSxp
         DeidlZqJZRkedsTnLiV3oc6+v7KlInIBTdaGYfnoe1fN8SK2Ww+Yv2mGT6zigAvVlWj4
         Mfo1S8aKgdZF0CkzW1eYAXrOclMiSPcjiCx6/vl+cEEkKjCbJeMYOmTjnm05dgQHw8Gr
         Df0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=42sItMr/D5Wq+0dBHN6jU3FpIi4hpB3vOynEYa+fIL4=;
        b=oIm1VjlIfZREZZrfvHVnqm3I9uE8ZeHs5AwLHY8D1uca6PD+ROZnFKXSreUoSpmXdS
         x6F8hHaItlak1VAhEF8pOb6T7wUi+Rv3eCH+Jc7QxR+R+NG674UN05xG/TMmuQ1wL64a
         VK/NNflt5VZb4hgqatRHPfMF31+gRFhEPTvuJeJltaXe1DaBNmYfu1ZRztysSPIlmtR3
         JpmcLjXNX+hLkuNjHr8yZLMEcMc2+ct9iO4APr+oc5Kh8Gh+k3GPpK/99HXC9pcoaMM4
         s27s4fT1OSXUrh/meChngH5gBmwGLMf911rvyd2Eh1Kpgb/nYp4yqvLERGNycU46EAj1
         1Ocw==
X-Gm-Message-State: APjAAAUnkmHStSCTgKHC5Y6yydf31yx6T9tCIlCjrO1q0/qH1w+VDDiP
        AoKKgG6v5qfwgPUuVXjhriVJbg==
X-Google-Smtp-Source: APXvYqxXDLcHSE+XNsIjvfnqyotxzvbC5wQAIEmI13p0v9dqe+EUFrm3Bo9qzz0Y1KIqdkqrmlcqIQ==
X-Received: by 2002:adf:e9c6:: with SMTP id l6mr7270590wrn.156.1570696800479;
        Thu, 10 Oct 2019 01:40:00 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id m18sm6742626wrg.97.2019.10.10.01.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 01:39:59 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:39:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] genetlink: do not parse attributes for families
 with zero maxattr
Message-ID: <20191010083958.GD2223@nanopsycho>
References: <20191009164432.AD5D1E3785@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009164432.AD5D1E3785@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 09, 2019 at 06:44:32PM CEST, mkubecek@suse.cz wrote:
>Commit c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing
>to a separate function") moved attribute buffer allocation and attribute
>parsing from genl_family_rcv_msg_doit() into a separate function
>genl_family_rcv_msg_attrs_parse() which, unlike the previous code, calls
>__nlmsg_parse() even if family->maxattr is 0 (i.e. the family does its own
>parsing). The parser error is ignored and does not propagate out of
>genl_family_rcv_msg_attrs_parse() but an error message ("Unknown attribute
>type") is set in extack and if further processing generates no error or
>warning, it stays there and is interpreted as a warning by userspace.
>
>Dumpit requests are not affected as genl_family_rcv_msg_dumpit() bypasses
>the call of genl_family_rcv_msg_doit() if family->maxattr is zero. Do the
>same also in genl_family_rcv_msg_doit().

This is the original code before the changes:

        if (ops->doit == NULL)
                return -EOPNOTSUPP;

        if (family->maxattr && family->parallel_ops) {
                attrbuf = kmalloc_array(family->maxattr + 1,
                                        sizeof(struct nlattr *),
                                        GFP_KERNEL);
                if (attrbuf == NULL)
                        return -ENOMEM;
        } else
                attrbuf = family->attrbuf;

        if (attrbuf) {
                enum netlink_validation validate = NL_VALIDATE_STRICT;

                if (ops->validate & GENL_DONT_VALIDATE_STRICT)
                        validate = NL_VALIDATE_LIBERAL;

                err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
                                    family->policy, validate, extack);
                if (err < 0)
                        goto out;
        }

Looks like the __nlmsg_parse() is called no matter if maxattr if 0 or
not. It is only considered for allocation of attrbuf. This is in-sync
with the current code.

For dumpit, the check was there:

                        if (family->maxattr) {
                                unsigned int validate = NL_VALIDATE_STRICT;

                                if (ops->validate &
                                    GENL_DONT_VALIDATE_DUMP_STRICT)
                                        validate = NL_VALIDATE_LIBERAL;
                                rc = __nla_validate(nlmsg_attrdata(nlh, hdrlen),
                                                    nlmsg_attrlen(nlh, hdrlen),
                                                    family->maxattr,
                                                    family->policy,
                                                    validate, extack);
                                if (rc)
                                        return rc;
                        }



>
>Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>---
> net/netlink/genetlink.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
>index ecc2bd3e73e4..c4bf8830eedf 100644
>--- a/net/netlink/genetlink.c
>+++ b/net/netlink/genetlink.c
>@@ -639,21 +639,23 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
> 				    const struct genl_ops *ops,
> 				    int hdrlen, struct net *net)
> {
>-	struct nlattr **attrbuf;
>+	struct nlattr **attrbuf = NULL;
> 	struct genl_info info;
> 	int err;
> 
> 	if (!ops->doit)
> 		return -EOPNOTSUPP;
> 
>+	if (!family->maxattr)
>+		goto no_attrs;
> 	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
> 						  ops, hdrlen,
> 						  GENL_DONT_VALIDATE_STRICT,
>-						  family->maxattr &&
> 						  family->parallel_ops);
> 	if (IS_ERR(attrbuf))
> 		return PTR_ERR(attrbuf);
> 
>+no_attrs:
> 	info.snd_seq = nlh->nlmsg_seq;
> 	info.snd_portid = NETLINK_CB(skb).portid;
> 	info.nlhdr = nlh;
>-- 
>2.23.0
>
