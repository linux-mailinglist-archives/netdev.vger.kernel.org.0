Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B863AC75D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhFRJ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:27:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231602AbhFRJ1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:27:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624008304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OudwFQoX7uDSqebBmwmgmYrBWQI2jkkXu2OD2Vo3jR8=;
        b=OiFMxDNf7TI/7trijrOlQwtVqNKeWI8ASbeAt2VRXVxNYm8rZv+sfpY7/+vQtm7bkQWg3S
        nIIGIhgM5b/5ooIz6En1B+xAmh9vX+GUqn+/FVsjkXrHMFn/x9hfkrns8QylPpIA/LqWFe
        tFboNqDrSuoWJRHys5BZiTBWtphJ3RM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-w6uV0cESPN2DZJpiMSvQdQ-1; Fri, 18 Jun 2021 05:25:03 -0400
X-MC-Unique: w6uV0cESPN2DZJpiMSvQdQ-1
Received: by mail-ej1-f70.google.com with SMTP id f1-20020a1709064941b02903f6b5ef17bfso3634352ejt.20
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 02:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OudwFQoX7uDSqebBmwmgmYrBWQI2jkkXu2OD2Vo3jR8=;
        b=eAIex+kIXlbKe9aAUSOQd2Ypf/sxPz9sFgfPzRUovAsOrGld/AOprlyhUlZ4uG+aqT
         t9840+LTo0Rz3MLmKJ5fC1Ju2QG2KG5N/e/8XXlUwDTbxSps3+eF84w8drBMeDQn8/br
         L0IUdNc52AuDEGv3gDUKXAscRyQ6irayG+02oIi6u0WDSrHdJEfEhP8MlsCDFV0+Dn3x
         7FoAGpInk8auykmsrl7ps9f5/7+78eKp+FMFn6w8jSSt0bGXAr9V6TYt8n+W7X28qu1I
         CN/36C43bpwGhGIrc9YoHgd02x03/JoTHVj4Ho8CUz27LDLHBdzyDdnm0LhnsQ+T++ZC
         iY5w==
X-Gm-Message-State: AOAM5316dU19mvH0KDdGY9aYagM2KWBWj42DRTf6ercm/4VQaTTbmxy9
        NzilKM1SnsM2AJHsPEe0dF26QQ/WTa1od0FZapRA5xNJ8iC98Auxu1rx4Iz+dk93IqYVTbX8WCZ
        4hJLrKD0UFoTRv2lM
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr3628106edt.333.1624008301635;
        Fri, 18 Jun 2021 02:25:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsZWiOMzD7NW/t+XHjTSQG6Lg8SLty3IvGVjI+QDKwqYAXON7EWfmhIVtUI76AvF7BcyzbgA==
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr3628077edt.333.1624008301255;
        Fri, 18 Jun 2021 02:25:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q9sm5975488edv.31.2021.06.18.02.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 02:25:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D73B4180350; Fri, 18 Jun 2021 11:24:58 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Anton Ivanov <anton.ivanov@kot-begemot.co.uk>,
        netdev@vger.kernel.org
Subject: Re: NULL pointer dereference in libbpf
In-Reply-To: <6f6476fb-4b02-e543-6dad-aca3f9b5881c@kot-begemot.co.uk>
References: <6f6476fb-4b02-e543-6dad-aca3f9b5881c@kot-begemot.co.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 18 Jun 2021 11:24:58 +0200
Message-ID: <87a6nnv82d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Anton Ivanov <anton.ivanov@kot-begemot.co.uk> writes:

> https://elixir.bootlin.com/linux/latest/source/tools/lib/bpf/bpf.c#L91
>
> A string is copied to a pointer destination which has been memset to
> zero a few lines above.

No, it isn't. attr.map_name is an array...

-Toke

