Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CAF1941B9
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgCZOnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:43:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36927 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgCZOnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:43:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id w10so8153352wrm.4
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 07:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PCvSJzZb2kesJUEdt6z8N1rfTZhkRics8TChnfM4zSk=;
        b=DaR9gZh7sNOcM1sQYjrMSzu6hxwa85Q4CBHRASdYzLktK2WDAehTymnA+kvWVog7Pq
         rjU7702jtzrE1JenTLggXtU3JSLUyB5NRUz0bRt3ip/JGBkwGKyQBWI8Yf9RRtL8A4a6
         r3VdFrGD2Q7MfTRMQzqw1Zq4FcvHTwJQdzZupNB1Y44btGZrEkQ4RZo6XreH6Rj505HX
         y/ROk53dJ/kBtqRHwm054Eg1fbYWmJpMOP6lnzvdZ6xNoEliXV1sjc0066rH/ZgoVrDu
         1pEJKSu873jiq3oF1fVczaZ+8FgWoW62LSEmkb6HaPqAGoCRcb73EMEhCqQ2cYaaZToK
         ugHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PCvSJzZb2kesJUEdt6z8N1rfTZhkRics8TChnfM4zSk=;
        b=Kw+pUTn1m4oXQu6FDxdn+blVmUnChc/viyYKmYUQxmZkq+RD6P1wPvYhNANb9KBbSE
         vORGJ5W19KAtz+bYhyTuh3Ss1GLdukXnzVKijdocYvkVjwSNavc3Z4v3HSjPBRUpQqla
         jk3nTjfIkSF2GfLljsn+RM4p+ZSfF1EFnh041to3KsS3fOf+6qSeR7GxV6lqAzGJXZup
         BBMt8Ku8p4rOs5TKqccEN6ZfmXSffFyRO4w8mWdvD6lUTn7mSEzFfu3EBpNFOXSml8sF
         PczW3tt6PPDptk/e6lFlC3gQBdqxs9xo02emWZd8+9Wblk0dyupD1vQHpH3aexOzI4JP
         ebhw==
X-Gm-Message-State: ANhLgQ0kjyBrHqHxnn4m1C0gLnfGxp2gZccheZ7KYNX6FPfVM/oL0i4x
        ppBhtOKxLnMocLgz8Le5jCRxhg==
X-Google-Smtp-Source: ADFU+vsZ5/XVubxhRp5cvPmoHgNhBfhK1nt6B1h1SJU/pB/lrC2GBAlS+r5i14IwevKu4yn7KkL0aQ==
X-Received: by 2002:a05:6000:108c:: with SMTP id y12mr9629393wrw.211.1585233792128;
        Thu, 26 Mar 2020 07:43:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k133sm3843800wma.11.2020.03.26.07.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:43:11 -0700 (PDT)
Date:   Thu, 26 Mar 2020 15:43:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca, saeedm@mellanox.com,
        leon@kernel.org, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, moshe@mellanox.com, ayal@mellanox.com,
        eranbe@mellanox.com, vladbu@mellanox.com, kliteyn@mellanox.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        tariqt@mellanox.com, oss-drivers@netronome.com,
        snelson@pensando.io, drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200326144310.GV11304@nanopsycho.orion>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >> Now the PF itself can have a "nested eswitch" to manage. The "parent
>> >> eswitch" where the PF was created would only see one leg to the "nested
>> >> eswitch".
>> >> 
>> >> This "nested eswitch management" might or might not be required. Depends
>> >> on a usecare. The question was, how to configure that I as a user
>> >> want this or not.  
>> >
>> >Ack. I'm extending your question. I think the question is not only who
>> >controls the eswitch but also which PFs share the eswitch.  
>> 
>> Yes.
>> 
>> >
>> >I think eswitch is just one capability, but SmartNIC will want to
>> >control which ports see what capabilities in general. crypto offloads
>> >and such.
>> >
>> >I presume in your model if host controls eswitch the smartNIC sees just  
>> 
>> host may control the "nested eswitch" in the SmartNIC case.
>
>By nested eswitch you mean eswitch between ports of the same Host, or
>within one PF? Then SmartNIC may switch between PFs or multiple hosts?

In general, each pf can manage a switch and have another pf underneath
which may manage the nested switch. This may go to more than 2 levels in
theory.

It is basically an independent switch with uplink to the higher switch.

It can be on the same host, or a different host. Does not matter.


>
>> >what what comes out of Hosts single "uplink"? What if SmartNIC wants
>> >the host to be able to control the forwarding but not loose the ability
>> >to tap the VF to VF traffic?  
>> 
>> You mean that the VF representors would be in both SmartNIC host and
>> host? I don't know how that could work. I think it has to be either
>> there or there.
>
>That'd certainly be easier. Without representors we can't even check
>traffic stats, though. SmartNIC may want to see the resource
>utilization of ports even if it doesn't see the ports. That's just a
>theoretical divagation, I don't think it's required.

Hmm, it would be really off. I don't think it would be possible to use
them both to do "write" config. Maybe only "read" for showing some stats
or something. Each would have netdev representor? One may be used to
send data and second not? That would be hell to maintain and understand :/
