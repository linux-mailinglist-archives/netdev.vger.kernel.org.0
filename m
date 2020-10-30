Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9402A054A
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgJ3MUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgJ3MTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:19:33 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2FCC0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 05:19:33 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id h19so3881316qtq.4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 05:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FXgSFwizVIhpGiUxr1iNj2XrB6DzcbAavez8DAqhiR0=;
        b=aMcp+xqiFXSm1X4vhQilJ7Kv7xircmCspbUJjDjhg26OErdG1F2hc6je6+ZKNRWzzu
         dT11ls9FJef3pN+GhJiWEgP6MOqHlkHJ8EhPs19EGnfkakzGIwZp1PwKy0mgVZ1eY7Kx
         /t2ngKuZvh10edOmwoSllx2g30dMeoef3IF6zhmc7gttYWIowsfwTV969enCmBjEaMFJ
         61eMErWpkRuUCCahzorD7BTfGRFl17dnSU5jvfteHrWRR9FkiOs+tqhkiGmtMs3cp8qd
         zVJu6Z8wGaBZYsNQBVwLnCjh6HehWjhvOt3SwU0yKt/bnXzgIjWjtklWgDBTCiNlCExs
         ITew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FXgSFwizVIhpGiUxr1iNj2XrB6DzcbAavez8DAqhiR0=;
        b=CD0kUXnRbW27lvnI8RvX0leNvsxQsLyHkvphQwCU0xa8tvt57p/dKPD4fPVbH0tFT5
         7hv+/hfYaQreIkfbhADzR+OXrcRTlK/+vctfqajdz2t4p8XAWBDBrKl0H9jPFgqayiEJ
         nsE4/GJWPM4MJBvhIHnFp4tRaEVZFRmDndPoCLhQG4dftAu3XNufrnEoj2q8EPIlBQS7
         eKBW0vdqXjG/W9PnMnge8l4WmSKFzjMGHdo7HQuNxTV3/RjHB64AQKgAJzKMnVSYe28K
         6tsT/gbIUoAb2nMln1XAmzqZ00H8d9fv7ZDIvGDipHuFXSEAaUwYo4Qm/2D0xAkfO2zC
         qzTA==
X-Gm-Message-State: AOAM530W4atYdz8Vqn2dxcNed6PkI8P2VTFqzfpGRC8HqfbvMg6lxAUj
        BkY4RttxSCV9lclh8MKg20k=
X-Google-Smtp-Source: ABdhPJzBqJkMOEOhAbk4c/GYzaMDgMl0MErSZBHR+oxXbgiUIl0Z/lEATZ2qURYNNYNy0qw8ap+fIA==
X-Received: by 2002:ac8:7409:: with SMTP id p9mr1655422qtq.351.1604060370823;
        Fri, 30 Oct 2020 05:19:30 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:3996:7c32:c023:7030:e73a])
        by smtp.gmail.com with ESMTPSA id k3sm2380305qtj.84.2020.10.30.05.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 05:19:29 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 98173C0DAB; Fri, 30 Oct 2020 09:19:27 -0300 (-03)
Date:   Fri, 30 Oct 2020 09:19:27 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [resend] Solution for the problem conntrack in tc subsystem
Message-ID: <20201030121927.GB11029@localhost.localdomain>
References: <7821f3ae-0e71-0d8b-5ef9-81da69ac29dc@ucloud.cn>
 <435e4756-f36a-f0f5-0ac5-45bd5cacaff2@ucloud.cn>
 <20201029225936.GM3837@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029225936.GM3837@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 07:59:36PM -0300, Marcelo Ricardo Leitner wrote:
> Cc'ing Cong, Paul, Oz and Davide.
> 
> On Thu, Oct 29, 2020 at 10:22:04AM +0800, wenxu wrote:
> > Only do gso for the reassembly big packet is also can't fix all the
> > case such for icmp packet.
> 
> Good point. And as we can't know that a fragment was for an icmp
> packet before defraging it, this is quite impactful.

Doh, we can, as that info is always present on the iphdr, but still,
quite impactful, as we would have to have special rule sets to cope
with it.

  Marcelo
