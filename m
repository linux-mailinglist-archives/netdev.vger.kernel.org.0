Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF4417C548
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCFSWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:22:48 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54609 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgCFSWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 13:22:48 -0500
Received: by mail-wm1-f68.google.com with SMTP id i9so3524048wml.4
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 10:22:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=IiwfDmAjy/RlSoWbBssHYmcZ3ToCqDIEmww1DB7Dhns=;
        b=si+JOlYFMNNVM20UzStIeCv0cZBnHec+1MUWUXvL4yQv0n/0ZbZzRk0fPefAB2Nb/Q
         mnDZ06I7rCjXrgTML3Io8HcNFkLMG7JonAq9AQDDsF8B1s4x7uXYw7HokAbpo2FfsAdn
         GDDCjlgGQFHPqObMZ09eUYZaV3woMl308baN54d5xy1pEQ3YuQQ/J4sdQFTpGfnu3dkJ
         Ik0cQZ5+KfXWPteRnlyr0c42hMRjCLJ1ni91RsDfg2K6qoouCV9lmiKTLWdOUXIdY57a
         8vIFmTvs2fn/JqByh86uqHPfzXBabe03VCYkQEWKRxEUnSU32tjxt8r9WFBo2oXuskZy
         KjJA==
X-Gm-Message-State: ANhLgQ0VqZNW/DWAdaFuqQYoYfhnkoQHGs+35ryMPc3cud7re9Q3ohFR
        QxhBOAwbNvCxxHqtaUSG8X9x1MKx
X-Google-Smtp-Source: ADFU+vtOr1glvMrdx+x2E/ekYp/5ZF81knOvnstZIqezrjrsIZxGiVyWmnGaYTiSgVvgmQA/FbavtQ==
X-Received: by 2002:a7b:cc14:: with SMTP id f20mr4893582wmh.132.1583518964800;
        Fri, 06 Mar 2020 10:22:44 -0800 (PST)
Received: from debian (41.142.6.51.dyn.plus.net. [51.6.142.41])
        by smtp.gmail.com with ESMTPSA id x8sm38832673wro.55.2020.03.06.10.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 10:22:43 -0800 (PST)
Date:   Fri, 6 Mar 2020 18:22:41 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>, netdev@vger.kernel.org,
        "ilias.apalodimas" <ilias.apalodimas@linaro.org>,
        wei.liu@kernel.org, paul@xen.org
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
Message-ID: <20200306182241.43uocmmodfoaf4jo@debian>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
 <f8aa7d34-582e-84de-bf33-9551b31b7470@suse.com>
 <CAOJe8K28BZCW7JDejKgDELR2WPfBgvj-0aJJXX9uCRnryGY+xg@mail.gmail.com>
 <c5cd0349-69b3-41e9-7fb1-d7909e659717@suse.com>
 <CAOJe8K0HuKyAi5YJwsWMcAJEp-Vkhbgvvg=RRcZZ8V6uqGzczw@mail.gmail.com>
 <b8c15b45-df1e-6f77-a36b-beacec7e70b6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8c15b45-df1e-6f77-a36b-beacec7e70b6@suse.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 11:33:48AM +0100, Jürgen Groß wrote:
> On 05.03.20 10:47, Denis Kirjanov wrote:
> > On 3/4/20, Jürgen Groß <jgross@suse.com> wrote:
> > > On 04.03.20 14:10, Denis Kirjanov wrote:
> > > > On 3/2/20, Jürgen Groß <jgross@suse.com> wrote:
> > > > > On 02.03.20 15:21, Denis Kirjanov wrote:
> > > > > > the patch adds a basic xdo logic to the netfront driver
> > > > > > 
> > > > > > XDP redirect is not supported yet
> > > > > > 
> > > > > > v2:
> > > > > > - avoid data copying while passing to XDP
> > > > > > - tell xen-natback that we need the headroom space
> > > > > 
> > > > > Please add the patch history below the "---" delimiter
> > > > > 
> > > > > > 
> > > > > > Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> > > > > > ---
> > > > > >     drivers/net/xen-netback/common.h |   1 +
> > > > > >     drivers/net/xen-netback/rx.c     |   9 ++-
> > > > > >     drivers/net/xen-netback/xenbus.c |  21 ++++++
> > > > > >     drivers/net/xen-netfront.c       | 157
> > > > > > +++++++++++++++++++++++++++++++++++++++
> > > > > >     4 files changed, 186 insertions(+), 2 deletions(-)
> > > > > 
> > > > > You are modifying xen-netback sources. Please Cc the maintainers.
> > > > > 
> > > 
> > > ...
> > > 
> > > > > > 
> > > > > > +	}
> > > > > > +
> > > > > > +	return 0;
> > > > > > +
> > > > > > +abort_transaction:
> > > > > > +	xenbus_dev_fatal(np->xbdev, err, "%s", message);
> > > > > > +	xenbus_transaction_end(xbt, 1);
> > > > > > +out:
> > > > > > +	return err;
> > > > > > +}
> > > > > > +
> > > > > > +static int xennet_xdp_set(struct net_device *dev, struct bpf_prog
> > > > > > *prog,
> > > > > > +			struct netlink_ext_ack *extack)
> > > > > > +{
> > > > > > +	struct netfront_info *np = netdev_priv(dev);
> > > > > > +	struct bpf_prog *old_prog;
> > > > > > +	unsigned int i, err;
> > > > > > +
> > > > > > +	old_prog = rtnl_dereference(np->queues[0].xdp_prog);
> > > > > > +	if (!old_prog && !prog)
> > > > > > +		return 0;
> > > > > > +
> > > > > > +	if (prog)
> > > > > > +		bpf_prog_add(prog, dev->real_num_tx_queues);
> > > > > > +
> > > > > > +	for (i = 0; i < dev->real_num_tx_queues; ++i)
> > > > > > +		rcu_assign_pointer(np->queues[i].xdp_prog, prog);
> > > > > > +
> > > > > > +	if (old_prog)
> > > > > > +		for (i = 0; i < dev->real_num_tx_queues; ++i)
> > > > > > +			bpf_prog_put(old_prog);
> > > > > > +
> > > > > > +	err = talk_to_netback_xdp(np, old_prog ?
> > > > > > NETBACK_XDP_HEADROOM_DISABLE:
> > > > > > +				  NETBACK_XDP_HEADROOM_ENABLE);
> > > > > > +	if (err)
> > > > > > +		return err;
> > > > > > +
> > > > > > +	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);
> > > > > 
> > > > > What is happening in case the backend doesn't support XDP?
> > > > Here we just ask xen-backend to make a headroom, that's it.
> > > > It's better to send xen-backend changes in a separate patch.
> > > 
> > > Okay, but what do you do if the backend doesn't support XDP (e.g. in
> > > case its an older kernel)? How do you know it is supporting XDP?
> > We can check a xenbus reply to xenbus state change.
> 
> Using the frontend state for that purpose is rather dangerous.
> 
> In case the backend doesn't support the "Reconfiguring" state you might
> end up with a broken network.
> 
> I'd rather let the backend advertise the support via a "feature-xdp"
> node in Xenstore and do the activation via another node.

Yes, that's how feature negotiation is supposed to work. If XDP somehow
doesn't fit into this model, we would like to know why at the very
least.

Wei.

> 
> 
> Juergen
