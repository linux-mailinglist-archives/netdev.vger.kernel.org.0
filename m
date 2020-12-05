Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6561B2CF8D0
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgLEBuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 20:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgLEBuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 20:50:16 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF5AC0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 17:49:30 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b2so7785403edm.3
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 17:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GD1sYDhJr0sOpnRPAOT7cG583JM5wjDdBcGg94KbwuY=;
        b=PQGUjy2+Cx2SvH7OhAtMqeKAiW08MBkh1iZ6GHgZfSL3DeflfIqE6rZ+S6lxcGquAq
         5jJygDSPRWKtDQNWaiytQKGt9OpCDMh1dC8bF8pdch4wjouyLHSQuj05TxAQO7EdfjI5
         r+el5uGNrB5T0QhatZ6jAmwhPsSYPbjx3xfT2WKBrJwXIh8TCno56Jux7Fvl1F0xiRLg
         HX3yGnD8+iUAD5zds7dGstzJQ0bvZW1htuCBj509CdLj6SVIc+c4s0IdqhxY/vqqPT6G
         fRUVILghJ4YzT3DCkVqLGhV2kYyzGM85/QTIvFo0e+RULsmBkwT6HoJoVIdTKG/0LqVJ
         JhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GD1sYDhJr0sOpnRPAOT7cG583JM5wjDdBcGg94KbwuY=;
        b=sB091wejNEEL2WqYNDzbAiKpVuGE/Lvb4rb5tYqQvDdldGINQMOzzxdXycB4rvH55r
         aVu8ySQQC4yLH6TaVIE5yJVy9iC0ssmiB4mSwp/7r2Dr5GKbzRE0p68jhQvtoVFjGGrz
         b7tZnlWFhT4zCIBky+0NXfaPekXhSlub2YYgfiGo++raw8kjCrQqs9ZMeXUbZeGf6C8e
         uvoxTa3GSo8rtjpt9B+7LF0KLr7rLP5EF/u1Iv5sp7BuxGUVuYOpevAYZrc7WNJCeRoH
         SV9y58GhVqCEPBt3CRwKuakxraneCTxrQEenCwmsH5rzNd5XBnvhFo3G1jeFW5thwJZD
         Ehmw==
X-Gm-Message-State: AOAM530oSDNyb+OdQT8XrD4ZL3/qgtcuCfiWugCnyTGoaYRA+BqN9X7b
        KTK2WeS22qX/X45TSHlwaHA=
X-Google-Smtp-Source: ABdhPJyz4M34gyaj1GYA0PPvNAkDy7CgeeeDTtPonJATpozj8UaQBHZ9zjxx60GyrLbGCwTtp5knfw==
X-Received: by 2002:aa7:cb02:: with SMTP id s2mr10324696edt.211.1607132969411;
        Fri, 04 Dec 2020 17:49:29 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id bn21sm1958779ejb.47.2020.12.04.17.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 17:49:28 -0800 (PST)
Date:   Sat, 5 Dec 2020 03:49:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201205014927.bna4nib4jelwkxe7@skbuf>
References: <20201203042108.232706-1-saeedm@nvidia.com>
 <20201203042108.232706-9-saeedm@nvidia.com>
 <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
 <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 12:26:13PM -0800, Jakub Kicinski wrote:
> On Fri, 04 Dec 2020 11:33:26 -0800 Saeed Mahameed wrote:
> > On Thu, 2020-12-03 at 18:29 -0800, Jakub Kicinski wrote:
> > > On Wed, 2 Dec 2020 20:21:01 -0800 Saeed Mahameed wrote:
> > > > Add TX PTP port object support for better TX timestamping accuracy.
> > > > Currently, driver supports CQE based TX port timestamp. Device
> > > > also offers TX port timestamp, which has less jitter and better
> > > > reflects the actual time of a packet's transmit.
> > >
> > > How much better is it?
> > >
> > > Is the new implementation is standard compliant or just a "better
> > > guess"?
> >
> > It is not a guess for sure, the closer to the output port you take the
> > stamp the more accurate you get, this is why we need the HW timestamp
> > in first place, i don't have the exact number though, but we target to
> > be compliant with G.8273.2 class C, (30 nsec), and this code allow
> > Linux systems to be deployed in the 5G telco edge. Where this standard
> > is needed.
>
> I see. IIRC there was also an IEEE standard which specified the exact
> time stamping point (i.e. SFD crosses layer X). If it's class C that
> answers the question, I think.

The ITU-T G.8273.2 specification just requires a Class C clock to have a
maximum absolute time error under steady state of 30 ns. And taking
timestamps closer to the wire eliminates some clock domain crossings
from what is measured in the path delay, this is probably the reason why
timestamping is more accurate, and it helps to achieve the required
jitter figure.

The IEEE standard that you're thinking of is clause "7.3.4 Generation of
event message timestamps" of IEEE 1588.

-----------------------------[cut here]-----------------------------
7.3.4.1 Event message timestamp point

Unless otherwise specified in a transport-specific annex to this
standard, the message timestamp point for an event message shall be the
beginning of the first symbol after the Start of Frame (SOF) delimiter.

7.3.4.2 Event timestamp generation

All PTP event messages are timestamped on egress and ingress. The
timestamp shall be the time at which the event message timestamp point
passes the reference plane marking the boundary between the PTP node and
the network.

NOTE 1— If an implementation generates event message timestamps using a
point other than the message timestamp point, then the generated
timestamps should be appropriately corrected by the time interval
between the actual time of detection and the time the message timestamp
point passed the reference plane. Failure to make these corrections
results in a time offset between the slave and master clocks.
-----------------------------[cut here]-----------------------------

So there you go, it just says "the reference plane marking the boundary
between the PTP node and the network". So it depends on how you draw the
borders. I cannot seem to find any more precise definition.

Regardless of the layer at which the timestamp is taken, it is the
jitter that matters more than the reduced path delay. The latter is just
a side effect.

"How much better" is an interesting question though.
