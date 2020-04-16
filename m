Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632F81ABBAB
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 10:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502849AbgDPIsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 04:48:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55180 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502900AbgDPIrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:47:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587026866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hLv2V74/okom8XQM5VUYo1cHtVIDyGEJ24uk+rS0wmg=;
        b=SLV9UV7CkFGewlY0P/9iMAEOE9PcQSaWeFwzm6QPKlw5IBiSKWch1sAmFOmk2xyX+Pnqu7
        yeY/liXk14ae9PLMLpOrJUWS3LhgdbPPjmyWi9rfCNxteg1gupDm9eihI2mcyniDNeXCUV
        fa89fP1h1StO/P8YwPyWNKa/k8ciFWk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-02PSLOA9OTmytz8bmfPaRQ-1; Thu, 16 Apr 2020 04:47:45 -0400
X-MC-Unique: 02PSLOA9OTmytz8bmfPaRQ-1
Received: by mail-lj1-f200.google.com with SMTP id j15so1097544lja.14
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 01:47:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=hLv2V74/okom8XQM5VUYo1cHtVIDyGEJ24uk+rS0wmg=;
        b=X20IujvT6PskU+eGm6F0ugy9Puf9dDDQnxwcQxJ6Ls5lG7VwDLCfaYOKXVIFk5hIBe
         llW3WKWE/u4G8fUbRH989HUA05ReWmNTYZSs7lilQO3KVsKufBsZEOsng+xiL9zcU63X
         S/3IIajeEQcae5sixOoKcKlc5LLpUy+nvh99zXRjyZroEYcCsK+B2T9G9z0ie6WWraoS
         PkObcVOWf34zWCvSTC7vY7UiIc1zn7TJ/Sr1mGDzIvroxmoJe9MPp3BHpiZ0Gg9vVnb4
         E8XcgM13KZ9rN5hhnLS57U+d3wxPP4EY3QrufwksOOHn0ByxlyOfosqNz7e2buWfC4Zx
         8yvg==
X-Gm-Message-State: AGi0PuZLRtX8ZaoXqdRAIPn221SFQ3K8wCk0UrlYXF4/UIvOxBlsJ10m
        A14l8AmCFIQFuwkhRpY9zN0YFmZdmTd7J2gsaMYHdJzLiE/tUMScdu4ZFq1ePXk1z98PZK2nORy
        f8akbXxx6dU3DNWAI
X-Received: by 2002:a2e:9c9a:: with SMTP id x26mr1506253lji.44.1587026863244;
        Thu, 16 Apr 2020 01:47:43 -0700 (PDT)
X-Google-Smtp-Source: APiQypI3dmIA2vUqeS7zRaeBy3Ztj2J2Yxxod5xsabISu1sBrS5O0an3v23WjQquhF+ZwkxFxnqIvg==
X-Received: by 2002:a2e:9c9a:: with SMTP id x26mr1506231lji.44.1587026862891;
        Thu, 16 Apr 2020 01:47:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i3sm983120ljg.82.2020.04.16.01.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 01:47:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4B9C9181586; Thu, 16 Apr 2020 10:47:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Odin Ugedal <odin@ugedal.com>, netdev@vger.kernel.org
Cc:     Odin Ugedal <odin@ugedal.com>
Subject: Re: [PATCH 1/3] q_cake: Make fwmark uint instead of int
In-Reply-To: <20200415143936.18924-2-odin@ugedal.com>
References: <20200415143936.18924-1-odin@ugedal.com> <20200415143936.18924-2-odin@ugedal.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Apr 2020 10:47:39 +0200
Message-ID: <87d087n7f8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Odin Ugedal <odin@ugedal.com> writes:

> This will help avoid overflow, since setting it to 0xffffffff would
> result in -1 when converted to integer, resulting in being "-1", setting
> the fwmark to 0x00.
>
> Signed-off-by: Odin Ugedal <odin@ugedal.com>

Thanks!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

