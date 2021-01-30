Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A119309829
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 21:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhA3UGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 15:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhA3UGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 15:06:32 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52713C061574
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 12:05:52 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id k193so12315442qke.6
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 12:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1L7e5QSERZYADHeNnRslO7TOplps1kXnEHhGdSMbfkA=;
        b=N9MZ/epOFY16VaZxVtueFsmeemJeK3/is1MKqatKVZF3J9BqzNJn1naeX1r66Nv3SQ
         OfCb3iQ3r7wpNw19WmKhbUAnTZ5BwbP8zeLJXL1/nIGfI4HISClxPH755oGOv/mnAcvx
         Mfz9gcKzJ2XX0vxdA+leP12zX3SUF/IadFAoSROUfTTRvId76wm37MdRo8ORP0Dvc+q3
         35fmUNu5tqjVB5hIum8zhYwplLPuY/Z6H92/jPFF6izOETLVoKXtWGitTOyZQKKczjnJ
         Lu+182JWacVw8DeV6eCfVlbmN6u83QurnYkSZYdnCQoeXcrt4uL5mDFYcCH5hkush6W0
         R5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1L7e5QSERZYADHeNnRslO7TOplps1kXnEHhGdSMbfkA=;
        b=Ak2jZW4jUCJ+UmpBHw0nKQdBnBsASN9i0htLO52XHo45XJg8Bu50QeCliNQ7L73iVj
         QsaS8XpNV+uHlc0Pjhdb3Y69lmpQX8GSxJH3KjyRRQGk77tfaF18DOYF1Vs5iVwPsvjy
         YSbtzbyBslc5UpfKug4Zq4FjC2u9z8EV1u1llo9AA5lHq1gURlme5XHJ6Ef5M/BfRW3c
         1mi1d0XyY7iMaPsgd/Z5pPrc3f2KbxD9w9lmXhfoEINskm3vb6QGtkEv5tKRnFd5V/Ea
         wGfXF+Xo9jnLJSlVu/HFoUCFxQ4cLhBlh7Wc01a0Ci+S5lhWKiSWVoL4RnrJseEwRjjW
         JCLg==
X-Gm-Message-State: AOAM531viH24YhH9FP6cqDEeDbTqiYNMhBuxkHKq0RLttyZ42VmWh9n5
        d56fFhOy0MI4nnkx78j6ZI0Abi2TEP2pXfrOwHY=
X-Google-Smtp-Source: ABdhPJxxgZjBvOvD7cVxeYRK00XW4KIFoC/65DvdUCOpJPWXy8+I54W9t0A8SfNkBA0PchPVBAnsFBJk8IGtW0wUtcg=
X-Received: by 2002:a37:a286:: with SMTP id l128mr9739954qke.78.1612037151606;
 Sat, 30 Jan 2021 12:05:51 -0800 (PST)
MIME-Version: 1.0
References: <20210123195916.2765481-1-jonas@norrbonn.se> <20210123195916.2765481-16-jonas@norrbonn.se>
 <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se> <CAOrHB_DFv8_5CJ7GjUHT4qpyJUkgeWyX0KefYaZ-iZkz0UgaAQ@mail.gmail.com>
 <9b9476d2-186f-e749-f17d-d191c30347e4@norrbonn.se> <CAOrHB_Cyx9Xf6s63wVFo1mYF7-ULbQD7eZy-_dTCKAUkO0iViw@mail.gmail.com>
 <20210130104450.00b7ab7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210130104450.00b7ab7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sat, 30 Jan 2021 12:05:40 -0800
Message-ID: <CAOrHB_DQTsEPEWpPVEcpSnbkLLz8eWPFvvzzO8wjuYsP4=9-QQ@mail.gmail.com>
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonas Bonn <jonas@norrbonn.se>,
        Harald Welte <laforge@gnumonks.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 10:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 29 Jan 2021 22:59:06 -0800 Pravin Shelar wrote:
> > On Fri, Jan 29, 2021 at 6:08 AM Jonas Bonn <jonas@norrbonn.se> wrote:
> > > On 28/01/2021 22:29, Pravin Shelar wrote:
> > > > Receive path: LWT extracts tunnel metadata into tunnel-metadata
> > > > struct. This object has 5-tuple info from outer header and tunnel key.
> > > > When there is presence of extension header there is no way to store
> > > > the info standard tunnel-metadata object. That is when the optional
> > > > section of tunnel-metadata comes in the play.
> > > > As you can see the packet data from GTP header onwards is still pushed
> > > > to the device, so consumers of LWT can look at tunnel-metadata and
> > > > make sense of the inner packet that is received on the device.
> > > > OVS does exactly the same. When it receives a GTP packet with optional
> > > > metadata, it looks at flags and parses the inner packet and extension
> > > > header accordingly.
> > >
> > > Ah, ok, I see.  So you are pulling _half_ of the GTP header off the
> > > packet but leaving the optional GTP extension headers in place if they
> > > exist.  So what OVS receives is a packet with metadata indicating
> > > whether or not it begins with these extension headers or whether it
> > > begins with an IP header.
> > >
> > > So OVS might need to begin by pulling parts of the packet in order to
> > > get to the inner IP packet.  In that case, why don't you just leave the
> > > _entire_ GTP header in place and let OVS work from that?  The header
> > > contains exactly the data you've copied to the metadata struct PLUS it
> > > has the incoming TEID value that you really should be validating inner
> > > IP against.
> > >
> >
> > Following are the reasons for extracting the header and populating metadata.
> > 1. That is the design used by other tunneling protocols
> > implementations for handling optional headers. We need to have a
> > consistent model across all tunnel devices for upper layers.
>
> Could you clarify with some examples? This does not match intuition,
> I must be missing something.
>

You can look at geneve_rx() or vxlan_rcv() that extracts optional
headers in ip_tunnel_info opts.
