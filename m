Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A597308E79
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhA2U0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbhA2UYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:24:15 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C602C061756
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:24:00 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id a31so3589513uae.11
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gB9WXGvfKsP5IIqHPOwDEYYbdK80L0VFLrvf+ytxsCU=;
        b=bWu82ZbDDu7KR0dBMzVLwDxYu8SexlYdrQINPwxI6XM6eASRFDNLyV/mBRvypd9zxy
         GbqGO9Vg6BuEAZUsvuU4R6GOunEc+M+Rno4kCbpqBSxiJBMJR3C1FYH0BxTq8UBYcfP/
         lMBwCau9iyNr+GpGcztUkwOeQVmYpTWduZ6IledyZ2r06DvzRI1rK5DZWTfHKRKFPwzG
         9bd/9I98dLSlqKWf7P8928TilLcuahj0MxC50UOWoJndTKlCP8t4oOE/juQYAQxJDw6N
         IjqAb2ju0MAHZa3y9oJkIpljSvS/ErZSX0D0lNcz+trBi3oDRZSPsLlJdiUoqsd6WELP
         +j8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gB9WXGvfKsP5IIqHPOwDEYYbdK80L0VFLrvf+ytxsCU=;
        b=dYnRuDK1yYoxvZ6ucgBaOqRXMwJo1aR2KwTRcPWR9yJSqpHh6qPOdbrrkWN7CwcxpG
         6DJVPs+j30miItTNs6PDWqNjjR7xVB8jVhvgIj7Fr1/EAJCjC4pXPBh4cwg1NZ22xjtV
         clF9/1s7xejvwrTOQA/OozSCq4jA2AJr94W53KupFxmpBQnNxm/4sAjig/cHjEOZG/Mq
         tVDda1+Y6fG0T/oUZDEoz9QihvbUJEX44jP0qQy8+AYBIsb4Yl8JTwG62i3Ijig6UB4J
         yKetvGnVkMqmMWsUieq2J2QQumuEBjkykhDOsv704eGERt/U0WPyL+IBdIztKmI1mWB7
         2eoQ==
X-Gm-Message-State: AOAM531VLZwPsHi+lxueHCNYm/rgIm4JXPLhiVWSrI0UhTTdH2nT8+cZ
        fQ+t/AznAp4xcdmvaOWbSxncp7zc1bw=
X-Google-Smtp-Source: ABdhPJwE39NZjwaauSkLrF7oSub86jsNAT1aApy6YN5RiSPm6I+rxjq2sa7PxkNratu3oYNT6veeGw==
X-Received: by 2002:ab0:3c91:: with SMTP id a17mr4156664uax.9.1611951838620;
        Fri, 29 Jan 2021 12:23:58 -0800 (PST)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id i1sm1226772vke.30.2021.01.29.12.23.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jan 2021 12:23:57 -0800 (PST)
Received: by mail-ua1-f47.google.com with SMTP id a16so3597502uad.9
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:23:57 -0800 (PST)
X-Received: by 2002:ab0:2a95:: with SMTP id h21mr3979785uar.108.1611951836863;
 Fri, 29 Jan 2021 12:23:56 -0800 (PST)
MIME-Version: 1.0
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com> <20210128213851.2499012-5-anthony.l.nguyen@intel.com>
In-Reply-To: <20210128213851.2499012-5-anthony.l.nguyen@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Jan 2021 15:23:20 -0500
X-Gmail-Original-Message-ID: <CA+FuTScbEK+1NBUNCbHNnwOoSB0JtsEv3wEisYAbm082P+K0Rw@mail.gmail.com>
Message-ID: <CA+FuTScbEK+1NBUNCbHNnwOoSB0JtsEv3wEisYAbm082P+K0Rw@mail.gmail.com>
Subject: Re: [PATCH net 4/4] i40e: Revert "i40e: don't report link up for a VF
 who hasn't enabled queues"
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 4:45 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>
> This reverts commit 2ad1274fa35ace5c6360762ba48d33b63da2396c
>
> VF queues were not brought up when PF was brought up after being
> downed if the VF driver disabled VFs queues during PF down.
> This could happen in some older or external VF driver implementations.
> The problem was that PF driver used vf->queues_enabled as a condition
> to decide what link-state it would send out which caused the issue.
>
> Remove the check for vf->queues_enabled in the VF link notify.
> Now VF will always be notified of the current link status.
> Also remove the queues_enabled member from i40e_vf structure as it is
> not used anymore. Otherwise VNF implementation was broken and caused
> a link flap.
>
> Fixes: 2ad1274fa35a ("i40e: don't report link up for a VF who hasn't enabled")
> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Doesn't this reintroduce the bug that the original patch aimed to solve?

Commit 2ad1274fa35a itself was also a fix.
