Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE84620A61C
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436487AbgFYTtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:49:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28109 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406925AbgFYTtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 15:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593114552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FxRf5mh28ziB7wkqut6ijV6sHC5O4nU/hMiPQ4XJITQ=;
        b=MPCkL3eV/+QwC8v+Tl4ZAPqlI/MRhI+xo3K1gGoUTvSnxtWW2MCSSgFHtKPNiQ7QGw6XnA
        dlwZ4H9W3V4jjvvlpLfqYLY2bff7ArdxLYjTgTG5sj6RgtyEdYh/pNf0iVSteGu/UeoDiQ
        rTfYPViX5nQjzmRISawqcldcjmBLbMQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-KwMSwULeNDGTwOHa5wUiFA-1; Thu, 25 Jun 2020 15:49:10 -0400
X-MC-Unique: KwMSwULeNDGTwOHa5wUiFA-1
Received: by mail-qt1-f197.google.com with SMTP id o11so4762697qti.23
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 12:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FxRf5mh28ziB7wkqut6ijV6sHC5O4nU/hMiPQ4XJITQ=;
        b=HyNBpUE+0PX/2YSWuezJ71EovYO/kv94QsaVDOtLN/svu0xMmj6XhpUq56zSlk7nfM
         zu1NSt/wd+LF7pW2YvdmXG6SpTX6HIiagvRjxjVYyoo5nxYIb1wzltarfHD2npGHoD+D
         iPw33F+049NFetS5OMEutQ8R6C/1oLhJBZx0Sru05zpRLDhf3Y+SVny+SS3cUXORgetU
         4xDb7CPl+GAkFGTWRatB8BNvGXeN+PX1XIUzAUuZJa7W9XlyeZlmZhi9SMjzClJueajA
         4HX6M/b/8wKxkaiBLqZKr8irer0+OaYuqibPOtunNm7JU3u/CnF+hurlVMInKCFsVJEn
         dWlA==
X-Gm-Message-State: AOAM533/1Mdh7DiR88KCNQGsa7uWmU8uAEBQxxgc1EOf8eBIlb23CDqR
        t9ZbJobnpFaUW99xl780eiaVl/SLx8yz1g/vkTIkx6HSUuJ8KFCx6Wulzttmwd4E3t9CGvxWWlX
        7IvBYsyRSY3OZdjpH
X-Received: by 2002:aed:2353:: with SMTP id i19mr2316019qtc.172.1593114549807;
        Thu, 25 Jun 2020 12:49:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUEVm4dNbJEvDXQqKgg/9pY0CXSaPmT4w1klxkckLCZor1fH0Ktgo2eLfFxWbYyDpYrhmEUw==
X-Received: by 2002:aed:2353:: with SMTP id i19mr2316006qtc.172.1593114549637;
        Thu, 25 Jun 2020 12:49:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w45sm7218390qtj.51.2020.06.25.12.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 12:49:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 35E061814F9; Thu, 25 Jun 2020 21:49:06 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Subject: Re: [PATCH net-next 0/5] sched: A series of fixes and optimisations for sch_cake
In-Reply-To: <20200625.123135.515382790882106490.davem@davemloft.net>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk> <20200625.123135.515382790882106490.davem@davemloft.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 25 Jun 2020 21:49:06 +0200
Message-ID: <87mu4rhqod.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Date: Thu, 25 Jun 2020 13:55:02 +0200
>
>> The first three patches in the series are candidates for inclusion into =
stable.
>
> Stable candidates, ie. fixes, should target 'net' not 'net-next'.

Right, sure, can do; I was just being lazy and putting everything in one
series :)

-Toke

