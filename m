Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FC942E35F
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 23:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhJNVj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 17:39:28 -0400
Received: from sender11-of-o51.zoho.eu ([31.186.226.237]:21177 "EHLO
        sender11-of-o51.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbhJNVj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 17:39:28 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1634247393; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=OpfT8Z47DI7Pa6XeRFGh2mWwerxjsMQD7OftTGKSWMevCVFecNWepF8luLzPIY21wqY5Vfinbh8AJb5Co0Vi9EVlUTRDGJWGMeAvBrcxumNkurlf+xcR5qd7GaSYrU5hQW7TSkm7CBXrOaVXAA85VKtwEBIFUTN8wOH/xSByayk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1634247393; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=MVWveRL9WqrkRXVHeUh1K5zxIt2rK/cc84UTjS6Fyzk=; 
        b=JlFBM/gRmt7yfQOdrCbAMx6sQ0mhAu7ipzYBBDhIdqg0x83fxa/OwwW0f41PwdgvUWB10cYLyVwJIoCxq6tVr5s00R9EXuBg/exY4KKER8TItAHoy1kZWIXH+Jvn6qolH/p+XvZ0O83wi25jMVfq0A9WaEGV11knrdkrHA/Nr7U=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1634247393;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=MVWveRL9WqrkRXVHeUh1K5zxIt2rK/cc84UTjS6Fyzk=;
        b=VbHdh2oE3IeMt3ht5+tH+ws3NIKZT8uyfi7BU1e5HOmpKtA6eHzREtgISSd9gzLf
        IcM6J5Eyze729MefpbhfWnJjfSB/u01B+ARbv8X7x6YcMvSVhadKGRYvoPL2xvSoBkO
        iuJt9g00TgYrY8svVFnjuOIgP1zBSMCpZ0XOXpY8=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1634247387836973.0428578910663; Thu, 14 Oct 2021 23:36:27 +0200 (CEST)
Date:   Thu, 14 Oct 2021 23:36:27 +0200
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Erik Kline" <ek@google.com>
Cc:     "Jakub Kicinski" <kuba@kernel.org>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "kuznet" <kuznet@ms2.inr.ac.ru>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Jscherpelz" <jscherpelz@google.com>
Message-ID: <17c80bc2aba.fa4204331209995.6054034489659150411@shytyi.net>
In-Reply-To: <CAAedzxrXyfi4L9pGVLJhQFeajOmjOUJz10s3ohMnApsTi3OjiA@mail.gmail.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
 <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
 <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
 <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
 <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net>
 <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
 <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net>
 <176458a838e.100a4c464143350.2864106687411861504@shytyi.net>
 <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net>
 <17c7be50990.d8ff97ac1139678.6280958386678329804@shytyi.net> <17c7bf4fe17.10fe56af01139851.4883748910080031944@shytyi.net> <CAAedzxrXyfi4L9pGVLJhQFeajOmjOUJz10s3ohMnApsTi3OjiA@mail.gmail.com>
Subject: Re: [PATCH net-next V10] net: Variable SLAAC: SLAAC with prefixes
 of arbitrary length in PIO
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 > > This patch solves "Race to the bottom"  problem  in  VSLAAC. 
 >  
 > How exactly does this "solve" the fundamental problem? 
 > 

VSLAAC is replaced by the SLAAC starting from /64 
 
if (pinfo->prefix_len == 64) {
64_bit_addr_gen
} else if (pinfo->prefix_len > 0 && pinfo->prefix_len < 64 &&
              in6_dev->cnf.variable_slaac) {
variable_bit_addr_gen
 } else {
             net_dbg_ratelimited("IPv6: Prefix with unexpected length %d\n",
                                            pinfo->prefix_len);
 }

I meant to say that this is no longer an issue in VSLAAC particular context, considering /128 bits the "bottom".
In this version of the patch, we are not reaching the /128 bit "bottom".

Best regards,
Dmytro SHYTYI.
