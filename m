Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7482F89A0
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbhAOXyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:54:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbhAOXyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 18:54:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73C8923603;
        Fri, 15 Jan 2021 23:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610754806;
        bh=klq/GRe+XV/NBHDwVLVdHZoesvl7JZfFOeeuOk62BVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LSkEWxc2S7ECRc9g8sp6i1+RzI/tD8V14i3+dfsmFBapGeDmGvKmVZ6arBBJwbKz2
         pZtKLk0FWqGeLOsXQHpApfKN3KPRubQQW5YupGRrq6T9NSNm0VQm3M9KF/hDVHs+QB
         ME2ivk29sHFxBW76IBVz2K8lpjbFvkRQPvFDL7kPDEZMIDklW0qYo7cz2mwRnsrUrA
         q9QoU7oVrE6/OfWAIZkkGOQWLxC4SBjYUM4doLYjHHNkCsgkWe2LBlseNODQ8NAPpK
         NK5P/lfFBTteJUndCXEzWlSFY5f90dnpQAJUREH7qr0kjdm0qTmqeDY/68ZX38MMhp
         K7qbwV61Lu5SQ==
Date:   Fri, 15 Jan 2021 15:53:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH iproute2] iplink: work around rtattr length limits for
 IFLA_VFINFO_LIST
Message-ID: <20210115155325.7811b052@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115225950.18762-1-edwin.peer@broadcom.com>
References: <20210115225950.18762-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 14:59:50 -0800 Edwin Peer wrote:
> The maximum possible length of an RTNL attribute is 64KB, but the
> nested VFINFO list exceeds this for more than about 220 VFs (each VF
> consumes approximately 300 bytes, depending on alignment and optional
> fields). Exceeding the limit causes IFLA_VFINFO_LIST's length to wrap
> modulo 16 bits in the kernel's nla_nest_end().

Let's add Michal to CC, my faulty memory tells me he was fighting with
this in the past.
