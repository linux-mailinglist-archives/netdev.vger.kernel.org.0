Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD99B58A019
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 19:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiHDR7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 13:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiHDR7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 13:59:23 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A5721E0D
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 10:59:22 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p18so515203plr.8
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 10:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BwcQN3pfTZOhr8bApWvnkfZQqF/csSZocbJTgzPkL9o=;
        b=lBQ+8jRiUWo6dWX4UrhHaCTuw8FRuzXD/mYy/oLD38BQbJQ7YQVxS/TcuMvjkFpT9k
         dOzm7x1Xh7p7tN7TZI6wQuUf5dfGlyh+TvQPe6ZQFmW8JHQhWPU3k2OR/L43JdDAF1lv
         IvpMtd03PrP8SO7o79O0g3ARI30aP32+tmL7zHspaUsRo2hIvpXEkS7nnF+ht5Wm031U
         hQNaAHe5IU46WK2bce6CZ4v7HaxmbdYq3dfMAD72Ptw3IOyjPjn5ckLW6YhgbKO6rtaK
         sTexPEjbefKxop8nErU9ch693WTZBG4e4pzOCrsBod/E7I9XIkJbBexKZnOLDA0gly1k
         gRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BwcQN3pfTZOhr8bApWvnkfZQqF/csSZocbJTgzPkL9o=;
        b=7ydI8iZsRKy4CTkbglacs2fi7ZDShBHj0/C+SOHEh7FTc4QNIMSkS1xXGn6JEfcXAb
         vmoV2KEVzxrOLYasdTO5Sx6MCl1b2hMdyAt3T7lh0SEKeIlkIcjaABwNCn9yY91zbfdM
         9Me6nTJAznSmM6KOIcZ4yUoTXbzDRSO7iUxMOeX1qWtFhCfe2ro65NiQotb1V8AyGDQ5
         o/4wTKi2wbWGgDP+q8Z8Q51M2E0idXoIKDTlUjEMR/cfuVdpMs53MgCYhJkVQobTQGSM
         0ubEEV520RACAyvNsv5QwB+jgDnxaf+H7gnDRzAxySZ96oJ9bNswvJ7oK35nQ0JnPmmS
         LQVQ==
X-Gm-Message-State: ACgBeo3Qy2i6hBtaDzndyCK3nee8uUrMnZea7ldpXuu9qdIAL344RyWJ
        zBhd189hymp7MhQZKWFlU1tmiMBONjL97A==
X-Google-Smtp-Source: AA6agR5aVg1el+lIrqG4k3EByxhKA5PVe67mmCm5TXzLwTOSl0+TUNRaX/EQV8kLb7ry5uPB+MyFkg==
X-Received: by 2002:a17:902:e552:b0:16c:571d:fc08 with SMTP id n18-20020a170902e55200b0016c571dfc08mr2911569plf.151.1659635961517;
        Thu, 04 Aug 2022 10:59:21 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id y23-20020a170902b49700b0016bf9437766sm1234810plr.261.2022.08.04.10.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 10:59:21 -0700 (PDT)
Date:   Thu, 4 Aug 2022 10:59:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     James Prestwood <prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
Message-ID: <20220804105917.79aaf6e9@hermes.local>
In-Reply-To: <20220804174307.448527-2-prestwoj@gmail.com>
References: <20220804174307.448527-1-prestwoj@gmail.com>
        <20220804174307.448527-2-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Aug 2022 10:43:07 -0700
James Prestwood <prestwoj@gmail.com> wrote:

> + * @IFF_LIVE_ADDR_CHANGE: device supports hardware address
> + *	change when it's running. Volatile

Since this is a property of the device driver, why is it volatile?

When you make it part of uapi, you also want to restrict userspace
from changing the value via sysfs?

