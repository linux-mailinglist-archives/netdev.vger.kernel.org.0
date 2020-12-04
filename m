Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCBE2CF31B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731043AbgLDR1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:27:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727639AbgLDR1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:27:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607102775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NQ798MNDfvtqQrDv2UBWcc2VnF0HXJeCo5mjae/HrWs=;
        b=Jt9aiwwvvQxtY35AYdx6jAjdX9VJohPPm7PIdn32CF9t58upvVGGa2Fc4R4el88HxVhwt5
        GSMMiOF0b50eKO67zwoxUELYNpqqwQ08hNRTEaoRYEqY64CLUol0zEcIBHi4UDAdjXfoZR
        l9RlhZiUOXI0kLiNplStBVVmgHAWpoQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-vFPLvkfZO02UrG-pk1DZkw-1; Fri, 04 Dec 2020 12:26:13 -0500
X-MC-Unique: vFPLvkfZO02UrG-pk1DZkw-1
Received: by mail-ed1-f69.google.com with SMTP id g8so2624442edm.7
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 09:26:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NQ798MNDfvtqQrDv2UBWcc2VnF0HXJeCo5mjae/HrWs=;
        b=nSCXHI3/87j1db+tD2Bwl+MFp4V3eHKm8aDu71h/FJQi/NvQiuwLBv0x+C48lSfVuY
         eDxFf+5ilRLkp49JQEXE0UlAW47ipXsKCxopTLQUE62bG8vm2VpVR0WGqzYsnoja/e9p
         0U3gIxaSzDX4w8V7azr/45Q+YurZi7CeBOsspMI/qVEVtcr/QqSQItswvvXd8WzEZnsv
         2DnGy+6TlXuwTi77iwtu+ORxQPYWkmVeh/6dXsNZ160V42rhdm2WUICB3mFhcVD65/AF
         02nUNTAfmWWy47mjs1fPRer9DkXnCXTCWjbrW/FWqykbAR0+y7l6B7gzMnwZCBonpyq4
         Etsw==
X-Gm-Message-State: AOAM531RLnwGiHsN3JbCj+v1fvADOMQ7uJy5ognWqfp2s9VtkFceZH3z
        BqwaueAcjelIIcBn2jPxJ1Rgv3KTgwhBUX7cxblDNKrTbA9JJaQqjWYBNUK4kvEyMOWMd8ug6z6
        1Kw3DyXk8HZ20UM9u
X-Received: by 2002:a17:907:700c:: with SMTP id wr12mr7944108ejb.398.1607102772067;
        Fri, 04 Dec 2020 09:26:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfRey5xD/WZwhxd3Nz82+uyMq/nlfkZPaMg0SBTagSfHMxSO6JURM+9isThgDkn3lIA72mTw==
X-Received: by 2002:a17:907:700c:: with SMTP id wr12mr7944088ejb.398.1607102771880;
        Fri, 04 Dec 2020 09:26:11 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ch30sm3854443edb.8.2020.12.04.09.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 09:26:11 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EF454182EEA; Fri,  4 Dec 2020 18:26:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, alardam@gmail.com
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 0/5] New netdev feature flags for XDP
In-Reply-To: <20201204092012.720b53bf@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204092012.720b53bf@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Dec 2020 18:26:10 +0100
Message-ID: <87k0tx7aa5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri,  4 Dec 2020 11:28:56 +0100 alardam@gmail.com wrote:
>>  * Extend ethtool netlink interface in order to get access to the XDP
>>    bitmap (XDP_PROPERTIES_GET). [Toke]
>
> That's a good direction, but I don't see why XDP caps belong in ethtool
> at all? We use rtnetlink to manage the progs...

You normally use ethtool to get all the other features a device support,
don't you? And for XDP you even use it to configure the number of
TXQs.

I mean, it could be an rtnetlink interface as well, of course, but I
don't think it's completely weird if this goes into ethtool...

-Toke

