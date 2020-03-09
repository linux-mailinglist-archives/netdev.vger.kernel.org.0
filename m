Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD5C17E82A
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 20:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgCITUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 15:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgCITUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 15:20:17 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C05120848;
        Mon,  9 Mar 2020 19:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583781616;
        bh=yozY3xFjQbiaGTaARWJMFmS1Jex9dxo1dVkuNCoUQmU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k6H+ItcCSes+s8gyW4+Yp6v3abvZ9SdK28oJr1h4xrhZLdBtMKj5iQfw8q6nijfxz
         XLGElgkmb9gSXhbIxSCF314v8F5lmG73eTQFyfOC9hx+5rvwC8/vxzONpiNOlGjQYw
         SG7c+JeefuMbBZReEMT6w7nEXhkxKXCaV5yHVdGY=
Date:   Mon, 9 Mar 2020 12:20:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 09/10] flow_offload: introduce "disabled" HW
 stats type and allow it in mlxsw
Message-ID: <20200309122014.22f1ed62@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200307065637.GA2210@nanopsycho.orion>
References: <20200306132856.6041-1-jiri@resnulli.us>
        <20200306132856.6041-10-jiri@resnulli.us>
        <20200306113116.1d7b0955@kicinski-fedora-PC1C0HJN>
        <20200307065637.GA2210@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Mar 2020 07:56:37 +0100 Jiri Pirko wrote:
> >Would it fit better for the bitfield if disabled internally is 
> >BIT(last type + 1)?   
> 
> I don't see why. Anyway, if needed, this can be always tweaked.

Because it makes it impossible for drivers to pass to
flow_action_hw_stats_types_check() that they support disabled.

I thought disabled means "must have no stats" but I think you may want
it to mean "no stats needed". Which probably makes more sense, right..
