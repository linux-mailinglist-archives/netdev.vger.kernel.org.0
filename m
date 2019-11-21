Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4CB105CB8
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 23:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUWhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 17:37:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfKUWhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 17:37:32 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC3FF15099D72;
        Thu, 21 Nov 2019 14:37:31 -0800 (PST)
Date:   Thu, 21 Nov 2019 14:37:31 -0800 (PST)
Message-Id: <20191121.143731.45820499993617607.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        andrewx.bowers@intel.com
Subject: Re: [net-next 05/15] ice: fix stack leakage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121142548.4bb62c55@cakuba.netronome.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
        <20191121074612.3055661-6-jeffrey.t.kirsher@intel.com>
        <20191121142548.4bb62c55@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 14:37:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu, 21 Nov 2019 14:25:48 -0800

> On Wed, 20 Nov 2019 23:46:02 -0800, Jeff Kirsher wrote:
>> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
>> 
>> In the case of an invalid virtchannel request the driver
>> would return uninitialized data to the VF from the PF stack
>> which is a bug.  Fix by initializing the stack variable
>> earlier in the function before any return paths can be taken.
> 
> I'd argue users may not want hypervisor stack to get leaked into the
> VMs, and therefore this should really have a fixes tag...

Agreed.
