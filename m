Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DA03E88FF
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 05:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhHKDsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 23:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbhHKDsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 23:48:20 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FA3C061765
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 20:47:56 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a8so1302058pjk.4
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 20:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ihJriyzNh7RpVGgztA38kimYOBRznG2XIWoRCGHPFP4=;
        b=sPlKWskfeZJm6vKBAAShF0RqAs4IUsWOVRPtm4IcS983xUJGBxKDF3f7fFVDdgxS4p
         eM+5E757JNXTd4ojotwdXkroruMZVXbiPhTcKEuOGApbzqPjhNq/R2Xu9dABB6/RwhAJ
         zmNRry6eo08U88QFrilDqLSKbeU3/qKyTBjG5YJxgu86tVzC3ppUU9iKO6af5kCr7WDw
         4FjXTFhB1MPQrMO55/ZqeG284KVFbOA8zfL701ZtF/TPqjCGPw9gfDerGpFlUeR/QXt4
         iojoTw5v9B1QiRCMSa5uStOV6IX5JNYv3MomlYk2gcQsK/ufyOEOLJwch+2iBUJMPH+M
         wkdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ihJriyzNh7RpVGgztA38kimYOBRznG2XIWoRCGHPFP4=;
        b=tyTuh4livobg5fh0sO41PpgSi61rdvK+xozKovmFAoviMAj5gHYPsdJrvC0ns9hPYK
         fpMLsmmfqs33wDEsWACo2x9R5WwtpPKtqkLwgtJbIxXLd0K52icTZvnGkRmfK2ah3xhk
         O6lcdScP681UW3X/9pk4H06xq1rUqVEvaA3KXEc/QkoNqasAQnrkn3ivxrzXccpiL/KY
         4r1LwpPfFTGDhCeoWENOXqbKkXVTtYIfxz7WpbWIGW+jdekboqy5cm5yIDazViULxUUH
         1V95c1001zZL5mqgO08YvxOO6KcITdo2LGnckvc1Y67sSTqFODuXGOC8i/u3IiV/2uIF
         +W3g==
X-Gm-Message-State: AOAM533vI4HYvak7/g1BxDFwd2BcvQwqpa+iLPYU9ogFwrTCd0hoCRh9
        ZNgKqkzqnRSgL/wE8f6PeePmeA==
X-Google-Smtp-Source: ABdhPJzBS+tdox/+EUaPyKk8R7M5IVJ1ZRdbjjLp1EM1Pn57BmFvToSz1+VS2J3amIpRLMtnuQCD8g==
X-Received: by 2002:aa7:9f5b:0:b029:3be:2a1f:ca58 with SMTP id h27-20020aa79f5b0000b02903be2a1fca58mr26303529pfr.46.1628653676138;
        Tue, 10 Aug 2021 20:47:56 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id v14sm4478482pjd.35.2021.08.10.20.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 20:47:55 -0700 (PDT)
Date:   Tue, 10 Aug 2021 20:47:53 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next v2 1/3] Add, show, link, remove IOAM
 namespaces and schemas
Message-ID: <20210810204753.546c151d@hermes.local>
In-Reply-To: <dbec63c4-8d05-b476-f508-b43eac749810@gmail.com>
References: <20210724172108.26524-1-justin.iurman@uliege.be>
        <20210724172108.26524-2-justin.iurman@uliege.be>
        <54514656-7e71-6071-a5b2-d6aa8eed6275@gmail.com>
        <506325411.28069607.1627552295593.JavaMail.zimbra@uliege.be>
        <6c6b379e-cf9e-d6a8-c009-3e1dbbafb257@gmail.com>
        <1693729071.28416702.1627576900833.JavaMail.zimbra@uliege.be>
        <dbec63c4-8d05-b476-f508-b43eac749810@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 08:39:50 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 7/29/21 10:41 AM, Justin Iurman wrote:
> > I see. But, in that case, I'm wondering if it wouldn't be better to directly modify "matches" internally so that we keep consistency between modules without changing everything.
> > 
> > Thoughts?  
> 
> matches() can not be changed.
> 
> iproute_lwtunnel code uses full strcmp. The  new ioam command can start
> off the same way.

Agreed.
Although "ip l s" is cool to impress people it is a maintenance nightmare
as more things get added.
