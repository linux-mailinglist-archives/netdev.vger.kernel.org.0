Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341EDE9059
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 20:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfJ2TxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 15:53:20 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37647 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfJ2TxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 15:53:20 -0400
Received: by mail-lf1-f67.google.com with SMTP id b20so11478410lfp.4
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 12:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ELIuHAsLUdOptuJRjC0EGY1vsp+EwGqf0TMIjtj9lzo=;
        b=CL6xSLkCn8z+SPxn0Ox2Q6QupnXa+71PuXMVumYce/AdZ5SIw+naoKj16l8UR2SCHV
         7i1haBetmU0frrYstQP06LJgQMQMft5ACDcvfsVzEKD5SAltBC2dnqXYH+wzgKuK6LO5
         m9++MWlozUYf3gNf93unMZDWiaov7NrL4GYQ7kXkCp+vf6lNQ5H2MRE13ertgZP0+lCX
         UETuw+o2EjBHSJFVt+NjApYTc259y7RV4Hw/Uam5kGh18cz+Jf8dEASSJTMq5zlq3B2m
         uTAYA8f3f5+uKdzxBSaxaqgOGGjH6pJVUZnXIxnB2n7hw+9oVGzcp2DxG9WKNeHJ99XR
         7CQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ELIuHAsLUdOptuJRjC0EGY1vsp+EwGqf0TMIjtj9lzo=;
        b=dGvuEcTAM1M2zVdha46MVcgJcwt4uNLn5ttgRfWEIVmDcEqHryYBbjFTrglM0ZRdJS
         /DUA11tPLEbPkwhc0odXcck+xh4YxYiIkIZoG/gd4LNRxO1fIXowHYPSwnhPYLkrnCk/
         8A2iHgU6m0lS8kHRJP8yK6UHMRMrUOrDC7E3N6b6w5J5tI3UG3yznz+RfDy66GgidrQx
         dPbkEdvj5FLEZom8qrga/dAGSBhayRJDLWWJwSJ0DSDgArYleq0z1A6D5nqw4/sUne19
         iSv2GepxAYre86z2GHE6/l3iZRvo4jVu8IB2S5L9HiNhPSWLjz9fYIKslF+qx5BUFWTT
         PXMA==
X-Gm-Message-State: APjAAAWKdcUSdDL/NedY55AfG2t50o+3GraKJ6DIU8btuYj00sTKUCIT
        Xo9+P1+suny1nsQgWbx7eBGrZw==
X-Google-Smtp-Source: APXvYqxoXomwuRDO/YmNQAylZagn+LTxZqxb/kzuIdcD9fkqeiGTej2ZyTO75cc3M2ivp48a1iK2vw==
X-Received: by 2002:a05:6512:1de:: with SMTP id f30mr3570832lfp.176.1572378797083;
        Tue, 29 Oct 2019 12:53:17 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c5sm6465233ljd.57.2019.10.29.12.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 12:53:16 -0700 (PDT)
Date:   Tue, 29 Oct 2019 12:53:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
Message-ID: <20191029125308.78b52511@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <DM6PR21MB1337547067BE5E52DFE05E20CA610@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
        <1572296801-4789-4-git-send-email-haiyangz@microsoft.com>
        <20191028143322.45d81da4@cakuba.hsd1.ca.comcast.net>
        <DM6PR21MB1337547067BE5E52DFE05E20CA610@DM6PR21MB1337.namprd21.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Oct 2019 19:17:25 +0000, Haiyang Zhang wrote:
> > > +int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> > > +		   struct netvsc_device *nvdev)
> > > +{
> > > +	struct bpf_prog *old_prog;
> > > +	int frag_max, i;
> > > +
> > > +	old_prog = netvsc_xdp_get(nvdev);
> > > +
> > > +	if (!old_prog && !prog)
> > > +		return 0;  
> > 
> > I think this case is now handled by the core.  
> Thanks for the reminder. I saw the code in dev_change_xdp_fd(), so the upper layer
> doesn't call XDP_SETUP_PROG with old/new prog both NULL.
> But this function is also called by other functions in our driver, like netvsc_detach(),
> netvsc_remove(), etc. Instead of checking for NULL in each place, I still keep the check inside
> netvsc_xdp_set().

I see. Makes sense on a closer look.

BTW would you do me a favour and reformat this line:

static struct netvsc_device_info *netvsc_devinfo_get
			(struct netvsc_device *nvdev)

to look like this:

static 
struct netvsc_device_info *netvsc_devinfo_get(struct netvsc_device *nvdev)

or

static struct netvsc_device_info *
netvsc_devinfo_get(struct netvsc_device *nvdev)

Otherwise git diff gets confused about which function given chunk
belongs to. (Incorrectly thinking your patch is touching
netvsc_get_channels()). I spent few minutes trying to figure out what's
going on there :)

> >   
> > > +		return -EOPNOTSUPP;
> > > +	}
> > > +
> > > +	if (prog) {
> > > +		prog = bpf_prog_add(prog, nvdev->num_chn);
> > > +		if (IS_ERR(prog))
> > > +			return PTR_ERR(prog);
> > > +	}
> > > +
> > > +	for (i = 0; i < nvdev->num_chn; i++)
> > > +		rcu_assign_pointer(nvdev->chan_table[i].bpf_prog, prog);
> > > +
> > > +	if (old_prog)
> > > +		for (i = 0; i < nvdev->num_chn; i++)
> > > +			bpf_prog_put(old_prog);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog *prog)  
> > > +{
> > > +	struct netdev_bpf xdp;
> > > +	bpf_op_t ndo_bpf;
> > > +
> > > +	ASSERT_RTNL();
> > > +
> > > +	if (!vf_netdev)
> > > +		return 0;
> > > +
> > > +	ndo_bpf = vf_netdev->netdev_ops->ndo_bpf;
> > > +	if (!ndo_bpf)
> > > +		return 0;
> > > +
> > > +	memset(&xdp, 0, sizeof(xdp));
> > > +
> > > +	xdp.command = XDP_SETUP_PROG;
> > > +	xdp.prog = prog;
> > > +
> > > +	return ndo_bpf(vf_netdev, &xdp);  
> > 
> > IMHO the automatic propagation is not a good idea. Especially if the
> > propagation doesn't make the entire installation fail if VF doesn't
> > have ndo_bpf.  
> 
> On Hyperv and Azure hosts, VF is always acting as a slave below netvsc.
> And they are both active -- most data packets go to VF, but broadcast,
> multicast, and TCP SYN packets go to netvsc synthetic data path. The synthetic 
> NIC (netvsc) is also a failover NIC when VF is not available.
> We ask customers to only use the synthetic NIC directly. So propagation
> of XDP setting to VF NIC is desired. 
> But, I will change the return code to error, so the entire installation fails if VF is 
> present but unable to set XDP prog.

Okay, if I read the rest of the code correctly you also fail attach
if xdp propagation failed? If that's the case and we return an error
here on missing NDO, then the propagation could be okay.

So the semantics are these:

(a) install on virt - potentially overwrites the existing VF prog;
(b) install on VF is not noticed by virt;
(c) uninstall on virt - clears both virt and VF, regardless what
    program was installed on virt;
(d) uninstall on VF does not propagate;

Since you're adding documentation it would perhaps be worth stating
there that touching the program on the VF is not supported/may lead 
to breakage, and users should only touch/configure the program on the
virt.
