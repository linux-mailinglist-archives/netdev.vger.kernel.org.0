Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8A03A0680
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhFHWAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 18:00:22 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:44840 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbhFHWAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 18:00:21 -0400
Received: by mail-ed1-f44.google.com with SMTP id u24so26253556edy.11;
        Tue, 08 Jun 2021 14:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1GgIM9q2yv+S/hbk8Q7E6JbvUMBu7C8HzNxlIoVCmk0=;
        b=CdxDwO0i61xJE4WZR0yWRqXWpvbHZ4F57wswSDvCELatiFaKDsOayisBbkrUlXFzf/
         kz7nvmQtqPorajhf50xRVcly9eLEo/4MTyXm5XkTmcZqqBPUHIHzJ/sBgWk9f9YDd/0f
         2B+fSuSwfY87yghlqID+fTia/adY7ynIXWfErBqSApFLojNPqj5Wu451SUjmbJy0TEVP
         FBub2eCuk7sQdn+c6x2KF26y90Q6ITjTKXZfZ1LmVQ8mFcLIgo83VLjS6JTiUdAtMlKV
         SXYV9ccFtVeEYadzH7Hq6DrXMhJTNqFkJzESo60wRApYwFa5tY2uQMIBRxoTpgUGoY59
         Mr2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1GgIM9q2yv+S/hbk8Q7E6JbvUMBu7C8HzNxlIoVCmk0=;
        b=LXtRlzLJosTAW0TaUHPOtgOZEfCgPKofPlrNTIuh2FtUwgc8OMdYA7yssLqcZlgN23
         ilEm+wKJDlRlj9ainq0xWr4OouT3kiEDEhuaysiIDXpiwVJPHnyTVd/VtKQ+nFHhFC5p
         itVVWFjZQjdhGiUDKlJYVhdDXJ6NtmRaddjwlH3TPQ/66s7Xtxhel676DDtbsZdCN3vM
         1ZLTrnJb4V7lqybkSzxqvl7Sib6tRrRZdcNXSCchAGZpK87eUi7KIZTEdPGxaXjd0bGM
         bl6kK4rgvi26Rckzbv3efwnMV6a1zRPX4T/UX/+22ZG6CnSyM0taSnHZeD+VRO5T24Uq
         076A==
X-Gm-Message-State: AOAM531qYvfzVOhlp6PT7gm4QDYslhpd6Jlih7wIzjJPbZgBdAnRvxlX
        mQUqwN8doHIU4ew4ic8+mP+XbfNzJQw=
X-Google-Smtp-Source: ABdhPJz0I8y0Zosfr0ARoXE+tH2lDvOKJ+YV+0JSQaMjjok+0ByKOBo0RxuMdMcaYtMkYL4ZRQe30Q==
X-Received: by 2002:a05:6402:51c9:: with SMTP id r9mr28249608edd.238.1623189433848;
        Tue, 08 Jun 2021 14:57:13 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id v4sm325401ejh.86.2021.06.08.14.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 14:57:13 -0700 (PDT)
Date:   Wed, 9 Jun 2021 00:57:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, mnhagan88@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: dsa: b53: Do not force CPU to be always
 tagged
Message-ID: <20210608215712.3ae24qudzvbzknww@skbuf>
References: <20210608212204.3978634-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608212204.3978634-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 02:22:04PM -0700, Florian Fainelli wrote:
> Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
> VLANs") forced the CPU port to be always tagged in any VLAN membership.
> This was necessary back then because we did not support Broadcom tags
> for all configurations so the only way to differentiate tagged and
> untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
> port into being always tagged.
> 
> With most configurations enabling Broadcom tags, especially after
> 8fab459e69ab ("net: dsa: b53: Enable Broadcom tags for 531x5/539x
> families") we do not need to apply this unconditional force tagging of
> the CPU port in all VLANs.
> 
> A helper function is introduced to faciliate the encapsulation of the
> specific condition requiring the CPU port to be tagged in all VLANs and
> the dsa_switch_ops::untag_bridge_pvid boolean is moved to when
> dsa_switch_ops::setup is called when we have already determined the
> tagging protocol we will be using.
> 
> Reported-by: Matthew Hagan <mnhagan88@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
