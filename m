Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2A610D3C0
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 11:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfK2KQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 05:16:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26685 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726360AbfK2KQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 05:16:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575022588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51S0qrxzGX1v8Ds8JGQLgzBVgjmZY5SfY6B34XQaXIA=;
        b=G6rbdLnOz7EMazxc5Ma0It/tvNMXH67qAptdPcTHtxC+06bJBQkI0vx8vK6G+Unx6SlPap
        qzjx/9jsPsqRSN7grVXfrI4rXnljHk0tFb521OXmx7YjKfbuhEFv8NepWK9TLMLxvWAzGr
        lH4DE28XhaQqa7VI2qCZ+7jqFkp8KFk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-Cpue7tWQNQuCJcr7prlqjQ-1; Fri, 29 Nov 2019 05:16:25 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C220BDBA3;
        Fri, 29 Nov 2019 10:16:23 +0000 (UTC)
Received: from ovpn-118-51.ams2.redhat.com (unknown [10.36.118.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EA5110013A7;
        Fri, 29 Nov 2019 10:16:22 +0000 (UTC)
Message-ID: <28ce014f1257f16e2cc5a1ebcedad0168f04b631.camel@redhat.com>
Subject: Re: [PATCH net 1/2] openvswitch: drop unneeded BUG_ON() in
 ovs_flow_cmd_build_info()
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org
Date:   Fri, 29 Nov 2019 11:16:21 +0100
In-Reply-To: <20191128.131700.1033448847172021072.davem@davemloft.net>
References: <cover.1574769406.git.pabeni@redhat.com>
         <a5a946ce525d00f927c010fca7da675ddc212c97.1574769406.git.pabeni@redhat.com>
         <20191128.131700.1033448847172021072.davem@davemloft.net>
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: Cpue7tWQNQuCJcr7prlqjQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-11-28 at 13:17 -0800, David Miller wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> Date: Tue, 26 Nov 2019 13:10:29 +0100
> 
> > All callers already deal with errors correctly, dump a warn instead.
> > 
> > Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  net/openvswitch/datapath.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> > index d8c364d637b1..e94f675794f1 100644
> > --- a/net/openvswitch/datapath.c
> > +++ b/net/openvswitch/datapath.c
> > @@ -882,7 +882,7 @@ static struct sk_buff *ovs_flow_cmd_build_info(const struct sw_flow *flow,
> >       retval = ovs_flow_cmd_fill_info(flow, dp_ifindex, skb,
> >                                       info->snd_portid, info->snd_seq, 0,
> >                                       cmd, ufid_flags);
> > -     BUG_ON(retval < 0);
> > +     WARN_ON_ONCE(retval < 0);
> >       return skb;
> >  }
> 
> I don't think this is right.  We should propagate the error by freeing the skb
> and returning a proper error pointer based upon retval.

Indeed you are right. Thank you for catching this.

Never cook patches when coffee is too low :/

Will send a v2

Thank you!

Paolo


