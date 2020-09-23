Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECD1275729
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 13:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgIWLaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 07:30:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26512 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726332AbgIWL35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 07:29:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600860596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=puu3LR6PBVkJbaIlQWrIFXp+CHL9X+avvkTO38uPYuA=;
        b=EZ7OhJZhlTYZg3IoNnQGLg+QOThwXG8zJCD2OItgOuQeTBgH+5Pa/H9OqWI0xSradgO58x
        HAx3IqmyMXrGMrYnqw0CaWf0I3A++ytPdC7/Lr6mo9pKvx4DxnGN0Je+uFQVq3Y3ltZ3g0
        NIx5OKvHl7fMvhf5DrY+tg8eGKWeaTA=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-MsG3hq9APXGA-bvwoim9Dw-1; Wed, 23 Sep 2020 07:29:54 -0400
X-MC-Unique: MsG3hq9APXGA-bvwoim9Dw-1
Received: by mail-oo1-f70.google.com with SMTP id n16so10162489oov.17
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 04:29:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=puu3LR6PBVkJbaIlQWrIFXp+CHL9X+avvkTO38uPYuA=;
        b=ki4r13nZpOS++Q8LFqVTF1uFnLM4kY3FyjNpFkMVjh4d+L7jPScdqbeihp3B5GwxZA
         qzcCT2vP35yewLKzlZs57Ttw0nSCWTiJ92gdgxP9rxH8FjVAMtZpi8mkgdKpEf/guB9q
         Hxzf02b+eDd21d3rSCO3ITDgw6NDHd91vkj8TIUzjWTNVoO3RGbpwYRM0NKRKscv2sw+
         iqQSMBVCkykNXf022x1txOyHfunI+SVLVch75nnjXa6SjEavbLcl624sWVriv5OvtC0l
         i10dDWpLv9bssGcjtaSQlFj3BVkKkgLbxZMmbK05gBDfUQ6Upm61xCAQlxG1I4cIFIMp
         kviQ==
X-Gm-Message-State: AOAM531pbvsdrg8CBq67hBW2Ctjg/RzDmcj5uj1F+xbzxwrNruuOs3yh
        jBeIqpBBPyCEybAxQ4HIsKhkluZ6g1KRzdLN4igyqfjjJ3minyuZ3a7OJK+xZepJRd+fO/2ywRI
        obOF4WEHeKAKd1Rh5xHXfGD23iyYuU5AU
X-Received: by 2002:a9d:3ca:: with SMTP id f68mr5367784otf.330.1600860593957;
        Wed, 23 Sep 2020 04:29:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpHbmO/24vw0t0dO0Z48Fo9ja7x9xin6XTNYYbw55FKRewu8qtDKfTiW2oZqiFX3+OgoxgQGeq71niS4pG3qE=
X-Received: by 2002:a9d:3ca:: with SMTP id f68mr5367775otf.330.1600860593748;
 Wed, 23 Sep 2020 04:29:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200922133731.33478-5-jarod@redhat.com> <20200923041337.GA29158@0b758a8b4a67>
In-Reply-To: <20200923041337.GA29158@0b758a8b4a67>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 23 Sep 2020 07:29:43 -0400
Message-ID: <CAKfmpScApsp7MXRdHS=V3LFVaJTPrhL7qmb4J_EKH=8KVDh-rA@mail.gmail.com>
Subject: Re: [RFC PATCH] bonding: linkdesc can be static
To:     kernel test robot <lkp@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kbuild-all@lists.01.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 12:15 AM kernel test robot <lkp@intel.com> wrote:
>
> Signed-off-by: kernel test robot <lkp@intel.com>
> ---
>  bond_procfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
> index 91ece68607b23..9b1b37a682728 100644
> --- a/drivers/net/bonding/bond_procfs.c
> +++ b/drivers/net/bonding/bond_procfs.c
> @@ -8,7 +8,7 @@
>  #include "bonding_priv.h"
>
>  #ifdef CONFIG_BONDING_LEGACY_INTERFACES
> -const char *linkdesc = "Slave";
> +static const char *linkdesc = "Slave";
>  #else
>  const char *linkdesc = "Link";
>  #endif

Good attempt, robot, but you missed the #else. Will fold a full
version into my set.

-- 
Jarod Wilson
jarod@redhat.com

