Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388EAFBDDF
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 03:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKNCZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 21:25:51 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33783 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfKNCZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 21:25:51 -0500
Received: by mail-pl1-f195.google.com with SMTP id ay6so1924059plb.0
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 18:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/csY5eFFUmtyRVUnJvdKwJ7ihuebAgTOkrrOvX8xDvU=;
        b=nEqZI+C7Ro+U6s4xuHIKTYffRWArjpffoS63aBVwwsdy1yv02J9X1/0J55eDZtAvrp
         XY1gqwArr/ytFkbyh9fOZ2Ck5wcS15EtON0UCeHs5aFbvms2OT7I9GV+YbwQSbJvdeZR
         /TXVgZuHmt7/g8UYaEIcH5iUtTzLReS08bY/EwHtNe0bcWAK+xrGJmaeAOFyIGe1qX7k
         2/ZpHy+n/xEJjDA0dpFbu/NXDOL6LqKwqf9Su2lMo80QjGpAgfSDGRawo91Pc6VCGTQz
         LFGcxMyjSFynrlYT/oLdd6X8GlPdfIKfwkoVRGjLHAY7QxnUpzBmY9o7Y8j/lZ+7LTi6
         K6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/csY5eFFUmtyRVUnJvdKwJ7ihuebAgTOkrrOvX8xDvU=;
        b=OHqzOYBjb2rnId9grDp5J9shRh3N6AWN/v9kDraNBCF98erT8+796QtM9GOKq90PLY
         sCDwy62E4JDcExOFogw2bT0ZZxP3ohrp2n+yR8rZJ9Los1u3KlffE6gXcgyG7PxgEHWY
         vGP9Ae8Jwr0oMByWxTINAkOEJZLdpNN8vIXaBvXMwgKZJ3/sjpGJVDaAWySj0p1IlZAw
         2c5VXYqU9/m52WiaXBHipmmOEzNULTYl6m89fUBwveihRXxL6GWC5nnREkzGHX0aq4TB
         naZug8W3WcBG4bAXL6t0SImsdQMrwaOXiNLiQXQRefyg+HFJ/pGaixK9Jov72JkOPbf1
         +n/Q==
X-Gm-Message-State: APjAAAUBnAHRbVOzkujrT6jycR/oCngSNdFOJyoYrAHoMoz4J0TkwDr0
        ITz+X5/9TeWpdzQifpnq7H7SZlgSDik=
X-Google-Smtp-Source: APXvYqxfZV0dpS0E6IzRSNhF8m1Cma7Inq2jWDOzlnGnBk7BayEgvNwIVhrbNIGneeTAVNKOSg2lzQ==
X-Received: by 2002:a17:902:76c1:: with SMTP id j1mr7370906plt.59.1573698349886;
        Wed, 13 Nov 2019 18:25:49 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id u8sm3682323pga.47.2019.11.13.18.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 18:25:49 -0800 (PST)
Date:   Wed, 13 Nov 2019 18:25:46 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "lariel@mellanox.com" <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Message-ID: <20191113182546.4db77a51@cakuba>
In-Reply-To: <fa3c4cfe6ed4db31bcdaff739ccad70fa1ec4a5e.camel@intel.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
        <20191031172330.58c8631a@cakuba.netronome.com>
        <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
        <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
        <20191101172102.2fc29010@cakuba.netronome.com>
        <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
        <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
        <20191104183516.64ba481b@cakuba.netronome.com>
        <3da1761ec4a15db87800a180c521bbc7bf01a5b2.camel@mellanox.com>
        <20191105135536.5da90316@cakuba.netronome.com>
        <8c740914b7627a10e05313393442d914a42772d1.camel@mellanox.com>
        <20191105151031.1e7c6bbc@cakuba.netronome.com>
        <a4f5771089f23a5977ca14d13f7bfef67905dc0a.camel@mellanox.com>
        <20191105173841.43836ad7@cakuba.netronome.com>
        <fa3c4cfe6ed4db31bcdaff739ccad70fa1ec4a5e.camel@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Nov 2019 22:55:16 +0000, Keller, Jacob E wrote:
> Hi Jakub,
> 
> On Tue, 2019-11-05 at 17:38 -0800, Jakub Kicinski wrote:
> > In the upstream community, however, we care about the technical
> > aspects.
> >   
> > > and we all know that it could take years before we can sit back and
> > > relax that we got our L2 switching ..   
> > 
> > Let's not be dramatic. It shouldn't take years to implement basic L2
> > switching offload.  
> 
> I had meant to send something earlier in this thread, but never got
> around to it. I wanted to ask your opinion and get some feedback.
> 
> We (Intel) have recently been investigating use of port representors
> for enabling introspection and control of VFs in the host system after
> they've been assigned to a virtual machine.

Cool!

> I had originally been thinking of adding these port representor netdevs
> before we fully implement switchdev with the e-switch offloads. The
> idea was to migrate to using port representors in either case.
> 
> However, from what it looks like on this thread, you'd rather propose
> that we implement switchdev with basic L2 offload?
> 
> I'm not too familiar with switchdev, (trying to read and learn about so
> that we can begin actually implementing it in our network drivers).

So switchdev mode for SR-IOV NICs basically means that all ports are
represented by a netdev and no implicit switching happens in HW, if
packet is received on a port, be it VF or uplink - it's sent up to the
representor. That's pretty much it. Then you can install rules to
forward internally in the device.

Perhaps an obvious suggestion but did you consider converting
Documentation/networking/switchdev.txt to ReST and updating it as you
explore the code? ;)

> Based on your comments and feedback in this thread, it sounds like our
> original idea to have a "legacy with port representors" mode is not
> really something you'd like, because it would continue to encourage
> avoiding migrating from legacy stack to switchdev model.

Not at this point, no. 

I think this was all discussed before with Alex still strongly in the
netdev loops at Intel. I was initially accommodating to some partial
implementations like what you mention, since it'd had been good to have
Intel come on board with switchdev, and Fortville reportedly couldn't
disable leaking the packets which missed filters to the uplink.

IIRC at that point Or Gerlitz strongly drew the line at preserving
switchdev behaviour as described above - default to everything falls
back to host.

Today since many months have passed I don't think we should walk back
on that decision.

> But, instead of trying to go fully towards implementing switchdev with
> complicated OvS offloads, we could do a simpler approach that only
> supports L2 offloads initially, and from these comments it seems this
> is the direction you'd rather upstream persue?

Yes, I think simple L2 offload that supports common cases would be a
pretty cool starting point for a new switchdev implementation.

> > I had given switchdev L2 some thought. IDK what you'd call serious, 
> > I don't have code. We are doing some ridiculously complex OvS
> > offloads
> > while most customers just need L2 plus maybe VXLAN encap and basic
> > ACLs. Which switchdev can do very nicely thanks to Cumulus folks.  
> 
> Based on this, it sounds like the switchdev API can do this L2
> offloading and drivers simply need to enable it. If I understand
> correctly, it  requires the system administrator to place the VF devies
> into a bridge, rather than simply having the bridging hidden inside the
> device.

Yup. You may want to support only offloading of certain configuration
of the bridge to simplify your life, e.g. disable learning and flood
only to uplink..
