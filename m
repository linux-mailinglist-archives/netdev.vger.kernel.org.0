Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3004E2DD86C
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgLQScf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgLQScf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:32:35 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840AAC061794
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 10:31:54 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id j22so21350059eja.13
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 10:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PaQLFCPDXYdRBDF0cqZO2lJPciGJZchQccbI7HdVSMU=;
        b=mFlsIgpstAtaXooJSG7Kd4fb1ctinOQ7VzQPp1I4l11uRT6AUmApLJmpirHM5tprWL
         2k224z19mqdGbgpx2tPwUZjSS0pH0pg2JzeFGvflV30iXSJSk7toUiD5MiSwEM0UluX+
         IvrGkspnS60FCN5sWfCFQ4BWTi2/h+WRbzkNJrjHIwceTtUZIv4I2trnN1fKiBUaTCvz
         d9Hd/AyraveG01rA76vxtTV8Orwkw78bEfYHiyz0mHr65W1lgEVwcIFRAeRkrwjuMiIb
         mCY1B+Cona9zaMsmx/07xzfLBEY5vFqJMKQKA8GPhP6hTR6IwJT+4b+CCXXf+lBZm6tj
         Ry4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PaQLFCPDXYdRBDF0cqZO2lJPciGJZchQccbI7HdVSMU=;
        b=TZfivmSiUlq6zkGxPt3I6m1LlX/0pbaHG9ijShud2LLxQWPbarrKEiy+byq+G3wj3c
         qQFYculTGKnbXvWcxd/6+eUWG4xSn0UxP/1T77qZYIQ2U2BTeGZtq2dNIq+Mqw/6VpuW
         UySsSYyi8zsw0Mb4keE5bp/lF5s2ARoQeXOfVU/ERuSRwZXa6JX4ELCb3YMMROqsoX2K
         98wt47URXdSrPgvuSf36UHsd6ptPwRE7BwBuE9FdBPvOWC7hY6xcVatWYvRSqxqjN0mn
         IZ90N1CEehaOrg5T6MPAoEp5AIXNmGdFtfwyN/eoKAqOYw4+S0rB5eFsCb58YvcWFKcw
         Bv8A==
X-Gm-Message-State: AOAM530feKvBGQmrFRvUwDmaq1A2sU2vOdetucX9VS7wyQ1JvI2fpBJs
        y24wfXF5YERnsSKRkTge2bg=
X-Google-Smtp-Source: ABdhPJzFH3Rqajs7CyBf51+438YGtQv7F9xE3XQ7SkWk2NPRzJ2btx7GnJmCOor4kXTiFcjA+gwS+w==
X-Received: by 2002:a17:907:2d0f:: with SMTP id gs15mr276804ejc.455.1608229913179;
        Thu, 17 Dec 2020 10:31:53 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id t12sm23858650edy.49.2020.12.17.10.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 10:31:51 -0800 (PST)
Date:   Thu, 17 Dec 2020 20:31:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/5] net: dsa: Link aggregation support
Message-ID: <20201217183150.utyeibdh7too5rmb@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com>
 <20201216160056.27526-4-tobias@waldekranz.com>
 <20201216184427.amplixitum6x2zui@skbuf>
 <87k0thbjhl.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0thbjhl.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 09:09:58PM +0100, Tobias Waldekranz wrote:
> On Wed, Dec 16, 2020 at 20:44, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Wed, Dec 16, 2020 at 05:00:54PM +0100, Tobias Waldekranz wrote:
> >> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> >> index 183003e45762..deee4c0ecb31 100644
> >> --- a/net/dsa/dsa2.c
> >> +++ b/net/dsa/dsa2.c
> >> @@ -21,6 +21,46 @@
> >>  static DEFINE_MUTEX(dsa2_mutex);
> >>  LIST_HEAD(dsa_tree_list);
> >>
> >> +void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
> >
> > Maybe a small comment here and in dsa_lag_unmap, describing what they're
> > for? They look a bit bland. Just a few words about the linear array will
> > suffice.
> 
> Not sure I understand why these two are "bland" whereas dsa_switch_find
> just below it is not. But sure, I will add a comment. You want a block
> comment before each function?

What I meant is that if you're just a casual reader carrying on with
your day and you see a function called dsa_switch_find, you have a vague
idea what it does just by reading the headline - it finds a DSA switch.
Whereas dsa_lag_map, I don't know, just doesn't speak to me, it's a very
uneventful name with a very uneventful implementation. If we hadn't had
the long discussion in the previous version about the linear array, I
would have honestly had to ask you what's the purpose of "mapping" and
"unmapping" a LAG. So I expect many of the readers ask themselves the
same thing, especially since the comments say that some drivers don't
use it.

I guess this would look more dynamic for me:

/* Helpers to add and remove a LAG net_device from this switch tree's
 * mapping towards a linear ID. These will do nothing for drivers which
 * don't populate ds->num_lag_ids, and therefore don't need the mapping.
 */
void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
{
	unsigned int id;

	if (dsa_lag_id(dst, lag) >= 0)
		/* Already mapped */
		return;

	for (id = 0; id < dst->lags_len; id++) {
		if (!dsa_lag_dev(dst, id)) {
			dst->lags[id] = lag;
			return;
		}
	}

	/* No IDs left, which is OK. Calling dsa_lag_id will return an
	 * error when this device joins a LAG. The driver can then
	 * return -EOPNOTSUPP back to DSA, which will fall back to a
	 * software LAG.
	 */
}

void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
{
	struct dsa_port *dp;
	unsigned int id;

	dsa_lag_foreach_port(dp, dst, lag)
		/* There are remaining users of this mapping */
		return;

	dsa_lags_foreach_id(id, dst) {
		if (dsa_lag_dev(dst, id) == lag) {
			dst->lags[id] = NULL;
			break;
		}
	}
}
