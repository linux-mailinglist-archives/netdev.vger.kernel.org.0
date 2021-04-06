Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEAC356083
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245522AbhDGA5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbhDGA5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 20:57:41 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D787CC06174A;
        Tue,  6 Apr 2021 17:57:32 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id mh7so14840296ejb.12;
        Tue, 06 Apr 2021 17:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OECY3yig9AVogbfPFflyIgKwhgrAYh7uO4GURi6uSqE=;
        b=ia4c3aHw7V5EWYaJ4KF9mGJXZ4zouKPc4J3o4xHGucNRberjEdxRHuv7GwDYgVUnTp
         c3AxrOXBurS/47WCwTe+j8krI4r9Bxx0z9NXkxOZPckt4hqqhHYLICne1ceGPwe8fzWG
         vAHLnpud3+DMSQ6S54UoTFT2fIhcgoORET/uq9DUgnaPfm5HrVd9I4PAEtefG5AHR/mk
         XoZx7BBAsuLu2tb+Jlds6Cienaxr1ppo9uDfFMyBaBStzi7ljX+tSLq3Lrc81ILjAoy6
         69AXb7sYxCIKpv+S+MRmFPw4bX+aRJYRJmMJHS9i0zH/xR9CeNF8STylvki9Eox2176M
         reBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OECY3yig9AVogbfPFflyIgKwhgrAYh7uO4GURi6uSqE=;
        b=sCwvgJDahjo0ZkmZ0N9nHWkJDPpPkhqT6Oyk6JD5ZV9CUL+Nuoss/oLmy3vI+FIOkC
         6UJc58mOBJizX68wNChvhmcWi2ebp1T3ocBhnLvhkZoS8U9LQeXNqNyapzfhkjhYzPAY
         mA5KbdGJlGF2U93DSqEKk16UkVqG5FjH+JQXHLghKb9UbBgOhCRE/FjvledV56tKljPp
         qtftPcFWjpl3t5eQH3dmiao5Kbc9bl2rlVPESg8pgcocTre7x1yOqszuq0cRp7KjXmHq
         pwSKof/6A5TNZqYK1fq5ijzi7Qw/eMtLwKGo9MHIvGcvpzuk8X/mY0ZyKsd+OzDJjvJp
         Paew==
X-Gm-Message-State: AOAM530ZenIBzpWn78v99n9H3ql02tsTC0B45VOwfKFqdVjH9p6Cuca7
        sZYw0Qe+nTVTi/uqRlkWWZg=
X-Google-Smtp-Source: ABdhPJwiAKeB9iAuJY4hsh5Sq5Tk7wEkpx/a5IX7LtMJxifF1qLRivLo6EOWuP6mCQ2k9/gfY116sg==
X-Received: by 2002:a17:906:77c5:: with SMTP id m5mr781186ejn.201.1617757051479;
        Tue, 06 Apr 2021 17:57:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-95-247-95-137.retail.telecomitalia.it. [95.247.95.137])
        by smtp.gmail.com with ESMTPSA id l9sm6263855edw.68.2021.04.06.17.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 17:57:30 -0700 (PDT)
Date:   Tue, 6 Apr 2021 07:16:08 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] drivers: net: dsa: qca8k: add support for
 multiple cpu port
Message-ID: <YGvumGtEJYYvTlc9@Ansuel-xps.localdomain>
References: <20210406045041.16283-1-ansuelsmth@gmail.com>
 <20210406045041.16283-2-ansuelsmth@gmail.com>
 <YGz/nu117LDEhsou@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGz/nu117LDEhsou@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 02:41:02AM +0200, Andrew Lunn wrote:
> On Tue, Apr 06, 2021 at 06:50:40AM +0200, Ansuel Smith wrote:
> > qca8k 83xx switch have 2 cpu ports. Rework the driver to support
> > multiple cpu port. All ports can access both cpu ports by default as
> > they support the same features.
> 
> Do you have more information about how this actually works. How does
> the switch decide which port to use when sending a frame towards the
> CPU? Is there some sort of load balancing?
> 
> How does Linux decide which CPU port to use towards the switch?
> 
>     Andrew

I could be very wrong, but in the current dsa code, only the very first
cpu port is used and linux use only that to send data.
In theory the switch send the frame to both CPU, I'm currently testing a
multi-cpu patch for dsa and I can confirm that with the proposed code
the packets are transmitted correctly and the 2 cpu ports are used.
(The original code has one cpu dedicated to LAN ports and one cpu
dedicated to the unique WAN port.) Anyway in the current implementation
nothing will change. DSA code still supports one cpu and this change
would only allow packet to be received and trasmitted from the second
cpu.

