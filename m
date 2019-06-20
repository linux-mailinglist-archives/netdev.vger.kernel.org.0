Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7271F4D035
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 16:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbfFTOTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 10:19:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46857 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfFTOTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 10:19:36 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so3287393qtn.13;
        Thu, 20 Jun 2019 07:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=v880IeJxTwzos0c8VI5a5byiKXKUlY/YMhkF+OvbysA=;
        b=hVSA8KGYTZplvKzqPP+XgtkgrVR7HQpPlLjeB+umbbAyo8DjE2FhxKndBREd/7O54b
         t3n5+YoMGB4u9GAFEpZqqI8ow+QqTSUgTb5ZoECE8fYBfL6L2QBBhZ8k4epu2d2Vy6p/
         FvoAPi0HcQbuyL5DtasNh+fPX11CcMp0WEqYnf2clTz3kt3x99G/+kYbXpuwAEDBEGTB
         1WW1W2quYVCevyglxMRrXVkE1GEgGkJH2SRKkObQJdAEHbYrj5PQ21HoohrmI3JiBagz
         +CqHWjDN4tCNSnW0OtOKqlp1tHaANDgxzESkGdahjXQuvzhtTcpslA2Ir+R9IIvOLHOb
         EkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=v880IeJxTwzos0c8VI5a5byiKXKUlY/YMhkF+OvbysA=;
        b=TBsyZ5uGO74F5IO/M6UlyVfrpPgxYQdQ+n2HxdmEAK8yp2DlZKLZnfsVeD/jKU4/0w
         AlzlUKAl5P6INIaqL/zEpjzKLwGkw1czBFqKeBj4SefrGrSTPjbp9VD2hL9kU5RDBe+f
         BxjypWfdPPbLF7wqFM+OBKJjCfoMdyU5enfGX7JpkhkVkM5JGwwnKHl2nVgMYCOUm/t2
         VFgotvCtvCYu0V9CiPCrKuD6pyLlY1eY5WbjcftOa5N7hXHCzHqm/igMfxDDuVdeSOMJ
         5S3SJCFBuddeKsUTOcfiwchlL/RSE50gj4b4egKGLnIZxIkr7Ed1a80HO5gkv7TvGJvU
         bdzA==
X-Gm-Message-State: APjAAAUJ1ji2vj5RzGYsTvIp7uPq1Q5usypdAvAZLgxm2Hbw4cufxOXi
        6bzAJ0U0uJq44yHl7S5ytOc=
X-Google-Smtp-Source: APXvYqySeXvZcQyPux6KxGiv2O78t2/DWrF6bTnSPbaO6yWc4VKOzej/mdsj4N8YAQ4wG/HgW8LjrQ==
X-Received: by 2002:ac8:2848:: with SMTP id 8mr105556319qtr.216.1561040375360;
        Thu, 20 Jun 2019 07:19:35 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id i48sm12862728qte.93.2019.06.20.07.19.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 07:19:34 -0700 (PDT)
Date:   Thu, 20 Jun 2019 10:19:33 -0400
Message-ID: <20190620101933.GB16083@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: introduce helpers for
 handling chip->reg_lock
In-Reply-To: <20190620135034.24986-1-rasmus.villemoes@prevas.dk>
References: <20190620135034.24986-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:50:42 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> This is a no-op that simply moves all locking and unlocking of
> ->reg_lock into trivial helpers. I did that to be able to easily add
> some ad hoc instrumentation to those helpers to get some information
> on contention and hold times of the mutex. Perhaps others want to do
> something similar at some point, so this frees them from doing the
> 'sed -i' yoga, and have a much smaller 'git diff' while fiddling.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
