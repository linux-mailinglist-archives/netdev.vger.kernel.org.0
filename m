Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BD52CA4E6
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388529AbgLAOEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388154AbgLAOEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:04:45 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A09C0613D4
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 06:03:59 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id qw4so4262027ejb.12
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 06:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ww1jZFSmoMN0V30+nLf3dGp1lFwul5jr4mGyVa+aU4I=;
        b=r256wXC0BpfsizDxi3OwyyQptmSF7HzQ9HDnabO9f3R3FMl2049tFh4TUhKI7mposq
         0dZDSa8bIuUapkKgvXygY+Wg8+OqFse8V+KlKOIOccWqT4JUnxT4DMlTr4eZpU0klZHG
         z+nsKCwvF5nrdd1dBZZre6pEpsaUUqb7VovFyDoeqwKTi+8pJwe6K3pODXEa2c94LlGG
         MLUkru8jno5KfNmjpoLXdfeioHl4BOwDoKZlk5JdLLJQZDkS9sLNJSMr7uKfcjc5319s
         UxndobCKYk07cl6mqcHS01JRc5mLt+C3NYl1khzZkYbFSkxmz1LdoRpZ9+gWPFMXZgaL
         vaiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ww1jZFSmoMN0V30+nLf3dGp1lFwul5jr4mGyVa+aU4I=;
        b=T4Cv9vBeU6o+/o5gbW2dL3sYezRKjYKD80ezYRtTB4RL3ZDETraTaV5NTZF8i1VZlY
         yE3T2E4mAgHs6GIkMW7H/u5j4eKnU9yXh2nAk/xBbox8SVu6P4E7hzs0xcWwHkOCfNHA
         fqAp6atSR6RYwzfQXf5bTZrTdTPfHg0kU9aMBGPcvXn9A2WDxcaxEQ9bBv0/zMCXIpl4
         P7teIXTgyzDwt5xc94GE0bjUQjW4oYjzJ43Zr7QcyNOHgCHpVRyY317UUsiEwcM99qXW
         GdpLYeLTdq6AjlBC+r1JdgOeV0iSFFoN+ANGMaOzSKXjHiONTLHdp6ljd1Z1DUcef3tJ
         5Viw==
X-Gm-Message-State: AOAM533O3zkP+LZCLAdZLH5NxACFwJbgUWqL4FcdIdRdIPm6fKRkV8oZ
        XX6KYj5XvVDVDSk+BOsBBnk=
X-Google-Smtp-Source: ABdhPJxnNPOVnx03K/r5iiLlcO9NliYmnqmHemaBC879sj4O1E3G2hYOqzPJgaLEASfT4AmcV+Dm9A==
X-Received: by 2002:a17:906:7087:: with SMTP id b7mr3090414ejk.70.1606831436222;
        Tue, 01 Dec 2020 06:03:56 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id t26sm893077eji.22.2020.12.01.06.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 06:03:55 -0800 (PST)
Date:   Tue, 1 Dec 2020 16:03:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201201140354.lnhwx3ix2ogtnngy@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com>
 <20201130140610.4018-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130140610.4018-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 03:06:08PM +0100, Tobias Waldekranz wrote:
> When a LAG joins a bridge, the DSA subsystem will treat that as each
> individual port joining the bridge. The driver may look at the port's
> LAG pointer to see if it is associated with any LAG, if that is
> required. This is analogue to how switchdev events are replicated out
> to all lower devices when reaching e.g. a LAG.

Agree with the principle. But doesn't that mean that this code:

static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
					      unsigned long event, void *ptr)
{
	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
	int err;

	switch (event) {
	case SWITCHDEV_PORT_OBJ_ADD:
		err = switchdev_handle_port_obj_add(dev, ptr,
						    dsa_slave_dev_check,
						    dsa_slave_port_obj_add);
		return notifier_from_errno(err);
	case SWITCHDEV_PORT_OBJ_DEL:
		err = switchdev_handle_port_obj_del(dev, ptr,
						    dsa_slave_dev_check,
						    dsa_slave_port_obj_del);
		return notifier_from_errno(err);
	case SWITCHDEV_PORT_ATTR_SET:
		err = switchdev_handle_port_attr_set(dev, ptr,
						     dsa_slave_dev_check,
						     dsa_slave_port_attr_set);
		return notifier_from_errno(err);
	}

	return NOTIFY_DONE;
}

should be replaced with something that also reacts to the case where
"dev" is a LAG? Like, for example, I imagine that a VLAN installed on a
bridge port that is a LAG should be propagated to the switch ports
beneath that LAG. Similarly for all bridge attributes.

As for FDB and MDB addresses, I think they should be propagated towards
a "logical port" corresponding to the LAG upper. I don't know how the
mv88e6xxx handles this.
