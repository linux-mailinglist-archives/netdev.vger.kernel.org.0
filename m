Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266481CC406
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 21:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgEITSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 15:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727940AbgEITSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 15:18:01 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5618CC061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 12:18:00 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id w6so4655340ilg.1
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 12:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t/C99Vq1CcRXkyCWT4mDpAKWzCEcXRVxn8g6EagSC8A=;
        b=vWf6J3Y0KnspKV7taIATIXizDrY1FqXhIPAebZg3A2m1on8UZpQVc7qY8p91AkH/gM
         KbmXy9Ru1gj41J9p7PJj7d29NgR3Gp0okC9L8c/IDBHD9jkeoj1bfmO/wccSonH2YMil
         6qucjIURFa6HzkeQZCTm1RWcsBBBuqe8mV+4d3xGQhlPjARMFgHrq5l3KETWbFb1cU4g
         nMQILFCztci6gx79K6dMjKfQ19D6SeV3LojEB5PvTuFgEJaNhDKg5pbES0KWu2udvVyz
         UaVB97muaUHsFRRI7e87R6Gspjx1Fto77lOKV14wkfsC1B5bXzP/Qssv7ZGfS/0KDHiE
         X27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t/C99Vq1CcRXkyCWT4mDpAKWzCEcXRVxn8g6EagSC8A=;
        b=cha5rVmwpZnv8K/s+Uq3Wfh4TYbooaIsT+nQhLufS+rOJ/aWHlY2KRSksyg6i0qfcU
         1jTI04ifE7P1rtLG2VZ0Y8eyqFEGUFTy2oHBJ5rIxp7Xptmo10FW5Gs6Edle11y0ZTmr
         HlXyTPxWmh/Qqx+XjaBErtM9rH+NNFnOqY+2fo+JFsuthyvCjPPBL6ATouoaPbcffeL9
         IxkspDDA2fWk+hA470rEG0utud4O0s9n+Do43n6nPiWdl+udP61wWp/70Y7J28YoI1SI
         +qOrisaR2aFCo3Ql44x8Ba3WQIsLsvGzljztejcdnZ4w+EfqR0iOzhgPkZmTIh+gk5nF
         4YQA==
X-Gm-Message-State: AGi0Pubbty5fJroUggs+U/ws3qAjeP/qabJzX/RlaOzyxWGSjSCp+2Vq
        qVR50kqP9gbXFqHTSsYT3Zm6eU5bD+liOFhM7aF7Bw==
X-Google-Smtp-Source: APiQypJeNYPnqOGZ2OaJWlqe7sydEmQXWAPuquAVZIU2DnWTCEPqf/3IHXSBj3Ba1BxKXuS+MJ8846vTnvcZufL9Y90=
X-Received: by 2002:a92:af44:: with SMTP id n65mr8476774ili.61.1589051879385;
 Sat, 09 May 2020 12:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200508234223.118254-1-zenczykowski@gmail.com> <20200509191536.GA370521@splinter>
In-Reply-To: <20200509191536.GA370521@splinter>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 12:17:47 -0700
Message-ID: <CANP3RGftbDDATFi+4HBSbOFEU-uAddqg2p8+asMMRJtgOJy6mg@mail.gmail.com>
Subject: Re: [PATCH] net-icmp: make icmp{,v6} (ping) sockets available to all
 by default
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Argh.  I've never understood the faintest thing about VRF's.
