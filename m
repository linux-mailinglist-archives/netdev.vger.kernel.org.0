Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7859E3DB630
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 11:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbhG3Jmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 05:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230462AbhG3Jmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 05:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3741D603E9;
        Fri, 30 Jul 2021 09:42:25 +0000 (UTC)
Date:   Fri, 30 Jul 2021 10:42:22 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, will@kernel.org,
        maz@kernel.org, mark.rutland@arm.com, dbrazdil@google.com,
        qperret@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lipeng321@huawei.com
Subject: Re: [PATCH net-next 2/4] io: add function to flush the write combine
 buffer to device immediately
Message-ID: <20210730094222.GB8570@arm.com>
References: <1627614864-50824-1-git-send-email-huangguangbin2@huawei.com>
 <1627614864-50824-3-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627614864-50824-3-git-send-email-huangguangbin2@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 11:14:22AM +0800, Guangbin Huang wrote:
> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> 
> Device registers can be mapped as write-combine type. In this case, data
> are not written into the device immediately. They are temporarily stored
> in the write combine buffer and written into the device when the buffer
> is full. But in some situation, we need to flush the write combine
> buffer to device immediately for better performance. So we add a general
> function called 'flush_wc_write()'. We use DGH instruction to implement
> this function for ARM64.

Isn't this slightly misleading? IIUC DGH does not guarantee flushing, it
just prevents writes merging (maybe this was already discussed on the
previous RFC).

-- 
Catalin
