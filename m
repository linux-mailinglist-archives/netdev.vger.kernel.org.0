Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9852B25E9
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgKMUxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgKMUxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:53:01 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1E7C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:53:01 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id t18so5131991plo.0
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=2xo53I7wrlzl3NE1YFvqqeiEzEfmvW1Nm6ThC/jjPYs=;
        b=Bp9CZFREG21PVXgPvDddIBYk1DeU1mFcbc1C4BPgTLX3G0b0SXl3iq08qm5XaxECTX
         Gj3cspBLWS1hxbU250WRSOvNEuqWlG8CCmPqhCVZyVj+uu8WmbdNtEQeT5JpSsfiXBY9
         ii//Nx62uUORf46tZ4KRuqFWO1MDpgZq+gtRS5vcuve78QtpQZ1cMxg0EGEHRZK1smyI
         g642QBB1F5QTYsCyU1ja4vMG5QkKyLeNv2A6k0XkAorGZMlSR+X8inWicQ/9hNYXnsVL
         0fDLKC0zPwmBHZdF9Ru3CMZxcmmj+wWIBSYrDz2g/BEYsoKS9o6VZcP4BqsoMuRIOmZ9
         SN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=2xo53I7wrlzl3NE1YFvqqeiEzEfmvW1Nm6ThC/jjPYs=;
        b=OYMtB2ku+WTTepBGAJKGGE1R4tQTDXKaX2ihUv6egRyMxorUQY0v2cS+DYFKR57lSZ
         wBDP+7AgFaaoNxAb0HqfGu3casomqsHYw+zrptjFJYHH4P6UNs4exsrhwaTdx0m7/MqS
         GMzo1n0QovsAkyvirZeOdKv3JZZ4JHxmoTbaRrFxSOL9mZxPMJ0dbC7MYvOBPWja3Znr
         2EnA21Y036Rt8AHjvkgz/26HQkKRbZVKA+TnGfp06Oupp9/eewNjwBDmo3dyM58dFe0j
         YEbU7dtnlAY91X+VT/1nnHc5aeZBs6aJINDqf+xNNWJnxjMqXYiAGZ95ejtYn4pXhzNh
         lFQg==
X-Gm-Message-State: AOAM533N0AxiclBX4RMuq6ugnO+D9M4d1wWoLVuaJFODM4B0nSTKKoKI
        zsLqTrDOFmKORhbOb7iHgdhwDld3agkJHUUj
X-Google-Smtp-Source: ABdhPJxgVOm1bVW4104/tbEGaYkN0iFU6ZOEM3Kq3ScB+VMON4lzKTOUTUhZ/5FOz3RSXNIRNt3oog==
X-Received: by 2002:a17:902:70cc:b029:d7:e8ad:26d4 with SMTP id l12-20020a17090270ccb02900d7e8ad26d4mr3674711plt.33.1605300781256;
        Fri, 13 Nov 2020 12:53:01 -0800 (PST)
Received: from ?IPv6:2601:648:8400:9ef4:34d:9355:e74:4f1b? ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.gmail.com with ESMTPSA id t9sm13519986pje.1.2020.11.13.12.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 12:53:00 -0800 (PST)
Message-ID: <368dca70e518a9576a80fbd629ea7dc3583cc597.camel@gmail.com>
Subject: Re: [PATCH 0/3] Add support for sending RFC8335 PROBE messages
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Date:   Fri, 13 Nov 2020 12:53:00 -0800
In-Reply-To: <20201113073230.3ecd6f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1605238003.git.andreas.a.roeseler@gmail.com>
         <20201113073230.3ecd6f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-13 at 07:32 -0800, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 21:02:27 -0800 Andreas Roeseler wrote:
> > The popular utility ping has several severe limitations such as
> > an inability to query specific interfaces on a node and requiring
> > bidirectional connectivity between the probing and the probed
> > interfaces. RFC 8335 attempts to solve these limitations by
> > creating the
> > new utility PROBE which is an ICMP message that makes use of the
> > ICMP
> > Extension Structure outlined in RFC 4884.
> > 
> > This patchset adds define statments for the probe ICMP message
> > request
> > and reply types for both IPv4 and IPv6. It also expands the list of
> > supported ICMP messages to accommodate probe messages.
> 
> Did you mean to CC netdev?

Thank you for catching that. I'm new to kernel development and I'm still
trying to get my bearings.

