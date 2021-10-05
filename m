Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AF2422B68
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbhJEOrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:47:07 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:47700 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235134AbhJEOrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 10:47:06 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 62E98200F48B;
        Tue,  5 Oct 2021 16:45:14 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 62E98200F48B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633445114;
        bh=D5CLXSpjv2zQmPTWaTxvZZom7i+QAm9xoMnWPURrcXI=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=WQHiPdK+u3Tmri7YzUJuc928V0IkfnVCSBJ+XzyvKoQjByV3WkqnsTTfsYWGp9Fwx
         IeL1DTvVB5+O51jnkAH5taH0YROPFvKhsPJUbT7CtO6/MComCxPk2b4Zs8VomhYAwN
         Rdae2XcBrwrJGC3S8DEhpTlU2xTRJBKM4RwJwNcI8lNEd1OdSG0yLp/yYddaX9RJBS
         QRYFqZmtRR8vFGj5RcpMbSSC2KODmh8e0e0k0WqpHee2cfAMPjXEpT+0YH0DHQ5nBq
         Ctu+sONUzEXviTgJawWzvFhLzvkN3kyYWB3qLWqvqT6gpNjnCAPkTFD+O+ooUbbXC5
         D2KFVEF2DC19g==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 5ADC4602245CD;
        Tue,  5 Oct 2021 16:45:14 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6rHTmE37pE0z; Tue,  5 Oct 2021 16:45:14 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 453C56010ECC0;
        Tue,  5 Oct 2021 16:45:14 +0200 (CEST)
Date:   Tue, 5 Oct 2021 16:45:14 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        stephen@networkplumber.org
Message-ID: <181201748.114494759.1633445114212.JavaMail.zimbra@uliege.be>
In-Reply-To: <a80c8fba-bf66-93ef-c54e-6648b3522e28@gmail.com>
References: <20211004130651.13571-1-justin.iurman@uliege.be> <20211004130651.13571-2-justin.iurman@uliege.be> <a80c8fba-bf66-93ef-c54e-6648b3522e28@gmail.com>
Subject: Re: [PATCH iproute2-next 1/2] Add support for IOAM encap modes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF92 (Linux)/8.8.15_GA_4026)
Thread-Topic: Add support for IOAM encap modes
Thread-Index: qck4K0XlCrUmVufBS9kmuWVQ/Z38Fg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +static const char *ioam6_mode_types[] = {
> 
> I think you want to declare this of size IOAM6_IPTUNNEL_MODE_MAX + 1

This is automatically the case, see below explanation.

>> +	[IOAM6_IPTUNNEL_MODE_INLINE]	= "inline",
>> +	[IOAM6_IPTUNNEL_MODE_ENCAP]	= "encap",
>> +	[IOAM6_IPTUNNEL_MODE_AUTO]	= "auto",
>> +};
>> +
>> +static const char *format_ioam6mode_type(int mode)
>> +{
>> +	if (mode < IOAM6_IPTUNNEL_MODE_MIN ||
>> +	    mode > IOAM6_IPTUNNEL_MODE_MAX ||
>> +	    !ioam6_mode_types[mode])
> 
> otherwise this check is not sufficient.

Are you sure? I mean, both IOAM6_IPTUNNEL_MODE_MIN and IOAM6_IPTUNNEL_MODE_MAX respectively point to IOAM6_IPTUNNEL_MODE_INLINE and IOAM6_IPTUNNEL_MODE_AUTO. So, either the input mode is out of bound, or not defined in the array above (this one is not mandatory, but it ensures that the above array is updated accordingly with the uapi). So, what we have right now is:

__IOAM6_IPTUNNEL_MODE_MIN = 0
IOAM6_IPTUNNEL_MODE_INLINE = 1
IOAM6_IPTUNNEL_MODE_ENCAP = 2
IOAM6_IPTUNNEL_MODE_AUTO = 3
__IOAM6_IPTUNNEL_MODE_MAX = 4

IOAM6_IPTUNNEL_MODE_MIN = 1
IOAM6_IPTUNNEL_MODE_MAX = 3

ioam6_mode_types = {
  [0] (null)
  [1] "inline"
  [2] "encap"
  [3] "auto"
}

where its size is automatically/implicitly 4 (IOAM6_IPTUNNEL_MODE_MAX + 1).
