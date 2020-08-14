Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E631224482A
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 12:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHNKj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 06:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgHNKj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 06:39:27 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9DEC061384;
        Fri, 14 Aug 2020 03:39:27 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id t10so9412878ejs.8;
        Fri, 14 Aug 2020 03:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P/IMbVVazwp69IEiF2BxdVyE/bB073q/0Zsieh45SU4=;
        b=YEgesqFOIJssOUsE3Ax30Jh1IoNlR6jOhwvHnnpivHHNXQu109DBtK1qFXl5b0obs6
         C5DY5jFHQMR7v15+JIsTefeqgMsCwQwMQTTLoBVUxIF95RSzkpZkzk1apQx5JqLfKnXV
         KuasG5Y5ZNkkd1GH82aAJiBKtP/X13oGVGl3/5oCGEBvLQ7iqFuk27+MoHIOgOLPoalA
         Ch5ikNAgfZX/GszT/+s1uha/M5i7oVf9Naxt8Rf/L0bVo/jpp/AJqVaON1l8g1n0Nxgn
         KhqTPmSkFyRjsQDi/0mI7Va+mVASIgWQzNnh7WbpgWuA9IDVjBcVu/fLMneVxG7Tf4II
         11jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P/IMbVVazwp69IEiF2BxdVyE/bB073q/0Zsieh45SU4=;
        b=BzyZ0MUq+dX/u+v6uu80XNnmAqTi2J2B1UYuyyzBgA/j7yM0RB7ytQi6/lZi6BNF1n
         ht7tQbFiJnk/xRyrxyNzrOInyx+w9mkr2FEq4W7IqL/KG8IzhnrS4CXozw8BJUu07AAJ
         CMvnw6XVmUpcRim7Ihas9uefVUOW/g5W+a9crwSRdxOBVRB9I7/1yU4NReObuiZrXmJd
         0/AkveT0RAZ6EKY7SIgln0TEygrOpzOVsd6CsaZ4RVGmG7B2FPShgjJh8sqsNs7cp+4M
         gnfuqVGI9l/q+HIT/RR5eH0ygX+JuI496M+x3aYJsWPAHHB0TlhcIBm8oanAP1ldSuIp
         LxXw==
X-Gm-Message-State: AOAM532hurth9pRLwIZwXF1DwfwFSjV5kK6kBxioFnjnlygXwLeC+cjt
        n4iVa0Cv20XpPdh0YtEFSxo=
X-Google-Smtp-Source: ABdhPJw5ITev1EgaRJCI88O4PzjGE8Uuux2A7OMbU/mNY0Gmu8uV3kvpdkdB6849WNTExc9cU7Vfbw==
X-Received: by 2002:a17:906:841:: with SMTP id f1mr1821223ejd.158.1597401565729;
        Fri, 14 Aug 2020 03:39:25 -0700 (PDT)
Received: from andrea (ip-213-220-210-175.net.upcbroadband.cz. [213.220.210.175])
        by smtp.gmail.com with ESMTPSA id e8sm5675092edy.68.2020.08.14.03.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 03:39:25 -0700 (PDT)
Date:   Fri, 14 Aug 2020 12:39:19 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Andres Beltran <lkmlabelt@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] hv_netvsc: Add validation for untrusted Hyper-V values
Message-ID: <20200814103919.GA12689@andrea>
References: <20200728225321.26570-1-lkmlabelt@gmail.com>
 <BL0PR2101MB0930BC0130F6AE5775E62604CA4C0@BL0PR2101MB0930.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR2101MB0930BC0130F6AE5775E62604CA4C0@BL0PR2101MB0930.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Haiyang,

[I'm resuming this work by Andres.  Sorry for the delay.]


> >  	switch (nvsp_packet->hdr.msg_type) {
> >  	case NVSP_MSG_TYPE_INIT_COMPLETE:
> >  	case NVSP_MSG1_TYPE_SEND_RECV_BUF_COMPLETE:
> >  	case NVSP_MSG1_TYPE_SEND_SEND_BUF_COMPLETE:
> >  	case NVSP_MSG5_TYPE_SUBCHANNEL:
> > +		if (msglen < sizeof(struct nvsp_message)) {
> > +			netdev_err(ndev, "nvsp_msg5 length too small: %u\n",
> > +				   msglen);
> > +			return;
> > +		}
> 
> struct nvsp_message includes all message types, so its length is the longest type,
> The messages from older host version are not necessarily reaching the 
> sizeof(struct nvsp_message).

I split the check above into several checks, one for each "case", using
(what I understand are) the corresponding structures/sizeofs...

> 
> Testing on both new and older hosts are recommended, in case I didn't find out all issues
> like this one.

Sure, will do.

Thanks,
  Andrea
