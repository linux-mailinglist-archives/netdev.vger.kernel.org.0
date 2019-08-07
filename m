Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABD38533A
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 20:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389411AbfHGSts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 14:49:48 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40009 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389382AbfHGSts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 14:49:48 -0400
Received: by mail-qk1-f193.google.com with SMTP id s145so66668841qke.7
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 11:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EADlsWbFtenzGYIUebwf0XoKyxnHp7MoePgcqzX4CVE=;
        b=q2BvYEdG153ZC8dSjAjkPRoGKTFaQj8SotYB61+Ust4qgY40NbWY6ywKOeY4fi8oli
         yheaabmGsI+PCUWe/rZbxzcewjvb4sfsXOPGfoH+C2mvCVF51pBEFEu0iehcTkzMRpit
         vITCvP99YmXS8myOQGvRqsRhrzjw5SO0lzEj3s93fGz6qzS2rvHezwKIzgahhho8CVKs
         oXKR6dkiOmTc4rvej0C5Gcfb29SYlBxYXZYmVcV6BYuRqUxDOUHuEQEHxiFwIznAOzJI
         mtawdOCgoL8EwHb5tU1sUgaeM3QLu/DMEiq37PjPdiaAyEvzkEei95DyEFEsh2ky68t4
         v64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EADlsWbFtenzGYIUebwf0XoKyxnHp7MoePgcqzX4CVE=;
        b=kFweYJg0INCjO93dLA2cXrUSqhW/h5O2LHyBBJJ+p3ufBYIusIzfh5EgoMJY1vJkcp
         5zLYR0rLwath1lAlYXQrfwT0S81j91xix8co6+1Yzw8CfxJKd7JVD9WKiudRwgt2tQ8Y
         KxDRBrVK/DNVhO+FZmRoL4d/q5dMSfapke+Elf28kWZPRMEd7IyOmgSnkH33stZDFJnk
         W0OR6W3h6ZHdhcklcBl8F/V2AOdousZYWBw7LA1VA7EEfAf/ZzSJSVw98lNKLyyv9XrT
         EcFRrNWMQQHVmAe4vQf6x+kZOEiwaTny+Q61et5lXnvVL8hh+rBwBb9sAmO4zqgY5rbX
         v+jQ==
X-Gm-Message-State: APjAAAX0KCRHBBHdDHG9MXtDAF8KbnhSUTYtMLB8uuoS9xOWGhh7DZZY
        l6nQvHtlGpMsXAKJivfWQmjU/g==
X-Google-Smtp-Source: APXvYqyGHtXocAWO+9+kUZQgdWR+WvRZbSjJiNfTBMBgvfGV3R0dHsb1JAcr2B2v6uZy7QmbDUDX9w==
X-Received: by 2002:ae9:f80b:: with SMTP id x11mr9683609qkh.479.1565203786894;
        Wed, 07 Aug 2019 11:49:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t6sm40235873qkh.129.2019.08.07.11.49.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 11:49:46 -0700 (PDT)
Date:   Wed, 7 Aug 2019 11:49:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
Message-ID: <20190807114918.15e10047@cakuba.netronome.com>
In-Reply-To: <e0047c07-11a0-423c-9560-3806328a0d76@gmail.com>
References: <20190806164036.GA2332@nanopsycho.orion>
        <c615dce5-9307-7640-2877-4e5c01e565c0@gmail.com>
        <20190806180346.GD17072@lunn.ch>
        <e0047c07-11a0-423c-9560-3806328a0d76@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Aug 2019 20:33:47 -0600, David Ahern wrote:
> Some time back supported was added for devlink 'resources'. The idea is
> that hardware (mlxsw) has limited resources (e.g., memory) that can be
> allocated in certain ways (e.g., kvd for mlxsw) thus implementing
> restrictions on the number of programmable entries (e.g., routes,
> neighbors) by userspace.
> 
> I contend:
> 
> 1. The kernel is an analogy to the hardware: it is programmed by
> userspace, has limited resources (e.g., memory), and that users want to
> control (e.g., limit) the number of networking entities that can be
> programmed - routes, rules, nexthop objects etc and by address family
> (ipv4, ipv6).

Memory hierarchy for ASIC is more complex and changes more often than
we want to change the model and kernel ABIs. The API in devlink is
intended for TCAM partitioning.

> 2. A consistent operational model across use cases - s/w forwarding, XDP
> forwarding and hardware forwarding - is good for users deploying systems
> based on the Linux networking stack. This aligns with my basic point at
> LPC last November about better integration of XDP and kernel tables.
> 
> The existing devlink API is the right one for all use cases. Most
> notably that the kernel can mimic the hardware from a resource
> management. Trying to say 'use cgroups for s/w forwarding and devlink
> for h/w forwarding' is complicating the lives of users. It is just a
> model and models can apply to more than some rigid definition.

This argument holds no water. Only a tiny fraction of Linux networking
users will have an high performance forwarding ASIC attached to their
CPUs. So we'll make 99.9% of users who never seen devlink learn the
tool for device control to control kernel resource?

Perhaps I'm misinterpreting your point there.

> As for the namespace piece of this, the kernel's tables for networking
> are *per namespace*, and so the resource controller must be per
> namespace. This aligns with another consistent theme I have promoted
> over the years - the ability to divide up a single ASIC into multiple,
> virtual switches which are managed per namespace. This is a very popular
> feature from a certain legacy vendor and one that would be good for open
> networking to achieve. This is the basis of my response last week about
> the devlink instance per namespace, and I thought Jiri was moving in
> that direction until our chat today. Jiri's intention is something
> different; we can discuss that on the next version of his patches.

Resource limits per namespace make perfect sense. Just not configured
via devlink..
