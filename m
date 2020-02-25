Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1C516B877
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgBYEQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:16:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgBYEQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 23:16:48 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF76324656;
        Tue, 25 Feb 2020 04:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582604208;
        bh=V3HRkjkINzbcPy4bIdDuWjHYlVP6mvYcHvSbEytnQhY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ns5pV7j2WhR2R1pvPoT182H9UnK0A+tUOHGxQY8NTAqd0k4pgDWsU/nwt+KRtYEpL
         YLNDDIdL728Oo7HHMKX/j0UDR5fjTGpsrLaIcG4G+MUA9wUQbv3RR3bA5nubMpyR3k
         W9QO/9cDzIZJ2wsl6RZlxAfvqAYQNunOI/aPulNU=
Date:   Mon, 24 Feb 2020 20:16:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 01/10] flow_offload: pass action cookie through
 offload structures
Message-ID: <20200224201647.2d3b6239@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200224210758.18481-2-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
        <20200224210758.18481-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Feb 2020 22:07:49 +0100, Jiri Pirko wrote:
> +struct flow_action_cookie {
> +	unsigned int cookie_len;
> +	unsigned long cookie[0];
> +};

nit: there's an ongoing effort to convert [0] to []

also since cookie_len is in bytes it feels like a leaky abstraction
to have the field as unsigned long (rather than u8)
