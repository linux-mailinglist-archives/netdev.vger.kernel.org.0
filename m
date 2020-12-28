Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A892E35B7
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 11:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgL1KM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 05:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgL1KM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 05:12:29 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FA2C061795
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 02:11:48 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id j16so9318520edr.0
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 02:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MdQ/D46RCr2gXEW9dmoWKE5z9/ANQwkSP5KORk8yc40=;
        b=ZBuKDesRddgX9RuM0o93raruELuqg8VG7S9kK93UqTMa+aks62BN7/+4o//wzVUEBh
         qivzEiNeTLfajSJaZvGzJFLYS91CJyuMy1vK6xu91HjRGkvqTUJCxNSzLfdCspYqLb+w
         EqBzSdBsJIewfU/F9vkeMKceMOcSBYu4944ZBdpRyqAn7zGEWn31Gkf3KYGqJXNL1wuv
         14bjishNlU0BYaYxRsocQQqsVDHKbmpI5ZIOvS6L1aNs2TiIvgLK5dQr5hROvFPYJ4a4
         4iQ0OizTb5qe2A58Mt8b2ugNilPKaFLLx6DFZ9BAyEp8qAX8chL4eLNJ6zGhO9kkhyfF
         LzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MdQ/D46RCr2gXEW9dmoWKE5z9/ANQwkSP5KORk8yc40=;
        b=JZzorlq9I+Jt+n5XmbhG+aU9CPF8byqo4RSBVaZvjkuj9mRpIHMRtYlFKJVPGBzMbi
         gDxKzSG4pUT0O+Z2t/ly6b6NVRbISKR9hgbi/tl+nH2etv34e1Oo77hBs0/CwEneeM38
         Xiyp0+5rXcX8DxJDiURYqHLfI3A532zLEDxHLFjyARmxieap68gtwiRyNTAN3rtijTdF
         +kF/ZpM7mM6+SUjjP8YQNkI3XdpQ4azWTlzw8HjbfSiv9rTi6VVj6YhCgoz4+yLQgWTr
         SbvX1xU/LsCHF3C8su3id0amee/0mBeGnUtWVzMk2x2TErCGce6yRKuwvM20FhbkeHak
         MnyQ==
X-Gm-Message-State: AOAM533975Ckh02ntSFNIh18fXCSHv/pMsj/c3L/bsvJxZBowe/gi9jy
        RH3Yg00sO0H7BPAnodbyQ2FJZg==
X-Google-Smtp-Source: ABdhPJzeBaAkxj3tRnfGYpjL14Szrs6UwTMpJTmk/jp+31CRpAHxsvrevzdJBUP+5u2X2QeyPEqkdA==
X-Received: by 2002:a50:d5d5:: with SMTP id g21mr42913750edj.41.1609150306867;
        Mon, 28 Dec 2020 02:11:46 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id ca4sm35731648edb.80.2020.12.28.02.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 02:11:46 -0800 (PST)
Date:   Mon, 28 Dec 2020 11:11:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] bonding: add a vlan+srcmac tx hashing option
Message-ID: <20201228101145.GC3565223@nanopsycho.orion>
References: <20201218193033.6138-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218193033.6138-1-jarod@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 18, 2020 at 08:30:33PM CET, jarod@redhat.com wrote:
>This comes from an end-user request, where they're running multiple VMs on
>hosts with bonded interfaces connected to some interest switch topologies,
>where 802.3ad isn't an option. They're currently running a proprietary
>solution that effectively achieves load-balancing of VMs and bandwidth
>utilization improvements with a similar form of transmission algorithm.
>
>Basically, each VM has it's own vlan, so it always sends its traffic out
>the same interface, unless that interface fails. Traffic gets split
>between the interfaces, maintaining a consistent path, with failover still
>available if an interface goes down.
>
>This has been rudimetarily tested to provide similar results, suitable for
>them to use to move off their current proprietary solution.
>
>Still on the TODO list, if these even looks sane to begin with, is
>fleshing out Documentation/networking/bonding.rst.

Jarod, did you consider using team driver instead ? :)
