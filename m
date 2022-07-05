Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB74B567388
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiGEPxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiGEPwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:52:50 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC7C205ED
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 08:51:37 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id s1so18162456wra.9
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 08:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jQCcOkpZ7cAXJe+jnFoaim6a5h5A5gzIBAB0Ta3iJpw=;
        b=eIBc/CRf/0p07lJ1qxd+KgrGRW+/zPlZk+oE/PBD8fSY+F40hBxerFzKQmeSFYD1O+
         AGLnfsGnjt66d3h+C2sC/p54+flffgOsjlfjXsloNT6349NQc3fYOSKq2xIJDNnabmMr
         hlc2lfehNVgBXwhJPAUapspH5kohjGgKkD6tMpe79+C3xZpvPN1knZuYxaV+o3f7Ekdl
         t8UCzBJ92F0paB8qN0RUcV2a2tuBIs/uIr+H6IC5+YFUmH7wybqMb/qjOqER0vmlpIvq
         OcdjEW5XElF5RLOjHzM8mEdH1hGZcnAGoqC7TxvLfGcUkM6UmwhUZ0fmDhXUWEgeQuFA
         3xzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jQCcOkpZ7cAXJe+jnFoaim6a5h5A5gzIBAB0Ta3iJpw=;
        b=Np143vrPi+HOLSt0zrcA/cJb4qYrVYkG1T/OXFRvcRLe6CPBHApDVGQAXqoax4hCf6
         E5fwzv8BEuC55baHhDqIbB+jHoz4wA9lG8cebZ1E85C6YamYi76k9qShRH7j1n1OdA9k
         G5uDXbfZJ/Mm3074qh3gWo9pR+phecf6MRfZn3mmIwsO5EWf0mgKoP+ARPVgKW7+9DYZ
         YxHyzsSqKSVfhnH/bP3sOgkGlXtViailB6paNBrS6Dd3+Wu5vCLFWQpvtobkb8Zwb226
         xXgiUlG41LPZ1mA+VHEtx4QfswmQ5p7jitEcxBtXc+EUxqJUt92mkXhHUbb/xLNJ4Ol9
         qD4w==
X-Gm-Message-State: AJIora9DHbqYaON2Sw84m1R9s251KyPU5EKJfoCXv3de8Ogc0SBvba+V
        O7ItiBQIhURPKog6aox6ygsLUtEYmv8=
X-Google-Smtp-Source: AGRyM1uNGz2QRKqFoUzd/OJVbnInIq57PEI8eDUEOYqp0dI3yK9QvmFMIzRw20G+kkEkUm0hqEEo5g==
X-Received: by 2002:a5d:430d:0:b0:210:2ce0:e2a9 with SMTP id h13-20020a5d430d000000b002102ce0e2a9mr32720056wrq.627.1657036295377;
        Tue, 05 Jul 2022 08:51:35 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id k1-20020adff5c1000000b0020d07d90b71sm32705252wrp.66.2022.07.05.08.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:51:35 -0700 (PDT)
Date:   Tue, 5 Jul 2022 17:50:29 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Fix IP_UNICAST_IF option behavior for connected
 sockets
Message-ID: <20220705155016.GA17630@debian>
References: <20220627085219.GA9597@debian>
 <80b97cf6d0591c615a229d754805d989be9183bc.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80b97cf6d0591c615a229d754805d989be9183bc.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 03:08:48PM +0200, Paolo Abeni wrote:
> This also changes a long-established behavior for such socket option.
> It can break existing application assuming connect() is not affected by
> IP_UNICAST_IF. I'm unsure we can accept it.

The IP_UNICAST_IF option was initially introduced for better compatibility
with the matching Windows socket-option. Its goal was better support for
wine applications.
This patch improves the compatibility even further since Windows behaves
this way for connect()ed sockets.

Also, I have not been able to find any examples of Linux applications
that use IP_UNICAST_IF with connect(). It would be quite confusing to use
this sockopt and expect that it would not affect your socket.
I think that unless someone finds an example of such a use case, then it
is better to accept this patch to improve compatibility for applications
that run with wine.

What are your thoughts on this?

Regards,
Richard
