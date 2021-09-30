Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA2741DE79
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 18:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348901AbhI3QNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 12:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348582AbhI3QNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 12:13:43 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5429C06176A;
        Thu, 30 Sep 2021 09:12:00 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id b15so27347352lfe.7;
        Thu, 30 Sep 2021 09:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a3vOhd3AxRBGGkQ1Ffsi6fx5ALF3ffB714UeOL8XqBU=;
        b=nEkTOTrBqW70y++KGcwtoP3dePkqsP3/baqjSZkpHheBCDHsP1siCD8Y1BFBU9jQyO
         8UDGfHNDWqE+AGmDygUGzFuWfe4t78xEAEml5WGju36hpmeaoWb3OUJnAF/XcATG/6dC
         7Iik7Qw1LiXXqOPtoFDBmwRjC/kzsqcgv8KC5vD5L3PRO5s42MvzcApCwwp5ybfaO16I
         J/z3t5w8djS3xthCuwDBzJkWmpueYK0RnE8w0RQLcCEXHtBKAUHzKZM493bI/v4xYLtX
         Ly/+1pxqoa4gUtm9ct106ZFK84CNFVN7k1jEnyb6fStPe9WD89oLs+QnP8b40on/yeO4
         JOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a3vOhd3AxRBGGkQ1Ffsi6fx5ALF3ffB714UeOL8XqBU=;
        b=nelmMyeJSE+WjV0LozY0NDJHsS68KZWwLzoY9P4a0uuV5ATmai/5G4r39m57c8xsZJ
         5VDdiUYqLnZBYA0Qy6LK3tvnMkjAv7LlSc4YJb5l2gJ3g2FW14DMS7th2x0x1d5gqVKV
         7EAuOwMzXu27J8SmNqPkE29IIbRpctgIKmCIJv86Qp5a+b2wM6efuiN7fP8tEB6afBl1
         /X12O/jNYKLw+wY2u1kPeuPtctHFqZ4ZXryx5yx4zcD0fM5x8zonHf23FK6/AgKE8ZJv
         Zk3nRA/65T8TeSDdU7IbuGwN2Qr2cJvaeFsFVQ+VyWTY15tOMomJkhEJ2ocFaVg28eVW
         O86Q==
X-Gm-Message-State: AOAM530IkTMe+ceMvVY8ebatr2ACn3+kE0nDgbiwSXTeE3Mon5/6EZhG
        GxBfkh/s6Qb1fCQ1byKa7TEq7fgv2DNpOu5xeSY=
X-Google-Smtp-Source: ABdhPJybsD1xRfNr9pXfjZhq2UbsQcKOSv4i+MJkaa5zkp7oWk8aHl9JVTIliUgrIfDbXq0SkjetAGoAwSkKXZTPFHE=
X-Received: by 2002:a05:6512:1052:: with SMTP id c18mr51516lfb.161.1633018319217;
 Thu, 30 Sep 2021 09:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210928194727.1635106-1-cpp.code.lv@gmail.com>
 <20210928174853.06fe8e66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d1e5b178-47f5-9791-73e9-0c1f805b0fca@6wind.com> <20210929061909.59c94eff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210929061909.59c94eff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Thu, 30 Sep 2021 09:11:48 -0700
Message-ID: <CAASuNyVe8z1R6xyCfSAxZbcrL3dej1n8TXXkqS-e8QvA6eWd+w@mail.gmail.com>
Subject: Re: [PATCH net-next v6] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netdev@vger.kernel.org, pshelar@ovn.org,
        "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 6:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 29 Sep 2021 08:19:05 +0200 Nicolas Dichtel wrote:
> > > /* Insert a kernel only KEY_ATTR */
> > > #define OVS_KEY_ATTR_TUNNEL_INFO    __OVS_KEY_ATTR_MAX
> > > #undef OVS_KEY_ATTR_MAX
> > > #define OVS_KEY_ATTR_MAX            __OVS_KEY_ATTR_MAX
> > Following the other thread [1], this will break if a new app runs over an old
> > kernel.
>
> Good point.
>
> > Why not simply expose this attribute to userspace and throw an error if a
> > userspace app uses it?
>
> Does it matter if it's exposed or not? Either way the parsing policy
> for attrs coming from user space should have a reject for the value.
> (I say that not having looked at the code, so maybe I shouldn't...)

To remove some confusion, there are some architectural nuances if we
want to extend code without large refactor.
The ovs_key_attr is defined only in kernel side. Userspace side is
generated from this file. As well the code can be built without kernel
modules.
The code inside OVS repository and net-next is not identical, but I
try to keep some consistency.

JFYI This is the file responsible for generating userspace part:
https://github.com/openvswitch/ovs/blob/master/build-aux/extract-odp-netlink-h
This is the how corresponding file for ovs_key_attr looks inside OVS:
https://github.com/openvswitch/ovs/blob/master/datapath/linux/compat/include/linux/openvswitch.h
one can see there are more values than in net-next version.
