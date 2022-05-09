Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCE851F643
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbiEIH6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiEIHoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:44:37 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038F0D96;
        Mon,  9 May 2022 00:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1652082045; x=1683618045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QTHY//D2kCJcGfjjQQ29xj9+Qvuho9wSSnjlq8Fi0Ao=;
  b=colpFVTDniE2xyXZmblIu/jF973j9XoRXJjUm2X5Vl+rO1JndnwTJTef
   KtVp40N/lrtvN9ldpBxs3y8uJYarA3R2m2kmA7pcal9DkB6RfwMYWkVnM
   4LxA+c/LroBUvDCFkADsytkvghXJ0GjawkkKVz43V4MOV9cONBZTLd7Av
   Y=;
X-IronPort-AV: E=Sophos;i="5.91,210,1647302400"; 
   d="scan'208";a="201065087"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-c275e159.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 09 May 2022 07:39:27 +0000
Received: from EX13D08EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-c275e159.us-west-2.amazon.com (Postfix) with ESMTPS id 23C40829A6;
        Mon,  9 May 2022 07:39:26 +0000 (UTC)
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08EUC001.ant.amazon.com (10.43.164.184) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Mon, 9 May 2022 07:39:24 +0000
Received: from dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (10.15.60.66)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.32 via Frontend Transport; Mon, 9 May 2022 07:39:23 +0000
Received: by dev-dsk-mheyne-1b-c1524648.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id C2D8B41135; Mon,  9 May 2022 07:39:21 +0000 (UTC)
From:   Maximilian Heyne <mheyne@amazon.de>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Maximilian Heyne <mheyne@amazon.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] drivers, ixgbe: show VF statistics
Date:   Mon, 9 May 2022 07:39:15 +0000
Message-ID: <20220509073915.28476-1-mheyne@amazon.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <7775a23b-199e-b0f2-fe6b-06a667ac9dee@intel.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-06T09:20:14-07:00   Tony Nguyen <anthony.l.nguyen@intel.com> wro=
te:
> On 5/6/2022 9:13 AM, Jakub Kicinski wrote:
> > On Fri, 6 May 2022 06:44:40 +0000 Maximilian Heyne wrote:
> >> On 2022-05-04T20:16:32-07:00   Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >>> On Tue, 3 May 2022 15:00:17 +0000 Maximilian Heyne wrote:
> >>>> +		for (i =3D 0; i < adapter->num_vfs; i++) {
> >>>> +			ethtool_sprintf(&p, "VF %u Rx Packets", i);
> >>>> +			ethtool_sprintf(&p, "VF %u Rx Bytes", i);
> >>>> +			ethtool_sprintf(&p, "VF %u Tx Packets", i);
> >>>> +			ethtool_sprintf(&p, "VF %u Tx Bytes", i);
> >>>> +			ethtool_sprintf(&p, "VF %u MC Packets", i);
> >>>> +		}
> >>>
> >>> Please drop the ethtool stats. We've been trying to avoid duplicating
> >>> the same stats in ethtool and iproute2 for a while now.
> >>
> >> I can see the point that standard metrics should only be reported via =
the
> >> iproute2 interface. However, in this special case this patch was
> >> intended to converge the out-of-tree driver with the in-tree version.
> >> These missing stats were breaking our userspace. If we now switch
> >> solely to iproute2 based statistics both driver versions would
> >> diverge even more. So depending on where a user gets the ixgbe driver
> >> from, they have to work-around.
> >>
> >> I can change the patch as requested, but it will contradict the inital
> >> intention. At least Intel should then port this change to the
> >> external driver as well. Let's get a statement from them.
> =

> We discussed this patch internally and concluded the correct approach =

> would be to not have the ethtool stats and use the VF info. Jakub beat =

> us to the comment. We would plan to port the iproute implementation to =

> OOT as well.

Ok, then I'll send a follow-up patch without the ethtool changes. I'm happy=
 to
get some kind of convergence between the out-of-tree driver and upstream. =


While at it, I wonder whether other drivers need similar changes as well and
what other features are missing in the upstream driver. There should be no
surprises when switching between these drivers.

> =

> > Ack, but we really want people to move towards using standard stats.
> > =

> > Can you change the user space to first try reading the stats via
> > iproute2/rtnetlink? And fallback to random ethtool strings if not
> > available? That way it will work with any driver implementing the
> > standard API. Long term that'll make everyone's life easier.

Yes, in this case we are in control of user space and can work around.

> > =

> > Out-of-tree code cannot be an argument upstream, otherwise we'd
> > completely lose control over our APIs. Vendors could ship whatever
> > in their out of tree repo and then force us to accept it upstream.
> > =

> > It's disappointing to see the vendor letting the uAPI of the out of
> > tree driver diverge from upstream, especially a driver this mature.
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



