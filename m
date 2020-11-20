Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31022BA203
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 06:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgKTFnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 00:43:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgKTFnh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 00:43:37 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70C9A221FC;
        Fri, 20 Nov 2020 05:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605851016;
        bh=2ecvJkGoQPKbfXk1VdJdZDGJCbqu/p2h/VxKC5SMNgg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VYhUeEiwfQM0X641vg3ibEMOj3K6jHNmyOCdIKoNmaenWhNPYR4hGtf71pxWn9vck
         IsGDWOl3W3abdlE8zCEo0XlV3uKlBqaYA/oksx6vxwKzJwvlEXNqWq8OwX0QQO0oPi
         k+bHg3HcwCKBN5gVg79bUSOhB6NtlTljbKj/6gvg=
Date:   Thu, 19 Nov 2020 21:43:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>
Subject: Re: [net-next v4 0/2] devlink: move common flash_update calls to
 core
Message-ID: <20201119214335.21a244a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118190636.1235045-1-jacob.e.keller@intel.com>
References: <20201118190636.1235045-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 11:06:34 -0800 Jacob Keller wrote:
> This series moves a couple common pieces done by all drivers of the
> ->flash_update interface into devlink.c flash update handler. Specifically,  
> the core code will now request_firmware and
> devlink_flash_update_(begin|end)_notify.
> 
> This cleanup is intended to simplify driver implementations so that they
> have less work to do and are less capable of doing the "wrong" thing.
> 
> For request_firmware, this simplification is done as it is not expected that
> drivers would do anything else. It also standardizes all drivers so that
> they use the same interface (request_firmware, as opposed to
> request_firmware_direct), and allows reporting the netlink extended ack with
> the file name attribute.
> 
> For status notification, this change prevents drivers from sending a status
> message without properly sending the status end notification. The current
> userspace implementation of devlink relies on this end notification to
> properly close the flash update channel. Without this, the flash update
> process may hang indefinitely. By moving the begin and end calls into the
> core code, it is no longer possible for a driver author to get this wrong.
> 
> Changes since v3
> * picked up acked-by and reviewed-by comments
> * fixed the ionic driver to leave the print statement in place
> 
> For the original patch that moved request_firmware, see [1]. For the v2 see
> [2]. For further discussion of the issues with devlink flash status see [3].
> For v3 see [4].

Applied, thanks!
