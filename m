Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB74619D7C1
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390886AbgDCNiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:38:21 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45901 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390770AbgDCNiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:38:20 -0400
Received: by mail-qk1-f194.google.com with SMTP id o18so5083560qko.12;
        Fri, 03 Apr 2020 06:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kYnZHxpPGf7DaV2eyxdpVvKIQEJ0x8tV886Kl8XWxiA=;
        b=lrvUKqCgKFfiT00Eui7HGLx0wjeLy4R+GU/a2axO0G1VoL90GmeCpeKV+aGHLYBEnZ
         Syo4J2xHK1ckt26K8Que5Cq5POPiP25pcS5yM288zGSG276nU6nYUzm2EeIvBiOuKOY+
         kC7UxBeXCyDyXAphAhamhn7xgvNCl7p2hRM+6qW/7yBTAYHa5bo0Tq6QxyBV/r5JlDuC
         oo6iYqhiBeYusnpK1SIZlI2/wY/VVZd0rbIiicvHfb+c5zlvTS0v+80b4lNJlfkDAW87
         OvCHrn5h667rPGJbAE341oPeh/RbdJyEucU77d6z8wCc0T65DVrQyfRDcnPHpcDDmciV
         nmyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=kYnZHxpPGf7DaV2eyxdpVvKIQEJ0x8tV886Kl8XWxiA=;
        b=MmmKhfilCkFvDD8Txx6ISyw2w1kJqKnFffMysh+bxKgzBV3gH0kOwgI8C4FtoWuV4G
         FU7Dl+pyMy00W+5cC96oEKz9lozjSJFuOUbLfpYxFvQKYEK/J4A5KsVClpklyZSz1Qoz
         fjtP9Z38nISfIV2xjaLaJ7Ho0bZD5nRC5/lnM+v/InV+tuQuFZv82f2rOsZBgPr3uwmy
         kWSW4w/NBA+raGPVi/+GdyReUCQrieEzOUWtJSiitmYj+2NP8n6+XGxCTbbDImWoEbOq
         Mqa2UlisCZd3MRsVC1LHaii6Hq5jSYWpS8OJ9pWp9tQcsfdpKw3CDySyBjngkEIspjvj
         7zuA==
X-Gm-Message-State: AGi0PubYo3Ngt1emZAWGLPMgjCEsKoysX57G6lF5Q5uXeoimgBVTDLaz
        KrlD4iLDggWv53IC5W5l4kc=
X-Google-Smtp-Source: APiQypL44cxfmuewwrpxwwbvpIKuvjPSzJvqGxjLEG8Ah2ndG4epcsnqs6WSVWBPiTG9XRxcx7UEZA==
X-Received: by 2002:a37:27cd:: with SMTP id n196mr9029422qkn.144.1585921099300;
        Fri, 03 Apr 2020 06:38:19 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::842b])
        by smtp.gmail.com with ESMTPSA id x6sm6182557qke.43.2020.04.03.06.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 06:38:18 -0700 (PDT)
Date:   Fri, 3 Apr 2020 09:38:17 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        khlebnikov@yandex-team.ru, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
Message-ID: <20200403133817.GW162390@mtj.duckdns.org>
References: <20200403095627.GA85072@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403095627.GA85072@yandex-team.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 12:56:27PM +0300, Dmitry Yakunin wrote:
> This patch adds cgroup v2 ID to common inet diag message attributes.
> Cgroup v2 ID is kernfs ID (ino or ino+gen). This attribute allows filter
> inet diag output by cgroup ID obtained by name_to_handle_at() syscall.
> When net_cls or net_prio cgroup is activated this ID is equal to 1 (root
> cgroup ID) for newly created sockets.
> 
> Some notes about this ID:
> 
> 1) gets initialized in socket() syscall
> 2) incoming socket gets ID from listening socket
>    (not during accept() syscall)

How would this work with things like inetd? Would it make sense to associate the
socket on the first actual send/recv?

Thanks.

-- 
tejun
