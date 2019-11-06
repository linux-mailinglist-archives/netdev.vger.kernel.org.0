Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DA9F1C75
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 18:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732384AbfKFR0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 12:26:52 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32881 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732141AbfKFR0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 12:26:52 -0500
Received: by mail-pg1-f196.google.com with SMTP id h27so652687pgn.0
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 09:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HFANtIHxQoYFdlaehJS8BV0r4beEhL6otQVZmHWO8Uw=;
        b=OcJxc2I/SRrt/ianKnknT7UTP5TPmMPtesBu4sv21WN+t796Miu36QIecal+BI7cv7
         qzSZcuUKjTAbmncsdAwrlCWOFTDWK7HZxBKByZN0W0oFRq2roDg87G2Y2Zw0dr08PlLU
         9iNQRS5ffH/lbF5BPWDVOd1fH1iLu6f68NGbyyhrbCdpi13o0iB0jW0/HwhvOpdCXQYY
         Fd+Dn51XTZbQ9LlQko1C0UpKrHvLbcikk9b/TuOthR0+kHlfJZIEu5mf7xSTjx97j/9k
         mcsQvWRwB8p4wuFV3Lv6RAKqmGX6fM0HGROLfKIhny61TSlcjOVY2CoM9mz0FkuZ1/GC
         RIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HFANtIHxQoYFdlaehJS8BV0r4beEhL6otQVZmHWO8Uw=;
        b=E3BXFdSNcEhk1ZACnjyO6l6HDF6NsIZ1J7kn3EHfR2+QTEFC+uePQzuEg/QNrVu0CC
         zzL+7Zer5TBlPJbN2KowLzDxWMngpXtRj54u92f/cvhbx9sXHYp98nWd21YzsjGB0Dkl
         wpSeWAdUpdt+7ROaRduqzgiIcMXQzxu1xFznEa8bS3Rwa8K+6blvL4VBekvcNnumHA8B
         yZLLt6ChrXiOY9eov0qeS2y9C2T+uSv7p1jzhD7b+36Mjaw9RIzNyssR/hEM/y/637bg
         EVefI+WgKzlfq7DJm0CxWm3f3GjOLMWo5I5+fJZjinUOC/kSd9ta6Z7erFCb5mEKCGUh
         Q+hQ==
X-Gm-Message-State: APjAAAUJP/FZv3LQwpto23qS5vpSTe51RGDkCUfnL3ixxmWR+3xdayk+
        IL/l2pFLrN/i+rE76U9yAfWCMQ==
X-Google-Smtp-Source: APXvYqxTD9YFs2J0NoLcpUMpgfVpeMNm5HNSQu3XscHftE/17KLmnk2GDVEGAKyfeskz+NpoacaviQ==
X-Received: by 2002:a63:5c4a:: with SMTP id n10mr4317686pgm.120.1573061211773;
        Wed, 06 Nov 2019 09:26:51 -0800 (PST)
Received: from cakuba.netronome.com ([216.4.53.35])
        by smtp.gmail.com with ESMTPSA id b26sm31794280pgs.93.2019.11.06.09.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 09:26:51 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:26:47 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191106092647.4de42312@cakuba.netronome.com>
In-Reply-To: <20191106082039.GB2112@nanopsycho>
References: <20191103083554.6317-1-idosch@idosch.org>
        <20191104123954.538d4574@cakuba.netronome.com>
        <20191104210450.GA10713@splinter>
        <20191104144419.46e304a9@cakuba.netronome.com>
        <20191104232036.GA12725@splinter>
        <20191104153342.36891db7@cakuba.netronome.com>
        <20191105074650.GA14631@splinter>
        <20191105095448.1fbc25a5@cakuba.netronome.com>
        <20191105204826.GA15513@splinter>
        <20191105134858.5d0ffc14@cakuba.netronome.com>
        <20191106082039.GB2112@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Nov 2019 09:20:39 +0100, Jiri Pirko wrote:
> Tue, Nov 05, 2019 at 10:48:58PM CET, jakub.kicinski@netronome.com wrote:
> >On Tue, 5 Nov 2019 22:48:26 +0200, Ido Schimmel wrote:  
> >> On Tue, Nov 05, 2019 at 09:54:48AM -0800, Jakub Kicinski wrote:  
> >> > Hm, the firmware has no log that it keeps? Surely FW runs a lot of
> >> > periodic jobs etc which may encounter some error conditions, how do 
> >> > you deal with those?    
> >> 
> >> There are intrusive out-of-tree modules that can get this information.
> >> It's currently not possible to retrieve this information from the
> >> driver. We try to move away from such methods, but it can't happen
> >> overnight. This set and the work done in the firmware team to add this
> >> new TLV is one step towards that goal.
> >>   
> >> > Bottom line is I don't like when data from FW is just blindly passed
> >> > to user space.    
> >> 
> >> The same information will be passed to user space regardless if you use
> >> ethtool / devlink / printk.  
> >
> >Sure, but the additional hoop to jump through makes it clear that this
> >is discouraged and it keeps clear separation between the Linux
> >interfaces and proprietary custom FW.. "stuff".  
> 
> Hmm, let me try to understand. So you basically have problem with
> passing random FW generated data and putting it to user (via dmesg,
> extack). However, ethtool dump is fine. Devlink health reporter is also
> fine.

Yup.

> That is completely sufficient for async events/errors.
> However in this case, we have MSG sent to fw which generates an ERROR
> and this error is sent from FW back, as a reaction to this particular
> message.

Well, outputting to dmesg is not more synchronous than putting it in
some other device specific facility.

> What do you suggest we should use in order to maintain the MSG-ERROR
> pairing? Perhaps a separate devlink health reporter just for this?

Again, to be clear - that's future work, right? Kernel logs as
implemented here do not maintain MSG-ERROR pairing.

> What do you think?

In all honesty it's hard to tell for sure, because we don't see the FW
and what it needs. That's kind of the point, it's a black box.

I prefer the driver to mediate all the information in a meaningful way.
If you want to report an error regarding a parameter the FW could
communicate some identification of the field and the reason and the
driver can control the output, for example format a string to print to
logs?
