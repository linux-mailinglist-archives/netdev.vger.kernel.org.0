Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C65F97BA
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKLRyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:54:53 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39738 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfKLRyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 12:54:53 -0500
Received: by mail-pg1-f194.google.com with SMTP id 29so12341638pgm.6
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 09:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L5vSG+1I0eRarvmx/5bPRA3Qpfyj9FqdzAnPPfortio=;
        b=cOhGN8hi3OGxkAw/eIRV5sc1P0xqbWEX0Ux1hM3QHpphAOI9RtFnmab2+F+eb/DkOL
         ejczQjNV2CPx2P2jHIn8Owpd0KrA2bV4jNyTAPnRcu8/aZwhsy1t0vWvVhKrALN1EPpt
         fMq7tY/5aWVQn0Z78G79GqfoMzUzmPcUEYClHDyMbsWohFYrB9qkufOAuiX3tVcZR4sc
         xtgNqbinPj3KYvfTjJyvEWlOTI5RhM6cdp7xoTSwzGm4oufdc1/Bi/9wqPFyLODr8XM8
         rY/GIMnFM8msOlZKbRcZKGdcYJK9pdE5TSHIXIHSLLCLZ4oJlY7pL1DlmPscZTOIjNBw
         C0ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L5vSG+1I0eRarvmx/5bPRA3Qpfyj9FqdzAnPPfortio=;
        b=WmtxwmN/DgfipAaTsHj+D79tcOfF5KoQ1I87X2NcFCVx6/+ujniFvWpsRKotf7UnNm
         C6KiYYZt/79yFNl+pGotQKEFtclLFAk73FOJtXPiF0m+XXuvACjPdcO8s6RfbIrG6f70
         RcahtL0TPa6qlz4cK64wR4+IL2M4boZh6CFZB2yi8kzq8F217nStrbisO2Y8A7t9zryN
         1pmrQOHLbEE+7/BamJyRySuV6p0rr0sBoUH6hQfqWkJEijhny6CRuEilXfYNh5pOGCMw
         Wk7N3PFaHOwdDXlCsjRhe2jY0VI8VGlSDCU0Xad1AaI9USvSpRe553FgKN4QQKJcwum8
         SUnw==
X-Gm-Message-State: APjAAAVHJ63hUqq01VHEfXPznblwLFvp4PMQ8NT92Xw8HMCY6HsFz0xb
        Xde/p1eOu8QVRFK6+JY/FiH6E0On
X-Google-Smtp-Source: APXvYqwrc0r/Xd2onrj7p4CHwpFKC3PTSxTqw/pNs01nQAyC1TLqZ3Q1pW22nW9YEpXlApsfZ3aMSQ==
X-Received: by 2002:aa7:9a86:: with SMTP id w6mr37762944pfi.169.1573581292833;
        Tue, 12 Nov 2019 09:54:52 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id b7sm3400401pjo.3.2019.11.12.09.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 09:54:52 -0800 (PST)
Subject: Re: [PATCH net-next v5 1/6] net: add queue argument to
 __skb_wait_for_more_packets and __skb_{,try_}recv_datagram
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
References: <cover.1573487190.git.sd@queasysnail.net>
 <0398d7e97db25019dcd32bbce4beba2bd1de27a7.1573487190.git.sd@queasysnail.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7c3de99a-4810-8a3b-72d4-04e72c47537b@gmail.com>
Date:   Tue, 12 Nov 2019 09:54:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0398d7e97db25019dcd32bbce4beba2bd1de27a7.1573487190.git.sd@queasysnail.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/12/19 7:18 AM, Sabrina Dubroca wrote:
> This will be used by ESP over TCP to handle the queue of IKE messages.
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
> v2: document the new argument to __skb_try_recv_datagram
> 
>

Please rebase your tree Sabrina. Some READ_ONCE() have been added lately/

