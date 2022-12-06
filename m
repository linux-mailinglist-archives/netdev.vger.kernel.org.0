Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A22644926
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbiLFQ0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiLFQ0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:26:01 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7722981F;
        Tue,  6 Dec 2022 08:26:00 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id e13so20995195edj.7;
        Tue, 06 Dec 2022 08:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ViQYjW1jYkpQ2+Xc5Y6fwo4Stf0Elolu0/yZsrAy48=;
        b=H4lUG3gOM5sTbfhgudKZ1J1OlMQuJTGv+gCztYmFNmxXkmHdALNXy5tMoe1oeSVkD0
         EhgOJfF5raKo+SUinm3p4eIDK9dh5CfIZH79Xac2Qd3TkXUvNRfaIqqESID7bF4zN6oK
         dEdW1Fgg5j2U6+ecv0AYDzA2uFAxM1N0CHGQHeqzzAaBpR1Yj4D8fEdfS+CyZ/O6pFBi
         CqEC62abGZn3YkQJrVxgqkVzdjzBMzdEZzqjReTt5eKj2lyZfQOOk7Hxljcs2tHHEvrR
         hEKgvX1Ywh/pKFDVSS0S/BLRKSfc7YvKIJ1nxd0aQjno5DIDJtsHfholo4gzmEtKgh1U
         S01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ViQYjW1jYkpQ2+Xc5Y6fwo4Stf0Elolu0/yZsrAy48=;
        b=cc7+3JqwgKqyutmfYa9xVvjEd2t8elcfTX6PL4hICH8ULxXhTdjPQFbWVfPzZ1BTmN
         qEbAwCz6BX32EVa0wiWNr7H7YiOtJg034CD/3ad9BOfmD8eb4H0T/OjLycmhByey3puB
         2YIvUp19h8aXtzlpNQ7Du7FBjURbA4qNz+NYf0eSplSMsMG2O8isuln2BWZceoB7rDv1
         yjm9XzpgadccrQPmfJ4M263ntw/xu68WsmmHYp9XRdnj39dqaaMTTbba/IBMxyAvDV7G
         rVI2xShLpIb9JPhUglddhkgmNOOftRZYVB1svXWBhVDWP3hbEjk44772lOuPqdCiC5jW
         Y8xQ==
X-Gm-Message-State: ANoB5pmVSx88Jip9asW3aDB1awUI91r4bM+A7OAMi9iPEx19XR5YIQvE
        +BwtjJtt7I9G8EVXm27n6hg=
X-Google-Smtp-Source: AA0mqf5Oxb98rjN5v25OlaRPuvniN9NYq+HO0r/Wcmfq932mmgmnboLJlOBWoHcrs6Acp+onFY6d9w==
X-Received: by 2002:aa7:d7c4:0:b0:46c:751a:faad with SMTP id e4-20020aa7d7c4000000b0046c751afaadmr11846895eds.163.1670343958817;
        Tue, 06 Dec 2022 08:25:58 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id lb26-20020a170907785a00b00781e7d364ebsm7624651ejc.144.2022.12.06.08.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 08:25:58 -0800 (PST)
Date:   Tue, 6 Dec 2022 18:25:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        f.fainelli@gmail.com, Radu Pirea <radu-nicolae.pirea@nxp.com>
Subject: Re: [PATCH] net: dsa: sja1105: fix slab-out-of-bounds in
 sja1105_setup
Message-ID: <20221206162556.ibgw6xyi7jnjwbsg@skbuf>
References: <20221206151136.802344-1-radu-nicolae.pirea@oss.nxp.com>
 <Y49oaMcgstaa+l5G@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49oaMcgstaa+l5G@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:06:00PM +0100, Greg KH wrote:
> On Tue, Dec 06, 2022 at 05:11:36PM +0200, Radu Nicolae Pirea (OSS) wrote:
> > From: Radu Pirea <radu-nicolae.pirea@nxp.com>
> > 
> > Fix slab-out-of-bounds in sja1105_setup.
> > 
> > Kernel log:
> 
> <snip>
> 
> This log doesn't say much, sorry.  Please read the kernel documentation
> for how to write a good changelog text and how to submit a patch to the
> stable trees (hint, this isn't how...)

Agree with Greg.

The commit description should say that the SJA1105 family has 45 L2
policing table entries (SJA1105_MAX_L2_POLICING_COUNT) and SJA1110 has
110 (SJA1110_MAX_L2_POLICING_COUNT). Keeping the table structure but
accounting for the difference in port count (5 in SJA1105 vs 10 in SJA1110)
does not fully explain the difference. Rather, the SJA1110 also has L2
ingress policers for multicast traffic. If a packet is classified as
multicast, it will be processed by the policer index 99 + SRCPORT.

The sja1105_setup() function initializes all L2 policers such that they
don't interfere with normal packet reception by default. To have common
code between SJA1105 and SJA1110, the index of the multicast policer for
the port is calculated, and because it's an index that is out of bounds
for SJA1105 but in bounds for SJA1110, a bounds check is performed.

The code fails to do the proper thing when determining what to do with
the multicast policer of port 0 on SJA1105 (ds->num_ports = 5). The
"mcast" index will be equal to 45, which is also equal to
table->ops->max_entry_count (SJA1105_MAX_L2_POLICING_COUNT). So it
passes through the check. But at the same time, SJA1105 doesn't have
multicast policers. So the code programs the SHARINDX field of an
out-of-bounds element in the L2 Policing table of the static config.

The comparison between index 45 and 45 entries should have determined
the code to not access this policer index on SJA1105, since its memory
wasn't even allocated.

With enough bad luck, the out of bounds write could even overwrite other
valid kernel data, but in this case the issue was detected using KASAN.

Or something like that. The point is that you should use the commit
description to prove to yourself (and also to readers) that the change
is correct.
