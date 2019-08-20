Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1C996B8E
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbfHTVgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:36:05 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46339 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730649AbfHTVgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 17:36:05 -0400
Received: by mail-qk1-f195.google.com with SMTP id p13so5846911qkg.13
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 14:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=GIVo5Nol5Q2ZzbfZYz8YZhTA7PTrXGn6nTuuh66O9nY=;
        b=u1FHpOwhPmNtvBHUzMQRL2zXOP/+HSNytgxZD0K2rb9aSKWElmOTtTrKoK5zNU1eSN
         8+TpAmbd8UEsmVJzLMwT3O5lwU0y+SFaKxApRXxThEYFHQaA4zp2uuEN1fVxfku++NXv
         abUdLAGaIdjqm1su1OFnYP5aA0dSKz0gwQJTMEoklS7wS4v9VLqa2oE6kyeHX2tFi18n
         ctCUpCGQSgr6VhV4az6qnCMSz/jZ2ipOKkAUwhgAcc42dHM1+g9KN2UbF0SHbqhbdEjd
         neFYNpwKH8laFj8UWtWGUO7BeLse7yGdh3GGfHUvzldgNYLHToCF9aMDNIQUIwG1HDHW
         Smgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=GIVo5Nol5Q2ZzbfZYz8YZhTA7PTrXGn6nTuuh66O9nY=;
        b=ajHeESYTzRBywFOmrh9O1dEbnRFLiOmKO+FLeMXouL8xH26+6SFDWdGLC/6+IMAb0a
         NZAVUdYk5VXzghia5UP9ArrNVUeZJqjHYVg85lumpe4sRlz5KnBtrD9to+2TaeodKjZX
         J97ChDksyxEHvcHsN18C3rLdReUC/b5tVWOeQPIidwc8jVIH41H4+m4c8ggLCjm0dInx
         1wfk9OyKRAtJ+Zki3YYVUra9p4rxjhebm5FvJ9qAHSYRM3xHYbn5QE3X+ORCUviKSyLH
         6QKDeMF4YVJIhjswhBfdJcXdONk420JZ8qQH3S3amO6z7AdF5SZMpcOLc4S2uM23dvt0
         TwpQ==
X-Gm-Message-State: APjAAAVZDDdai9pdfZFEMKhdHKxDupt5SC0d1gkC+GCnw4rkp9sM47RJ
        /f0Lqqo/d7rBpAMDamSO2BI=
X-Google-Smtp-Source: APXvYqzgDgvM5uWH/r1kGokH8YZq7QhL6+LyGC/YVfOj+sMMR/kHDrQO5coJ1JyLQG0j/sQPqLGzzA==
X-Received: by 2002:a37:a04b:: with SMTP id j72mr27567275qke.277.1566336964436;
        Tue, 20 Aug 2019 14:36:04 -0700 (PDT)
Received: from localhost (mtrlpq2853w-lp130-05-67-70-100-98.dsl.bell.ca. [67.70.100.98])
        by smtp.gmail.com with ESMTPSA id k16sm9141210qki.119.2019.08.20.14.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 14:36:03 -0700 (PDT)
Date:   Tue, 20 Aug 2019 17:36:02 -0400
Message-ID: <20190820173602.GB10980@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
In-Reply-To: <CA+h21hrgUxKXmYuzdCPd-GqVyzNnjPAmf-Q29=7=gFJyAfY_gw@mail.gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-4-olteanv@gmail.com>
 <20190820015138.GB975@t480s.localdomain>
 <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
 <20190820135213.GB11752@t480s.localdomain>
 <c359e0ca-c770-19da-7a3a-a3173d36a12d@gmail.com>
 <CA+h21hqdXP1DnCxwuZOCs4H6MtwzjCnjkBf3ibt+JmnZMEFe=g@mail.gmail.com>
 <20190820165813.GB8523@t480s.localdomain>
 <CA+h21hrgUxKXmYuzdCPd-GqVyzNnjPAmf-Q29=7=gFJyAfY_gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 00:02:22 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, 20 Aug 2019 at 23:58, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> >
> > On Tue, 20 Aug 2019 23:40:34 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > I don't need this patch. I'm not sure what my thought process was at
> > > the time I added it to the patchset.
> > > I'm still interested in getting rid of the vlan bitmap through other
> > > means (picking up your old changeset). Could you take a look at my
> > > questions in that thread? I'm not sure I understand what the user
> > > interaction is supposed to look like for configuring CPU/DSA ports.
> >
> > What do you mean by getting rid of the vlan bitmap? What do you need exactly?
> 
> It would be nice to configure the VLAN attributes of the CPU port in
> another way than the implicit way it is done currently. I don't have a
> specific use case right now.

So you mean you need a lower level API to configure VLANs on a per-port basis,
without any logic, like including CPU and DSA links, etc.

The bitmap operations were introduced to simplify the switch drivers in the
future, since most of them could implement the VLAN operations (add, del)
in simple functions taking all local members at once.

But the Linux interface being exclusively based on a per port (slave) logic,
it is hard to implement right now.

The thing is that CPU ports, as well as DSA links in a multi-chip setup,
need to be programmed transparently when a given user port is configured,
hence the notification sent by a port to all switches of the fabric.

So I'm not against removing the bitmap logic, actually I'm looking into it
as well as moving more bridge checking logic into the slave code itself,
because I'm not a fan of your "Allow proper internal use of VLANs" patch.

But you'll need to provide more than "it would be nice" to push in that
direction, instead of making changes everywhere to make your switch work.


Thanks,

	Vivien
