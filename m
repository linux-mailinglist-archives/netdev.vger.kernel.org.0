Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F9149C93B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241045AbiAZMEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:04:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233883AbiAZMEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 07:04:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643198644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rxu+xIvjFnCWUUg4LR7b57e/T2dW4crjuCGw7/sZ+G4=;
        b=Lj2ezPyKlvBmkjFBkGXraLeTsywzw3npKDUuzW2XM8oXmxLGY64gML75RXKtoPSY3Shns2
        T+ZLRWD3rR4PH8Ysm8vNjsexu9SdWVJVjwUtVYLYIBxTsSgginD4sVU7VcUZ5cj5w/xdGf
        cPVtOFwOdgI8+3KTsd6/IRVgeAl3hs4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-GywpGgsSMv2G2VIsLpnN7w-1; Wed, 26 Jan 2022 07:04:03 -0500
X-MC-Unique: GywpGgsSMv2G2VIsLpnN7w-1
Received: by mail-ej1-f70.google.com with SMTP id i21-20020a1709063c5500b006b4c7308c19so4785589ejg.14
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 04:04:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Rxu+xIvjFnCWUUg4LR7b57e/T2dW4crjuCGw7/sZ+G4=;
        b=MERkkJeQ5romNMrn3L2zQTlh04YOnfJq2Dz5t2UIOm+ziRmebnYG1UP9TamFniZT8C
         dERdjCKG0F9yOdc59kMjJnjrz/gNQe+IR90FSGOenAWoqNwtQqO0+psFz9MVwi1hyfpk
         5Tge19dEAPD1BzgIOgtt0mqyd8/cI18C/Q9LbR8ju4CTLHT0ri7mqNsPuvKYlABPndKB
         Ay16A6aXxoEiwG8CfPmQ2kQNtot+dtpDalRV+kgRu34Eck4XWNrQIsSQ60VUyTdgY27A
         uN2qyU20T174Ygn9lzI873d2LKTrQEO+7e8snkHmvikNV1Nsq+EJxZYAN7VsxU1b0bUF
         QlYg==
X-Gm-Message-State: AOAM532bziQD1DzsH89jlHcBYeeqGXwI2JVyz1WusryQYSTbXbV6RH0l
        Fs0WXW+UrnweEFdAYMNXPeHUgXXuw3N0QPgNkyXuSndy6aZbQ/lzHdEXrv07Pl/j3ZxrnQms43i
        ljZ09v+zEySK3us/u
X-Received: by 2002:a17:906:5208:: with SMTP id g8mr19288935ejm.634.1643198639445;
        Wed, 26 Jan 2022 04:03:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx20qiGcount9gXgCJ4X5aF3vX+eaFsSPFELTeKR1M5Z7OzD9puXNwQl5QGT0zPpIiW6u90uw==
X-Received: by 2002:a17:906:5208:: with SMTP id g8mr19288858ejm.634.1643198638008;
        Wed, 26 Jan 2022 04:03:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b7sm6493432edv.58.2022.01.26.04.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 04:03:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EEF051805FA; Wed, 26 Jan 2022 13:03:56 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, memxor@gmail.com,
        andrii.nakryiko@gmail.com
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
In-Reply-To: <YfEzl0wL+51wa6z7@lore-desk>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <878rv558fy.fsf@toke.dk> <YfEzl0wL+51wa6z7@lore-desk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Jan 2022 13:03:56 +0100
Message-ID: <87bkzy3dqr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

>> > +	rcu_read_lock();
>> 
>> This is not needed when the function is only being called from XDP...
>
> don't we need it since we do not hold the rtnl here?

No. XDP programs always run under local_bh_disable() which "counts" as
an rcu_read_lock(); I did some cleanup around this a while ago, see this
commit for a longer explanation:

782347b6bcad ("xdp: Add proper __rcu annotations to redirect map entries")

-Toke

