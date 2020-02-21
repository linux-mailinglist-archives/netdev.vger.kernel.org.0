Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21F9168501
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgBURbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:31:44 -0500
Received: from mail-qt1-f179.google.com ([209.85.160.179]:44452 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbgBURbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:31:44 -0500
Received: by mail-qt1-f179.google.com with SMTP id j23so1803552qtr.11;
        Fri, 21 Feb 2020 09:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oK/nXyAueilIzDZsC0Y5hsaXIqdUEPt9TRtAILDKA6Q=;
        b=b+0hSjSBfyeS4lA9IVzCtESD7w69oMdk3SrR+C9Aet+KyHKc9OBN7hSmzey+IQ1OW5
         4wfGYG4j1iQA8tI5OeGumC0K/ipMiT1MFyxW8PMDb24WtHoDSxwizFwujuGVsYYi9d22
         pg18lRv0TcBWU342lloirv1vBDHYfQxZOAubTqmGDbUBxaG2jGDn3XGm2+tngS4isT9g
         0dNS69aIECSHedtIi4p6QwoCz0k9AJdchFULTTZ/wwC8pUJ+lhgc34Nb+K+4i5YTwz2c
         JRjNaUH4bhmno/TPzJ7vo8hMszP80u9T5QO+HODH+htzi/WmUbcYZv25Y4ec8F9u4xZ/
         aGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oK/nXyAueilIzDZsC0Y5hsaXIqdUEPt9TRtAILDKA6Q=;
        b=kHsQYyntVfKs0asrUKPx2ie2/WWjnyIt8oi6JGgqgDAmA03oH30mEgyEoQ2nt5wwTr
         YNK6fth93hjtq4D1ItJKPG5QOjOtHY1ibFZa22wNMMvzgtSEHQd4ylNnkLvy3mzNzz0D
         RkYkRAl1bPs7omJkNTym39CcOl78RuGlWWlRk6xj/PcVjVcVJn8WSKczV7mbUspiQsGQ
         rxI0KvLfEwMptR8wvHm7UtpGtD4WtKOY2wF0m/FG0ECjWqZwAd5qsGh2q4H3DG8B2zmU
         dHWXej+MNGI5QqVPamyNxPfvblG8LS6vXAMJZfca1Db2GOubec/VaeSFbNJtZE6dMaoy
         mb0g==
X-Gm-Message-State: APjAAAVFJZkSED0uSBUK54LPGfHtDiytQzMUgJoBFwTeakbV2qltdKVW
        HePhG/QxjI849iMUqMKa7wI=
X-Google-Smtp-Source: APXvYqzpYRNNUJSiKh8gmPEdbaxDY5OyJM14UpGmeO0xURtbPV+kpkab8vqx2gjj82ie3PBz2bzP0A==
X-Received: by 2002:ac8:6f27:: with SMTP id i7mr32636103qtv.253.1582306303354;
        Fri, 21 Feb 2020 09:31:43 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:6191:8310:a1b6:e817? ([2601:282:803:7700:6191:8310:a1b6:e817])
        by smtp.googlemail.com with ESMTPSA id b22sm1832828qkk.20.2020.02.21.09.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:31:42 -0800 (PST)
Subject: Re: [net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB table
To:     Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ahmed.abdelsalam@gssi.it,
        dav.lebrun@gmail.com, andrea.mayer@uniroma2.it,
        paolo.lungaroni@cnit.it, hiroki.shirokura@linecorp.com
References: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
 <20200213010932.11817-2-carmine.scarpitta@uniroma2.it>
 <7302c1f7-b6d1-90b7-5df1-3e5e0ba98f53@gmail.com>
 <20200219005007.23d724b7f717ef89ad3d75e5@uniroma2.it>
 <cd18410f-7065-ebea-74c5-4c016a3f1436@gmail.com>
 <20200219034924.272d991505ee68d95566ff8d@uniroma2.it>
 <a39867b0-c40f-e588-6cf9-1524581bb145@gmail.com>
 <20200220233336.53eda87e7a76ed24317e0165@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <70077e59-1614-b059-a85e-42863f63144f@gmail.com>
Date:   Fri, 21 Feb 2020 10:31:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200220233336.53eda87e7a76ed24317e0165@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/20 3:33 PM, Carmine Scarpitta wrote:
> As you can see, what is missing is having SRv6 End.DT4 supported to do 
> decapsulation and VRF lookup.  

Thanks for the detailed explanation and reference. Both this comment and
the slides reference VRF and per-tenant table lookup which is the same
as VRF.

If you allocated a VRF device for the tenant, the SRv6 header pop and
route lookup can be done very similar to how MPLS works when the goal is
to do a route lookup vs forwarding to a specific nexthop, be it main table:

    ip -f mpls route add 200 dev lo

or VRF table

    ip -f mpls route add 200 dev red

Take a look at the mpls code. Unless I am missing something this use
case is very similar.
