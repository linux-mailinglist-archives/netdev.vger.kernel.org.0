Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF47B0F19
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 14:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731743AbfILMt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 08:49:58 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40818 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731685AbfILMt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 08:49:58 -0400
Received: by mail-lf1-f66.google.com with SMTP id d17so1379408lfa.7
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 05:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5xF/sCJ+NwxwvLnjBbUnuQ502znTrEXd9hdnYUrg4yc=;
        b=A4QTfzuJi5NQl1Q51mIVj5t7Sn9HOIXNwYige03S4yTX6oc0smlZ0UzD8YXqvat3ZN
         n3dj+RCEo6ss4zhB7DbVuqg5CDLTaL3uRXpf0KN2Dlhf7OUq1qhx3qESt25ymURGFAQK
         OhsIy8UqyEYdxk4I54twgErvf5QBRZTegD0tBSw8Udk7vxSnVFHQFdftAK/McFTj7XoN
         Lb6XwemuNQCoBVUHaD3WS9YzCk/jVMJw2mywDGdzFFFVSfap6jlnHEEx5jgQTiqAqHaB
         BucbCjrogGDut0G83x51WcUXNIg9uGhbd6i9XA0TyFnzAKhcmLK06z4d53yGXiFAOPYE
         6Y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5xF/sCJ+NwxwvLnjBbUnuQ502znTrEXd9hdnYUrg4yc=;
        b=T3+AfjvggDRnXqfkbtsNZXjO6/SH3YcbpkLoqt3sRYP3qVDhfuozlLByli7L3Th6oT
         TxgEVUJTEyGOaU36+JCaUayeIsKSa0fkYyGyBptfeirm916IxMVZX2p298+7EqCqTxKB
         w6QOvF2nAMrjx8dvgiR+GXxBCeD2NSbzpvI0E2L6GxwxHLXzmXnC51fIBNcGQX6ZzeWD
         MrYX0GyLcqPHBku6SC+SXy2GXRxuvxcVAYi8pzDWgDkScyssT5uKXdygPIgZo0GXqhc6
         lIFX2D3JbPbHXNerTdSXF7KxnrvVQP3tOSyc0rWspeAxDyObzfIUr8pemvCI31grLb8j
         vETw==
X-Gm-Message-State: APjAAAV7t3/4VT5hJ6q6d0/XYe9YsxDwvuk6FXQJnLhjuY3iN6vlBrhJ
        QXXOtKqKSZBkAT8Tz9erM1BS+NCAYbCfUnqtIsE=
X-Google-Smtp-Source: APXvYqxM0BzI7m4uDQ3XxhJjNL+uLbjaU0FzdbazvctIsPFXvtAkH3puhTmI+LdSLmE/uYdAfmK6MLkWpMk0S+93F/s=
X-Received: by 2002:a19:c191:: with SMTP id r139mr27395866lff.23.1568292596497;
 Thu, 12 Sep 2019 05:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAMArcTV-Qvfd7xA0huCh_dbtr7P4LA+cQ7CpnaBBhdq-tq5fZQ@mail.gmail.com>
 <20190912.113807.52193745382103083.davem@davemloft.net> <CAMArcTWMjTsZB8Ssx+hVMK-3-XozZw7AqVE62-H+zrJ+doC5Lw@mail.gmail.com>
 <20190912.133717.257813019167130934.davem@davemloft.net>
In-Reply-To: <20190912.133717.257813019167130934.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 12 Sep 2019 21:49:44 +0900
Message-ID: <CAMArcTVtv=ah=KbzOb=u_Qyx0V+iGts77kz_X9GhJfEHbGPUSQ@mail.gmail.com>
Subject: Re: [PATCH net v2 01/11] net: core: limit nested device depth
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Sep 2019 at 20:37, David Miller <davem@davemloft.net> wrote:
>
> From: Taehee Yoo <ap420073@gmail.com>
> Date: Thu, 12 Sep 2019 19:14:37 +0900
>
> > On Thu, 12 Sep 2019 at 18:38, David Miller <davem@davemloft.net> wrote:
> >>
> >> From: Taehee Yoo <ap420073@gmail.com>
> >> Date: Thu, 12 Sep 2019 12:56:19 +0900
> >>
> >> > I tested with this reproducer commands without lockdep.
> >> >
> >> >     ip link add dummy0 type dummy
> >> >     ip link add link dummy0 name vlan1 type vlan id 1
> >> >     ip link set vlan1 up
> >> >
> >> >     for i in {2..200}
> >> >     do
> >> >             let A=$i-1
> >> >
> >> >             ip link add name vlan$i link vlan$A type vlan id $i
> >> >     done
> >> >     ip link del vlan1 <-- this command is added.
> >>
> >> Is there any other device type which allows arbitrary nesting depth
> >> in this manner other than VLAN?  Perhaps it is the VLAN nesting
> >> depth that we should limit instead of all of this extra code.
> >
> > Below device types have the same problem.
> > VLAN, BONDING, TEAM, VXLAN, MACVLAN, and MACSEC.
> > All the below test commands reproduce a panic.
>
> I think then we need to move the traversals over to a iterative
> rather than recursive algorithm.

Just to clarify, I have a question.

There are two recursive routines in the code.
a) netdev_walk_all_{lower/upper}_dev() that are used to traversal
all of their lower or upper devices.
b) VLAN, BONDING, TEAM, VXLAN, MACVLAN, and MACSEC
modules internally handle their lower/upper devices recursively
when an event is received such as unregistering.

what is the routine that you mentioned?
