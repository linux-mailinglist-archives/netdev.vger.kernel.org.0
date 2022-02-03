Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04684A8B30
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353160AbiBCSHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:07:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233118AbiBCSHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:07:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643911656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oxlN7OwDYW+AO5GUu76ZIRNgAVPZQnlCKRtpC+fQGoA=;
        b=Oz4ot/EFacmMSP7/r4m4B9+X5kWcvK/M51vdbVHVThLjkUJliae1Vvy0dC7Wf//ZGo1K6J
        r6T6A/ek6MHZFcNfO/BkYgoEuw6oUekXqRBS2C6mMRioI27+lfOwENCNdEGBmPS8HjozC7
        LwZMkMeZjNHkom34JOwipPUi3gGuz+M=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-Cbzr33dVPLecS6xwcIViCw-1; Thu, 03 Feb 2022 13:07:34 -0500
X-MC-Unique: Cbzr33dVPLecS6xwcIViCw-1
Received: by mail-qt1-f198.google.com with SMTP id h22-20020ac85696000000b002d258f68e98so2706811qta.22
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 10:07:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oxlN7OwDYW+AO5GUu76ZIRNgAVPZQnlCKRtpC+fQGoA=;
        b=bTs/+Of5lUApnn9lMSyvj9TAdf//gv/L3RZ0ydg0tlMiFxVVgA6VuLxIVwzqDB6vT5
         /IhGkFsqFCjI0uZAUHFN+fM9RBomoYRCQKmS/FBvkbZmolylEgm5FBinCg4HSHMn02AU
         PycxYWAsltXQEFj+8eJBU6hcoy07Tvb8uWh7NiWsom6/SJ2xeSaijMTzeZ4EzNY6O91R
         BWdYi343Sq8cF1k45H3WhZTpXjq+9Bv+sp8JURW3Zwh0rj7H2TMjIAA/BCBqtD6wi9My
         d92ysWc3D2e5oCN8csWC6bWs3s7dxnay4iV6S9WKYDVKH8viiyzdbH2XLBROoWuGChvo
         Vc2A==
X-Gm-Message-State: AOAM533gn9i0W7cPV/qSSiUYXgGBEX3btPraAv+FCZF8D+uHEJIkPuCO
        SEbLyUn+CrhZvJLaAKefA8uvj2maV6odHrOrgIEIR7snjqBAqkvy9fnXO3CvzF8EqP+C9r+h9nh
        qNW/tMMXZFo51H66U
X-Received: by 2002:ad4:5962:: with SMTP id eq2mr32251607qvb.99.1643911653399;
        Thu, 03 Feb 2022 10:07:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVBB2RSjqChnipqs8SPy/7rTEUd03WkXxSP4BB+hBHVFjzilZ/hT/WngJ/v6gX6/yHPX7Txw==
X-Received: by 2002:ad4:5962:: with SMTP id eq2mr32251580qvb.99.1643911653143;
        Thu, 03 Feb 2022 10:07:33 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id l11sm15490466qkp.86.2022.02.03.10.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 10:07:32 -0800 (PST)
Message-ID: <dce81ce750946287ff08aa1821d7428cd622ddfa.camel@redhat.com>
Subject: Re: [PATCH net-next 3/3] net: gro: register gso and gro offload on
 separate lists
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 03 Feb 2022 19:07:29 +0100
In-Reply-To: <CANn89i+PnPNFpd-eap1n5VPZn__+Q-0BCP46hf+_kVJfw_phYQ@mail.gmail.com>
References: <cover.1643902526.git.pabeni@redhat.com>
         <550566fedb425275bb9d351a565a0220f67d498b.1643902527.git.pabeni@redhat.com>
         <CANn89iLvee2jqB7R7qap9i-_johkbKofHE4ARct18jM_DwdaZg@mail.gmail.com>
         <20220203162619.13881-1-alexandr.lobakin@intel.com>
         <CANn89i+PnPNFpd-eap1n5VPZn__+Q-0BCP46hf+_kVJfw_phYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-03 at 08:41 -0800, Eric Dumazet wrote:
> On Thu, Feb 3, 2022 at 8:28 AM Alexander Lobakin
> <alexandr.lobakin@intel.com> wrote:
> > 
> > From: Eric Dumazet <edumazet@google.com>
> > Date: Thu, 3 Feb 2022 08:11:43 -0800
> > 
> > > On Thu, Feb 3, 2022 at 7:48 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > 
> > > > So that we know each element in gro_list has valid gro callbacks
> > > > (and the same for gso). This allows dropping a bunch of conditional
> > > > in fastpath.
> > > > 
> > > > Before:
> > > > objdump -t net/core/gro.o | grep " F .text"
> > > > 0000000000000bb0 l     F .text  000000000000033c dev_gro_receive
> > > > 
> > > > After:
> > > > 0000000000000bb0 l     F .text  0000000000000325 dev_gro_receive
> > > > 
> > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > ---
> > > >  include/linux/netdevice.h |  3 +-
> > > >  net/core/gro.c            | 90 +++++++++++++++++++++++----------------
> > > >  2 files changed, 56 insertions(+), 37 deletions(-)
> > > > 
> > > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > > index 3213c7227b59..406cb457d788 100644
> > > > --- a/include/linux/netdevice.h
> > > > +++ b/include/linux/netdevice.h
> > > > @@ -2564,7 +2564,8 @@ struct packet_offload {
> > > >         __be16                   type;  /* This is really htons(ether_type). */
> > > >         u16                      priority;
> > > >         struct offload_callbacks callbacks;
> > > > -       struct list_head         list;
> > > > +       struct list_head         gro_list;
> > > > +       struct list_head         gso_list;
> > > >  };
> > > > 
> > > 
> > > On the other hand, this makes this object bigger, increasing the risk
> > > of spanning cache lines.
> > 
> > As you said, GSO callbacks are barely used with most modern NICs.
> > Plus GRO and GSO callbacks are used in the completely different
> > operations.
> > `gro_list` occupies the same place where the `list` previously was.
> > Does it make a lot of sense to care about `gso_list` being placed
> > in a cacheline separate from `gro_list`?
> 
> Not sure what you are asking in this last sentence.
> 
> Putting together all struct packet_offload and struct net_offload
> would reduce number of cache lines,
> but making these objects bigger is conflicting.
> 
> Another approach to avoiding conditional tests would be to provide non
> NULL values
> for all "struct offload_callbacks"  members, just in case we missed something.
> 
> I think the test over ptype->type == type should be enough, right ?

I'll try this later approach, it looks simpler.

Also I'll keep this patch separate, as the others looks less
controversial.

Thanks!

Paolo


