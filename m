Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A993FD4CC
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 09:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242790AbhIAIAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 04:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230161AbhIAIAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 04:00:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630483154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iyKrp7I82f3wYzsbQR/1Jeu1cFgJoa6hSbBVeuarAhw=;
        b=SVu3Ie7M7qe03EblygVArvpDQoYY1Nlm4MtpL7bRifjFZ3Vj6D5VeCSiez28rUVnVk56ez
        yI5ZdaqGRZtgyovOLitsbUyOo5r540Cr/wEoYGcfKw16gquTJZB2NqXI0Rjhk064d6pyJy
        ScDI4qBIMNjUOzgoJekNf+iEvjr1tBk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-QeSx9WsbMMGS8Mk5SDfeVQ-1; Wed, 01 Sep 2021 03:59:13 -0400
X-MC-Unique: QeSx9WsbMMGS8Mk5SDfeVQ-1
Received: by mail-wr1-f70.google.com with SMTP id d10-20020adffbca000000b00157bc86d94eso490749wrs.20
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 00:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=iyKrp7I82f3wYzsbQR/1Jeu1cFgJoa6hSbBVeuarAhw=;
        b=eFQotQjAYBAcp2LMr4AMeIMY+nu/sggdKL++ZP0oHb49fK50immoYboCxQZ4NpsGKl
         Xk9hSCNE92b0S3I/bsiAtn1S/laKmO05ANHH2LDhR/xSAn4Z+xe1BEWQTtaEf6599HHx
         8hnK62jsnkjN3ICuF5NLJ8gryumseCKTJOfhmHZBObrZJTP1JoJocZNO+5k+kP05qdgU
         O/GfLHhRJEenKYV4l9OhVA3OEOQskgXaPK1rKq6vD/Aj4Uy+d/R9DVmn7UfUgs3YvhQX
         k/YJumGfS9oEai0/WC33lWkDrVO2feTQbdy5BoxQ2RezT5oSppNQWUIuzzcq5H2G4tKf
         S9pw==
X-Gm-Message-State: AOAM530As8uP5WV6SSqZpSHwJhK/siGT+L12mvqH6vdTG21BFqes8EHC
        b4CFKThYC7YDpAAhoPMe2vzM/ReXyVu+rfejJln1qs4pDGCIuIG7bPzWU4OhQqJJIWifwriCMyj
        hTkWnPfEmbMuwOwYp
X-Received: by 2002:adf:b318:: with SMTP id j24mr35920239wrd.84.1630483152538;
        Wed, 01 Sep 2021 00:59:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6qSKRkrppsPrE7xFz0DPwkHom7QW17kdpSLZeZaFEbxoQd+jkS4db/+oYTilJq6NO0oKDdw==
X-Received: by 2002:adf:b318:: with SMTP id j24mr35920224wrd.84.1630483152355;
        Wed, 01 Sep 2021 00:59:12 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-233-185.dyn.eolo.it. [146.241.233.185])
        by smtp.gmail.com with ESMTPSA id o23sm8974034wro.76.2021.09.01.00.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 00:59:12 -0700 (PDT)
Message-ID: <d49518ac90b2442fc293fd333d0315b1cff00671.camel@redhat.com>
Subject: Re: [PATCH] [v3] mptcp: Fix duplicated argument in protocol.h
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wan Jiabing <wanjiabing@vivo.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
Date:   Wed, 01 Sep 2021 09:59:10 +0200
In-Reply-To: <20210901031932.7734-1-wanjiabing@vivo.com>
References: <20210901031932.7734-1-wanjiabing@vivo.com>
Content-Type: text/plain
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo=


