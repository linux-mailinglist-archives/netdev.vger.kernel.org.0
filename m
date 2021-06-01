Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918DE39738B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhFAMva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:51:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232965AbhFAMva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 08:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622551788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CUyiBAvHciJIPwfC6jLsz3WeTKnIlzrb9FgnVPrpbok=;
        b=g/G4LEpYzrNVI/lAZRD1ti9tAf4G5tzb2PazPi5hVQf03xofeAIr1stF1sDvbWD2xhEQaT
        /qBhlfIfcKk6EXFexUoQYDBENe+BVQ8o9Y4KARcPgCl7l2liiH8thyArqAb9LEFnrYLKuf
        gYrEjq7Dd4NYwTK6IFEW0A20Bw0lFqk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-TX3mW7gcM2C0qPjjgc-pDQ-1; Tue, 01 Jun 2021 08:49:47 -0400
X-MC-Unique: TX3mW7gcM2C0qPjjgc-pDQ-1
Received: by mail-ed1-f70.google.com with SMTP id f12-20020a056402150cb029038fdcfb6ea2so3610594edw.14
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 05:49:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CUyiBAvHciJIPwfC6jLsz3WeTKnIlzrb9FgnVPrpbok=;
        b=J8evFXf1fOqjTeSTqG+UvH5gYuqs3I6gZoOIShuceIbjOwqrnTLy3Mj2fnMj77rMMI
         YP0hIJC9QCfJouIx8BZifSCTaM1PN1ucP5t3A27UqI1pRRpAAVkBewZd/csMKUdM2iNV
         HsyK52ExQlk9O2S6E+4CuwBQIWNTDCQ+GdQagS3JVySilsIOaolEdANhSMPYiJMchaAu
         3CEAwnIa4FO0uAQgqW0ST1VhMD9jOAAc6kNecJHe1pkrbfJa8UwA/fmKS5ugW0rJxORm
         tc+nrKuw+uFSzebjWCuNYmPNo8bfeWLoCpNS0zzRF8bBxAsy0sVzvvnI2/s48D2pJ05Q
         no0A==
X-Gm-Message-State: AOAM532NcNLAqgVpHQ+Fzq/zlg3YaEVgMJ705hPCtGDHTDMMOeJASfky
        ppzdmrrM+bjFGLD8B7FvqurPtkZCzk6zd+leM+ESSc+7XVesEkmNwGAPTYh5FjyOyWsx/zP0VU8
        TvD7azsdccyy7ij6O
X-Received: by 2002:a17:907:2815:: with SMTP id eb21mr25802257ejc.270.1622551786348;
        Tue, 01 Jun 2021 05:49:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCVG8UsUYvPHd2LaJ7oglB+E6qaIO8fMtgVU+V/dJh44OGRrvzpcRRujTIZ4naHVW3wmzCFw==
X-Received: by 2002:a17:907:2815:: with SMTP id eb21mr25802241ejc.270.1622551786237;
        Tue, 01 Jun 2021 05:49:46 -0700 (PDT)
Received: from localhost (net-188-218-12-178.cust.vodafonedsl.it. [188.218.12.178])
        by smtp.gmail.com with ESMTPSA id p10sm7173537ejc.14.2021.06.01.05.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 05:49:45 -0700 (PDT)
Date:   Tue, 1 Jun 2021 14:49:45 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v4 0/3] net/sched: act_vlan: Fix modify to allow
 0
Message-ID: <YLYs6UYfykZwDwJ8@dcaratti.users.ipa.redhat.com>
References: <20210601123052.3887-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601123052.3887-1-boris.sukholitko@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 03:30:49PM +0300, Boris Sukholitko wrote:
> Currently vlan modification action checks existence of vlan priority by
> comparing it to 0. Therefore it is impossible to modify existing vlan
> tag to have priority 0.

[...]
 
> Change Log:
> v3 -> v4:
> - revert tcf_vlan_get_fill_size change: total size calculation may race vs dump
> 
> v2 -> v3:
> - Push assumes that the priority is being set
> - tcf_vlan_get_fill_size accounts for priority existence
> 
> v1 -> v2:
> - Do not dump unset priority and fix tests accordingly
> - Test for priority 0 modification

Reviewed-by: Davide Caratti <dcaratti@redhat.com>

