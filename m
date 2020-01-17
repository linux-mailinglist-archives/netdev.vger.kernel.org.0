Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9392140BDD
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 14:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgAQN7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 08:59:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30306 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726587AbgAQN7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 08:59:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579269564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ls+kSlHqVQ+u1kX+cqEVnpc6zmG7oOzrJUKMo8AMl8=;
        b=bi4XHCn5f0VF//QnTAN3ohN78pbEp6Bbrf+4dz1IZgvSo0B9z6V8ddivOFI0U/uq/9DkN2
        W4PNANRtMIwDwBNs9l/tKx+PwZTPiCrX7tlNLTXZ5FHa+TvDqQp09k7UtXjxsCuFOdVOIs
        UQiE/w6PLpElFE9H0pST0oqGLu1d0Mk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-ZC8PAMjyM5yc1Hmc29zDNQ-1; Fri, 17 Jan 2020 08:59:22 -0500
X-MC-Unique: ZC8PAMjyM5yc1Hmc29zDNQ-1
Received: by mail-ed1-f69.google.com with SMTP id ay24so13342017edb.0
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 05:59:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ls+kSlHqVQ+u1kX+cqEVnpc6zmG7oOzrJUKMo8AMl8=;
        b=DpX+cLjFUsCJry4plq0mFtemFK1+PFUE9b9kuNygSYxgNVXabRkE1OzDl9wqREjS+x
         ErO1lEgQOiQELbcqIpDl//gtYLN8/4GfA43mdP55RD+jLNIfNhk1u9UfRLDq672uJqT6
         UX/weqfKgAheRmavFcdlkmyttxCH6/JwpuFyPnBspIiY0JF4etRhZCvRpskAaglA8XMs
         lXx0vW2zRtD1FgdnJ7wPIiSxBKx3+Q8KqF8s72kCllLeUsDVLBRN8+GrW1ZOtFf8ZrdK
         TIF2/G0R1VJpdXm2ItNGJailOuMC7TYIudXbadnE8QaxRiSaK8EacvWANzzifv956c+I
         Lt8w==
X-Gm-Message-State: APjAAAWgF+90gF546y2/xGsxEVvnNxGCfVuxcHebpGRVqGumOk0MHg0j
        ePWSEfEUGTHRE/o5B/2IEfyJnZJql3fHEI2fEuYTEEBscGDpbRTtRRNZFO20jWqsT30GvfKNLUw
        j7HvdP247JpBrdZf5iHC2Ej80QtJ9lefG
X-Received: by 2002:a50:d713:: with SMTP id t19mr3929116edi.367.1579269561388;
        Fri, 17 Jan 2020 05:59:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqxAsGzCXA9EJ4EPSY4ugITvGbPZH1q8+xILVMKbBBuBJ7J37TP4OBaxSDbpsc38DeebLkBIv5h+jImU9urNBYM=
X-Received: by 2002:a50:d713:: with SMTP id t19mr3929095edi.367.1579269561228;
 Fri, 17 Jan 2020 05:59:21 -0800 (PST)
MIME-Version: 1.0
References: <20200115164030.56045-1-mcroce@redhat.com> <f3c001e1-8963-536d-4158-3ce16ad5de69@redhat.com>
In-Reply-To: <f3c001e1-8963-536d-4158-3ce16ad5de69@redhat.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 17 Jan 2020 14:58:45 +0100
Message-ID: <CAGnkfhy=GtFzwEUabfnZ9L7q3D0PHjUmntKxD6bQGk6vqrwcZQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3] openvswitch: add TTL decrement action
To:     Jeremy Harris <jgh@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 2:44 PM Jeremy Harris <jgh@redhat.com> wrote:
>
> On 15/01/2020 16:40, Matteo Croce wrote:
> > New action to decrement TTL instead of setting it to a fixed value.
> > This action will decrement the TTL and, in case of expired TTL, drop it
> > or execute an action passed via a nested attribute.
> > The default TTL expired action is to drop the packet.
>
> On drop, will it emit an ICMP?
> --
> Cheers,
>   Jeremy
>

No, drop will silently drop it.

But if you add an action which sends the packet to userspace, the
controller can send an ICMP TTL exceeded response.

-- 
Matteo Croce
per aspera ad upstream

