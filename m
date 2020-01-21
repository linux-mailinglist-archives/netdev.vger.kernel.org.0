Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7988143F82
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAUO2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:28:39 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36246 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbgAUO2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:28:39 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so3273793wma.1
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c332BukrkRyK/u9Ls0zuwzIT1b5IS90orRxiNkQuaTA=;
        b=XFMJxvsBLS0HoJDfEWKPu6Vo5oTG6YFcU+Psc4eOD8J77wGJwtp8lJBL4+OOESBn/1
         vO5GYAN46vViWcvQ6lO+Uwd3i32yFThB3nChJXuEVDXUewYTfDeyB9DeM15vLmHNfEHE
         LMjeNdcL4RTTzQIQ4o1xt/wo4n/Z5RJv5dWoNdO/6mNCSFifv9l03LQjkx/UB3eK/02W
         BSpDW9D8yJDPcMkFIDY2EiQnwMTddvcxTasZOx6sNkojGIxq1COQrutDvVYGkQ391Q/r
         IAqusDD08X+RePUadSUpbEdTr/0jh98XO5cj62m6/1bacAkCD08bwbmPz93aNdYOlEMU
         ffTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=c332BukrkRyK/u9Ls0zuwzIT1b5IS90orRxiNkQuaTA=;
        b=UrqoptiD4EJtuEB581V6bcGuL8GknlN9xXyGPQcUv5aPWdyDwNN8BUlJ7WfWABdUh7
         DVFkBVsucit52+5+SAXVw8qI54laSBPJJH+L/ZPi5oihzr6oGujjMJpK4K5vvZUz46RK
         GvwHxXxWevc33EE7O48S8/+cKx6bV8Os3oTZe8SXyyRDA+Y20SIY11ueFL5u/kNVU/Xy
         XXTzweZooCr7LK9PqIBA7yw5jHOmFGWS2CevWw3IzBRlaOawbf46AWGLe8H87qo2aNhm
         c4PpyAW3xFFAt68RMBWWnCrLJ983NrMTL2IGAfeuQqQG2qrzarwqS0+HZhJoaMwUBVUM
         EzOg==
X-Gm-Message-State: APjAAAWSyQdy85jp7S0KeFW6THGGd5jo98A21cujNVbB2qLYiunx4bYr
        51LLUHk68ACdOF57cqitNhqE/A==
X-Google-Smtp-Source: APXvYqzXpJiCFZSyvA+9eoy341816uTzmqD7eFqqOQIkjwRaL91cc8c3KdC3xkBF0vCBFEKJWXciHA==
X-Received: by 2002:a1c:6605:: with SMTP id a5mr4454543wmc.112.1579616917161;
        Tue, 21 Jan 2020 06:28:37 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:281e:d905:c078:226c? ([2a01:e0a:410:bb00:281e:d905:c078:226c])
        by smtp.gmail.com with ESMTPSA id j12sm57001660wrw.54.2020.01.21.06.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 06:28:36 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2] net, ip_tunnel: fix namespaces move
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@nicira.com>,
        William Tu <u9012063@gmail.com>
References: <8f942c9f-206e-fecc-e2ba-8fa0eaa14464@6wind.com>
 <20200121142624.40174-1-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <6dbbe067-8295-7177-7bd9-7d105913003b@6wind.com>
Date:   Tue, 21 Jan 2020 15:28:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200121142624.40174-1-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 21/01/2020 à 15:26, William Dauchy a écrit :
> in the same manner as commit 690afc165bb3 ("net: ip6_gre: fix moving
> ip6gre between namespaces"), fix namespace moving as it was broken since
> commit 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.").
> Indeed, the ip6_gre commit removed the local flag for collect_md
> condition, so there is no reason to keep it for ip_gre/ip_tunnel.
> 
> this patch will fix both ip_tunnel and ip_gre modules.
> 
> Fixes: 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.")
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
