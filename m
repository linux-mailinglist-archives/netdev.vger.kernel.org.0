Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF2716151B
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgBQOwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:52:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30951 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728375AbgBQOwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:52:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581951119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/NoWh0zn9jWJMB5I+rtK46UqFrT287gQNYFOr27dFUg=;
        b=a7hpgbxhCrY0XB/gg9TAVU3KhlQ59jrc2lnjxdfhOTSzHfw+VzE8s7vMe5WY6oqHLDiwlG
        hshgif2M8LMkFl5RcxOB7L0R392cAanvmsQ/+sh893AxIyJEXb7K58Jyi8Q4PAABOP4BpT
        xF36QcepQgb7gExeDJ01TOaSgV0i7bI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-XH_M8WsZP5i6dbm-sWHrdg-1; Mon, 17 Feb 2020 09:51:50 -0500
X-MC-Unique: XH_M8WsZP5i6dbm-sWHrdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C20FF13E4;
        Mon, 17 Feb 2020 14:51:48 +0000 (UTC)
Received: from carbon (ovpn-200-53.brq.redhat.com [10.40.200.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7402319C69;
        Mon, 17 Feb 2020 14:51:40 +0000 (UTC)
Date:   Mon, 17 Feb 2020 15:51:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        David Ahern <dsahern@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH net-next 4/5] net: mvneta: introduce xdp counters to
 ethtool
Message-ID: <20200217155139.6363aa52@carbon>
In-Reply-To: <20200217130515.GE32734@lunn.ch>
References: <cover.1581886691.git.lorenzo@kernel.org>
        <882d9f03a8542cceec7c7b8e6d083419d84eaf7a.1581886691.git.lorenzo@kernel.org>
        <20200217111718.2c9ab08a@carbon>
        <20200217102550.GB3080@localhost.localdomain>
        <20200217113209.2dab7f71@carbon>
        <20200217130515.GE32734@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Feb 2020 14:05:15 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Mon, Feb 17, 2020 at 11:32:09AM +0100, Jesper Dangaard Brouer wrote:
> > On Mon, 17 Feb 2020 11:25:50 +0100
> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> >   
[...]
> > > 
> > > yes, I think it is definitely better. So to follow up:
> > > - rename current "xdp_tx" counter in "xdp_xmit" and increment it for
> > >   XDP_TX verdict and for ndo_xdp_xmit
> > > - introduce a new "xdp_tx" counter only for XDP_TX verdict.
> > > 
> > > If we agree I can post a follow-up patch.  
> > 
> > I agree, that sounds like an improvement to this patchset.
> > 
> > 
> > I suspect David Ahern have some opinions about more general stats for
> > XDP, but that it is a more general discussion, that it outside this
> > patchset, but we should also have that discussion.  
> 
> Hi Jesper
> 
> I've not been following XDP too much, but xdp_xmit seems pretty
> generic. It would be nice if all drivers used the same statistics
> names. Less user confusion that way. So why is this outside of the
> discussion?

I do want to have this discussion, please.

I had hoped this patchset sparked this that discussion... maybe we can
have it despite this patchset already got applied?

My only request is that, if we don't revert, we fixup the "xdp_tx"
counter name.  It would make it easier for us[1] if we can keep them
applied, as we are preparing (asciinema) demos for [1].

That said, I think it is rather important to standardize on same
statistics names across drivers... which is an assignment that Lorenzo
have already signed up for [2].


[1] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to-a-NIC-driver
[2] https://github.com/xdp-project/xdp-project/blob/master/planning.org#consistency-for-statistics-with-xdp
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

