Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12D22F9044
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 03:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbhAQC71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 21:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbhAQC7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 21:59:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D9AE206E9;
        Sun, 17 Jan 2021 02:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610852323;
        bh=WBZuQqQ/v6iVzAKq0bC/zQNfVZJOT1K3Ttri70N663E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=THd3Gsy3iGk0b3GBgYX2Kwk61gBvhrAwmMue9nov2gRJp1MxsqjJ1iJDvL7qLDTIU
         reREgmqH8ccskIPDrV01qcDcY6Cwk0xstgKXJAz47xEZ26oCxk3VNzg2MYWmRyU3Rr
         cccuq8dMglUmj+xDFOnncLtiCnVgCpfhJKQgZGjrRkv0pJaKlPSyuRk5ry14PZJM3B
         69dPxiiuCNB6bbfQgZ8DqbufDrm/LF97wkaYb/N1KYQ70yW/7w7/xbYU38/m86PLFu
         0ww4xhqaCT15S08YBUIcihcKQsFiVWxsJH8OfSCye437IvmKVJ0/5jIlRcHGX5xQSQ
         PfQEJJlV8MjMA==
Date:   Sat, 16 Jan 2021 18:58:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH v3 net-next] net: bridge: check vlan with
 eth_type_vlan() method
Message-ID: <20210116185842.322bf3b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115044131.6039-1-dong.menglong@zte.com.cn>
References: <20210115044131.6039-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 20:41:31 -0800 menglong8.dong@gmail.com wrote:
> -	if (data[IFLA_BR_VLAN_PROTOCOL]) {
> -		switch (nla_get_be16(data[IFLA_BR_VLAN_PROTOCOL])) {
> -		case htons(ETH_P_8021Q):
> -		case htons(ETH_P_8021AD):
> -			break;
> -		default:
> -			return -EPROTONOSUPPORT;
> -		}
> +	if (data[IFLA_BR_VLAN_PROTOCOL] &&
> +	    !eth_type_vlan(nla_get_be16(data[IFLA_BR_VLAN_PROTOCOL]))) {
> +		return -EPROTONOSUPPORT;
>  	}

The curly brackets are no longer necessary here, since it's a single
line expression.
