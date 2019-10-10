Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2ED3D2660
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388023AbfJJJcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:32:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34898 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfJJJb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 05:31:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id v8so6982916wrt.2
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 02:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MyHkItq+3f5f6XhOQmBQDuPqwsiCso3hU6AV8azXpM4=;
        b=02o6A4zXXVQPLJFPGLnJEDV3VsW1W70MzX6dlz1pjQ+Qb2wdhVDMnYSMobJxi8LnuV
         a5uPRcWzXinFQkKps6GqXd4Jt6NyWP5StYYkL9H33r1eVc3Iq6f9d9sYkiJk6i6XUznC
         OvHLaOB+G1ejSBcyaydjAKIWezdy1kcvs3rcQwXJzNl1WrS1Yd1RAHLSRbm3OqkbRwCX
         UbZ8V2bPp0tSSUUl+74AiD1avzMcuhbQTwbUh09pA4i/+iBIvASw0mDLPFZ01sSVswzl
         K+vnfirFrR5wAkpky47pnUgiopTBOIg9lENMAeM45E/g33umdHE/YFHRA5yY+l0ZAyiA
         Mttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MyHkItq+3f5f6XhOQmBQDuPqwsiCso3hU6AV8azXpM4=;
        b=mFtWCbHi3BbSS47o6x06s/IUMaAGLIFfiI1gJE/NqCukK6jXhHZ4wWAz98RixTVNLF
         4dJavcSVAho9odG7MWbgqEMCLKc1fzEDFfLAVo2EzkVklIwVMmQ0xugJawPDX/aY6xfj
         X9Z7z+7LRLBBAoUd1db9pw+Gak0enzymGoI3wc4amxVBUOdTbwsaB3TcXMX8ywWed/vK
         S3wqpCIdE/pKb8m/QGKVOUqx/QI8LxyH6nurFf6t02/iqk/tvS1j6EW/457SMGgWqKlx
         b4yM53GeGxSr2B4p3qNGhp7GRiuOe4jhVpQhMN0IqgdhUCuHs1iQTD4VR6re7sXyejmx
         MBBw==
X-Gm-Message-State: APjAAAX0EAx8+2Xlv+eC0uwmszeyNKybau5dqKdBGVLrHhuoyFAzob9+
        yLeOxP9rvuCf0wG0vFjmn8FCFw==
X-Google-Smtp-Source: APXvYqyJMVy8NWJi3linHyfYh4c37lJsuAOqVBceajAGlAq6CFQgyZVlDa7J0Y8TEd1uLefC1Trv/g==
X-Received: by 2002:adf:f50b:: with SMTP id q11mr4045559wro.310.1570699914005;
        Thu, 10 Oct 2019 02:31:54 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id l13sm5415316wmj.25.2019.10.10.02.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 02:31:53 -0700 (PDT)
Date:   Thu, 10 Oct 2019 11:31:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] genetlink: do not parse attributes for families
 with zero maxattr
Message-ID: <20191010093153.GG2223@nanopsycho>
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

Please also adjust genl_family_rcv_msg_attrs_free() call arg
below in this function in the similar way.



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
