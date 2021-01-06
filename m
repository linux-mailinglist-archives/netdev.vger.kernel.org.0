Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640A52EC1C8
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbhAFRJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbhAFRJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:09:04 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9059CC06134D
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 09:08:24 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id t16so5890222ejf.13
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 09:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JHTEjbraBDE/80VUF13QA3u17M0QYo3wbwfpnN3R5QE=;
        b=SIVLZEBO4hCcCsfPv+1ow07LzajJfL5GxjZ42bO/d5uw5UUkM4bcARWQB76XXLvEzK
         DfogK/u7EFfVy5hlhIn7Ua+6TGR+fNtlT5wdeJlnt+6bZbhdssspGx0iK889v8AcqIOq
         ElASjBdvpzhByDn/nIA8Z/cos1DDv7FnJHumfhpznfInOMj59ebbcfoJ0srtbe2QLjSN
         J0eqIb6BNLl5HIi2n5pyZgiKFGbOXEB27xyw7dH2mBSy7PfEoTRZHQd78ZlYNC8f48XQ
         L+fhS21Wdnt9VuNo8pZMHwwqmldZj5TVdEW+ToB5O03/sqnRqjBfJNGTlTv0NyP1s9g5
         fH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JHTEjbraBDE/80VUF13QA3u17M0QYo3wbwfpnN3R5QE=;
        b=J/UxxybHdCwevJeFitolhH8nj3gCFpcy1BYPa7wrhzgEZNrXUW4xPlz//6r2NR4Nr/
         b0qDD5I9Mh762WTnHbdazTQpkiT4einXw4rb/9hUIwq8fAWGM2GTkwRqALvV8VXel7BB
         SuQCGgqopciTzKZOn/ryZN856gjT/Y7PgmGdY5u3e6ohWRY+0yFArR+ApYRyJcIclDTS
         RLz+fTzUYOX6qI7kUvDV/92DOlvt2G/erxyWSWmZz0SGweUpYPaxTHsqzTkUwIkqy6lz
         MN3ZPoIHcwcerxPo9HT+bFk2fLIU3E2wfGhJr5X93b+ZzXO2WY1HpbSC3zvn7VoOvfLl
         MjTQ==
X-Gm-Message-State: AOAM5306+VEJYsr6sZ8h2mKa1oflEMBfMLQWxN9iUHD8c48Bue+g4mt8
        TjzTi+TwJRReATxtLqDnHvU=
X-Google-Smtp-Source: ABdhPJw9NMg4kcaaP6b/UO7aey4uu7hHKaNH9LIjgDF6N5+21YuUQL92Wq0iiMh32ajz45D+pmDkvA==
X-Received: by 2002:a17:906:1cd4:: with SMTP id i20mr3568790ejh.415.1609952903260;
        Wed, 06 Jan 2021 09:08:23 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id by30sm1686897edb.15.2021.01.06.09.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 09:08:22 -0800 (PST)
Date:   Wed, 6 Jan 2021 19:08:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH v2 net-next 01/10] net: switchdev: remove vid_begin ->
 vid_end range from VLAN objects
Message-ID: <20210106170821.z7m6ouapcij25y7w@skbuf>
References: <20210106131006.577312-2-olteanv@gmail.com>
 <202101062240.KXBT8Rcf-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202101062240.KXBT8Rcf-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 10:12:39PM +0800, kernel test robot wrote:
> static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
> 				    const struct switchdev_obj_port_vlan *vlan)
> {
> 	struct mv88e6xxx_chip *chip = ds->priv;
> 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> 	bool warn;
> 	u8 member;
> 	u16 vid;
> 
> 	if (!mv88e6xxx_max_vid(chip))
> 		return;
> 
> 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
> 		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED;
> 	else if (untagged)
> 		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNTAGGED;
> 	else
> 		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_TAGGED;
> 
> 	/* net/dsa/slave.c will call dsa_port_vlan_add() for the affected port
> 	 * and then the CPU port. Do not warn for duplicates for the CPU port.
> 	 */
> 	warn = !dsa_is_cpu_port(ds, port) && !dsa_is_dsa_port(ds, port);
> 
> 	mv88e6xxx_reg_lock(chip);
> 
> 	if (mv88e6xxx_port_vlan_join(chip, port, vlan->vid, member, warn))
> 		dev_err(ds->dev, "p%d: failed to add VLAN %d%c\n", port,
> 			vid, untagged ? 'u' : 't');

s/vid/vlan->vid/

Sorry about this. I'm superseding it with a v3.
