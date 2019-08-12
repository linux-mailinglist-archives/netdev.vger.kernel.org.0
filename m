Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3F78A282
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHLPkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:40:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37533 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHLPkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 11:40:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id d1so16860456pgp.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 08:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6FcQAxIfEahUorsEma1oL75v92II5Zkq1A/PM/S0gb4=;
        b=FouWC44GcvZe9/YBFDnhf6IFCwesiK0u4iM0VKM4qupUz5RogIcGHx2DxzU4EMiOTv
         HnNgp18iLAMFGXn9HJaykUUZT/r2tL28kPw9hai6PJdlBA+tLnMmlOZb2GBq5Ryhyz9l
         zJ28VbPb3zKb9/IVgyRDxKCm5nPIoCx0hzR5pDBqXB89wVQfHQWY4XBw+QCZGEb+vMx6
         JpjQ7f0XCbZahWSr2dMOiG5MAIC49fcs7BfgfXAMu2G5Dhi+3CTZaTqEgFcC4ANC6dpS
         v+jlIxuiekjXe+IoCD7SqhaXt0ifO0f2EXuAuUoCd7w8QbShUTIsSgpV5zUP4ygCNxG7
         3m/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6FcQAxIfEahUorsEma1oL75v92II5Zkq1A/PM/S0gb4=;
        b=FIuq9IHqx31Wg0Tv6OGHbEL/pZjNGRfWgVf7YyMLntfCusrG4YlW6SrINgp3GBMlI7
         jSU54UfpQZe1GmvbXtQrusJtmN0bLGXbm427Xbycpla05JxlDOyxjesbJPx16d0eYwXm
         Y56REzAyb8Gcd/qSmJPz8zPb+xNSoGb7hpXKX0KWTY8zFG9iPmfdpNY2p8oC2IeqStQN
         a8GAbNK17UoTubhApRMjeDM4aOaudqsTWXAzCpxysWy0M21UufwRYXj32gRhi5Zb8KDk
         45sTyvZC8qlKh6odareRYe3Xra7R/wE+85t+/+bhEbOC56MGgniolA9ATJmkq5ifK4jV
         NqaA==
X-Gm-Message-State: APjAAAX9vqs9nl7bjyuKRH0OoDXsSmYiW33A/NvTrgy82JfmVBEG7Pk7
        XGtP9g41/ZJqpkrV52VsffW3lw==
X-Google-Smtp-Source: APXvYqxZDK+UrZqMLV2Ewy7VwLGrAsZ8Og4bxrhXg5aECbGpOdqc1gdoQT/sFgqSF18xPWKsqPpcCA==
X-Received: by 2002:a65:4341:: with SMTP id k1mr30782738pgq.153.1565624446430;
        Mon, 12 Aug 2019 08:40:46 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k36sm107209610pgl.42.2019.08.12.08.40.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 08:40:46 -0700 (PDT)
Date:   Mon, 12 Aug 2019 08:40:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add
 and delete alternative ifnames
Message-ID: <20190812084039.2fbd1f01@hermes.lan>
In-Reply-To: <20190812083139.GA2428@nanopsycho>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 10:31:39 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Mon, Aug 12, 2019 at 03:37:26AM CEST, dsahern@gmail.com wrote:
> >On 8/11/19 7:34 PM, David Ahern wrote:  
> >> On 8/10/19 12:30 AM, Jiri Pirko wrote:  
> >>> Could you please write me an example message of add/remove?  
> >> 
> >> altnames are for existing netdevs, yes? existing netdevs have an id and
> >> a name - 2 existing references for identifying the existing netdev for
> >> which an altname will be added. Even using the altname as the main
> >> 'handle' for a setlink change, I see no reason why the GETLINK api can
> >> not take an the IFLA_ALT_IFNAME and return the full details of the
> >> device if the altname is unique.
> >> 
> >> So, what do the new RTM commands give you that you can not do with
> >> RTM_*LINK?
> >>   
> >
> >
> >To put this another way, the ALT_NAME is an attribute of an object - a
> >LINK. It is *not* a separate object which requires its own set of
> >commands for manipulating.  
> 
> Okay, again, could you provide example of a message to add/remove
> altname using existing setlink message? Thanks!

The existing IFALIAS takes an empty name to do deletion.
