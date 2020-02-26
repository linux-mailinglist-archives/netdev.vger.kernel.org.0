Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2F316F9E0
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgBZImh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:42:37 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24500 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725872AbgBZImg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:42:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582706555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P68znaufQR80QI9iwdfdCLcBJsMbuHi73Tp9YJqiZ08=;
        b=OghSjETpa5GkmQ+LezO2cxRMyFGCBBWzzSm/c7NBMsQbYhHSIUjVMpZhyjmvgVMoZKh2B1
        yhxvbjgKvTrgcDK/mAstqR6UrBx8XOBFYjD6eVYp6+wRz3kRJ9yynwX7zSB5UhegWIUq1T
        KZrfm7aZVAF0JBn6+auyig3hNJJwu7E=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-gonInPdtN8eYWclNsXDNpA-1; Wed, 26 Feb 2020 03:42:30 -0500
X-MC-Unique: gonInPdtN8eYWclNsXDNpA-1
Received: by mail-qk1-f197.google.com with SMTP id 22so111931qkc.7
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:42:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=P68znaufQR80QI9iwdfdCLcBJsMbuHi73Tp9YJqiZ08=;
        b=eiQfd33KcVINJHNs53yXuGj1tW44A5cG7Dy569QZkcAu6RSlpJyL2z2dsC+xBPmiu7
         XBWkG8j9rCZnDzTlkwleYBZdtc77zNIfrZ0I8dxYA+/Ot/Vdmw01MADdrJwabOsb2LKM
         PI5q3gILVdLJGhIqEqe8sgLXbgVBMG+82+TQc3BBlueOzZyX3aowJuDgD3C3qJ0cyd2R
         aEB/0pvmGf+70sKBNFKr2cApYZYZ03Udz7mpoUwt5zYwQkbiYj2AVfmrXkc72ab89Pbx
         gy/dgIEazkwtcOebvjGsHGNtgNxDWBcSaMXZV69K8ASRda1PtFXiV657C7pJ1YzGkN58
         SLsw==
X-Gm-Message-State: APjAAAV9InZv7mtzGH+mk/o3bKWvvXWz29TAo075e3IVsP9xKuSPWil1
        eFNnoK36tnjJWhMDfqY5o9nAKUIoWaYcdyx+4/+Va1uAEERqZHXabYfN7hX1GYoIYq1oLcYuQAC
        8esMxppS7VA/kdfRB
X-Received: by 2002:a05:620a:15f4:: with SMTP id p20mr3845057qkm.272.1582706549677;
        Wed, 26 Feb 2020 00:42:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqyNEN49K/3n99ijMioDH+6oN7IkPJ/X/nkeDDmMmPoNa7kAu3jptkzLTdCKNZVrJ38Fk36iUQ==
X-Received: by 2002:a05:620a:15f4:: with SMTP id p20mr3845040qkm.272.1582706549499;
        Wed, 26 Feb 2020 00:42:29 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id l3sm732703qtf.76.2020.02.26.00.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:42:28 -0800 (PST)
Date:   Wed, 26 Feb 2020 03:42:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
Message-ID: <20200226034004-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
 <87wo89zroe.fsf@toke.dk>
 <20200226032204-mutt-send-email-mst@kernel.org>
 <87r1yhzqz8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1yhzqz8.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 09:34:51AM +0100, Toke Høiland-Jørgensen wrote:
> we already do block some reconfiguration if an XDP program is loaded
> (such as MTU changes), so there is some precedence for that :)
Do we really block MTU changes when XDP is loaded?
Seems to work for me - there's a separate discussion going
on about how to handle MTU changes - see
https://lore.kernel.org/r/7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com
	virtio_net: can change MTU after installing program

-- 
MST

