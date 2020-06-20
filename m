Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13B120233F
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 12:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgFTKmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 06:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgFTKmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 06:42:49 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BE3C0613EE
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 03:42:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id q11so12019986wrp.3
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 03:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjYrvX5Xg4/zDKs440DRFSzipo55xnvNBQlkBuatSQA=;
        b=AiMu0NtKJP/nMRDzLWTG2nwqYgspLRLW6yNl4uXPO18PKQeONMPV4jLpfXhNnY6sjE
         nxcmdYVlnkKeUHH5w1X/392WG7Jsmv14hqIyL3yTx+OVuPhlfbggUyKzthU2I+GcPkw+
         h7x5e13y2YNYfx5EvhVLOpRjR2i0tXYbkIcco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjYrvX5Xg4/zDKs440DRFSzipo55xnvNBQlkBuatSQA=;
        b=uLEYFsVMG0/LTX/tLEm+DT6JMroJ7xqF11g8MHq/MQavBouLTnROVWyeVh8hmSD4CS
         fKbUMN8rA3+kxkJOAMVTmK8QvNszxBT32C2lRwK0uVjYZ5ujDDdf93xFxBHiPlhjw1Bm
         KgG8GzXMYQQHnPtJrjGP+Po6Yzw3O3wuWSUCaYXqVnt2i1Tjyk3ZnxaqoQVVyenjkJQ1
         3m+Xv3bl803DBX9ePtyMal4eLsH7keGwQUOvf/lZqa/LWorQ43GhUFWJU3fMRPnDufpp
         XhY8f9d0gbK2PJN77idvux89WVek8fh6mtj4t20yRQt9+tnlIczeGr1quBw2p4Y+jg8y
         cGvQ==
X-Gm-Message-State: AOAM532XwN9tfQbMwACW8BNTx/3MspVRee6nVq1+THHl+p4cCJKdLazf
        JRyG9KU1liMI3cY4jJnnvYj/HrPRpYdMADhqt3Jxiw==
X-Google-Smtp-Source: ABdhPJw3azsvlXSiwIuxzPq0kHHHqC03dLWG0bY6WtuL95CkMoW7iqBzuNbtORpbMrNDSRywMgiz37GKhDGCc+yWYhE=
X-Received: by 2002:adf:9525:: with SMTP id 34mr9025584wrs.313.1592649767455;
 Sat, 20 Jun 2020 03:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
 <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
 <20190902110818.2f6a8894@carbon> <fd3ee317865e9743305c0e88e31f27a2d51a0575.camel@mellanox.com>
 <CAHApi-k=9Szxm0QMD4N4PW9Lq8L4hW6e7VfyBePzrTgvKGRs5Q@mail.gmail.com> <20200618150347.ihtdvsfuurgfka7i@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200618150347.ihtdvsfuurgfka7i@bsd-mbp.dhcp.thefacebook.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Sat, 20 Jun 2020 12:42:36 +0200
Message-ID: <CAHApi-kMwnvRwJO8LT2UtrixVSd_bDgWybOP6H_eLTBmSFsd4A@mail.gmail.com>
Subject: Re: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "toke.hoiland-jorgensen@kau.se" <toke.hoiland-jorgensen@kau.se>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 5:23 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Sun, Jun 14, 2020 at 10:55:30AM +0200, Kal Cutter Conley wrote:
> > Hi Saeed,
> > Thanks for explaining the reasoning behind the special mlx5 queue
> > numbering with XDP zerocopy.
> >
> > We have a process using AF_XDP that also shares the network interface
> > with other processes on the system. ethtool rx flow classification
> > rules are used to route the traffic to the appropriate XSK queue
> > N..(2N-1). The issue is these queues are only valid as long they are
> > active (as far as I can tell). This means if my AF_XDP process dies
> > other processes no longer receive ingress traffic routed over queues
> > N..(2N-1) even though my XDP program is still loaded and would happily
> > always return XDP_PASS. Other drivers do not have this usability issue
> > because they use queues that are always valid. Is there a simple
> > workaround for this issue? It seems to me queues N..(2N-1) should
> > simply map to 0..(N-1) when they are not active?
>
> If your XDP program returns XDP_PASS, the packet should be delivered to
> the xsk socket.  If the application isn't running, where would it go?
>
> I do agree that the usability of this can be improved.  What if the flow
> rules are inserted and removed along with queue creatioin/destruction?

I think I misunderstood your suggestion here. Do you mean the rules
should be inserted / removed on the hardware level but still show in
ethtool even if they are not active in the hardware? In this case the
rules always occupy a "location" but just never apply if the
respective queues are not "enabled". I think this would be the best
possible solution.

> --
> Jonathan

Kal
