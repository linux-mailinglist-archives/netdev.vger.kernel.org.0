Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B8A8A98C
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfHLVnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:43:23 -0400
Received: from mail-qk1-f177.google.com ([209.85.222.177]:39816 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHLVnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:43:22 -0400
Received: by mail-qk1-f177.google.com with SMTP id 125so5120180qkl.6
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2sIpWQ6RPCE7AwMWmnBJWnxDq+8VX1GCPKjS805Q+Ho=;
        b=tqVlPujQQP2P8ag08LAUwjLlV0o+Wm8QQthUXNSj6w8j1mDwuDp1Bwl9wVTeUi993n
         MckXpjHY19OOHzbEuVeXMzZX/bWsjhdBWNbJKzCAOCxA+mdsNFVAWmOltQxA2Qnsx27y
         pWCCwyOgNknFTYNRhGXsNrCmCydEeyj/IYogdpbQoiEOV3aBM3NUfVvY6KVBPFOx+38c
         +5QtufZGl/pxTSkdvVPfU9XODM8MxlK5SnxTQRs7GFtFiqsOQbohbvayFevKzvh+lEqo
         P6McJGwHkyPuk9nL6Ji5QgkdDzaZBEei3NUjB/pjZz9VexgUrPwo42Z5J+yGOriBjdGn
         mC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2sIpWQ6RPCE7AwMWmnBJWnxDq+8VX1GCPKjS805Q+Ho=;
        b=RtebY5JHPWpx5pMwk4kc7XitWm1ik0W/PLAMQ01wdpJB6TG3Ch9+03BVL57rtcGBL+
         iuQcur5DKo1pC8SrY+8ktHYd2unFvmc/lAw8f6nT1qcaopw+sFUID/PKjS18lUI+JI29
         1NxvOBdIUFN4PgqRhvlPiwE1qOGFTIRmxDSknLW1loSWlrCNN2op9JZhu62nWvJNeSqM
         NG5nlBZPD4lEiLLrDG203t+5o3lvE9+FDYRcEdhDiP5c1pdGBM0K6uP43encjzZFa5lu
         WlMTAzgiNV1HYzOPZUwWUt+RXRAf+BW5coEwmNXYhgj6dU5uBeQ1QlYFZRv06IGd1wR/
         nlxA==
X-Gm-Message-State: APjAAAVEpnXMb8pXySb24Hvd+1t6xE6FZsehaPSBSBXUNOyKdm087PAg
        5D5MRPoF5AyWJ89k4VXLuYjhNw==
X-Google-Smtp-Source: APXvYqyTKSDQtCSp7o0G58bYA/pu6x+HDdpbFKHOo0Hmk2PKDo1Gy1gCnI36IIAi4xnS7yrWU4tHPA==
X-Received: by 2002:ae9:f016:: with SMTP id l22mr31632778qkg.51.1565646201869;
        Mon, 12 Aug 2019 14:43:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u28sm2333335qtu.22.2019.08.12.14.43.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 14:43:20 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:43:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add
 and delete alternative ifnames
Message-ID: <20190812144310.442869de@cakuba.netronome.com>
In-Reply-To: <CAJieiUhqAvqvxDZk517hWQP4Tx3Hk2PT7Yjq6NSGk+pB_87q8A@mail.gmail.com>
References: <20190719110029.29466-1-jiri@resnulli.us>
        <20190719110029.29466-4-jiri@resnulli.us>
        <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
        <20190809062558.GA2344@nanopsycho.orion>
        <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
        <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
        <20190810063047.GC2344@nanopsycho.orion>
        <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
        <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
        <20190812083139.GA2428@nanopsycho>
        <CAJieiUhqAvqvxDZk517hWQP4Tx3Hk2PT7Yjq6NSGk+pB_87q8A@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 08:13:39 -0700, Roopa Prabhu wrote:
> On Mon, Aug 12, 2019 at 1:31 AM Jiri Pirko <jiri@resnulli.us> wrote:
> > Mon, Aug 12, 2019 at 03:37:26AM CEST, dsahern@gmail.com wrote:  
> > >On 8/11/19 7:34 PM, David Ahern wrote:  
> > >> On 8/10/19 12:30 AM, Jiri Pirko wrote:  
> > >>> Could you please write me an example message of add/remove?  
> > >>
> > >> altnames are for existing netdevs, yes? existing netdevs have an id and
> > >> a name - 2 existing references for identifying the existing netdev for
> > >> which an altname will be added. Even using the altname as the main
> > >> 'handle' for a setlink change, I see no reason why the GETLINK api can
> > >> not take an the IFLA_ALT_IFNAME and return the full details of the
> > >> device if the altname is unique.
> > >>
> > >> So, what do the new RTM commands give you that you can not do with
> > >> RTM_*LINK?
> > >
> > >To put this another way, the ALT_NAME is an attribute of an object - a
> > >LINK. It is *not* a separate object which requires its own set of
> > >commands for manipulating.  
> >
> > Okay, again, could you provide example of a message to add/remove
> > altname using existing setlink message? Thanks!  
> 
> Will the below work ?... just throwing an example for discussion:
> 
> make the name list a nested list
> IFLA_ALT_NAMES
>         IFLA_ALT_NAME_OP /* ADD or DEL used with setlink */
>         IFLA_ALT_NAME
>         IFLA_ALT_NAME_LIST
> 
> With RTM_NEWLINK  you can specify a list to set and unset
> With RTM_SETLINK  you can specify an individual name with a add or del op
> 
> notifications will always be RTM_NEWLINK with the full list.
> 
> The nested attribute can be structured differently.
> 
> Only thing is i am worried about increasing the size of link dump and
> notification msgs.

Is not adding commands better because it's easier to deal with the
RTM_NEWLINK notification? I must say it's unclear from the thread why
muxing the op through RTM_SETLINK is preferable. IMHO new op is
cleaner, do we have precedent for such IFLA_.*_OP-style attributes?
