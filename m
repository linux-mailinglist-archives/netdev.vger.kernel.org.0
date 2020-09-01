Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61873258B95
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgIAJa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:30:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgIAJa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:30:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598952654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hEI6w8pkhBx0pRn2evfFgE40/baKnW53cmKF71KTuiY=;
        b=Cu67wSTp6lThmRoCzCdyEfrwt8tv9+Ml5e9sRK+di+lJiYsIS/z41AFTc8yo+f0GjTseP6
        PlpPYOoVahD6k9f1STtTF/B5ubxVtIwNRfBMnKic4lZH2nuAxa1fMBIh2/1bcDaur0tVMA
        pgAj20DpqIdhgOIHmXyHfZ2T3aNnif8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-60xnjTdKO2azLSdz7zx1bA-1; Tue, 01 Sep 2020 05:30:53 -0400
X-MC-Unique: 60xnjTdKO2azLSdz7zx1bA-1
Received: by mail-ej1-f72.google.com with SMTP id by23so261140ejb.14
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 02:30:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=hEI6w8pkhBx0pRn2evfFgE40/baKnW53cmKF71KTuiY=;
        b=dAISCIVLFcdmKHwVScrBiPEsttWx5NFoFpgcLMWUqpq/hgSZNAIrP9n/9mTi2H3Hri
         2OjZTncBm+etUYDhluovUGBi9QGwbnDu421v9dix1J9cr1j55YNkRraajGoqc9Vy+QbV
         LJTc4pj4zhzPb6z/F47Y5pxqIuc+UrOhKVx28lBviHVlrqwtb3kn66fbMfPMpRFo4NhO
         m+9xfl8yCNJw4L2omMCUQcbfzkjpdWwkYPthTEsSZIv7qkUZ1sJM92i+1EtufW73HE+S
         th00b7MMYDcGe89zwoWSoYMa0cT/Y7zeh0TpVvAwgiyYrxesb9+i2oKlsJNqdX1DjUEZ
         QeqA==
X-Gm-Message-State: AOAM530YlgR9gHUOHerGRIpLymUDAxDnOvuibmmZXtpAVN1FPyTvp/x2
        BhOHia5EtcvFoVO+Fkrh8AieTMzUsnnillZt8Nz3fkC7k5HpmsXK6NbU5pEsi4G0wDx6ginVpFI
        XvsWhRqETtAivK2zh
X-Received: by 2002:a17:906:2a1a:: with SMTP id j26mr664891eje.456.1598952651897;
        Tue, 01 Sep 2020 02:30:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxi8RpvZMvbljE/lfXOnHgixWg+IZS3T/Azy6rX2jkbDTJ08NmOlGgnQ5zLeRudM/YORCYNaw==
X-Received: by 2002:a17:906:2a1a:: with SMTP id j26mr664879eje.456.1598952651741;
        Tue, 01 Sep 2020 02:30:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 1sm726011ejn.50.2020.09.01.02.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:30:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9CB6C182A41; Tue,  1 Sep 2020 11:30:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        brouer@redhat.com, dsahern@gmail.com
Subject: Re: [PATCH bpf-next v2] bpf: {cpu,dev}map: change various functions
 return type from int to void
In-Reply-To: <20200901083928.6199-1-bjorn.topel@gmail.com>
References: <20200901083928.6199-1-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Sep 2020 11:30:49 +0200
Message-ID: <87blipkfna.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The functions bq_enqueue(), bq_flush_to_queue(), and bq_xmit_all() in
> {cpu,dev}map.c always return zero. Changing the return type from int
> to void makes the code easier to follow.
>
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

