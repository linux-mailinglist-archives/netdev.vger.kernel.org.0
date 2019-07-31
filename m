Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1EA7D126
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfGaW2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:28:22 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:32957 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbfGaW2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:28:21 -0400
Received: by mail-qt1-f178.google.com with SMTP id r6so63940687qtt.0
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=m02BDa/XAf/oAI6HQcytaagPhu3Z4FmLeb7H1llDB28=;
        b=Tl6DnmbvvGXavyE31ipkHReb3mySN/g6knjHPw+8vkovnRo+63nrJrtkZv8qpAC8LM
         TA24y0ynY3tUch+KrwMDsVDAaEa9LcoX0FRWv7163eNBbuLIQlVkNnJt8oXVxeX5UhtH
         ELg0oqP6FcxT3wvre1NNBaZlPY8rjvOdmgyafStTmAw3/GnLnps16yIi6jtOjCM58gGo
         P6OZVaritZlUjm8j7ovenGzlyNHX6EhQsSw3F34cMCM2Yk1iqYG/oWnOXakibgsSPrlx
         xPoGDnCKY/SVwjp3ntfRkFfXbTOWXxPhFw9ADpLTQGv/gOf9qz9BJA0+797ie9Sgbk4X
         SKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=m02BDa/XAf/oAI6HQcytaagPhu3Z4FmLeb7H1llDB28=;
        b=Qa5bdrIq/tqH/uLP+iZcVmncHpGxACs15LEdXbNnfEdMP0KYNUAKbdgOjh7vcD+NXz
         SLVBgFe6W/x//T0RSC3c3UeaJfo8HOnGsNKv2lR1AR0gzhSwcdgOdJzOVEZ3QuClFrYP
         Ft1QGtfLi8xJEX8BfQXyP3ub1BHBVCI4F/UBbAxZRO8ypSFLDjwdLe1scnq/LLupThJO
         GCc+po7Dv8Ogguf1B/Tz6/dgCV7xN/L9MOiAtoA9nbTkRsv5RBk/qToqXdaS2656gq4v
         jvkzfEL22SKuObW676byd2i+rd80YtChC0HLuAki9islynrPP7DUPK8l5TP/KijFcWI5
         88zQ==
X-Gm-Message-State: APjAAAV7AsuvZigfHRb7WbB3wOQ0hfen7ur1/ijpvZFsARAeDWxl0c2v
        Mvysg3f4p65lU2QSrdT0T006PQ==
X-Google-Smtp-Source: APXvYqzUp3WLCyUbBwR02QgGn7DT4nxEZUvyflzCTFBXq1fVeR772ZKBU4q+O+wEqLPQ1japgfG50Q==
X-Received: by 2002:a0c:d14e:: with SMTP id c14mr89153754qvh.206.1564612100827;
        Wed, 31 Jul 2019 15:28:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q17sm26262054qtl.13.2019.07.31.15.28.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 15:28:20 -0700 (PDT)
Date:   Wed, 31 Jul 2019 15:28:05 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 0/3] net: devlink: Finish network namespace
 support
Message-ID: <20190731152805.4110ec41@cakuba.netronome.com>
In-Reply-To: <45803ed3-0328-9409-4351-6c26ba8af3cd@gmail.com>
References: <20190727094459.26345-1-jiri@resnulli.us>
        <eebd6bc7-6466-2c93-4077-72a39f3b8596@gmail.com>
        <20190730060817.GD2312@nanopsycho.orion>
        <8f5afc58-1cbc-9e9a-aa15-94d1bafcda22@gmail.com>
        <20190731150233.432d3c86@cakuba.netronome.com>
        <45803ed3-0328-9409-4351-6c26ba8af3cd@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 16:07:31 -0600, David Ahern wrote:
> On 7/31/19 4:02 PM, Jakub Kicinski wrote:
> > Can you elaborate further? Ports for most purposes are represented by
> > netdevices. Devlink port instances expose global topological view of
> > the ports which is primarily relevant if you can see the entire ASIC.
> > I think the global configuration and global view of resources is still
> > the most relevant need, so in your diagram you must account for some
> > "all-seeing" instance, e.g.:
> > 
> >    namespace 1 |  namespace 2  | ... | namespace N
> >                |               |     |
> >   { ports 1 }  |   { ports 2 } | ... | { ports N }
> >                |               |     |
> > subdevlink 1   | subdevlink 2  | ... |  subdevlink N
> >          \______      |              _______/
> >                  master ASIC devlink
> >   =================================================
> >                    driver
> > 
> > No?
> 
> sure, there could be a master devlink visible to the user if that makes
> sense or the driver can account for it behind the scenes as the sum of
> the devlink instances.
> 
> The goal is to allow ports within an asic [1] to be divided across
> network namespace where each namespace sees a subset of the ports. This
> allows creating multiple logical switches from a single physical asic.
> 
> [1] within constraints imposed by the driver/hardware - for example to
> account for resources shared by a set of ports. e.g., front panel ports
> 1 - 4 have shared resources and must always be in the same devlink instance.

So the ASIC would start out all partitioned? Presumably some would
still like to use it non-partitioned? What follows there must be a top
level instance to decide on partitioning, and moving resources between
sub-instances.

Right now I don't think there is much info in devlink ports which would
be relevant without full view of the ASIC..
