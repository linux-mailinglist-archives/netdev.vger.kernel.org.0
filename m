Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C672D405B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgLIKyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgLIKyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 05:54:09 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E37C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 02:53:29 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id m19so1424342ejj.11
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 02:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v1bIGnibE305aEafg/51bZzbz0YkGS9AA1hbns9QF6o=;
        b=he/tuXioIK0TQjOjTFk0A+HK89mEhlJ6pSkRmVfiAiA15+Ix9p8Sx7umwwH8kzWCQV
         XBl+hBnUGLLyYtg/+kl5zKrLENVxOst5HUrDnF00UZc2BjzvmWuF4u7q1gZAjieR4BKl
         95I1bQN9SUwypXBJ6PD31hzrKXkMKgN88cF6DcH3pgG3bDgxfifjPLVkKGUSr7VIBx7B
         9NREywu33qOC3l6ZTJn1fGIdgMMEnpElUB4Egn7OLhK7K1kO5LSToQUT0OUoTh6lZpfV
         1E+MGOtcKnOlC3f5r5qD2uY2SeFFsaucYtQGc7evmPZT0yS7D+K3JAPCYUlFxjkrIqNV
         pL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v1bIGnibE305aEafg/51bZzbz0YkGS9AA1hbns9QF6o=;
        b=hish/qgn+QoPGVaFbdtzxLig5116X+9fFrURgzeA34VF6oLWpdc3fqCT4EwQd8ZStB
         e1Tx6hIQaIeIUYHHdmZ/oxuKS+3M4tlDZd66uegXpMqGyM2wCKVCO6HwGB9FWWlhx1vc
         0YzrvjPe+OUn8i4Mq7HJD3E9TxBeM502D3xpN9hf+z3ckhJ1WxTp2sxQlJ1szyWQkTun
         ml/7beOVYfN5O1DFYF/DIvrpXF2VbjbQMNH/im84edmN2tg78iDHFiFeWBbQ9u8sCPJa
         M63f79sVEIDkc98JTHKzUZPhSHFsUziipkDQSiXS1rxNUInv1BV81F8cQY07J5pzlDs7
         7Xag==
X-Gm-Message-State: AOAM533usm5O3g8EM/EENLhO3hhgLLfjd7N9e3x42q0B+hDh0257QYRo
        G4zEzv+rIum2VyUutGWNKso=
X-Google-Smtp-Source: ABdhPJxChHDi5YEGwztLITvE52CHBvCU6uu2HBWLPfaWurbR0Tdb4rMt3WKK0g4vrhfiZYsYtJ39NQ==
X-Received: by 2002:a17:907:c15:: with SMTP id ga21mr1550571ejc.472.1607511207929;
        Wed, 09 Dec 2020 02:53:27 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id dx7sm1112954ejb.120.2020.12.09.02.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 02:53:27 -0800 (PST)
Date:   Wed, 9 Dec 2020 12:53:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201209105326.boulnhj5hoaooppz@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87mtyo5n40.fsf@waldekranz.com>
 <20201208163751.4c73gkdmy4byv3rp@skbuf>
 <87k0tr5q98.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0tr5q98.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 09:37:39AM +0100, Tobias Waldekranz wrote:
> I will remove `struct dsa_lag` in v4.

Ok, thanks.
It would be nice if you could also make .port_lag_leave return an int code.
And I think that .port_lag_change passes more arguments than needed to
the driver.

> > I don't think the DSA switch tree is private to anyone.
>
> Well I need somewhere to store the association from LAG netdev to LAG
> ID. These IDs are shared by all chips in the tree. It could be
> replicated on each ds of course, but that does not feel quite right.

The LAG ID does not have significance beyond the mv88e6xxx driver, does
it? And even there, it's just a number. You could recalculate all IDs
dynamically upon every join/leave, and they would be consistent by
virtue of the fact that you use a formula which ensures consistency
without storing the LAG ID anywhere. Like, say, the LAG ID is to be
determined by the first struct dsa_port in the DSA switch tree that has
dp->bond == lag_dev. The ID itself can be equal to (dp->ds->index *
MAX_NUM_PORTS + dp->index). All switches will agree on what is the first
dp in dst, since they iterate in the same way, and any LAG join/leave
will notify all of them. It has to be like this anyway.
