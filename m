Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05E23959F0
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 13:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhEaL6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 07:58:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231292AbhEaL6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 07:58:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622462231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZT6fgZcKFOOMcFjvD5ihvxXWLQMbqZ98vtTuBTita70=;
        b=SNveE5mImqu612nBuegDe9ANLpcS0ikbHYT4zSHfwoopQCXQHcipudqxulr5amKpd9uSIP
        GkA4qxAbzgSYdF37Z+PGaI0RtwGyDbTCbxiw364bqTTgrcfwwBN/suDDYH1jc0IPqiKlQy
        E8nzlpDl1yBv2edO3UrRHP7lHKpylRE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-Sl3T0zrSOh2iMMWKc_zHXw-1; Mon, 31 May 2021 07:57:09 -0400
X-MC-Unique: Sl3T0zrSOh2iMMWKc_zHXw-1
Received: by mail-wr1-f69.google.com with SMTP id n2-20020adfb7420000b029010e47b59f31so3857540wre.9
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 04:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZT6fgZcKFOOMcFjvD5ihvxXWLQMbqZ98vtTuBTita70=;
        b=ohwu30mx5MfI+X0ZO0T4k9DZu0d90EVDza4Z6eCEjQxBERtyZNH+afxudnePM+NPl7
         /YoZm1VGeGcnEMlIldfHD2psCIzclYCO5o7EwqIyWgLL+ZBqOp+Zp8nAjwp+uUuji8Fn
         cNwaOyuJF8IOgsmT7YBjFk5/+u4Ei1kivmeG5dAusmPA5pH4ACLRIZtJBj+rLjLdg2wS
         U8JQh5Bi7ItvPR5yysgs7Oyu0IOOneqUbsd4a6qA43N22kN/ZlMSX2iyldwWoWXc7xl5
         SygY+rKYKRbv6EF9SzGfzGe6ylI7LQ9XVCVjz1UgmlXT++QYBcMxD+/DhdVcORYPi794
         YmOA==
X-Gm-Message-State: AOAM533d8U0O0dTZYYqkwMsY1F903ztkOBivEfDyKko/rZOpQJMMz5/c
        J47SiFL4Evc4T/uBpPHrCXRQk8Pr6TqX5xlnFeqm/PVYaYWN+KAnPBt+iInS09qRowFsH7JkGDi
        T4boj7NCjw4Qi3pGg
X-Received: by 2002:a5d:4fce:: with SMTP id h14mr9969891wrw.57.1622462228777;
        Mon, 31 May 2021 04:57:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSEh58VwJlBLxXhFjnTSTgxpD7e2IpB3ixQmKLeFGu/3RqcyG0ab9yK3/jUgFwDa97A0A0kg==
X-Received: by 2002:a5d:4fce:: with SMTP id h14mr9969876wrw.57.1622462228607;
        Mon, 31 May 2021 04:57:08 -0700 (PDT)
Received: from localhost (net-188-218-12-178.cust.vodafonedsl.it. [188.218.12.178])
        by smtp.gmail.com with ESMTPSA id l18sm16343013wrt.97.2021.05.31.04.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 04:57:07 -0700 (PDT)
Date:   Mon, 31 May 2021 13:57:07 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 0/3] net/sched: act_vlan: Fix modify to allow
 0
Message-ID: <YLTPEzvYsUmxOIr9@dcaratti.users.ipa.redhat.com>
References: <20210530114052.16483-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210530114052.16483-1-boris.sukholitko@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 30, 2021 at 02:40:49PM +0300, Boris Sukholitko wrote:
> Currently vlan modification action checks existence of vlan priority by
> comparing it to 0. Therefore it is impossible to modify existing vlan
> tag to have priority 0.

hello Boris, thanks for following up!
 
> Change Log:
> v2 -> v3:
> - Push assumes that the priority is being set
> - tcf_vlan_get_fill_size accounts for priority existence

Reviewed-by: Davide Caratti <dcaratti@redhat.com>

