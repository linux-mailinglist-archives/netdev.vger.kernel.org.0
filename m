Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA2E1BA1C4
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgD0K5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:57:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40492 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726504AbgD0K5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587985070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZjeHMOInxG/ogA06xMJWXt7aKLPTwY8NVJUcbuqTFBk=;
        b=g1rTF7rZVlM8evaAcNoSFJFv51cp9lMFnFQ8TcsKISOsL6D8ygxwbhoDHB4JhNh2Wr7ZrR
        D7gF0XFlJcDLYTlQkCv0zKJT66tbzkmZ2kjBiXh5OFiIRk5kTjhMVj2WOE78HIRHWX25dK
        CCl5X3DVsY+ruKUWFnS5G3SkCdI5bpQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-N7ULD1wKN2yf72CYCk816Q-1; Mon, 27 Apr 2020 06:57:48 -0400
X-MC-Unique: N7ULD1wKN2yf72CYCk816Q-1
Received: by mail-lj1-f198.google.com with SMTP id e18so1492801ljn.8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:57:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ZjeHMOInxG/ogA06xMJWXt7aKLPTwY8NVJUcbuqTFBk=;
        b=ZxP1WR72rWVgb1lrclRKk1NN5FxFuyM6xbdzl2ybOPVYa0XsLPUcRMppN9n/st2U9C
         zjUfcjp1frVDv2mvcnECx4qWF9L/l2DKW3FFE2SKNbrwWKLESortgpvf9jXEo/CJxQk4
         WF4j9taarKC5ddUfmfFWLloWzddK5wNueychFuc1CU+B4D79IfdJhocNi7yWr6qZqmIb
         HTVHjzMxTgIYE1OdcGqxEmiZ6STlzYdRKfkmrdbXrdliNYoYJqfnuVgXEfuapS6Izmhj
         KFQIrG3wJmdT+7zj+41SHM8jNsBwr44UM6q14uiUfvXxYoJgxJz5PXvg0YwuUrmCdz6U
         yNxg==
X-Gm-Message-State: AGi0PuaINWPV0Tivzcotq2EySiCxQLIuk17Xdrwlp+4rPwHbxxi7v/C3
        ola5WV6l+eaYMXwIrqSAGV8sEKy3ZlF/GaDx2Ql8Zn8KUtnbGjWs5EPg0K33xwr/eZShxSccoDw
        ahTw2V2bBzI/Fx122
X-Received: by 2002:a2e:85da:: with SMTP id h26mr13652974ljj.260.1587985066838;
        Mon, 27 Apr 2020 03:57:46 -0700 (PDT)
X-Google-Smtp-Source: APiQypL+tgHHMLsxzZnr0KU57fAd2vXZc66fVCyQEyoUPxhO/HbY1G2LiN/3JwUdNuezWCcdJJ2oRw==
X-Received: by 2002:a2e:85da:: with SMTP id h26mr13652968ljj.260.1587985066662;
        Mon, 27 Apr 2020 03:57:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q23sm10236673lji.92.2020.04.27.03.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 03:57:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0C9791814FF; Mon, 27 Apr 2020 12:57:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 net] fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks
In-Reply-To: <20200425194025.70351-1-edumazet@google.com>
References: <20200425194025.70351-1-edumazet@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 Apr 2020 12:57:45 +0200
Message-ID: <87lfmhyz4m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> writes:

> My intent was to not let users set a zero drop_batch_size,
> it seems I once again messed with min()/max().
>
> Fixes: 9d18562a2278 ("fq_codel: add batch ability to fq_codel_drop()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

