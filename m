Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A683192DE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 20:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhBKTNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 14:13:46 -0500
Received: from novek.ru ([213.148.174.62]:37194 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhBKTNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 14:13:43 -0500
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id BC73F50028E;
        Thu, 11 Feb 2021 22:13:04 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru BC73F50028E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1613070785; bh=RDrfLcoM8E9gjV+uXOvBpJluzDDGDiTsKBJzullgDGs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=EWVL2YcEaEEOoXpnLFk5FdU4HCrGrQdf/8xw7XjQxPrN3Gy7Qdh0HIeVEyPIsNDrp
         dhzvn87l8SopKrczFwm01GL4WcAUfb0fuFdj7Dtkm4/5rwicgYUty9Wvf4OEPiDb1Z
         1RapNi2KG1oG66Np2A9yjlTbMBOLVxM4+Wjmq+RY=
Subject: Re: [net-next] rxrpc: Fix dependency on IPv6 in udp tunnel config
To:     Jakub Kicinski <kuba@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20210209135429.2016-1-vfedorenko@novek.ru>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <171e77b1-b58b-9c62-3082-c40c80bc9240@novek.ru>
Date:   Thu, 11 Feb 2021 19:12:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209135429.2016-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.02.2021 13:54, Vadim Fedorenko wrote:
> As udp_port_cfg struct changes its members with dependency on IPv6
> configuration, the code in rxrpc should also check for IPv6.

Looks like this patch was mistakely tagged as superseded by
dc0e6056decc rxrpc: Fix missing dependency on NET_UDP_TUNNEL
Although both patches have the same Fixes tag, this one fixes
different problem - rxrpc subsystem could not be compiled without
support for IPv6 because the code tries to access ipv6-specific
members of struct udp_port_cfg.

Should I resend it?
