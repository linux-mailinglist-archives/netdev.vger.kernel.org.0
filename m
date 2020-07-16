Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B249222894
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgGPQwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgGPQwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 12:52:06 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70940C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:52:06 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s10so7742926wrw.12
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f2qUng5HF9NW+OotedZU8QElatY7609gFS7Ok3Iu3Lo=;
        b=PLUrTwNEGjZAxVnDXucir6yf3HPZyS7Re2k/EUqQy48zljWN2k1Jbqi4C4TMvV4x32
         nAzQVwF5k5V4YL8SsoeJ3kPPDyplut/uX7GU/tI3acjmFn4lXAYE5zKV2oJWUVn7c4EN
         AauG7HORNSsn2ohVwS/hLs5cbj2/JeKcrLNY2thaDQ2KKSjNOF+ARdwEQgbVfy1ZoPe3
         j2kPSVyVAbWMBLV8R6vkXE9cF0kKpJCGh4nOAFr//n+akjlkIEH1axkj3+wBBVyD4XZw
         MBIUXOjBw9uggGkFPbkurTml1KzHMVJ5ohhCkYenqzLFMJR97WWglXrzIGFqPxQy+haq
         KDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f2qUng5HF9NW+OotedZU8QElatY7609gFS7Ok3Iu3Lo=;
        b=AiEbocjN1dEkgX6Pjnx5RRfwqcU/NxImrloguyJK5Xym6eJhTVmImjvG16k3ddImIP
         8vUNnyaWb7Tr3r7v+M29A8IdefEdiB/bUpqjJUcRqiymHKa2h1Iq7TTKWDtJY65B+TVL
         kpZh3r8n0k1/rtYji6hA6J4q/txMDBiNT84I+JQ+TkfV7HJB3FzmC0NjkA27C4ItpE20
         A9ix147o2nI2IFZdH3x+kjVglq1kMmuUyQHESjzh+/UFjpnXH0srRtcu//XU7RzIDMVM
         rKLUUS6M3Y3i51C5gS/K8KETBgVqr1/4+RouFZjZoDaBHEU8h9BgcEbwqJLVfQ1rheSH
         zjWw==
X-Gm-Message-State: AOAM532CxTUf/QJqFcQyfMjvG/v2cdmPDWF1XIZS2USx8nOND6Q47D8q
        9GOCXM4mbSOiPHh8mKrQnxTZew==
X-Google-Smtp-Source: ABdhPJw+i+SrqYv9HrIY5Uu1HeTMSKZ1aEdQrD5nvBBoSUT/DunETqxnGtcYK2x+MFy2C9DMIaoJxQ==
X-Received: by 2002:adf:f984:: with SMTP id f4mr5818808wrr.221.1594918325247;
        Thu, 16 Jul 2020 09:52:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s10sm9737503wme.31.2020.07.16.09.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 09:52:04 -0700 (PDT)
Date:   Thu, 16 Jul 2020 18:52:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 2/2] tc: q_red: Implement has_block for
 RED
Message-ID: <20200716165203.GD23663@nanopsycho.orion>
References: <cover.1594914405.git.petrm@mellanox.com>
 <18f80c432a0d278d32711bdafdd9d2376028ad50.1594914405.git.petrm@mellanox.com>
 <20200716160729.GC23663@nanopsycho.orion>
 <87mu3zifgd.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mu3zifgd.fsf@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 16, 2020 at 06:37:22PM CEST, petrm@mellanox.com wrote:
>
>Jiri Pirko <jiri@resnulli.us> writes:
>
>> Thu, Jul 16, 2020 at 05:49:46PM CEST, petrm@mellanox.com wrote:
>>>In order for "tc filter show block X" to find a given block, implement the
>>>has_block callback.
>>>
>>>Signed-off-by: Petr Machata <petrm@mellanox.com>
>>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>
>Actually it's broken. When there are several qdiscs, the latter one's
>result overwrites the previous one.

:/
