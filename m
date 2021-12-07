Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B2C46BF96
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhLGPlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhLGPlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:41:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD34AC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 07:37:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27248B817F8
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 15:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDF9C341C5;
        Tue,  7 Dec 2021 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638891436;
        bh=D8ExswXYdrGhBlycr0G4UNvuuWCvHdmies+q8+Q2LtY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fr8QkNA006ATogOpUbZmxsfcwAYcf4IShlnl0UXUMVaiFD4d5tWfCsoZE6A4uSnaL
         9eMFzDkXynVlK6RvdBLXSOvJg+m5QdvyXLjxKqyKESi/WsuoHwUuHe12ioJeoF7Sww
         azd8j6ww3CvSlfUxi8f8M6lYA2bObVu8lN3WdsxPCB6cVJ7vNS+Nfl2ekruZRIWBx4
         OOHO1CcOztYTg3MPkxcQJgiMj5k7N0CR/VwI7G10FSAd+frc9aFEQZtnNa/VAqk789
         +BvVGsr1uJSJDUwhQipToS0vKrVqFliQqbUPYTkkSUrfQgRIBoIhOFdZjYGwCR6Wxn
         VOLq/d4F+NmAA==
Date:   Tue, 7 Dec 2021 07:37:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org, nikolay@nvidia.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211207073715.386e3f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
        <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 21:12:33 -0700 David Ahern wrote:
> The need to walk the list twice (3 really with the sort) to means the
> array solution is better.

Technically the linear walk will be dwarfed by the sort for non-trivial
inputs (have I been conducting too many coding interviews?) 

Especially with retpolines :(

> I liked the array variant better. Jakub?

I always default to attr-per-member unless there is a strong constraint
on message size. Trying to extend old school netlink (TC etc) left me
scarred. But we can do array, no big deal.
